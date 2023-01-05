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
