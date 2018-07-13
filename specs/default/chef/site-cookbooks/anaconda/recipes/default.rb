#
# Cookbook Name:: anaconda
# Recipe:: default
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

#include_recipe 'apt::default'
# ubuntu: base docker images don't have bzip installed, which the anaconda
# installer needs
#include_recipe 'bzip2::default'
# centos: base docker images don't have tar (?!?)
#include_recipe 'tar::default'


node.default['anaconda']['installer_info'] = {
  'anaconda' => {
    '2.2.0' => {
      'python2' => {
        'uri_prefix' => 'https://repo.continuum.io',
        'x86' => '6437d5b08a19c3501f2f5dc3ae1ae16f91adf6bed0f067ef0806a9911b1bef15',
        'x86_64' => 'ca2582cb2188073b0f348ad42207211a2b85c10b244265b5b27bab04481b88a2',
      },
      'python3' => {
        'uri_prefix' => 'https://repo.continuum.io',
        'x86' => '223655cd256aa912dfc83ab24570e47bb3808bc3b0c6bd21b5db0fcf2750883e',
        'x86_64' => '4aac68743e7706adb93f042f970373a6e7e087dbf4b02ac467c94ca4ce33d2d1',
      },
    },
    '2.3.0' => {
      'python2' => {
        'uri_prefix' => 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com',
        'x86' => '73fdbbb3e38207ed18e5059f71676d18d48fdccbc455a1272eb45a60376cd818',
        'x86_64' => '7c02499e9511c127d225992cfe1cd815e88fd46cd8a5b3cdf764f3fb4d8d4576',
      },
      'python3' => {
        'uri_prefix' => 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com',
        'x86' => '4cc10d65c303191004ada2b6d75562c8ed84e42bf9871af06440dd956077b555',
        'x86_64' => '3be5410b2d9db45882c7de07c554cf4f1034becc274ec9074b23fd37a5c87a6f',
      },
    },
    '4.4.0' => {
      'python2' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => nil,
        'x86_64' => nil,
      },
      'python3' => {
        'uri_prefix' => 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com',
        'x86' => '4cc10d65c303191004ada2b6d75562c8ed84e42bf9871af06440dd956077b555',
        'x86_64' => '3be5410b2d9db45882c7de07c554cf4f1034becc274ec9074b23fd37a5c87a6f',
      },
    },
    '5.0.1' => {
      'python2' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => '88c8d698fff16af15862daca10e94a0a46380dcffda45f8d89f5fe03f6bd2528',
        'x86_64' => '23c676510bc87c95184ecaeb327c0b2c88007278e0d698622e2dd8fb14d9faa4',
      },
      'python3' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => '991a4b656fcb0236864fbb27ff03bb7f3d98579205829b76b66f65cfa6734240',
        'x86_64' => '55e4db1919f49c92d5abbf27a4be5986ae157f074bf9f8238963cd4582a4068a',
      },
    },
  },
  'miniconda' => {
    'latest' => {
      'python2' => {
        'uri_prefix' => 'https://repo.continuum.io/miniconda',
        'x86' => nil,
        'x86_64' => nil,
      },
      'python3' => {
        'uri_prefix' => 'https://repo.continuum.io/miniconda',
        'x86' => nil,
        'x86_64' => nil,
      },
    },
  },
}

if node['anaconda']['install_type'] == 'miniconda'
  Chef::Log.info "Defaulting to Conda version 'latest.'  For #{node['anaconda']['install_type']}, currently only version 'latest' is suppported."
  node.override['anaconda']['version'] = 'latest'
end



# make sure the desired user and group exists
group node['anaconda']['group']
user node['anaconda']['owner'] do
  gid node['anaconda']['group']
  home node['anaconda']['home']
  manage_home true
end

version = node['anaconda']['version']
python_version = node['anaconda']['python']
flavor = node['anaconda']['flavor'] || (
  case node['kernel']['machine']
  when 'i386', 'i686'
    'x86'
  when 'x86_64'
    'x86_64'
  else
    Chef::Log.fatal("Unrecognized node['kernel']['machine']=#{node['kernel']['machine']}; please explicitly node['anaconda']['flavor']")
  end
)
Chef::Log.debug "Autodetected node['kernel']['machine']=#{node['kernel']['machine']}, implying flavor=#{flavor}"
install_type = node['anaconda']['install_type']
installer_info = node['anaconda']['installer_info'][install_type][version][python_version]

# e.g.
# Anaconda-5.0.1-Linux-x86
# Anaconda3-5.0.1-Linux-x86
# Miniconda-latest-Linux-x86
# Miniconda3-latest-Linux-x86
installer_basename =
  if install_type == 'anaconda'
    "Anaconda#{python_version == 'python3' ? '3' : (Gem::Version.new(version) >= Gem::Version.new('4.0.0') ? '2' : '')}-#{version}-Linux-#{flavor}.sh"
  else
    Chef::Log.debug "miniconda installs ONLY have version = latest; setting it now"
    node.default['anaconda']['version'] = 'latest'
    version = 'latest'
    "Miniconda#{python_version == 'python3' ? '3' : '2'}-#{version}-Linux-#{flavor}.sh"
  end
Chef::Log.debug "installer_basename = #{installer_basename}"

# where the installer will install to
anaconda_install_dir = "#{node['anaconda']['install_root']}/#{version}"
# where the installer is downloaded to locally
installer_path = "#{Chef::Config[:file_cache_path]}/#{installer_basename}"
# where to download the installer from
installer_source = "#{installer_info['uri_prefix']}/#{installer_basename}"
installer_checksum = installer_info[flavor]

installer_config = 'installer_config'
installer_config_path = "#{Chef::Config[:file_cache_path]}/#{installer_config}"

# First check if the installer is in blobs
execute "#{node['cyclecloud']['jetpack']['executable']} download #{installer_basename} #{installer_path}  --project anaconda" do
  returns [0, 1]
  not_if { ::File.exists?(installer_path) }
end

# If not, then download  installer from anaconda
remote_file installer_path do
  source installer_source
  checksum installer_checksum
  user node['anaconda']['owner']
  group node['anaconda']['group']
  mode 0755
  not_if { ::File.exists?(installer_path) }
  action :create_if_missing
  notifies :run, 'bash[run anaconda installer]', :delayed
end

template installer_config_path do
  source "#{installer_config}.erb"
  user node['anaconda']['owner']
  group node['anaconda']['group']
  variables({
    :version => version,
    :flavor => flavor,
    :anaconda_install_dir => anaconda_install_dir,
    :accept_license => node['anaconda']['accept_license'],
    :add_to_shell_path => 'no',
  })
end

directory node['anaconda']['install_root'] do
  owner node['anaconda']['owner']
  group node['anaconda']['group']
  recursive true
end

bash 'run anaconda installer' do
  code "cat #{installer_config_path} | bash #{installer_path}"
  user node['anaconda']['owner']
  group node['anaconda']['group']
  action :run
  not_if { File.directory?(anaconda_install_dir) }
end

# Add system-wide path to profile.d
file '/etc/profile.d/anaconda.sh' do
  content "export PATH=$PATH:#{anaconda_install_dir}/bin"
  mode '0755'
  owner 'root'
  only_if { node['anaconda']['system_path'] }
end

defer_block 'Defer until after all anaconda cookbooks run' do
  bash 'ensure conda binaries are executable' do
    code "chmod a+rx #{anaconda_install_dir}/bin/* && chown -R #{node['anaconda']['owner']}:#{node['anaconda']['group']} #{anaconda_install_dir}/bin"
  end
end

