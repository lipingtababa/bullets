# What is it
This project provisions all the code, dependencies, test cases and a runtime for a micro service, which counts bullets POSTed by clients.
## APIs
There are 2 APIs defined in [OpenAPI manifest](./openapi.yaml)
1. POST /api/v1/player/fired_bullet
2. GET  /api/v1/player/fired_bullets

Please note that the POST endpoint doesn't take any request body.

## CI/CD
Any changes to the platform, the configuration, or the service itself requires one and only one PR to the repo. There is no need to log into any console or to invoke any CLI from his/her notebook. The [github actions' workflow](./.github/workflows/service.yml) will apply any changes introduced by the PR automatically.

## E2E Test Suite
There is a linux client that can send 100, 1,000 or 10,000 request per second. It is used in [the end-2-end integration test suite](./test/e2e/Dockerfile)

# Why not a script?
The reasons that I don't implement this project with a script are:
1. Usually a script is not tested, which would lead to more bugs.
2. Usually a script is distributed in a copy-and-paste way, which makes version-tcontrol really difficult.
3. A script can be installed in some places and be forgotten forever until it causes an incident.
4. Last but not least, the syntax of shell script is ugly.

# Then why Github Actions?
1. This is a simple project that doesn't need flexibility provided by Jenkins.
2. It's a managed service from Github, which means that we don't have to do the maintenance ourselves.
3. It integrates with Github and [AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) well.


# Why use Elastic Container Service instead of Kubernetes?
An AWS Elastic Container Service is chosen to be the runtime platform for its simplicity. Using Kubernetes to support one service is kind of overkill.

An example of simplicity can be found in the fact that an ECS services can be provisioned with terraform, which means that we can provisoin all the resources with terraform. 

In contrast, with kubernetes, we have to provision cloud services with terraform + tf files and then provision services/deployments with kubectl + yaml files.

However, given that this is for technical review, I will add another solution with Kubernetes before the meeting.


# Components of the bullet service
This web service consists of:
- A LB that accepts HTTPS requests on 8080 and forward them to an ECS service.
- An [ECS service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) which consists of several pods.
- The code that serves 2 APIs aforementioned in the pods.
- A Redis instance that is shared by all the pods.
- Various network security groups and IAM policies/roles that implement access control.

# TODO
- Re-implement it with Kubernetes and an installation script.
- Move the management of API versions from the app code to API gateway, ALB or other infra components.
- Refine IAM policies to enforce least-priviledge-principles.
- Add unit test cases.
