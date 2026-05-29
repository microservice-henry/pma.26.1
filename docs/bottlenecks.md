# Bottlenecks

Gargalos identificados e solucionados no projeto, com análise do problema, solução implementada e evidência no código.

---

## Henry Idesis — Order API

### 1. Resiliência: Fallback quando Exchange Service cai

O `OrderService` implementa fallback gracioso: quando o Exchange Service está indisponível, em vez de retornar 500, o pedido é devolvido em USD com taxa 1.

```java
} catch (FeignException e) {
    // Fallback to storage currency (USD) when exchange service is unavailable.
    return BigDecimal.ONE;
}
```

| Cenário | Antes | Depois |
|---------|-------|--------|
| Exchange fora do ar | 500 (crash) | 200 em USD (fallback) |
| Moeda inválida | 500 (crash) | 422 com mensagem clara |

### 2. Observabilidade: Métricas do Gateway com Prometheus + Grafana

O Gateway expõe métricas via Spring Boot Actuator. O Prometheus coleta a cada 1 segundo e o Grafana visualiza em tempo real.

### 3. Performance: Índices no banco de dados

```sql
CREATE INDEX idx_orders_account_date ON orders.orders (id_account, date);
CREATE INDEX idx_order_items_order ON orders.order_items (id_order);
```

!!! info "Documentação detalhada"
    Ver [documentação individual de Henry](https://microservice-henry.github.io/pma.26.1-docs/bottlenecks/) para análise completa com diagramas e testes.

---

## Kauã — Exchange API

### 1. Cache Redis com TTL de 60 segundos

Requisições repetidas para o mesmo par de moedas são respondidas diretamente do Redis, sem chamar a AwesomeAPI externa.

```python
cache_key = f"exchange:rate:{par}"
cached = await r.get(cache_key)
if cached:
    data = json.loads(cached)
    return {"rate": data["sell"]}

# somente na primeira requisição chama a API externa
await r.setex(cache_key, CACHE_TTL, json.dumps(armazenavel))
```

| Cenário | Comportamento |
|---------|--------------|
| Primeira requisição (cache miss) | Chama AwesomeAPI, armazena no Redis por 60s |
| Requisições seguintes (cache hit) | Respondidas direto do Redis, sem chamada externa |

---

### 2. Graceful Degradation do Cache

Se o Redis estiver indisponível, o serviço não cai — faz fallback direto para a AwesomeAPI, mantendo disponibilidade total.

```python
async def cache_conn() -> aioredis.Redis | None:
    try:
        _cache = aioredis.Redis(host=REDIS_HOST, port=REDIS_PORT)
        await _cache.ping()
    except Exception:
        _cache = None  # fallback: sem cache, mas o serviço continua
    return _cache
```

| Cenário | Antes | Depois |
|---------|-------|--------|
| Redis fora do ar | Serviço crashava com erro de conexão | Serviço continua respondendo via AwesomeAPI |

---

## Nathan — Product API

### 1. Cache Redis em `@Cacheable` (TTL 60s)

Consultas repetidas ao mesmo produto são servidas direto do Redis, sem queries ao PostgreSQL.

| Métrica | Sem cache | Com cache |
|---------|-----------|-----------|
| Tempo de resposta | 26ms | 4ms |
| Speedup | — | **8x** |
| Queries no Postgres | 1 por requisição | 0 (dentro do TTL) |

---

### 2. Métricas nativas de cache via Micrometer + Actuator

O serviço expõe métricas de cache hit/miss via Spring Actuator, acessíveis em `/actuator/prometheus` e `/actuator/caches/products`, integradas ao Prometheus para monitoramento em tempo real.
