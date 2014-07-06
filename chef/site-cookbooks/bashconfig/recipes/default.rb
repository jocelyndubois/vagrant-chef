cookbook_file "/home/vagrant/.bashrc" do
  source ".bashrc"
  owner "vagrant"
  group "vagrant"
  action :create
end