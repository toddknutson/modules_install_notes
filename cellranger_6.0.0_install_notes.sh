#!/bin/bash




MODULE_NAME=cellranger
VERSION=6.0.0
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

wget -O cellranger-6.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.0.0.tar.gz?Expires=1615284001&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjAuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MTUyODQwMDF9fX1dfQ__&Signature=kQrptICSUOtbN27OwHwYw0mkblxbwTLQfD6tZ7ZE-y1Pg5X36DpE5kYkOPcugNHtsLkxjuNfpDezajOycnluNbj68kKpqMmRY9rECFMEGcLxII655BWpnLlua-pBrZFmJeAqxYbKHvXqwxImDKP148RcC-dlQrCIV3v7H~gaTnqLfwCCJEouGLTxhbsLzvHYD~7z5lOVU3yx28X7LqFJKSVI-MbXdrqTwgcHu4O66b8QAYTE8C-k85NiYCzDs7jiSXYNCROyY5GOghvkPuijFQqGzyDbWK0aWgpwqZEKHlKCSgawgYhSyQ2UxYA~NK4lAt7zyTnDHP3Kaq~24e2YiQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar xvzf cellranger-${VERSION}.tar.gz


# NOTE: the refs have not changed since the previous versions. 
# Use a symlink to the previous module data
ln -s /panfs/roc/groups/0/lmnp/knut0297/software/modules/cellranger/5.0.1/ref_downloads $MODULES_DIR/$MODULE_NAME/$VERSION/



# 
# wget https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-mm10-2020-A.tar.gz
# tar xzvf refdata-gex-mm10-2020-A.tar.gz
# 
# wget https://cf.10xgenomics.com/supp/cell-vdj/refdata-cellranger-vdj-GRCm38-alts-ensembl-5.0.0.tar.gz
# tar xzvf refdata-cellranger-vdj-GRCm38-alts-ensembl-5.0.0.tar.gz
# 



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/cellranger-${VERSION}"
setenv CELLRANGER_REFS "$MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: \\\$CELLRANGER_REFS, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads"
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




