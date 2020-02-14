set_location_assignment PIN_AE29 -to aq600_sso
set_location_assignment PIN_AE28 -to aq600_sso(n)
set_instance_assignment -name IO_STANDARD LVDS -to aq600_sso
set_instance_assignment -name INPUT_TERMINATION "Differential" -to aq600_sso

set_location_assignment PIN_AF31 -to ASLp[0]
set_location_assignment PIN_AF30 -to ASLp[0](n)
set_location_assignment PIN_AF35 -to ASLp[1]
set_location_assignment PIN_AF34 -to ASLp[1](n)

# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to ASLp[0]
# #set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_3 -to ASLp[1]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to ASLp[1]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to BSLp[0]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to BSLp[1]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to CSLp[0]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to CSLp[1]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to DSLp[0]
# set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to DSLp[1]

set_location_assignment PIN_AH35 -to BSLp[0]
set_location_assignment PIN_AH34 -to BSLp[0](n)
set_location_assignment PIN_AG33 -to BSLp[1]
set_location_assignment PIN_AG32 -to BSLp[1](n)

set_location_assignment PIN_AD35 -to CSLp[0]
set_location_assignment PIN_AD34 -to CSLp[0](n)
set_location_assignment PIN_AD31 -to CSLp[1]
set_location_assignment PIN_AD30 -to CSLp[1](n)

set_location_assignment PIN_AE33 -to DSLp[0]
set_location_assignment PIN_AE32 -to DSLp[0](n)
set_location_assignment PIN_AC33 -to DSLp[1]
set_location_assignment PIN_AC32 -to DSLp[1](n)

set_location_assignment PIN_AL13 -to aq600_rstn
set_location_assignment PIN_AL14 -to aq600_spi_sclk
set_location_assignment PIN_AN12 -to aq600_spi_csn
set_location_assignment PIN_AW8 -to CSN_PLL
set_location_assignment PIN_AN13 -to aq600_spi_mosi
set_location_assignment PIN_AJ10 -to aq600_spi_miso
set_location_assignment PIN_AW9 -to PLL_LOCK
set_location_assignment PIN_AP26 -to aq600_synco
set_location_assignment PIN_AN26 -to aq600_synco(n)
set_location_assignment PIN_AG25 -to aq600_synctrig
set_location_assignment PIN_AF25 -to aq600_synctrig(n)

set_instance_assignment -name IO_STANDARD LVDS -to aq600_synco
set_instance_assignment -name IO_STANDARD LVDS -to aq600_synctrig

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
