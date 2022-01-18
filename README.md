# AI 应用云原生最佳实践

这个案例包含了 [训练任务](train.py) 和 [推理服务](api.py) 两个应用。

对于 AI 应用开发者来说，操作流程如下：

- 写业务逻辑 code: train.py + api.py
- 配置下 [app.yaml](./app.yaml) 和 [Github action](./workflow.yml)
- git push，触发一系列 render & build & deploy 操作
- 最后训练完成、推理上线
- 在 UI 上展示出：
  - 生成的配置 (Dockerfiles, Kubernetes)
  - CI/CD pipeline (build -> train -> serve)
  - 训练任务
  - 推理服务

注意这个例子里的下列配置跟业务代码无关，属于 render 操作生成的内容，放在这里作为示例:

- Dockerfiles/
- kubernetes/


TODO:

- Dockerfile
- Build Image
  - Github Action: https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action
- Push Image
  - Github Registry
- Apply application
  - Apply Definitions
  - Apply Train Component
  - Apply Serve Component
