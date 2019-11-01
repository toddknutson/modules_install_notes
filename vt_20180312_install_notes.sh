# 2018-03-12


# Vt software
# https://genome.sph.umich.edu/wiki/Vt
# A tool set for short variant discovery in genetic sequence data.




MODULE_NAME=vt
VERSION=20180312
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Downloaded from github on 2018-03-12
git clone https://github.com/atks/vt.git
cd vt

module load gcc/4.8.2
module load xz-utils
make

mkdir bin
cd bin

ln -s ../vt .

# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/vt/vt






#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds vt to your path."
}



# Create a variable for this module's bin location
prepend-path PATH "/home/lmnp/knut0297/software/modules/vt/20180312/vt/bin"


ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "20180312"

ENDOFMESSAGE





