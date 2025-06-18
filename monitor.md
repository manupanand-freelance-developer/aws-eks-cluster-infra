# Monitor using Newrelic in K8s

- integrations and agents>k8s>helm>create newkey>copykey>>copy the newrelic install > enable |only black box monitory dont give insight into each pods you run> only give insigts about how cluster performing etc

# add promethues and grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack