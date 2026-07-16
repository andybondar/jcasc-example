# Jenkins Configuration as Code
## Introduction
This tutorial aims to help the beginners automate Jenkins deployment and configuration with Docker and Jenkins Configuration as Code approach.

## Requirements
* GitHub account. It also can be an account in GitLab, BitBucket or any other Git repository.
* Google Cloud Platform (GCP) or Amazon Web Services (AWS) account. Any other Cloud Platform can be used, but this tutorial does not provide examples for them yet.
* An IDE or at least a text editor.
* Docker Engine running locally on your computer.

## Agenda
* Getting started with Jenkins Server
* Using Jenkins Configuration as Code
* Moving Jenkins Server to Cloud
* Portability, Scalability and other tips

## Getting started with Jenkins Server
### Step 1 - Running containerized Jenkins
Run `vanilla` Jenkins image by using `docker run` command:
```
docker run --name jenkins --rm -p 8080:8080 jenkins/jenkins:latest
```

The following output indicates that Jenkins is up and running:
```
2023-04-22 19:14:30.632+0000 [id=22]	INFO	hudson.lifecycle.Lifecycle#onReady: Jenkins is fully up and running
```
Now, use your browser to navigate to `http://server_ip:8080`, http://127.0.0.1:8080 if Jenkins is running on your local machine.

Open an interactive shell install the container to get the password:
```
docker exec -it $(docker ps | grep "jenkins:latest" | awk '{print $1}') bash

$ cat /var/jenkins_home/secrets/initialAdminPassword
```

### Step 2 - Disabling the Setup Wizard
Create `Dockerfile` and copy the following content into it (Jenkins version can be different for you):
```
FROM jenkins/jenkins:2.573
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
```

Build custom Docker image:
```
docker build -t jenkins:jcasc .
```

Run Docker container using that custom image:
```
docker run --name jenkins --rm -p 8080:8080 jenkins:jcasc
```

Navigate to `http://server_ip:8080` (http://127.0.0.1:8080) in your web browser. You should be able to see Jenkins dashboard without going through the Setup Wizard.

### Step 3 - Installing Jenkins plugins
By default no plugins are installed. You can see that by navigating to http://127.0.0.1:8080/pluginManager/installed .
In this step, we're going to pre-install a selection of Jenkins plugins.

Create a folder named `jcasc` and open a new file named `plugins.txt` in it:
```
mkdir jcasc
vim jcasc/plugins.txt
```

Then, add the following newline-separated entries into that file, using the `<plugin_id>:<version>` format, starting from `configuration-as-code:latest`:
```
configuration-as-code:latest
```

Next, edit the `Dockerfile`:
```
vim Dockerfile
```

In it, add `COPY` instaruction to copy the `jcasc/plugins.txt` file into the `/usr/share/jenkins/ref/` inside the Jenkins image. Also, add `RUN` instruction, which will execute the `/usr/local/bin/install-plugins.sh` script inside the image:
```diff
FROM jenkins/jenkins:2.573
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
+ COPY jcasc/plugins.txt /usr/share/jenkins/ref/plugins.txt
+ RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
```

Save the `Dockerfile` and build a new image:
```
docker build -t jenkins:jcasc .
```

Once the build is done, run the new Jenkins image:
```
docker run --name jenkins --rm -p 8080:8080 jenkins:jcasc
```

## Using Jenkins Configuration as Code
In this section we will go through the Jenkins configuration using `Configuration as Code` plugin, which allows to configure Jenkins based on human-readable declarative `yaml` file(s).

### Step 1 - Setting up Jenkins URL 
Create and modify `jcasc/jcasc.yaml` file:
```yaml
unclassified:
  location:
    url: http://${JENKINS_URL}/
```


Add some instructions to the `Dockerfile`:
```diff
FROM jenkins/jenkins:2.573
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
+ ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/ref/jcasc.yaml"
COPY jcasc/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
+ COPY jcasc/jcasc.yaml /usr/share/jenkins/ref/jcasc.yaml
```

Build a new Jenkins image and push it to container registry. Then deploy VM.

### Step 2 - Creating a User
Edit `jcasc/jcasc.yaml` file:
```diff
+ jenkins:
+  securityRealm:
+    local:
+      allowsSignup: false
+      users:
+       - id: ${JENKINS_ADMIN_ID}
+         password: ${JENKINS_ADMIN_PASSWORD}
unclassified:
  location:
    url: ${JENKINS_URL}
```

Re-build Jenkins image and push it to container registry. Re-deploy the VM.

### Step 3 - Setting Up Authorization Strategy
The user we have created can successfully log in, but still any unauthorized, anonymous user can have access to the Jenkins management dashboard, whithout any authentication. To fix that, edit `jcasc/casc.yaml` file as follows:
```diff
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
       - id: ${JENKINS_ADMIN_ID}
         password: ${JENKINS_ADMIN_PASSWORD}
+  authorizationStrategy:
+    loggedInUsersCanDoAnything:
+      allowAnonymousRead: false         
unclassified:
  location:
    url: ${JENKINS_URL}
```

Re-build Jenkins image and push it to container registry. Re-deploy the VM.

### Step 4 - Jenkins Pipelines as Code and more
Now, let's add `workflow-aggregator` plugin to `` which will allow us to define Jenkins Pipelines as code:
```
workflow-aggregator:latest
```

Also, the following plugin allows to use fundamental `git` operations for Jenkins projects, including form tha Pipelines:
```
git:latest
```

Improving Jenkins Pipelines visualization:
```
blueocean:latest
```

Add plugins allowing to work with Terraform CLI and to use AWS Credentials:
```
terraform:latest
aws-credentials:latest
```

Define Terraform installation in the `jcasc/jcasc.yaml` file:
```diff
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
       - id: admin
         password: admin
  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false
+ tool:
+  terraform:
+    installations:
+      - name: "terraform-1.14.1"
+        properties:
+          - installSource:
+              installers:
+                - terraformInstaller:
+                    id: "1.14.1-linux-amd64"
unclassified:
  location:
    url: http://127.0.0.1:8080/
```

Add those plugins to the `jcasc/plugins.txt` file, re-build the Jenkins image and push it to container registry. Re-deploy the VM.

## Moving Jenkins Server to Cloud
* [GCP](terraform/gcp/README.md)
* [AWS](terraform/aws/README.md)

## Data persistency, Portability, Scalability and other tips
### Step 1 - Attaching additional Disk to Jenkins VM
Additional disk will be used to store Jenkins persistent data, like jobs and pipelines configuration, history of their runs, etc.