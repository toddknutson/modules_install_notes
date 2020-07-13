#!/bin/bash

# 2019-04-22


#######################################################################
# SUCCESSFUL INSTALL and TESTED - works on 2019-04-22
#######################################################################



# delly structural variant calling
# https://github.com/arq5x/lumpy-sv#installation





MODULE_NAME=delly
VERSION=0.8.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION




# Get executable
# 2019-04-22
wget https://github.com/dellytools/delly/releases/download/v0.8.1/delly_v0.8.1_linux_x86_64bit

# Update permissions
chmod a+x delly_v0.8.1_linux_x86_64bit

# Make a nice name
ln -s delly_v0.8.1_linux_x86_64bit delly 


# Download entire git dir, which provides "exclude" files for human genome
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/github_repo
cd $MODULES_DIR/$MODULE_NAME/$VERSION/github_repo

git clone --recursive https://github.com/dellytools/delly.git

# Exclude templates provided here:
# $MODULES_DIR/$MODULE_NAME/$VERSION/github_repo/delly/excludeTemplates



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds delly executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION"
setenv DELLY_EXCLUDE_TEMPLATES "$MODULES_DIR/$MODULE_NAME/$VERSION/github_repo/delly/excludeTemplates"


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




