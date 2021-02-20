###################################################################
#                  Makefile for OVI40-RF1                         #
#                  Andreas Richter, DF8OE                         #
###################################################################

PROJECT = Transceiver

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################

all:
	# builds the complete project
	quartus_sh --flow compile $(PROJECT)

clean:
	# removes all files and folders which are produced by build process
	rm -rf build db incremental_db greybox_tmp $(PROJECT).qws

program:
	# programs bitfile with USB-Blaster to RF1-board
	quartus_pgm --no_banner --mode=as -o "BVP;build/$(PROJECT).pof"

help:
	# shows all possible actions
	@grep --after-context=1 --extended-regexp '^[[:alnum:]_-]+:' Makefile
