# Auto Scaling Group & Deployment Configuration

## Launch Template

Defines immutable infrastructure blueprint.

Configuration:

- AMI: Ubuntu 22.04
- Instance Type: t2.micro
- Security Group: App-Server-SG
- No public IP
- User-data script installs Docker and runs container

A new Launch Template version is created per deployment.

---

## Auto Scaling Group Configuration

Desired Capacity: 2  
Minimum Capacity: 2  
Maximum Capacity: 4  

Multi-AZ: Enabled (2 subnets)  

Health Check Type:
- ELB (ALB-based health evaluation)

---

## Instance Refresh Strategy

Triggered via Jenkins:

