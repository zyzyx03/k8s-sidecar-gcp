# DevOps Assessment

### :goal_net: Goal
##### :one: Understand what level of independence you can work with. How fast docs can be read, info can be grabbed to achieve the mission ?
##### :two: It is 2020, automation is everywhere. Are you willing to automate, how automation is structured?
##### :three: You did it, well done. Sharing is caring so it is time to document it (use any medium: PDF, word, gitlab or github repo).

### :blue_book: Scenario
##### You just got hired as a DevOps Engineer with a local company. One day a Developer named Mat ask you on how to deploy his new web app (PyZine) using GCP cloud offering which recently purchased by company for him to test as a pilot project. Your task is to help him to deploy his app and to document all the steps taken. Since he is using flask framework and MySQL so it is suggested to use the hosted GKE(Google Kubernets Engine) and Cloud SQL to reap the benefits of the cloud environment in terms of scalability, upgrades and security. 

##### By using cloud SQL a different type of deployment for k8s will be used, since the SQL instance is located outside the K8s environment so a supporting container is needed to run as a proxy client. This pattern is known as sidecars. 


<p align="center">
<img src="https://cdn.pixabay.com/photo/2018/12/14/15/24/motorcycle-3875237_960_720.jpg" width=350 height=230>
</p>

##### The sidecar container extends and works with the primary container. This pattern is best used when there is a clear difference between a primary container and any secondary tasks that need to be done for it. In this diagram PyZine will serve as a web server that connected to the proxy container and proxy container will authenticate and query cloud SQL when users interacting with PyZine to perform CRUD operation. 

<p align="center">
<img src="https://drive.google.com/uc?export=view&id=1C4Db6kKJp4jYJxecLjB01jO1gTrcbudR">
</p>

##### To initially bring up required resource we will use Terraform so that we can treat our infrastucture as a code, where it can be versioned and maintained easily. 

### :construction_worker: Prerequisites.
1. **A GCP project is created**
2. **gcloud installed, up-to-date, logged in, and connected to your project**

Run this command to install gcloud In this case I am using Debian based distro. 
```bash
> sudo apt install google-cloud-sdk
> gcloud auth login
> gcloud projects list
> gcloud config set project <my-project>
> gcloud config list
````
3. **Enable necessary API for this project that are not allowed on default.**
```bash
> gcloud services enable \
    cloudresourcemanager.googleapis.com \
    compute.googleapis.com \
    iam.googleapis.com \
    sqladmin.googleapis.com \
    container.googleapis.com
```
4. **Install Terraform binary to spin up the cloud infrastucture.**
```bash
> wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip
> unzip terraform_0.12.23_linux_amd64.zip
> cp terraform /usr/loca/bin
> terraform -v
```
:warning: We will not be using the 13.0(latest) version since upon testing some GCP module that we need will not work. For this project version 12.23 seems to work fine.

5. **Creating a google service account so that terraform can authenticate to GCP.**

In this scenario we need a service account for terraform and cloud SQL. Remember to make things easier assign the account with primitive role as owner.

Visit this link to learn on how to setup the [service account](https://cloud.google.com/iam/docs/service-accounts). After that save the credential in JSON file, Download and store it somewhere safe.

6. ***Preparing terraform deployment.Module organization, variables and output.***
If you used with Ansible the main.tf file as it's name is your main Playbook that will be pointing to your custom roles. In terraform it's known as modules. 

```bash
gcpPyZineDeploy
├── main.tf
├── modules
│   ├── db
│   │   ├── main.tf
│   │   ├── myflaskapp.sql
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── gke
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── ops.tfvars
├── secret
│   └── terraform.json
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf
```
:warning: You should never share ops.tfvars, secrets, terraform.tfstate, terraform.tfstate.backup as it contains sensitive data that you use to authenticate with your GCP. Please exclude it before you push in .gitignore file. 

Example of main.tf file, as you can see is linked to two modules 
which is DB and GKE. 
```hcl
// root module

provider "google" {
  credentials = file("./secret/terraform.json")
  project = var.gcp_project_name
  region  = var.gcp_region
  zone    = var.gcp_zone
}

module "db" {

  source = "./modules/db"
  disk_size     = 10
  instance_type = "db-f1-micro"
  password      = var.db_password 
  user          = var.db_username

}

module "gke" {

