#helm3
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

   
   helm upgrade -i loki grafana/loki-stack -n monitor --create-namespace \
     --set grafana.enabled=true,grafana.adminPassword=Tdt@123456 \
     --set prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false \
     --set alertmanager.enabled=true \
     --set loki.persistence.enabled=true,loki.persistence.size=10000000Gi,loki.persistence.storageClassName=nfs-client \
     --set promtail.enabled=true,promtail.config.lokiAddress=http://loki:3100/api/prom/push
   
   kubectl expose service loki-grafana --type=LoadBalancer --name=grafana-svc --namespace=monitor
   
   kubectl get svc grafana-svc -n loki-stack -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
   kubectl port-forward service/loki-grafana 3000:80 --address='0.0.0.0' -n monitor

   --set alertmanager.enabled=true