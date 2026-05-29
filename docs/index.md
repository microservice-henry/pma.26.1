# Store Platform

**Disciplina:** Plataformas, Microsserviços, DevOps e APIs — Insper 2026.1  
**Instrutor:** Humberto Sandmann

---

## Sobre o Projeto

Plataforma de e-commerce baseada em arquitetura de microsserviços, onde usuários autenticados podem criar e consultar pedidos com suporte a múltiplas moedas. O sistema é composto por cinco serviços independentes que se comunicam via Gateway com autenticação JWT.

---

## Membros do Grupo

| Aluno | Microsserviço | Documentação Individual |
|-------|--------------|------------------------|
| Henry Idesis | Order API | [microservice-henry.github.io/pma.26.1-docs](https://microservice-henry.github.io/pma.26.1-docs/) |
| Nathan Benaion | Product API | [microservice-henry.github.io/pma.261.product](https://microservice-henry.github.io/pma.261.product/) |
| Kauã Makiyama | Exchange API | [microservice-henry.github.io/pma.26.1.exchange](https://microservice-henry.github.io/pma.26.1.exchange/) |

---

## Repositórios

| Serviço | Repositório |
|---------|-------------|
| Plataforma (raiz) | [microservice-henry/pma.26.1](https://github.com/microservice-henry/pma.26.1) |
| Order API (contrato) | [microservice-henry/pma.261.order](https://github.com/microservice-henry/pma.261.order) |
| Order Service | [microservice-henry/pma.261.order-service](https://github.com/microservice-henry/pma.261.order-service) |
| Gateway Service | [microservice-henry/pma.261.gateway-service](https://github.com/microservice-henry/pma.261.gateway-service) |
| Account Service | [microservice-henry/pma.26.1.account-service](https://github.com/microservice-henry/pma.26.1.account-service) |
| Auth Service | [microservice-henry/pma.261.auth-service](https://github.com/microservice-henry/pma.261.auth-service) |
| Product Service | [microservice-henry/pma.261.product](https://github.com/microservice-henry/pma.261.product) |
| Exchange Service | [microservice-henry/pma.26.1.exchange](https://github.com/microservice-henry/pma.26.1.exchange) |
| Repositório do grupo | [repo-classes/pma.261](https://github.com/repo-classes/pma.261) |

---

## Status das Entregas

| Tarefa | Peso | Status |
|--------|------|--------|
| API Gateway | 5% | ✅ |
| Autenticação e Autorização | 5% | ✅ |
| Account Management | 5% | ✅ |
| Product Catalog | 5% | ✅ |
| Currency Exchange | 5% | ✅ |
| Bottlenecks | 20% | ✅ |
| AWS Cloud Setup | 5% | ✅ |
| Orquestração (EKS) | 10% | ✅ |
| CI/CD (Jenkins) | 10% | ✅ |
| Testes de Carga | 15% | *(a documentar)* |
| Custos & SLA | 10% | ✅ |
| Documentação (MkDocs) | 10% | ✅ |

---

## Vídeo de Apresentação

<iframe width="100%" height="400" src="https://youtu.be/1jqzBKDlxhY" title="Store Platform — Apresentação" frameborder="0" allowfullscreen></iframe>

---

## Uso de Inteligência Artificial

!!! info "Declaração de uso de IA"
    Durante o desenvolvimento, utilizamos o **Claude (Anthropic)** como ferramenta de apoio em tarefas pontuais: geração de código boilerplate, sugestões de melhoria e correção de erros. As decisões de arquitetura, a lógica de negócio e a estrutura dos serviços foram definidas e implementadas pelo grupo. Toda a documentação e o código foram revisados e validados em conjunto pelos membros, garantindo que todos compreendem e conseguem explicar cada parte do projeto.
