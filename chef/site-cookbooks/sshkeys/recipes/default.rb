Chef::Log.info("Copying ssh keys")

remote_directory "/home/vagrant/.ssh/" do
    source "ssh"
    owner 'vagrant'
    group 'vagrant'
    mode "0775"
end