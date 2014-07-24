node['postgresql']['users'].each do |datas|
    postgresql_database_user 'create_user' do
        connection(
            :host     => '127.0.0.1',
            :port     => node['postgresql']['port'],
            :username => node['postgresql']['username'],
            :password => node['postgresql']['password'][node['postgresql']['username']]
        )
        username datas['username']
        password datas['password']
        action :create
    end
end