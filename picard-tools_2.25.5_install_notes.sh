#!/bin/bash



MODULE_NAME=picard-tools
VERSION=2.25.5
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget https://github.com/broadinstitute/picard/releases/download/${VERSION}/picard.jar

chmod a+x picard.jar








# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

module load java/jdk1.8.0_171

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION"
prepend-path CLASSPATH "$MODULES_DIR/$MODULE_NAME/$VERSION"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION"
set tmpdir "/tmp/\$env(USER)/picard_temp"
exec mkdir -p \$tmpdir
setenv _JAVA_OPTIONS -Djava.io.tmpdir=\$tmpdir
set ptool "$MODULES_DIR/$MODULE_NAME/$VERSION/picard.jar"
setenv PICARD_JAR \$ptool


# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "picard is set to write temporary files to \$tmpdir"
    puts stderr "\\\$PICARD_JAR environment variable is set to: \$ptool"
    puts stderr "For example, to get help with MarkDuplicates, run the command: java -jar \\\$PICARD_JAR MarkDuplicates --help"
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


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory



