bash "fun stuff" do
    user "root"
    cwd "/root"
    code <<-EOH
        git clone https://github.com/rwvagros/gti.git
        cd gti
        make
        make install
    EOH
    subscribes :create, "remote_directory[/home/vagrant/.ssh/]"
end