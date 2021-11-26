# 监控系统

我们通常以三个维度来对服务运行状态进行描述，分别为：

- [x] Metrics(指标)

- [x] Logging(日志)

- [ ] Opentracing(调用链)


该项目为监控方案的部署yaml，可在Kubernetes集群上直接使用，关于关于监控的文档可参考目录[doc](./doc)

## 部署组件与版本

### Metrics

| Image:Version | Note |
| ---|---|
| prom/Prometheus:v2.24.1 |  |
| prom/node-exporter:v1.0.1 |  |
| quay.io/coreos/kube-state-metrics:v1.9.7 | 用于Kubernetes v1.12版本|
|k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.0.0-beta | 用于Kubernetes v1.19版本 |
| grafana/grafana:7.1.3 |  |
| prom/alertmanager:v0.21.0 |  |
| registry.aliyuncs.com/acs/kube-eventer-amd64:v1.2.0-484d9cd-aliyun(算是k8s事件，不算指标) | |

### Logging

| Image:Version | Note |
| --- | ---|
| kibana:7.8.1 | |
|elastic/logstash:7.8.1| |
|elastic/filebeat:7.8.1| |
|elasticsearch:7.8.1| |

### Opentracing 

> todo

