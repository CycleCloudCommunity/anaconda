#!/bin/bash

source /etc/profile.d/anaconda-env.sh

ANACONDA_HOME=$( jetpack config anaconda.home )

ANACONDA_PACKAGES=$( jetpack config anaconda.packages )

set -x
set -e


if [ ! -z "${ANACONDA_PACKAGES}" ]  && [ "${ANACONDA_PACKAGES}" != "None" ]; then
    echo "Installing conda packages : ${ANACONDA_PACKAGES}"
    conda install -y ${ANACONDA_PACKAGES}
fi




