#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
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


# 2023-01-10




MODULE_NAME=oncokb
VERSION=3.3.1_python_3.7.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p "${MODULES_DIR}/${MODULE_NAME}/${VERSION}/build"
cd "${MODULES_DIR}/${MODULE_NAME}/${VERSION}"


git clone "https://github.com/oncokb/oncokb-annotator"
cd oncokb-annotator
git checkout tags/v3.3.1
git reset --hard

# Make python scripts executabled
find ./*.py -print0 | xargs -0 -I{} chmod u+x {}

# Change shebang to use env python, not hardcoded ver
# so these files can be run as standalone scripts from any dir
find ./*.py -print0 | xargs -0 -I{} sed -i '1d' {}
find ./*.py -print0 | xargs -0 -I{} sed -i '1i#!/usr/bin/env python3' {}


module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10


PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed -r requirements/common.txt
PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed -r requirements/pip3.txt


# Note: An OncoKB authorization token needs to be generated at "https://www.oncokb.org/apiAccess"
# and stored as an environment variable that can be used by the scripts.
#
# # Example:
# cat > ~/.oncokb <<HEREDOC
# #!/bin/env bash
# ONCOKB_TOKEN=""
# export ONCOKB_TOKEN
# HEREDOC

# . ~/.oncokb
# MafAnnotator.py -b "${ONCOKB_TOKEN}"




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p "${MODULESFILES_DIR}/${MODULE_NAME}"
cd "${MODULESFILES_DIR}/${MODULE_NAME}"




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/oncokb-annotator"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.7/site-packages"


ENDOFMESSAGE





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<ENDOFMESSAGE
#%Module
set ModulesVersion "$VERSION"

ENDOFMESSAGE






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







