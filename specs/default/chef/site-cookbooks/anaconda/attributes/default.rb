# for miniconda this must be 'latest'
default['anaconda']['version'] = '5.0.1'
# the version of python: either 'python2' or 'python3'
default['anaconda']['python'] = 'python2'
# the architecture: nil to autodetect, or either 'x86' or 'x86_64'
default['anaconda']['flavor'] = nil
# either 'anaconda' or 'miniconda'
default['anaconda']['install_type'] = 'anaconda'
# add system-wide path to profile.d?
default['anaconda']['system_path'] = false


# specific versions are installed _under_ this directory
default['anaconda']['install_root'] = "/opt/#{node['anaconda']['install_type']}"
default['anaconda']['accept_license'] = 'yes'
default['anaconda']['package_logfile'] = nil

default['anaconda']['owner'] = 'anaconda'
default['anaconda']['group'] = 'anaconda'
default['anaconda']['home'] = "/home/#{node['anaconda']['owner']}"

default['anaconda']['notebook'] = {
  # by default, listens on all interfaces; there will be a warning since
  # security is disabled
  'ip' => '*',
  'port' => 8888,
  'owner' => node['anaconda']['owner'],
  'group' => node['anaconda']['group'],
  'install_dir' => '/opt/jupyter/server',
  # the default is to NOT set the security token, to ensure that a secure key
  # is chosen and set
  'use_provided_token' => false,
  'token' => '',
}
