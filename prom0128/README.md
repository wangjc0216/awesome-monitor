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

- [x] redis-exporter

- [x] mysqld-exporter

- [x] kube-state-metrics

~~kubectl apply -f deploy-kube-state-metrics.yaml(会报错，获取资源的错误)~~
```
kubectl apply -f new-kube-state-metrics.yaml
```

- [x] node-exporter
```
kubectl apply -f ds-node-exporter.yaml
```

- [x] cadvisor
cadvisor是Kubernetes自带的服务，无需额外安装

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

- [x] monitor-nginx
对nginx进行部署，nginx中的index.html页面中记录指标监控平台和日志监控平台两个平台的地址。
```shell
kubectl apply -f deploy-nginx.yaml
```



如果使用docker进行部署，可以参考[docker部署](./prom-docker.md)


