# -*- mode: ruby -*-
# vi: set ft=ruby :

def mirror_port(config, port)
  config.vm.network "forwarded_port", guest: port, host: port
end

def share_home(config, dir)
  config.vm.synced_folder File.expand_path("~/#{dir}"), "/home/vagrant/#{dir}"
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  mirrored_ports = [6005, 8000, 8080]
  mirrored_ports.each do |p|
    mirror_port(config, p)
  end

  config.vm.synced_folder "..", "/vagrant_dev"

  [".aws", ".m2", ".lein", ".vim"].each do |dir|
    share_home(config, dir)
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8096"
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end
  config.vm.provision :shell, path: "bootstrap.sh"
end
