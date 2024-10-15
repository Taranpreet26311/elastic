# elastic

### Prerequisites and Initial installation

This repository contains manifests that will be deployed a VPC and GKE cluster in GCP. After this we will deploy an elastic cluster

There are a few requirements to satisfy before we proceed
1. Helm
2. Terraform
3. A GCP account


To install terraform use

`brew install terraform`

and for Helm

`brew install helm`

### Creating the cluster using terraform

Now we will use terraform to create the cluster. Set the required values in gke.tfvars or create a new file with different vars.

`cd terraform && terraform init && terraform plan -var-file="gke.tfvars"`

If everything seems alright apply

`terraform apply -var-file="gke.tfvars"`

The cluster will spin up in 5-10 mins. As per default values it will spin up a 3 node GKE cluster with on a new VPC and Subnet

### Install Elastic

To install Elasticsearch, we will first login to cluster

`gcloud container clusters get-credentials test-cluster --region us-central1 --project <PROJECT ID>>`

Now install the chart. We will use Bitnami's Elasticsearch chart

`helm repo add bitnami https://charts.bitnami.com/bitnami`

And then run

`helm install <DEPLOYMENET-NAME>  oci://registry-1.docker.io/bitnamicharts/elasticsearch -f elasticsearch/values.yaml`

This will deploy an Elasticseach cluster with 3 nodes each of coordinator, master, ingestor and data. Along with this it will also spin up a Kibana node.

We have set affinity in such a way no component will have its replica on the same K8s node. For example; master will have replica on different nodes of K8s cluster

### Stack decision

1. We choose GKE for deployement due ease of managing a serivce like Elasticsearch compared to VMs. It might be complex manage it via Instance group or other services.

2. Terraform was chosen to automate the deployment of Infrastrucure and destroying it easily

3. Helm made it easier to deploy Elastic from a single values file instead of having to managed dozens of yaml files