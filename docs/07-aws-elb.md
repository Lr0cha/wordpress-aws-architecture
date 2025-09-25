<div align="center">
<h1>Elastic Load Balancer (ELB)</h1>
</div>

1. No console da AWS, pesquise por **EC2** e vá em **Load Balancers**. 
2. Clique em **`Create Load Balancer`**. 
3. Escolha **Application Load Balancer**. 

<details>
<summary>📷 Criação do ALB</summary>
<div align="center">
  <img alt="Criação do ALB" src="https://github.com/user-attachments/assets/51000baf-fc48-404e-953c-def7ecc0bb35" width="80%" />
  <br />
  <i>Figura 1 – Criação do ALB</i>
</div>
</details>

> [!NOTE] 
> O ALB precisa estar em **subnets públicas** para receber tráfego externo.

---

### Configurações principais

- **Nome:** Defina um nome para identificar o ALB. 
- **Scheme:** Internet-facing. 
- **IP address type:** IPv4. 
- **VPC:** Selecione a criada anteriormente. 
- **Subnets:** Selecione as **duas subnets públicas** (ex.: us-east-1a e us-east-1b). 

---

### Configuração de Security Group

- Associe o **Security Group [elb-sg](./05-aws-sgs.md)**. 

---

### Listeners e Target Groups

- **Listener:** Clique em **Create a target** e configure um listener HTTP (porta 80). 
- **Target Group:** 
  - Tipo: Instances. 
  - Protocolo: HTTP. 
  - Porta: 80. 
  - VPC: Selecione a mesma usada para as EC2. 

<details>
<summary>📷 Criação do Target Group</summary>
<div align="center">
  <img alt="Criação do Target Group" src="https://github.com/user-attachments/assets/b9f27420-a4c7-4c69-b77b-4469e499ecde" width="80%" />
  <br />
  <i>Criação do Target Group</i>
</div>
</details>

> [!NOTE] 
> O Target Group deve apontar para as instâncias **EC2 do Auto Scaling Group**. 

---

## Resource Map

<div align="center">
  <img alt="Resource Map do ALB" src="https://github.com/user-attachments/assets/52759fb4-1b8f-4940-8475-554a521a7332"/>
  <br />
  <i>Figura 3 – Resource Map do ALB</i>
</div>

> [!IMPORTANT] 
> O Target Group deve apontar para as instâncias **EC2 do Auto Scaling Group**. 
