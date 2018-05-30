#!/bin/bash

source /etc/profile.d/anaconda-env.sh

ANACONDA_ROOT=$( jetpack config anaconda.install_root )
ANACONDA_VERSION=$( jetpack config anaconda.version )
ANACONDA_HOME=${ANACONDA_ROOT}/${ANACONDA_VERSION}

# Set up the condarc for all users:
cat <<EOF > /etc/profile.d/anaconda_setup.sh
source /etc/profile.d/anaconda-env.sh

export ANACONDA_HOME=${ANACONDA_ROOT}/${ANACONDA_VERSION}

if [ ! -f ~/.condarc ]  && [ "\$( whoami )" != "root" ]; then
  conda config --add envs_dirs \${HOME}/.conda/envs
fi
EOF
chmod a+rx /etc/profile.d/anaconda_setup.sh

PKG_LISTS=$( find ${CYCLECLOUD_SPEC_PATH}/files/conda_pkgs -name "*list" -type f )

for PKG_LIST in ${PKG_LISTS}; do
    
    echo "Installing conda packages from : $PKG_LIST"
    conda install -y --file $PKG_LIST
    
done

