# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 6005, host: 6005
  config.vm.synced_folder "..", "/vagrant_dev"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8096"
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end
  config.vm.provision :shell, path: "bootstrap.sh"
end
