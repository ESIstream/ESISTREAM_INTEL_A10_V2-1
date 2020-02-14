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

library STD;
use STD.textio.all;


entity tb_tx_rx_esistream is
end entity tb_tx_rx_esistream;

architecture behavioral of tb_tx_rx_esistream is

---------------- Constants ----------------
  constant NB_LANES           : natural                               := 4;
  constant Tdelayclk          : time                                  := 100 ps;
  constant Trefclk            : time                                  := 6400 ps;  -- mgtrefclk period - 156.25MHz
  constant tx_lfsr_init       : slv_17_array_n(NB_LANES-1 downto 0)   := (others => (others => '1'));
---------------- Signals ----------------
  signal rst_tx               : std_logic                             := '0';
  signal rst_rx               : std_logic                             := '0';
  signal rst_tx_pulse         : std_logic                             := '0';
  signal rst_rx_pulse         : std_logic                             := '0';
  --
  signal mgtrefclk_n_t        : std_logic                             := '0';
  signal mgtrefclk_p_t        : std_logic                             := '1';
  signal sysclk               : std_logic                             := '0';
  signal sync_in_rx           : std_logic                             := '0';
  signal sync_in_tx           : std_logic                             := '0';
  signal sync_in_rx_pulse     : std_logic                             := '0';
  signal sync_in_tx_pulse     : std_logic                             := '0';
  signal sync_out_rx          : std_logic                             := '0';
  --
  signal txn                  : std_logic_vector(NB_LANES-1 downto 0) := X"F";
  signal txp                  : std_logic_vector(NB_LANES-1 downto 0) := X"0";
  signal rxn                  : std_logic_vector(NB_LANES-1 downto 0) := X"F";
  signal rxp                  : std_logic_vector(NB_LANES-1 downto 0) := X"0";
  --
  signal tx_clk               : std_logic                             := '0';
  signal tx_d_ctrl            : std_logic_vector(1 downto 0)          := (others => '0');
  signal tx_d_ctrl_1          : std_logic_vector(1 downto 0)          := (others => '0');
  signal tx_d_ctrl_2          : std_logic_vector(1 downto 0)          := (others => '0');
  signal tx_prbs_en           : std_logic                             := '0';
  signal tx_disp_en           : std_logic                             := '0';
  signal tx_ip_ready          : std_logic                             := '0';
  --
  signal rx_clk               : std_logic                             := '0';
  signal rx_ip_ready          : std_logic                             := '0';
  signal rx_lanes_on          : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  signal rx_prbs_en           : std_logic                             := '0';
  --
  signal data_to_encode_1     : std_logic_vector(13 downto 0)         := (others => '0');
  signal data_to_encode_2     : std_logic_vector(13 downto 0)         := (others => '0');
  signal data_to_encode_1_64b : std_logic_vector(13 downto 0)         := (others => '0');
  signal data_to_encode_2_64b : std_logic_vector(13 downto 0)         := (others => '0');
  signal rx_data              : std_logic_vector(16*4-1 downto 0)     := (others => '0');
  signal rx_data_valid        : std_logic                             := '0';
  signal rx_lanes_ready       : std_logic                             := '0';
  signal esistream_com_ready  : std_logic                             := '0';
  --
  signal tx_data              : tx_data_array(NB_LANES-1 downto 0);
  --
  signal rst_check            : std_logic                             := '1';
  signal clk                  : std_logic;
  signal data_ctrl            : std_logic_vector(1 downto 0);
  signal frame_out            : rx_frame_array(NB_LANES-1 downto 0);
  signal data_out             : rx_data_array(NB_LANES-1 downto 0);
  signal valid_out            : std_logic_vector(NB_LANES-1 downto 0);
  signal ber_status           : std_logic;
  signal cb_status            : std_logic;

--
begin

