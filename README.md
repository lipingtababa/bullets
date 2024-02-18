# Goal
This project provisions all the code, dependencies and runtime for a micro service, which counts bullets POSTed by clients.

Any changes to the platform, the configuration, or the service itself requires one and only one PR to the repo. No one should be asked to log into any console or invoke any CLI from his/her notebook.
The [github actions' workflow](./.github/workflows/service.yml) will apply any changes introduced by the PR automatically.

# APIs
There are 2 APIs defined in [OpenAPI manifest](./openapi.yaml)
1. POST /api/v1/player/fired_bullet
2. GET  /api/v1/player/fired_bullets

Please note that the POST endpoint doesn't take any request body.

# Runtime choice
An AWS Elastic Container Service is chosed to be the runtime platform, over an Kubernetes cluster for its simplicity.

An example of simplicity can be found in the fact that an ECS services can be provisioned with terraform, which means that we can provisoin all the resources with terraform. In contract, with kubernetes, we have to provision cloud serives with terraform + tf files and then provision services/deployments with kubectl + yaml files.

Another example is that associating an ECS service with a LB is much easier than associating an Kubernetes service with a LB.


# Components of the bullet service
This web service consists of:
- A LB that accepts HTTPS requests on 8080 and forward them to an ECS service.
- An [ECS service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) which consists of several pods.
- The code that serves 2 APIs aforementioned in the pods.
- A Redis instance that is shared by all the pods.
- Various netowrk security groups and IAM policies/roles that implement access control.

# Requirements to a service
- A web service should  
    - Listen on port 8080.
    - Provide a health-check endpoint on 8081.
    - Be able to exit gracefully on signal SITINT.
    - Collect metrics and logs of the application.

# TODO
- Move the management of API versions from the app code to API gateway, ALB or other infra components.
