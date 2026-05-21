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

## Nathan — Exchange API

!!! note "A preencher"
    Nathan deve adicionar aqui os bottlenecks implementados na Exchange API (mínimo 2).

---

## Kauã — Product API

!!! note "A preencher"
    Kauã deve adicionar aqui os bottlenecks implementados na Product API (mínimo 2).
