#!/bin/bash

# 2021-10-11




MODULE_NAME=abra2
VERSION=2.24
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://github.com/mozack/abra2/releases/download/v2.24/abra2-2.24.jar

chmod u+x abra2-2.24.jar

# Create a symlink without version number
ln -s abra2-2.24.jar abra2.jar



 
 

# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

# MSI modules
module load java/openjdk-8_202

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION"
prepend-path CLASSPATH "$MODULES_DIR/$MODULE_NAME/$VERSION"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION"


set tmpdir "/tmp/\$env(USER)/abra2_temp"
exec mkdir -p \$tmpdir
setenv _JAVA_OPTIONS -Djava.io.tmpdir=\$tmpdir
setenv ABRA2_JAR "$MODULES_DIR/$MODULE_NAME/$VERSION/abra2-2.24.jar"



# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "$MODULE_NAME is set to write temporary files to \$tmpdir"
    puts stderr "An environment variable: ABRA2_JAR, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/abra2-2.24.jar"
    puts stderr "To execute the program, try: java -jar \\\$ABRA2_JAR"
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


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx




