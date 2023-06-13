#!/bin/env bash
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




MODULE_NAME=cellranger
VERSION=7.1.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
# Sign in with email, accept terms and conditions.
# They provide a unique download link (below)
wget -O cellranger-7.1.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.1.0.tar.gz?Expires=1683363771&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci03LjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2ODMzNjM3NzF9fX1dfQ__&Signature=oTOAorsVZ-VArOKjGn-aNFEIXxfWV78PHn63o-rOki-kMAfLr-py--i5PSVcpu1Sig87CNNpICllW8mPh0l-3jly5szXxVgQDChch3JyhSCHA048E65lwK0HmqAc0wWnYfdFhQhtQ~qqXfTE7rsRBu3aEixG9jy5qOj6EZ6fCTE9ZHJsw9kPj5f7PZW2t1lEZk0ENEKrymxaUTMy8DYUL9sAeMHs8Z6ldM14qYZedEUzj5Wl5Ezay5dRdDr~Lf8QHNZoNTeOFakM5WBBMoat2I0SNzkM~wy5MdvKA4WzDK648y3cQq038TP8s8qSsiSiPoMgROA42BGCFo2gKCDLPA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar xvzf cellranger-${VERSION}.tar.gz



# ---------------------------------------------------------------------
# References
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads
cd $MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads


# Mouse
wget https://cf.10xgenomics.com/supp/cell-vdj/refdata-cellranger-vdj-GRCm38-alts-ensembl-7.0.0.tar.gz
tar xzvf refdata-cellranger-vdj-GRCm38-alts-ensembl-7.0.0.tar.gz
 
wget https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-mm10-2020-A.tar.gz
tar xzvf refdata-gex-mm10-2020-A.tar.gz


# Human
wget https://cf.10xgenomics.com/supp/cell-vdj/refdata-cellranger-vdj-GRCh38-alts-ensembl-7.1.0.tar.gz
tar xzvf refdata-cellranger-vdj-GRCh38-alts-ensembl-7.1.0.tar.gz

wget https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCh38-2020-A.tar.gz
tar xzvf refdata-gex-GRCh38-2020-A.tar.gz




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/cellranger-${VERSION}"
setenv CELLRANGER_REFS "$MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads"
setenv CELLRANGER_BARCODES "$MODULES_DIR/$MODULE_NAME/$VERSION/cellranger-${VERSION}/lib/python/cellranger/barcodes"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: CELLRANGER_REFS, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads"
    puts stderr "An environment variable: CELLRANGER_BARCODES, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/cellranger-${VERSION}/lib/python/cellranger/barcodes"
}


EOF





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOF
#%Module
set ModulesVersion "$VERSION"

EOF






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w
find $MODULESFILES_DIR/$MODULE1_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx,go-w
# Note: there are no executable files in the modulesfiles directory




