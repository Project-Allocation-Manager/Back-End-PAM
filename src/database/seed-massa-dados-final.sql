-- ============================================================
-- SEED DE DADOS DEMONSTRATIVOS - PAM
-- Baseado no esquema de script-tabelas-safe.sql.
-- Os nomes, e-mails, projetos, orçamentos e atividades são fictícios,
-- mas foram montados para representar um cenário corporativo plausível.
-- Senhas: hash bcrypt (cost 12) da regra primeiro_nome_em_minúsculas + '123'.
-- Execute após criar o schema/tabelas. Não contém DDL nem altera o schema.
-- Reexecução: inserts usam verificações de existência para evitar duplicações.
-- ============================================================

USE PAM;
START TRANSACTION;


INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Rafael Gomes', 'GST001', 40, 'rafael.gomes@pam.local', '$2b$12$3xAmuBDcAZT9tzl/uhkdj.COY4tn432MSrqkGnwBxMnFn1LJtHIVi', 'Gestão de Projetos', 'Gerente de Projetos', 'gestor', 1,
       NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' OR MATRICULA = 'GST001');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Pedro Henrique Rodrigues', 'REC001', 25, 'pedro.rodrigues@pam.local', '$2b$12$REiccSNPWZgQpHc6q9k4xeWPmr5fQpleyxe6jN6l35K8e48VceuY6', 'Dados e Tecnologia', 'Analista de Dados', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'pedro.rodrigues@pam.local' OR MATRICULA = 'REC001');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Ana Carolina Silva', 'REC002', 29, 'ana.silva@pam.local', '$2b$12$L1RxA0TlZLI9zt9DVuC51u4Ti1WQ7HwS4GOHcGtEyhZa3UVz4gg0K', 'Dados e Tecnologia', 'Engenheira de Software', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'ana.silva@pam.local' OR MATRICULA = 'REC002');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Mariana Costa', 'REC003', 28, 'mariana.costa@pam.local', '$2b$12$yXPx0cUmJwdOswGU05mM3uOzi3WENV2f/.Gy6ZMZUvNev.g7JovCS', 'Dados e Tecnologia', 'Analista de Negócios', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'mariana.costa@pam.local' OR MATRICULA = 'REC003');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Bruno Oliveira', 'REC004', 31, 'bruno.oliveira@pam.local', '$2b$12$HRXDxtT.jzGaNX..fvoBb.HK4wLRXKMJYGXN0I3l64kUyE2qXKJbG', 'Dados e Tecnologia', 'Desenvolvedor Backend', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'bruno.oliveira@pam.local' OR MATRICULA = 'REC004');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'João Victor Lima', 'REC005', 27, 'joao.lima@pam.local', '$2b$12$tLk8v2h5QxCeTAS9eJKAR.35tinIRklZaKWerhVQBiJlKIUJmMGNW', 'Dados e Tecnologia', 'Desenvolvedor Frontend', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'joao.lima@pam.local' OR MATRICULA = 'REC005');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Fernanda Souza', 'REC006', 30, 'fernanda.souza@pam.local', '$2b$12$UBXiIrq2dlGAGe5cRiSs.e3KiQsjcggN2NiYp7HDnZn5LvwFnnU1W', 'Dados e Tecnologia', 'QA / Analista de Testes', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'fernanda.souza@pam.local' OR MATRICULA = 'REC006');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Marcos Vinícius Rocha', 'REC007', 33, 'marcos.rocha@pam.local', '$2b$12$NGUCoelBmqr3AC.bOUFn2Obwoh1V0INXFujY1jETaNbGC2FiWqZ2S', 'Dados e Tecnologia', 'Engenheiro de Dados', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'marcos.rocha@pam.local' OR MATRICULA = 'REC007');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Beatriz Fernandes', 'REC008', 26, 'beatriz.fernandes@pam.local', '$2b$12$3yCOI4xP21lafGBBEVmM6.uuRl/QJB1D67FB5AcRtqrNOtn.bRmza', 'Dados e Tecnologia', 'UX/UI Designer', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'beatriz.fernandes@pam.local' OR MATRICULA = 'REC008');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Ricardo Nascimento', 'REC009', 34, 'ricardo.nascimento@pam.local', '$2b$12$8QeiJwBa/k7wZSvzp4tZc.1MSKR98vF5Q82yy9tuSUZAGIQUVpSwK', 'Dados e Tecnologia', 'DevOps Engineer', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'ricardo.nascimento@pam.local' OR MATRICULA = 'REC009');
