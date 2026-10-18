import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import pool from './src/database/config.js'

const app = express()
const port = Number(process.env.PORT || 3001)
const jwtSecret = process.env.JWT_SECRET || 'dev-secret-change-me'


// Configure CORS: allow configured FRONTEND_URL and common local dev origins (5173/5174)
const allowedFrontend = [
  process.env.FRONTEND_URL,
  'http://localhost:5173',
  'http://localhost:5174',
  'http://127.0.0.1:5173',
  'http://127.0.0.1:5174',
].filter(Boolean)

app.use(cors({
  origin: (origin, callback) => {
    // allow non-browser tools (curl, server-to-server) which send no origin
    if (!origin) return callback(null, true)
    if (allowedFrontend.includes(origin)) return callback(null, true)
    // For development convenience, also allow any localhost origin if FRONTEND_URL not explicitly set
    if (!process.env.FRONTEND_URL && /^(https?:)?\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin)) return callback(null, true)
    return callback(new Error('CORS origin denied'))
  }
}))
app.use(express.json())
app.use((request, response, next) => {
  const startedAt = Date.now()
  response.on('finish', () => {
    console.log(`${request.method} ${request.originalUrl} -> ${response.statusCode} (${Date.now() - startedAt}ms)`)
  })
  next()
})

const asyncRoute = (handler) => (request, response, next) => {
  Promise.resolve(handler(request, response, next)).catch(next)
}

const wait = (milliseconds) => new Promise((resolve) => setTimeout(resolve, milliseconds))

let databaseReady = false

const waitForDatabase = async () => {
  let attempt = 0

  while (true) {
    try {
      await pool.query('SELECT 1')
      databaseReady = true
      if (attempt > 0) {
        console.log('Conexao com MySQL estabelecida.')
      }
      return
    } catch (error) {
      attempt += 1
      console.log(`Aguardando MySQL (tentativa ${attempt})...`)
      console.error(error.message)
      await wait(5000)
    }
  }
}

const startDatabaseWatch = () => {
  waitForDatabase().catch((error) => {
    console.error('Falha ao monitorar MySQL.')
    console.error(error)
  })
}

const nextId = async (client, table) => {
  const [rows] = await client.query(`SELECT COALESCE(MAX(ID), 0) + 1 AS id FROM ${table}`)
  return rows[0].id
}

const normalizeFuncionario = (row) => row && ({
  id: row.id ?? row.ID,
  nome: row.nome ?? row.NOME,
  email: row.email ?? row.EMAIL,
  senha: row.senha ?? row.SENHA,
  departamento: row.departamento ?? row.DEPARTAMENTO,
  cargo: row.cargo ?? row.CARGO,
  tipo_perfil: row.tipo_perfil ?? row.TIPO_PERFIL ?? null,
  gestor: row.gestor ?? row.GESTOR ?? false,
  managerId: row.fk_gestor_id ?? row.FK_GESTOR_ID ?? null,
  data_criacao: row.data_criacao ?? row.DATA_CRIACAO,
  // convenience fields
  profileType: (row.tipo_perfil ?? row.TIPO_PERFIL) || (row.gestor || row.GESTOR ? 'gestor' : 'recurso'),
  isAdmin: ((row.tipo_perfil ?? row.TIPO_PERFIL) === 'admin') || false,
  isManager: (row.gestor ?? row.GESTOR) === 1 || (row.gestor ?? row.GESTOR) === true,
})

const publicUser = (user) => ({
  id: user.id,
  name: user.nome,
  email: user.email,
  department: user.departamento,
  role: user.cargo,
  isManager: user.gestor,
  profileType: user.gestor ? 'admin' : 'recurso',
  createdAt: user.data_criacao,
})

const authenticate = asyncRoute(async (request, response, next) => {
  const authorization = request.headers.authorization
  if (!authorization?.startsWith('Bearer ')) {
    return response.status(401).json({ error: 'Token de autenticação não informado.' })
  }

    try {
      const payload = jwt.verify(authorization.slice(7), jwtSecret)
      const [rows] = await pool.query('SELECT * FROM FUNCIONARIO WHERE ID = ?', [payload.userId])
      if (!rows.length) {
        return response.status(401).json({ error: 'Usuário não encontrado.' })
      }
    request.user = normalizeFuncionario(rows[0])
    next()
  } catch {
    return response.status(401).json({ error: 'Token inválido ou expirado.' })
  }
})

// Authorization middleware: roles = array of allowed profileType strings (e.g. ['admin','gestor'])
const authorize = (roles) => (request, response, next) => {
  if (!request.user) return response.status(401).json({ error: 'Token de autenticação não informado.' })
  const userRole = request.user.profileType || (request.user.isManager ? 'gestor' : 'recurso')
  if (!roles.includes(userRole)) return response.status(403).json({ error: 'Acesso negado.' })
  next()
}

app.get('/api/health', asyncRoute(async (_request, response) => {
  response.json({ status: 'ok', database: databaseReady ? 'ready' : 'starting' })
}))

app.get('/api/health/db', asyncRoute(async (_request, response) => {
  await pool.query('SELECT 1')
  response.json({ status: 'ok', database: 'connected' })
}))

