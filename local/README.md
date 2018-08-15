# Local Deployment of Apps

## Overview

This directory's scripts deploy demo apps by using docker commands.(not use kubernetes)  
This is required for test of demo application program.

## File Detail

- build_containers.sh  
    - This script creates application container from src/Dockerfile_\* by `docker build` command.
    - If you want to use this script, please set variables in default.conf
- deploy_service_local.sh
    - This script deploy apps to local docker environment.
    - Before run this script, please run `./build_containers.sh`
- stop_service_local.sh
    - This script delete apps from local docker environment.