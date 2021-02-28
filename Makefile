###################################################################
#                  Makefile for OVI40-RF1                         #
#                  Andreas Richter, DF8OE                         #
###################################################################

###################################################################
# Main Targets                                                    #
#                                                                 #
# rfboardx: build everything                                      #
# clean: remove output files and database                         #
# program_rfboardx: program your device with the compiled design  #
###################################################################

rfboard0:
	# builds the project DDC2
	quartus_sh --flow compile boards/RFBoard0/RFBoard0

clean_rfboard0:
	# removes all files and folders which are produced by build process DDC2
	rm -rf boards/RFBoard0/simulation boards/RFBoard0/build boards/RFBoard0/db boards/RFBoard0/incremental_db boards/RFBoard0/greybox_tmp boards/RFBoard0/RFBoard0.qws

program_rfboard0:
	# programs bitfile with USB-Blaster to DDC2-board
	quartus_pgm --no_banner --mode=as -o "BVP;boards/RFBoard0/build/RFBoard0.pof"

rfboard1:
	# builds the project RF1
	quartus_sh --flow compile boards/RFBoard1/RFBoard1

clean_rfboard1:
	# removes all files and folders which are produced by build process RF1
	rm -rf boards/RFBoard1/simulation boards/RFBoard1/build boards/RFBoard1/db boards/RFBoard1/incremental_db boards/RFBoard1/greybox_tmp boards/RFBoard1/RFBoard1.qws

program_rfboard1:
	# programs bitfile with USB-Blaster to RF1-board
	quartus_pgm --no_banner --mode=as -o "BVP;boards/RFBoard1/build/RFBoard1.pof"

rfboard2:
	# builds the project RF2
	quartus_sh --flow compile boards/RFBoard2/RFBoard2

clean_rfboard2:
	# removes all files and folders which are produced by build process RF2
	rm -rf boards/RFBoard2/simulation boards/RFBoard2/build boards/RFBoard2/db boards/RFBoard2/incremental_db boards/RFBoard2/greybox_tmp boards/RFBoard2/RFBoard2.qws

program_rfboard2:
	# programs bitfile with USB-Blaster to RF2-board
	quartus_pgm --no_banner --mode=as -o "BVP;boards/RFBoard2/build/RFBoard2.pof"

help:
	# shows all possible actions
	@grep --after-context=1 --extended-regexp '^[[:alnum:]_-]+:' Makefile