app.post('/api/auth/register', asyncRoute(async (request, response) => {
  const {
    name,
    email,
    password,
    department = 'Não informado',
    role = 'Colaborador',
    age = 18,
    managerId = null,
  } = request.body

  if (!name || !email || !password) {
    return response.status(400).json({ error: 'name, email e password são obrigatórios.' })
  }
  if (password.length < 6) {
    return response.status(400).json({ error: 'A senha deve ter no mínimo 6 caracteres.' })
  }

  const client = await pool.getConnection()
  try {
    const [existing] = await client.query('SELECT 1 FROM FUNCIONARIO WHERE LOWER(EMAIL) = LOWER(?)', [email.trim()])
    if (existing.length) {
      return response.status(409).json({ error: 'Já existe um funcionário com este e-mail.' })
    }

    const id = await nextId(client, 'FUNCIONARIO')
    const passwordHash = await bcrypt.hash(password, 12)
    await client.query(
      `INSERT INTO FUNCIONARIO (ID, NOME, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, FK_GESTOR_ID)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, name.trim(), Number(age), email.trim().toLowerCase(), passwordHash, department, role, managerId],
    )

    const [userRows] = await client.query('SELECT * FROM FUNCIONARIO WHERE ID = ?', [id])
    const user = normalizeFuncionario(userRows[0])
    const token = jwt.sign({ userId: user.id }, jwtSecret, { expiresIn: '8h' })
    response.status(201).json({ token, user: publicUser(user) })
  } finally {
    client.release()
  }
}))

app.post('/api/auth/login', asyncRoute(async (request, response) => {
  const { email, password } = request.body
  if (!email || !password) {
    return response.status(400).json({ error: 'email e password são obrigatórios.' })
  }

  const [rows] = await pool.query('SELECT * FROM FUNCIONARIO WHERE LOWER(EMAIL) = LOWER(?)', [email.trim()])
  const user = normalizeFuncionario(rows[0])
  if (!user || !(await bcrypt.compare(password, user.senha))) {
    return response.status(401).json({ error: 'E-mail ou senha inválidos.' })
  }

  const token = jwt.sign({ userId: user.id }, jwtSecret, { expiresIn: '8h' })
  response.json({ token, user: publicUser(user) })
}))

app.get('/api/auth/me', authenticate, (request, response) => {
  response.json({ user: publicUser(request.user) })
})

app.get('/api/funcionarios', authenticate, asyncRoute(async (_request, response) => {
  const [rows] = await pool.query(
    `SELECT ID AS id,
            NOME AS name,
            MATRICULA AS matricula,
            IDADE AS age,
            EMAIL AS email,
            SENHA AS senha,
            DEPARTAMENTO AS department,
            CARGO AS role,
            TIPO_PERFIL AS profileType,
            GESTOR AS isManager,
            FK_GESTOR_ID AS managerId,
            ATIVO AS active,
            DATA_CRIACAO AS data_criacao,
            DATA_ATUALIZACAO AS data_atualizacao
     FROM FUNCIONARIO
     ORDER BY NOME`,
  )
  response.json(rows)
}))

app.get('/api/funcionarios/:id', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT ID AS id, NOME AS name, MATRICULA, IDADE, EMAIL, DEPARTAMENTO AS department, CARGO AS role, TIPO_PERFIL AS profileType, GESTOR AS isManager, ATIVO FROM FUNCIONARIO WHERE ID = ?', [request.params.id])
  if (!rows.length) return response.status(404).json({ error: 'Funcionário não encontrado.' })
  response.json({ data: rows[0] })
}))

app.post('/api/funcionarios', authenticate, asyncRoute(async (request, response) => {
  const { nome, matricula = null, idade = null, email, senha = null, departamento = null, cargo = null, tipo_perfil = 'recurso', fk_gestor_id = null } = request.body
  if (!nome || !email) return response.status(400).json({ error: 'nome e email são obrigatórios.' })
  const client = await pool.getConnection()
  try {
    const [existing] = await client.query('SELECT 1 FROM FUNCIONARIO WHERE LOWER(EMAIL) = LOWER(?)', [email.trim()])
    if (existing.length) return response.status(409).json({ error: 'Já existe um funcionário com este e-mail.' })
    const id = await nextId(client, 'FUNCIONARIO')
    // If senha provided, hash it; otherwise NULL
    let senhaHash = null
    if (senha) {
      senhaHash = await bcrypt.hash(senha, 12)
    }
    await client.query('INSERT INTO FUNCIONARIO (ID, NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, FK_GESTOR_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [id, nome.trim(), matricula, idade, email.trim().toLowerCase(), senhaHash, departamento, cargo, tipo_perfil, fk_gestor_id])
    const [rows] = await client.query('SELECT ID AS id, NOME AS name, EMAIL, DEPARTAMENTO AS department, CARGO AS role, TIPO_PERFIL AS profileType, GESTOR AS isManager FROM FUNCIONARIO WHERE ID = ?', [id])
    response.status(201).json({ data: rows[0] })
  } finally { client.release() }
}))

app.patch('/api/funcionarios/:id', authenticate, asyncRoute(async (request, response) => {
  const { nome, matricula, idade, email, senha, departamento, cargo, tipo_perfil, fk_gestor_id, ativo } = request.body
  const client = await pool.getConnection()
  try {
    const [existing] = await client.query('SELECT * FROM FUNCIONARIO WHERE ID = ?', [request.params.id])
    if (!existing.length) return response.status(404).json({ error: 'Funcionário não encontrado.' })
    let senhaHash = null
    if (senha) senhaHash = await bcrypt.hash(senha, 12)
    await client.query('UPDATE FUNCIONARIO SET NOME = COALESCE(?, NOME), MATRICULA = COALESCE(?, MATRICULA), IDADE = COALESCE(?, IDADE), EMAIL = COALESCE(?, EMAIL), SENHA = COALESCE(?, SENHA), DEPARTAMENTO = COALESCE(?, DEPARTAMENTO), CARGO = COALESCE(?, CARGO), TIPO_PERFIL = COALESCE(?, TIPO_PERFIL), FK_GESTOR_ID = COALESCE(?, FK_GESTOR_ID), ATIVO = COALESCE(?, ATIVO) WHERE ID = ?', [nome, matricula, idade, email, senhaHash, departamento, cargo, tipo_perfil, fk_gestor_id, ativo, request.params.id])
    const [rows] = await client.query('SELECT ID AS id, NOME AS name, EMAIL, DEPARTAMENTO AS department, CARGO AS role, TIPO_PERFIL AS profileType, GESTOR AS isManager, ATIVO FROM FUNCIONARIO WHERE ID = ?', [request.params.id])
    response.json({ data: rows[0] })
  } finally { client.release() }
}))

app.delete('/api/funcionarios/:id', authenticate, asyncRoute(async (request, response) => {
  // soft delete
  await pool.query('UPDATE FUNCIONARIO SET ATIVO = 0 WHERE ID = ?', [request.params.id])
  response.status(204).send()
}))

// Disponibilidade de funcionário (percentual disponível)
app.get('/api/funcionarios/:id/disponibilidade', authenticate, asyncRoute(async (request, response) => {
  const { startDate = null, endDate = null } = request.query
  const values = [request.params.id]
  let where = 'WHERE USUARIO_ID = ?'
  if (startDate) { values.push(startDate); where += ' AND (DATA_FIM IS NULL OR DATA_FIM >= ?)'}
  if (endDate) { values.push(endDate); where += ' AND DATA_INICIO <= ?'}
  const [rows] = await pool.query(`SELECT COALESCE(SUM(PERCENTUAL_ALOCACAO),0) as total FROM ALOCACOES_PROJETO ${where}`, values)
  const total = Number(rows[0].total || 0)
  response.json({ data: { total_percentual: total, disponivel: Math.max(0, 100 - total) } })
}))

app.get('/api/projetos', authenticate, asyncRoute(async (_request, response) => {
  const [rows] = await pool.query(
    `SELECT p.ID AS id,
            p.NOME AS name,
            p.CATEGORIA AS category,
            p.DESCRICAO AS description,
            p.STATUS AS status,
            p.GESTOR_ID AS managerId,
            f.NOME AS managerName,
            p.DATA_INICIO AS startDate,
            p.DATA_ESTIMADA_FIM AS estimatedEndDate,
            p.DATA_FIM AS endDate,
            p.ORCAMENTO AS budget,
            p.PROGRESSO AS progress,
            p.ATIVO AS active,
            p.DATA_CRIACAO AS data_criacao,
            p.DATA_ATUALIZACAO AS data_atualizacao
     FROM PROJETOS p LEFT JOIN FUNCIONARIO f ON f.ID = p.GESTOR_ID
     ORDER BY p.DATA_CRIACAO DESC`,
  )
  // Return rows with consistent camelCase keys expected by frontend
  response.json(rows)
}))

app.post('/api/projetos', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  const { name, category, description, managerId, startDate, estimatedEndDate, budget } = request.body
  if (!name || !managerId || !startDate) {
    return response.status(400).json({ error: 'name, managerId e startDate são obrigatórios.' })
  }

  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'PROJETOS')
    await client.query(
      `INSERT INTO PROJETOS (ID, NOME, CATEGORIA, DESCRICAO, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, name, category || null, description || null, managerId, startDate, estimatedEndDate || null, budget || null],
    )
    const [rows] = await client.query(
      `SELECT ID AS id, NOME AS name, CATEGORIA AS category, DESCRICAO AS description, STATUS AS status, GESTOR_ID AS managerId, DATA_INICIO AS startDate, DATA_ESTIMADA_FIM AS estimatedEndDate, DATA_FIM AS endDate, ORCAMENTO AS budget, PROGRESSO AS progress, ATIVO AS active, DATA_CRIACAO AS data_criacao, DATA_ATUALIZACAO AS data_atualizacao FROM PROJETOS WHERE ID = ?`,
      [id]
    )
    response.status(201).json(rows[0])
  } finally {
    client.release()
  }
}))

