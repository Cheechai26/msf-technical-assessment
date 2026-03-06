# MSF Technical Assessment

# Technical Question

## Assumptions

- The infrastructure is intended for end-to-end testing rather than production environment
- Security configuration are simplified for ease of testing and deployment, with a focus on reducing costs
- The interface-facing ALB accepts HTTP traffic without enforcing HTTPS
- Amazon Aurora is used in the test environment but it is not strictly necessary

## Possible Security Flaws and Exploitation

1. Internet-facing ALB is directly exposed to the internet. Any service behind could be potentially exploited or attacked. An attacker could scan for endpoints, brute-force unauthorised access or any exploit vulnerabilities in exposed services

2. Traffic flows through multiple load balancers across VPC with Transit Gateway. If routing tables or security groups are misconfigured, workload internal service may be exposed to unintended sources. An attacker who manage to get access to the internet-facing VPC could potentially reach internal ALB and ECS services

3. Transit Gateway connects multiple VPCs which increases the potential impact if one VPC is compromised. A compromised resource in one VPC could potentially access service in other VPCs

## Discuss three trade-off for the design

1. **Additional Latency** - Having multiple load balancer (NLB -> ALB) in the web tier introduce extra network hops, which increases request/response time

2. **High Cost and complexity** - Multiple load balancers also add infrastructure cost additional cost and increase operational complexity

3. **Transit Gateway overhead** - Using Transit gateway enables VPC to VPC connectivity but it add management overhead, such as maintaining route tables and monitor traffic between VPCs

## Scheduled Job for Fetching Hacker News Stories
Recommend to use AWS EventBrige + Lambda function. 

- Setup a EventBridge Schedule rule that will trigger a lambda function at 5pm GMT +8 everyday
- The lambda function:
   - Calls the Hacker News API endpoint to retrieve the latest stories
   - Processes the data
   - Check and remove any duplicate records
   - Stores new stories in the database

This approach is cost effective since resources are only used during lambda execution and it allows fast deployment and easy maintenance

If the complexity grows overtime, the system can be migrated to alternative approach - EventBridge + ECS/Fargate where the the ECS service worker performs the processing. This migration would be relatively straightforward

## LLMs in the System

1. **Content Processing** - Assuming that the scheduler is implemented, we can use LLM to process incoming stories to summarize the content before storing into the database

2. **Log and metric analysis** - LLM can be use to analyse logs and metric collected from service to identify any unusual patterns or potential security anomalies, enabling early detection

3. **Automated documentation** - LLM can also automate the generation and updating of documentation, reducing manual maintenance effort


## Additional Architecture Improvements
1. **Simplify the Load Balancer Flow** - The load balancer flow could be simplified by removing the internal NLB and route traffic directly from Internet-facing ALB to the internal ALB. This would reduce latency, lower infrastructure costs and simplify the operational complexity while maintaining public and private resources


2. **Use PostgreSQL instead of Aurora** - If there is no specific reason to use AWS Aurora features, I will suggest to use AWS RDS PostgreSQL. Compared to AWS Aurora, RDS PostgreSQL is less expensive, simpler to manage and sufficient for E2E testing environment


# Setup Guide

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with valid credentials
- IAM permissions for VPC, ECS, RDS, ELB, and Transit Gateway

## Usage

```bash
# Copy example variables and edit with your values
cp terraform.tfvars.example terraform.tfvars

# IMPORTANT: Replace and set the master_password (requires at least 8 characters) in terraform.tfvars

# Initialize, validate, and deploy
terraform init
terraform validate
terraform plan
terraform apply
```

After successful deployment, access the echoserver by copying the `internet_alb_dns` output from the terminal and paste it into your browser. You should see the echoserver request details on the webpage

## Cleanup

```bash
terraform destroy
```

## Next Step
- Setup CI/CD pipeline
Implement CI/CD pipeline to automate infrastructure deployment and validation. The pipeline would:
   - Run `terraform validate` to ensure the formatting is correct
   - Execute `terraform plan` to review changes
   - Deploy infrastructure automatically using `terraform apply` after approval
   - Approval step to execute `terraform destory` to destroy the whole infrastructure 