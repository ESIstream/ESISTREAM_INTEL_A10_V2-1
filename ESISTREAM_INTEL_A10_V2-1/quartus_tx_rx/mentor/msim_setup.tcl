
# (C) 2001-2019 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ----------------------------------------
# Auto-generated simulation script msim_setup.tcl
# ----------------------------------------
# This script provides commands to simulate the following IP detected in
# your Quartus project:
#     output_buffer
#     rx_ip_rst
#     rx_ip_xcvr
#     tx_ip_pll
#     tx_ip_rst
#     tx_ip_xcvr
# 
# Altera recommends that you source this Quartus-generated IP simulation
# script from your own customized top-level script, and avoid editing this
# generated script.
# 
# To write a top-level script that compiles Altera simulation libraries and
# the Quartus-generated IP in your project, along with your design and
# testbench files, copy the text from the TOP-LEVEL TEMPLATE section below
# into a new file, e.g. named "mentor.do", and modify the text as directed.
# 
# ----------------------------------------
# # TOP-LEVEL TEMPLATE - BEGIN
# #
# # QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# # construct paths to the files required to simulate the IP in your Quartus
# # project. By default, the IP script assumes that you are launching the
# # simulator from the IP script location. If launching from another
# # location, set QSYS_SIMDIR to the output directory you specified when you
# # generated the IP script, relative to the directory from which you launch
# # the simulator.
# #
# set QSYS_SIMDIR <script generation output directory>
# #
# # Source the generated IP simulation script.
# source $QSYS_SIMDIR/mentor/msim_setup.tcl
# #
# # Set any compilation options you require (this is unusual).
# set USER_DEFINED_COMPILE_OPTIONS <compilation options>
# set USER_DEFINED_VHDL_COMPILE_OPTIONS <compilation options for VHDL>
# set USER_DEFINED_VERILOG_COMPILE_OPTIONS <compilation options for Verilog>
# #
# # Call command to compile the Quartus EDA simulation library.
# dev_com
# #
# # Call command to compile the Quartus-generated IP simulation files.
# com
# #
# # Add commands to compile all design files and testbench files, including
# # the top level. (These are all the files required for simulation other
# # than the files compiled by the Quartus-generated IP simulation script)
# #
# vlog <compilation options> <design and testbench files>
# #
# # Set the top-level simulation or testbench module/entity name, which is
# # used by the elab command to elaborate the top level.
# #
# set TOP_LEVEL_NAME <simulation top>
# #
# # Set any elaboration options you require.
# set USER_DEFINED_ELAB_OPTIONS <elaboration options>
# #
# # Call command to elaborate your design and testbench.
# elab
# #
# # Run the simulation.
# run -a
# #
# # Report success to the shell.
# exit -code 0
# #
# # TOP-LEVEL TEMPLATE - END
# ----------------------------------------
# 
# IP SIMULATION SCRIPT
# ----------------------------------------
# ACDS 18.1 625 win32 2019.08.07.16:21:33

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "tx_ip_xcvr"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "D:/intelfpga/18.1/quartus/"
}

if ![info exists USER_DEFINED_COMPILE_OPTIONS] { 
  set USER_DEFINED_COMPILE_OPTIONS ""
}
if ![info exists USER_DEFINED_VHDL_COMPILE_OPTIONS] { 
  set USER_DEFINED_VHDL_COMPILE_OPTIONS ""
}
if ![info exists USER_DEFINED_VERILOG_COMPILE_OPTIONS] { 
  set USER_DEFINED_VERILOG_COMPILE_OPTIONS ""
}
if ![info exists USER_DEFINED_ELAB_OPTIONS] { 
  set USER_DEFINED_ELAB_OPTIONS ""
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                   ./libraries/altera_ver/       
  vmap       altera_ver        ./libraries/altera_ver/       
  ensure_lib                   ./libraries/lpm_ver/          
  vmap       lpm_ver           ./libraries/lpm_ver/          
  ensure_lib                   ./libraries/sgate_ver/        
  vmap       sgate_ver         ./libraries/sgate_ver/        
  ensure_lib                   ./libraries/altera_mf_ver/    
  vmap       altera_mf_ver     ./libraries/altera_mf_ver/    
  ensure_lib                   ./libraries/altera_lnsim_ver/ 
  vmap       altera_lnsim_ver  ./libraries/altera_lnsim_ver/ 
  ensure_lib                   ./libraries/twentynm_ver/     
  vmap       twentynm_ver      ./libraries/twentynm_ver/     
  ensure_lib                   ./libraries/twentynm_hssi_ver/
  vmap       twentynm_hssi_ver ./libraries/twentynm_hssi_ver/
  ensure_lib                   ./libraries/twentynm_hip_ver/ 
  vmap       twentynm_hip_ver  ./libraries/twentynm_hip_ver/ 
}
ensure_lib                                         ./libraries/output_buffer_fifo_181/                 
vmap       output_buffer_fifo_181                  ./libraries/output_buffer_fifo_181/                 
ensure_lib                                         ./libraries/rx_ip_rst_altera_xcvr_reset_control_181/
vmap       rx_ip_rst_altera_xcvr_reset_control_181 ./libraries/rx_ip_rst_altera_xcvr_reset_control_181/
ensure_lib                                         ./libraries/altera_common_sv_packages/              
vmap       altera_common_sv_packages               ./libraries/altera_common_sv_packages/              
ensure_lib                                         ./libraries/rx_ip_xcvr_altera_xcvr_native_a10_181/  
vmap       rx_ip_xcvr_altera_xcvr_native_a10_181   ./libraries/rx_ip_xcvr_altera_xcvr_native_a10_181/  
ensure_lib                                         ./libraries/tx_ip_pll_altera_xcvr_atx_pll_a10_181/  
vmap       tx_ip_pll_altera_xcvr_atx_pll_a10_181   ./libraries/tx_ip_pll_altera_xcvr_atx_pll_a10_181/  
ensure_lib                                         ./libraries/tx_ip_rst_altera_xcvr_reset_control_181/
vmap       tx_ip_rst_altera_xcvr_reset_control_181 ./libraries/tx_ip_rst_altera_xcvr_reset_control_181/
ensure_lib                                         ./libraries/tx_ip_xcvr_altera_xcvr_native_a10_181/  
vmap       tx_ip_xcvr_altera_xcvr_native_a10_181   ./libraries/tx_ip_xcvr_altera_xcvr_native_a10_181/  

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                 -work altera_ver       
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                          -work lpm_ver          
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                             -work sgate_ver        
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                         -work altera_mf_ver    
    eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                     -work altera_lnsim_ver 
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_atoms.v"                    -work twentynm_ver     
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_atoms_ncrypt.v"      -work twentynm_ver     
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hssi_atoms_ncrypt.v" -work twentynm_hssi_ver
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hssi_atoms.v"               -work twentynm_hssi_ver
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.v"  -work twentynm_hip_ver 
    eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hip_atoms.v"                -work twentynm_hip_ver 
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_rx/output_buffer/fifo_181/sim/output_buffer_fifo_181_3ah473i.v"                                                             -work output_buffer_fifo_181                 
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_rx/output_buffer/sim/output_buffer.v"                                                                                                                                    
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/altera_xcvr_functions.sv"                                                    -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/altera_xcvr_functions.sv"                                             -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/alt_xcvr_resync.sv"                                                          -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/alt_xcvr_resync.sv"                                                   -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/altera_xcvr_reset_control.sv"                                                -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/alt_xcvr_reset_counter.sv"                                                   -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/altera_xcvr_reset_control.sv"                                         -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/alt_xcvr_reset_counter.sv"                                            -work rx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_rst/sim/rx_ip_rst.v"                                                                                                                                            
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/altera_xcvr_native_a10_functions_h.sv"                                         -work altera_common_sv_packages              
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_resync.sv"                               -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_arbiter.sv"                              -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/alt_xcvr_resync.sv"                        -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/alt_xcvr_arbiter.sv"                       -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_pcs.sv"                                  -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_pma.sv"                                  -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_xcvr_avmm.sv"                            -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_xcvr_native.sv"                          -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_pcs.sv"                           -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_pma.sv"                           -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_xcvr_avmm.sv"                     -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_xcvr_native.sv"                   -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/a10_avmm_h.sv"                                    -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_pipe_retry.sv"                    -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_avmm_csr.sv"                      -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_prbs_accum.sv"                    -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_odi_accel.sv"                     -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_rcfg_arb.sv"                      -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/altera_xcvr_native_pcie_dfe_params_h.sv"          -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_commands_h.sv"                          -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_functions_h.sv"                         -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_program.sv"                             -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_cpu.sv"                                 -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_master.sv"                              -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/altera_xcvr_native_pcie_dfe_ip.sv"                -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/rx_ip_xcvr_altera_xcvr_native_a10_181_zu6mori.sv" -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_rcfg_opt_logic_zu6mori.sv"        -L altera_common_sv_packages -work rx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_rx/rx_ip_xcvr/sim/rx_ip_xcvr.v"                                                                                                                                          
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/twentynm_xcvr_avmm.sv"                            -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/twentynm_xcvr_avmm.sv"                     -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/alt_xcvr_resync.sv"                               -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/alt_xcvr_arbiter.sv"                              -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/alt_xcvr_resync.sv"                        -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/alt_xcvr_arbiter.sv"                       -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/a10_avmm_h.sv"                                    -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/alt_xcvr_atx_pll_rcfg_arb.sv"                     -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/a10_xcvr_atx_pll.sv"                              -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/alt_xcvr_pll_embedded_debug.sv"                   -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/alt_xcvr_pll_avmm_csr.sv"                         -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/alt_xcvr_atx_pll_rcfg_arb.sv"              -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/a10_xcvr_atx_pll.sv"                       -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/alt_xcvr_pll_embedded_debug.sv"            -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/mentor/alt_xcvr_pll_avmm_csr.sv"                  -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/tx_ip_pll_altera_xcvr_atx_pll_a10_181_l5dl3na.sv" -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/altera_xcvr_atx_pll_a10_181/sim/alt_xcvr_atx_pll_rcfg_opt_logic_l5dl3na.sv"       -L altera_common_sv_packages -work tx_ip_pll_altera_xcvr_atx_pll_a10_181  
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_pll/sim/tx_ip_pll.v"                                                                                                                                            
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/altera_xcvr_functions.sv"                                                    -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/altera_xcvr_functions.sv"                                             -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/alt_xcvr_resync.sv"                                                          -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/alt_xcvr_resync.sv"                                                   -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/altera_xcvr_reset_control.sv"                                                -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/alt_xcvr_reset_counter.sv"                                                   -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/altera_xcvr_reset_control.sv"                                         -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/altera_xcvr_reset_control_181/sim/mentor/alt_xcvr_reset_counter.sv"                                            -work tx_ip_rst_altera_xcvr_reset_control_181
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_rst/sim/tx_ip_rst.v"                                                                                                                                            
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_resync.sv"                               -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_arbiter.sv"                              -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/alt_xcvr_resync.sv"                        -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/alt_xcvr_arbiter.sv"                       -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_pcs.sv"                                  -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_pma.sv"                                  -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_xcvr_avmm.sv"                            -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/twentynm_xcvr_native.sv"                          -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_pcs.sv"                           -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_pma.sv"                           -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_xcvr_avmm.sv"                     -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/mentor/twentynm_xcvr_native.sv"                   -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/a10_avmm_h.sv"                                    -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_pipe_retry.sv"                    -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_avmm_csr.sv"                      -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_prbs_accum.sv"                    -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_odi_accel.sv"                     -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_rcfg_arb.sv"                      -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/altera_xcvr_native_pcie_dfe_params_h.sv"          -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_commands_h.sv"                          -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_functions_h.sv"                         -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_program.sv"                             -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_cpu.sv"                                 -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/pcie_mgmt_master.sv"                              -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/altera_xcvr_native_pcie_dfe_ip.sv"                -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/tx_ip_xcvr_altera_xcvr_native_a10_181_ktcmi5a.sv" -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/altera_xcvr_native_a10_181/sim/alt_xcvr_native_rcfg_opt_logic_ktcmi5a.sv"        -L altera_common_sv_packages -work tx_ip_xcvr_altera_xcvr_native_a10_181  
  eval  vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../A10/ip_tx/tx_ip_xcvr/sim/tx_ip_xcvr.v"                                                                                                                                          
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS -L work -L work_lib -L output_buffer_fifo_181 -L rx_ip_rst_altera_xcvr_reset_control_181 -L altera_common_sv_packages -L rx_ip_xcvr_altera_xcvr_native_a10_181 -L tx_ip_pll_altera_xcvr_atx_pll_a10_181 -L tx_ip_rst_altera_xcvr_reset_control_181 -L tx_ip_xcvr_altera_xcvr_native_a10_181 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L twentynm_ver -L twentynm_hssi_ver -L twentynm_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS -L work -L work_lib -L output_buffer_fifo_181 -L rx_ip_rst_altera_xcvr_reset_control_181 -L altera_common_sv_packages -L rx_ip_xcvr_altera_xcvr_native_a10_181 -L tx_ip_pll_altera_xcvr_atx_pll_a10_181 -L tx_ip_rst_altera_xcvr_reset_control_181 -L tx_ip_xcvr_altera_xcvr_native_a10_181 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L twentynm_ver -L twentynm_hssi_ver -L twentynm_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                                         -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                                           -- Compile device library files"
  echo
  echo "com                                               -- Compile the design files in correct order"
  echo
  echo "elab                                              -- Elaborate top level design"
  echo
  echo "elab_debug                                        -- Elaborate the top level design with novopt option"
  echo
  echo "ld                                                -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                                          -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                                    -- Top level module name."
  echo "                                                     For most designs, this should be overridden"
  echo "                                                     to enable the elab/elab_debug aliases."
  echo
  echo "SYSTEM_INSTANCE_NAME                              -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                                       -- Platform Designer base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR                               -- Quartus installation directory."
  echo
  echo "USER_DEFINED_COMPILE_OPTIONS                      -- User-defined compile options, added to com/dev_com aliases."
  echo
  echo "USER_DEFINED_ELAB_OPTIONS                         -- User-defined elaboration options, added to elab/elab_debug aliases."
  echo
  echo "USER_DEFINED_VHDL_COMPILE_OPTIONS                 -- User-defined vhdl compile options, added to com/dev_com aliases."
  echo
  echo "USER_DEFINED_VERILOG_COMPILE_OPTIONS              -- User-defined verilog compile options, added to com/dev_com aliases."
}
file_copy
h