app.get('/api/projetos/:projectId/alocacoes', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query(
    `SELECT a.*, f.NOME AS usuario_nome
     FROM ALOCACOES_PROJETO a JOIN FUNCIONARIO f ON f.ID = a.USUARIO_ID
    WHERE a.PROJETO_ID = ? ORDER BY a.DATA_INICIO`,
    [request.params.projectId],
  )
  response.json(rows)
}))

// Get project by id
app.get('/api/projetos/:projectId', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query(`SELECT ID AS id, NOME AS name, CATEGORIA AS category, DESCRICAO AS description, STATUS AS status, GESTOR_ID AS managerId, DATA_INICIO AS startDate, DATA_ESTIMADA_FIM AS estimatedEndDate, DATA_FIM AS endDate, ORCAMENTO AS budget, PROGRESSO AS progress, ATIVO AS active, DATA_CRIACAO AS data_criacao, DATA_ATUALIZACAO AS data_atualizacao FROM PROJETOS WHERE ID = ?`, [request.params.projectId])
  if (!rows.length) return response.status(404).json({ error: 'Projeto não encontrado.' })
  response.json({ data: rows[0] })
}))

// Update project
app.patch('/api/projetos/:projectId', authenticate, asyncRoute(async (request, response) => {
  const { name, category, description, status, managerId, startDate, estimatedEndDate, budget } = request.body
  const client = await pool.getConnection()
  try {
    const [existing] = await client.query('SELECT * FROM PROJETOS WHERE ID = ?', [request.params.projectId])
    if (!existing.length) return response.status(404).json({ error: 'Projeto não encontrado.' })
    await client.query(
      `UPDATE PROJETOS SET NOME = COALESCE(?, NOME), CATEGORIA = COALESCE(?, CATEGORIA), DESCRICAO = COALESCE(?, DESCRICAO), STATUS = COALESCE(?, STATUS), GESTOR_ID = COALESCE(?, GESTOR_ID), DATA_INICIO = COALESCE(?, DATA_INICIO), DATA_ESTIMADA_FIM = COALESCE(?, DATA_ESTIMADA_FIM), ORCAMENTO = COALESCE(?, ORCAMENTO) WHERE ID = ?`,
      [name, category, description, status, managerId, startDate, estimatedEndDate, budget, request.params.projectId],
    )
    const [rows] = await client.query(`SELECT ID AS id, NOME AS name, CATEGORIA AS category, DESCRICAO AS description, STATUS AS status, GESTOR_ID AS managerId, DATA_INICIO AS startDate, DATA_ESTIMADA_FIM AS estimatedEndDate, DATA_FIM AS endDate, ORCAMENTO AS budget, PROGRESSO AS progress, ATIVO AS active, DATA_CRIACAO AS data_criacao, DATA_ATUALIZACAO AS data_atualizacao FROM PROJETOS WHERE ID = ?`, [request.params.projectId])
    response.json({ data: rows[0] })
  } finally {
    client.release()
  }
}))