INSERT INTO FUNCIONARIO
(NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, FK_GESTOR_ID, ATIVO)
SELECT 'Paula Martins', 'REC010', 29, 'paula.martins@pam.local', '$2b$12$RKThtyqL41XnFt1AIRzbT.0vIxLCHYfa0/U28XOJFOkkIjTyM4OAy', 'Dados e Tecnologia', 'Analista de Segurança', 'recurso', 0,
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1), 1
WHERE NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE EMAIL = 'paula.martins@pam.local' OR MATRICULA = 'REC010');
-- Garante o vínculo hierárquico mesmo quando os registros já existiam.
UPDATE FUNCIONARIO
SET FK_GESTOR_ID = (SELECT ID FROM (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1) AS gerente)
WHERE TIPO_PERFIL = 'recurso'
  AND EMAIL IN ('pedro.rodrigues@pam.local','ana.silva@pam.local','mariana.costa@pam.local',
                'bruno.oliveira@pam.local','joao.lima@pam.local','fernanda.souza@pam.local',
                'marcos.rocha@pam.local','beatriz.fernandes@pam.local','ricardo.nascimento@pam.local',
                'paula.martins@pam.local');

-- Projetos com orçamento, datas e progresso plausíveis.

INSERT INTO PROJETOS
(NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO, PROGRESSO, ATIVO)
SELECT 'Projeto Atlas', 'Dados e Analytics', 'Plataforma corporativa de indicadores e dashboards executivos.', 'andamento',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       '2026-01-12', '2026-11-30', 285000.00, 68.00, 1
WHERE NOT EXISTS (SELECT 1 FROM PROJETOS WHERE NOME = 'Projeto Atlas');
INSERT INTO PROJETOS
(NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO, PROGRESSO, ATIVO)
SELECT 'Projeto Horizonte', 'Desenvolvimento', 'Modernização do portal de atendimento ao cliente.', 'andamento',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       '2026-02-02', '2026-12-18', 420000.00, 54.00, 1
WHERE NOT EXISTS (SELECT 1 FROM PROJETOS WHERE NOME = 'Projeto Horizonte');
INSERT INTO PROJETOS
(NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO, PROGRESSO, ATIVO)
SELECT 'Projeto Prisma', 'Infraestrutura', 'Migração de serviços para infraestrutura em nuvem e automação DevOps.', 'andamento',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       '2025-11-03', '2026-09-30', 360000.00, 82.00, 1
WHERE NOT EXISTS (SELECT 1 FROM PROJETOS WHERE NOME = 'Projeto Prisma');
INSERT INTO PROJETOS
(NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO, PROGRESSO, ATIVO)
SELECT 'Projeto Orquídea', 'Segurança', 'Adequação de controles de acesso, auditoria e gestão de vulnerabilidades.', 'planejamento',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       '2026-08-03', '2027-02-26', 195000.00, 12.00, 1
WHERE NOT EXISTS (SELECT 1 FROM PROJETOS WHERE NOME = 'Projeto Orquídea');
INSERT INTO PROJETOS
(NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO, PROGRESSO, ATIVO)
SELECT 'Projeto Farol', 'Pesquisa e Inovação', 'Pesquisa com usuários e protótipo de aplicativo de autosserviço.', 'concluido',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       '2025-03-10', '2025-12-19', 148000.00, 100.00, 1
WHERE NOT EXISTS (SELECT 1 FROM PROJETOS WHERE NOME = 'Projeto Farol');
INSERT INTO PROJETOS
(NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO, PROGRESSO, ATIVO)
SELECT 'Projeto Vértice', 'Integração', 'Integração de sistemas internos via APIs e mensageria.', 'pausado',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       '2025-09-01', '2026-06-30', 230000.00, 40.00, 1
WHERE NOT EXISTS (SELECT 1 FROM PROJETOS WHERE NOME = 'Projeto Vértice');

-- Marcos e entregas: cada entrega aponta para o marco do respectivo projeto.

INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1), 'Descoberta e modelagem', 'Requisitos, fontes de dados e modelo dimensional aprovados', '2026-02-27', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND TITULO = 'Descoberta e modelagem'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Descoberta e modelagem' LIMIT 1),
       'Inventário das fontes', 'Mapeamento e classificação das fontes de dados', 'concluido', '2026-02-13'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Descoberta e modelagem' LIMIT 1)
    AND TITULO = 'Inventário das fontes'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Descoberta e modelagem' LIMIT 1),
       'Modelo dimensional', 'Modelo lógico e dicionário de dados', 'concluido', '2026-02-27'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Descoberta e modelagem' LIMIT 1)
    AND TITULO = 'Modelo dimensional'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1), 'Pipeline analítico', 'Pipelines de ingestão e transformação disponíveis', '2026-06-30', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND TITULO = 'Pipeline analítico'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Pipeline analítico' LIMIT 1),
       'Ingestão incremental', 'Carga incremental das fontes prioritárias', 'concluido', '2026-06-17'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Pipeline analítico' LIMIT 1)
    AND TITULO = 'Ingestão incremental'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Pipeline analítico' LIMIT 1),
       'Validação de qualidade', 'Regras de qualidade e reconciliação implementadas', 'concluido', '2026-06-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Pipeline analítico' LIMIT 1)
    AND TITULO = 'Validação de qualidade'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1), 'Painéis executivos', 'Painéis publicados e validados com áreas de negócio', '2026-10-30', 'Em andamento', 2, 0
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND TITULO = 'Painéis executivos'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Painéis executivos' LIMIT 1),
       'Dashboard financeiro', 'Painel de custos e orçamento', 'em andamento', '2026-10-23'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Painéis executivos' LIMIT 1)
    AND TITULO = 'Dashboard financeiro'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Painéis executivos' LIMIT 1),
       'Dashboard operacional', 'Indicadores operacionais e filtros', 'pendente', '2026-10-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1) AND TITULO = 'Painéis executivos' LIMIT 1)
    AND TITULO = 'Dashboard operacional'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1), 'Levantamento funcional', 'Jornadas e requisitos funcionais validados', '2026-03-20', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND TITULO = 'Levantamento funcional'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Levantamento funcional' LIMIT 1),
       'Mapa de jornadas', 'Jornadas prioritárias documentadas', 'concluido', '2026-03-13'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Levantamento funcional' LIMIT 1)
    AND TITULO = 'Mapa de jornadas'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Levantamento funcional' LIMIT 1),
       'Protótipo navegável', 'Protótipo validado com usuários-chave', 'concluido', '2026-03-20'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Levantamento funcional' LIMIT 1)
    AND TITULO = 'Protótipo navegável'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1), 'Implementação do portal', 'Funcionalidades prioritárias implementadas', '2026-08-28', 'Em andamento', 2, 1
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND TITULO = 'Implementação do portal'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Implementação do portal' LIMIT 1),
       'Autenticação e perfil', 'Fluxos de autenticação e perfil', 'concluido', '2026-07-31'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Implementação do portal' LIMIT 1)
    AND TITULO = 'Autenticação e perfil'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Implementação do portal' LIMIT 1),
       'Área de solicitações', 'Abertura e acompanhamento de solicitações', 'em andamento', '2026-08-28'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Implementação do portal' LIMIT 1)
    AND TITULO = 'Área de solicitações'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1), 'Homologação e publicação', 'Testes de aceitação e publicação da versão', '2026-12-18', 'Pendente', 2, 0
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND TITULO = 'Homologação e publicação'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Homologação e publicação' LIMIT 1),
       'Testes de aceitação', 'Roteiros e evidências de aceite', 'pendente', '2026-12-04'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Homologação e publicação' LIMIT 1)
    AND TITULO = 'Testes de aceitação'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Homologação e publicação' LIMIT 1),
       'Publicação produtiva', 'Plano de implantação e rollback', 'pendente', '2026-12-18'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1) AND TITULO = 'Homologação e publicação' LIMIT 1)
    AND TITULO = 'Publicação produtiva'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1), 'Preparação da nuvem', 'Ambientes, redes e controles básicos configurados', '2026-01-30', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND TITULO = 'Preparação da nuvem'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Preparação da nuvem' LIMIT 1),
       'Arquitetura alvo', 'Arquitetura e plano de migração', 'concluido', '2026-01-16'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Preparação da nuvem' LIMIT 1)
    AND TITULO = 'Arquitetura alvo'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Preparação da nuvem' LIMIT 1),
       'Ambiente de homologação', 'Ambiente de homologação provisionado', 'concluido', '2026-01-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Preparação da nuvem' LIMIT 1)
    AND TITULO = 'Ambiente de homologação'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1), 'Migração de serviços', 'Serviços prioritários migrados e monitorados', '2026-06-30', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND TITULO = 'Migração de serviços'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Migração de serviços' LIMIT 1),
       'Migração serviço A', 'Migração e smoke tests do serviço A', 'concluido', '2026-05-15'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Migração de serviços' LIMIT 1)
    AND TITULO = 'Migração serviço A'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Migração de serviços' LIMIT 1),
       'Migração serviço B', 'Migração e smoke tests do serviço B', 'concluido', '2026-06-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Migração de serviços' LIMIT 1)
    AND TITULO = 'Migração serviço B'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1), 'Estabilização', 'Alertas, documentação e transferência operacional', '2026-09-30', 'Em andamento', 2, 1
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND TITULO = 'Estabilização'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Estabilização' LIMIT 1),
       'Monitoramento', 'Dashboards e alertas configurados', 'concluido', '2026-09-12'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Estabilização' LIMIT 1)
    AND TITULO = 'Monitoramento'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Estabilização' LIMIT 1),
       'Runbook operacional', 'Procedimentos de operação e contingência', 'em andamento', '2026-09-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1) AND TITULO = 'Estabilização' LIMIT 1)
    AND TITULO = 'Runbook operacional'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1), 'Diagnóstico de segurança', 'Inventário de riscos e plano de remediação priorizado', '2026-10-30', 'Em andamento', 2, 0
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND TITULO = 'Diagnóstico de segurança'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Diagnóstico de segurança' LIMIT 1),
       'Matriz de riscos', 'Riscos classificados por impacto e probabilidade', 'em andamento', '2026-10-16'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Diagnóstico de segurança' LIMIT 1)
    AND TITULO = 'Matriz de riscos'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Diagnóstico de segurança' LIMIT 1),
       'Plano de remediação', 'Plano de ações priorizadas', 'pendente', '2026-10-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Diagnóstico de segurança' LIMIT 1)
    AND TITULO = 'Plano de remediação'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1), 'Controles de acesso', 'Papéis, permissões e trilhas de auditoria definidos', '2026-12-18', 'Pendente', 2, 0
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND TITULO = 'Controles de acesso'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Controles de acesso' LIMIT 1),
       'Matriz de acesso', 'Matriz de papéis e permissões', 'pendente', '2026-12-04'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Controles de acesso' LIMIT 1)
    AND TITULO = 'Matriz de acesso'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Controles de acesso' LIMIT 1),
       'Trilha de auditoria', 'Eventos críticos registrados e consultáveis', 'pendente', '2026-12-18'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Controles de acesso' LIMIT 1)
    AND TITULO = 'Trilha de auditoria'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1), 'Validação final', 'Testes de segurança e relatório final', '2027-02-26', 'Pendente', 2, 0
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND TITULO = 'Validação final'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Validação final' LIMIT 1),
       'Testes de controles', 'Evidências de teste e correções', 'pendente', '2027-02-12'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Validação final' LIMIT 1)
    AND TITULO = 'Testes de controles'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Validação final' LIMIT 1),
       'Relatório final', 'Relatório executivo e aceite', 'pendente', '2027-02-26'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1) AND TITULO = 'Validação final' LIMIT 1)
    AND TITULO = 'Relatório final'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1), 'Pesquisa com usuários', 'Pesquisa, entrevistas e síntese de oportunidades', '2025-05-30', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND TITULO = 'Pesquisa com usuários'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Pesquisa com usuários' LIMIT 1),
       'Entrevistas', 'Entrevistas com usuários e síntese', 'concluido', '2025-05-16'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Pesquisa com usuários' LIMIT 1)
    AND TITULO = 'Entrevistas'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Pesquisa com usuários' LIMIT 1),
       'Personas e jornada', 'Personas e jornada atual', 'concluido', '2025-05-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Pesquisa com usuários' LIMIT 1)
    AND TITULO = 'Personas e jornada'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1), 'Protótipo e validação', 'Protótipo avaliado e melhorias priorizadas', '2025-09-26', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND TITULO = 'Protótipo e validação'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Protótipo e validação' LIMIT 1),
       'Protótipo de alta fidelidade', 'Fluxos principais prototipados', 'concluido', '2025-09-12'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Protótipo e validação' LIMIT 1)
    AND TITULO = 'Protótipo de alta fidelidade'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Protótipo e validação' LIMIT 1),
       'Teste de usabilidade', 'Sessões e relatório de usabilidade', 'concluido', '2025-09-26'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Protótipo e validação' LIMIT 1)
    AND TITULO = 'Teste de usabilidade'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1), 'Entrega e encerramento', 'Pacote final de documentação e apresentação', '2025-12-19', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND TITULO = 'Entrega e encerramento'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Entrega e encerramento' LIMIT 1),
       'Documentação funcional', 'Requisitos e especificação final', 'concluido', '2025-12-05'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Entrega e encerramento' LIMIT 1)
    AND TITULO = 'Documentação funcional'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Entrega e encerramento' LIMIT 1),
       'Apresentação executiva', 'Resultados e próximos passos apresentados', 'concluido', '2025-12-19'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1) AND TITULO = 'Entrega e encerramento' LIMIT 1)
    AND TITULO = 'Apresentação executiva'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1), 'Desenho de integração', 'Contratos de API e arquitetura de integração definidos', '2025-10-31', 'Concluído', 2, 2
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND TITULO = 'Desenho de integração'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Desenho de integração' LIMIT 1),
       'Catálogo de APIs', 'APIs e sistemas consumidores mapeados', 'concluido', '2025-10-17'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Desenho de integração' LIMIT 1)
    AND TITULO = 'Catálogo de APIs'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Desenho de integração' LIMIT 1),
       'Contratos de integração', 'Esquemas e contratos documentados', 'concluido', '2025-10-31'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Desenho de integração' LIMIT 1)
    AND TITULO = 'Contratos de integração'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1), 'Implementação de conectores', 'Conectores e tratamento de falhas implementados', '2026-03-31', 'Em andamento', 2, 1
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND TITULO = 'Implementação de conectores'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Implementação de conectores' LIMIT 1),
       'Conector CRM', 'Integração com sistema de relacionamento', 'concluido', '2026-02-27'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Implementação de conectores' LIMIT 1)
    AND TITULO = 'Conector CRM'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Implementação de conectores' LIMIT 1),
       'Fila de eventos', 'Mensageria e política de retry', 'em andamento', '2026-03-31'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Implementação de conectores' LIMIT 1)
    AND TITULO = 'Fila de eventos'
);
INSERT INTO MARCO (PROJETO_ID, TITULO, DESCRICAO, DATA_VENCIMENTO, STATUS, TOTAL_ENTREGAS, ENTREGAS_CONCLUIDAS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1), 'Testes integrados', 'Testes integrados e observabilidade completos', '2026-06-30', 'Pendente', 2, 0
WHERE NOT EXISTS (
  SELECT 1 FROM MARCO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND TITULO = 'Testes integrados'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Testes integrados' LIMIT 1),
       'Testes de contrato', 'Testes automatizados de contrato', 'pendente', '2026-06-15'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Testes integrados' LIMIT 1)
    AND TITULO = 'Testes de contrato'
);
INSERT INTO ENTREGA (MARCO_ID, TITULO, DESCRICAO, STATUS, DATA_ENTREGA)
SELECT (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Testes integrados' LIMIT 1),
       'Painel de integração', 'Métricas de latência e falhas', 'pendente', '2026-06-30'
WHERE NOT EXISTS (
  SELECT 1 FROM ENTREGA
  WHERE MARCO_ID = (SELECT ID FROM MARCO WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1) AND TITULO = 'Testes integrados' LIMIT 1)
    AND TITULO = 'Painel de integração'
);

