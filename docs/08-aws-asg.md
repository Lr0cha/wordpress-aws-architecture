<div align="center">
<h1>Auto Scaling Group (ASG)</h1>
</div>

1. No console da AWS, pesquise por **EC2** e vá em **Auto Scaling Groups**. 
2. Clique em **`Create Auto Scaling Group`**. 
3. Associe ao **Launch Template** previamente configurado. 

> [!NOTE] 
> O Auto Scaling Group precisa estar associado às **subnets privadas**.

---

### Configurações principais

- **Nome:** Defina um identificador para o ASG. 
- **Launch Template:** Selecione o criado anteriormente. 
- **VPC e Subnets:** Selecione as subnets privadas criadas. 
- **Load Balancer:** Associe ao **Application Load Balancer (ALB)** configurado.

<details>
<summary>📷 Criação do ASG (Network)</summary>
<div align="center">
  <img alt="Criação do ASG" src="https://github.com/user-attachments/assets/a081a8d3-b97a-4323-8477-40c76b186929" width="80%" />
  <br />
  <i>Figura 1 – Criação do Auto Scaling Group (Network)</i>
</div>
</details> 

<details>
<summary>📷 Seleção do ALB para o ASG</summary>
<div align="center">
  <img alt="Seleção de Subnets no ASG" src="https://github.com/user-attachments/assets/62b6133e-5242-4db5-a200-78fc50bde02e" width="80%" />
  <br />
  <i>Figura 2 – Seleção do ALB para o ASG</i>
</div>
</details>

---

### Configuração de Escalabilidade (CPU)

- Defina o número **mínimo, desejado e máximo** de instâncias. 
- Configure políticas de escalabilidade (ex.: baseado em **CPU Utilization**). 

<details>
<summary>📷 Configuração de escalabilidade</summary>
<div align="center">
  <img alt="Configuração de Escalabilidade no ASG" src="https://github.com/user-attachments/assets/0ef29ad8-bbdb-4520-8ad9-8bc3ea024e9c" width="80%" />
  <br />
  <i>Figura 3 – Configuração de Escalabilidade</i>
</div>
</details>

> [!TIP] 
> Configure **CloudWatch Alarms**. 

> [!IMPORTANT]\
> O Auto Scaling deve estar integrado ao **ALB** para distribuir tráfego entre as instâncias.

<div align="center">
  <a href="./07-aws-elb.md">◀️</a> |
</div>
