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



# 2022-12-20


MODULE_NAME=python
VERSION=3.9.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
tar xzvf Python-$VERSION.tgz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/Python-$VERSION



module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load /home/lmnp/knut0297/software/modulesfiles/libffi/3.3


# libffi needs to be available during configure
# https://www.sourceware.org/libffi/
# https://bugs.python.org/issue31652
# https://superuser.com/questions/1412975/how-to-build-and-install-python-3-7-x-from-source-on-debian-9-8
#./configure LDFLAGS='-L/opt/local/lib -R/opt/local/lib'
# https://bugs.python.org/issue31710


# ./configure --help

export LIBFFI_INCLUDEDIR="/home/lmnp/knut0297/software/modules/libffi/3.3/build/include"


./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build \
--enable-optimizations \
--with-system-ffi \
--enable-shared \
CPPFLAGS="-L/home/lmnp/knut0297/software/modules/libffi/3.3/build/lib64 -I/home/lmnp/knut0297/software/modules/libffi/3.3/build/include" \
LDFLAGS="-L/home/lmnp/knut0297/software/modules/libffi/3.3/build/lib64" \
PKG_CONFIG_PATH="/home/lmnp/knut0297/software/modules/libffi/3.3/build/lib/pkgconfig" \
LIBFFI_INCLUDEDIR="/home/lmnp/knut0297/software/modules/libffi/3.3/build/include"




make altinstall -j $THREADS

# NOTE error message:
# make: warning:  Clock skew detected.  Your build may be incomplete.
# You can probably ignore this error message
# https://stackoverflow.com/questions/3824500/compiling-c-on-remote-linux-machine-clock-skew-detected-warning


# 
# Installing collected packages: setuptools, pip
#   WARNING: The script easy_install-3.9 is installed in '/home/lmnp/knut0297/software/modules/python3/3.9.1/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#   WARNING: The script pip3.9 is installed in '/home/lmnp/knut0297/software/modules/python3/3.9.1/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
# Successfully installed pip-20.2.3 setuptools-49.2.1
# make: warning:  Clock skew detected.  Your build may be incomplete.
# 
# 





# ---------------------------------------------------------------------
# Create python alias
# ---------------------------------------------------------------------

cd $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin/python3.9 python
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin/python3.9 python3
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin/pip3.9 pip
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin/pip3.9 pip3


# ---------------------------------------------------------------------
# Consider adding these to modulefile
# ---------------------------------------------------------------------

# Other environment variables:
# PYTHONSTARTUP: file executed on interactive startup (no default)
# PYTHONPATH   : ':'-separated list of directories prefixed to the
#                default module search path.  The result is sys.path.
# PYTHONHOME   : alternate <prefix> directory (or <prefix>:<exec_prefix>).
#                The default module search path uses <prefix>/pythonX.X.
# PYTHONCASEOK : ignore case in 'import' statements (Windows).
# PYTHONIOENCODING: Encoding[:errors] used for stdin/stdout/stderr.
# PYTHONHASHSEED: if this variable is set to 'random', the effect is the same
#    as specifying the -R option: a random value is used to seed the hashes of
#    str, bytes and datetime objects.  It can also be set to an integer
#    in the range [0,4294967295] to get hash values with a predictable seed.




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOM
#%Module######################################################################

module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load /home/lmnp/knut0297/software/modulesfiles/libffi/3.3
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.9/site-packages"

# Add local paths because the above paths will not be writable, causing package installs to
# occur in local dirs.
prepend-path PATH "[getenv HOME]/.local/bin:[getenv PATH]]"
prepend-path PYTHONPATH "[getenv HOME]/.local/lib/python3.9/site-packages:[getenv PYTHONPATH]"

EOM





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


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx





#######################################################################
# Block permissions on system files
#######################################################################

# I do not want anyone (including myself) from writing to the base site-packages dir.
# Remove dir write permissions. If I need to delete these files, change the permissions first.

find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a-w
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a-w







