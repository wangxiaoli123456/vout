all:find clean compile simulate coverage

all_sim:clean compile simulate

all_cov:clean compile_cov simulate_cov coverage

all_cov_random:clean compile_cov simulate_cov_ran coverage

find:
	find . -name *.v > filelist

OUTPUT = result
SEED = $(shell date +s%)
CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name ${OUTPUT}
CM_DIR = -cm_dir ./${OUTPUT}.vdb

compile:
	vcs +v2k -debug_all -kdb -lca -f fileList -l compile.log

compile_cov:
	vcs ${CM} ${CM_NAME} ${CM_DIR} +v2k -debug_all -kdb -lca -f fileList -l compile.log

simulate:
	./simv -gui=verdi -l simulate.log

simulate_cov:
	./simv ${CM} ${CM_NAME} ${CM_DIR} -l simulate.log

coverage:
	dve -covdir *.vdb  & 

clean:
	rm -rf *.log *.vdb simv* cov csrc DVEfiles ucli.key *.vpd

simulate_cov_ran:
	./simv ${CM} ${CM_NAME} ${CM_DIR} +seed=${SEED} -l simulate.log

simulate_ran:
	./simv +seed=${SEED} -gui=verdi -l simulate.log
