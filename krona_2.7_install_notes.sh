#!/bin/bash
# 2017-10-16

# Krona pie chart visualization


MODULE_NAME=krona
VERSION=2.7
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This cloned version is 26 commits past the official release
git clone https://github.com/marbl/Krona.git


cd $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools

# Install the software. This will create a bin directory in the current directory containing
# all of the necessary executables
./install.pl --prefix /home/lmnp/knut0297/software/modules/krona/2.7/Krona/KronaTools



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



# OUTPUT:
# Installation complete.
# 
# Run ./updateTaxonomy.sh to use scripts that rely on NCBI taxonomy:
#    ktClassifyBLAST
#    ktGetLCA
#    ktGetTaxInfo
#    ktImportBLAST
#    ktImportTaxonomy
#    ktImportMETAREP-BLAST
# 
# Run ./updateAccessions.sh to use scripts that get taxonomy IDs from accessions:
#    ktClassifyBLAST
#    ktGetTaxIDFromAcc
#    ktImportBLAST








# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/scripts
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/lib
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/deployResources.sh
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/install.pl
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/updateAccessions.sh
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Krona/KronaTools/updateTaxonomy.sh




###### OLD INFO THAT MIGHT BE USEFUL IN THE FUTURE #######
# Instead of running "updateTaxonomy.sh", I will simply copy over the same taxonomy database
# that John Garbe uses in his "gopher-pipelines" scripts. That way, all the taxonomy databases
# are the same. If we update Kraken, we'll also update our Krona taxonomy so they are in sync.


# John's taxonomy is located here:
# /home/umii/public/gopher-pipelines/1.5/software/KronaTools-2.7

# remove the empty taxonomy dir that came with the installation
rm -r /home/vdl/public/vdltools/1.0/software/KronaTools-2.7/taxonomy
# link to Garbe's taxonomy.
ln -s /home/umii/public/gopher-pipelines/1.5/software/KronaTools-2.7/taxonomy /home/vdl/public/vdltools/1.0/software/KronaTools-2.7/taxonomy


# FYI
# 2016-10-14
# Both the Krona and Kraken taxonomy databases were updated. 
# The kraken database (k8) was also updated on 2016-11-23, so they should have the same
# taxonomy/gi/accession database.

################## 












#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds krona to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/krona/2.7/Krona/KronaTools/bin"
prepend-path PATH $BASEDIR
set BASEDIR "/home/lmnp/knut0297/software/modules/krona/2.7/Krona/KronaTools/lib"
prepend-path PATH $BASEDIR
set BASEDIR "/home/lmnp/knut0297/software/modules/krona/2.7/Krona/KronaTools/scripts"
prepend-path PATH $BASEDIR
set BASEDIR "/home/lmnp/knut0297/software/modules/krona/2.7/Krona/KronaTools"
prepend-path PATH $BASEDIR


# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

#prepend-path PATH $BASEDIR





ENDOFMESSAGE





