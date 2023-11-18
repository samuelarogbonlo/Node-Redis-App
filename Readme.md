# Lifinance  Deployment infrastructure task

This repository contains the code for the Lifinance ECS infrastructure.

## Infrastructure overview

The setup includes an ECS cluster that operates one service. This service manages tasks, each containing only a container for the NodeJS application. A load balancer efficiently distributes incoming requests among these tasks. Additionally, the architecture incorporates a postgres database for data storage related to the NodeJS app and Redis for caching purposes.

## Continous integration / Continous deployment


The CI/CD pipeline is setup with Github actions. The pipeline is triggered by a push to the master branch on Github and performs the following tasks.

- The pipeline runs Dockerfile linting. 

- The pipeline builds a docker image from the application and pushes to docker hub

- The pipeline downloads the task definition from AWS and updates it with the latest docker image.

- The pipeline deploys a new version of the application to ECS.

The ECS deployment is a rolling deployment. ECS sets up a new task and deploys the application into that task. Then, it reroutes the traffic to the new task and drains all connections on the old task.

