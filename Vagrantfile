# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"
  # config.vm.synced_folder "/home/zvlex/devz/mkdev/step2", "/vagrant", type: "rsync",
    # rsync__exclude: ".git/"
  #
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = './Berksfile'

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "git"
    chef.add_recipe "vim"
    chef.add_recipe "tmux"
    chef.add_recipe "rbenv::default"
    chef.add_recipe "rbenv::ruby_build"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "nodejs::nodejs_from_binary"
    chef.add_recipe "flc"

    chef.json = {
      postgresql: {
        version: '9.5',
        config: {
          listen_addresses: "*"
        },
        pg_hba: [
          {
            type: "local",
            db: "all",
            user: "postgres",
            addr: nil,
            method: "trust"
          }
        ],
        password: {
          postgres: "pgtome1"
        }
      }
    }
  end

  # config.vm.provision :shell, path: 'bootstrap.sh'
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3001, host: 3001

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  #
  config.vm.provider :virtualbox do |libvirt|
    # libvirt.driver = "kvm"
  end
end
