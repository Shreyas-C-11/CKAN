library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PkgKAN is
  -- Model parameters
  constant N_INPUT  : positive := 50;
  constant N_OUTPUT : positive := 10;

  -- bitwidths
  constant INPUT_WIDTH : positive := 16;
  constant OUTPUT_WIDTH : positive := 16;

  subtype input_t  is unsigned(INPUT_WIDTH-1 downto 0);
  subtype output_t is signed(OUTPUT_WIDTH-1 downto 0);

  type input_vec_t  is array (0 to N_INPUT-1)  of input_t;
  type output_vec_t is array (0 to N_OUTPUT-1) of output_t;

  -- For summation
  constant SUM_WIDTH_0_0: positive := 22;
  subtype sum_t_0_0 is signed(SUM_WIDTH_0_0-1 downto 0);
  constant SUM_WIDTH_0_1: positive := 22;
  subtype sum_t_0_1 is signed(SUM_WIDTH_0_1-1 downto 0);
  constant SUM_WIDTH_0_2: positive := 22;
  subtype sum_t_0_2 is signed(SUM_WIDTH_0_2-1 downto 0);
  constant SUM_WIDTH_0_3: positive := 22;
  subtype sum_t_0_3 is signed(SUM_WIDTH_0_3-1 downto 0);
  constant SUM_WIDTH_0_4: positive := 22;
  subtype sum_t_0_4 is signed(SUM_WIDTH_0_4-1 downto 0);
  constant SUM_WIDTH_0_5: positive := 22;
  subtype sum_t_0_5 is signed(SUM_WIDTH_0_5-1 downto 0);
  constant SUM_WIDTH_0_6: positive := 22;
  subtype sum_t_0_6 is signed(SUM_WIDTH_0_6-1 downto 0);
  constant SUM_WIDTH_0_7: positive := 22;
  subtype sum_t_0_7 is signed(SUM_WIDTH_0_7-1 downto 0);
  constant SUM_WIDTH_0_8: positive := 22;
  subtype sum_t_0_8 is signed(SUM_WIDTH_0_8-1 downto 0);
  constant SUM_WIDTH_0_9: positive := 22;
  subtype sum_t_0_9 is signed(SUM_WIDTH_0_9-1 downto 0);
  constant SUM_WIDTH_0_10: positive := 22;
  subtype sum_t_0_10 is signed(SUM_WIDTH_0_10-1 downto 0);
  constant SUM_WIDTH_0_11: positive := 22;
  subtype sum_t_0_11 is signed(SUM_WIDTH_0_11-1 downto 0);
  constant SUM_WIDTH_0_12: positive := 22;
  subtype sum_t_0_12 is signed(SUM_WIDTH_0_12-1 downto 0);
  constant SUM_WIDTH_0_13: positive := 22;
  subtype sum_t_0_13 is signed(SUM_WIDTH_0_13-1 downto 0);
  constant SUM_WIDTH_0_14: positive := 22;
  subtype sum_t_0_14 is signed(SUM_WIDTH_0_14-1 downto 0);
  constant SUM_WIDTH_0_15: positive := 22;
  subtype sum_t_0_15 is signed(SUM_WIDTH_0_15-1 downto 0);
  constant SUM_WIDTH_0_16: positive := 22;
  subtype sum_t_0_16 is signed(SUM_WIDTH_0_16-1 downto 0);
  constant SUM_WIDTH_0_17: positive := 22;
  subtype sum_t_0_17 is signed(SUM_WIDTH_0_17-1 downto 0);
  constant SUM_WIDTH_0_18: positive := 22;
  subtype sum_t_0_18 is signed(SUM_WIDTH_0_18-1 downto 0);
  constant SUM_WIDTH_0_19: positive := 22;
  subtype sum_t_0_19 is signed(SUM_WIDTH_0_19-1 downto 0);
  constant SUM_WIDTH_0_20: positive := 22;
  subtype sum_t_0_20 is signed(SUM_WIDTH_0_20-1 downto 0);
  constant SUM_WIDTH_0_21: positive := 22;
  subtype sum_t_0_21 is signed(SUM_WIDTH_0_21-1 downto 0);
  constant SUM_WIDTH_0_22: positive := 22;
  subtype sum_t_0_22 is signed(SUM_WIDTH_0_22-1 downto 0);
  constant SUM_WIDTH_0_23: positive := 22;
  subtype sum_t_0_23 is signed(SUM_WIDTH_0_23-1 downto 0);
  constant SUM_WIDTH_0_24: positive := 22;
  subtype sum_t_0_24 is signed(SUM_WIDTH_0_24-1 downto 0);
  constant SUM_WIDTH_0_25: positive := 22;
  subtype sum_t_0_25 is signed(SUM_WIDTH_0_25-1 downto 0);
  constant SUM_WIDTH_0_26: positive := 22;
  subtype sum_t_0_26 is signed(SUM_WIDTH_0_26-1 downto 0);
  constant SUM_WIDTH_0_27: positive := 22;
  subtype sum_t_0_27 is signed(SUM_WIDTH_0_27-1 downto 0);
  constant SUM_WIDTH_0_28: positive := 22;
  subtype sum_t_0_28 is signed(SUM_WIDTH_0_28-1 downto 0);
  constant SUM_WIDTH_0_29: positive := 22;
  subtype sum_t_0_29 is signed(SUM_WIDTH_0_29-1 downto 0);
  constant SUM_WIDTH_0_30: positive := 22;
  subtype sum_t_0_30 is signed(SUM_WIDTH_0_30-1 downto 0);
  constant SUM_WIDTH_0_31: positive := 22;
  subtype sum_t_0_31 is signed(SUM_WIDTH_0_31-1 downto 0);
  constant SUM_WIDTH_1_0: positive := 21;
  subtype sum_t_1_0 is signed(SUM_WIDTH_1_0-1 downto 0);
  constant SUM_WIDTH_1_1: positive := 21;
  subtype sum_t_1_1 is signed(SUM_WIDTH_1_1-1 downto 0);
  constant SUM_WIDTH_1_2: positive := 21;
  subtype sum_t_1_2 is signed(SUM_WIDTH_1_2-1 downto 0);
  constant SUM_WIDTH_1_3: positive := 21;
  subtype sum_t_1_3 is signed(SUM_WIDTH_1_3-1 downto 0);
  constant SUM_WIDTH_1_4: positive := 21;
  subtype sum_t_1_4 is signed(SUM_WIDTH_1_4-1 downto 0);
  constant SUM_WIDTH_1_5: positive := 21;
  subtype sum_t_1_5 is signed(SUM_WIDTH_1_5-1 downto 0);
  constant SUM_WIDTH_1_6: positive := 21;
  subtype sum_t_1_6 is signed(SUM_WIDTH_1_6-1 downto 0);
  constant SUM_WIDTH_1_7: positive := 21;
  subtype sum_t_1_7 is signed(SUM_WIDTH_1_7-1 downto 0);
  constant SUM_WIDTH_1_8: positive := 21;
  subtype sum_t_1_8 is signed(SUM_WIDTH_1_8-1 downto 0);
  constant SUM_WIDTH_1_9: positive := 21;
  subtype sum_t_1_9 is signed(SUM_WIDTH_1_9-1 downto 0);
  
  -- Function to saturate a signed value into W-bit signed range
  function saturate(x : signed; W : positive) return signed;
end package PkgKAN;

package body PkgKAN is
  -- Function to saturate a signed value into W-bit signed range
  function saturate(x : signed; W : positive) return signed is
      constant MAX_W_BITS : signed(W-1 downto 0) := (W-1 => '0', others => '1');
      constant MIN_W_BITS : signed(W-1 downto 0) := (W-1 => '1', others => '0');

      variable max_for_comp : signed(x'length-1 downto 0) := resize(MAX_W_BITS, x'length);
      variable min_for_comp : signed(x'length-1 downto 0) := resize(MIN_W_BITS, x'length);
      
      variable result : signed(W-1 downto 0);
  begin
      if x > max_for_comp then
          result := MAX_W_BITS;
      elsif x < min_for_comp then
          result := MIN_W_BITS;
      else
          result := resize(x, W);
      end if;

      return result;
  end function;
end package body PkgKAN;