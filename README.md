# Jenkins Configuration as Code
## Introduction
This tutorial aims to help the beginners automate Jenkins deployment and configuration with Docker and Jenkins Configuration as Code approach.

## Requirements
* GitHub account. It also can be an account in GitLab, BitBucket or any other Git repository.
* Google Cloud Platform (GCP) account. Any other Cloud Platform can be used, but this tutorial does not provide examples for them yet.
* An IDE or at least a text editor.
* Docker Engine running locally on your computer.

## Agenda
* Getting started with Jenkins Server
* Moving Jenkins Server to Cloud
* Using Jenkins Configuration as Code
* Portability, Scalability and other tips

## Getting started with Jenkins Server
### Step 1 - Running containerized Jenkins
Run `vanilla` Jenkins image by using `docker run` command:
```
$ docker run --name jenkins --rm -p 8080:8080 jenkins/jenkins:latest
```

The following output indicates that Jenkins is up and running:
```
2023-04-22 19:14:30.632+0000 [id=22]	INFO	hudson.lifecycle.Lifecycle#onReady: Jenkins is fully up and running
```
Now, use your browser to navigate to `http://server_ip:8080`.

### Step 2 - Disabling the Setup Wizard
Create `Dockerfile` and copy the following content into it (Jenkins version can be different for you):
```
FROM jenkins/jenkins:2.401
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
```

Build custom Docker image:
```
$ docker build -t jenkins:jcasc .
```

Run Docker container using that custom image:
```
$ docker run --name jenkins --rm -p 8080:8080 jenkins:jcasc
```

Navigate to `http://server_ip:8080` in your web browser. You should be able to see Jenkins dashboard without going through the Setup Wizard.