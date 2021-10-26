#!/bin/bash

while ! terraform apply -auto-approve --var-file=my-oci-conf.tfvars | grep Apply
do
  sleep 60
done
