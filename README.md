High Availability Architecture with ALB + ASG
---------------------------------------------------------------------
🏗 Architecture Overview

This lab implements a highly available containerized deployment using:

Jenkins (CI Layer)

Docker (Containerization)

Docker Hub (Image Registry)

Launch Template

Auto Scaling Group (Multi-AZ)

Application Load Balancer

Target Group Health Checks

📐 Architecture Flow
Developer → GitHub → Jenkins → Docker Build → Docker Hub
→ Launch Template → Auto Scaling Group (Multi-AZ)
→ EC2 Instances (Docker)
→ Target Group
→ ALB (Health Checks + Traffic Routing)
→ Users
⚙ Deployment Workflow

Jenkins builds Docker image.

Image is tagged using build number (v1, v2, v3...).

Image is pushed to Docker Hub.

Launch Template defines EC2 bootstrap via user-data.

ASG maintains desired instance count.

Instance refresh ensures rolling update.

ALB distributes traffic across healthy instances.

🔐 Security Design

Separate Security Groups for Jenkins, ALB, and App instances.

SSH access restricted to Jenkins security group.

Application instances not publicly accessible.

Only ALB exposes HTTP to the internet.

Private communication inside default VPC.

🎯 High Availability Features

Multi-AZ deployment

Health check-based routing

Automatic instance replacement

Horizontal scaling capability

Decoupled CI and runtime layers

🔄 Current Deployment Strategy

Application updates are deployed by:

Pushing new Docker image

Triggering Auto Scaling instance refresh

Rolling replacement behind ALB

🚀 Future Improvements

Fully automated instance refresh via Jenkins

Blue/Green deployment model

Infrastructure as Code (Terraform)

HTTPS with ACM
-----------------------------------------------------------------------------------
This is a simple train schedule app written using nodejs. It is intended to be used as a sample application for a series of hands-on learning activities.

## Running the app on local

You need a Java JDK 7 or later to run the build. You can run the build like this:

    ./gradlew build

You can run the app with:

    ./gradlew npm_start

Once it is running, you can access it in a browser at [http://localhost:3000](http://localhost:3000)