  source = "./modules/gke"
  name   = var.k8s_name
  project = var.gcp_project_name
  location = var.gcp_region
  initial_node_count = 1

}
```

### :rocket: Launching the infrastucture.
```bash
> cd gcpPyZineDeploy
> terraform init # Terraform will download all necessary components for deployment.
> terraform validate # Syntax Validation
> terraform plan -var-file="ops.tfvars" # Dry Run
> terraform apply -var-file="ops.tfvars" # Apply
```

There are several way to store you environment variable in this case I'm using tfvars file that will store all of my secret key where it will overwrite the existing default value. Deployment will finish between 7-10 minutes. 

```bash
module.gke.google_container_node_pool.default: Creating...
module.gke.google_container_node_pool.default: Still creating... [10s elapsed]
module.gke.google_container_node_pool.default: Still creating... [20s elapsed]
module.gke.google_container_node_pool.default: Still creating... [30s elapsed]
module.gke.google_container_node_pool.default: Still creating... [40s elapsed]
module.gke.google_container_node_pool.default: Still creating... [50s elapsed]
module.gke.google_container_node_pool.default: Still creating... [1m0s elapsed]
module.gke.google_container_node_pool.default: Creation complete after 1m7s [id=projects/pyzine-288209/locations/asia-southeast1/clusters/pyzine/nodePools/pyzine-node-pool]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

1. **Verifying your terraform provisioning.**

Cloud SQL

```bash
gcloud sql instances list # list avilable cloud SQL instance
gcloud sql instances describe <instance_name> # Get the connection name
```
GKE

```bash
gcloud container clusters list # List the GKE cluster
sudo apt install kubectl # Install kubectl
gcloud container clusters get-credentials <cluster-name>  --zone <zone># Get the Auth Credential
kubect get nodes # Testing the authentication
kubect get pods --all-namespaces
```
2. **Testing the cloud proxy and importing the database**

As mentioned earlier we need to use SQL proxy in order to authenticate to our current cloud SQL. Run this command on gcloudSqlProxy to connect.

```bash
./cloud_sql_proxy --instances pyzine-288209:asia-southeast1:pyzine-mysql-1=tcp:3306 -credential_file=./pyzinesqladmin.json &
```
:warning: Don't forget to create a service account with SQL Admin Role and pass the JSON file credential, this is the same JSON file that will be used by our sidecars container.

The Proxy now is running on the background, Now let's connect to it. 

```bash
mysql -u <username> -h 127.0.0.1 -p # Enter the password when prompted
# Try to query the DB
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| main               |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.04 sec)
```
Success, now since we had gain access to the cloud SQL it's time to import
the database that been provided by our dev which is Mat. It can be done by simply invoking the MySQL command.

```bash
mysql -u <username> -h 127.0.0.1 -p < database.sql # Import the database
# Login and verify
select * from users;
+----+---------------+-------------------+----------+-------------------------------------------------------------------------------+---------------------+
| id | name          | email             | username | password                                                                      | register_date       |
+----+---------------+-------------------+----------+-------------------------------------------------------------------------------+---------------------+
|  1 | Brad Traversy | brad@traversy.com | bradt    | $5$rounds=535000$VcQrgJBGPWTT6gur$FkTO3g/tNiMjI7AaPujzspM12PY6gUyLVc4nKkJFphA | 2020-09-01 01:58:01 |
+----+---------------+-------------------+----------+-------------------------------------------------------------------------------+---------------------+
1 row in set (0.02 sec)
```
Great! the data has been imported.

## :whale: Containerize the app.

We will create our container image plain simple like below. The env variable value will be provided as kubernetes secrets.

```dockerfile
from python:3.8

MAINTAINER zyzyx

COPY . /app
WORKDIR /app

RUN pip install pipenv

RUN pipenv install --system --deploy --ignore-pipfile

#ENV DB_USER "something"
#ENV DB_PASSWORD "something"
#ENV DB_NAME "something"
#ENV SECRET_KEY "something"
#ENV DB_HOST "something"

CMD ["python", "app.py"]

```
Invoke the following command to build the docker image. 

```bash
docker build --tag pyzine:0.1 . # Image Build
docker container run pyzine:0.1 -p 8080:5000 -d # Run the docker Image locally to test. 
```
Next we will be pushing the container image to GCR(google container registry)
```bash
# Allow docker to authenticate request to GCR.
gcloud auth configure-docker 
# Tag the docker image
docker tag pyzine:0.1 asia.gcr.io/pyzine-288209/pyzine:0.1 
# As you can see GCP allow you to store you docker image in several region in this case I use Asia.

# Push to gcr
docker push asia.gcr.io/pyzine-288209/pyzine:0.1
# Try to pull the image for testing
docker pull asia.gcr.io/pyzine-288209/pyzine:0.1 
# Deleting docker container on GCR
gcloud container images delete asia.gcr.io/pyzine-288209/pyzine:0.1 --force-delete-tags 
```

## :sailboat: Enter the Kubernetes.

Did you notice that the ENV is commented out in the dockerfile. And kubernetes secret is mentioned, now we will use this command to store our secrets in K8s. 

1. **Creating the secrets**

