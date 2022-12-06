cat <<EOF >ETCD.yaml | kubectl apply -f ETCD.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: etcd-pvc
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 10Gi
  hostPath:
    path: /volume/etcd/
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: etcd-pvc-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: etcd-deployment
spec:
  selector:
    matchLabels:
      app: etcd
  replicas: 1
  template:
    metadata:
      labels:
        app: etcd
    spec:
      containers:
        - name: etcd
          image: bitnami/etcd:3.4.9-debian-10-r21
          volumeMounts:
          - mountPath: /var/www/html
            name: etcd-data
          env:
          - name: ETCD_ROOT_PASSWORD
            value: "123456a@"
          - name: ETCD_DATA_DIR
            value: "/bitnami/etcd/data/restoreddata/"
          ports:
            - containerPort: 2379
      volumes:
      - name: etcd-data
        persistentVolumeClaim:
          claimName: etcd-pvc-claim
---
apiVersion: v1
kind: Service
metadata:
  name: etcd-service
  labels:
    app: etcd
spec:
  type: NodePort
  ports:
    - port: 2379
      nodePort: 30004
  selector:
    app: etcd
EOF


eyJhbGciOiJSUzI1NiIsImtpZCI6Ilg2WnJ5X3hzVWQxVHRBYW55YnUtTjY3UWV6YVA5OUR3UnlQMlRIY0hhcU0ifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNjY5MzYzOTA5LCJpYXQiOjE2NjkzNjAzMDksImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJhZG1pbi11c2VyIiwidWlkIjoiNTI5MGQyOTMtNDMyYS00ODJhLWI5YjItNzJjM2VmZjNhMWUzIn19LCJuYmYiOjE2NjkzNjAzMDksInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbi11c2VyIn0.FNGqX1LeN1MWzjSTHIZhpqlB9N8Z-6Js8oWvcqmphXDSjDmSfNsHQMDWZGRcuMHvNGzvyrcpBMTPVDTpW1-9PvSf7NyfcfvhSl7PodfhmDLrqXV1D4hcJp0s0QVH4F-L8Cn24FCVNcIxN_wCkEuYBk7vFveK9szIk_1JMHu6XS6wtxUSndd4qb-7pE0T7OVaSg40_8N-Vj5xns5mwjF6FexC9pG4VrQzMhra-sz9zN5x_bK9tuFnQatcdTkbbfMgesaWWf4G5hqelvhsSHGt0eLUYBKu1jtRYx-x2xXwL9hIlforQfrLxxlnPTDgHlnRJMt5w5EajhOr807crkfTKA