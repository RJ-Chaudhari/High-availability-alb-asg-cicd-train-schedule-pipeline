# High Availability Architecture – Technical Design

## 1. System Overview

This project implements a rolling, zero-downtime deployment strategy using:

- Application Load Balancer (Layer 7)
- Target Group (HTTP health-based routing)
- Auto Scaling Group (Multi-AZ)
- Launch Template versioning
- Jenkins-triggered infrastructure update

The deployment model follows immutable infrastructure principles.

---

## 2. Network Architecture

VPC: Default VPC  
Subnets: Two subnets across different Availability Zones  
ALB: Internet-facing  
EC2 instances: No public IP (private communication via ALB)

Traffic Flow:

Internet  
→ ALB (Port 80)  
→ Target Group  
→ EC2 instances (Docker container on port 80)

---

## 3. Deployment Architecture

Each deployment performs:

1. Docker image build with version tag `v${BUILD_NUMBER}`
2. Push image to DockerHub
3. Create new Launch Template version
4. Trigger Auto Scaling Group instance refresh

ASG performs rolling replacement:

- Launch new instance using latest Launch Template version
- Wait for ALB health check success
- Terminate old instance
- Maintain minimum healthy capacity

This guarantees no service interruption.

---

## 4. Launch Template Strategy

Launch Template contains:

- AMI: Ubuntu 22.04
- Instance type: t2.micro
- Security Group: App-Server-SG
- User-data script (base64 encoded)

User-data responsibilities:

- Install Docker
- Pull image from DockerHub using version tag
- Run container mapped to port 80

A new Launch Template version is created for every deployment.

---

## 5. High Availability Mechanisms

High availability is achieved through:

- Multi-AZ deployment
- Minimum capacity of 2 instances
- ELB-based health checks
- Rolling instance refresh
- ALB routing only to healthy targets

If an instance fails health check:

- ASG automatically replaces it
- ALB stops routing traffic to it

---

## 6. Failure Scenarios Covered

| Scenario | System Behavior |
|----------|-----------------|
| Instance crash | ASG launches replacement |
| Container failure | Health check fails → ASG replacement |
| Deployment update | Rolling replacement |
| Single AZ failure | Traffic routed to other AZ |

---

## 7. Architectural Principles Applied

- Immutable deployments
- Infrastructure versioning
- Health-driven traffic routing
- Automated infrastructure updates
- Multi-AZ redundancy
