# Exchange API

**Responsável:** Kauã Makiyama
**Documentação individual:** [microservice-henry.github.io/pma.26.1.exchange](https://microservice-henry.github.io/pma.26.1.exchange/)

---

## Descrição

API REST em Python/FastAPI para consulta de taxas de câmbio em tempo real entre duas moedas. As cotações vêm da AwesomeAPI, são cacheadas em Redis por 60 segundos e o endpoint principal exige autenticação via JWT. Utilizada pelo Order Service para conversão de totais de pedidos quando o cliente solicita em moeda diferente de USD.

---

## Endpoints

| Método | Rota | Autenticação | Descrição |
|--------|------|-------------|-----------|
| `GET` | `/exchanges/health-check` | Pública | Verifica disponibilidade do serviço e do Redis |
| `GET` | `/exchanges/{from}/{to}` | Bearer JWT | Retorna a taxa de câmbio entre duas moedas (códigos de 3–5 letras maiúsculas) |

**Response 200 OK (`/exchanges/{from}/{to}`):**

```json
{
  "sell": 5.12,
  "buy": 5.08,
  "date": "2026-05-25 18:30:00",
  "id-account": "0195abfb-...",
  "cached": true
}
```

**Códigos de erro:** `401` (token inválido), `404` (par de moedas inexistente), `422` (formato inválido), `502` (timeout >10s na AwesomeAPI).

---

## Stack

| Tecnologia | Versão | Função |
|-----------|--------|--------|
| Python | 3.12 | Linguagem |
| FastAPI | 0.115.0 | Framework web |
| Uvicorn | 0.32.0 | Servidor ASGI |
| httpx | ≥0.28.1 | HTTP assíncrono para a AwesomeAPI |
| python-jose | 3.3.0 | Validação de JWT |
| redis | ≥5.0.0 | Cache (TTL 60s) |
| Docker | — | Containerização |
| AwesomeAPI | — | Provedor externo de cotações |

---

## Variáveis de ambiente

| Variável | Default | Função |
|----------|---------|--------|
| `JWT_SECRET` | `secret` | Chave de validação do JWT (trocar em produção) |
| `JWT_ALGORITHM` | `HS256` | Algoritmo do JWT |
| `REDIS_HOST` | `localhost` | Host do Redis |
| `REDIS_PORT` | `6379` | Porta do Redis |

---

## Bottlenecks implementados

| # | Bottleneck | Solução |
|---|---|---|
| 3 | Cache Redis (60s TTL) | Requisições repetidas para o mesmo par de moedas dentro da janela são respondidas direto do Redis, sem chamar a AwesomeAPI |
| 6 | Graceful degradation do cache | Falha no Redis não derruba o serviço — fallback consulta a AwesomeAPI diretamente, mantendo disponibilidade |

---

## Repositórios

| Módulo | Link |
|--------|------|
| Exchange Service | [microservice-henry/pma.26.1.exchange](https://github.com/microservice-henry/pma.26.1.exchange) |

---

!!! info "Documentação completa"
    Para endpoints detalhados com exemplos, fluxo de requisição, código completo e detalhes dos bottlenecks, acesse a [documentação individual de Kauã](https://microservice-henry.github.io/pma.26.1.exchange/).
