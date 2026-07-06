# Moving Jenkins Server to GCP
In this section, we will go through the deployment of our Jenkins Servers in the Cloud ([Google Cloud Platform](https://cloud.google.com/) in this case), which will make the service available for our Team, regardless of where in the world any of our teammates is currently located.


### Step 1 - Creating a GCP project
Assuming that we already have a `GCP account`, first thing that needs to be done is creating a `GCP project`, where all requried GCP infrastructure resources will be deployed. We will use [Terraform](https://www.terraform.io/) to automatically create the project, and destroy it when it is not needed anymore.

Authenticate your GCP account using `gcloud` command (use your own email address associated with your GCP account):
```
gcloud auth login user@example.com
```
or
```
gcloud auth login user@example.com --no-launch-browser
```
More details can be found [here](https://cloud.google.com/sdk/gcloud/reference/auth).

Go to the `terraform/modules/project` and run the following commands on by one:
```
terraform init
```

```
terraform plan
```

```
terraform apply
```
That will create a dedicated GCP project to host required GCP infrastructure resources


Now, go to the `terraform/modules/services` folder and do the same `terraform init/plan/apply` sequence again. That will enable the following GCP APIs (there can be more in the future):
```
Google Container Registry API - containerregistry.googleapis.com
Compute Engine API - compute.googleapis.com
```

### Step 2 - Pushing Jenkins custom image to Google Container Registry
Fist, make sure that you have access to the `gcr.io` Container Registry:
```
gcloud container images list
```

You should see the following output:
```
Listed 0 items.
Only listing images in gcr.io/jcas-lab-01. Use --repository to list images in other repositories.
```
The name of the project, `jcas-lab-01` will be different for you.

Tag your local custom Jenkins image as follows:
```
docker tag jenkins:jcasc gcr.io/jcas-lab-01/jenkins:jcasc
```

Push your local custom Jenkins image to `gcr.io/jcas-lab-01/` container registry:
```
docker push gcr.io/jcas-lab-01/jenkins:jcasc
```

The output of the `gcloud container images list` command should be the following:
```
NAME
gcr.io/jcas-lab-01/jenkins
Only listing images in gcr.io/jcas-lab-01. Use --repository to list images in other repositories.
```

### Step 3 - Running Jenkins in GCE Virtual Machine
Now, it is time to run your containerized Jenkins Server in GCP. Go to the `terraform/modules/compute` folder and run `init/plan/apply` sequence.


As the GCE VM running Jenkins Server is started, a public IP address will be assigned to that VM and a DNS record withing the existing Cloud DNS zone will be created. That DNS record associates the IP address with an FQDN within that DNS Zone. Creating a Cloud DNS Zone is not covered by this guide, at least for now. We're using an existing Cloud DNS zone here.