#!/bin/bash


# Ensembl
# variant effect predictor

# https://useast.ensembl.org/info/docs/tools/vep/script/vep_download.html

MODULE_NAME=vep
VERSION=104.3
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# ---------------------------------------------------------------------
# Install dependencies
# ---------------------------------------------------------------------


module purge
module load gcc/7.2.0
module load perl/5.26.1
module load perl/modules.centos7.5.26.1
module load /home/lmnp/knut0297/software/modulesfiles/htslib/1.12
module load /home/lmnp/knut0297/software/modulesfiles/samtools/1.12


# Check if perl libraries are installed
perldoc -l Archive::Zip
perldoc -l DBI
perldoc -l DBD::mysql
perldoc -l Set::IntervalTree
perldoc -l JSON
perldoc -l PerlIO::gzip
perldoc -l Bio::Perl
perldoc -l Math::CDF
# This was missing
perldoc -l Bio::DB::BigFile
#perl -e 'use Bio::DB::BigFile; print $Bio::DB::BigFile::VERSION;'





# The Bio::DB::BigFile module depends on the Kent source tree
# Install Jim Kent source  tree
# Following these instructions
# https://useast.ensembl.org/info/docs/tools/vep/script/vep_download.html#installer
cd $MODULES_DIR/$MODULE_NAME/$VERSION
wget https://github.com/ucscGenomeBrowser/kent/archive/v335_base.tar.gz
tar xzf v335_base.tar.gz
export KENT_SRC=$PWD/kent-335_base/src
export MACHTYPE=$(uname -m)
export CFLAGS="-fPIC"
export MYSQLINC=`mysql_config --include | sed -e 's/^-I//g'`
export MYSQLLIBS=`mysql_config --libs`
cd $KENT_SRC/lib
echo 'CFLAGS="-fPIC"' > ../inc/localEnvironment.mk

make clean && make
cd ../jkOwnLib
make clean && make


# Install Bio::DB::BigFile
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/cpanm
export PERL5LIB="$PERL5LIB:$MODULES_DIR/$MODULE_NAME/$VERSION/cpanm/lib/perl5"
cpanm -l $MODULES_DIR/$MODULE_NAME/$VERSION/cpanm Bio::DB::BigFile
# Test the installation
perldoc -l Bio::DB::BigFile









# ---------------------------------------------------------------------
# Download and install VEP
# ---------------------------------------------------------------------


# Get the latest commit 
cd $MODULES_DIR/$MODULE_NAME/$VERSION
git clone https://github.com/Ensembl/ensembl-vep.git
cd $MODULES_DIR/$MODULE_NAME/$VERSION/ensembl-vep
git checkout f155014

# Resets the index and working tree. Any changes to tracked files in the working tree 
# since <commit> are discarded. Thus, this permanently changes the files to match current HEAD
# and destroys all previous commits. 
git reset --hard

cd $MODULES_DIR/$MODULE_NAME/$VERSION
tar czf ensembl-vep.tar.gz ensembl-vep/
cd $MODULES_DIR/$MODULE_NAME/$VERSION/ensembl-vep

# Install VEP
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache/Plugins



# Check out available Plugins
# http://grch37.ensembl.org/info/docs/tools/vep/script/vep_plugins.html#g2p
# perl INSTALL.pl -a p --PLUGINS list

 
 
# Install VEP
perl INSTALL.pl \
--AUTO acfp \
--CACHEDIR "$MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache" \
--PLUGINSDIR "$MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache/Plugins" \
--PLUGINS "DisGeNET,G2P,NearestGene,SpliceAI,gnomADc,Mastermind,Carol,Draw" \
--SPECIES "homo_sapiens" \
--ASSEMBLY "GRCh37"
 
# Some harmless warnings will occur when installing
# https://github.com/Ensembl/ensembl-vep/issues/914
# https://github.com/bioperl/bioperl-live/issues/355





# ---------------------------------------------------------------------
# bgzip primary assembly
# ---------------------------------------------------------------------

# The fasta files supplied to vcf2maf need to be compressed 
cd $MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache/homo_sapiens/104_GRCh37

# Decompress regular gzip file
gzip -d Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
# Re-compress using bgzip
bgzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa
# Build a samtools fasta index
samtools faidx Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz



# ---------------------------------------------------------------------
# Test the installation
# ---------------------------------------------------------------------

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/vep_test
cd $MODULES_DIR/$MODULE_NAME/$VERSION/vep_test

wget https://raw.githubusercontent.com/Ensembl/ensembl-vep/release/${VERSION}/examples/homo_sapiens_GRCh37.vcf

$MODULES_DIR/$MODULE_NAME/$VERSION/ensembl-vep/vep --cache \
--species homo_sapiens \
--assembly GRCh37 \
--input_file homo_sapiens_GRCh37.vcf \
--output_file homo_sapiens_GRCh37.txt \
--format vcf \
--stats_file homo_sapiens_GRCh37.html \
--fork $THREADS \
--dir $MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache \
--tab \
--fields "SYMBOL,Gene,Feature,Feature_type,Consequence,cDNA_position,CDS_position,IMPACT,HGNC_ID,BIOTYPE,EXON,INTRON,CLIN_SIG" \
--check_existing \
--offline



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

module load perl/5.26.1
module load perl/modules.centos7.5.26.1
module load /home/lmnp/knut0297/software/modulesfiles/htslib/1.12
module load /home/lmnp/knut0297/software/modulesfiles/samtools/1.12
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/ensembl-vep"
prepend-path PERL5LIB "$PERL5LIB:$MODULES_DIR/$MODULE_NAME/$VERSION/cpanm/lib/perl5"
setenv VEP_CACHE "$MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache"



# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: VEP_CACHE, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/vep_cache\nVariant Effect Predictor should be run including this option: vep --dir \\\$VEP_CACHE"
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