// Patch project status
app.patch('/api/projetos/:projectId/status', authenticate, asyncRoute(async (request, response) => {
  const { status } = request.body
  if (!status) return response.status(400).json({ error: 'status é obrigatório.' })
  await pool.query('UPDATE PROJETOS SET STATUS = ? WHERE ID = ?', [status, request.params.projectId])
  const [rows] = await pool.query('SELECT * FROM PROJETOS WHERE ID = ?', [request.params.projectId])
  response.json({ data: rows[0] })
}))

// Project resumo: basic aggregates
app.get('/api/projetos/:projectId/resumo', authenticate, asyncRoute(async (request, response) => {
  const projectId = request.params.projectId
  const [[hours]] = await pool.query(
    `SELECT COALESCE(SUM(DURACAO_MINUTOS),0) as total_minutos FROM LANCAMENTOS_HORAS WHERE PROJETO_ID = ? AND STATUS = 'aprovado'`,
    [projectId],
  )
  const [[allocs]] = await pool.query(
    `SELECT COUNT(*) as total_alocacoes FROM ALOCACOES_PROJETO WHERE PROJETO_ID = ?`,
    [projectId],
  )
  response.json({ data: { total_minutos: Number(hours.total_minutos || 0), total_alocacoes: allocs.total_alocacoes } })
}))

app.post('/api/projetos/:projectId/alocacoes', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  const { userId, duration, startDate, endDate = null } = request.body
  if (!userId || duration === undefined || !startDate) {
    return response.status(400).json({ error: 'userId, duration e startDate são obrigatórios.' })
  }

  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'ALOCACOES_PROJETO')
    await client.query(
      `INSERT INTO ALOCACOES_PROJETO (ID, PROJETO_ID, USUARIO_ID, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [id, request.params.projectId, userId, duration, startDate, endDate],
    )
    const [rows] = await client.query('SELECT * FROM ALOCACOES_PROJETO WHERE ID = ?', [id])
    response.status(201).json(rows[0])
  } finally {
    client.release()
  }
}))

// Update allocation
app.patch('/api/alocacoes/:id', authenticate, asyncRoute(async (request, response) => {
  const { percentual_alocacao, data_inicio, data_fim, status } = request.body
  const client = await pool.getConnection()
  try {
    const [existing] = await client.query('SELECT * FROM ALOCACOES_PROJETO WHERE ID = ?', [request.params.id])
    if (!existing.length) return response.status(404).json({ error: 'Alocação não encontrada.' })
    await client.query(
      `UPDATE ALOCACOES_PROJETO SET PERCENTUAL_ALOCACAO = COALESCE(?, PERCENTUAL_ALOCACAO), DATA_INICIO = COALESCE(?, DATA_INICIO), DATA_FIM = COALESCE(?, DATA_FIM), STATUS = COALESCE(?, STATUS) WHERE ID = ?`,
      [percentual_alocacao, data_inicio, data_fim, status, request.params.id],
    )
    const [rows] = await client.query('SELECT * FROM ALOCACOES_PROJETO WHERE ID = ?', [request.params.id])
    response.json({ data: rows[0] })
  } finally {
    client.release()
  }
}))

// Delete allocation
app.delete('/api/alocacoes/:id', authenticate, asyncRoute(async (request, response) => {
  await pool.query('DELETE FROM ALOCACOES_PROJETO WHERE ID = ?', [request.params.id])
  response.status(204).send()
}))

// Disponibilidade: total alocado percentual para usuário no período
app.get('/api/alocacoes/disponibilidade', authenticate, asyncRoute(async (request, response) => {
  const { userId, startDate = null, endDate = null } = request.query
  if (!userId) return response.status(400).json({ error: 'userId é obrigatório.' })
  const values = [userId]
  let where = 'WHERE USUARIO_ID = ?'
  if (startDate) {
    values.push(startDate)
    where += ' AND (DATA_FIM IS NULL OR DATA_FIM >= ?)'
  }
  if (endDate) {
    values.push(endDate)
    where += ' AND DATA_INICIO <= ?'
  }
  const [rows] = await pool.query(`SELECT COALESCE(SUM(PERCENTUAL_ALOCACAO),0) as total FROM ALOCACOES_PROJETO ${where}`, values)
  const total = Number(rows[0].total || 0)
  response.json({ data: { total_percentual: total, disponivel: Math.max(0, 100 - total) } })
}))

// Empréstimo de alocação
app.post('/api/projetos/:projectId/alocacoes/emprestimo', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  const { userId, percentual_alocacao, gestor_origem_id, gestor_destino_id, motivo, data_inicio, data_fim } = request.body
  if (!userId || percentual_alocacao === undefined || !gestor_origem_id || !gestor_destino_id || !data_inicio) {
    return response.status(400).json({ error: 'userId, percentual_alocacao, gestor_origem_id, gestor_destino_id e data_inicio são obrigatórios.' })
  }
  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'ALOCACOES_PROJETO')
    await client.query(
      `INSERT INTO ALOCACOES_PROJETO (ID, PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, GESTOR_ORIGEM_ID, GESTOR_DESTINO_ID, MOTIVO_EMPRESTIMO)
       VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?)`,
      [id, request.params.projectId, userId, percentual_alocacao, data_inicio, data_fim || null, gestor_origem_id, gestor_destino_id, motivo || null],
    )
    const [rows] = await client.query('SELECT * FROM ALOCACOES_PROJETO WHERE ID = ?', [id])
    response.status(201).json({ data: rows[0] })
  } finally {
    client.release()
  }
}))

app.get('/api/lancamentos', authenticate, asyncRoute(async (request, response) => {
  const values = [request.user.id]
  let where = 'WHERE l.USUARIO_ID = ?'
  if (request.query.projectId) {
    values.push(request.query.projectId)
    where += ' AND l.PROJETO_ID = ?'
  }

  const [rows] = await pool.query(
    `SELECT l.*, p.NOME AS projeto_nome
     FROM LANCAMENTOS_HORAS l JOIN PROJETOS p ON p.ID = l.PROJETO_ID
     ${where} ORDER BY l.DATA_LANCAMENTO DESC, l.ID DESC`,
    values,
  )
  response.json(rows)
}))

app.post('/api/lancamentos', authenticate, asyncRoute(async (request, response) => {
  const { projectId, description, category, duration, date } = request.body
  if (!projectId || !description || !category || !duration || !date) {
    return response.status(400).json({ error: 'projectId, description, category, duration e date são obrigatórios.' })
  }

  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'LANCAMENTOS_HORAS')
    // duration may be provided as minutes number or string 'HH:MM'
    let durMin = Number(duration)
    if (isNaN(durMin)) {
      // expect format 'HH:MM' or 'HH:MM:SS'
      const parts = String(duration).split(':').map(p => Number(p))
      if (parts.length >= 2 && !parts.some(isNaN)) {
        durMin = (parts[0] * 60) + parts[1]
      } else {
        durMin = 0
      }
    }
    // Accept optional hora_inicio / hora_fim from client and persist them
    const horaInicio = request.body.hora_inicio || null
    const horaFim = request.body.hora_fim || null
    await client.query(
      `INSERT INTO LANCAMENTOS_HORAS (ID, USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, request.user.id, projectId, description, category, durMin, durMin, date, horaInicio, horaFim],
    )
    const [rows] = await client.query('SELECT * FROM LANCAMENTOS_HORAS WHERE ID = ?', [id])
    response.status(201).json(rows[0])
  } finally {
    client.release()
  }
}))

