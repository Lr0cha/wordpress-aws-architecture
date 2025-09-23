<div align="center">
  <h1>Relational Database Service (RDS)</h1>
</div>

## 1. Acessando o serviço
No console da AWS, pesquise e clique em **Aurora and RDS**.

<div align="center">
  <img alt="Tela inicial do RDS" src="https://github.com/user-attachments/assets/7744a9e7-ab99-45bb-8f9e-867094439c66" width="80%" />
  <br />
  <i>Figura 1 – Tela inicial do RDS</i>
</div>

---

## 2. Criando o banco de dados
- Clique em **Create database** 
- Selecione **Standard create** 
- Escolha o mecanismo **MySQL**

<div align="center">
  <img alt="Criação de instância MySQL" src="https://github.com/user-attachments/assets/71fd673e-a75e-4341-97c9-82f48d75d496" width="80%" />
  <br />
  <i>Figura 2 – Seleção do mecanismo MySQL</i>
</div>

- **Engine version:** escolha a mais recente disponível
- **Modelo de instância:** `Free tier`
- **Implantação:** `Single-AZ DB instance deployment (1 instance)`

<div align="center">
  <img alt="Configurações iniciais de instância RDS" src="https://github.com/user-attachments/assets/2f049aca-195a-48c1-b164-5d20f75b3dc9" width="80%" />
  <br />
  <i>Figura 3 – Configurações iniciais da instância</i>
</div>

---

## 3. Configuração de credenciais
- Nome da instância: `wordpress-db` 
- Usuário administrador: `admin`
- Método de autenticação: `Self managed` 
- Crie e confirme a senha 

> [!IMPORTANT]\
> Guarde essas credenciais com segurança. Serão necessárias para conectar o WordPress ao banco.

- **Tipo de instância:** `db.t3.micro`

---

## 4. Armazenamento
- Tipo de armazenamento: `gp3` 
- Tamanho inicial: `20 GiB` 

---

## 5. Rede
- Conectividade: `Don't connect to an EC2 compute resource`
- Tipo de IP: `IPv4` 
- VPC: selecione a criada anteriormente 
- Security group: selecione o **rds-sg** 

<div align="center">
  <img alt="Configuração de armazenamento" src="https://github.com/user-attachments/assets/62c1e1a0-32f2-46dd-8fc0-fe6a8c3357ef" width="80%" />
  <br />
  <i>Figura 4 – Configuração de armazenamento</i>
</div>

> [!NOTE]\
> A porta padrão do MySQL é **3306** (não altere).

---

## 6. Configurações adicionais
- **Banco de dados inicial:** `wordpress`
- **Backup automático:** desabilite para reduzir custos 

<div align="center">
  <img alt="Configuração adicional do banco de dados" src="https://github.com/user-attachments/assets/ab2e62da-00b2-492a-9b76-e1cd6a7fe170" width="80%" />
  <br />
  <i>Figura 5 – Configurações adicionais</i>
</div>

---

## 7. Finalização
- Revise as informações 
- Clique em **Create database** para provisionar a instância.
