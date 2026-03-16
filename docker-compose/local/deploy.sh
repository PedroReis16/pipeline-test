#!/bin/bash

aws ecr get-login-password --region us-east-1 | docker login --password-stdin --username AWS "201538476474.dkr.ecr.us-east-1.amazonaws.com"
docker-compose pull
docker-compose -p pipeline up -d
