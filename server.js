import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import mysql from 'mysql2/promise'

const app = express()
const port = Number(process.env.PORT || 3001)
const jwtSecret = process.env.JWT_SECRET || 'dev-secret-change-me'
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'PAM',
  waitForConnections: true,
  connectionLimit: 10,
})

app.use(cors({ origin: process.env.FRONTEND_URL || 'http://localhost:5173' }))
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

const waitForDatabase = async () => {
  let attempt = 0

  while (true) {
    try {
      await pool.query('SELECT 1')
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
  gestor: row.gestor ?? row.GESTOR,
  data_criacao: row.data_criacao ?? row.DATA_CRIACAO,
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

app.get('/api/health', asyncRoute(async (_request, response) => {
  response.json({ status: 'ok' })
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

  const client = await pool.connect()
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
    'SELECT ID AS id, NOME AS name, EMAIL AS email, DEPARTAMENTO AS department, CARGO AS role, GESTOR AS `isManager` FROM FUNCIONARIO ORDER BY NOME',
  )
  response.json(rows)
}))

app.get('/api/projetos', authenticate, asyncRoute(async (_request, response) => {
  const [rows] = await pool.query(
    `SELECT p.*, f.NOME AS gestor_nome
     FROM PROJETOS p JOIN FUNCIONARIO f ON f.ID = p.GESTOR_ID
     ORDER BY p.DATA_CRIACAO DESC`,
  )
  response.json(rows)
}))

app.post('/api/projetos', authenticate, asyncRoute(async (request, response) => {
  const { name, category, description, managerId, startDate, estimatedEndDate, budget } = request.body
  if (!name || !managerId || !startDate) {
    return response.status(400).json({ error: 'name, managerId e startDate são obrigatórios.' })
  }

  const client = await pool.connect()
  try {
    const id = await nextId(client, 'PROJETOS')
    await client.query(
      `INSERT INTO PROJETOS (ID, NOME, CATEGORIA, DESCRICAO, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, name, category || null, description || null, managerId, startDate, estimatedEndDate || null, budget || null],
    )
    const [rows] = await client.query('SELECT * FROM PROJETOS WHERE ID = ?', [id])
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

app.post('/api/projetos/:projectId/alocacoes', authenticate, asyncRoute(async (request, response) => {
  const { userId, duration, startDate, endDate = null } = request.body
  if (!userId || duration === undefined || !startDate) {
    return response.status(400).json({ error: 'userId, duration e startDate são obrigatórios.' })
  }

  const client = await pool.connect()
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

  const client = await pool.connect()
  try {
    const id = await nextId(client, 'LANCAMENTOS_HORAS')
    await client.query(
      `INSERT INTO LANCAMENTOS_HORAS (ID, USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO, DATA_LANCAMENTO)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [id, request.user.id, projectId, description, category, duration, date],
    )
    const [rows] = await client.query('SELECT * FROM LANCAMENTOS_HORAS WHERE ID = ?', [id])
    response.status(201).json(rows[0])
  } finally {
    client.release()
  }
}))

app.use((_request, response) => response.status(404).json({ error: 'Rota não encontrada.' }))
app.use((error, _request, response, _next) => {
  console.error(error)
  if (error.code === 'ER_DUP_ENTRY') return response.status(409).json({ error: 'Registro duplicado.' })
  if (error.code === 'ER_NO_REFERENCED_ROW_2') return response.status(400).json({ error: 'Referência relacionada não encontrada.' })
  if (error.code === 'ER_CHECK_CONSTRAINT_VIOLATED') return response.status(400).json({ error: 'Dados violam uma regra do banco.' })
  response.status(500).json({ error: 'Erro interno do servidor.' })
})

const start = async () => {
  await waitForDatabase()
  app.listen(port, '0.0.0.0', () => {
    console.log(`PAM API rodando em http://0.0.0.0:${port}`)
  })
}

start().catch((error) => {
  console.error('Falha ao iniciar a API.')
  console.error(error)
  process.exit(1)
})
