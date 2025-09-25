<div align="center">
<h1>Security Groups (SGs)</h1>
</div>

Para este projeto foram criados os seguintes **Security Groups (SGs)**:

> [!IMPORTANT]\
> Estas são as regras de **entrada** (IMBOUND RULES), as de saída deixei **All trafic**

> [!NOTE]\
> Todos os SGs são **stateful**, ou seja, se a conexão é permitida de entrada, a resposta de saída também será permitida automaticamente.


---

## 🔹 ELB Security Group (`elb-sg`)

<div align="center">

| Tipo | Protocolo | Porta | Origem    | Descrição                  |
|------|-----------|-------|-----------|----------------------------|
| HTTP | TCP       | 80    | 0.0.0.0/0 | Permite acesso público web |

</div>


## 🔹 EC2 Template Security Group (`ec2-template-sg`)

<div align="center">

| Tipo | Protocolo | Porta | Origem | Descrição                                    |
|------|-----------|-------|--------|----------------------------------------------|
| HTTP | TCP       | 80    | elb-sg | Permite tráfego HTTP vindo do Load Balancer  |

</div>


## 🔹 RDS Security Group (`rds-sg`)

<div align="center">

| Tipo        | Protocolo | Porta | Origem          | Descrição                                |
|-------------|-----------|-------|-----------------|------------------------------------------|
| MySQL/Aurora | TCP      | 3306  | ec2-template-sg | Permite conexão ao banco de dados via EC2 |

</div>


## 🔹 EFS Security Group (`efs-sg`)

<div align="center">

| Tipo | Protocolo | Porta | Origem          | Descrição                               |
|------|-----------|-------|-----------------|-----------------------------------------|
| NFS  | TCP       | 2049  | ec2-template-sg | Permite que instâncias EC2 montem o EFS |

</div>