// Solicitações
app.get('/api/solicitacoes', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT s.*, f.NOME as usuario_nome FROM SOLITICACAO s JOIN FUNCIONARIO f ON f.ID = s.USUARIO_ID ORDER BY s.DATA_CRIACAO DESC')
  response.json({ data: rows })
}))

app.get('/api/solicitacoes/:id', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT s.*, f.NOME as usuario_nome FROM SOLITICACAO s JOIN FUNCIONARIO f ON f.ID = s.USUARIO_ID WHERE s.ID = ?', [request.params.id])
  if (!rows.length) return response.status(404).json({ error: 'Solicitação não encontrada.' })
  response.json({ data: rows[0] })
}))

app.post('/api/solicitacoes/ausencias', authenticate, asyncRoute(async (request, response) => {
  const { tipo_ausencia, data_inicio, data_fim, motivo } = request.body
  if (!data_inicio || !data_fim) return response.status(400).json({ error: 'data_inicio e data_fim são obrigatórios.' })
  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'SOLITICACAO')
    await client.query('INSERT INTO SOLITICACAO (ID, USUARIO_ID, TIPO, TIPO_AUSENCIA, DATA_INICIO, DATA_FIM, MOTIVO) VALUES (?, ?, ?, ?, ?, ?, ?)', [id, request.user.id, 'ausencia', tipo_ausencia || null, data_inicio, data_fim, motivo || null])
    const [rows] = await client.query('SELECT * FROM SOLITICACAO WHERE ID = ?', [id])
    response.status(201).json({ data: rows[0] })
  } finally { client.release() }
}))

app.post('/api/solicitacoes/horas-extras', authenticate, asyncRoute(async (request, response) => {
  const { horas, data_inicio, data_fim, motivo } = request.body
  if (!horas || !data_inicio) return response.status(400).json({ error: 'horas e data_inicio são obrigatórios.' })
  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'SOLITICACAO')
    await client.query('INSERT INTO SOLITICACAO (ID, USUARIO_ID, TIPO, HORAS, DATA_INICIO, DATA_FIM, MOTIVO) VALUES (?, ?, ?, ?, ?, ?, ?)', [id, request.user.id, 'hora_extra', horas, data_inicio, data_fim || null, motivo || null])
    const [rows] = await client.query('SELECT * FROM SOLITICACAO WHERE ID = ?', [id])
    response.status(201).json({ data: rows[0] })
  } finally { client.release() }
}))

app.patch('/api/solicitacoes/:id/aprovar', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  await pool.query('UPDATE SOLITICACAO SET STATUS = ?, APROVADO_POR = ? WHERE ID = ?', ['aprovado', request.user.id, request.params.id])
  const [rows] = await pool.query('SELECT * FROM SOLITICACAO WHERE ID = ?', [request.params.id])
  response.json({ data: rows[0] })
}))

app.patch('/api/solicitacoes/:id/reprovar', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  const { observacao } = request.body
  await pool.query('UPDATE SOLITICACAO SET STATUS = ?, OBSERVACAO_APROVACAO = ?, APROVADO_POR = ? WHERE ID = ?', ['reprovado', observacao || null, request.user.id, request.params.id])
  const [rows] = await pool.query('SELECT * FROM SOLITICACAO WHERE ID = ?', [request.params.id])
  response.json({ data: rows[0] })
}))

// Marcos
app.get('/api/projetos/:projectId/marcos', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT * FROM MARCO WHERE PROJETO_ID = ? ORDER BY DATA_VENCIMENTO', [request.params.projectId])
  response.json({ data: rows })
}))

