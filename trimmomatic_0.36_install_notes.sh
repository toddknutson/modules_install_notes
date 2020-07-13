# 2018-02-14


# Trimmomatic software 
# http://www.usadellab.org/cms/?page=trimmomatic
# sequence trimmer


MODULE_NAME=trimmomatic
VERSION=0.36
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip

unzip Trimmomatic-0.36.zip

cd Trimmomatic-0.36
mkdir bin
cd bin
# Create symlinks for the jar file
ln -s ../trimmomatic-0.36.jar .
ln -s ../trimmomatic-0.36.jar trimmomatic.jar


# Create a merged adapters file
cd $MODULES_DIR/$MODULE_NAME/$VERSION/Trimmomatic-0.36/adapters
cat *.fa > all_illumina_adapters.fasta



# Update permissions
# add executable to world for binaries
chmod -R a+r $MODULES_DIR/$MODULE_NAME/$VERSION
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Trimmomatic-0.36/trimmomatic-0.36.jar

# USAGE:
# java -jar $TRIMMOMATIC/trimmomatic-0.36.jar --help
# java -jar $TRIMMOMATIC/trimmomatic.jar --help


#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds trimmomatic to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location

module load java/openjdk-11.0.2
prepend-path CLASSPATH "/home/lmnp/knut0297/software/modules/trimmomatic/0.36/Trimmomatic-0.36/bin"
prepend-path TRIMMOMATIC "/home/lmnp/knut0297/software/modules/trimmomatic/0.36/Trimmomatic-0.36/bin"
setenv TRIMMOMATIC_ADAPTERS_FASTA "/home/lmnp/knut0297/software/modules/trimmomatic/0.36/Trimmomatic-0.36/adapters/all_illumina_adapters.fasta"
prepend-path PATH "/home/lmnp/knut0297/software/modules/trimmomatic/0.36/Trimmomatic-0.36/bin"



ENDOFMESSAGE








#######################################################################
# Set the version
#######################################################################
cd $MODULESFILES_DIR/$MODULE_NAME
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "0.36"

ENDOFMESSAGE


