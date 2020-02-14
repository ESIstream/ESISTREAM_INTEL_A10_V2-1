# TOP-LEVEL TEMPLATE - BEGIN
#
# QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# construct paths to the files required to simulate the IP in your Quartus
# project. By default, the IP script assumes that you are launching the
# simulator from the IP script location. If launching from another
# location, set QSYS_SIMDIR to the output directory you specified when you
# generated the IP script, relative to the directory from which you launch
# the simulator.
#
set QUARTUS_INSTALL_DIR "D:/intelfpga/18.1/quartus/"
set path_src_rx ../../src_rx
set path_src_tx ../../src_tx
set path_src_co ../../src_common
set path_tb     ../../testbench
set path_ip_wra ../../A10
set QSYS_SIMDIR ../

#
# Source the generated IP simulation script.
source ../../quartus_tx_rx/mentor/msim_setup.tcl

# Add commands to compile all design files and testbench files, including
# the top level. (These are all the files required for simulation other
# than the files compiled by the Quartus-generated IP simulation script)
#
source ./scripts/compile_src_com.tcl	 
source ./scripts/compile_src_rx.tcl	 
source ./scripts/compile_src_tx.tcl	 
	 
 
vcom "$path_tb/tb_tx_rx_esistream.vhd"
#
# Set the top-level simulation or testbench module/entity name, which is
# used by the elab command to elaborate the top level.
#
set TOP_LEVEL_NAME work.tb_tx_rx_esistream

#
# Set any elaboration options you require.
# set USER_DEFINED_ELAB_OPTIONS <elaboration options>
#
# Call command to elaborate your design and testbench.
elab_debug
 
#
# Show signals
log -r /*

source wave.do
#
# Run the simulation.
run 1 ms