USE PAM;

-- Seed de usuários (senhas: ver README local)
INSERT INTO FUNCIONARIO (NOME, MATRICULA, IDADE, EMAIL, SENHA, DEPARTAMENTO, CARGO, TIPO_PERFIL, GESTOR, ATIVO)
VALUES
('Admin System', 'ADM001', 35, 'admin@pam.local', '$2b$12$l5F4OTUdh/tMFbOwkASkBu/4ctJYu2PdFKdpBddMCBwtSJ.EzvoTK', 'TI', 'Administrador', 'admin', 1, 1),
('Gerente Exemplo', 'GST001', 40, 'gestor@pam.local', '$2b$12$jwQxTXXNHqfBX16f3CPEfOi2YDCSk0u.LYCPUtA18Gj4icvqO/KuC', 'TI', 'Gerente de Projeto', 'gestor', 1, 1),
('Recurso Exemplo', 'REC001', 28, 'recurso@pam.local', '$2b$12$4.JjM1KIkZywjowvoxsc8.va29uIVn6XzAmNo0YtRb2dac7IEC5bK', 'TI', 'Desenvolvedor', 'recurso', 0, 1);

-- Seed de projetos
INSERT INTO PROJETOS (NOME, CATEGORIA, DESCRICAO, STATUS, GESTOR_ID, DATA_INICIO, DATA_ESTIMADA_FIM, ORCAMENTO)
VALUES
('Projeto Alpha', 'Desenvolvimento', 'Projeto de exemplo Alpha', 'andamento', 2, '2023-01-01', '2023-12-31', 100000.00),
('Projeto Beta', 'Pesquisa', 'Projeto de exemplo Beta', 'planejamento', 2, '2024-02-01', '2024-08-01', 50000.00);

-- Exemplo de alocação
INSERT INTO ALOCACOES_PROJETO (PROJETO_ID, USUARIO_ID, PERCENTUAL_ALOCACAO, DATA_INICIO, DATA_FIM, STATUS)
VALUES (1, 3, 100.00, '2024-01-01', NULL, 'ativo');

-- Exemplo de lançamento de horas
INSERT INTO LANCAMENTOS_HORAS (USUARIO_ID, PROJETO_ID, DESCRICAO_ATIVIDADE, CATEGORIA, DURACAO_MINUTOS, DATA_LANCAMENTO, STATUS)
VALUES (3, 1, 'Implementação de feature X', 'desenvolvimento', 120, '2024-09-01', 'aprovado');
