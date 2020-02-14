-------------------------------------------------------------------------------
-- This is free and unencumbered software released into the public domain.
--
-- Anyone is free to copy, modify, publish, use, compile, sell, or distribute
-- this software, either in source code form or as a compiled bitstream, for 
-- any purpose, commercial or non-commercial, and by any means.
--
-- In jurisdictions that recognize copyright laws, the author or authors of 
-- this software dedicate any and all copyright interest in the software to 
-- the public domain. We make this dedication for the benefit of the public at
-- large and to the detriment of our heirs and successors. We intend this 
-- dedication to be an overt act of relinquishment in perpetuity of all present
-- and future rights to this software under copyright law.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
-- ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------

library work;
use work.esistream_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_esistream is
  generic(
     NB_LANES   : natural                       := 4        
   ; COMMA      : std_logic_vector(31 downto 0) := x"FF0000FF"  -- comma for frame alignemnent (0x00FFFF00 or 0xFF0000FF).
  );
  port (
    clk_xcvr_fcm1_a          : in    std_logic                                -- refclk from transceiver clock input
  ; clk_100mhz_1             : in    std_logic                                -- sysclk
  ; fmc_dp_c2m               : out   std_logic_vector(NB_LANES-1 downto 0)    -- Serial output connected to FMC
  ; fmc_dp_m2c               : in    std_logic_vector(NB_LANES-1 downto 0)    -- Serial output connected to FMC
  ; bp_n                     : in    std_logic_vector(4 downto 1)             --
  ; dipswitch_a              : in    std_logic_vector(4 downto 1)             --
  ; dipswitch_b              : in    std_logic_vector(4 downto 1)             --
  ; led_fav_blue             : out   std_logic                                --
  ; led_fav_green            : out   std_logic                                --
  ; led_fav_red              : out   std_logic                                --
  ; led_usr_green1_n         : out   std_logic                                --
  ; led_usr_green2_n         : out   std_logic                                --
  ; led_usr_orange1_n        : out   std_logic                                --
  ; led_usr_red1_n           : out   std_logic                                --
 );
end entity top_esistream;

architecture behavioral of top_esistream is

  --============================================================================================================================
  -- Function and Procedure declarations
  --============================================================================================================================
  
  --============================================================================================================================
  -- Constant and Type declarations
  --============================================================================================================================
  constant tx_lfsr_init             : slv_17_array_n(NB_LANES-1 downto 0) := (others => (others => '1'));
  constant ALL_LANES_ON             : std_logic_vector(NB_LANES-1 downto 0) := x"F";
  constant ALL_LANES_OFF            : std_logic_vector(NB_LANES-1 downto 0) := x"0";
  --============================================================================================================================
  -- Component declarations
  --============================================================================================================================
 
  --============================================================================================================================
  -- Signal declarations
  --============================================================================================================================
  signal rst_tx                     : std_logic                           := '0';
  signal rst_rx                     : std_logic                           := '0';
  signal rst_tx_pulse               : std_logic                           := '0';
  signal rst_rx_pulse               : std_logic                           := '0';
  --
  signal sysclk                     : std_logic                           := '0';
  signal sync_in_rx                 : std_logic                           := '0';
  signal sync_in_tx                 : std_logic                           := '0';
  signal sync_in_rx_pulse           : std_logic                           := '0';
  signal sync_in_tx_pulse           : std_logic                           := '0';
  signal sync_out_rx                : std_logic                           := '0';
  --
  signal tx_clk                     : std_logic                           := '0';
  signal tx_d_ctrl                  : std_logic_vector(1 downto 0)        := (others => '0');
  signal tx_d_ctrl_1                : std_logic_vector(1 downto 0)        := (others => '0');
  signal tx_d_ctrl_2                : std_logic_vector(1 downto 0)        := (others => '0');
  signal prbs_en                    : std_logic                           := '0';
  signal tx_disp_en                 : std_logic                           := '0';
  signal tx_ip_ready                : std_logic                           := '0';
  --
  signal rx_clk                     : std_logic                           := '0';
  signal rx_ip_ready                : std_logic                           := '0';
  --
  signal data_to_encode_1           : std_logic_vector(13 downto 0)       := (others => '0');
  signal data_to_encode_2           : std_logic_vector(13 downto 0)       := (others => '0');
  signal data_to_encode_1_64b       : std_logic_vector(13 downto 0)       := (others => '0');
  signal data_to_encode_2_64b       : std_logic_vector(13 downto 0)       := (others => '0');
  signal rx_data                    : std_logic_vector(16*4-1 downto 0)   := (others => '0');
  signal rx_data_valid              : std_logic                           := '0';
  signal rx_lanes_ready             : std_logic                           := '0';
  signal esistream_com_ready        : std_logic                           := '0';
  --
  signal tx_data                    : tx_data_array(NB_LANES-1 downto 0);
  --
  signal rst_check                  : std_logic := '0';
  signal data_ctrl                  : std_logic_vector(1 downto 0);
  signal frame_out                  : rx_frame_array(NB_LANES-1 downto 0);
  signal data_out                   : rx_data_array(NB_LANES-1 downto 0);
  signal valid_out                  : std_logic_vector(NB_LANES-1 downto 0);
  signal ber_status                 : std_logic;
  signal cb_status                  : std_logic;
  --signal pll_rst                    : std_logic;
  --signal pll_rst_rq                 : std_logic;
  
  signal s_rst_cntr       			: std_logic_vector(11 downto 0) := (others => '1');
  signal s_reset_i					: std_logic:='0';
  signal rst_tx_mux, rst_rx_mux		: std_logic:='0';

--
begin

    --############################################################################################################################
    --############################################################################################################################
    -- System PLL / Reset
    --############################################################################################################################
    --############################################################################################################################        
	
	sysclk	<= clk_100mhz_1;
	
	process(sysclk)
    begin
        if rising_edge(sysclk) then
			if s_rst_cntr /= "000000000000" then 
				s_rst_cntr <= std_logic_vector(unsigned(s_rst_cntr) - 1);
            end if;
            
            -- Global POR reset.
            if s_rst_cntr /= "000000000000" then 
				s_reset_i <= '1';
            else                                 
				s_reset_i <= '0';
            end if;
		end if;
	end process;

  --############################################################################################################################
  --############################################################################################################################
  -- User interface
  --############################################################################################################################
  --############################################################################################################################
  -- dipswitch_a : SW4 
  prbs_en         <= dipswitch_a(4)             ;
  tx_disp_en      <= dipswitch_a(3)             ;
  tx_d_ctrl       <= dipswitch_a(2 downto 1)    ;
  -- dipswitch_b : SW5 
  rst_rx          <= dipswitch_b(3)             ;
  rst_tx          <= dipswitch_b(2)             ;
  --pll_rst_rq      <= dipswitch_b(1)             ;
  
  
  -- BP :Each push-button switch provides a high logic level when it is not pressed, and provides a low logic level when pressed.
  process (rx_clk)
  begin
       if bp_n(2)='0'         then rst_check <= '1'; 
    elsif rising_edge(rx_clk) then rst_check <= '0';  end if; 
  end process;
  sync_in_rx       <= not(bp_n(1));             

  -- GPIO LEDS
  led_usr_green1_n      <= not tx_ip_ready   ;      
  led_usr_green2_n      <= not rx_ip_ready   ;      
  led_usr_orange1_n     <= cb_status         ;             
  led_usr_red1_n        <= ber_status        ;
  led_fav_blue          <= '0'               ;
  led_fav_green         <= rx_lanes_ready    ;
  led_fav_red           <= '0'               ;
  
