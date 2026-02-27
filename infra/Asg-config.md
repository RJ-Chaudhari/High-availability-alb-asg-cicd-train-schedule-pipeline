# Auto Scaling Group Configuration

## Launch Template

AMI: Ubuntu 22.04
Instance type: t2.micro
IAM Role: Allows EC2 + AutoScaling API access (for Jenkins operations)

User-data script:
- Installs Docker
- Pulls image from DockerHub
- Runs container on port 80

---

## Auto Scaling Group

Desired Capacity: 2
Minimum Capacity: 2
Maximum Capacity: 4

Multi-AZ deployment enabled (2 subnets)

Health Check Type:
- ELB (ALB health check based)

Instance Refresh Strategy:
- Triggered via Jenkins after new Launch Template version
- Rolling replacement
- Maintains minimum healthy capacity
