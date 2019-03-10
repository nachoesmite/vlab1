{{- /* probes.http defines an http liveness and readiness probes if desired. */ -}}
{{- define "probes.http" -}}
<!!CHANGE_ME!!>
{{- end -}}

{{- /* probe.http defines an http probe for a given url and port. */ -}}
{{- define "probe.http" }}
httpGet:
  path: {{ .path }}
  port: {{ .port }}
initialDelaySeconds: {{ default 5 .delay }}
periodSeconds: {{ default 10 .frequency }}
failureThreshold: {{ default 3 .failures }}
successThreshold: {{ default 1 .successes }}
timeoutSeconds: {{ default 1 .timeout }}
{{- end -}}