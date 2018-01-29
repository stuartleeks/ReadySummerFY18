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
export DEMO_DOMAIN_NAME=azure.faux.ninja
```

### Deploy a cluster
Run the `deploy-cluster.sh` script, e.g.:

```
    deploy/deploy-cluster.sh \
            --resource-group readyprep \
            --location westeurope \
            --cluster-name readyprep \
            --ssh-key ~/.ssh/acs-stuart.pub \
            --admin-username stuart \
            --base-domain azure.faux.ninja
```

The deploy script:
* Creates a resource group
* Creates an AKS deployment
* Deploys VAMP
* Sets up the DNS for vamp.base_domain



## Demo setup

### k8s-rolling

```bash
# deploy pods
./k8s-rolling/deploy-initial.sh 

# wire up dns
./common/dns/set-dns.sh --domain $DEMO_DOMAIN_NAME --subdomain rolling --service-name rolling
```

###  vamp-blue-green

```bash
# initial deployment
./vamp-blue-green/deploy-initial.sh

# wire up dns 
./vamp-blue-green/set-dns-for-gateway.sh --domain $DEMO_DOMAIN_NAME --subdomain bluegreen --gateway-name demo_80 
```
