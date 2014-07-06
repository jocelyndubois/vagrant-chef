sf_dist = "/home/share/symfony/"

# Ensure directory is created
directory "/home/share/symfony/" do
    owner 'root'
    group 'www-data'
    mode "0777"
    action :create
end

# Download and install symfony
node['global_symfony'].each do |datas|
    bash "Download symfony 1.x and copy" do
        subscribes :create, "directory[/home/share/symfony/]"
        user "root"
        cwd "/home/share/symfony"
        code <<-EOH
          wget http://pear.symfony-project.com/get/#{datas['dist']}.tgz
          tar -zxf #{datas['dist']}.tgz
          mv #{datas['dist']} #{datas['version']}
          rm #{datas['dist']}.tgz
        EOH
    end
end
