#!/bin/bash
# 2019-02-25

# Krona pie chart visualization


MODULE_NAME=krona
VERSION=2.7.plus42commits
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This cloned version is 42 commits past the official release
git clone https://github.com/marbl/Krona.git


cd $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools

# Install the software. This will create a bin directory in the current directory containing
# all of the necessary executables
./install.pl --prefix "$MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools"




# Fix the symlinks -- point to files using /home/ instead of /panfs/roc/
readarray -t FILES <<<"ClassifyHits
ClassifyBLAST
GetContigMagnitudes
GetLCA
GetLibPath
GetTaxIDFromAcc
GetTaxInfo
ImportBLAST
ImportDiskUsage
ImportEC
ImportFCP
ImportGalaxy
ImportHits
ImportKrona
ImportMETAREP-BLAST
ImportMETAREP-EC
ImportMGRAST
ImportPhymmBL
ImportRDP
ImportRDPComparison
ImportTaxonomy
ImportText
ImportXML"

echo "${FILES[@]}"
echo "${#FILES[@]}"
echo "${!FILES[@]}"


cd $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/bin
rm *
for i in "${!FILES[@]}"
do
    ln -s "${MODULES_DIR}/${MODULE_NAME}/${VERSION}/Krona/KronaTools/scripts/${FILES[$i]}.pl" "kt${FILES[$i]}"
done




# Instead of running "updateTaxonomy.sh", I will simply copy over an updated taxonomy dir
# from the kraken installation. That way, both kraken and krona will use the same exact 
# taxonomy information.
DEFAULT_TAXONOMY_DIR=/home/arbefevi/shared/ris/csf_pathogens/databases/2018-02-13/ncbi_taxonomy
ln -s $DEFAULT_TAXONOMY_DIR $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/taxonomy








#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds krona to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.



# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/bin"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/lib"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/scripts"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools"



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




