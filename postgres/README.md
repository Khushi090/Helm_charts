## Postgres Helm Chart

A PostgreSQL Helm chart is a package of pre-configured Kubernetes resources that allows you to easily deploy and manage PostgreSQL databases on a Kubernetes cluster using Helm, a package manager for Kubernetes.

## Postgres Helm Files

<details>
<summary><code>values.yaml</code></summary>
<br>
   
 ```shell  
  replicaCount: 1

image:
  repository: postgres
  tag: "12.6"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 5432

configMap:
  databaseName: mydatabase
  user: myuser

secret:
  password: changeme

resources:
  requests:
    memory: "512Mi"
    cpu: "500m"
  limits:
    memory: "10Gi"
    cpu: "1"

nodeSelector: {}

tolerations: []

affinity: {}
```
<br>
</details>


<details>
<summary><code>Chart.yaml</code></summary>
<br>
   
 ```shell  
  apiVersion: v2
name: postgresql-helm-chart
description: A Helm chart for PostgreSQL
version: 0.1.0
appVersion: "12.6"
```
<br>
</details>


<details>
<summary><code>.helmignore</code></summary>
<br>
   
 ```shell  
# Patterns to ignore when building packages.
# This supports shell glob matching, relative path matching, and
# negation (prefixed with !). Only one pattern per line.
.DS_Store
# Common VCS dirs
.git/
.gitignore
.bzr/
.bzrignore
.hg/
.hgignore
.svn/
# Common backup files
*.swp
*.bak
*.tmp
*.orig
*~
# Various IDEs
.project
.idea/
*.tmproj
.vscode/
```
<br>
</details>


<details>
<summary><code>templates/service.yaml</code></summary>
<br>
   
 ```shell  
apiVersion: v1
kind: Service
metadata:
  name: postgresql-headless
spec:
  clusterIP: None
  ports:
    - port: {{ .Values.service.port }}
      targetPort: 5432
  selector:
    app: postgresql
```
<br>
</details>

<details>
<summary><code>templates/secrets.yaml</code></summary>
<br>
   
 ```shell  
apiVersion: v1
kind: Secret
metadata:
  name: postgresql-secret
type: Opaque
data:
  password: {{ default (randAlphaNum 16) .Values.secret.password | b64enc | quote }}
```
<br>
</details>

<details>
<summary><code>templates/deployment.yaml</code></summary>
<br>
   
 ```shell  
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgresql
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: postgresql
  template:
    metadata:
      labels:
        app: postgresql
    spec:
      containers:
        - name: postgresql
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          env:
            - name: POSTGRES_DB
              valueFrom:
                configMapKeyRef:
                  name: postgresql-config
                  key: POSTGRES_DB
            - name: POSTGRES_USER
              valueFrom:
                configMapKeyRef:
                  name: postgresql-config
                  key: POSTGRES_USER
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgresql-secret
                  key: password
          ports:
            - containerPort: 5432
```
<br>
</details>

<details>
<summary><code>templates/configmap.yaml</code></summary>
<br>
   
 ```shell  
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgresql-config
data:
  POSTGRES_DB: {{ default (randAlphaNum 8) .Values.configMap.databaseName }}
  POSTGRES_USER: {{ default (randAlphaNum 8) .Values.configMap.user }}
```
<br>
</details>

<details>
<summary><code>templates/_helpers.tpl</code></summary>
<br>
   
 ```shell  
{{/*
Expand the name of the chart.
*/}}
{{- define "postgres.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgres.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgres.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgres.labels" -}}
helm.sh/chart: {{ include "postgres.chart" . }}
{{ include "postgres.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgres.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "postgres.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
```
<br>
</details>

<details>
<summary><code>templates/NOTES.txt</code></summary>
<br>
   
 ```shell
{{- if .Values.ingress }}
  {{- if .Values.ingress.enabled }}
    {{- range $host := .Values.ingress.hosts }}
      {{- range .paths }}
        http{{ if $.Values.ingress.tls }}s{{ end }}://{{ $host.host }}{{ .path }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- else if contains "NodePort" .Values.service.type }}
  export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{ include "postgres.fullname" . }})
  export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
{{- else if contains "LoadBalancer" .Values.service.type }}
  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
  You can watch its status by running 'kubectl get --namespace {{ .Release.Namespace }} svc -w {{ include "postgres.fullname" . }}'
  export SERVICE_IP=$(kubectl get svc --namespace {{ .Release.Namespace }} {{ include "postgres.fullname" . }} --template "{{"{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"}}")
  echo http://$SERVICE_IP:{{ .Values.service.port }}
{{- else if contains "ClusterIP" .Values.service.type }}
  export POD_NAME=$(kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/name={{ include "postgres.name" . }},app.kubernetes.io/instance={{ .Release.Name }}" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace {{ .Release.Namespace }} $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace {{ .Release.Namespace }} port-forward $POD_NAME 8080:$CONTAINER_PORT
{{- end }}
```
<br>
</details>


## OUTPUT

``` shell 
helm create postgres
```

![image (32)](https://github.com/user-attachments/assets/04990026-1339-4b4b-8867-216ae3692356)


``` shell
kubectl create namespace k8s
```

![image (33)](https://github.com/user-attachments/assets/8ed1bad9-1cda-41a1-a1c1-fb8820d8a246)


```shell 
helm install postgres ./ --namespace k8s
```

![image (34)](https://github.com/user-attachments/assets/295e4289-1425-42d7-8d17-9a329424dc0e)

To see the events which happened while creating pods for postgres

```shell 
kubectl get pods --namespace k8s
```

```shell 
kubectl get events --namespace k8s
```

![image (35)](https://github.com/user-attachments/assets/536ae7fd-5f2e-44d8-8f1c-292c91319e8c)

To see what all configuration is there for pods 

```shell
kubectl describe pods <pods_id> --namespace k8s
```

![image (36)](https://github.com/user-attachments/assets/701b89d5-44b1-4d8f-9960-5ec036a76918)

To get secrets for postgres DB and User

```shell 
kubectl describe secret postgresql-secret --namespace k8s
```

![image (37)](https://github.com/user-attachments/assets/5a0cae25-cf04-4795-9e5b-e3825620ed61)

To enter the pod 

```shell
kubectl exec -it <pod_id> --namespace k8s -- /bin/bash
```

```shell 
postgres --version
```

```shell 
env | grep postgres
```

```shell
psql -h localhost -U <YOUR_USERNAME> -d  <YOUR_DATABASE_NAME>
```

![image (38)](https://github.com/user-attachments/assets/53e2dfb9-16ec-456d-8969-486cada6375a)


```shell
CREATE TABLE khushi (
id SERIAL PRIMARY KEY,
name VARCHAR(100)
);
```

```shell
INSERT INTO khushi (name) VALUES ('Alice'), ('Bob');
```

```shell
SELECT * FROM khushi;
```

![image (39)](https://github.com/user-attachments/assets/c0b8b6e5-414f-4c9d-a82d-8c930d19df1e)