--############################################################################################################################
--############################################################################################################################
-- Clock Generation
--############################################################################################################################
--############################################################################################################################
  mgtrefclk_p_t <= not mgtrefclk_p_t after Trefclk/2;  -- 312.5 MHz
  mgtrefclk_n_t <= not mgtrefclk_n_t after Trefclk/2;  -- 312.5 MHz
  --
  sysclk        <= not (sysclk)      after 10 ns;      --100MHz

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
      nrst     => tx_ip_ready
, clk          => tx_clk
, d_ctrl       => tx_d_ctrl_1
, data_out     => data_to_encode_1
, data_out_64b => data_to_encode_1_64b
      );
  tx_d_ctrl_1 <= tx_d_ctrl;

  data_gen_inst_2 : entity work.data_gen
    port map (
      nrst     => tx_ip_ready
, clk          => tx_clk
, d_ctrl       => tx_d_ctrl_2
, data_out     => data_to_encode_2
, data_out_64b => data_to_encode_2_64b
      );
  tx_d_ctrl_2 <= not tx_d_ctrl;

  gen_data_32b : if SER_WIDTH = 32 generate
  begin
    process(data_to_encode_1, data_to_encode_2)
    begin
      for idx_lane in 0 to NB_LANES-1 loop
        for idx in 0 to SER_WIDTH/16-1 loop
          case (idx mod 2) is
            when 0      => tx_data(idx_lane)(idx) <= data_to_encode_1;
            when others => tx_data(idx_lane)(idx) <= data_to_encode_2;
          end case;
        end loop;
      end loop;
    end process;
  end generate gen_data_32b;

  gen_data_64b : if SER_WIDTH = 64 generate
  begin
    process(data_to_encode_1, data_to_encode_2, data_to_encode_1_64b, data_to_encode_2_64b)
    begin
      for idx_lane in 0 to NB_LANES-1 loop
        for idx in 0 to SER_WIDTH/16-1 loop
          case idx is
            when 0      => tx_data(idx_lane)(idx) <= data_to_encode_1;
            when 1      => tx_data(idx_lane)(idx) <= data_to_encode_2;
            when 2      => tx_data(idx_lane)(idx) <= data_to_encode_1_64b;
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
        clk     => sysclk
