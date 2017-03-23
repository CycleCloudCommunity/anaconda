# for miniconda this must be 'latest'
default.anaconda.version = '4.3.0'
# the version of python: either 'python2' or 'python3'
default.anaconda.python = 'python2'
# the architecture: nil to autodetect, or either 'x86' or 'x86_64'
default.anaconda.flavor = nil
# either 'anaconda' or 'miniconda'
default.anaconda.install_type = 'anaconda'

default.anaconda.installer_info = {
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
    '4.2.0' => {
      'python2' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => '618b720f309fe8da4f235415f11b6ce3db0a16d702ca67fdceeecf6bec78c32a',
        'x86_64' => 'beee286d24fb37dd6555281bba39b3deb5804baec509a9dc5c69185098cf661a',
        },
      'python3' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => '1a8320635f2f06ec9d8610e77d6d0f9cb2c5d11d20a4ff7fcda113e04b0a8a50',
        'x86_64' => '73b51715a12b6382dd4df3dd1905b531bd6792d4aa7273b2377a0436d45f0e78',
        },
      },
    '4.3.0' => {
      'python2' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => 'b80d471839e8cf7b100e59308720cc13c141deb1ba903a4776c9a05f613e5078',
        'x86_64' => '7c52e6e99aabb24a49880130615a48e685da444c3c14eb48d6a65f3313bf745c',
        },
      'python3' => {
        'uri_prefix' => 'https://repo.continuum.io/archive',
        'x86' => 'f7ce2eeec3e42c2ba1ee3b9fcd670478fd30f4be547c6e0a675d183c4ca9dd9b',
        'x86_64' => 'e9169c3a5029aa820393ac92704eb9ee0701778a085ca7bdc3c57b388ac1beb6',
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

# specific versions are installed _under_ this directory
default.anaconda.install_root = '/opt/anaconda'
default.anaconda.accept_license = 'yes'
default.anaconda.package_logfile = nil

default.anaconda.owner = 'anaconda'
default.anaconda.group = 'anaconda'
default.anaconda.home = "/home/#{node["anaconda"]["owner"]}"

default.anaconda.notebook = {
  # by default, listens on all interfaces; there will be a warning since
  # security is disabled
  'ip' => '*',
  'port' => 8888,
  'owner' => node["anaconda"]["owner"],
  'group' => node["anaconda"]["group"],
  'install_dir' => '/opt/ipython/server',
  'memory' => '20G'
}

