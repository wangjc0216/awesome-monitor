# METRIC AND LABEL NAMING

## Metrics names

- 应该是命名的合法字符
- 应该有一个前缀用来描述该指标所在的领域（如http_request_total，process_cpu_seconds_total 中个的http和process），也被称为`namespace`

- 应该有一个基本单元，防止bit和Byte，ms和s发生混淆。
- 应该有一个后缀来描述复数单位，如http_request_duration_seconds,node_memory_usage_bytes等，如果描述累加值可以使用total作为描述，如process_cpu_**seconds_total**
- 应该代表在所有标签维度上测量的相同逻辑事物。



按照经验来判断，所有的指标通过`sum`或者`avg`之类的操作符都有相应的显示意义，如果没有，说明这个指标设置的不合理，需要对该指标进行拆分。



## Labels

我们使用Label用来区分观测指标的**不同特征**，如下：

```
api_http_requests_total - differentiate request types: operation="create|update|delete"
api_request_duration_seconds - differentiate request stages: stage="extract|transform|load"
```



>需要注意的是，key-value键值对每一个不同的组合就构成一个新的time series，这将大大增加了数据的存储量，所以我们不应该将id，email，这些高维度值放在label中。



## REF

[METRIC AND LABEL NAMING](https://prometheus.io/docs/practices/naming/)