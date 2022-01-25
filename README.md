# AI 应用云原生最佳实践

这个案例包含了 [训练任务](train.py) 和 [推理服务](api.py) 两个应用。

对于 AI 应用开发者来说，操作流程如下：

- 写业务逻辑 code: train.py + api.py
- 配置下 [app.yaml](./app.yaml)
- 剩下的一键 `dagger up` 即可，包括
  - build & deploy orchestration
  - infrastructure resources rendering

## Quickstart

If you have not setup Dagger environment, run
```
dagger init
dagger new test -p plans/ml
```

Initialize parameters:

```
dagger input yaml parameters -f app.yaml
```

Run:
```
dagger up
dagger query resources
```

## Add a new capability

The [monitoring.cue](./plans/ml/monitoring.cue) is an example to add a new capability to an existing definition:

```go
package ml

// This will register the new capability and expose it to users
parameters: serveModel: monitoring: {
  groups: [...#monitorGroup]
}

#monitorGroup: {
  name: string
  rules: [...#monitorRule]
}

#monitorRule: {
  alert: string
  expr: string
  for: string
  annotations: [string]: string
}
```

Then you can use the capability in `app.yaml`:

```yaml
serveModel:
  ...

  monitoring:
    groups:
      - name: example
        rules:
          - alert: APIHighRequestLatency
            expr: api_http_request_latencies_second{quantile="0.5"} > 1
            for: 10m
            annotations:
              summary: "High request latency on {{ $labels.instance }}"
              description: "{{ $labels.instance }} has a median request latency above 1s (current value: {{ $value }}s)"
```


TODO:

- Dagger -> KubeVela App + Defs:
  - Deployment
  - Ingress + Service
  - Monitoring
