#!/bin/bash

# 2022-04-08



# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=fzf
VERSION=0.30.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/bin
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget https://github.com/junegunn/fzf/releases/download/${VERSION}/fzf-${VERSION}-linux_amd64.tar.gz
tar xvf fzf-${VERSION}-linux_amd64.tar.gz

mv fzf bin/




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"

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


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx






# ---------------------------------------------------------------------
# For Todd only: Update my .bashrc with current version
# ---------------------------------------------------------------------

if [ $USER == "knut0297" ]
then
	# Find and replace with current $VERSION
	sed -i "s|$MODULES_DIR/$MODULE_NAME/.*/bin|$MODULES_DIR/$MODULE_NAME/$VERSION/bin|g" /home/lmnp/knut0297/.bashrc
fi