-- Alocações: percentuais variam para representar dedicação parcial e integral.

INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       100.00, NULL, '2026-01-12', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND DATA_INICIO = '2026-01-12'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       50.00, NULL, '2026-01-12', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND DATA_INICIO = '2026-01-12'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       75.00, NULL, '2026-01-12', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND DATA_INICIO = '2026-01-12'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1),
       25.00, NULL, '2026-02-01', '2026-08-31', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1)
    AND DATA_INICIO = '2026-02-01'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       75.00, NULL, '2026-02-02', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND DATA_INICIO = '2026-02-02'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       100.00, NULL, '2026-02-02', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND DATA_INICIO = '2026-02-02'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       100.00, NULL, '2026-02-02', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND DATA_INICIO = '2026-02-02'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1),
       50.00, NULL, '2026-03-01', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1)
    AND DATA_INICIO = '2026-03-01'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1),
       50.00, NULL, '2026-02-02', '2026-08-31', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1)
    AND DATA_INICIO = '2026-02-02'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       50.00, NULL, '2025-11-03', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND DATA_INICIO = '2025-11-03'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       100.00, NULL, '2025-11-03', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND DATA_INICIO = '2025-11-03'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       25.00, NULL, '2025-11-03', '2026-06-30', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND DATA_INICIO = '2025-11-03'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       25.00, NULL, '2026-01-05', '2026-09-30', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND DATA_INICIO = '2026-01-05'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       75.00, NULL, '2026-08-03', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND DATA_INICIO = '2026-08-03'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       25.00, NULL, '2026-08-03', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND DATA_INICIO = '2026-08-03'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       25.00, NULL, '2026-08-15', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND DATA_INICIO = '2026-08-15'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       50.00, NULL, '2025-03-10', '2025-12-19', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND DATA_INICIO = '2025-03-10'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1),
       100.00, NULL, '2025-03-10', '2025-12-19', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1)
    AND DATA_INICIO = '2025-03-10'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       25.00, NULL, '2025-04-01', '2025-12-19', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND DATA_INICIO = '2025-04-01'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       50.00, NULL, '2025-09-01', NULL, 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND DATA_INICIO = '2025-09-01'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       25.00, NULL, '2025-09-01', '2026-06-30', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND DATA_INICIO = '2025-09-01'
);
INSERT INTO ALOCACOES_PROJETO
(PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DURACAO_ALOCACAO, DATA_INICIO, DATA_FIM, IS_EMPRESTADO, STATUS)
SELECT (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1),
       (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       25.00, NULL, '2025-09-01', '2026-06-30', 0, 'ativo'
WHERE NOT EXISTS (
  SELECT 1 FROM ALOCACOES_PROJETO
  WHERE PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND DATA_INICIO = '2025-09-01'
);

-- Lançamentos de horas regulares, distribuídos entre projetos e categorias.

INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Implementação e revisão técnica - REC001', 'desenvolvimento', 180, 180, '2026-09-14', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC001' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1),
       'Alinhamento de sprint e dependências - REC001', 'reuniao', 60, 60, '2026-09-15', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC001' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Testes, validação e documentação - REC001', 'teste', 120, 120, '2026-09-16', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC001' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Implementação e revisão técnica - REC002', 'desenvolvimento', 180, 180, '2026-09-15', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC002' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Alinhamento de sprint e dependências - REC002', 'reuniao', 60, 60, '2026-09-16', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC002' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       'Testes, validação e documentação - REC002', 'teste', 120, 120, '2026-09-14', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC002' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Implementação e revisão técnica - REC003', 'desenvolvimento', 180, 180, '2026-09-16', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC003' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       'Alinhamento de sprint e dependências - REC003', 'reuniao', 60, 60, '2026-09-14', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC003' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Testes, validação e documentação - REC003', 'teste', 120, 120, '2026-09-15', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC003' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Implementação e revisão técnica - REC004', 'desenvolvimento', 180, 180, '2026-09-14', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC004' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Alinhamento de sprint e dependências - REC004', 'reuniao', 60, 60, '2026-09-15', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC004' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1),
       'Testes, validação e documentação - REC004', 'teste', 120, 120, '2026-09-16', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC004' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Implementação e revisão técnica - REC005', 'desenvolvimento', 180, 180, '2026-09-15', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC005' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       'Alinhamento de sprint e dependências - REC005', 'reuniao', 60, 60, '2026-09-16', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC005' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Testes, validação e documentação - REC005', 'teste', 120, 120, '2026-09-14', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC005' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Implementação e revisão técnica - REC006', 'desenvolvimento', 180, 180, '2026-09-16', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC006' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Alinhamento de sprint e dependências - REC006', 'reuniao', 60, 60, '2026-09-14', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC006' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Testes, validação e documentação - REC006', 'teste', 120, 120, '2026-09-15', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC006' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC006' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Implementação e revisão técnica - REC007', 'desenvolvimento', 180, 180, '2026-09-14', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC007' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Alinhamento de sprint e dependências - REC007', 'reuniao', 60, 60, '2026-09-15', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC007' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1),
       'Testes, validação e documentação - REC007', 'teste', 120, 120, '2026-09-16', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Vértice' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC007' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       'Implementação e revisão técnica - REC008', 'desenvolvimento', 180, 180, '2026-09-15', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC008' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Alinhamento de sprint e dependências - REC008', 'reuniao', 60, 60, '2026-09-16', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC008' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1),
       'Testes, validação e documentação - REC008', 'teste', 120, 120, '2026-09-14', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC008' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Farol' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC008' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Implementação e revisão técnica - REC009', 'desenvolvimento', 180, 180, '2026-09-16', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC009' AND DATA_LANCAMENTO = '2026-09-16'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       'Alinhamento de sprint e dependências - REC009', 'reuniao', 60, 60, '2026-09-14', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC009' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Testes, validação e documentação - REC009', 'teste', 120, 120, '2026-09-15', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC009' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       'Implementação e revisão técnica - REC010', 'desenvolvimento', 180, 180, '2026-09-14', '09:00:00', '12:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Implementação e revisão técnica - REC010' AND DATA_LANCAMENTO = '2026-09-14'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Alinhamento de sprint e dependências - REC010', 'reuniao', 60, 60, '2026-09-15', '13:00:00', '14:00:00', 'aprovado'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Alinhamento de sprint e dependências - REC010' AND DATA_LANCAMENTO = '2026-09-15'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       'Testes, validação e documentação - REC010', 'teste', 120, 120, '2026-09-16', '14:00:00', '16:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Testes, validação e documentação - REC010' AND DATA_LANCAMENTO = '2026-09-16'
);

