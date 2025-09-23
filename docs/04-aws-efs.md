<div align="center">
<h1>Elastic File System (EFS)</h1>
</div>

1. Pesquise e clique em **`EFS`** 

<div align="center">
  <img alt="Acesso ao EFS" src="https://github.com/user-attachments/assets/8cecbc99-a655-488a-9ed9-8c6399c47984" width="60%" />
  <br />
  <i>Figura 1 – Acesso ao EFS</i>
</div>

---

### 2. Criação do File System

1. Clique em **`Create file system`** 
2. Dê um nome para o seu File System 
3. Selecione a **VPC** criada anteriormente 
4. Clique em **`Customize`** 

<div align="center">
  <img alt="Customização do EFS" src="https://github.com/user-attachments/assets/59377a2d-6479-4c6e-a95e-3d0114b8d143" width="80%" />
  <br />
  <i>Figura 2 – Customização do EFS</i>
</div>

---

### 3. Configurações Iniciais

1. Confira o nome do seu EFS (alterar se necessário) 
2. Em **File system type**, selecione `Regional` 
3. **Desabilite** a opção de `Backups` 
4. Em **Availability and durability** selecione: 
   - `None` 
   - `None` 

<div align="center">
  <img alt="Configurações Iniciais do EFS" src="https://github.com/user-attachments/assets/00a72b3b-4b5e-4245-b9c2-5119756036bc" width="80%" />
  <br />
  <i>Figura 3 – Configurações Iniciais do EFS</i>
</div>

---

### 4. Performance e Throughput

1. Em **Throughput mode**, selecione `Bursting` 
2. Em **Performance mode**, selecione `General Purpose (Recommended)` 
3. Clique em **`Next`** 

<div align="center">
  <img alt="Configuração de Performance" src="https://github.com/user-attachments/assets/233779ae-18f6-42c7-865b-33e6a954255d" width="80%" />
  <br />
  <i>Figura 4 – Configuração de Performance</i>
</div>

---

### 5. Configurações de Rede

1. Em **Network**, selecione a **VPC** criada anteriormente 
2. Configure os mount targets: 
   - `us-east-1a` → **Subnet privada** correspondente + Security Group: `efs-sg` 
   - `us-east-1b` → **Subnet privada** correspondente + Security Group: `efs-sg` 
3. Clique em **`Next`** 

<div align="center">
  <img alt="Configuração de Rede do EFS" src="https://github.com/user-attachments/assets/98b479ae-9e9f-49c5-a173-c870a0b94f81" width="80%" />
  <br />
  <i>Figura 5 – Configuração de Rede do EFS</i>
</div>

---

### 6. Finalização

1. Não adicione **policies** 
2. Clique em **`Create`** 
3. Após a criação, volte à tela do EFS e clique em **Attach** 

> [!NOTE] 
> O comando exibido em **Attach** será utilizado no **script user-data** da EC2 para montar o EFS automaticamente.
