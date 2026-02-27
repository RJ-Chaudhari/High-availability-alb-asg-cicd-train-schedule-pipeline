# High Availability Architecture – ALB + ASG + Jenkins CI/CD

## Overview

This project implements a production-style high availability deployment architecture on AWS.

### Architecture Flow

Internet
   ↓
Application Load Balancer (ALB)
   ↓
Target Group (HTTP:80)
   ↓
Auto Scaling Group (Min:2, Multi-AZ)
   ↓
EC2 Instances (Docker container running train-app)

Jenkins CI Server triggers rolling deployments by:

1. Building Docker image (v${BUILD_NUMBER})
2. Pushing image to DockerHub
3. Creating new Launch Template version
4. Starting Auto Scaling Group Instance Refresh

ALB routes traffic only to healthy instances.
This ensures zero-downtime rolling deployments.
