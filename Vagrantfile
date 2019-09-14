# -*- mode: ruby *-*
# vi: set ft=ruby
 
if Vagrant::VERSION == '1.8.5'
  ui = Vagrant::UI::Colored.new
  ui.error 'Unsupported Vagrant Version: 1.8.5'
  ui.error 'Version 1.8.5 introduced an SSH key permissions bug, please upgrade to version 1.8.6+'
  ui.error ''
end
 
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.ssh.insert_key = false
  config.vm.box_check_update = false
 
  config.vm.box = "fedora31"
 
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = "qemu:///system"
    libvirt.qemu_use_session = false
  end
 
  cluster = {
    "master-1" => { :box => "dongsupark/coreos-stable", :ip => "10.10.10.11", :cpus => 2, :memory => 2048, :playbook => "kubernetes-setup/master-playbook.yml" },
    "worker-1" => { :box => "dongsupark/coreos-stable", :ip => "10.10.10.21", :cpus => 1, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook.yml" },
    "worker-2" => { :box => "dongsupark/coreos-stable", :ip => "10.10.10.22", :cpus => 1, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook.yml" },
    "worker-3" => { :box => "dongsupark/coreos-stable", :ip => "10.10.10.23", :cpus => 1, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook.yml" },
    "worker-4" => { :box => "fedora/30-cloud-base", :ip => "10.10.10.24", :cpus => 1, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook-fedora.yml" },
    "client-1" => { :box => "fedora31", :ip => "10.10.10.31", :cpus => 1, :memory => 2048, :playbook => "kubernetes-setup/client-playbook.yml" },
  }
 
  cluster.each do | hostname, specs |
    config.vm.define hostname do |node|
      node.vm.box = specs[:box]
      node.vm.hostname = hostname
      node.vm.network :private_network, ip: specs[:ip]
      node.vm.provision "ansible" do |ansible|
            ansible.playbook = specs[:playbook]
            ansible.inventory_path = "kubernetes-setup/hosts"
            ansible.extra_vars = {
                node_ip: specs[:ip],
                target: hostname,
            }
        end

      node.vm.provider :libvirt do |libvirt|
        libvirt.cpus   = specs[:cpus]
        libvirt.memory = specs[:memory]
        if specs.key?(:disk)
          libvirt.storage :file, :size => specs[:disk]
        end
      end
    end
  end
 
end
