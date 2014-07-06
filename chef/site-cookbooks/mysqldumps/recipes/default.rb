mysql_connection_info = {
  :host => "localhost",
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

if node['mysql_dumps'].nil?
    Chef::Log.info "No mysql dumps to import, let's continue"
else
    node['mysql_dumps'].each do |datas|
        # drop if exists, then create a mysql database named DB_NAME
        mysql_database datas['db_name'] do
          connection mysql_connection_info
          action [:drop, :create]
        end

        # import from a dump file
        if defined?(datas['type']) and datas['type'] == 'postgres'
            mysql_database datas['db_name'] do
              connection mysql_connection_info
              sql "source /vagrant/chef/site-cookbooks/mysqldumps/files/default/#{datas['dump_file']};"
            end
        else
            # import from a dump file
            mysql_database datas['db_name'] do
              connection mysql_connection_info
              sql "source /vagrant/chef/site-cookbooks/mysqldumps/files/default/#{datas['dump_file']};"
            end
        end
    end
end