--############################################################################################################################
--############################################################################################################################
-- TX side
--############################################################################################################################
--############################################################################################################################   
  --============================================================================================================================
  -- Generation data
  --============================================================================================================================  
  data_gen_inst_1 : entity work.data_gen
    port map (
      nrst         => tx_ip_ready
    , clk          => tx_clk
    , d_ctrl       => tx_d_ctrl_1
    , data_out     => data_to_encode_1
    , data_out_64b => data_to_encode_1_64b
   );
  tx_d_ctrl_1   <= tx_d_ctrl;

  data_gen_inst_2 : entity work.data_gen
    port map (
      nrst         => tx_ip_ready
    , clk          => tx_clk
    , d_ctrl       => tx_d_ctrl_2
    , data_out     => data_to_encode_2
    , data_out_64b => data_to_encode_2_64b
   );
  tx_d_ctrl_2   <= not tx_d_ctrl;
  
  gen_data_32b : if SER_WIDTH = 32 generate
  begin
    process(data_to_encode_1,data_to_encode_2)
    begin
     for idx_lane in 0 to NB_LANES-1 loop
           for idx in 0 to SER_WIDTH/16-1 loop
                case ( idx mod 2) is
                    when      0 => tx_data(idx_lane)(idx) <= data_to_encode_1;
                    when others => tx_data(idx_lane)(idx) <= data_to_encode_2;
                end case;
           end loop;
      end loop;
    end process;
  end generate gen_data_32b;
  
  gen_data_64b : if SER_WIDTH = 64 generate
  begin
      process(data_to_encode_1,data_to_encode_2,data_to_encode_1_64b,data_to_encode_2_64b)
      begin
         for idx_lane in 0 to NB_LANES-1 loop
               for idx in 0 to SER_WIDTH/16-1 loop
                    case idx is
                        when      0 => tx_data(idx_lane)(idx) <= data_to_encode_1;
                        when      1 => tx_data(idx_lane)(idx) <= data_to_encode_2;
                        when      2 => tx_data(idx_lane)(idx) <= data_to_encode_1_64b;
                        when others => tx_data(idx_lane)(idx) <= data_to_encode_2_64b;
                    end case;
               end loop;
          end loop;
      end process;
  end generate gen_data_64b;
  
  
  --============================================================================================================================
  -- rst_tx EDGE DETECT
  --============================================================================================================================
  edge_detect_1 : entity work.edge_detect
    generic map (
      EDGE_TYPE => "RISING"
    ) port map (
      clk           => sysclk
    , din           => rst_tx
    , edge_detected => rst_tx_pulse
   );
   
   rst_tx_mux	<= rst_tx_pulse or s_reset_i;
   
  --============================================================================================================================
  -- sync_in_tx EDGE DETECT
  --============================================================================================================================
  sync_in_tx <= sync_out_rx;
  edge_detect_2 : entity work.edge_detect
    generic map (
      EDGE_TYPE => "RISING"
    ) port map (
      clk           => tx_clk
    , din           => sync_in_tx
    , edge_detected => sync_in_tx_pulse
   );
      
  --============================================================================================================================
  -- TX ESIstream IP
  --============================================================================================================================
  tx_esistream_inst : entity work.tx_esistream_with_xcvr
    generic map(
      NB_LANES       => 4
    , COMMA          => X"FF0000FF"
    ) port map (
      rst       => rst_tx_mux 	--rst_tx_pulse
    , refclk_n  => '0'
    , refclk_p  => clk_xcvr_fcm1_a
    , sysclk    => sysclk
    , sync_in   => sync_in_tx_pulse
    , prbs_en   => prbs_en
    , disp_en   => tx_disp_en
    , lfsr_init => tx_lfsr_init
    , data_in   => tx_data
    , txn       => open
    , txp       => fmc_dp_c2m
    , tx_clk    => tx_clk
    , ip_ready  => tx_ip_ready
   );

--############################################################################################################################
--############################################################################################################################
-- RX side
--############################################################################################################################
--############################################################################################################################
  --============================================================================================================================
  -- rst_rx_pulse
  --============================================================================================================================
  edge_detect_3 : entity work.edge_detect
    generic map (
      EDGE_TYPE => "RISING"
    ) port map (
      clk           => sysclk
    , din           => rst_rx
    , edge_detected => rst_rx_pulse
   );
   
   rst_rx_mux	<= rst_rx_pulse or s_reset_i;
   
  --============================================================================================================================
  -- sync_in_rx_pulse
  --============================================================================================================================
  edge_detect_4 : entity work.edge_detect
    generic map (
      EDGE_TYPE => "RISING")
    port map (
      clk           => sysclk
    , din           => sync_in_rx
    , edge_detected => sync_in_rx_pulse
   );

  --============================================================================================================================
  -- ESIstream RX IP
  --============================================================================================================================
  rx_esistream_inst : entity work.rx_esistream_with_xcvr
    generic map(
      NB_LANES   => 4
    , SYNC_DELAY => 2
    , COMMA      => x"FF0000FF"
    ) port map(
      rst          => rst_rx_mux 	--rst_rx_pulse
    , sysclk       => sysclk
    , refclk_n     => '0'
    , refclk_p     => clk_xcvr_fcm1_a
    , rxn          => (others => '0')
    , rxp          => fmc_dp_m2c
    , sync_in      => sync_in_rx_pulse
    , prbs_en      => prbs_en
    , lanes_on     => ALL_LANES_ON
    , read_data_en => rx_lanes_ready
    , clk_acq      => rx_clk
    , rx_clk       => rx_clk
    , sync_out     => sync_out_rx
    , frame_out    => frame_out
    , data_out     => data_out
    , valid_out    => valid_out
    , ip_ready     => rx_ip_ready
    , lanes_ready  => rx_lanes_ready
   );
  
  --============================================================================================================================
  -- my tb results
  --============================================================================================================================ 
  i_rx_check : entity work.rx_check
    generic map (
      NB_LANES => 4
    ) port map (
      rst        => rst_check
    , clk        => rx_clk
    , data_ctrl  => tx_d_ctrl
    , frame_out  => frame_out
    , data_out   => data_out 
    , valid_out  => valid_out
    , ber_status => ber_status
    , cb_status  => cb_status
   );

end behavioral;
