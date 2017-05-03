#!/bin/bash

source /etc/profile.d/anaconda-env.sh

ANACONDA_ROOT=$( jetpack config anaconda.install_root )
ANACONDA_VERSION=$( jetpack config anaconda.version )
ANACONDA_HOME=${ANACONDA_ROOT}/${ANACONDA_VERSION}

# Set up the condarc for all users:
cat <<EOF > /etc/profile.d/anaconda_setup.sh
source /etc/profile.d/anaconda-env.sh

export ANACONDA_HOME=${ANACONDA_ROOT}/${ANACONDA_VERSION}

if [ ! -f ~/.condarc ]; then
  conda config --add envs_dirs \${HOME}/.conda/envs
fi
EOF
chmod a+rx /etc/profile.d/anaconda_setup.sh

YML_ENVS=$( find ${CYCLECLOUD_SPEC_PATH}/files/conda_envs -name "*yml" -type f )

for YML in ${YML_ENVS}; do
    ENV_NAME=$( basename ${YML%.yml} )
    
    echo "Creating conda env: ${ENV_NAME}"
    if conda info --envs | grep -q ${ENV_NAME}; then
        echo "Skipping $YML - conda environment already exists."
        conda info --envs
    else
        conda env create -f ${YML}
    fi
done

