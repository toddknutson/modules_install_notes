#!/bin/bash
# 2018-05-30

# fgbio

# Links:
https://github.com/fulcrumgenomics/fgbio



MODULE_NAME=fgbio
VERSION=1.3.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/fulcrumgenomics/fgbio/releases/download/${VERSION}/fgbio-${VERSION}.jar

# Make it executable
chmod a+rx fgbio-${VERSION}.jar

# Create symlink for the jar file
ln -s fgbio-${VERSION}.jar fgbio.jar


# Example usage
# java -jar fgbio-${VERSION}.jar <command>
# java -jar fgbio.jar <command>


# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

# Update the necessary shell environment variables to make the software work
module load java/openjdk-11.0.2
setenv FGBIO "$MODULES_DIR/$MODULE_NAME/$VERSION"
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: FGBIO, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/fgbio-${VERSION}"
    puts stderr "To execute the program, try: java -jar \\\$FGBIO/fgbio.jar --help"
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
find $MODULES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







