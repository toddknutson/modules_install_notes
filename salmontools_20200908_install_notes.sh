#!/bin/bash


# 2020-09-08



MODULE_NAME=salmontools
VERSION=20200908
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Clone everything
git clone --recursive https://github.com/COMBINE-lab/SalmonTools.git


cd SalmonTools
# Checkout the newest commit (June 24, 2020)
git checkout d71b677b0e9174312265b6deeb9658e88bfe381c
git reset --hard
git checkout master


module purge
module load gcc/7.2.0
module load cmake/3.10.2



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/SalmonTools/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION/SalmonTools/build

cmake .. -DCMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION
make
make install


chmod ug+x $MODULES_DIR/$MODULE_NAME/$VERSION/SalmonTools/scripts/generateDecoyTranscriptome.sh


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
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
setenv SALMONTOOLS_SCRIPTS "$MODULES_DIR/$MODULE_NAME/$VERSION/SalmonTools/scripts"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: \\\$SALMONTOOLS_SCRIPTS, has been set that points to a directory containing extra salmontools scripts."
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







