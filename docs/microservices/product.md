# Product API

**Responsável:** Nathan Benaion
**Documentação individual:** [microservice-henry.github.io/pma.261.product](https://microservice-henry.github.io/pma.261.product/)

---

## Descrição

API REST para gerenciamento do catálogo de produtos da loja — criação, listagem (com filtro opcional por nome), consulta individual e remoção. É a fonte de verdade que o Order Service consulta via OpenFeign para enriquecer os itens de cada pedido com nome e preço atualizados.

Para suportar a carga típica de catálogos (poucas escritas, muitas leituras repetidas dos mesmos `id`), o serviço implementa **cache Redis** com TTL de 60 segundos e expõe **métricas Prometheus** via Spring Actuator.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/products` | Cria um novo produto |
| `GET` | `/products` | Lista produtos (filtro opcional `?name=`) |
| `GET` | `/products/{id}` | Busca produto por id (servido por cache) |
| `DELETE` | `/products/{id}` | Remove produto (e invalida cache) |

Todas as rotas autenticadas exigem o header `id-account` (injetado pelo Gateway após validar o JWT).

---

## Stack

| Tecnologia | Versão |
|-----------|--------|
| Java | 25 |
| Spring Boot | 4.0.3 |
| Spring Data JPA | 4.0.3 |
| Spring Boot Starter Cache | 4.0.3 |
| Spring Boot Starter Data Redis | 4.0.3 |
| Spring Boot Starter Actuator | 4.0.3 |
| Micrometer Registry Prometheus | runtime |
| PostgreSQL | 16 (schema `products`) |
| Redis | 7-alpine |
| Flyway | 4.0.3 |
| Docker image | `microservice-henry/product:latest` |

---

## Bottlenecks implementados

| # | Bottleneck | Speedup mensurado |
|---|---|---|
| 1 | Cache Redis em `@Cacheable` (TTL 60s, prefix `products::`) | **8×** (26ms → 4ms); 6 GETs HTTP → 0 queries no Postgres |
| 2 | Métricas nativas de cache via Micrometer + Actuator | qualitativo (`/actuator/prometheus`, `/actuator/caches/products`) |

---

## Repositórios

| Módulo | Link |
|--------|------|
| Product Service | [microservice-henry/pma.261.product](https://github.com/microservice-henry/pma.261.product) |

---

!!! info "Documentação completa"
    Para endpoints detalhados com exemplos `cURL`/`Python`, modelo de erro RFC 7807, decisões de arquitetura, guia de development e detalhes dos bottlenecks, acesse a [documentação individual de Nathan](https://microservice-henry.github.io/pma.261.product/).
