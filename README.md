# What is it
This project provisions all the code, dependencies, test cases and a runtime for a micro service, which counts bullets POSTed by clients.

There are 2 APIs defined in [OpenAPI manifest](./openapi.yaml)
1. POST /api/v1/player/fired_bullet
2. GET  /api/v1/player/fired_bullets

Please note that the POST endpoint doesn't take any request body.

There are 2 implementations for this project. While the implementation with Minikube is a direct answer to the case study, I personally prefer the implementation with AWS ECS.

# Implementation with Minikube on MacOS
The [installation script](./localhost/install.sh) installs:
- a minikube cluster
- a service and a deployment for the server
- a docker container for the client


# Implementation with ECS on AWS

## Components
This solution includes:
- A CI/CD pipeline on Github Actions.
- An E2E test suite.
- An Service on AWS ECS.

## CI/CD
Any changes to the platform, the configuration, or the service itself requires one and only one PR to the repo. 

There is no need to log into any console or to invoke any CLI from a notebook. The [github actions' workflow](./.github/workflows/service.yml) will apply any changes introduced by the PR automatically.

Compared to the installer script, this CI/CD pipeline: 
- is tested.
- is version controlled.
- use nodes managed by Github, which means that we don't have to maintain the infra for the piepeline ourselves.
- integrates with [AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) well.

## E2E Test Suite
There is a linux client that can send 100, 1,000 or 10,000 request per second. It is used in [the end-2-end integration test suite](./test/e2e/Dockerfile), which in turn is invoked in CI/CD workflow.

## The Service and its dependencies
This web service consists of:
- A LB that accepts HTTP requests on 8080.
- An [ECS service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) which consists of 3 pods.
- The code that serves 2 APIs aforementioned in the pods.
- A Redis instance that is shared by all the pods.
- Various network security groups and IAM policies/roles that implement access control.

# Why use Elastic Container Service instead of Kubernetes?
An AWS Elastic Container Service is chosen to be the runtime platform for its simplicity. Using Kubernetes to support one service is kind of overkill.

An example of simplicity can be found in the fact that an ECS services can be provisioned with terraform, which means that we can provisoin all the resources with terraform. 

In contrast, with kubernetes, we have to provision cloud services with terraform + tf files and then provision services/deployments with kubectl + yaml files.

# TODO
- Move the management of API versions from the app code to API gateway, ALB or other infra components.
- Refine IAM policies to enforce least-priviledge-principles.
- Add unit test cases.
