#!/usr/bin/env node
import bcrypt from 'bcryptjs'
import pool from './config.js'

// Configurable sizes
const RESOURCES_COUNT = 80
const PROJECTS_COUNT = 12
const MIN_MILESTONES = 3
const MAX_MILESTONES = 6
const MIN_DELIVERIES = 2
const MAX_DELIVERIES = 8

// Simple name pools to build realistic names
const firstNames = ['Pedro','Ana','João','Mariana','Lucas','Carolina','Rafael','Bruna','Marcos','Paula','Gustavo','Laura','Felipe','Camila','Eduardo','Sofia','Thiago','Beatriz','Victor','Mariana']
const lastNames = ['Silva','Santos','Oliveira','Pereira','Rodrigues','Almeida','Costa','Gomes','Martins','Lima','Araújo','Fernandes','Barbosa','Ribeiro','Cardoso']

function randInt(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min }
function pick(arr) { return arr[Math.floor(Math.random()*arr.length)] }

function makeName(i) {
  // create semi-unique names using pools and index
  const fn = pick(firstNames)
  const ln1 = pick(lastNames)
  const ln2 = pick(lastNames)
  return `${fn} ${ln1} ${ln2}${i > 0 ? ' ' + i : ''}`
}

function slugForEmail(name, i) {
  const base = name.toLowerCase().replace(/[^a-z0-9]+/g, '.')
  return `${base}${i}@pam.local`
}

async function seed() {
  const client = await pool.getConnection()
  try {
    await client.query('START TRANSACTION')

    // Ensure a single manager exists (create or reuse)
    const managerName = 'Gestor Único'
    const managerEmail = 'gestor.unico@pam.local'
    const [mgrRows] = await client.query('SELECT ID FROM FUNCIONARIO WHERE EMAIL = ? LIMIT 1', [managerEmail])
    let managerId
    if (!mgrRows.length) {
      const pass = 'gestor123'
      const hash = bcrypt.hashSync(pass, 12)
      const res = await client.query('INSERT INTO FUNCIONARIO (NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, ATIVO) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [managerName, null, 40, managerEmail, hash, 'Gestão', 'Gerente de Projetos', 'gestor', 1, 1])
      managerId = res[0].insertId
    } else managerId = mgrRows[0].ID

    // Create resources
    const resourceIds = []
    for (let i=0;i<RESOURCES_COUNT;i++) {
      const name = makeName(i)
      const email = slugForEmail(name, i)
      const first = String(name).split(' ')[0].toLowerCase()
      const plain = `${first}123`
      const hash = bcrypt.hashSync(plain, 12)
      const [exists] = await client.query('SELECT ID FROM FUNCIONARIO WHERE EMAIL = ? LIMIT 1', [email])
      if (!exists.length) {
        const r = await client.query('INSERT INTO FUNCIONARIO (NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [name, null, randInt(22,45), email, hash, 'Desenvolvimento', 'Recurso', 'recurso', 0, managerId, 1])
        resourceIds.push(r[0].insertId)
      } else resourceIds.push(exists[0].ID)
    }

    // Create projects with budgets
    const projectIds = []
    for (let p=0;p<PROJECTS_COUNT;p++) {
      const pname = (['Portal Cliente','App Mobile','Migração Cloud','ERP Upgrade','Site Marketing','Analytics','Integração API','Refatoração Backend','Automação Testes','Infra Segurança','Onboarding','Data Pipeline'][p]) || `Projeto ${p+1}`
      const budget = randInt(50000, 800000) + Math.round(Math.random()*99)/100
      const [exists] = await client.query('SELECT ID FROM PROJETOS WHERE NOME = ? LIMIT 1', [pname])
      let pid
      if (!exists.length) {
        const res = await client.query('INSERT INTO PROJETOS (NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', [pname, 'Desenvolvimento', `Projeto ${pname} descrito`, 'andamento', managerId, `2024-${String(randInt(1,6)).padStart(2,'0')}-01`, `2024-${String(randInt(7,12)).padStart(2,'0')}-${String(randInt(10,28)).padStart(2,'0')}`, budget])
        pid = res[0].insertId
      } else pid = exists[0].ID
      projectIds.push(pid)

      // create milestones
      const milestonesCount = randInt(MIN_MILESTONES, MAX_MILESTONES)
      for (let m=0;m<milestonesCount;m++) {
        const title = `Marco ${m+1} - ${pname}`
        const totalDeliveries = randInt(MIN_DELIVERIES, MAX_DELIVERIES)
        const completed = Math.floor(totalDeliveries * Math.random())
        const due = `2024-${String(randInt(6,12)).padStart(2,'0')}-${String(randInt(1,28)).padStart(2,'0')}`
        const [mexists] = await client.query('SELECT ID FROM MARCO WHERE PROJETO_ID = ? AND TITULO = ? LIMIT 1', [pid, title])
        let mid
        if (!mexists.length) {
          const r = await client.query('INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?)', [pid, title, title, due, totalDeliveries, completed, (completed >= totalDeliveries ? 'Concluído' : (completed > 0 ? 'Andamento' : 'Pendente'))])
          mid = r[0].insertId
        } else mid = mexists[0].ID

        // create deliveries
        for (let d=1; d<=totalDeliveries; d++) {
          const t = `Entrega ${d} - ${title}`
          const [dex] = await client.query('SELECT ID FROM ENTREGA WHERE MARCO_ID = ? AND TITULO = ? LIMIT 1', [mid, t])
          if (!dex.length) {
            const status = (d <= completed) ? 'concluida' : 'pendente'
            const data_ent = (d <= completed) ? due : null
            await client.query('INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA) VALUES (?, ?, ?, ?, ?)', [mid, t, t, status, data_ent])
          }
        }
      }
    }

    // Create allocations: distribute resources across projects
    for (let i=0;i<resourceIds.length;i++) {
      const uid = resourceIds[i]
      // allocate each resource to 1-3 projects
      const allot = randInt(1, Math.min(3, projectIds.length))
      const chosen = new Set()
      for (let a=0;a<allot;a++) {
        let projIdx
        do { projIdx = projectIds[Math.floor(Math.random()*projectIds.length)] } while (chosen.has(projIdx))
        chosen.add(projIdx)
        const percent = [50,75,100][Math.floor(Math.random()*3)]
        const [exists] = await client.query('SELECT ID FROM ALOCACOES_PROJETO WHERE PROJETO_ID = ? AND USUARIO_ID = ? LIMIT 1', [projIdx, uid])
        if (!exists.length) {
          await client.query('INSERT INTO ALOCACOES_PROJETO (PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DATA_INICIO, STATUS) VALUES (?, ?, ?, ?, ?)', [projIdx, uid, percent, '2024-01-01', 'ativo'])
        }
      }
    }

    // commit
    await client.query('COMMIT')
    console.log('Large seeding complete:')
    console.log(`Resources: ${resourceIds.length}, Projects: ${projectIds.length}`)
    process.exit(0)
  } catch (e) {
    console.error('Seeding failed', e)
    try { await client.query('ROLLBACK') } catch {}
    process.exit(1)
  } finally {
    try { client.release() } catch {}
  }
}

seed()
