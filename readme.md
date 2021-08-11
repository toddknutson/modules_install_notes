
# Software Install Notes

Todd Knutson  
Last updated: 2021-08-11

## Introduction


This directory contains text files that can be helpful when trying to install various software modules in your home directory on MSI (i.e. without root access). Generally, these files are bash scripts, but they should definitely be run interactively, line-by-line, so any issues can be identified immediately.

>The exact code in these notes are specific to my software directory organization and may need to be edited if someone else tries to use them.


I have set up multiple personal software modules using the [Environment modules](http://modules.sourceforge.net) system. My software modules and associated files are organized into the following directories, within in my MSI home directory (`/home/lmnp/knut0297`) on MSI's tier1 (panasas, primary) storage:

| Directory path | Purpose |
|----------------|---------|
|`/home/lmnp/knut0297/software/modules/`| Location where all software files are downloaded and/or compiled (organized by a unique software name).|
|`/home/lmnp/knut0297/software/modulesfiles/`| Location of the "modulefile" for each software tool. Each modulefile contains the instructions for how your environment is modified when loading the module. |
|`/home/lmnp/knut0297/software/modules_install_notes/`| Location of the bash script that defines the software tool installation method (i.e. this git repo)|




Everything in the `/home/lmnp/knut0297/software` directory should be world `u+g+o` readable and executable (dirs and executable files). Thus, anyone on the MSI system can use these software installations.


## How to use these install notes?

1. Copy the note to your system.
2. Edit the note as necessary (change any paths, etc.).
3. Run the commands in the note to download and build the software tool.
4. Each note also includes creating an associated `modulefile` that describes how the environment needs to be changed for the software to work. You must load the module or manually update any PATH (or similar) variables on your system for the software to work. 


Consider forking this repo to track any updates.


## Can someone just load these software modules (without re-installing them)?

Yes, anyone on the system *should* be able to load these modules. 

> However, I do not test these modules as different users/groups, so there might be issues. Please let me know if you have any problems running one of my modules in your environment and I might be able to help (knut0297@umn.edu).


### There are three potential methods (just use method #1 for simplicity and transparency):

1. Explicitly use the full path to my modulefile when running the `module load` command.

	For example, to load my `samtools` ver 1.10 module, run:

		module load /home/lmnp/knut0297/software/modulesfiles/samtools/1.10

    If MSI also has a `samtools/1.10` version available, the above method will ensure that my module will be loaded and not the MSI version.
    
    


2. Specify my `/home/lmnp/knut0297/software/modulesfiles` directory as the search path only one time.

	For example, if we wanted to load my `samtools` software, but we were unsure which version to use, we could specify the `MODULEPATH` variable directly on the command line for only "one execution of the `module load` command". This is nice, because it does not alter your original `MODULEPATH` variable in any way and allows you to load any of my modules without specifying a version number. [How does this work? It's a simple feature of bash](https://unix.stackexchange.com/a/126942/146742).
	
	```
	MODULEPATH=/home/lmnp/knut0297/software/modulesfiles module load samtools
	which samtools
	# /home/lmnp/knut0297/software/modules/samtools/1.10/bin/samtools
	```



3. Prepend (or append) my `/home/lmnp/knut0297/software/modulesfiles` directory to your `MODULEPATH ` environment variable. This will make all of my modules available to you.


	If you "prepend" your `MODULEPATH` variable, all of my modules will be available __before__ the MSI system wide ones. Thus, if a tool is available in my collection and MSI's, this will load my tool.

		# Prepend path to MODULEPATH var
		module use /home/lmnp/knut0297/software/modulesfiles
		
		module load samtools
		
		which samtools
		# /home/lmnp/knut0297/software/modules/samtools/1.10/bin/samtools
	
	If you "append" your `MODULEPATH` variable, all of my modules will be available __after__ the MSI system wide ones. Thus, if a tool is available in my collection and MSI's, you will load MSI's tool first. 
	
		# Append path to MODULEPATH var
		module use -a /home/lmnp/knut0297/software/modulesfiles
		
		module purge # might be needed to clear out previously loaded modules
		module load samtools
		
		which samtools
		# /panfs/roc/msisoft/samtools/1.10_gcc-7.2.0_haswell/bin/samtools

	Regardless, you can always remove a search path from your `MODULEPATH` variable:
	
		module unuse /home/lmnp/knut0297/software/modulesfiles






## What modules are available?
	

To view all available modules in my personal collection, run:

	MODULEPATH=/home/lmnp/knut0297/software/modulesfiles module avail
	

## How is my `env` changed by loading modules?

To see how your environment will be changed after loading the modulefile, you can run the `module display` command. For example:


	module display /home/lmnp/knut0297/software/modulesfiles/samtools/1.10
	
	# Or, if you've added my path to your MODULEPATH var, simply run:
	module display samtools/1.10












## Version control
Only the install notes source code is being tracked using git (not any input/output files, etc.). The code is synced with GitHub at the following location: 
[https://github.umn.edu/knut0297org/modules_install_notes](https://github.umn.edu/knut0297org/modules_install_notes)



