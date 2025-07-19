# Project Context: Flutter Cafe App

## 1. Project Overview

This is a Flutter-based cafe application. This project is configured for the following environments:
1.  **Automated deployment** to a serverless architecture on AWS.

## 2. Deployment to AWS (CI/CD)

Deployment to the AWS production environment is automated via GitHub Actions.

-   **Workflow File**: `.github/workflows/aws-deploy.yml`
-   **Trigger**: The workflow runs automatically on every `push` to the `main` branch.
-   **Mechanism**: The workflow builds the Flutter web application, syncs the static files to an S3 bucket, and invalidates the CloudFront cache.

-   **Required GitHub Secrets**: The workflow requires the following secrets to be set in the repository settings (`Settings > Secrets and variables > Actions`):
    -   `AWS_ROLE_TO_ASSUME`: The ARN of the IAM Role for GitHub Actions to assume.
    -   `AWS_REGION`: The AWS region for the resources (e.g., `ap-northeast-1`).
    -   `S3_BUCKET_NAME`: The name of the S3 bucket for storing web assets.
    -   `CLOUDFRONT_DISTRIBUTION_ID`: The ID of the CloudFront distribution serving the content.

## 3. AWS Architecture

The production infrastructure is designed as a serverless stack for scalability, performance, and cost-efficiency.

-   **Core Components**: Amazon S3 (for hosting), Amazon CloudFront (as a CDN), and Amazon Route 53 (for DNS).
-   **Detailed Documentation**: A full breakdown of the architecture, including diagrams and data flows, is available in the `AWS_ARCHITECTURE.md` file in the project root.
