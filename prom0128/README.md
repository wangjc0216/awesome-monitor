# prom0128 说明

基础性能指标的监控服务部署

## 数据流

```
kube-state-metrics 
node-exporter  
cadvisor        -->   promethues  -->  grafana  --> alertmanager --> alertwebhook
grok-exporter
```
## 部署顺序

- [x] kube-state-metrics
```
kubectl apply -f deploy-kube-state-metrics.yaml
```

- [x] node-exporter
```
kubectl apply -f ds-node-exporter.yaml
```

- [ ] cadvisor
```

```

- [ ] grok-exporter
```

```


- [x] promethues
找一台机器来部署promethues
```
kubectl label node fabric-wangjc-13  prometheus=monitor
kubectl get nodes -L prometheus
//在对应机器上创建目录、更改权限
sudo mkdir -p /data/promethues
sudo chmod -R 777 /data/promethues
kubectl apply -f deploy-prometheus.yaml
```

- [x] grafana
找一台机器来部署grafana

```
kubectl label node fabric-test-4  grafana=monitor
kubectl get nodes -L grafana
//在对应机器上创建目录、更改权限
sudo mkdir -p /data/grafana
sudo chmod -R 777  /data/grafana
//创建plugin目录
sudo mkdir -p /data/grafana/plugins
//todo 需要添加插件
//更改plugin目录权限
sudo chmod -R 777 /data/grafana/plugins

kubectl apply -f deploy-grafana.yaml
```

- [x] alertmanager
```
kubectl apply -f deploy-alertmanager.yaml
```

- [ ] alertwebhook

```

```