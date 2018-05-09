require 'openssl'

password = node['cyclecloud']['cluster']['user']['password'].dup
salt_len = 6
salt = OpenSSL::Random.random_bytes(salt_len).unpack('H*').first
encoded_password = OpenSSL::Digest::SHA1.hexdigest(password.force_encoding("utf-8") + salt.encode("ASCII"))
shadow_hash = 'sha1:' + salt + ':' + encoded_password

directory node['anaconda']['home'] do
  mode '0755'
  recursive true
  owner node['anaconda']['owner']
  group node['anaconda']['group']
end

directory "#{node['anaconda']['home']}/.jupyter" do
  mode '0755'
  recursive true
  owner node['anaconda']['owner']
  group node['anaconda']['group']
end

directory "#{node['anaconda']['home']}/.local" do
  mode '0755'
  recursive true
  owner node['anaconda']['owner']
  group node['anaconda']['group']
end

template "#{node['anaconda']['home']}/.jupyter/jupyter_notebook_config.py" do
  source 'jupyter_notebook_config.py.erb'
  owner node['anaconda']['owner']
  group node['anaconda']['group']
  variables(
    shadow_hash: shadow_hash
  )
end

template '/usr/lib/systemd/system/jupyter.service' do
  source 'jupyter.service.erb'
  mode '0755'
  owner 'root'
end

#template '/etc/init.d/jupyter' do
#  source 'sv-jupyter-notebook-initd.erb'
#  mode '0755'
#  owner 'root'
#end

service 'jupyter' do
  action :start
  supports(
    restart: true,
    reload: false,
    status: true
  )
end
