{{/*
Generate a random password for PostgreSQL
*/}}
{{- define "postgresql.password" -}}
{{- if .Values.postgresql.password.generate -}}
{{- randAlphaNum 12 -}}
{{- else -}}
{{ .Values.postgresql.password }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "postgress.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default app name.
*/}}
{{- define "postgress.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "postgress.labels" -}}
app.kubernetes.io/name: {{ include "postgress.fullname" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

