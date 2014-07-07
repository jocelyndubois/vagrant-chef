# Load yaml settings
require 'yaml'

unless File.exists? ("config.yml")
    raise 'You must define a config.yml file, just copy config.yml.dist and change the values as you want'
end

unless File.directory? ("chef/site-cookbooks/sshkeys/files/default/ssh")
    raise 'You must copy your ssh keys into chef/site-cookbooks/sshkeys/files/default/ssh'
end

settings = YAML.load_file 'config.yml'


USE_PRECONFIGURED_LAMP_BOX = false

Vagrant.configure("2") do |config|
    # Vagrant plugins config
    config.cache.scope = :box

    config.omnibus.chef_version = settings['chef_version']
    if settings['chef_version'] == 'latest'
        config.omnibus.chef_version = :latest
    end

    config.librarian_chef.cheffile_dir = "chef"

    # Box
    if USE_PRECONFIGURED_LAMP_BOX
        config.vm.box = "lamp-vagrant-chef-solo"
        config.vm.box_url = "https://dl.dropboxusercontent.com/u/13070740/vagrant-base-boxes/lamp-vagrant-chef-solo.box"
    else
        config.vm.box = "precise64"
        config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    end

    config.vm.provider "virtualbox" do |v|
        v.memory = settings['memory']
    end

    # Networking
    config.vm.network :private_network, ip: settings['ip']

    # Synced folders
    config.vm.synced_folder "/var/www/html", "/var/www", type: "nfs"

    # Provision via chef solo
    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = [
            "chef/cookbooks",
            "chef/site-cookbooks"
        ]

        chef.add_recipe "apt"
        chef.add_recipe "git"
        chef.add_recipe "vim"
        chef.add_recipe "apache2"
        chef.add_recipe "apache2::mod_rewrite"
        chef.add_recipe "apache2::mod_alias"
        chef.add_recipe "apache2::mod_php5"
        chef.add_recipe "mysql::server"
        chef.add_recipe "mysql-chef_gem"
        chef.add_recipe "database::mysql"
        # chef.add_recipe "database::postgresql"
        chef.add_recipe "php"
        chef.add_recipe "php::module_apc"
        chef.add_recipe "php::module_curl"
        chef.add_recipe "php::module_gd"
        chef.add_recipe "php::module_mcrypt"
        chef.add_recipe "php::module_mysql"
        chef.add_recipe "php::apache2"
        chef.add_recipe "xdebug"
        chef.add_recipe "composer"

        # Projects recipes
        chef.add_recipe "gitconfig"
        chef.add_recipe "vhosts"
        chef.add_recipe "symfony"
        chef.add_recipe "sshkeys"
        chef.add_recipe "bashconfig"
        chef.add_recipe "mysqldumps"
        chef.add_recipe "funstuff"

        chef.json = {
            :apache => {
                :default_site_enabled => settings['apache']['default_site_enabled']
            },
            :mysql => {
                :server_root_password => settings['mysql']['server_root_password'],
                :server_debian_password => settings['mysql']['server_debian_password'],
                :server_repl_password => settings['mysql']['server_repl_password'],
                :allow_remote_root => settings['mysql']['allow_remote_root']
            },
            :mysql_dumps => settings['mysql_dumps'],
            :php => {
                :ini_settings => {
                    "date.timezone" => settings['phpini']['date.timezone'],
                    "display_errors" => settings['phpini']['display_errors'],
                    "error_reporting" => settings['phpini']['error_reporting'],
                    "display_startup_errors" => settings['phpini']['display_startup_errors'],
                    "version" => settings['phpini']['version']
                }
            },
            :xdebug => {
                :remote_enable => settings['xdebug']['remote_enable'],
                :remote_connect_back => settings['xdebug']['remote_connect_back']
            },
            :git => {
                :username => settings['git']['username'],
                :email => settings['git']['email'],
            },
            :vhosts => settings['vhosts'],
            :global_symfony => settings['global_symfony']
        }
    end
end
