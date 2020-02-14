# ############################################################################################################################################
# ############################################################################################################################################
post_message -type info "############################################################################################################################################"
post_message -type info "# Setting SDC constraints of RxC modules..."
# ############################################################################################################################################
# ############################################################################################################################################

# ############################################################################################################################
# ############################################################################################################################
# Base clocks
# ############################################################################################################################
# ############################################################################################################################
set_time_format -unit ns -decimal_places 3

create_clock -name {clk_100mhz_1}       -period 100.000MHz    [get_ports {clk_100mhz_1}]
create_clock -name {aq600_sso}    -period 156.250MHz    [get_ports {aq600_sso}]
create_clock -period "30.303 ns" -name {altera_reserved_tck} {altera_reserved_tck}


# ############################################################################################################################
# ############################################################################################################################
# Generated clocks
# ############################################################################################################################
# ############################################################################################################################
derive_pll_clocks

derive_clock_uncertainty

# ############################################################################################################################
# ############################################################################################################################
# Asynchronous groups & False paths
# ############################################################################################################################
# ############################################################################################################################
set_clock_groups \
            -group {altera_reserved_tck} \
            -group clk_100mhz_1 \
			-group *clk_wiz_0_inst|iopll_0|outclk0 \
            -group aq600_sso \
            -group {*|xcvr_native_a10_0*|tx_pma_clk *|xcvr_native_a10_0*|tx_coreclkin}\
            -group {*|xcvr_native_a10_0*|rx_pma_clk *|xcvr_native_a10_0*|rx_coreclkin}\
            -asynchronous
			
set_false_path -to   [ get_ports led_fav_blue       ]
set_false_path -to   [ get_ports led_fav_green      ]
set_false_path -to   [ get_ports led_fav_red        ]
set_false_path -to   [ get_ports led_usr_green1_n   ]
set_false_path -to   [ get_ports led_usr_green2_n   ]
set_false_path -to   [ get_ports led_usr_orange1_n  ]
set_false_path -to   [ get_ports led_usr_red1_n     ]               

     
# ############################################################################################################################################
# ############################################################################################################################################
post_message -type info "# Finished SDC constraints of RxC modules."
post_message -type info "############################################################################################################################################"
# ############################################################################################################################################
# ############################################################################################################################################
