Vagrant.configure("2") do |config|
    # Vagrant plugins config
    config.cache.scope = :box
    config.omnibus.chef_version = :latest
    config.librarian_chef.cheffile_dir = "chef"

    # Box
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Networking
    config.vm.network :private_network, ip: "10.10.10.2"

    # Synced folders
    config.vm.synced_folder "./", "/var/www", type: "nfs"

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
        chef.add_recipe "mysql::server"
        chef.add_recipe "mysql::remote-access"
        chef.add_recipe "php"
        chef.add_recipe "php::module_mysql"
        chef.add_recipe "php::module_apc"
        chef.add_recipe "php::module_curl"
        chef.add_recipe "xdebug"
        chef.add_recipe "apache2::mod_php5"
        chef.add_recipe "composer"

        chef.json = {
            :apache => {
                :default_site_enabled => true
            },
            :mysql => {
                :server_root_password => "root",
                :server_debian_password => "root",
                :server_repl_password => "root",
                :mysql_bin => "/usr/bin/mysql",
                :bind_address => "0.0.0.0"
            },
            :php => {
                :directives => {
                    "date.timezone" => "Europe/London"
                }
            },
            :xdebug => {
                :idekey => "lamp-vagrant-dev",
                :remote_enable => 1,
                :remote_connect_back => 1
            }
        }
    end
end