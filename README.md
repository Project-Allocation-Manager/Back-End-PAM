# PAM Backend

API REST em Node.js para o Project Allocation Manager.

## Requisitos

- Node.js 20 LTS+
- MySQL ou MariaDB
- Banco criado com `Front-End/banco.sql`

## Configuração

1. Crie o banco executando o script SQL. O script cria o banco `PAM`.
2. Copie `.env.example` para `.env`.
3. Ajuste `DB_USER`, `DB_PASSWORD` e os demais dados do seu MySQL/MariaDB.
4. Instale as dependências:

```powershell
npm install
```

## Execução

```powershell
npm run dev
```

A API ficará disponível em `http://localhost:3001`.

## Rotas principais

- `GET /api/health`
- `GET /api/health/db`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`
- `GET /api/funcionarios`
- `GET /api/projetos`
- `POST /api/projetos`
- `GET /api/projetos/:projectId/alocacoes`
- `POST /api/projetos/:projectId/alocacoes`
- `GET /api/lancamentos`
- `POST /api/lancamentos`

As rotas protegidas esperam o cabeçalho `Authorization: Bearer <token>` retornado no login ou cadastro.
