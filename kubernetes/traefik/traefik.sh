#!/bin/bash
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm show values traefik --repo https://helm.traefik.io/traefik > values.yaml
#helm install --values=./values.yaml traefik --set experimental.kubernetesGateway.enabled=true traefik/traefik --namespace traefik --create-namespace

#helm upgrade traefik -f values.yaml traefik/traefik -n traefik