app.post('/api/projetos/:projectId/marcos', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  const { titulo, descricao, data_vencimento, total_entregas } = request.body
  if (!titulo) return response.status(400).json({ error: 'titulo é obrigatório.' })
  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'MARCO')
    await client.query('INSERT INTO MARCO (ID, PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, TOTAL_ENTREGAS) VALUES (?, ?, ?, ?, ?, ?)', [id, request.params.projectId, titulo, descricao || null, data_vencimento || null, total_entregas || 0])
    const [rows] = await client.query('SELECT * FROM MARCO WHERE ID = ?', [id])
    response.status(201).json({ data: rows[0] })
  } finally { client.release() }
}))

app.get('/api/marcos/:id', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT * FROM MARCO WHERE ID = ?', [request.params.id])
  if (!rows.length) return response.status(404).json({ error: 'Marco não encontrado.' })
  response.json({ data: rows[0] })
}))

app.patch('/api/marcos/:id', authenticate, asyncRoute(async (request, response) => {
  const { titulo, descricao, data_vencimento, status } = request.body
  const client = await pool.getConnection()
  try {
    await client.query('UPDATE MARCO SET TITULO = COALESCE(?, TITULO), DESCRICAO = COALESCE(?, DESCRICAO), DATA_VENCIMENTO = COALESCE(?, DATA_VENCIMENTO), STATUS = COALESCE(?, STATUS) WHERE ID = ?', [titulo, descricao, data_vencimento, status, request.params.id])
    const [rows] = await client.query('SELECT * FROM MARCO WHERE ID = ?', [request.params.id])
    response.json({ data: rows[0] })
  } finally { client.release() }
}))

app.delete('/api/marcos/:id', authenticate, asyncRoute(async (request, response) => {
  await pool.query('DELETE FROM MARCO WHERE ID = ?', [request.params.id])
  response.status(204).send()
}))

app.patch('/api/marcos/:id/status', authenticate, asyncRoute(async (request, response) => {
  const { status } = request.body
  if (!status) return response.status(400).json({ error: 'status é obrigatório.' })
  await pool.query('UPDATE MARCO SET STATUS = ? WHERE ID = ?', [status, request.params.id])
  const [rows] = await pool.query('SELECT * FROM MARCO WHERE ID = ?', [request.params.id])
  response.json({ data: rows[0] })
}))

// Entregas
app.get('/api/marcos/:marcoId/entregas', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT * FROM ENTREGA WHERE MARCO_ID = ? ORDER BY DATA_ENTREGA', [request.params.marcoId])
  response.json({ data: rows })
}))

app.post('/api/marcos/:marcoId/entregas', authenticate, asyncRoute(async (request, response) => {
  const { titulo, descricao, data_entrega } = request.body
  if (!titulo) return response.status(400).json({ error: 'titulo é obrigatório.' })
  const client = await pool.getConnection()
  try {
    const id = await nextId(client, 'ENTREGA')
    await client.query('INSERT INTO ENTREGA (ID, MARCO_ID, TITULO, DESCRICAO, DATA_ENTREGA) VALUES (?, ?, ?, ?, ?)', [id, request.params.marcoId, titulo, descricao || null, data_entrega || null])
    // atualiza contadores
    await client.query('UPDATE MARCO SET TOTAL_ENTREGAS = TOTAL_ENTREGAS + 1 WHERE ID = ?', [request.params.marcoId])
    const [rows] = await client.query('SELECT * FROM ENTREGA WHERE ID = ?', [id])
    response.status(201).json({ data: rows[0] })
  } finally { client.release() }
}))

app.patch('/api/entregas/:id', authenticate, asyncRoute(async (request, response) => {
  const { titulo, descricao, status, data_entrega } = request.body
  const client = await pool.getConnection()
  try {
    await client.query('UPDATE ENTREGA SET TITULO = COALESCE(?, TITULO), DESCRICAO = COALESCE(?, DESCRICAO), STATUS = COALESCE(?, STATUS), DATA_ENTREGA = COALESCE(?, DATA_ENTREGA) WHERE ID = ?', [titulo, descricao, status, data_entrega, request.params.id])
    const [rows] = await client.query('SELECT * FROM ENTREGA WHERE ID = ?', [request.params.id])
    response.json({ data: rows[0] })
  } finally { client.release() }
}))

app.delete('/api/entregas/:id', authenticate, asyncRoute(async (request, response) => {
  await pool.query('DELETE FROM ENTREGA WHERE ID = ?', [request.params.id])
  response.status(204).send()
}))

// Dashboard admin endpoints (basic aggregations)
app.get('/api/dashboard/admin', authenticate, authorize(['admin']), asyncRoute(async (request, response) => {
  const [kpis] = await pool.query(`SELECT (SELECT COUNT(*) FROM PROJETOS) as total_projetos, (SELECT COUNT(*) FROM FUNCIONARIO WHERE ATIVO = 1) as total_usuarios, (SELECT COALESCE(SUM(DURACAO_MINUTOS),0) FROM LANCAMENTOS_HORAS WHERE STATUS = 'aprovado') as total_minutos`)
  response.json({ data: kpis[0] })
}))

app.get('/api/dashboard/admin/kpis', authenticate, authorize(['admin']), asyncRoute(async (request, response) => {
  const [rows] = await pool.query(`SELECT (SELECT COUNT(*) FROM PROJETOS) as total_projetos, (SELECT COUNT(*) FROM FUNCIONARIO WHERE ATIVO = 1) as total_usuarios, (SELECT COALESCE(SUM(DURACAO_MINUTOS),0) FROM LANCAMENTOS_HORAS WHERE STATUS = 'aprovado') as total_minutos, (SELECT COUNT(*) FROM SOLITICACAO WHERE STATUS = 'pendente') as solicitacoes_pendentes`)
  response.json({ data: rows[0] })
}))

