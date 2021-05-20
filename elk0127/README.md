# elk0127 说明

## 说明
是2021.01.27创建的elk 脚本




## 数据流 

```

filebeat -> logstash -> elasticsearch -> kibana

```


## 部署顺序
- [x] namespace
```
kubectl apply -f ns-elk.yaml
```

- [x] elasticsearch statefulset  //在测试环境已经有本地挂载的例子了
  
  //todo:当前遇到的问题,node0，node1，node2 如何与myapp0，myapp1，myapp2分别对应
  
  //todo:挂载在`/data/elasticsearch`目录下，会有文件权限问题，所以现在先在宿主机上改变成为最大权限，再进行部署

```
//添加标签 kubectl label node elk-wangjc-2 es=elk 删除标签 kubectl label node elk-wangjc-2 es-  
kubectl label node fabric-test-4 es=elk
sudo mkdir -p /data/elasticsearch
sudo chmod -R 777 /data/elasticsearch
kubectl apply -f sts-elasticsearch-local.yaml
kubectl get sts -nelk
```


- [x] kibana deployment
```
//执行kibana.yaml
//kubectl create cm cm-kibana-yaml --from-file=kibana.yaml -n elk
//现在已经废弃了，可以直接执行下面命令
kubectl apply -f deploy-kibana.yaml
kubectl get deploy -nelk
```

- [x] logstash deployment
```
kubectl apply -f deploy-logstash.yaml
kubectl get deploy -nelk 
```

- [x] filebeat  daemonset
```
kubectl apply -f ds-filebeat.yaml
kubectl get ds -nelk
```
docker部署方式[参考](./docker/README.md)

  




