IMAGE_NAME = "dongsupark/coreos-stable"
N = 1

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "libvirt" do |v|
        v.memory = 2048
        v.cpus = 2
        v.driver = "kvm"
        v.uri = "qemu:///system"
        v.qemu_use_session = false
    end
      
    config.vm.define "testing" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "10.10.50.10"
        master.vm.hostname = "k8s-master"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "kubernetes-setup/master-playbook.yml"
            ansible.inventory_path = "kubernetes-setup/hosts"
            ansible.extra_vars = {
                node_ip: "10.10.50.10",
            }
        end
    end
 end