app.get('/api/dashboard/admin/horas-por-projeto', authenticate, authorize(['admin']), asyncRoute(async (request, response) => {
  const { startDate, endDate } = request.query
  const values = []
  let where = 'WHERE l.STATUS = "aprovado"'
  if (startDate) { where += ' AND l.DATA_LANCAMENTO >= ?'; values.push(startDate) }
  if (endDate) { where += ' AND l.DATA_LANCAMENTO <= ?'; values.push(endDate) }
  const [rows] = await pool.query(`SELECT p.ID as projectId, p.NOME as projectName, COALESCE(SUM(l.DURACAO_MINUTOS),0) as minutos FROM PROJETOS p LEFT JOIN LANCAMENTOS_HORAS l ON l.PROJETO_ID = p.ID ${where} GROUP BY p.ID, p.NOME ORDER BY minutos DESC`, values)
  response.json({ data: rows })
}))

app.get('/api/dashboard/admin/horas-por-recurso', authenticate, authorize(['admin']), asyncRoute(async (request, response) => {
  const { startDate, endDate } = request.query
  const values = []
  let where = 'WHERE l.STATUS = "aprovado"'
  if (startDate) { where += ' AND l.DATA_LANCAMENTO >= ?'; values.push(startDate) }
  if (endDate) { where += ' AND l.DATA_LANCAMENTO <= ?'; values.push(endDate) }
  const [rows] = await pool.query(`SELECT f.ID as userId, f.NOME as userName, COALESCE(SUM(l.DURACAO_MINUTOS),0) as minutos FROM FUNCIONARIO f LEFT JOIN LANCAMENTOS_HORAS l ON l.USUARIO_ID = f.ID ${where} GROUP BY f.ID, f.NOME ORDER BY minutos DESC`, values)
  response.json({ data: rows })
}))

app.get('/api/dashboard/admin/horas-extras', authenticate, authorize(['admin']), asyncRoute(async (request, response) => {
  const [rows] = await pool.query("SELECT s.ID, s.USUARIO_ID, f.NOME as usuario_nome, s.HORAS, s.STATUS, s.DATA_CRIACAO FROM SOLITICACAO s JOIN FUNCIONARIO f ON f.ID = s.USUARIO_ID WHERE s.TIPO = 'hora_extra' ORDER BY s.DATA_CRIACAO DESC")
  response.json({ data: rows })
}))

app.get('/api/dashboard/admin/apontamentos', authenticate, asyncRoute(async (request, response) => {
  const { startDate, endDate } = request.query
  const values = []
  let where = ''
  if (startDate) { where += ' WHERE l.DATA_LANCAMENTO >= ?'; values.push(startDate) }
  if (endDate) { where += (where ? ' AND' : ' WHERE') + ' l.DATA_LANCAMENTO <= ?'; values.push(endDate) }
  const [rows] = await pool.query(`SELECT l.DATA_LANCAMENTO as date, COALESCE(SUM(l.DURACAO_MINUTOS),0) as minutos FROM LANCAMENTOS_HORAS l ${where} GROUP BY l.DATA_LANCAMENTO ORDER BY l.DATA_LANCAMENTO`, values)
  response.json({ data: rows })
}))

app.get('/api/dashboard/admin/burndown', authenticate, asyncRoute(async (request, response) => {
  const { projectId, startDate, endDate } = request.query
  if (!projectId || !startDate || !endDate) return response.status(400).json({ error: 'projectId, startDate e endDate são obrigatórios.' })
  const [rows] = await pool.query(`SELECT l.DATA_LANCAMENTO as date, COALESCE(SUM(l.DURACAO_MINUTOS),0) as minutos FROM LANCAMENTOS_HORAS l WHERE l.PROJETO_ID = ? AND l.DATA_LANCAMENTO BETWEEN ? AND ? GROUP BY l.DATA_LANCAMENTO ORDER BY l.DATA_LANCAMENTO`, [projectId, startDate, endDate])
  response.json({ data: rows })
}))

app.get('/api/dashboard/admin/distribuicao-recursos', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query(`SELECT p.ID as projectId, p.NOME as projectName, COALESCE(SUM(a.PERCENTUAL_ALOCACAO),0) as total_percentual FROM PROJETOS p LEFT JOIN ALOCACOES_PROJETO a ON a.PROJETO_ID = p.ID GROUP BY p.ID, p.NOME ORDER BY total_percentual DESC`)
  response.json({ data: rows })
}))

// Heatmap: hours per resource per day in a date range (defaults to last 7 days)
app.get('/api/dashboard/admin/heatmap', authenticate, asyncRoute(async (request, response) => {
  const { startDate, endDate } = request.query
  // default to last 7 days
  const end = endDate || new Date().toISOString().slice(0,10)
  const start = startDate || new Date(Date.now() - 6 * 24 * 60 * 60 * 1000).toISOString().slice(0,10)

  const [rows] = await pool.query(
    `SELECT f.ID as userId, f.NOME as userName, DATE(l.DATA_LANCAMENTO) as date, COALESCE(SUM(l.DURACAO_MINUTOS),0) as minutos
     FROM FUNCIONARIO f
     LEFT JOIN LANCAMENTOS_HORAS l ON l.USUARIO_ID = f.ID AND l.STATUS = 'aprovado' AND l.DATA_LANCAMENTO BETWEEN ? AND ?
     GROUP BY f.ID, DATE(l.DATA_LANCAMENTO)
     ORDER BY f.NOME, DATE(l.DATA_LANCAMENTO)`,
    [start, end],
  )
  response.json({ data: rows })
}))

// Semana: retorna lançamentos por semana (startDate query)
app.get('/api/lancamentos/semana', authenticate, asyncRoute(async (request, response) => {
  const { startDate } = request.query
  if (!startDate) return response.status(400).json({ error: 'startDate é obrigatório no formato YYYY-MM-DD' })
  const [rows] = await pool.query(
    `SELECT l.*, p.NOME as projeto_nome FROM LANCAMENTOS_HORAS l JOIN PROJETOS p ON p.ID = l.PROJETO_ID WHERE l.USUARIO_ID = ? AND l.DATA_LANCAMENTO BETWEEN ? AND DATE_ADD(?, INTERVAL 6 DAY) ORDER BY l.DATA_LANCAMENTO`,
    [request.user.id, startDate, startDate],
  )
  response.json({ data: rows })
}))

