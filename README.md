# Projeto Final Segundo Bimestre

Esse projeto foi desenvolvido como prática de Banco de Dados, simulando uma plataforma de streaming chamada StreamFlow.

A ideia foi criar toda a estrutura do sistema, desde clientes até histórico de reprodução e consultas para análise de dados.

---

## 📌 Sobre o Banco de Dados

O StreamFlow simula um serviço de streaming onde usuários podem:

- Criar contas
- Escolher planos de assinatura
- Criar perfis dentro da conta
- Assistir vídeos (filmes e séries)
- Ter histórico de reprodução
- Consultar dados de consumo

---

## 🗄️ Estrutura do banco

O banco é composto pelas seguintes tabelas:

- Clientes
- Planos
- Assinaturas
- Perfis
- Categorias
- Produtoras
- Vídeos
- Históricos

---

## 🔗 Relacionamentos

- Um cliente pode ter uma assinatura
- Um cliente pode ter vários perfis
- Um vídeo pertence a uma categoria e produtora
- O histórico registra o que cada perfil assistiu

---

## 📊 Consultas criadas

O projeto também inclui consultas para análise de dados:

- Perfis com conteúdo em andamento (continuar assistindo)
- Consumo de tempo por produtora
- Relatório de acessos por região e dispositivo
- Visualização de idade dos clientes

---

## 🛠️ Linguagens

- MySQL
- SQL
---

## 👩‍💻 Desenvolvido por

Beatriz Batista  
ETEC Zona Leste — 3º DS/AMS
