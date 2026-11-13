{{- define "kubelab.topologySpread" -}}
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      {{- include "kubelab.selectorLabels" . | nindent 6 }}
{{- end }}
