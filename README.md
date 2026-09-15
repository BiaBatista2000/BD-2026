
# 🎬 Projeto Final: StreamFlow — 2º e 3º Bimestre

Esse projeto foi desenvolvido como prática da disciplina de **Banco de Dados II**, simulando uma plataforma de streaming chamada **StreamFlow**.

O objetivo foi desenvolver a estrutura de um banco de dados para uma plataforma de streaming, incluindo o cadastro de clientes, planos, assinaturas, perfis, vídeos, produtoras e o histórico de reprodução.

## 📌 Sobre o Banco de Dados

O StreamFlow simula um serviço de streaming onde os usuários podem:

* Criar contas;
* Escolher planos de assinatura;
* Criar perfis dentro da conta;
* Assistir a filmes e séries;
* Registrar o histórico de reprodução;
* Consultar dados de consumo;
* Realizar cobranças de assinatura;
* Gerar dados de faturamento das produtoras.

## 🗄️ Estrutura do Banco de Dados

O banco é composto pelas seguintes entidades:

* **Clientes**
* **Planos**
* **Assinaturas**
* **Perfis**
* **Categorias**
* **Produtoras**
* **Vídeos**
* **Históricos**

## 🔗 Relacionamentos

Os principais relacionamentos do banco são:

* Um cliente pode possuir uma assinatura;
* Um cliente pode possuir vários perfis;
* Um vídeo pertence a uma categoria;
* Um vídeo pertence a uma produtora;
* O histórico registra as reproduções realizadas por cada perfil.

## ⚙️ Procedures

Durante o desenvolvimento do projeto, foram criadas **procedures** para automatizar operações importantes do sistema.

Entre elas estão:

* **Cobrança de assinatura:** realiza a cobrança do valor da assinatura, verificando se o cliente possui saldo suficiente;
* **Registro de reprodução:** registra uma nova reprodução no histórico do perfil;
* **Faturamento mensal:** gera os dados de faturamento das produtoras com base nos minutos de conteúdo consumidos.

Essas procedures permitem automatizar operações que seriam realizadas repetidamente no sistema. O projeto também possui testes para verificar o comportamento dessas operações.

## 🔒 Triggers e Validações

Foram utilizadas **triggers** para garantir regras de integridade e segurança dos dados.

Entre as regras implementadas estão:

* Impedir que um cliente seja cadastrado com saldo negativo;
* Impedir que o saldo de um cliente seja atualizado para um valor negativo;
* Impedir alterações no histórico de produção/reprodução;
* Impedir a exclusão de registros do histórico.

Dessa forma, o banco consegue aplicar automaticamente regras importantes, evitando alterações indevidas nos dados.

## 📊 Consultas Criadas

Foram desenvolvidas consultas SQL para análise dos dados do sistema, incluindo:

* Perfis com conteúdos em andamento;
* Cálculo da idade dos clientes;
* Consulta de cliente por e-mail;
* Quantidade de minutos assistidos por produtora;
* Faturamento mensal das produtoras;
* Quantidade de acessos por estado;
* Quantidade de acessos de acordo com o dispositivo utilizado.

Essas consultas permitem obter informações importantes sobre o consumo dos usuários e o funcionamento da plataforma.

## 💰 Sistema de Cobrança

O projeto também possui um sistema de cobrança de assinatura.

Quando o cliente possui saldo suficiente, o valor da assinatura é descontado de sua conta e o novo saldo pode ser consultado.

Caso o saldo seja insuficiente, a cobrança não é realizada e o saldo anterior do cliente permanece inalterado.

## 📈 Faturamento das Produtoras

Foi implementado um processo para gerar o **faturamento mensal das produtoras**, considerando os minutos de conteúdo consumidos.

O sistema permite consultar informações como:

* Produtora;
* Competência;
* Minutos consumidos;
* Dados relacionados ao faturamento.

## 🛡️ Integridade dos Dados

O banco foi desenvolvido buscando manter a integridade das informações por meio de:

* Chaves primárias (**PK**);
* Chaves estrangeiras (**FK**);
* Relacionamentos entre tabelas;
* Procedures;
* Triggers;
* Validações;
* Regras de proteção do histórico.

## 🛠️ Tecnologias Utilizadas

* **MySQL**
* **SQL**

## 📚 Conteúdos Trabalhados

Durante o desenvolvimento do projeto foram trabalhados conceitos de:

* Modelagem de banco de dados;
* Criação e relacionamento de tabelas;
* Chaves primárias e estrangeiras;
* Consultas SQL;
* Funções;
* Procedures;
* Triggers;
* Integridade de dados;
* Manipulação de registros;
* Consultas para análise de dados.

## 📄 Documentação Completa

A documentação completa do projeto, contendo os códigos, testes, explicações e resultados desenvolvidos durante o 3º bimestre, está disponível no PDF:

**[📥 Projeto Final - BDII](./Projeto%20Final%20-%20BDII.pdf)**

## 👩‍💻 Desenvolvido por

**Beatriz Batista**

**ETEC Zona Leste — 3º DS/AMS**
