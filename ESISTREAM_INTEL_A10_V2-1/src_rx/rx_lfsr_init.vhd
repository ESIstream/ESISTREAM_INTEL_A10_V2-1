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
-- Version      Date            Author       Description
-- 1.0          2019            Teledyne e2v Creation
-- 1.1          2019            REFLEXCES    FPGA target migration, 64-bit data path
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description :
-- After a sync event, waits frames aligned event to initialize and
-- synchronize the PRBS with scrambled data.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;

entity rx_lfsr_init is
  generic (
    COMMA       : std_logic_vector(31 downto 0)
  ; LFSR_LENGTH : natural := 17
  ; DATA_LENGTH : natural := 14
  );
  port (
    clk         : in  std_logic
  ; rst         : in  std_logic
  ; din_rdy     : in  std_logic
  ; din         : in  slv_16_array_n(0 to DESER_WIDTH/16 - 1)
  ; dout_rdy    : out std_logic
  ; prbs        : out slv_17_array_n(0 to DESER_WIDTH/16 - 1)
  ; dout        : out slv_16_array_n(0 to DESER_WIDTH/16 - 1)
 );
end rx_lfsr_init;

architecture rtl of rx_lfsr_init is

  --============================================================================================================================
  -- Function and Procedure declarations
  --============================================================================================================================ 
 
  --============================================================================================================================
  -- Constant and Type declarations
  --============================================================================================================================
  constant LFSR_DELAY : natural := 6*(DESER_WIDTH/32); -- if DESER_WIDTH = 64b then LFSR_DELAY = 12 else 6
  
  --============================================================================================================================
  -- Component declarations
  --============================================================================================================================
  
  --============================================================================================================================
  -- Signal declarations
  --============================================================================================================================
  signal prbs_frame_started   : std_logic                               := '0'                        ;
  signal din_no_prbs          : std_logic                               := '0'                        ;
  signal din_rdy_d            : std_logic                               := '0'                        ;
  signal prbs_frame_started_r : std_logic_vector(2 downto 0)            := (others => '0')            ;
  signal din_r                : slv_16_array_n(0 to DESER_WIDTH/16 - 2) := (others => (others => '0'));
  signal din_adj              : slv_16_array_n(0 to DESER_WIDTH/16 - 1) := (others => (others => '0'));
  signal din_adj_t            : slv_16_array_n(0 to DESER_WIDTH/16 - 1) := (others => (others => '0'));
  signal lfsr_temp            : std_logic_vector(16 downto 0)           := (others => '0')            ;
  signal lfsr_init_value      : slv_17_array_n(0 to DESER_WIDTH/16 - 1) := (others => (others => '0'));
  signal lfsr_value           : slv_17_array_n(0 to DESER_WIDTH/16 - 1) := (others => (others => '0'));

