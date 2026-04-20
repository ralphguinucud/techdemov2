{{/* Common labels */}}
{{- define "aks-store.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{/* Build a service image reference. Usage: include "aks-store.image" (dict "repo" .Values.image.repository "name" "store-front" "tag" .Values.image.tag) */}}
{{- define "aks-store.image" -}}
{{- printf "%s/%s:%s" .repo .name .tag -}}
{{- end -}}
