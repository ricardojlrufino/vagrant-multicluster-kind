# -*- mode: ruby -*-
# vi: set ft=ruby :

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

Vagrant.configure("2") do |config|

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|

      node.vm.box = "ricardojlrufino/vagrant-box-bionic64-kind" # 18.04
      #config.vm.box_version = "0.1.0"
      config.vm.box_version = "0" # local
      node.vm.network "public_network", bridge: 'wlp0s20f3', ip: machine[:ip]
      node.vm.hostname = machine[:hostname]
      node.vm.provision :shell, path: "deploy_example.sh",  :args => [machine[:appname], machine[:ip]]

      node.vm.provider "virtualbox" do |v|
        v.memory = 2096
        v.cpus = 2
        v.name = machine[:hostname]
      end
    end
  end  

end
