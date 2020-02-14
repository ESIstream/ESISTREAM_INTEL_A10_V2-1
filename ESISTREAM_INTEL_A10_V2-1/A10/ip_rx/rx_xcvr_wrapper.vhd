----------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Description :
-- 
--
----------------------------------------------------------------------------------------------------
-- Version      Date            Author               Description
-- 0.1          2019            REFLEXCES            Creation
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;

entity rx_xcvr_wrapper is
  generic (
    NB_LANES : natural := 4                                                     -- number of lanes
    );
  port (
    rst         : in  std_logic                                                 -- Active high (A)synchronous reset
; rst_xcvr      : in  std_logic                                                 -- Active high (A)synchronous reset
; rx_rstdone    : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0')
; rx_usrclk     : out std_logic                                         := '0'  -- user clock
; sysclk        : in  std_logic                                                 -- transceiver ip system clock
; refclk_n      : in  std_logic                                                 -- transceiver ip reference clock
; refclk_p      : in  std_logic                                                 -- transceiver ip reference clock
; rxp           : in  std_logic_vector(NB_LANES-1 downto 0)                     -- lane serial input p
; rxn           : in  std_logic_vector(NB_LANES-1 downto 0)                     -- lane Serial input n
; xcvr_pll_lock : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0')
; data_out      : out std_logic_vector(DESER_WIDTH*NB_LANES-1 downto 0) := (others => '0')
    );
end entity rx_xcvr_wrapper;

architecture rtl of rx_xcvr_wrapper is
  --============================================================================================================================
  -- Function and Procedure declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Constant and Type declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Component declarations
  --============================================================================================================================
  component rx_ip_xcvr is
    port (
      rx_analogreset          : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X');  -- rx_analogreset
      rx_cal_busy             : out std_logic_vector(NB_LANES-1 downto 0);                     -- rx_cal_busy
      rx_cdr_refclk0          : in  std_logic                             := 'X';              -- clk
      rx_clkout               : out std_logic_vector(NB_LANES-1 downto 0);                     -- clk
      rx_coreclkin            : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X');  -- clk
      rx_digitalreset         : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X');  -- rx_digitalreset
      rx_is_lockedtodata      : out std_logic_vector(NB_LANES-1 downto 0);                     -- rx_is_lockedtodata
      rx_is_lockedtoref       : out std_logic_vector(NB_LANES-1 downto 0);                     -- rx_is_lockedtoref
      rx_parallel_data        : out std_logic_vector(data_out 'range);                         -- rx_parallel_data
      rx_serial_data          : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X');  -- rx_serial_data
      unused_rx_parallel_data : out std_logic_vector(511-(DESER_WIDTH*NB_LANES) downto 0)      -- unused_rx_parallel_data
      );
  end component rx_ip_xcvr;


  component rx_ip_rst is
    port (
      clock              : in  std_logic                             := 'X';              -- clk
      reset              : in  std_logic                             := 'X';              -- reset
      rx_analogreset     : out std_logic_vector(NB_LANES-1 downto 0);                     -- rx_analogreset
      rx_cal_busy        : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X');  -- rx_cal_busy
      rx_digitalreset    : out std_logic_vector(NB_LANES-1 downto 0);                     -- rx_digitalreset
      rx_is_lockedtodata : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X');  -- rx_is_lockedtodata
      rx_ready           : out std_logic_vector(NB_LANES-1 downto 0)                      -- rx_ready
      );
  end component rx_ip_rst;

  --============================================================================================================================
  -- Signal declarations
  --============================================================================================================================       
  -- Reset controller ip
  signal rx_analogreset     : std_logic_vector(rxp'range);
  signal rx_cal_busy        : std_logic_vector(rxp'range);
  signal rx_digitalreset    : std_logic_vector(rxp'range);
  signal rx_is_lockedtodata : std_logic_vector(rxp'range);
  signal rx_ready           : std_logic_vector(rxp'range);

  -- XCVR ip 
  signal rx_is_lockedtoref : std_logic_vector(rxp'range);
  signal rx_parallel_data  : std_logic_vector(data_out'range);
  signal rx_serial_data    : std_logic_vector(rxp'range);
  signal rx_clkout         : std_logic_vector(rxp'range);
  signal rx_coreclkin      : std_logic_vector(rxp'range);
  signal rx_cdr_refclk0    : std_logic;

begin
  --============================================================================================================================
  -- Assignments
  --============================================================================================================================
  rx_usrclk     <= rx_clkout(0);
  xcvr_pll_lock <= (others => '1');
  rx_coreclkin  <= (others => rx_clkout(0));

  --============================================================================================================================
  -- XCVR reset controller
  --============================================================================================================================
  i_xcvr_rst_ip : component rx_ip_rst
    port map (
      clock          => sysclk
, reset              => rst_xcvr
, rx_analogreset     => rx_analogreset
, rx_cal_busy        => rx_cal_busy
, rx_digitalreset    => rx_digitalreset
, rx_is_lockedtodata => rx_is_lockedtodata
, rx_ready           => rx_rstdone
      );

  --============================================================================================================================
  -- XCVR instance (ADME enabled)
  --============================================================================================================================
  i_xcvr : component rx_ip_xcvr
    port map (
      rx_analogreset      => rx_analogreset
, rx_cal_busy             => rx_cal_busy
, rx_cdr_refclk0          => refclk_p
, rx_clkout               => rx_clkout
, rx_coreclkin            => rx_coreclkin
, rx_digitalreset         => rx_digitalreset
, rx_is_lockedtodata      => rx_is_lockedtodata
, rx_is_lockedtoref       => rx_is_lockedtoref
, rx_parallel_data        => data_out
, rx_serial_data          => rxp
, unused_rx_parallel_data => open
      );
end architecture rtl;