```bash
# Change the value in [] with real value.  
kubectl create secret generic cloudsql-db-credentials \
    --from-literal=username=[DB_USER] \
    --from-literal=password=[DB_PASS] \
    --from-literal=dbname=[DB_NAME] \
    --from-literal=secretkey=[SECRET_KEY]
# List the secrets
kubectl get secrets
# Describe the Secrets
kubectl describe secrets cloudsql-db-credentials
# Output
Data
====
dbname:     10 bytes
password:   11 bytes
secretkey:  11 bytes
username:   5 bytes
```

2. **Credential file secrets**

We will do the same to obfuscate our service account key.

```bash
kubectl create secret generic cloudsql-instance-credentials \
--from-file=pyzinesqladmin.json=./secrets/pyzinesqladmin.json
```

3. **Describe the Deployment**

Next, we need to create a deployment that describes how we want our pods to run. For our use we want a deployment consisting of two containers: PyZine and cloud-sql-proxy. The application will run in the PyZine container, and will connect to the Cloud SQL instance through what is called a ‘sidecar' container.

Our first step is to describe out main container which is the PyZine.

```yaml
- name: pyzine
        image: asia.gcr.io/pyzine-288209/pyzine:0.1
        env:
        - name: DB_HOST
          value: 127.0.0.1
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: cloudsql-db-credentials
              key: username
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: cloudsql-db-credentials
              key: password
        - name: DB_NAME
          valueFrom:
            secretKeyRef:
              name: cloudsql-db-credentials
              key: dbname
        - name: SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: cloudsql-db-credentials
              key: secretkey
```
Next, we want to describe the sidecar container. This container will contain our proxy, and allow the main container to connect to the Cloud SQL instance. The second container should be described like this:

```yaml
      - name: cloud-sql-proxy
        image: gcr.io/cloudsql-docker/gce-proxy:1.17
        command:
          - "/cloud_sql_proxy"
          - "-instances=pyzine-288209:asia-southeast1:pyzine-mysql-1=tcp:3306"
          - "-credential_file=/secrets/pyzinesqladmin.json"
        securityContext:
          # The default Cloud SQL proxy image runs as the
          # "nonroot" user and group (uid: 65532) by default.
          runAsNonRoot: true
        volumeMounts:
        - name: my-secrets-volume
          mountPath: ./secrets
          readOnly: true
          # [END cloud_sql_proxy_k8s_volume_mount]
```

In order to mount a volume, you must also describe it and its contents. This is done in the volume section.
```yaml
      # [START cloud_sql_proxy_k8s_volume_secret]
      volumes:
      - name: my-secrets-volume
        secret:
          secretName: cloudsql-instance-credentials
      # [START cloud_sql_proxy_k8s_volume_secret]
```
4. **Time to Execute your Deployment**
```bash
#After a few minutes, you can get the status of your pod with the following command:
kubectl create -f pyZineDeployment.yaml
#If everything is set up correctly, you should see a 2/2 indicating both containers inside your pod are running correctly.
NAME                      READY   STATUS    RESTARTS   AGE
pyzine-78c748d56b-jklbw   2/2     Running   0          33m
```

Next, you need to create a service that exposes your deployment to the outside world. We want to forward port 80 to our containers port at 5000, so we can create a LoadBalancer with the following command:
```bash
kubectl expose deployment gmemegen --type "LoadBalancer" --port 80 --target-port 5000
```
After a few minutes, you can describe the service to get the LoadBalancer Ingress

```bash
> kubectl get services
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
kubernetes   ClusterIP      10.55.240.1    <none>           443/TCP        27h
pyzine       LoadBalancer   10.55.250.91   34.126.125.198   80:32031/TCP   34m
```

## 	:penguin: Congratulations!!.

You have successfully launched an application attached to a MySQL Server with High Availability!

<p align="center">
<img src="https://drive.google.com/uc?export=view&id=1KLeCqQ1T-NUc8jwM_2uST4h3ayHjjyaw">
</p>

## :construction: Troubleshooting and Issue.

After provisioning I do face an issue with terraform. Where GKE failed to pull PyZine images from private registry (GCR). After several hours of googling and testing I am able to find and fix the issue. 

```bash
  node_config {
    preemptible  = false
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
```
Notice the oauth_scopes, "https://www.googleapis.com/auth/cloud-platform" it need to be included inside our module in order for GKE cluster to pull the images from GCR. This behavior will not happen if you provision the cluster manually through command line or console. Luckily since we are using Terraform as our IaaC we can easily update our HCL and redeploy GKE without disturbing the DB.

Terraform [taint]("https://www.terraform.io/docs/commands/taint.html") allow us to redeploy the resource that has been tainted. In our case the GKE module will be marked as tainted and replaced on the next terraform apply. 

```bash
# Taint the resource that need to be replaced.
terraform taint module.gke.google_container_node_pool.default 
# Configure a new plan.
terraform plan -var-file="ops.tfvars"
# And Apply.
terraform plan -var-file="ops.tfvars"
```


