#!/bin/bash
for ns in  $(kubectl get ns | awk '{print $1}' | tail -n +2)
do
        echo "$ns"
            kubectl delete po $(kubectl get po -n$ns  | grep Evicted | awk '{print $1}') -n$ns
        done
done