-- Horas extras: lançamentos adicionais fora da jornada padrão.

INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Correção de divergência no fechamento do dashboard', 'desenvolvimento', 120, 120, '2026-09-18', '18:00:00', '20:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Correção de divergência no fechamento do dashboard' AND DATA_LANCAMENTO = '2026-09-18'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Ajuste emergencial no fluxo de autenticação', 'desenvolvimento', 120, 120, '2026-09-22', '18:30:00', '20:30:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Ajuste emergencial no fluxo de autenticação' AND DATA_LANCAMENTO = '2026-09-22'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Correção crítica antes da demonstração', 'desenvolvimento', 180, 180, '2026-09-24', '18:00:00', '21:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Correção crítica antes da demonstração' AND DATA_LANCAMENTO = '2026-09-24'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1),
       'Ajustes de acessibilidade e responsividade', 'desenvolvimento', 120, 120, '2026-09-25', '18:00:00', '20:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Horizonte' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Ajustes de acessibilidade e responsividade' AND DATA_LANCAMENTO = '2026-09-25'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Investigação de falha no pipeline de implantação', 'desenvolvimento', 180, 180, '2026-09-17', '18:00:00', '21:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Investigação de falha no pipeline de implantação' AND DATA_LANCAMENTO = '2026-09-17'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1),
       'Ajuste de alertas e validação de recuperação', 'desenvolvimento', 120, 120, '2026-09-21', '18:30:00', '20:30:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Prisma' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Ajuste de alertas e validação de recuperação' AND DATA_LANCAMENTO = '2026-09-21'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1),
       'Análise de vulnerabilidade reportada', 'desenvolvimento', 120, 120, '2026-10-05', '18:00:00', '20:00:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Orquídea' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Análise de vulnerabilidade reportada' AND DATA_LANCAMENTO = '2026-10-05'
);
INSERT INTO LANCAMENTOS_HORAS
(USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DURACAO, DATA_LANCAMENTO, HORA_INICIO, HORA_FIM, STATUS)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1),
       'Preparação de material para comitê executivo', 'desenvolvimento', 90, 90, '2026-10-07', '18:00:00', '19:30:00', 'pendente'
