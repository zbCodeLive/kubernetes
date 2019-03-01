#!/bin/bash

SERVICE_NAME=${1:-"usercenter-api-service"}
NAMESPACE=${2:-"default"}
IMAGE=$3
REPLICAS=${4:-"1"}
CONTAINER_PORT=${5:-"80"}
TARGET_PORT=${6:-"$CONTAINER_PORT"}
NODE_PORT=${7:-"$CONTAINER_PORT"}

cat > backend.yaml<<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: $SERVICE_NAME
  namespace: $NAMESPACE
  labels:
    app: $SERVICE_NAME
spec:
  replicas: $REPLICAS
  template:
    metadata:
      labels:
        app: $SERVICE_NAME
    spec:
      containers:
      - image: $IMAGE
        name: $SERVICE_NAME
        imagePullPolicy: Always
        volumeMounts:
        - name: timezone
          mountPath: /etc/localtime
        ports:
          - containerPort: $CONTAINER_PORT
      imagePullSecrets:
      - name: registrysecret
      volumes:
      - name: timezone
        hostPath:
          path: /usr/share/zoneinfo/Asia/Shanghai

---

apiVersion: v1
kind: Service
metadata:
  name: $SERVICE_NAME
  namespace: $NAMESPACE
  labels:
    app: $SERVICE_NAME
spec:
  type: NodePort
  ports:
  - port: $CONTAINER_PORT
    targetPort: $TARGET_PORT
    nodePort: $NODE_PORT
  selector:
    app: $SERVICE_NAME
EOF