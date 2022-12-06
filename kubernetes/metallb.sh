#!/bin/bash
kubectl edit configmap -n kube-system kube-proxy

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

kubectl apply -f metallb-config.yaml
