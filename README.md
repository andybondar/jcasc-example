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
docker run --name jenkins --rm -p 8080:8080 jenkins/jenkins:latest
```

The following output indicates that Jenkins is up and running:
```
2023-04-22 19:14:30.632+0000 [id=22]	INFO	hudson.lifecycle.Lifecycle#onReady: Jenkins is fully up and running
```
Now, use your browser to navigate to `http://server_ip:8080`, http://127.0.0.1:8080 if Jenkins is running on your local machine.

### Step 2 - Disabling the Setup Wizard
Create `Dockerfile` and copy the following content into it (Jenkins version can be different for you):
```
FROM jenkins/jenkins:2.401
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
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

Then, add the following newline-separated entries into that file, using the `<plugin_id>:<version>` format:
```
ant:latest
antisamy-markup-formatter:latest
build-timeout:latest
cloudbees-folder:latest
credentials-binding:latest
email-ext:latest
git:latest
github-branch-source:latest
gradle:latest
ldap:latest
mailer:latest
matrix-auth:latest
pam-auth:latest
timestamper:latest
ws-cleanup:latest
```

Next, edit the `Dockerfile`:
```
vim Dockerfile
```

In it, add `COPY` instaruction to copy the `jcasc/plugins.txt` file into the `/usr/share/jenkins/ref/` inside the Jenkins image. Also, add `RUN` instruction, which will execute the `/usr/local/bin/install-plugins.sh` script inside the image:
```
FROM jenkins/jenkins:2.401
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY jcasc/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
```

Save the `Dockerfile` and build a new image:
```
docker build -t jenkins:jcasc .
```

Once the build is done, run the new Jenkins image:
```
docker run --name jenkins --rm -p 8080:8080 jenkins:jcasc
```