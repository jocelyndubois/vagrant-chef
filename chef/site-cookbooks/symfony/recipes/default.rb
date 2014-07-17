sf_dist = "/home/share/symfony/"

# Ensure directory is created
directory "/home/share/symfony/" do
    owner 'root'
    group 'www-data'
    mode "0777"
    action :create
    recursive true
end

# Download and install symfony
node['global_symfony'].each do |datas|
    bash "Download symfony 1.x and copy" do
        user "root"
        cwd "/home/share/symfony"
        code <<-EOH
          wget http://pear.symfony-project.com/get/#{datas['dist']}.tgz
          tar -zxf #{datas['dist']}.tgz
          mv #{datas['dist']} #{datas['version']}
          rm #{datas['dist']}.tgz
        EOH
        action :run
        subscribes :create, "/home/share/symfony/"
    end
end
