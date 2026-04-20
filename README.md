## Run locally

### Docker Compose


docker compose -f docker-compose-quickstart.yml up --build

store-front -> http://localhost:8080


### Local Kubernetes - minikube (Windows)


 1. Start the cluster
minikube start

 2. Enable the bundled NGINX Ingress controller
minikube addons enable ingress

3. Wait for the controller to be Running
kubectl get pods -n ingress-nginx --watch
Ctrl+C once ingress-nginx-controller-* is Running

4. Deploy the app
kubectl apply -f k8s/manifest.yaml

5. Wait for store-front to be Ready
kubectl -n aks-store rollout status deploy/store-front

6. Get the Ingress address

kubectl get ingress -n aks-store

NAME          CLASS   HOSTS         ADDRESS         PORTS
store-front   nginx   store.local   192.168.49.2    80


Map the host to the Ingress IP

The hostname in k8s/manifest.yaml (store.local by default) is fake — no
public DNS resolves it. Add it to your local hosts file so the browser can find
your cluster.

Open "C:\Windows\System32\drivers\etc\hosts" **as Administrator** and add a
line **outside** the Docker-managed block, using the IP from step 6:


192.168.49.2   store.local


Then flush DNS and open the page:

ipconfig /flushdns



curl http://store.local or open http://store.local in a browser


#### Windows + Docker driver

If minikube ip is unreachable from your host (common on Windows + Docker
driver), run minikube tunnel in a separate terminal and use 127.0.0.1
instead of the minikube IP in your hosts file:


127.0.0.1   store.local


## Provision AKS with Terraform

cd terraform

terraform init

terraform plan

terraform apply

### Expected output

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

acr_login_server = "aksstoreacrtrg8y.azurecr.io"

acr_name = "aksstoreacrtrg8y"

aks_name = "aks-aksstore"

kubeconfig = <sensitive>

resource_group = "rsg-aksstore"


## CI/CD pipeline (Azure DevOps)

azure-pipelines.yml defines two stages:

- **CI**: builds store-front, order-service, product-service Docker images,
  runs unit tests, pushes images tagged $(Build.BuildId) to ACR.
- **CD**: deploys via helm upgrade --install to AKS, overriding image tags.

### Configure once

In Azure DevOps -> Project settings -> Service connections, create:

| Name              | Type                | Points to              |
| ----------------- | ------------------- | ---------------------- |
| acr-connection  | Docker Registry     | Your ACR               |
| azure-rm-conn   | Azure Resource Mgr  | Subscription with AKS  |

Set pipeline variables:

| Variable           | Example                  |
| ------------------ | ------------------------ |
| acrName          | aksstoredemoacr        |
| aksClusterName   | aks-aksstore           |
| aksResourceGroup | rg-aksstore            |
| helmReleaseName  | aks-store              |

Trigger by pushing to main (or run manually).

## 4. Deploy with Helm


helm upgrade --install aks-store ./charts/aks-store \
  --namespace aks-store --create-namespace \
  --set image.tag=$(git rev-parse --short HEAD) \ 2.1.0
  --set image.repository=$ACR_LOGIN_SERVER


The chart includes:
- Per-service Deployment + Service
- Ingress (NGINX class) routing / -> store-front
- NetworkPolicy per service (default-deny + explicit allow)
- Resource requests / limits on every container

## Cleanup

helm uninstall aks-store -n aks-store

cd terraform && terraform destroy

