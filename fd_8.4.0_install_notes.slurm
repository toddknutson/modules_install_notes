#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=96
#SBATCH --time=1:00:00
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




# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)

echo "[$(date)] Script start."

#######################################################################
# Script
#######################################################################





# 2022-10-10



MODULE_NAME=fd
VERSION=8.4.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/bin
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://github.com/sharkdp/fd/releases/download/v${VERSION}/fd-v${VERSION}-x86_64-unknown-linux-musl.tar.gz
tar xvzf fd-v${VERSION}-x86_64-unknown-linux-musl.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/bin 
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/fd-v${VERSION}-x86_64-unknown-linux-musl/fd .



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


cat > $VERSION <<HEREDOC
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"

# For autocompletion, source this file:
# . "$MODULESFILES_DIR/$MODULE_NAME/fd-v${VERSION}-x86_64-unknown-linux-musl/autocomplete/fd.bash"

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






