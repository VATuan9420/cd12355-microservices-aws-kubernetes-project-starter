# Coworking Space Service Extension
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

## Getting Started

### Dependencies
#### Local Environment
1. Python Environment - run Python 3.6+ applications and install Python dependencies via `pip`
2. Docker CLI - build and run Docker images locally
3. `kubectl` - run commands against a Kubernetes cluster
4. `helm` - apply Helm Charts to a Kubernetes cluster

#### Remote Resources
1. AWS CodeBuild - build Docker images remotely
2. AWS ECR - host Docker images
3. Kubernetes Environment with AWS EKS - run applications in k8s
4. AWS CloudWatch - monitor activity and logs in EKS
5. GitHub - pull and clone code

### Setup
#### 1. Configure a Database
In the `db/` directory:

1. Set up PostgreSQL

```bash
kubectl apply -f pvc.yaml
kubectl apply -f pv.yaml
kubectl apply -f deploy.yaml
kubectl apply -f svc.yaml
```
2. Insert seeding data
The database is accessible within the cluster. This means that when you will have some issues connecting to it via your local environment. You can either connect to a pod that has access to the cluster _or_ connect remotely via [`Port Forwarding`](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)

* Setup Tunnel Via Port Forwarding and Run Seeding Files
```bash
export POSTGRES_PASSWORD=mypassword
./insert_data.sh
```

### 2. Running the Analytics Application Locally
In the `analytics/` directory:

1. Install dependencies
```bash
pip install -r requirements.txt
```
2. Run the application (see below regarding environment variables)
```bash
export DB_USERNAME=myusername
export DB_PASSWORD=mypassword
export DB_HOST=127.0.0.1
export DB_PORT=5432
export DB_NAME=mydatabase
python app.py
```

There are multiple ways to set environment variables in a command. They can be set per session by running `export KEY=VAL` in the command line or they can be prepended into your command.

* `DB_USERNAME`
* `DB_PASSWORD`
* `DB_HOST` (defaults to `127.0.0.1`)
* `DB_PORT` (defaults to `5432`)
* `DB_NAME` (defaults to `postgres`)

If we set the environment variables by prepending them, it would look like the following:
```bash
DB_USERNAME=username_here DB_PASSWORD=password_here python app.py
```
The benefit here is that it's explicitly set. However, note that the `DB_PASSWORD` value is now recorded in the session's history in plaintext. There are several ways to work around this including setting environment variables in a file and sourcing them in a terminal session.

3. Verifying The Application
* Generate report for check-ins grouped by dates
`curl <BASE_URL>/api/reports/daily_usage`

* Generate report for check-ins grouped by users
`curl <BASE_URL>/api/reports/user_visits`

### 3. Deploy Application to EKS

1. To deploy new application
```bash
kubectl  apply -f deployment/coworking.yaml
```

2. To update new version for deployment
```bash
IMAGE=991840463755.dkr.ecr.us-east-1.amazonaws.com/udacity
TAG=20241101_050408

kubectl set image deployment/coworking \
  coworking=$IMAGE:$TAG
```

### 4. Install CloudWatch Agent

```bash
./install-cw-fluent-bit.sh
```

## Notes

1. DB and Application run in namespace default
2. Dockerfile is in folder analytics
3. Image Evidences is in folder evidences
4. To build and push image, refer steps noted in file buildspec.yml
5. In case build and push image via CodeBuild, see the log in CloudWatch or view newest image in ECR to get newly-built image version 