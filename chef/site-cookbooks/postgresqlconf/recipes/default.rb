node['postgresql']['users'].each do |datas|
    postgresql_database_user 'create_user' do
        connection(
            :host     => 'localhost',
            :port     => node['postgresql']['port'],
            :username => node['postgresql']['username'],
            :password => node['postgresql']['password']
        )
        username datas['username']
        password datas['password']
        action :create
    end
end

bash "change setting of postgres" do
    user "root"
    cwd "/root"
    code <<-EOH
        rm /etc/postgresql/9.2/main/pg_hba.conf

        echo "# This file was automatically generated and dropped off by Chef!

        # PostgreSQL Client Authentication Configuration File
        # ===================================================
        #
        # Refer to the "Client Authentication" section in the PostgreSQL
        # documentation for a complete description of this file.

        # TYPE  DATABASE        USER            ADDRESS                 METHOD

        ###########
        # Other authentication configurations taken from chef node defaults:
        ###########

        local   all             postgres                                ident

        local   all             all                                     ident

        host    all             all             0.0.0.0/0               md5

        host    all             all             ::1/128                 md5

        # "local" is for Unix domain socket connections only
        local   all             all                                     peer" > /etc/postgresql/9.2/main/pg_hba.conf

        rm /etc/postgresql/9.2/main/postgresql.conf

        echo "# PostgreSQL configuration file
        # This file was automatically generated and dropped off by chef!
        # Please refer to the PostgreSQL documentation for details on
        # configuration settings.

        data_directory = '/var/lib/postgresql/9.2/main'
        datestyle = 'iso, mdy'
        default_text_search_config = 'pg_catalog.english'
        external_pid_file = '/var/run/postgresql/9.2-main.pid'
        hba_file = '/etc/postgresql/9.2/main/pg_hba.conf'
        ident_file = '/etc/postgresql/9.2/main/pg_ident.conf'
        listen_addresses = '*'
        log_line_prefix = '%t '
        max_connections = 100
        port = 5432
        shared_buffers = '24MB'
        ssl = on
        ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
        ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'
        unix_socket_directory = '/var/run/postgresql'" > /etc/postgresql/9.2/main/postgresql.conf

        sudo /etc/init.d/postgresql restart

        sudo -u postgres psql -c "update pg_database set datallowconn = TRUE where datname = 'template0';"
        sudo -u postgres psql -c "\c template0"
        sudo -u postgres psql -c "update pg_database set datistemplate = FALSE where datname = 'template1';"
        sudo -u postgres psql -c "drop database template1;"
        sudo -u postgres psql -c "create database template1 with encoding = 'UTF-8' lc_collate = 'en_US.UTF8' lc_ctype = 'en_US.UTF8' template = template0;"
        sudo -u postgres psql -c "update pg_database set datistemplate = TRUE where datname = 'template1';"
        sudo -u postgres psql -c "\c template1"
        sudo -u postgres psql -c "update pg_database set datallowconn = FALSE where datname = 'template0';"
    EOH
end