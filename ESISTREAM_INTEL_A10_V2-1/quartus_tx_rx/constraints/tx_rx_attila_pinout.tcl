set_location_assignment PIN_AG28 -to clk_xcvr_fcm1_a(n)                        
set_location_assignment PIN_AG29 -to clk_xcvr_fcm1_a                                                    
set_location_assignment PIN_AL36 -to fmc_dp_c2m[0](n)                          
set_location_assignment PIN_AL37 -to fmc_dp_c2m[0]                             
set_location_assignment PIN_AK38 -to fmc_dp_c2m[1](n)                          
set_location_assignment PIN_AK39 -to fmc_dp_c2m[1]                             
set_location_assignment PIN_AJ36 -to fmc_dp_c2m[2](n)                          
set_location_assignment PIN_AJ37 -to fmc_dp_c2m[2]                             
set_location_assignment PIN_AH38 -to fmc_dp_c2m[3](n)                          
set_location_assignment PIN_AH39 -to fmc_dp_c2m[3]   

set_location_assignment PIN_AH34 -to fmc_dp_m2c[0](n)                           
set_location_assignment PIN_AH35 -to fmc_dp_m2c[0]                              
set_location_assignment PIN_AG32 -to fmc_dp_m2c[1](n)                           
set_location_assignment PIN_AG33 -to fmc_dp_m2c[1]                              
set_location_assignment PIN_AF30 -to fmc_dp_m2c[2](n)                           
set_location_assignment PIN_AF31 -to fmc_dp_m2c[2]                              
set_location_assignment PIN_AF34 -to fmc_dp_m2c[3](n)                           
set_location_assignment PIN_AF35 -to fmc_dp_m2c[3] 
         
set_instance_assignment -name IO_STANDARD LVDS -to clk_xcvr_fcm1_a
set_instance_assignment -name INPUT_TERMINATION "Differential" -to clk_xcvr_fcm1_a

set_location_assignment PIN_AJ5 -to clk_100mhz_1
set_location_assignment PIN_L20 -to rstn       
set_location_assignment PIN_L23 -to dipswitch_a[1]   
set_location_assignment PIN_M22 -to dipswitch_a[2]   
set_location_assignment PIN_L22 -to dipswitch_a[3]   
set_location_assignment PIN_M21 -to dipswitch_a[4]   
set_location_assignment PIN_N20 -to dipswitch_b[1]   
set_location_assignment PIN_K22 -to dipswitch_b[2]   
set_location_assignment PIN_K21 -to dipswitch_b[3]   
set_location_assignment PIN_K20 -to dipswitch_b[4]   
set_location_assignment PIN_L20 -to bp_n[1]           
set_location_assignment PIN_K23 -to bp_n[2]           
set_location_assignment PIN_H21 -to bp_n[3]           
set_location_assignment PIN_J19 -to bp_n[4]           
set_location_assignment PIN_P20 -to led_fav_blue      
set_location_assignment PIN_N22 -to led_fav_green      
set_location_assignment PIN_N23 -to led_fav_red        
set_location_assignment PIN_J18 -to led_usr_green1_n   
set_location_assignment PIN_H18 -to led_usr_green2_n   
set_location_assignment PIN_G17 -to led_usr_orange1_n  
set_location_assignment PIN_H19 -to led_usr_red1_n     

set_location_assignment PIN_AK3 -to sync_out                      
set_location_assignment PIN_AF8 -to sync_in_from_tx                      

proc xcvr_set_tx {pin} {
    set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to $pin

    set_instance_assignment -name XCVR_A10_TX_VOD_OUTPUT_SWING_CTRL 29 -to $pin 
    set_instance_assignment -name XCVR_A10_TX_COMPENSATION_EN ENABLE -to $pin 
    set_instance_assignment -name XCVR_A10_TX_PRE_EMP_SWITCHING_CTRL_1ST_POST_TAP 0 -to $pin 
    set_instance_assignment -name XCVR_A10_TX_PRE_EMP_SIGN_1ST_POST_TAP FIR_POST_1T_POS -to $pin 
    
    post_message -type info "# XCVR TX settings applied to pin=$pin."
}

proc xcvr_set_rx {pin } {
    set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to $pin 

    set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP5 RADP_DFE_FXTAP5_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP4 RADP_DFE_FXTAP4_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP1 RADP_DFE_FXTAP1_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP7 RADP_DFE_FXTAP7_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP6 RADP_DFE_FXTAP6_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP3 RADP_DFE_FXTAP3_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_DFE_FXTAP2 RADP_DFE_FXTAP2_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_0 -to $pin 
    set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM NO_DC_GAIN -to $pin 
    set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to $pin 

    post_message -type info "# XCVR RX settings applied to pin=$pin."
}
xcvr_set_tx fmc_dp_c2m[0] 
xcvr_set_tx fmc_dp_c2m[1] 
xcvr_set_tx fmc_dp_c2m[2] 
xcvr_set_tx fmc_dp_c2m[3] 

xcvr_set_rx fmc_dp_m2c[0] 
xcvr_set_rx fmc_dp_m2c[1] 
xcvr_set_rx fmc_dp_m2c[2] 
xcvr_set_rx fmc_dp_m2c[3] 

