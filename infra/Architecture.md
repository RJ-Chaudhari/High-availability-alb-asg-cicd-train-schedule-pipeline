# High Availability Architecture – ALB + ASG + Jenkins CI/CD

## 1. Overview

This project demonstrates a production-style high availability deployment architecture on AWS using:

- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Launch Templates
- Jenkins CI/CD Pipeline
- Docker-based application deployment

The system is designed to support rolling, zero-downtime deployments across multiple Availability Zones.

---

## 2. High-Level Architecture
            Internet
                ↓
    Application Load Balancer (ALB)
                ↓
          Target Group (HTTP:80)
                ↓
      Auto Scaling Group (Min: 2)
         ↓                    ↓
    EC2 Instance A        EC2 Instance B
    Docker Container      Docker Container
    (train-app:vX)        (train-app:vX)

                ↑
           Jenkins CI Server


---

## 3. Infrastructure Components

### 3.1 Application Load Balancer (ALB)

- Type: Internet-facing
- Listener: HTTP (Port 80)
- Routes traffic to Target Group
- Performs health checks on `/`
- Only routes traffic to healthy instances

---

### 3.2 Target Group

- Protocol: HTTP
- Port: 80
- Health check path: `/`
- Health check type: ELB-based
- Registered targets: EC2 instances from ASG

---

### 3.3 Auto Scaling Group (ASG)

- Desired capacity: 2
- Minimum capacity: 2
- Maximum capacity: 4
- Multi-AZ deployment (2 subnets)
- Health check type: ELB

ASG ensures:

- Minimum 2 healthy instances always running
- Automatic replacement of unhealthy instances
- Rolling instance replacement during deployment

---

### 3.4 Launch Template

Each deployment creates a new Launch Template version.

Launch Template defines:

- AMI: Ubuntu 22.04
- Instance type: t2.micro
- Security Group: App-Server-SG
- User-data script:
  - Install Docker
  - Pull Docker image (rajshreec/train-app:vX)
  - Run container on port 80

User-data is dynamically updated per deployment to inject the new image version.

---

### 3.5 Jenkins CI/CD Server

Jenkins is responsible for:

1. Cloning repository from GitHub
2. Building Docker image (`v${BUILD_NUMBER}`)
3. Pushing image to DockerHub
4. Creating new Launch Template version
5. Triggering ASG Instance Refresh

Deployment is fully automated via GitHub Webhook.

---

## 4. CI/CD Deployment Flow
Developer
↓
GitHub Push
↓ (Webhook)
Jenkins Pipeline
↓
Docker Build (vX)
↓
Push to DockerHub
↓
Create Launch Template Version
↓
Start ASG Instance Refresh
↓
New EC2 Instances Launch
↓
ALB Health Check
↓
Traffic Shift to Healthy Instances


---

## 5. Rolling Deployment Strategy

The deployment uses:

- Launch Template versioning
- ASG Instance Refresh
- ELB health-based traffic routing

Process:

1. New Launch Template version is created
2. ASG starts instance refresh
3. New instance launches with new image version
4. Health checks pass
5. Old instance terminates
6. Capacity remains at minimum healthy level (2)

This ensures zero downtime.

---

## 6. Security Design

Security Groups are configured using reference-based rules:

### Jenkins-SG
- SSH (22) → Admin IP
- 8080 → Public (for webhook testing)

### ALB-SG
- HTTP (80) → 0.0.0.0/0

### App-Server-SG
- HTTP (80) → ALB-SG
- SSH (22) → Jenkins-SG

No direct public access to application instances.

---

## 7. Versioning Strategy

Docker images are tagged using:
v${BUILD_NUMBER}


Each deployment produces:

- Immutable image
- Immutable Launch Template version
- Controlled rolling update

---

## 8. Key Engineering Principles Demonstrated

- Immutable infrastructure
- Rolling deployments
- Multi-AZ high availability
- Health-based traffic routing
- Automated infrastructure update via CI/CD
- Version-controlled deployment strategy