begin

  process (clk)
  begin
    if rising_edge (clk) then
      if rst = '1' then
        prbs_frame_started_r <= (others => '0');
        din_rdy_d            <= '0';
        din_r                <= (others => (others => '0'));
        din_adj              <= (others => (others => '0'));
      else
        prbs_frame_started_r <= prbs_frame_started_r(1 downto 0) & prbs_frame_started;
        din_adj              <= din_adj_t;
        for index in 0 to DESER_WIDTH/16-2 loop  
            din_r(index)         <= din(index + 1);
        end loop;
        din_rdy_d            <= din_rdy;
      end if;
    end if;
  end process;
  
 --============================================================================================================================
 -- FOR DESER_WIDTH = 32
 --============================================================================================================================
 gen_32b_datapath : if DESER_WIDTH = 32 generate
      signal bus_rearrng          : std_logic := '0';
 begin 
    prbs_start_proc : process (clk)
    begin
        if rising_edge (clk) then
          if rst = '1' then
            prbs_frame_started <= '0';
            bus_rearrng        <= '0';
            din_no_prbs        <= '0';
          elsif (din_rdy = '1' and din_rdy_d = '0') or din_no_prbs = '1' then
            if din(0) = COMMA (DESER_WIDTH/2- 1 downto 0) and din(1) = COMMA (DESER_WIDTH- 1 downto DESER_WIDTH/2) then
              prbs_frame_started <= '0';
              bus_rearrng        <= '0';
              din_no_prbs        <= '1';
            elsif din(0) = COMMA (DESER_WIDTH- 1 downto DESER_WIDTH/2) then
              prbs_frame_started <= '0';
              bus_rearrng        <= '1';
              din_no_prbs        <= '1';
            else
              prbs_frame_started <= '1';
              bus_rearrng        <= bus_rearrng;
              din_no_prbs        <= '0';
            end if;
          else
            prbs_frame_started <= '0';
            bus_rearrng        <= bus_rearrng;
            din_no_prbs        <= din_no_prbs;
          end if;
        end if;
      end process prbs_start_proc;
     --============================================================================================================================
     -- Arrange Din according to COMMA 
     --============================================================================================================================
      rearrange_din : process (clk)
      begin
        if rising_edge (clk) then
          if bus_rearrng = '0' then
            din_adj_t <= din;
          else
            din_adj_t(0) <= din_r(0);
            din_adj_t(1) <= din  (0);
          end if;
        end if;
      end process;
 end generate gen_32b_datapath;
 
 --============================================================================================================================
 -- FOR DESER_WIDTH = 64
 --============================================================================================================================
 gen_64b_datapath : if DESER_WIDTH = 64 generate 
    signal bus_rearrng          : std_logic_vector(1 downto 0):= (others => '0');
 begin 
     prbs_start_proc : process (clk)
     begin
       if rising_edge (clk) then
         if rst = '1' then
           prbs_frame_started <= '0';
           din_no_prbs        <= '0';
           bus_rearrng        <= (others => '0');
         elsif (din_rdy = '1' and din_rdy_d = '0') or din_no_prbs = '1' then   
            if     din(0) = COMMA(15 downto 00) and din(1) = COMMA(31 downto 16)  
               and din(2) = COMMA(15 downto 00) and din(3) = COMMA(31 downto 16) then  
                        prbs_frame_started     <= '0'   ;
                        din_no_prbs            <= '1'   ;
                        bus_rearrng            <= "00"  ;  
            elsif  din(2) = COMMA(31 downto 16) then
                        prbs_frame_started     <= '0'   ;
                        din_no_prbs            <= '1'   ;
                        bus_rearrng            <= "11"  ; 
            elsif  din(1) = COMMA(31 downto 16) then
                        prbs_frame_started     <= '0'   ;
                        din_no_prbs            <= '1'   ;
                        bus_rearrng            <= "10"  ; 
            elsif  din(0) = COMMA(31 downto 16) then
                        prbs_frame_started     <= '0'   ;
                        din_no_prbs            <= '1'   ;
                        bus_rearrng            <= "01"  ;                                
           else
                        prbs_frame_started <= '1';
                        din_no_prbs        <= '0';
                        bus_rearrng        <= bus_rearrng;
           end if;
         else
           prbs_frame_started <= '0';
           din_no_prbs        <= din_no_prbs;
           bus_rearrng        <= bus_rearrng;
         end if;
       end if;
     end process prbs_start_proc;
     
     --============================================================================================================================
     -- Arrange Din according to COMMA 
     --============================================================================================================================
     rearrange_din : process (clk)
      begin
        if rising_edge (clk) then
          case bus_rearrng is 
          when "00" => 
            -- clock        |  0       1      2 
            -- din(3)       | COMMA  PRBS3  PRBS7
            -- din(2)       | COMMA  PRBS2  PRBS6
            -- din(1)       | COMMA  PRBS1  PRBS5
            -- din(0)       | COMMA  PRBS0  PRBS4
            -- ------------ |---------------------
            -- clock        |   0      1      2
            -- din_r(2)     | COMMA  COMMA  PRBS3
            -- din_r(1)     | COMMA  COMMA  PRBS2
            -- din_r(0)     | COMMA  COMMA  PRBS1
            -- ------------ |---------------------
            -- clock        |    0     1      2  
            -- din_adj_t(3) | COMMA  PRBS3  PRBS7
            -- din_adj_t(2) | COMMA  PRBS2  PRBS6
            -- din_adj_t(1) | COMMA  PRBS1  PRBS5
            -- din_adj_t(0) | COMMA  PRBS0  PRBS4
            din_adj_t <= din;
          when "01" => 
            -- clock        |  0       1      2 
            -- din(3)       | PRBS2  PRBS6  PRBS10
            -- din(2)       | PRBS1  PRBS5  PRBS9
            -- din(1)       | PRBS0  PRBS4  PRBS8
            -- din(0)       | COMMA  PRBS3  PRBS7
            -- ------------ |---------------------
            -- clock        |   0      1      2
            -- din_r(2)     | COMMA  PRBS2  PRBS6
            -- din_r(1)     | COMMA  PRBS1  PRBS5
            -- din_r(0)     | COMMA  PRBS0  PRBS4
            -- ------------ |---------------------
            -- clock        |    0     1      2  
            -- din_adj_t(3) | COMMA  PRBS3  PRBS7
            -- din_adj_t(2) | COMMA  PRBS2  PRBS6
            -- din_adj_t(1) | COMMA  PRBS1  PRBS5
            -- din_adj_t(0) | COMMA  PRBS0  PRBS4   
            din_adj_t(3 to 3)  <= din   (0 to 0);
            din_adj_t(0 to 2)  <= din_r (0 to 2);
        when "10" => 
            -- clock        |  0       1      2 
            -- din(3)       | PRBS1  PRBS5  PRBS9
            -- din(2)       | PRBS0  PRBS4  PRBS8
            -- din(1)       | COMMA  PRBS3  PRBS7
            -- din(0)       | COMMA  PRBS2  PRBS6
            -- ------------ |---------------------
            -- clock        |   0      1      2
            -- din_r(2)     | COMMA  PRBS1  PRBS5
            -- din_r(1)     | COMMA  PRBS0  PRBS4
            -- din_r(0)     | COMMA  COMMA  PRBS3
            -- ------------ |---------------------
            -- clock        |    0     1      2  
            -- din_adj_t(3) | COMMA  PRBS3  PRBS7
            -- din_adj_t(2) | COMMA  PRBS2  PRBS6
            -- din_adj_t(1) | COMMA  PRBS1  PRBS5
            -- din_adj_t(0) | COMMA  PRBS0  PRBS4                     
            din_adj_t(2 to 3)      <= din   (0 to 1);
            din_adj_t(0 to 1)      <= din_r (1 to 2);
        when others =>
            -- clock        |  0       1      2
            -- din(3)       | PRBS0  PRBS4  PRBS8
            -- din(2)       | COMMA  PRBS3  PRBS7
            -- din(1)       | COMMA  PRBS2  PRBS6
            -- din(0)       | COMMA  PRBS1  PRBS5
            -- ------------ |---------------------  
            -- clock        |   0      1      2
            -- din_r(2)     | COMMA  PRBS0  PRBS4
            -- din_r(1)     | COMMA  COMMA  PRBS3
            -- din_r(0)     | COMMA  COMMA  PRBS2
            -- ------------ |---------------------  
            -- clock        |    0     1      2  
            -- din_adj_t(3) | COMMA  PRBS3  PRBS7
            -- din_adj_t(2) | COMMA  PRBS2  PRBS6
            -- din_adj_t(1) | COMMA  PRBS1  PRBS5
            -- din_adj_t(0) | COMMA  PRBS0  PRBS4                  
            din_adj_t(1 to 3)  <= din   (0 to 2);
            din_adj_t(0 to 0)  <= din_r (2 to 2); 
        end case; 
        end if;
      end process;    
 end generate gen_64b_datapath;

  --============================================================================================================================
  -- Data out aligned
  --============================================================================================================================
  process (clk)
  begin
    if rising_edge(clk) then
      if din_rdy = '0' or rst = '1' then
        dout_rdy <= '0';
      elsif prbs_frame_started = '1' then
        dout_rdy <= '1';
      end if;
    end if;
  end process;

  dout <= din_adj;  -- should be pipelined outside

  --============================================================================================================================
  -- Initialization LFSR
  --============================================================================================================================
  init_lfsr_proc : process (clk)
  begin
    if rising_edge (clk) then
      if din_rdy = '0' then
        lfsr_temp       <= (others => '0');
        lfsr_init_value <= (others => (others => '0'));

      elsif prbs_frame_started_r(0) = '1' then     -- get the initial prbs value
        lfsr_init_value <= (others => (others => '0'));       
        -- LSB bits
        if din_adj(0)(din_adj(0)'high) = '1' then  -- invert if disparity = '1'
          lfsr_temp (DATA_LENGTH - 1 downto 0) <= (not din_adj(0)(13 downto 0));
        else
          lfsr_temp (DATA_LENGTH - 1 downto 0) <= din_adj(0)(13 downto 0);
        end if;
        -- MSB bits
        if din_adj(1)(din_adj(1)'high) = '1' then  -- invert if disparity = '1'
          lfsr_temp(LFSR_LENGTH - 1 downto DATA_LENGTH) <= (not din_adj(1)(2 downto 0));
        else
          lfsr_temp(LFSR_LENGTH - 1 downto DATA_LENGTH) <= din_adj(1)(2 downto 0);
        end if;

      elsif prbs_frame_started_r(1) = '1' then  -- generate initial values for the first samples in the parallel bus     
        for idx in 0 to (DESER_WIDTH/16-1) loop 
            lfsr_init_value(idx) <= f_lfsr(lfsr_temp, LFSR_DELAY + idx);
        end loop;    
      else
        lfsr_temp       <= lfsr_temp;
        lfsr_init_value <= lfsr_init_value;

      end if;
    end if;
  end process init_lfsr_proc;

  gen_lfsr_proc : process (clk)
    variable v_temp : natural :=4;
  begin
      if DESER_WIDTH = 32 then v_temp := 2; 
    else                       v_temp := 4; end if;
    
    if rising_edge (clk) then
      if din_rdy = '0' then
        lfsr_value <= (others => (others => '0'));
      elsif prbs_frame_started_r (2) = '1' then
        lfsr_value               <= lfsr_init_value;
      else
        for idx in 0 to (DESER_WIDTH/16-1) loop  -- generate the next PRBS values
          lfsr_value(idx) <= f_lfsr(lfsr_value(idx), v_temp);
        end loop;  
      end if;
    end if;
  end process gen_lfsr_proc;

  prbs <= lfsr_value;

end architecture rtl;
