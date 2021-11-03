# client_golang包

````
A Basic Example
Metrics
Custom Collectors and constant Metrics
Advanced Uses of the Registry
HTTP Exposition
Pushing to the Pushgateway
Graphite Bridge
Other Means of Exposition
````





```
通过标签对样本的维度进行区分

Gauge,Counter,Summary,Histogram 添加标签后，-->

GaugeVec, CounterVec, SummaryVec, and HistogramVec

Note that Gauge, Counter, Summary, and Histogram are interfaces themselves while GaugeVec, CounterVec, SummaryVec, and HistogramVec are not.


```





```
Gauge,Counter,Summary,Histogram 实现了Metrics接口
Gauge,Counter,Summary,Histogram,GaugeVec, CounterVec, SummaryVec, HistogramVec 实现了Collect接口 Metrics接口


MustRegister 是注册collector最通用的方式。

custom registry的使用方式还有很多：可以使用NewPedanticRegistry来注册特殊的属性；可以避免由DefaultRegisterer限制的全局状态属性；也可以同时使用多个registry来暴露不同的metrics。


DefaultRegisterer注册了Go runtime metrics （通过NewGoCollector）和用于process metrics 的collector（通过NewProcessCollector）。通过custom registry可以自己决定注册的collector。


Registry实现了Gather接口。调用Gather接口可以通过某种方式暴露采集的metric。通常metric endpoint使用http来暴露metric。通过http暴露metric的工具为promhttp子包。


通过http暴露metric的工具为promhttp子包。


func Register(c Collector) error：使用DefaultRegisterer来注册传入的Collector

func Unregister(c Collector) bool：使用DefaultRegisterer来移除传入的Collector的注册信息


type Collector：用于采集prometheus metric，如果运行多个相同的实例，则需要使用ConstLabels来注册这些实例。实现collector接口需要实现Describe和Collect方法，并注册collector。


type Registerer：负责collector的注册和去注册，实现custom registrer时应该实现该接口
带Must的版本函数只是对不带Must函数的封装，增加了panic操作，如：


REF：  https://www.shuzhiduo.com/A/A7zgqxXP54/
```



可通过Example文件来对包进行解读： 

```


```





## SDK  TYPE

### Type Desc struct

Desc是每个Metric使用的描述符(descriptor)，它本质上是指标的不可变元数据(immutable meta-data)。在该包(client_golang/promethes)下面的Metric实现都会使用通过它来管理它们的描述符。

```
func (d *Desc) String() string  //返回Desc的序列化信息

func NewInvalidDesc(err error) *Desc //如果Metric是错误的，那么调用该方法，返回代表一个错误的Desc对象
```



**用户只需要在使用ExpvarCollector或自定义Collector和Metric 这样的高级功能的时候才会去处理Desc**



### Type Metric interface



```\
//返回Metric的Desc，该接口具有幂等性
Desc() *Desc    

//将Metric对象编码为 Metric协议缓冲区数据存储对象 ("Metric" Protocol Buffer data transmission object.)
//指标实现一定遵守并发安全性，因为该指标的读取可能随时发生，所以不要阻塞。
//任何阻塞都会意渲染所有注册指标的总体性能为代价。理想状态是Metrics是支持并发阅读。
Write(*dto.Metric) error 
```

Metric 对单个样本值进行建模，并将其元数据导出到 Prometheus。此包中的 Metric 实现是 Gauge、Counter、Histogram、Summary 和 Untyped。





### Type Collector interface

Collector 是一个接口，被Prometheus来收集指标。**Collector 一定要被注册**

```
Collector is the interface implemented by anything that can be used by Prometheus to collect metrics. A Collector has to be registered for collection. See Registerer.Register.
```



固有的metrics指标(Gauge,Counter,Summary,Histogram,Untyped)也是Collector，但是只能采集一个指标，就是它们自己。

**一个Collector 的实现可能是收集多个指标以coordinated fashion 且/或 创建指标on the fly。**

方法列表： 

```
//Describe会发送该Collector收集到的所有Metrics的Desc发送到指定的通道中，发送完最后一个描述符则会返回。
Describe(chan<- *Desc)

//当Registry收集指标的时候，Collect方法被Promethues registry调用
Collect(chan<- Metric)
```





### Type Registerer interface

Registerer是registry(注册处)的一部分，负责注册和注销

```
// Registerer is the interface for the part of a registry in charge of
// registering and unregistering. Users of custom registries should use
// Registerer as type for registration purposes (rather than the Registry type
// directly). In that way, they are free to use custom Registerer implementation
// (e.g. for testing purposes).
```





```

Register(Collector) error

MustRegister(...Collector)

Unregister(Collector) bool
```



### Type Gatherer

Gatherer是registry(注册处)的一部分，负责将采集到的指标放到多个MetricFamilies中.(MetricFamily是一个proto结构体)

```
// Gatherer is the interface for the part of a registry in charge of gathering
// the collected metrics into a number of MetricFamilies. The Gatherer interface
// comes with the same general implication as described for the Registerer
// interface.
```

### 







## client_golang/push包



### Add

```
Add works like push, but only previously pushed metrics with the same name (and the same job and other grouping labels) will be replaced. (It uses HTTP method “POST” to push to the Pushgateway.)
```





