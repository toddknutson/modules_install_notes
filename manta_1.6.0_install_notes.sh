#!/bin/bash

# 2021-06-08


#######################################################################
# SUCCESSFUL INSTALL and TESTED - 2021-06-08
#######################################################################



# manta illumina structural variation calling
# https://github.com/Illumina/manta/releases





MODULE_NAME=manta
VERSION=1.6.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

# Get source code
wget https://github.com/Illumina/manta/archive/v1.6.0.tar.gz

# Get executable
wget https://github.com/Illumina/manta/releases/download/v1.6.0/manta-1.6.0.centos6_x86_64.tar.bz2
tar -vxjf manta-1.6.0.centos6_x86_64.tar.bz2






# Test help page
# configManta.py --help

# Run test data
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/run_test_data_2021-06-08
cd $MODULES_DIR/$MODULE_NAME/$VERSION/run_test_data_2021-06-08
$MODULES_DIR/$MODULE_NAME/$VERSION/manta-1.6.0.centos6_x86_64/bin/runMantaWorkflowDemo.py
# Successful




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/manta-1.6.0.centos6_x86_64/bin"
setenv MANTA_INSTALL_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/manta-1.6.0.centos6_x86_64"

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




