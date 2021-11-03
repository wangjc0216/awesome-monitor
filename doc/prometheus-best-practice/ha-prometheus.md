# 低成本高可用方案

M3的机器成本和运维成本较高(1.没有很多人使用；2.对机器的成本要求较高)


## multi_remote_read

promethues支持multi_remote_read功能，多的可以去重，少的可以补上。 可以将数据分片存储在不同的proemtheus中。

> poromethues在这里有四种角色： 采集/查询/预聚合/告警
![img.png](image/ha-prometheus-arch.png)

可以在promethues的配置中添加多个remote_read： 
```
remote_read:
  - url: "http://172.20.70.205:9090/api/v1/read"
    read_recent: true
  - url: "http://172.20.70.215:9090/api/v1/read"
    read_recent: true
```



## 缺点

- 网络会产生木桶效应，多个remote query会根据返回最慢的进行返回。

- 应对重查询(zhong，四声)可能会把query打挂。query是无状态，打挂了问题也不大。

- 由于是无差别的并发query，也就是所有query都会打向所有的采集器，promethues会做一些优化，m3db存在布隆过滤器可以在很浅的地方就进行返回。

**如果想要query打向在特定的采集器（避免木桶效应、避免无效查询的资源浪费），可以做一个查询统一入口服务**（该服务会有具体指标的注册，可以将请求分发到不同采集器），
可以参考：[prome-route](https://zhuanlan.zhihu.com/p/231914857)


## 优点

- 这是一个低成本的高可用方案,比m3db的成本低很多，虽然不可以称为高可用存储（因为没有对数据进行reblance），但是达到了服务高可用的效果。可以保证查询时数据不丢不少不重复。


## 注意

promethues启动配置Remote Write Receiver参数(在cmd后可以加的参数) ，本地则不存储指标数据。 

Thanos 利用了公有云的对象存储，而对象存储的高可用特点是公有云进行提供的。

