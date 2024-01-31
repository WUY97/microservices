#!/bin/bash

kubectl config current-context

for file in k8s/*.yml ; do
  kubectl apply -f "$file"
done