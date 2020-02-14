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
-- Version      Date            Author      Description
-- 0.1          2019/07/03      YLA         Creation
-- 0.2          2019/07/10      YLA         corr: tx_coreclkin 
----------------------------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;

entity tx_xcvr_wrapper is
    generic (
          NB_LANES   : natural                       := 4           -- number of lanes
       );
    port (
          rst               : in    std_logic                                                 -- Active high (A)synchronous reset
        ; rst_xcvr          : in    std_logic_vector(NB_LANES-1 downto 0)                     -- Active high (A)synchronous reset
        ; tx_rstdone        : out   std_logic_vector(NB_LANES-1 downto 0) := (others => '0')
        ; tx_usrclk         : out   std_logic                             :=  '0'             -- user clock
        ; sysclk            : in    std_logic                                                 -- transceiver ip system clock
        ; refclk_n          : in    std_logic                                                 -- transceiver ip reference clock
        ; refclk_p          : in    std_logic                                                 -- transceiver ip reference clock
        ; txp               : out   std_logic_vector(NB_LANES-1 downto 0)                     -- lane serial input p
        ; txn               : out   std_logic_vector(NB_LANES-1 downto 0)                     -- lane Serial input n
        ; xcvr_pll_lock     : out   std_logic_vector(NB_LANES-1 downto 0) := (others => '0')  
        ; tx_usrrdy         : in    std_logic_vector(NB_LANES-1 downto 0) := (others => '0')  
        ; data_in           : in    std_logic_vector(SER_WIDTH*NB_LANES-1 downto 0) := (others => '0')
    );
end entity tx_xcvr_wrapper;

