#!/bin/bash
# 2021-06-15


# Trimmomatic software 
# http://www.usadellab.org/cms/?page=trimmomatic
# sequence trimmer


MODULE_NAME=trimmomatic
VERSION=0.39
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Commit e77bb89
# Download compiled jar file
wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-${VERSION}.zip

unzip Trimmomatic-${VERSION}.zip

cd Trimmomatic-${VERSION}
mkdir bin
cd bin
# Create symlinks for the jar file
ln -s ../trimmomatic-${VERSION}.jar .
ln -s ../trimmomatic-${VERSION}.jar trimmomatic.jar


# Create a merged adapters file
cd $MODULES_DIR/$MODULE_NAME/$VERSION/Trimmomatic-${VERSION}/adapters
cat *.fa > all_illumina_adapters.fasta



# Update permissions
# add executable to world for binaries
chmod -R a+r $MODULES_DIR/$MODULE_NAME/$VERSION
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Trimmomatic-${VERSION}/trimmomatic-${VERSION}.jar

# USAGE:
# java -jar $TRIMMOMATIC/trimmomatic-${VERSION}.jar --help
# java -jar $TRIMMOMATIC/trimmomatic.jar --help


#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

module load java/openjdk-11.0.2
prepend-path CLASSPATH "/home/lmnp/knut0297/software/modules/trimmomatic/${VERSION}/Trimmomatic-${VERSION}/bin"
setenv TRIMMOMATIC "/home/lmnp/knut0297/software/modules/trimmomatic/${VERSION}/Trimmomatic-${VERSION}/bin"
setenv TRIMMOMATIC_ADAPTERS_FASTA "/home/lmnp/knut0297/software/modules/trimmomatic/${VERSION}/Trimmomatic-${VERSION}/adapters/all_illumina_adapters.fasta"
prepend-path PATH "/home/lmnp/knut0297/software/modules/trimmomatic/${VERSION}/Trimmomatic-${VERSION}/bin"

setenv CELLRANGER_REFS "$MODULES_DIR/$MODULE_NAME/$VERSION/ref_downloads"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: TRIMMOMATIC, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION//Trimmomatic-${VERSION}/bin"
    puts stderr "To execute the program, try: java -jar \\\$TRIMMOMATIC/trimmomatic.jar --help"
}



EOF






# ---------------------------------------------------------------------
# Set the version
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






