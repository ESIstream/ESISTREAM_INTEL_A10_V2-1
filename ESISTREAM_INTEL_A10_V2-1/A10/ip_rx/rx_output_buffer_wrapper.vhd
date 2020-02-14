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
-- Description :
--
--
----------------------------------------------------------------------------------------------------
-- Version      Date            Author      Description
-- 0.1          2019            REFLEXCES   Creation
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;


entity rx_output_buffer_wrapper is
  generic (
    DATA_LENGTH : integer := 14                                      -- useful data length in an ESIstream frame (16-bit) 
    );
  port (
    rst             : in  std_logic
; wr_clk            : in  std_logic
; rd_clk            : in  std_logic
; din               : in  slv_16_array_n(0 to (DESER_WIDTH/16)-1)
; wr_en             : in  std_logic
; rd_en             : in  std_logic
; empty             : out std_logic_vector((DESER_WIDTH/16)-1 downto 0)
; decoded_valid_out : out std_logic
; decoded_frame_out : out slv_16_array_n(DESER_WIDTH/16-1 downto 0)  -- decoded output frame: disparity bit (15) + clk bit (14) + data (13 downto 0) (descrambling and disparity processed)  
; decoded_data_out  : out slv_14_array_n(DESER_WIDTH/16-1 downto 0)  -- decoded output data: data (13 downto 0)(descrambling and disparity processed)                        
    );
end entity rx_output_buffer_wrapper;

architecture rtl of rx_output_buffer_wrapper is
  --============================================================================================================================
  -- Function and Procedure declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Constant and Type declarations
  --============================================================================================================================
  constant FIFO_READ_LATENCY : natural range 1 to 6 := 2;  -- READ LATENCY of the FIFO output decoded data valid 

  --============================================================================================================================
  -- Component declarations
  --============================================================================================================================
  component output_buffer is
    port (
      data    : in  std_logic_vector(15 downto 0) := (others => 'X');  -- datain
      wrreq   : in  std_logic                     := 'X';              -- wrreq
      rdreq   : in  std_logic                     := 'X';              -- rdreq
      wrclk   : in  std_logic                     := 'X';              -- wrclk
      rdclk   : in  std_logic                     := 'X';              -- rdclk
      aclr    : in  std_logic                     := 'X';              -- aclr
      q       : out std_logic_vector(15 downto 0);                     -- dataout
      rdempty : out std_logic                                          -- rdempty
      );
  end component output_buffer;

--============================================================================================================================
-- Signal declarations
--============================================================================================================================
begin

  --============================================================================================================================
  -- FIFO Read latency
  --============================================================================================================================
  delay_decoding_vld : entity work.delay
    generic map (
      LATENCY => FIFO_READ_LATENCY - 1
      ) port map (
        clk => rd_clk
, rst       => rst
, d         => rd_en
, q         => decoded_valid_out
        );

  gen_output_buffer : for idx in 0 to DESER_WIDTH/16 - 1 generate
    signal dout : slv_16_array_n(0 to (DESER_WIDTH/16)-1);
  begin
    i_output_buffer : component output_buffer
      port map(
        wrclk => wr_clk
, rdclk       => rd_clk
, data        => din(idx)
, wrreq       => wr_en
, rdreq       => rd_en
, aclr        => rst
, q           => dout(idx)
, rdempty     => empty(idx)
        );
    decoded_data_out (idx) <= dout(idx)(DATA_LENGTH-1 downto 0);
    decoded_frame_out(idx) <= dout(idx);
  end generate gen_output_buffer;


end architecture rtl;
