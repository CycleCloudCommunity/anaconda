#!/bin/bash
#
# See: https://bioconda.github.io/
#
source /etc/profile.d/anaconda-env.sh

# Setup Channels
conda config --add channels conda-forge
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda

# Create the default environments
for PKG in bwa bowtie hisat start; do
    conda install ${PKG}
done

conda create -n aligners bwa bowtie hisat star


