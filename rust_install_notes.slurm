#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --time=8:00:00
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
    if [ -n "${SLURM_JOB_ID+x}" ]; then
        scontrol show job "${SLURM_JOB_ID}"
        sstat -j "${SLURM_JOB_ID}" --format=JobID,MaxRSS,MaxVMSize,NTasks,MaxDiskWrite,MaxDiskRead
    fi
}
# Execute these functions after any error (i.e. nonzero exit code) or 
# when exiting the script (i.e. with zero or nonzero exit code).
trap trap_my_error ERR
trap trap_my_exit EXIT


# If not a slurm job, set THREADS to 1
THREADS=$([ -n "${SLURM_CPUS_PER_TASK+x}" ] && echo "${SLURM_CPUS_PER_TASK}" || echo 1)
export THREADS

echo "[$(date)] Script start."

#######################################################################
# Script
#######################################################################





MODULE_NAME=rust
VERSION=current
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

curl https://sh.rustup.rs -sSf | sh





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOM
#%Module######################################################################

# This module is only supported for Todd Knutson (knut0297). Everyone should install
# rust on their own (and use their own home dir).
prepend-path PATH "[getenv HOME]/.cargo/bin:[getenv PATH]]"

EOM





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<ENDOFMESSAGE
#%Module
set ModulesVersion "$VERSION"

ENDOFMESSAGE







#######################################################################
# Block permissions on system files
#######################################################################

# This module is only supported for Todd Knutson (knut0297). Everyone should install
# rust on their own (and use their own home dir).

# Make this module NOT readable or writeable by anyone except Todd Knutson (knut0297).

chmod go-rwx $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod go-rwx
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod go-rwx
chmod go-rwx $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod go-rwx