WHERE NOT EXISTS (
  SELECT 1 FROM LANCAMENTOS_HORAS
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND PROJETO_ID = (SELECT ID FROM PROJETOS WHERE NOME = 'Projeto Atlas' LIMIT 1)
    AND DESCRICAO_ATIVIDADE = 'Preparação de material para comitê executivo' AND DATA_LANCAMENTO = '2026-10-07'
);

-- Solicitações de aprovação de hora extra associadas ao gerente único.

INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1),
       'hora_extra', '2026-09-18', '2026-09-18', 120, 'Hora extra no projeto Projeto Atlas: correção de divergência no fechamento do dashboard', 'aprovado',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       'Aprovada pelo gerente para atender prazo do projeto.'
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC001' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-09-18'
    AND MOTIVO = 'Hora extra no projeto Projeto Atlas: correção de divergência no fechamento do dashboard'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1),
       'hora_extra', '2026-09-22', '2026-09-22', 120, 'Hora extra no projeto Projeto Horizonte: ajuste emergencial no fluxo de autenticação', 'pendente',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       NULL
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC002' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-09-22'
    AND MOTIVO = 'Hora extra no projeto Projeto Horizonte: ajuste emergencial no fluxo de autenticação'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1),
       'hora_extra', '2026-09-24', '2026-09-24', 180, 'Hora extra no projeto Projeto Horizonte: correção crítica antes da demonstração', 'pendente',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       NULL
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC004' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-09-24'
    AND MOTIVO = 'Hora extra no projeto Projeto Horizonte: correção crítica antes da demonstração'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1),
       'hora_extra', '2026-09-25', '2026-09-25', 120, 'Hora extra no projeto Projeto Horizonte: ajustes de acessibilidade e responsividade', 'pendente',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       NULL
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC005' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-09-25'
    AND MOTIVO = 'Hora extra no projeto Projeto Horizonte: ajustes de acessibilidade e responsividade'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1),
       'hora_extra', '2026-09-17', '2026-09-17', 180, 'Hora extra no projeto Projeto Prisma: investigação de falha no pipeline de implantação', 'aprovado',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       'Aprovada pelo gerente para atender prazo do projeto.'
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC007' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-09-17'
    AND MOTIVO = 'Hora extra no projeto Projeto Prisma: investigação de falha no pipeline de implantação'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1),
       'hora_extra', '2026-09-21', '2026-09-21', 120, 'Hora extra no projeto Projeto Prisma: ajuste de alertas e validação de recuperação', 'pendente',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       NULL
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC009' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-09-21'
    AND MOTIVO = 'Hora extra no projeto Projeto Prisma: ajuste de alertas e validação de recuperação'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1),
       'hora_extra', '2026-10-05', '2026-10-05', 120, 'Hora extra no projeto Projeto Orquídea: análise de vulnerabilidade reportada', 'pendente',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       NULL
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC010' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-10-05'
    AND MOTIVO = 'Hora extra no projeto Projeto Orquídea: análise de vulnerabilidade reportada'
);
INSERT INTO SOLITICACAO
(USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, HORAS, MOTIVO, STATUS, APROVADO_POR, OBSERVACAO_APROVACAO)
SELECT (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1),
       'hora_extra', '2026-10-07', '2026-10-07', 90, 'Hora extra no projeto Projeto Atlas: preparação de material para comitê executivo', 'pendente',
       (SELECT ID FROM FUNCIONARIO WHERE EMAIL = 'rafael.gomes@pam.local' LIMIT 1),
       NULL
