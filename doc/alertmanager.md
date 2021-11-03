# Alertmanager

Alertmanager 告警发送的组件


Alert Generator 生成告警的组件

Dedup 重复数据删除  高可用的时候将重复告警进行删除。



| deduplicating | 重复数据删除 | prometheus产生同一条报警<br>发送给多个alm去重后发送          |
| ------------- | ------------ | ------------------------------------------------------------ |
| grouping      | 分组         | 告警可以分组处理，同一个组里共享等待时长等参数<br>可以做告警聚合 |
| route         | 路由         | 路由匹配树，可以理解为告警订阅                               |
| silencing     | 静默         | 灵活的告警静默，如按tag                                      |
| inhibition    | 抑制         | 如果某些其他警报已经触发，则抑制某些警报的通知 <br>如机器down，上面的进程down告警不触发 |
| HA            | 高可用性     | gossip实现                                                   |





## 搭建Alertmanager

```shell
docker run --name alertmanager -d -p 127.0.0.1:9093:9093 quay.io/prometheus/alertmanager
```




## 一些操作

1. prometheus 添加Rules

2. 根据标签进行分组 

告警聚合 ： 将告警批次发送，而不是分别发送




3. 根据标签进行抑制

**critical 触发了，warning就不要触发了。**


4. 静默

设置时间范围。

静默是一个接口，可以直接调用接口来对指定告警指标进行静默

可以配置静默时间，在时间范围内不发送告警记录。

在飞书可以做卡片信息，点击静默就可以进行静默。



5. 告警升级




6. HA 高可用问题

在启动Alertmanager的时候加上参数--cluster.ip 



