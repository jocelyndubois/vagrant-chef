include_recipe "apache2"

Chef::Log.info("Adding vhosts to apache")

node['vhosts'].each do |name, values|
    web_app name do
      server_name values['server_name']
      server_aliases values['server_aliases']
      docroot values['docroot']
      directory_index values['directory_index']
    end
end