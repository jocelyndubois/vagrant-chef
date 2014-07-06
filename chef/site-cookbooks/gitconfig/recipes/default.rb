Chef::Log.info("Copying .gitignore_global file")

cookbook_file "/home/vagrant/.gitignore_global" do
  source ".gitignore_global"
  owner "vagrant"
  action :create_if_missing
end

username = node['git']['username']
email = node['git']['email']

bash "config git globals" do
    user "vagrant"
    cwd "/home/vagrant"
    environment 'HOME' => '/home/vagrant'
    code <<-EOH
        git config --global color.ui true
        git config --global core.excludesfile "~/.gitignore_global"
        git config --global user.name #{username}
        git config --global user.email #{email}
    EOH
    action :run
end