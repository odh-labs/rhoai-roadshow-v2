# LLM Observability

```yaml
    - name: kube-linter
      runAfter:
      - fetch-app-repository
      taskRef:
        name: kube-linter
      workspaces:
        - name: source
          workspace: shared-workspace
      params:
        - name: manifest
          value: "$(params.APPLICATION_NAME)/$(params.GIT_BRANCH)/chart"
```
