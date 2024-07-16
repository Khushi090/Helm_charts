# Helm_charts
Helm is an open-source graduated CNCF project originally created by DeisLabs as a third-party utility, now known as the package manager for Kubernetes, focused on automating the Kubernetes applications lifecycle in a simple and consistent way.

The objective of Helm as package manager is to make an easy and automated management (install, update, or uninstall) of packages for Kubernetes applications, and deploy them with just a few commands.


### Why use Helm?
Deploying your applications manually seems complex without using Helm. You will have to define every single YAML configuration, from configuring your workloads to how (and what) you want them to be deployed.

And it’s not only that. After defining and debugging the YAML, think about what will happen after updating the application? You will have to manually remove all created resources and re-deploy them for the new version, which can be slightly mitigated if you create additional files for automation, but that costs additional effort.
Helm is the simplification of this. With Helm, you can simply download your preferred Helm chart, deploy it in the cluster, and update or delete it with low effort. Helm means several benefits for your application:

- Offers Helm charts and repositories where you get everything necessary for deployment and its configurations.
- Official Helm charts are up to date and maintained with new releases.
- Allows you to jump between your preferred versions of the Helm chart.
- Everything with just a single CLI command.

## What is a Helm chart?
We have mentioned Helm charts before, but what are they? Kubernetes applications packages are structured in the Helm packaging format called charts.

A Helm chart is a set of YAML manifests and templates that describes Kubernetes resources (Deployments, Secrets, CRDs, etc.) and defined configurations needed for the Kubernetes application, and is also easy to deploy in a Kubernetes cluster or in a single node with just one command.

The chart keeps its files in a main directory. This directory is what defines the name of the chart and defines the version of the chart package. The chart directory has a specific structure that must be respected, and can also created with helm create command:

The chart.yaml is the file that contains all the metadata about the chart, including dependent helm charts:

This YAML describes the official Falco chart. Falco is a Cloud Native Runtime Security tool for detecting anomalous activity in your application.
The chart.yaml can have two versions, the version tag describes the version of the chart itself and the appVersion indicates the version of the contained application.
The dependencies is a list of charts needed for the current one that Helm will download at the moment of installing the chart. Falco has a dependency with falcosidekick, a daemon for connecting Falco to your ecosystem, taking its events and forwarding them to different outputs in a fan-out way.
Helm chart releases
Did you know that your cluster can run different instances of the same chart? Now you do, and those are called Helm chart releases. A release is an instance of your selected chart running on your Kubernetes Cluster.

That means every time that you install a Helm chart there, it creates a new release or instance that coexists with other releases without conflict.

However, the coexistence relation between releases will depend on the Helm chart. For example, with some charts, there can’t be more than one release (e.g., Falco).

## Installing Helm and Kubernetes

```shell
sudo apt update
```

![image (12)](https://github.com/user-attachments/assets/4560471a-1735-4674-9792-17c028174a56)


```shell 
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

```shell
sudo snap install kubectl --classic
```

- Minikube Install

```shell 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

```shell
sudo apt install -y docker.io
```

![image (13)](https://github.com/user-attachments/assets/3069e4ac-77b9-4f4b-b6a7-5ecff5dfe6f5)

![image (14)](https://github.com/user-attachments/assets/e6072ccf-fcef-4b35-93ba-475f91c908bc)

```shell
sudo systemctl start docker
```

```shell
sudo systemctl enable docker
```

```shell
sudo usermod -aG docker $USER
```

```shell
newgrp docker
```

```shell
sudo apt update
```

```shell
sudo apt install -y VirtualBox
```

![image (15)](https://github.com/user-attachments/assets/b6669282-b105-4bd0-8ad6-22692a3faf3a)

```shell
minikube start --driver=docker
```
![image (16)](https://github.com/user-attachments/assets/3e982cd0-ecaa-49f1-af2f-767513fcb5f6)