WHERE NOT EXISTS (
  SELECT 1 FROM SOLITICACAO
  WHERE USUARIO_ID = (SELECT ID FROM FUNCIONARIO WHERE MATRICULA = 'REC003' LIMIT 1)
    AND TIPO = 'hora_extra' AND DATA_INICIO = '2026-10-07'
    AND MOTIVO = 'Hora extra no projeto Projeto Atlas: preparação de material para comitê executivo'
);

COMMIT;

-- Consultas rápidas para conferir a massa após a execução:
SELECT TIPO_PERFIL, COUNT(*) AS TOTAL FROM FUNCIONARIO GROUP BY TIPO_PERFIL;
SELECT NOME, STATUS, ORCAMENTO, PROGRESSO FROM PROJETOS ORDER BY NOME;
SELECT COUNT(*) AS TOTAL_MARCOS FROM MARCO;
SELECT COUNT(*) AS TOTAL_ENTREGAS FROM ENTREGA;
SELECT COUNT(*) AS TOTAL_ALOCACOES FROM ALOCACOES_PROJETO;
SELECT COUNT(*) AS TOTAL_LANCAMENTOS FROM LANCAMENTOS_HORAS;
SELECT COUNT(*) AS TOTAL_HORAS_EXTRAS FROM LANCAMENTOS_HORAS WHERE HORA_FIM > '18:00:00';
SELECT COUNT(*) AS TOTAL_SOLICITACOES_EXTRA FROM SOLITICACAO WHERE TIPO = 'hora_extra';
