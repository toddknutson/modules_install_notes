#!/bin/bash

# 2020-10-22



# "ichorCNA" software



MODULE_NAME=ichorcna
VERSION=0.2.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Clone everything
git clone --recursive git://github.com/broadinstitute/ichorCNA
cd ichorCNA
# Checkout the newest commit (July 18, 2017)
git checkout 5bfc03ed854f0e93fe5b624c97c1290fa0053837
git reset --hard


# Update permissions
find $MODULES_DIR/$MODULE_NAME/$VERSION/ichorCNA/scripts -name "*.R" -print0 | xargs -0 -I{} chmod u+x {}


# module purge
# module load R/4.0.0_mkl
# Also installed directly as an R package...
# library(devtools)
# install_github("broadinstitute/ichorCNA")




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
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/ichorCNA/scripts"
setenv ICHORCNA_LIBDIR "$MODULES_DIR/$MODULE_NAME/$VERSION/ichorCNA"
setenv ICHORCNA_SCRIPTS "$MODULES_DIR/$MODULE_NAME/$VERSION/ichorCNA/scripts"
setenv ICHORCNA_EXTDATA "$MODULES_DIR/$MODULE_NAME/$VERSION/ichorCNA/inst/extdata"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: \\\$ICHORCNA_LIBDIR, has been set that points to a directory containing the ichorcna library dir."
    puts stderr "An environment variable: \\\$ICHORCNA_SCRIPTS, has been set that points to a directory containing scripts that can be run with Rscript directly."
    puts stderr "An environment variable: \\\$ICHORCNA_EXTDATA, has been set that points to a directory containing example data files to use with the tool."
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







