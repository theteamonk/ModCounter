# Makefile for Memory - Regression Testing - Lab10

# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = VCS
FSDB_PATH=/home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64
RTL= ../rtl/*.v
work= work #library name
SVTB1= ../tb/CounterInterface.sv
INC = +incdir+../tb +incdir+../test
SVTB2 = ../test/CounterPackage.sv  ../test/CounterTop.sv
COVOP = -coveropt 3 +cover=bcft
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"

help:
	@echo ===========================================================================================================
	@echo " USAGE   	--  make target                      								"
	@echo " clean   	=>  clean the earlier log and intermediate files.      						"
	@echo " sv_cmp    	=>  Create library and compile the code.              						"									   
	@echo " TestCase       	=>  To compile and run the testcase in batch mode.						" 
	@echo " covhtml		=>  To view the coverage report in firefox.									"
	@echo " covtxt	     => To view the coverage report in text editor [only for VCS]					"
	@echo "cov_verdi 	=> To view the coverage report in verdi [only for VCS]		"
	@echo ===========================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
TestCase : TestCase_$(SIMULATOR)
view_wave : view_wave_$(SIMULATOR)
covhtml : covhtml_$(SIMULATOR)
covtxt: covtxt_$(SIMULATOR)
cov_verdi: cov_verdi_$(SIMULATOR)
	
# ---- Start of Definitions for Synopsys VCS Specific Targets -----#

sv_cmp_VCS:
	vcs -full64 -l comp.log -sverilog -debug_access+all -kdb -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(INC) $(SVTB1) $(SVTB2)

TestCase_VCS:clean_VCS  sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave_file1.fsdb -cm_dir ./cov1 +ntb_random_seed +TestCase 
	urg -dir cov1.vdb -format both -report urgReport
	
clean_VCS:
	rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h urgReport* *.fsdb verdi*
	clear  

covhtml_VCS:
	firefox urgReport/grp*.html &
	
covtxt_VCS:
	vi urgReport/grp*.txt
cov_verdi_VCS:
	verdi -cov -covdir merged_dir.vdb

# ---- End of Definitions for Synopsys VCS Specific Targets -----#