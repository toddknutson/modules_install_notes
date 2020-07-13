# 2018-02-02


# Kraken software 
# https://github.com/DerrickWood/kraken
# nucleotide based kmer taxonomer


MODULE_NAME=kraken
VERSION=1.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


git clone https://github.com/DerrickWood/kraken.git



cd kraken
mkdir bin
./install_kraken.sh bin



# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/kraken/bin






#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds kraken to your path."
}



# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/kraken/1.1/kraken/bin"
prepend-path PATH $BASEDIR

# Update the Perl5 path
set perlpath "/home/lmnp/knut0297/software/modules/kraken/1.1/kraken/bin"
prepend-path PERL5LIB $perlpath

set perlpath "/home/lmnp/knut0297/software/modules/kraken/1.1/kraken/bin"
prepend-path PERLLIB $perlpath

# Set a environment variable
setenv KRAKEN_DIR /home/lmnp/knut0297/software/modules/kraken/1.1/kraken/bin




ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "1.1"

ENDOFMESSAGE





