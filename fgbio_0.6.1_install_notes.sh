#!/bin/bash
# 2018-05-30

# fgbio

# Links:
https://github.com/fulcrumgenomics/fgbio



MODULE_NAME=fgbio
VERSION=0.6.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/fulcrumgenomics/fgbio/releases/download/0.6.1/fgbio-0.6.1.jar

# Make it executable
chmod a+rx fgbio-0.6.1.jar


# Example usage
# java -jar fgbio-0.6.1.jar <command>



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
        puts stderr "\tThis module adds fgbio to your path."
}


# Update the necessary shell environment variables to make the software work
module load java/jdk1.8.0_144
set-alias fgbio "java -jar $MODULES_DIR/$MODULE_NAME/$VERSION/fgbio-0.6.1.jar"
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION




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
find $MODULES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







