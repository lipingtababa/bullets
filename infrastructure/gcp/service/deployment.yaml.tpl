apiVersion: apps/v1
kind: Deployment
metadata:
  name: bullets-app-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bullets-app
  template:
    metadata:
      labels:
        app: bullets-app
    spec:
      containers:
      - name: bullets-app
        image: ${DEPLOYMENT_REGION}-docker.pkg.dev/${PROJECT_ID}/shared-repository/${APP_NAME}:${APP_VERSION}
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
        env:
        - name: DEPLOYMENT_REGION
          value: "localhost"
        - name: DB_HOST
          value: "bullets-db-redis-master"
        - name: DB_PORT
          value: "6379"
        - name: DB_PASSWORD
          value: "1234qwerASDF"
        - name: APP_NAME
          value: "bullets"
---
apiVersion: v1
kind: Service
metadata:
  name: bullets-app-service
spec:
  selector:
    app: bullets-app
  type: NodePort
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30001

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: bullets-app-ingress
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: "/ping"
        backend:
          service:
            name: bullets-app-service
            port:
              number: 8080
