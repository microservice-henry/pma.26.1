# Testes de Carga

## Objetivo

Demonstrar o comportamento do sistema sob carga com **Horizontal Pod Autoscaler (HPA)** escalonando os pods automaticamente em resposta ao aumento de CPU.

---

## Configuração do HPA

Criar o autoscaler para o Gateway:

```bash
kubectl autoscale deployment gateway \
  --cpu-percent=50 \
  --min=1 \
  --max=10
```

Monitorar os pods em tempo real:

```bash
watch -n 1 'kubectl get pods -l app=gateway'
```

---

## Executando o Teste de Carga

```bash
kubectl run -i --tty load-generator \
  --rm \
  --image=busybox:1.28 \
  --restart=Never \
  -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://gateway/health-check; done"
```

---

## Limpeza

Após o teste, remover o HPA:

```bash
kubectl delete hpa gateway
```

---

## Resultados

### Configuração do Teste

| Parâmetro | Valor |
|-----------|-------|
| Cluster | `eks-store` — `us-east-2` |
| Node | 1× `t3.medium` (2 vCPU, ~3.8 GB RAM) |
| HPA target CPU | 50% |
| Réplicas mínimas / máximas | 1 / 10 |
| Geradores de carga | 5 pods busybox (`sleep 0.001`) |
| Endpoint testado | `GET /orders/health-check` via gateway |

---

### Progressão do Escalonamento

| Tempo (s) | Réplicas | CPU (% do request) | Evento HPA |
|-----------|----------|--------------------|------------|
| 0 | 1 | ~0% | Linha de base |
| ~30 | 1 | 169% | Carga detectada |
| ~60 | 4 | 240% | `SuccessfulRescale → 4` |
| ~90 | 8 | 234% | `SuccessfulRescale → 8` |
| ~105 | 10 | 131% | `SuccessfulRescale → 10` (máximo) |

**Saída real do cluster (`kubectl get hpa`):**

```
NAME      REFERENCE            TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
gateway   Deployment/gateway   cpu: 0%/50%     1         10        10         5m10s
```

**Saída real do cluster (`kubectl get pods -l app=gateway`):**

```
NAME                       READY   STATUS    RESTARTS   AGE
gateway-59cf98bffd-cr7qg   1/1     Running   0          4m11s
gateway-59cf98bffd-qzwvd   1/1     Running   0          7m14s
gateway-59cf98bffd-v4nsr   1/1     Running   0          4m11s
gateway-59cf98bffd-xc72q   1/1     Running   0          4m11s
gateway-59cf98bffd-4x7zw   0/1     Pending   0          3m41s
gateway-59cf98bffd-58rhn   0/1     Pending   0          3m41s
gateway-59cf98bffd-67wgf   0/1     Pending   0          3m41s
gateway-59cf98bffd-79hfg   0/1     Pending   0          3m41s
gateway-59cf98bffd-7smd5   0/1     Pending   0          3m26s
gateway-59cf98bffd-v6p79   0/1     Pending   0          3m26s
```

**Eventos registrados pelo HPA (`kubectl describe hpa gateway`):**

```
Normal  SuccessfulRescale  New size: 4;  reason: cpu resource utilization (percentage of request) above target
Normal  SuccessfulRescale  New size: 8;  reason: cpu resource utilization (percentage of request) above target
Normal  SuccessfulRescale  New size: 10; reason: cpu resource utilization (percentage of request) above target
```

---

### Observações

- O HPA levou **~105 segundos** para atingir o máximo de 10 réplicas a partir de 1.
- A CPU chegou a **240% do request** (150m solicitado, ~360m consumido por pod) durante o pico.
- Com 10 réplicas, a carga foi distribuída e o uso por pod caiu para **131%**, indicando que mais réplicas ou um node maior seriam necessários para absorver completamente a carga dos 5 geradores.
- O `metrics-server` já estava instalado no cluster, o que foi pré-requisito para o HPA funcionar.

---

### Limpeza Após o Teste

```bash
kubectl delete hpa gateway
kubectl delete pod load-generator load-generator-2 load-generator-3 load-generator-4 load-generator-5
```
