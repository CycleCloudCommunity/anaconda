#!/bin/bash

source /etc/profile.d/anaconda-env.sh

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

