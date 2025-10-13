# PetProject1

This project simulates a multi-page web application. It runs entirely on AWS infrastructure and is managed using modern DevOps tools.

## Infrastructure

The infrastructure is provisioned using Terraform and includes the following AWS resources:

- VPC, Internet Gateway (IGW), Subnets, NAT Gateway
- EKS Cluster with worker nodes
- RDS for storing image metadata
- IAM roles and policies for secure access

## Tech Stack

- Frontend: HTML, CSS, JavaScript, React
- Backend: Node.js with Express
- Infrastructure:
  - AWS EC2: Hosting the web application
  - AWS S3: Image storage
  - AWS RDS: Storing image descriptions and S3 links
  - Terraform: Infrastructure automation
  - Docker & Kubernetes: Containerization and deployment

## Folder Structure

- frontend/ – React-based user interface
- backend/ – REST API and server-side logic
- terraform/ – AWS resource definitions
- k8s/ – Kubernetes deployment configurations

## Deployment Overview

1. Use Terraform to provision AWS resources.
2. Build Docker containers for frontend and backend.
3. Deploy containers to EKS using Kubernetes manifests.
4. Application connects to RDS and S3 for data and image storage.