architecture rtl of tx_xcvr_wrapper is
    --============================================================================================================================
    -- Function and Procedure declarations
    --============================================================================================================================
    
    --============================================================================================================================
    -- Constant and Type declarations
    --============================================================================================================================

    --============================================================================================================================
    -- Component declarations
    --============================================================================================================================
    component tx_ip_rst is
        port (
            clock           : in  std_logic                    := 'X';             -- clk
            pll_locked      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_locked
            pll_powerdown   : out std_logic_vector(0 downto 0);                    -- pll_powerdown
            pll_select      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_select
            reset           : in  std_logic                    := 'X';             -- reset
            tx_analogreset  : out std_logic_vector(NB_LANES-1 downto 0);                    -- tx_analogreset
            tx_cal_busy     : in  std_logic_vector(NB_LANES-1 downto 0) := (others => 'X'); -- tx_cal_busy
            tx_digitalreset : out std_logic_vector(NB_LANES-1 downto 0);                    -- tx_digitalreset
            tx_ready        : out std_logic_vector(NB_LANES-1 downto 0);                     -- tx_ready
            pll_cal_busy    : in  std_logic_vector(0 downto 0) := (others => 'X')  -- pll_cal_busy
       );
    end component tx_ip_rst;
    
    component tx_ip_pll is
        port (
            mcgb_rst        : in  std_logic := 'X'; -- mcgb_rst
            mcgb_serial_clk : out std_logic;        -- clk
            pll_cal_busy    : out std_logic;        -- pll_cal_busy
            pll_locked      : out std_logic;        -- pll_locked
            pll_powerdown   : in  std_logic := 'X'; -- pll_powerdown
            pll_refclk0     : in  std_logic := 'X'; -- clk
            tx_serial_clk   : out std_logic         -- clk
        );
    end component tx_ip_pll;
    
    component tx_ip_xcvr is
        port (
            tx_analogreset          : in  std_logic_vector(NB_LANES-1 downto 0)   := (others => 'X')                ; -- tx_analogreset
            tx_cal_busy             : out std_logic_vector(NB_LANES-1 downto 0)                                     ; -- tx_cal_busy
            tx_clkout               : out std_logic_vector(NB_LANES-1 downto 0)                                     ; -- clk
            tx_coreclkin            : in  std_logic_vector(NB_LANES-1 downto 0)   := (others => 'X')                ; -- clk
            tx_digitalreset         : in  std_logic_vector(NB_LANES-1 downto 0)   := (others => 'X')                ; -- tx_digitalreset
            tx_enh_data_valid       : in  std_logic_vector(NB_LANES-1 downto 0)   := (others => 'X')                ; -- tx_enh_data_valid
            tx_parallel_data        : in  std_logic_vector(data_in'range) := (others => 'X')                        ; -- tx_parallel_data
            tx_serial_clk0          : in  std_logic_vector(NB_LANES-1 downto 0)   := (others => 'X')                ; -- clk
            tx_serial_data          : out std_logic_vector(NB_LANES-1 downto 0)                                     ; -- tx_serial_data
            unused_tx_parallel_data : in  std_logic_vector(511-(SER_WIDTH*NB_LANES) downto 0) := (others => 'X')      -- unused_tx_parallel_data
        );
    end component tx_ip_xcvr;
    
    --============================================================================================================================
    -- Signal declarations
    --============================================================================================================================
    -- Reset controller ip
    signal tx_analogreset         : std_logic_vector(txp'range)                     ; 
    signal tx_cal_busy            : std_logic_vector(txp'range)                     ; 
    signal tx_digitalreset        : std_logic_vector(txp'range)                     ; 
    signal tx_is_lockedtodata     : std_logic_vector(txp'range)                     ; 
    signal tx_ready               : std_logic_vector(txp'range)                     ; 
    
    -- XCVR ip 
    signal tx_is_lockedtoref      : std_logic_vector(txp'range)                     ;
    signal tx_parallel_data       : std_logic_vector(data_in'range)                 ;
    signal tx_serial_data         : std_logic_vector(txp'range)                     ;
    signal tx_clkout              : std_logic_vector(txp'range)                     ;
    signal tx_cdr_refclk0         : std_logic                                       ;
    signal tx_serial_clk0         : std_logic_vector(NB_LANES-1 downto 0)           ;
    signal tx_coreclkin           : std_logic_vector(NB_LANES-1 downto 0)           ;
    
    -- PLL IP
    signal pll_cal_busy           : std_logic                                       ;
    signal pll_locked             : std_logic                                       ;
    signal pll_powerdown          : std_logic                                       ;
    signal mcgb_serial_clk        : std_logic                                       ;

begin
    --============================================================================================================================
    -- Assignments
    --============================================================================================================================
    tx_usrclk      <= tx_clkout(0);
    xcvr_pll_lock  <= (others => pll_locked);
    tx_serial_clk0 <= (others => mcgb_serial_clk);
    tx_coreclkin   <= (others => tx_clkout(0));
    
    --============================================================================================================================
    -- XCVR reset controller
    --============================================================================================================================
    i_xcvr_rst_ip : component tx_ip_rst
        port map (
            clock              => sysclk
        ,   pll_locked    (0)  => pll_locked
        ,   pll_powerdown (0)  => pll_powerdown
        ,   pll_select    (0)  => '1'
        ,   reset              => rst 
        ,   tx_analogreset     => tx_analogreset
        ,   tx_cal_busy        => tx_cal_busy
        ,   tx_digitalreset    => tx_digitalreset
        ,   tx_ready           => tx_rstdone
        ,   pll_cal_busy  (0)  => pll_cal_busy
       );

    i_tx_ip_pll : component tx_ip_pll
        port map (
           mcgb_rst            => pll_powerdown
         , mcgb_serial_clk     => mcgb_serial_clk 
         , pll_cal_busy        => pll_cal_busy
         , pll_locked          => pll_locked
         , pll_powerdown       => pll_powerdown 
         , pll_refclk0         => refclk_p
         , tx_serial_clk       => open 
        );
    --============================================================================================================================
    -- XCVR instance (ADME enabled)
    --============================================================================================================================     
     i_xcvr : component tx_ip_xcvr
        port map (
           tx_analogreset          => tx_analogreset
         , tx_cal_busy             => tx_cal_busy            
         , tx_clkout               => tx_clkout              
         , tx_coreclkin            => tx_coreclkin           
         , tx_digitalreset         => tx_digitalreset        
         , tx_enh_data_valid       => tx_usrrdy      
         , tx_parallel_data        => data_in       
         , tx_serial_clk0          => tx_serial_clk0        
         , tx_serial_data          => txp         
         , unused_tx_parallel_data => open
        );
        
end architecture rtl;
