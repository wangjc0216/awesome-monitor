# prometheus 容器部署

## cadvisor

启动cadvisor容器：
```shell
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest
```

访问http://localhost:8080/metrics 即可获取到标准的Prometheus监控样本输出:
```shell
# HELP cadvisor_version_info A metric with a constant '1' value labeled by kernel version, OS version, docker version, cadvisor version & cadvisor revision.
# TYPE cadvisor_version_info gauge
cadvisor_version_info{cadvisorRevision="1e567c2",cadvisorVersion="v0.28.3",dockerVersion="17.09.1-ce",kernelVersion="4.9.49-moby",osVersion="Alpine Linux v3.4"} 1
# HELP container_cpu_load_average_10s Value of container cpu load average over the last 10 seconds.
# TYPE container_cpu_load_average_10s gauge
container_cpu_load_average_10s{container_label_maintainer="",id="/",image="",name=""} 0
container_cpu_load_average_10s{container_label_maintainer="",id="/docker",image="",name=""} 0
container_cpu_load_average_10s{container_label_maintainer="",id="/docker/15535a1e09b3a307b46d90400423d5b262ec84dc55b91ca9e7dd886f4f764ab3",image="busybox",name="lucid_shaw"} 0
container_cpu_load_average_10s{container_label_maintainer="",id="/docker/46750749b97bae47921d49dccdf9011b503e954312b8cffdec6268c249afa2dd",image="google/cadvisor:latest",name="cadvisor"} 0
container_cpu_load_average_10s{container_label_maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>",id="/docker/f51fd4d4f410965d3a0fd7e9f3250218911c1505e12960fb6dd7b889e75fc114",image="nginx",name="confident_brattain"} 0
```

## node-exporter 

启动node-exporter容器：
```shell
docker run -d \
  --name=node-exporter \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter \
  --path.rootfs /host
```
访问http://localhost:9100/metrics 即可获取到标准的Prometheus监控样本输出:
```shell
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 3.3823e-05
go_gc_duration_seconds{quantile="0.25"} 0.000125238
go_gc_duration_seconds{quantile="0.5"} 0.000219714
go_gc_duration_seconds{quantile="0.75"} 0.000292111
go_gc_duration_seconds{quantile="1"} 0.000664916
go_gc_duration_seconds_sum 0.00672721
go_gc_duration_seconds_count 30
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 8
# HELP go_info Information about the Go environment.
# TYPE go_info gauge
```

## promethues 

`/opt/prometheus`目录下创建prometheus.yml配置文件：
```shell
global:
  scrape_interval: 15s
  scrape_timeout: 15s
scrape_configs:
- job_name: cadvisor
  static_configs:
  - targets: ['10.0.0.108:8080']
- job_name: node-exporter
  static_configs:
  - targets: ['10.0.0.108:9100']
```
启动prometheus容器：
```shell
docker run  -d \
  -p 9090:9090 \
  --name prometheus \
  -v /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
  prom/prometheus
```

## grafana

创建目录：
```shell
mkdir /opt/grafana-storage
chmod 777 -R /opt/grafana-storage
```
启动grafana 容器：
```shell
docker run -d \
  -p 3000:3000 \
  --name=grafana \
  -v /opt/grafana-storage:/var/lib/grafana \
  grafana/grafana
```

## Alertmanager

`/opt/alertmanager/config.yml`文件：
```shell
global:
  resolve_timeout: 5m
route:
  group_by: ['alertname', 'cluster']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 5m
```
启动Alertmanager容器：
```shell
docker run -d \
-p 9093:9093 \
--name alertmanager \
-v /opt/alertmanager/:/etc/alertmanager/ \
docker.io/prom/alertmanager:latest \
--config.file=/etc/alertmanager/config.yml
```

## Grafana界面配置

需要参考Grafana使用文档，配置promethues作为数据源，配置Alertmanager作为告警通道。


## Reference

[基于Docker搭建promethues grafana](https://www.cnblogs.com/xiao987334176/p/9930517.html)