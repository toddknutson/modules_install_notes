#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --time=4:00:00
#SBATCH --mem=32gb
#SBATCH --tmp=16gb
#SBATCH --error=%x.e%j
#SBATCH --output=%x.o%j
#SBATCH --export=NONE
#SBATCH --mail-type=ALL
#SBATCH --mail-user=knut0297@umn.edu
#SBATCH --partition=agsmall


#######################################################################
# Script preliminaries
#######################################################################

# Exit script immediately upon error
set -o errexit -o errtrace -o pipefail -o functrace


function trap_my_error {
    >&2 echo "ERROR: \"${BASH_COMMAND}\" command failed with exit code $? [$(date)]"
}

function trap_my_exit {
    echo "[$(date)] Script exit."
    # Print env variables
    declare -p
    # Print slurm job details
    if [ ! -z ${SLURM_JOB_ID+x} ]; then
        scontrol show job "${SLURM_JOB_ID}"
        sstat -j "${SLURM_JOB_ID}" --format=JobID,MaxRSS,MaxVMSize,NTasks,MaxDiskWrite,MaxDiskRead
    fi
}
# Execute these functions after any error (i.e. nonzero exit code) or 
# when exiting the script (i.e. with zero or nonzero exit code).
trap trap_my_error ERR
trap trap_my_exit EXIT


# Prepend MODULPATH with personal software modules
module use /home/lmnp/knut0297/software/modulesfiles

# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)

echo "[$(date)] Script start."

#######################################################################
# Script
#######################################################################





# 2022-07-15


MODULE_NAME=neovim
VERSION=0.7.2
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# wget https://github.com/neovim/neovim/releases/download/v${VERSION}/nvim-linux64.tar.gz
# tar xvzf nvim-linux64.tar.gz


wget https://github.com/neovim/neovim/archive/refs/tags/v${VERSION}.tar.gz
tar xvzf v${VERSION}.tar.gz
cd neovim-${VERSION}



# Prerequisites
# Clang or GCC version 4.4+
# CMake version 3.10+, built with TLS/SSL support

module purge
module load gcc/7.2.0
module load ninja/0.97
module load /home/lmnp/knut0297/software/modulesfiles/cmake/3.21.1

which Ninja
which libtool
which autoconf
which automake
which cmake
which gcc 
which c++ 
which make 
which pkg-config 
which unzip 
which patch 
which gettext 
which curl

# This is a problem. cc (/usr/bin/cc) is a symlink to the default gcc on the system, not the loaded gcc module
which cc
# Therefore, set 'CC=gcc make' before make, so make finds the right gcc module (not cc)

export CC=gcc
# Build neovim from source
# (Do not add a -j flag if ninja is installed! The build will be in parallel automatically.)
CC=gcc make \
CMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION/build \
CMAKE_BUILD_TYPE=Release \
install


# This needs to be done before running nvim
# module load gcc/7.2.0
# export CC=gcc
# nvim

# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


cat > $VERSION <<HEREDOC
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"

HEREDOC





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<HEREDOC
#%Module
set ModulesVersion "$VERSION"

HEREDOC







# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx






