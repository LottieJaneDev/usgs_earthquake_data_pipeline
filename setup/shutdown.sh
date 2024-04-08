#!/bin/bash

# tearing down terraform infrastructure 
terraform destroy -autoaprove

# include shutting down docker containers
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

# disconnecting from the VM 

