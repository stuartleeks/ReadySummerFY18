# ReadySummerFY18
Demos for our internal conference


## Initial Installation steps

Pre-requisites
 * Azure CLI
 * kubectl (although this can be installed via `az aks install-cli` once the Azure CLI is installed :-))


### Set up Azure DNS 

Set up Azure DNS for use in the demos.

Then set up some environment variables for the later scripts

```bash
export AZDNS_RESOURCE_GROUP=dnstest
export READY_DOMAIN_NAME=azure.faux.ninja
```




### Create a k8s cluster

```bash
# create a resource group
az group create --name mydemos --location ukwest

# create the managed kubernetes cluster
# run az aks --help to see other options (kubernetes version, agent VM sku, SSH key, ...)
az aks create --resource-group mydemos --name democluster --agent-count 4

# setup up kubernetes credentials for kubectl
az aks get-credentials  --resource-group mydemos --name democluster

# verify kubectl connection
kubectl cluster-info
```

### Deploy VAMP

The VAMP quickstart installer can be downloaded from [here](https://github.com/magneticio/vamp.io/blob/master/static/res/v0.9.5/vamp_kube_quickstart.sh).

To install VAMP

```bash
./vamp_kube_quickstart.

# wait for the IP Address for the vamp service to be set (TODO - script this with a wait)
./common/dns/set-a-record.sh --domain $READY_DOMAIN_NAME --subdomain vamp --ip $(kubectl get service vamp -o jsonpath={.status.loadBalancer.ingress[0].ip}) 
```

## Demo setup

### k8s-rolling

```bash
# deploy pods
./k8s-rolling/deploy-initial.sh 

# wire up dns
./common/dns/set-dns.sh --domain $READY_DOMAIN_NAME --subdomain rolling --service-name rolling
```

###  vamp-blue-green

```bash
# initial deployment
./vamp-blue-green/deploy-initial.sh

# wire up dns 
./vamp-blue-green/set-dns-for-gateway.sh --domain $READY_DOMAIN_NAME --subdomain bluegreen --gateway-name demo_80 
```
