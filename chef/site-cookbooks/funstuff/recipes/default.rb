bash "fun stuff" do
    user "root"
    cwd "/root"
    code <<-EOH
        git clone https://github.com/rwos/gti.git
        cd gti
        make
        make install
    EOH
end