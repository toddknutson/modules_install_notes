#!/bin/bash


# Compare NGS datasets to make sure samples are the same




MODULE_NAME=ngscheckmate
VERSION=1.0.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Clone everything
git clone --recursive git://github.com/parklab/NGSCheckMate.git
cd NGSCheckMate
# Checkout the newest commit (May 7, 2019 -- 19 commits past ver 1.0.0)
git checkout 8ea2c043896adf9bbd1dc5bb2136f3a1dab9b445



# There is a unaccepted pull request that has an important fix. Get it.
# https://stackoverflow.com/questions/14947789/github-clone-from-pull-request
# https://coderwall.com/p/z5rkga/github-checkout-a-pull-request-as-a-branch
git fetch origin refs/pull/31/head:pullrequest_31
git checkout pullrequest_31





# Update permissions on executables
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -name "*.py" -print0 | xargs -0 -I{} chmod u+x {}






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
        puts stderr "\tThis module adds $MODULE_NAME $VERSION to your path."
}


# Update the necessary shell environment variables to make the software work
module load python2/2.7.15
module load R/3.3.3
module load samtools/0.1.19
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/NGSCheckMate"
setenv NGSCHECKMATE_INSTALL_DIR "$MODULES_DIR/$MODULE_NAME/$VERSION/NGSCheckMate"


# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: \\\$NGSCHECKMATE_INSTALL_DIR, has been set that points to a directory containing NGSCheckMate scripts."
}



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
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







