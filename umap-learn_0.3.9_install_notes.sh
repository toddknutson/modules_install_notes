#!/bin/bash

# 2019-07-09


#######################################################################
# 
#######################################################################






MODULE_NAME=umap-learn
VERSION=0.3.9
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget https://files.pythonhosted.org/packages/d9/15/ced881a7af6184c5556dbffbfc82750904a18c6fdafb248ca84873d0be06/umap-learn-0.3.9.tar.gz
tar -xvzf umap-learn-0.3.9.tar.gz


# Install python
# More info:
# http://stackoverflow.com/questions/2915471/install-a-python-package-into-a-different-directory-using-pip?rq=1


# Set up a folder for all python3 stuff called "build"
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build

# Move into src dir
cd $MODULES_DIR/$MODULE_NAME/$VERSION/umap-learn-0.3.9


module purge
module load python3/3.6.3_anaconda5.0.1



# Install using this command:
PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --upgrade --ignore-installed $MODULES_DIR/$MODULE_NAME/$VERSION/umap-learn-0.3.9




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
        puts stderr "\tThis module adds R 3.6.1 executable to your path."
}


# Update the necessary shell environment variables to make the software work
module load python3/3.6.3_anaconda5.0.1
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.6/site-packages"


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







