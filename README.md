<div align="center">
  <h1>☁️ WordPress em Alta Disponibilidade na AWS</h1>
</div>

Este projeto utiliza a [imagem oficial do WordPress](https://hub.docker.com/_/wordpress) para criar uma aplicação via **Docker Compose**, distribuída em múltiplas instâncias **EC2** gerenciadas por um **Auto Scaling Group (ASG)**.  

- O balanceamento de carga é feito por um **Application Load Balancer (ALB)**.  
- O armazenamento de arquivos é centralizado via **Amazon Elastic File System (EFS)**.  
- O banco de dados da aplicação é hospedado em um **Amazon RDS (MySQL)**.  

<div align="center">
  <img alt="Arquitetura do projeto" src="https://github.com/user-attachments/assets/7fb0bb81-1dd3-4d32-9e15-a8e445b32bbd"/>
  <br />
  <i>Figura 1 - Arquitetura de alta disponibilidade do WordPress na AWS</i>
</div>

---

## 📑 Etapas do Projeto

1. [Criação da VPC](#)  
2. [Configuração da EC2 para desenvolvimento inicial](#)  
3. [Provisionamento do banco de dados no RDS](#) 
