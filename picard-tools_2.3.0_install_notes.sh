#!/bin/bash



MODULE_NAME=picard-tools
VERSION=2.3.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget https://github.com/broadinstitute/picard/releases/download/2.3.0/picard-tools-2.3.0.zip
unzip -d . picard-tools-2.3.0.zip

cd picard-tools-2.3.0












# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds $MODULE_NAME $VERSION executable to your path."
}


# Update the necessary shell environment variables to make the software work
module load /panfs/roc/soft/modulefiles.legacy/modulefiles.common/java/jdk1.8.0_45

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/picard-tools-2.3.0"
prepend-path CLASSPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/picard-tools-2.3.0"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/picard-tools-2.3.0"
set tmpdir "/scratch.local/\$env(USER)/picard_temp"
exec mkdir -p \$tmpdir
setenv _JAVA_OPTIONS -Djava.io.tmpdir=\$tmpdir
set ptool "java -jar $MODULES_DIR/$MODULE_NAME/$VERSION/picard-tools-2.3.0"
setenv PTOOL \$ptool
puts stderr "picard is set to write temporary files to \$tmpdir"
puts stderr "Invoke a specific picard tool with the command: \$ptool/picard.jar"


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


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory



