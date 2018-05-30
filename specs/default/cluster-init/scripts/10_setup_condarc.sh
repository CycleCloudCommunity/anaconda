#!/bin/bash

set -v

source /etc/profile.d/anaconda-env.sh

ANACONDA_ROOT=$( jetpack config anaconda.install_root )
ANACONDA_VERSION=$( jetpack config anaconda.version )
ANACONDA_HOME=${ANACONDA_ROOT}/${ANACONDA_VERSION}

set -x


cat > ${ANACONDA_HOME}/.condarc << 'CONDA'
channels:
  - bioconda
  - conda-forge
  - defaults
  - r

conda-build:
    skip_existing: true

CONDA


