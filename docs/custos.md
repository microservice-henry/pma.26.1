# Custos & SLA

## Modelo de Serviço (PaaS vs IaaS)

| Componente | Modelo | Quem gerencia |
|------------|--------|--------------|
| EKS Control Plane | **PaaS** | AWS gerencia master nodes, etcd, API server |
| EC2 Node Group | IaaS | O grupo gerencia os workers |
| NLB | **PaaS** | AWS gerencia roteamento e failover |
| Docker Hub | **PaaS** | Docker Inc. gerencia o registry |
| GitHub Pages (docs) | **PaaS** | GitHub gerencia o hosting |
| PostgreSQL em pod K8s | IaaS | O grupo gerencia backup, HA, atualizações |

!!! info "Por que EKS é PaaS?"
    Com EKS, você não gerencia os master nodes do Kubernetes — a AWS cuida de alta disponibilidade, patches e atualizações do control plane. Você só gerencia o que roda nos workers.

---

## Estimativa de Custos por Hora

Valores de referência (us-east-2, Mai/2026):

| Recurso | Tipo | Qtd | Custo/hora |
|---------|------|-----|-----------|
| EKS Control Plane | PaaS | 1 cluster | $0,10 |
| EC2 Workers | `t3.medium` | 1 node | $0,0416 |
| NLB | Network Load Balancer | 1 | $0,008 + tráfego |
| **Total estimado** | | | **~$0,15/hora** |

---

## Custo Estimado por Evento

| Cenário | Duração | Custo estimado |
|---------|---------|---------------|
| Apresentação (cluster ativo) | ~2 horas | ~$0,30 |
| Semana de testes | ~40 horas | ~$6,00 |
| Cluster esquecido ligado | 720h (1 mês) | ⚠️ ~$108,00 |

---

## SLA dos Serviços AWS

| Serviço | SLA AWS | Impacto se cair |
|---------|---------|----------------|
| EKS Control Plane | 99,95% | Deploys e scaling param |
| EC2 (nodes) | 99,99% | Pods ficam offline |
| NLB | 99,99% | API inacessível externamente |

O SLA composto da aplicação é limitado pelo componente mais frágil. Com EKS + NLB, o SLA teórico é **≤ 99,95%** — até ~4,4 horas de downtime por ano no pior caso.

---

## Estratégia de Teardown

```bash
# 1. Deletar services LoadBalancer (libera o NLB)
kubectl delete svc gateway

# 2. Deletar node group (para as EC2s)
eksctl delete nodegroup --cluster eks-store --name ng-store --region us-east-2

# 3. Deletar cluster EKS (para o control plane)
eksctl delete cluster --name eks-store --region us-east-2

# 4. Confirmar que não há recursos órfãos
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' \
  --output table

aws elbv2 describe-load-balancers --output table
```

!!! warning "Verifique sempre após deletar"
    Load Balancers e EBS volumes podem persistir mesmo após `eksctl delete cluster`. Verifique no Console AWS → EC2 → Load Balancers.
