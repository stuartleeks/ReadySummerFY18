#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

#
# Argument parsing and validation
#

RESOURCE_GROUP=""
LOCATION=""
CLUSTER_NAME=""
SSH_KEY=""
ADMIN_USERNAME=""

function show_usage(){
    echo "deploy-cluster"
    echo
    echo -e "\t--resource-group\tThe resource group to deploy to"
    echo -e "\t--location\tThe location to deploy to"
    echo -e "\t--cluster-name\tThe name of the cluster to deploy"
    echo -e "\t--ssh-key\tThe ssh key to use"
    echo -e "\t--admin-username\tThe administrator user name for the cluster"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --resource-group)
            RESOURCE_GROUP="$2"
            shift 2
            ;;
        --location)
            LOCATION="$2"
            shift 2
            ;;
        --cluster-name)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        --ssh-key)
            SSH_KEY="$2"
            shift 2
            ;;
        --admin-username)
            ADMIN_USERNAME="$2"
            shift 2
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

if [ -z $RESOURCE_GROUP ]; then
    echo "resource-group not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $LOCATION ]; then
    echo "location not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $CLUSTER_NAME ]; then
    echo "cluster-name not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $SSH_KEY ]; then
    echo "ssh-key not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $ADMIN_USERNAME ]; then
    echo "admin-username not specified"
    echo
    show_usage
    exit 1
fi


#
# Create the resource group
#

if [[  $(az group exists --name $RESOURCE_GROUP -o tsv) == "false" ]]; then 
    echo "Resource group $RESOURCE_GROUP not found. Creating..."
    az group create --name $RESOURCE_GROUP --location $LOCATION > /dev/null
    if [ $? -eq 0 ]; then
        echo "Resource group created"
    else
        echo "Error - exiting"
        exit 1
    fi
else
    echo "Resource group $RESOURCE_GROUP exists"
fi

#
# Create the cluster
#
az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Cluster $CLUSTER_NAME exists"
else
    echo "Cluster $CLUSTER_NAME not found. Creating..."
    az aks create --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --location $LOCATION --dns-name $CLUSTER_NAME --ssh-key-value $SSH_KEY --admin-username $ADMIN_USERNAME
    if [ $? -eq 0 ]; then
        echo "Cluster created"
    else
        echo "Error - exiting"
        exit 1
    fi
fi
