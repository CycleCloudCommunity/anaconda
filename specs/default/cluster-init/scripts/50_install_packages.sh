#!/bin/bash

source /etc/profile.d/anaconda-env.sh

ANACONDA_ROOT=$( jetpack config anaconda.install_root )
ANACONDA_VERSION=$( jetpack config anaconda.version )
ANACONDA_HOME=${ANACONDA_ROOT}/${ANACONDA_VERSION}

ANACONDA_PACKAGES=$( jetpack config anaconda.packages )

set -x
set -e


if [ ! -z "${ANACONDA_PACKAGES}" ]  && [ "${ANACONDA_CHANNELS}" != "None" ]; then
    echo "Installing conda packages : ${ANACONDA_PACKAGES}"
    conda install -y ${ANACONDA_PACKAGES}
fi