// Get lancamento by id
app.get('/api/lancamentos/:id', authenticate, asyncRoute(async (request, response) => {
  const [rows] = await pool.query('SELECT l.*, f.NOME as usuario_nome, p.NOME as projeto_nome FROM LANCAMENTOS_HORAS l JOIN FUNCIONARIO f ON f.ID = l.USUARIO_ID JOIN PROJETOS p ON p.ID = l.PROJETO_ID WHERE l.ID = ?', [request.params.id])
  if (!rows.length) return response.status(404).json({ error: 'Lançamento não encontrado.' })
  response.json({ data: rows[0] })
}))

// Update lancamento
app.patch('/api/lancamentos/:id', authenticate, asyncRoute(async (request, response) => {
  const { descricao, categoria, duracao_minutos, data_lancamento, hora_inicio, hora_fim } = request.body
  const client = await pool.getConnection()
  try {
    const [existing] = await client.query('SELECT * FROM LANCAMENTOS_HORAS WHERE ID = ?', [request.params.id])
    if (!existing.length) return response.status(404).json({ error: 'Lançamento não encontrado.' })
    await client.query(
      `UPDATE LANCAMENTOS_HORAS SET DESCRICAO_ATIVIDADE = COALESCE(?, DESCRICAO_ATIVIDADE), CATEGORIA = COALESCE(?, CATEGORIA), DURACAO_MINUTOS = COALESCE(?, DURACAO_MINUTOS), DATA_LANCAMENTO = COALESCE(?, DATA_LANCAMENTO), HORA_INICIO = COALESCE(?, HORA_INICIO), HORA_FIM = COALESCE(?, HORA_FIM) WHERE ID = ?`,
      [descricao, categoria, duracao_minutos, data_lancamento, hora_inicio, hora_fim, request.params.id],
    )
    const [rows] = await client.query('SELECT * FROM LANCAMENTOS_HORAS WHERE ID = ?', [request.params.id])
    response.json({ data: rows[0] })
  } finally {
    client.release()
  }
}))

// Delete lancamento
app.delete('/api/lancamentos/:id', authenticate, asyncRoute(async (request, response) => {
  await pool.query('DELETE FROM LANCAMENTOS_HORAS WHERE ID = ?', [request.params.id])
  response.status(204).send()
}))

// Semana: retorna lançamentos por semana (startDate query)
app.get('/api/lancamentos/semana', authenticate, asyncRoute(async (request, response) => {
  const { startDate } = request.query
  if (!startDate) return response.status(400).json({ error: 'startDate é obrigatório no formato YYYY-MM-DD' })
  const [rows] = await pool.query(
    `SELECT l.*, p.NOME as projeto_nome FROM LANCAMENTOS_HORAS l JOIN PROJETOS p ON p.ID = l.PROJETO_ID WHERE l.USUARIO_ID = ? AND l.DATA_LANCAMENTO BETWEEN ? AND DATE_ADD(?, INTERVAL 6 DAY) ORDER BY l.DATA_LANCAMENTO`,
    [request.user.id, startDate, startDate],
  )
  response.json({ data: rows })
}))

// Resumo: agregados por filtro
app.get('/api/lancamentos/resumo', authenticate, asyncRoute(async (request, response) => {
  const { projectId, userId, startDate, endDate } = request.query
  const values = []
  let where = 'WHERE 1=1'
  if (projectId) { where += ' AND PROJETO_ID = ?'; values.push(projectId) }
  if (userId) { where += ' AND USUARIO_ID = ?'; values.push(userId) }
  if (startDate) { where += ' AND DATA_LANCAMENTO >= ?'; values.push(startDate) }
  if (endDate) { where += ' AND DATA_LANCAMENTO <= ?'; values.push(endDate) }
  const [rows] = await pool.query(`SELECT COALESCE(SUM(DURACAO_MINUTOS),0) as total_minutos, COUNT(*) as total_registros FROM LANCAMENTOS_HORAS ${where}`, values)
  response.json({ data: rows[0] })
}))

// Aprovar / Reprovar lançamento
app.patch('/api/lancamentos/:id/aprovar', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  await pool.query('UPDATE LANCAMENTOS_HORAS SET STATUS = ? WHERE ID = ?', ['aprovado', request.params.id])
  const [rows] = await pool.query('SELECT * FROM LANCAMENTOS_HORAS WHERE ID = ?', [request.params.id])
  response.json({ data: rows[0] })
}))

app.patch('/api/lancamentos/:id/reprovar', authenticate, authorize(['admin','gestor']), asyncRoute(async (request, response) => {
  const { observacao } = request.body
  await pool.query('UPDATE LANCAMENTOS_HORAS SET STATUS = ?, OBSERVACAO_APROVACAO = ? WHERE ID = ?', ['reprovado', observacao || null, request.params.id])
  const [rows] = await pool.query('SELECT * FROM LANCAMENTOS_HORAS WHERE ID = ?', [request.params.id])
  response.json({ data: rows[0] })
}))

app.use((_request, response) => response.status(404).json({ error: 'Rota não encontrada.' }))
app.use((error, _request, response, _next) => {
  console.error(error)
  if (error.code === 'ER_DUP_ENTRY') return response.status(409).json({ error: 'Registro duplicado.' })
  if (error.code === 'ER_NO_REFERENCED_ROW_2') return response.status(400).json({ error: 'Referência relacionada não encontrada.' })
  if (error.code === 'ER_CHECK_CONSTRAINT_VIOLATED') return response.status(400).json({ error: 'Dados violam uma regra do banco.' })
  response.status(500).json({ error: 'Erro interno do servidor.' })
})

app.listen(port, '0.0.0.0', () => {
  console.log(`PAM API rodando em http://0.0.0.0:${port}`)
})

startDatabaseWatch()
