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

!!! note "A preencher"
    Adicionar aqui os resultados obtidos: tempo de resposta, número de réplicas criadas, gráficos do HPA em ação.