, din           => rst_tx
, edge_detected => rst_tx_pulse
        );
  --============================================================================================================================
  -- sync_in_tx EDGE DETECT
  --============================================================================================================================
  sync_in_tx <= sync_out_rx;
  edge_detect_2 : entity work.edge_detect
    generic map (
      EDGE_TYPE => "RISING"
      ) port map (
        clk     => tx_clk
, din           => sync_in_tx
, edge_detected => sync_in_tx_pulse
        );

  --============================================================================================================================
  -- TX ESIstream IP
  --============================================================================================================================
  tx_esistream_inst : entity work.tx_esistream_with_xcvr
    generic map(
      NB_LANES => 4
, COMMA        => X"FF0000FF"
      ) port map (
        rst => rst_tx_pulse
, refclk_n  => mgtrefclk_n_t
, refclk_p  => mgtrefclk_p_t
, sysclk    => sysclk
, sync_in   => sync_in_tx_pulse
, prbs_en   => tx_prbs_en
, disp_en   => tx_disp_en
, lfsr_init => tx_lfsr_init
, data_in   => tx_data
, txn       => txn
, txp       => txp
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
        clk     => sysclk
, din           => rst_rx
, edge_detected => rst_rx_pulse
        );
  --============================================================================================================================
  -- sync_in_rx_pulse
  --============================================================================================================================
  edge_detect_4 : entity work.edge_detect
    generic map (
      EDGE_TYPE => "RISING")
    port map (
      clk       => sysclk
, din           => sync_in_rx
, edge_detected => sync_in_rx_pulse
      );

  --============================================================================================================================
  -- RX lane delay line
  --============================================================================================================================
  gen_dly : for i in 0 to NB_LANES-1 generate
    rxp(i) <= transport txp(i) after i*(500 ps);
  end generate gen_dly;

  --============================================================================================================================
  -- ESIstream RX IP
  --============================================================================================================================
  rx_esistream_inst : entity work.rx_esistream_with_xcvr
    generic map(
      NB_LANES => 4
, SYNC_DELAY   => 2
, COMMA        => x"FF0000FF"
      ) port map(
        rst    => rst_rx_pulse
, sysclk       => sysclk
, refclk_n     => mgtrefclk_n_t
, refclk_p     => mgtrefclk_p_t
, rxn          => rxn
, rxp          => rxp
, sync_in      => sync_in_rx_pulse
, prbs_en      => rx_prbs_en
, lanes_on     => rx_lanes_on
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
-- Stimulus
--============================================================================================================================
  my_tb : process
  begin
    -------------------------------- 
    -- tb init
    -------------------------------- 
    tx_d_ctrl   <= "01";    -- data encoded is 14bits positive ramp
    tx_prbs_en  <= '1';     -- Scrambling enabled
    tx_disp_en  <= '1';     -- Disparity enabled
    rst_tx      <= '0';
    sync_in_rx  <= '0';
    rx_lanes_on <= "1111";  -- All lanes on
    rx_prbs_en  <= '1';     -- Descrambling enabled
    rst_rx      <= '0';
    -- The TX should be reset first.
    -- Then the RX should be reset.
    -- And then the RX SYNC_IN should be pressed.
    -- The configuration can be changed before or after reset and sync
    -- at the exception of the lanes standby on the RX after which the SYNC_IN should be pressed again.
    report "wait all TX cpll locked";
    wait until rising_edge(tx_ip_ready);
    report "generate TX rst pulse";
    wait for 100 ns;
    rst_tx     <= '1';
    wait for 100 ns;
    rst_tx     <= '0';
    report "Wait for TX reset to complete";
    wait until rising_edge(tx_ip_ready);
    report "generate TX rst pulse";
    rst_rx     <= '1';
    wait for 100 ns;
    rst_rx     <= '0';
    report "Wait for RX reset to complete";
    wait until rising_edge(rx_ip_ready);
    wait for 100 ns;
    report "RX synchronization";
    sync_in_rx <= '1';
    wait for 100 ns;
    sync_in_rx <= '0';
    wait until rst_check = '0';
    report "Check Begin";
    wait for 200 ns;
    assert ber_status = '1' report "BER OK step 1 ";
    assert cb_status = '1' report "CB  OK step 1 ";

    report "RX synchronization";
    sync_in_rx <= '1';
    wait for 100 ns;
    sync_in_rx <= '0';
    wait for 200 ns;
    wait until rst_check = '0';
    report "Check Begin";
    wait for 200 ns;
    assert ber_status = '1' report "BER OK step 2 ";
    assert cb_status = '1' report "CB  OK step 2 ";

    wait for 1000 ns;
    report "RX synchronization";
    sync_in_rx <= '1';
    wait for 100 ns;
    sync_in_rx <= '0';
    wait for 200 ns;

    if rst_check /= '0' then
      wait until rst_check = '0';
    end if;

    report "Check Begin";
    wait for 200 ns;
    assert ber_status = '1' report "BER OK step 3 ";
    assert cb_status = '1' report "CB  OK step 3 ";

    assert false report "Test finish" severity failure;
  end process;

--============================================================================================================================
-- my tb results
--============================================================================================================================
  process(rx_clk)
  begin
    if rising_edge(rx_clk) then
      if valid_out = "1111" then
        rst_check <= '0';
      else
        rst_check <= '1';
      end if;
    end if;
  end process;

  i_rx_check : entity work.rx_check
    generic map (
      NB_LANES => 4
      ) port map (
        rst  => rst_check
, clk        => rx_clk
, data_ctrl  => tx_d_ctrl
, frame_out  => frame_out
, data_out   => data_out
, valid_out  => valid_out
, ber_status => ber_status
, cb_status  => cb_status
        );

end behavioral;
