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
#  config.vm.box_check_update = false
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = "qemu:///system"
    libvirt.qemu_use_session = false
  end

  config.vm.define "master-1", primary: true do |master|
          master.vm.box = "coreos"
          master.ssh.username = "core"
          master.vm.network "private_network", ip: "10.10.10.11"
          master.vm.network :public_network, bridge: 'enp1s0f0', :dev => 'enp1s0f0'
          master.vm.hostname = "master-1"
          master.vm.provision "ansible" do |ansible|
              ansible.playbook = "kubernetes-setup/master-playbook.yml"
              ansible.inventory_path = "kubernetes-setup/hosts"
              ansible.verbose = "-vv"
              ansible.extra_vars = {
                  node_ip: "10.10.10.11",
              }
          end
          master.vm.provider :libvirt do |libvirt|
            libvirt.cpus   = 4
            libvirt.memory = 4096
          end


   end


 
  cluster = {
    "worker-1" => { :box => "coreos", :ip => "10.10.10.21", :cpus => 4, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook.yml" },
#    "worker-2" => { :box => "coreos", :ip => "10.10.10.22", :cpus => 2, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook.yml" },
#    "worker-3" => { :box => "dongsupark/coreos-stable", :ip => "10.10.10.23", :cpus => 1, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook.yml" },
    "worker-4" => { :box => "fedora/30-cloud-base", :ip => "10.10.10.24", :cpus => 1, :memory => 4096, :disk => "20G", :playbook => "kubernetes-setup/node-playbook-fedora.yml" },
    "client-1" => { :box => "fedora31", :ip => "10.10.10.31", :cpus => 1, :memory => 1024, :playbook => "kubernetes-setup/client-playbook.yml" },
  }
 
  cluster.each do | hostname, specs |
    config.vm.define hostname do |node|
#      node.ssh.username = "core"
      node.vm.box = specs[:box]
      node.vm.hostname = hostname
      node.vm.network :private_network, ip: specs[:ip]
      node.vm.network :public_network, bridge: 'enp1s0f0', :dev => 'enp1s0f0'
      node.vm.provision "ansible" do |ansible|
            ansible.playbook = specs[:playbook]
            ansible.inventory_path = "kubernetes-setup/hosts"
            ansible.verbose = "-vv"
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
