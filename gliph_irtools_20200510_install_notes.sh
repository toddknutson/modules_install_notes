#!/bin/bash

# 2021-08-02

# GLIPH version 2

# GROUPING OF LYMPHOCYTE INTERACTIONS BY PARATOPE HOTSPOTS - GLIPH version 2


# GLIPH [Glanville J., Huang H. et al. Nature. 2017 Jul 6;547(7661):94-98]
# GLIPH2 [Huang H., Wang C., et al. Nat Biotechnol 2020 Apr 27; https://doi.org/10.1038/s41587-020-0505-4] 


# Links:
# http://50.255.35.37:8080/tools



MODULE_NAME=gliph_irtools
VERSION=20200510
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# linux executable
wget http://50.255.35.37:8080/downloads/irtools.centos
# Make it executable
chmod a+rx irtools.centos



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/ref_data
cd $MODULES_DIR/$MODULE_NAME/$VERSION/ref_data
wget http://50.255.35.37:8080/downloads/mouse_v1.0.zip
wget http://50.255.35.37:8080/downloads/human_v2.0.zip

unzip -d . mouse_v1.0.zip
unzip -d . human_v2.0.zip




# Test data
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION
wget http://50.255.35.37:8080/downloads/test_data.zip

unzip -d . test_data.zip




# ---------------------------------------------------------------------
# Example usage
# ---------------------------------------------------------------------

# Program: irtools (Tools for analyzing CDR3 sequence data)
# Version: 0.01
# Usage:   irtools -c parameter_file
# A typical parameter_file looks like the following
# #this line will be ignored
# out_prefix=Prefix #entry after this pound sign will be ignored
# cdr3_file=cdr3_file.txt
# hla_file =hla_file.txt
# refer_file=ref_file.txt
# v_usage_freq_file=ref_V.txt
# cdr3_length_freq_file=ref_L.txt
# local_min_pvalue=0.001
# p_depth = 1000
# global_convergence_cutoff = 1
# simulation_depth=1000
# kmer_min_depth=3
# local_min_OVE=10
# algorithm=GLIPH2
# all_aa_interchangeable=1






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOM
#%Module######################################################################

setenv GLIPH_IRTOOLS "$MODULES_DIR/$MODULE_NAME/$VERSION"
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: GLIPH_IRTOOLS, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION"
    puts stderr "To explore the reference or test data supplied by the program, explore the dirs: \\\$GLIPH_IRTOOLS/ref_data or \\\$GLIPH_IRTOOLS/test_data"
}


EOM



# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOM
#%Module
set ModulesVersion "$VERSION"

EOM






# ---------------------------------------------------------------------
# Update permissions
# ---------------------------------------------------------------------


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx






