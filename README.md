# vagrant-multicluster-kind

Example to create a kubernets multi-cluster using Kind + Vagrant + Virtualbox


## Description

This repository contains everything needed to build multi-cluster vagrant box. This box is based on the hashicorp/bionic64, a standard Ubuntu 18.04 LTS 64-bit provided by Hashicorp.

The cluster created by kind will have an ingres controller (nginx) and a local docker registry.
Also, in the nginx-app-example are the manifests required to deploy an application on top of kubernetes.

This base-box is used: 
https://github.com/ricardojlrufino/vagrant-box-bionic64-kind


## Usage
You can use the base box like any other base box. 

## Prerequisites:

Install [Vagrant](https://www.vagrantup.com/docs/installation) and [Virtualbox](https://www.vagrantup.com/docs/providers/virtualbox).


## Using:

Clone this repo:
```
$ git clone git@github.com:galvarado/vagrant-box-bionic64-kind.git
```

Edit your servers in `Vagrantfile`

```
servers=[
  {
    :hostname => "cluster1",
    :appname => "pcb-app-a",
    :ip => "192.168.0.201"
  }
  # ,{
  #   :hostname => "cluster2",
  #   :appname => "vip-app-b",
  #   :ip => "192.168.0.202"
  # }
]


```

Create the box:
```
$ vagrant up
```

Login with ssh:
```
$ vagrant ssh clusterX
```

After machine boot, you will find a `.kube` folder, with kubernetes config. You can use to iteract with cluster

.Get the k8s details with kubectl:

```
$ kubectl cluster-info
Kubernetes master is running at https://127.0.0.1:46157
KubeDNS is running at https://127.0.0.1:46157/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

Ready to shine! You are ready to deploy applications on kubernetes.

