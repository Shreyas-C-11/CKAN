library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PkgKAN.all;
use work.PkgLUT.all;

entity KAN is
  port (
    clk    : in  std_logic;
    en     : in  std_logic := '1';
    input  : in  input_vec_t;
    output : out output_vec_t
  );
end entity;

architecture rtl of KAN is
  -- === auto: signal declarations ===
  -- Layer 0 (50->32)
  signal act_0_0_3, act_0_0_4, act_0_0_12, act_0_0_14, act_0_0_16, act_0_0_17, act_0_0_18, act_0_0_20, act_0_0_21, act_0_0_23, act_0_0_24, act_0_0_28, act_0_0_31, act_0_1_0, act_0_1_1, act_0_1_3 : lut_output_t_0;
  signal act_0_1_5, act_0_1_6, act_0_1_7, act_0_1_8, act_0_1_10, act_0_1_12, act_0_1_13, act_0_1_14, act_0_1_15, act_0_1_17, act_0_1_18, act_0_1_19, act_0_1_20, act_0_1_22, act_0_1_23, act_0_1_24 : lut_output_t_0;
  signal act_0_1_25, act_0_1_27, act_0_1_28, act_0_1_29, act_0_1_30, act_0_1_31, act_0_2_0, act_0_2_1, act_0_2_2, act_0_2_3, act_0_2_5, act_0_2_6, act_0_2_7, act_0_2_8, act_0_2_9, act_0_2_10 : lut_output_t_0;
  signal act_0_2_11, act_0_2_12, act_0_2_13, act_0_2_14, act_0_2_15, act_0_2_16, act_0_2_17, act_0_2_18, act_0_2_20, act_0_2_21, act_0_2_22, act_0_2_23, act_0_2_24, act_0_2_25, act_0_2_28, act_0_2_29 : lut_output_t_0;
  signal act_0_2_30, act_0_3_0, act_0_3_2, act_0_3_3, act_0_3_4, act_0_3_5, act_0_3_6, act_0_3_7, act_0_3_8, act_0_3_9, act_0_3_10, act_0_3_11, act_0_3_12, act_0_3_13, act_0_3_14, act_0_3_15 : lut_output_t_0;
  signal act_0_3_16, act_0_3_17, act_0_3_18, act_0_3_19, act_0_3_20, act_0_3_21, act_0_3_22, act_0_3_23, act_0_3_24, act_0_3_25, act_0_3_26, act_0_3_27, act_0_3_29, act_0_3_30, act_0_3_31, act_0_4_0 : lut_output_t_0;
  signal act_0_4_1, act_0_4_2, act_0_4_3, act_0_4_4, act_0_4_5, act_0_4_7, act_0_4_8, act_0_4_9, act_0_4_11, act_0_4_12, act_0_4_13, act_0_4_14, act_0_4_15, act_0_4_16, act_0_4_17, act_0_4_18 : lut_output_t_0;
  signal act_0_4_21, act_0_4_22, act_0_4_24, act_0_4_25, act_0_4_27, act_0_4_29, act_0_4_30, act_0_4_31, act_0_5_3, act_0_5_5, act_0_5_6, act_0_5_7, act_0_5_8, act_0_5_10, act_0_5_11, act_0_5_14 : lut_output_t_0;
  signal act_0_5_15, act_0_5_16, act_0_5_18, act_0_5_19, act_0_5_20, act_0_5_22, act_0_5_23, act_0_5_24, act_0_5_25, act_0_5_26, act_0_5_28, act_0_5_29, act_0_5_30, act_0_5_31, act_0_6_0, act_0_6_1 : lut_output_t_0;
  signal act_0_6_2, act_0_6_3, act_0_6_4, act_0_6_5, act_0_6_6, act_0_6_7, act_0_6_8, act_0_6_9, act_0_6_10, act_0_6_11, act_0_6_12, act_0_6_14, act_0_6_15, act_0_6_16, act_0_6_17, act_0_6_19 : lut_output_t_0;
  signal act_0_6_20, act_0_6_21, act_0_6_22, act_0_6_23, act_0_6_24, act_0_6_25, act_0_6_26, act_0_6_27, act_0_6_28, act_0_6_29, act_0_6_30, act_0_6_31, act_0_7_0, act_0_7_1, act_0_7_2, act_0_7_3 : lut_output_t_0;
  signal act_0_7_4, act_0_7_5, act_0_7_6, act_0_7_7, act_0_7_8, act_0_7_9, act_0_7_10, act_0_7_12, act_0_7_13, act_0_7_14, act_0_7_15, act_0_7_16, act_0_7_18, act_0_7_20, act_0_7_22, act_0_7_23 : lut_output_t_0;
  signal act_0_7_24, act_0_7_25, act_0_7_26, act_0_7_27, act_0_7_28, act_0_7_29, act_0_7_30, act_0_7_31, act_0_8_0, act_0_8_1, act_0_8_2, act_0_8_3, act_0_8_4, act_0_8_5, act_0_8_6, act_0_8_7 : lut_output_t_0;
  signal act_0_8_9, act_0_8_10, act_0_8_11, act_0_8_12, act_0_8_13, act_0_8_14, act_0_8_15, act_0_8_16, act_0_8_17, act_0_8_18, act_0_8_19, act_0_8_20, act_0_8_21, act_0_8_22, act_0_8_24, act_0_8_25 : lut_output_t_0;
  signal act_0_8_26, act_0_8_27, act_0_8_28, act_0_8_29, act_0_8_30, act_0_8_31, act_0_9_0, act_0_9_1, act_0_9_2, act_0_9_3, act_0_9_5, act_0_9_6, act_0_9_7, act_0_9_9, act_0_9_10, act_0_9_11 : lut_output_t_0;
  signal act_0_9_13, act_0_9_14, act_0_9_15, act_0_9_16, act_0_9_17, act_0_9_19, act_0_9_20, act_0_9_21, act_0_9_22, act_0_9_23, act_0_9_24, act_0_9_26, act_0_9_27, act_0_9_28, act_0_9_29, act_0_9_30 : lut_output_t_0;
  signal act_0_9_31, act_0_10_0, act_0_10_1, act_0_10_2, act_0_10_3, act_0_10_4, act_0_10_5, act_0_10_6, act_0_10_7, act_0_10_8, act_0_10_9, act_0_10_11, act_0_10_12, act_0_10_13, act_0_10_14, act_0_10_16 : lut_output_t_0;
  signal act_0_10_18, act_0_10_21, act_0_10_22, act_0_10_25, act_0_10_26, act_0_10_27, act_0_10_28, act_0_10_29, act_0_10_31, act_0_11_1, act_0_11_2, act_0_11_3, act_0_11_4, act_0_11_5, act_0_11_7, act_0_11_8 : lut_output_t_0;
  signal act_0_11_9, act_0_11_10, act_0_11_11, act_0_11_12, act_0_11_13, act_0_11_14, act_0_11_15, act_0_11_16, act_0_11_18, act_0_11_19, act_0_11_20, act_0_11_21, act_0_11_22, act_0_11_23, act_0_11_24, act_0_11_25 : lut_output_t_0;
  signal act_0_11_26, act_0_11_27, act_0_11_28, act_0_11_29, act_0_11_31, act_0_12_0, act_0_12_1, act_0_12_2, act_0_12_3, act_0_12_4, act_0_12_5, act_0_12_6, act_0_12_7, act_0_12_8, act_0_12_9, act_0_12_10 : lut_output_t_0;
  signal act_0_12_11, act_0_12_12, act_0_12_13, act_0_12_14, act_0_12_15, act_0_12_16, act_0_12_18, act_0_12_19, act_0_12_20, act_0_12_21, act_0_12_22, act_0_12_23, act_0_12_24, act_0_12_25, act_0_12_26, act_0_12_27 : lut_output_t_0;
  signal act_0_12_28, act_0_12_29, act_0_12_30, act_0_12_31, act_0_13_0, act_0_13_1, act_0_13_2, act_0_13_5, act_0_13_6, act_0_13_7, act_0_13_8, act_0_13_9, act_0_13_10, act_0_13_11, act_0_13_12, act_0_13_13 : lut_output_t_0;
  signal act_0_13_14, act_0_13_15, act_0_13_16, act_0_13_17, act_0_13_18, act_0_13_20, act_0_13_21, act_0_13_23, act_0_13_24, act_0_13_25, act_0_13_26, act_0_13_27, act_0_13_28, act_0_13_29, act_0_13_30, act_0_13_31 : lut_output_t_0;
  signal act_0_14_0, act_0_14_1, act_0_14_2, act_0_14_3, act_0_14_4, act_0_14_5, act_0_14_6, act_0_14_7, act_0_14_8, act_0_14_9, act_0_14_10, act_0_14_11, act_0_14_12, act_0_14_13, act_0_14_15, act_0_14_16 : lut_output_t_0;
  signal act_0_14_17, act_0_14_18, act_0_14_19, act_0_14_21, act_0_14_23, act_0_14_24, act_0_14_25, act_0_14_26, act_0_14_27, act_0_14_28, act_0_14_29, act_0_14_30, act_0_14_31, act_0_15_0, act_0_15_1, act_0_15_2 : lut_output_t_0;
  signal act_0_15_3, act_0_15_5, act_0_15_6, act_0_15_7, act_0_15_8, act_0_15_9, act_0_15_10, act_0_15_11, act_0_15_14, act_0_15_15, act_0_15_16, act_0_15_18, act_0_15_19, act_0_15_20, act_0_15_21, act_0_15_22 : lut_output_t_0;
  signal act_0_15_23, act_0_15_24, act_0_15_25, act_0_15_27, act_0_15_29, act_0_15_31, act_0_16_0, act_0_16_2, act_0_16_3, act_0_16_4, act_0_16_5, act_0_16_6, act_0_16_8, act_0_16_10, act_0_16_11, act_0_16_14 : lut_output_t_0;
  signal act_0_16_15, act_0_16_16, act_0_16_17, act_0_16_18, act_0_16_19, act_0_16_20, act_0_16_21, act_0_16_22, act_0_16_23, act_0_16_24, act_0_16_25, act_0_16_26, act_0_16_27, act_0_16_28, act_0_16_29, act_0_16_30 : lut_output_t_0;
  signal act_0_16_31, act_0_17_0, act_0_17_2, act_0_17_3, act_0_17_4, act_0_17_5, act_0_17_7, act_0_17_8, act_0_17_9, act_0_17_10, act_0_17_11, act_0_17_12, act_0_17_13, act_0_17_14, act_0_17_15, act_0_17_16 : lut_output_t_0;
  signal act_0_17_17, act_0_17_18, act_0_17_19, act_0_17_20, act_0_17_21, act_0_17_22, act_0_17_23, act_0_17_24, act_0_17_25, act_0_17_26, act_0_17_27, act_0_17_28, act_0_17_29, act_0_17_30, act_0_17_31, act_0_18_0 : lut_output_t_0;
  signal act_0_18_1, act_0_18_2, act_0_18_3, act_0_18_4, act_0_18_5, act_0_18_6, act_0_18_8, act_0_18_9, act_0_18_10, act_0_18_11, act_0_18_12, act_0_18_13, act_0_18_14, act_0_18_15, act_0_18_16, act_0_18_17 : lut_output_t_0;
  signal act_0_18_18, act_0_18_19, act_0_18_20, act_0_18_21, act_0_18_22, act_0_18_23, act_0_18_24, act_0_18_25, act_0_18_26, act_0_18_27, act_0_18_28, act_0_18_30, act_0_18_31, act_0_19_0, act_0_19_1, act_0_19_2 : lut_output_t_0;
  signal act_0_19_3, act_0_19_4, act_0_19_5, act_0_19_6, act_0_19_7, act_0_19_8, act_0_19_9, act_0_19_10, act_0_19_11, act_0_19_13, act_0_19_14, act_0_19_15, act_0_19_17, act_0_19_18, act_0_19_19, act_0_19_20 : lut_output_t_0;
  signal act_0_19_21, act_0_19_24, act_0_19_25, act_0_19_26, act_0_19_27, act_0_19_28, act_0_19_29, act_0_19_30, act_0_19_31, act_0_20_1, act_0_20_2, act_0_20_4, act_0_20_5, act_0_20_6, act_0_20_10, act_0_20_11 : lut_output_t_0;
  signal act_0_20_13, act_0_20_14, act_0_20_15, act_0_20_16, act_0_20_20, act_0_20_21, act_0_20_22, act_0_20_23, act_0_20_25, act_0_20_27, act_0_20_29, act_0_20_30, act_0_21_1, act_0_21_2, act_0_21_3, act_0_21_4 : lut_output_t_0;
  signal act_0_21_5, act_0_21_6, act_0_21_7, act_0_21_8, act_0_21_9, act_0_21_11, act_0_21_12, act_0_21_13, act_0_21_14, act_0_21_15, act_0_21_16, act_0_21_17, act_0_21_18, act_0_21_20, act_0_21_21, act_0_21_22 : lut_output_t_0;
  signal act_0_21_23, act_0_21_25, act_0_21_27, act_0_21_28, act_0_21_29, act_0_21_30, act_0_21_31, act_0_22_0, act_0_22_1, act_0_22_2, act_0_22_3, act_0_22_4, act_0_22_6, act_0_22_7, act_0_22_8, act_0_22_10 : lut_output_t_0;
  signal act_0_22_11, act_0_22_12, act_0_22_13, act_0_22_14, act_0_22_15, act_0_22_17, act_0_22_18, act_0_22_19, act_0_22_20, act_0_22_21, act_0_22_22, act_0_22_24, act_0_22_25, act_0_22_27, act_0_22_28, act_0_22_29 : lut_output_t_0;
  signal act_0_22_30, act_0_22_31, act_0_23_0, act_0_23_1, act_0_23_2, act_0_23_3, act_0_23_4, act_0_23_5, act_0_23_6, act_0_23_7, act_0_23_8, act_0_23_9, act_0_23_10, act_0_23_11, act_0_23_12, act_0_23_14 : lut_output_t_0;
  signal act_0_23_15, act_0_23_16, act_0_23_17, act_0_23_18, act_0_23_19, act_0_23_20, act_0_23_25, act_0_23_27, act_0_23_28, act_0_23_29, act_0_23_30, act_0_23_31, act_0_24_0, act_0_24_1, act_0_24_2, act_0_24_3 : lut_output_t_0;
  signal act_0_24_4, act_0_24_6, act_0_24_7, act_0_24_10, act_0_24_12, act_0_24_15, act_0_24_16, act_0_24_17, act_0_24_18, act_0_24_19, act_0_24_22, act_0_24_24, act_0_24_25, act_0_24_26, act_0_24_27, act_0_24_28 : lut_output_t_0;
  signal act_0_24_29, act_0_24_30, act_0_25_4, act_0_25_5, act_0_25_7, act_0_25_9, act_0_25_10, act_0_25_12, act_0_25_13, act_0_25_16, act_0_25_17, act_0_25_22, act_0_25_23, act_0_25_26, act_0_25_27, act_0_25_29 : lut_output_t_0;
  signal act_0_26_1, act_0_26_2, act_0_26_4, act_0_26_7, act_0_26_8, act_0_26_9, act_0_26_12, act_0_26_13, act_0_26_16, act_0_26_18, act_0_26_19, act_0_26_21, act_0_26_22, act_0_26_23, act_0_26_24, act_0_26_25 : lut_output_t_0;
  signal act_0_26_26, act_0_26_28, act_0_26_29, act_0_26_30, act_0_26_31, act_0_27_0, act_0_27_2, act_0_27_3, act_0_27_4, act_0_27_5, act_0_27_6, act_0_27_7, act_0_27_8, act_0_27_9, act_0_27_10, act_0_27_11 : lut_output_t_0;
  signal act_0_27_12, act_0_27_13, act_0_27_15, act_0_27_16, act_0_27_18, act_0_27_19, act_0_27_20, act_0_27_21, act_0_27_23, act_0_27_24, act_0_27_25, act_0_27_27, act_0_27_28, act_0_27_29, act_0_27_30, act_0_27_31 : lut_output_t_0;
  signal act_0_28_1, act_0_28_2, act_0_28_4, act_0_28_5, act_0_28_6, act_0_28_7, act_0_28_8, act_0_28_9, act_0_28_10, act_0_28_13, act_0_28_14, act_0_28_15, act_0_28_16, act_0_28_18, act_0_28_19, act_0_28_20 : lut_output_t_0;
  signal act_0_28_21, act_0_28_22, act_0_28_23, act_0_28_24, act_0_28_25, act_0_28_26, act_0_28_27, act_0_28_28, act_0_28_29, act_0_28_30, act_0_28_31, act_0_29_1, act_0_29_2, act_0_29_4, act_0_29_5, act_0_29_7 : lut_output_t_0;
  signal act_0_29_8, act_0_29_9, act_0_29_10, act_0_29_11, act_0_29_12, act_0_29_13, act_0_29_14, act_0_29_15, act_0_29_16, act_0_29_17, act_0_29_18, act_0_29_19, act_0_29_20, act_0_29_21, act_0_29_23, act_0_29_25 : lut_output_t_0;
  signal act_0_29_27, act_0_29_29, act_0_29_30, act_0_29_31, act_0_30_0, act_0_30_2, act_0_30_3, act_0_30_5, act_0_30_7, act_0_30_9, act_0_30_11, act_0_30_12, act_0_30_14, act_0_30_15, act_0_30_16, act_0_30_17 : lut_output_t_0;
  signal act_0_30_18, act_0_30_19, act_0_30_20, act_0_30_22, act_0_30_25, act_0_30_26, act_0_30_28, act_0_30_30, act_0_31_0, act_0_31_3, act_0_31_4, act_0_31_5, act_0_31_6, act_0_31_7, act_0_31_8, act_0_31_9 : lut_output_t_0;
  signal act_0_31_10, act_0_31_11, act_0_31_12, act_0_31_14, act_0_31_15, act_0_31_17, act_0_31_18, act_0_31_19, act_0_31_21, act_0_31_22, act_0_31_23, act_0_31_24, act_0_31_26, act_0_31_27, act_0_31_28, act_0_31_29 : lut_output_t_0;
  signal act_0_31_30, act_0_31_31, act_0_32_0, act_0_32_1, act_0_32_2, act_0_32_3, act_0_32_4, act_0_32_7, act_0_32_8, act_0_32_9, act_0_32_10, act_0_32_11, act_0_32_12, act_0_32_13, act_0_32_14, act_0_32_15 : lut_output_t_0;
  signal act_0_32_16, act_0_32_18, act_0_32_19, act_0_32_20, act_0_32_21, act_0_32_23, act_0_32_24, act_0_32_25, act_0_32_26, act_0_32_28, act_0_32_30, act_0_32_31, act_0_33_0, act_0_33_1, act_0_33_2, act_0_33_5 : lut_output_t_0;
  signal act_0_33_6, act_0_33_7, act_0_33_8, act_0_33_9, act_0_33_10, act_0_33_11, act_0_33_12, act_0_33_13, act_0_33_14, act_0_33_16, act_0_33_17, act_0_33_18, act_0_33_19, act_0_33_20, act_0_33_21, act_0_33_22 : lut_output_t_0;
  signal act_0_33_23, act_0_33_24, act_0_33_25, act_0_33_26, act_0_33_27, act_0_33_28, act_0_33_29, act_0_33_31, act_0_34_0, act_0_34_1, act_0_34_2, act_0_34_3, act_0_34_4, act_0_34_5, act_0_34_6, act_0_34_7 : lut_output_t_0;
  signal act_0_34_8, act_0_34_9, act_0_34_10, act_0_34_11, act_0_34_12, act_0_34_13, act_0_34_15, act_0_34_17, act_0_34_19, act_0_34_20, act_0_34_21, act_0_34_22, act_0_34_24, act_0_34_25, act_0_34_26, act_0_34_27 : lut_output_t_0;
  signal act_0_34_28, act_0_34_29, act_0_34_30, act_0_34_31, act_0_35_0, act_0_35_2, act_0_35_3, act_0_35_4, act_0_35_5, act_0_35_7, act_0_35_8, act_0_35_9, act_0_35_10, act_0_35_11, act_0_35_12, act_0_35_14 : lut_output_t_0;
  signal act_0_35_15, act_0_35_16, act_0_35_17, act_0_35_18, act_0_35_19, act_0_35_20, act_0_35_22, act_0_35_23, act_0_35_24, act_0_35_26, act_0_35_27, act_0_35_28, act_0_35_29, act_0_35_30, act_0_35_31, act_0_36_0 : lut_output_t_0;
  signal act_0_36_2, act_0_36_3, act_0_36_4, act_0_36_5, act_0_36_6, act_0_36_7, act_0_36_8, act_0_36_9, act_0_36_12, act_0_36_13, act_0_36_14, act_0_36_15, act_0_36_16, act_0_36_17, act_0_36_18, act_0_36_19 : lut_output_t_0;
  signal act_0_36_20, act_0_36_21, act_0_36_22, act_0_36_23, act_0_36_24, act_0_36_25, act_0_36_26, act_0_36_27, act_0_36_31, act_0_37_0, act_0_37_1, act_0_37_2, act_0_37_3, act_0_37_4, act_0_37_5, act_0_37_6 : lut_output_t_0;
  signal act_0_37_7, act_0_37_8, act_0_37_9, act_0_37_10, act_0_37_12, act_0_37_13, act_0_37_14, act_0_37_15, act_0_37_16, act_0_37_17, act_0_37_18, act_0_37_19, act_0_37_20, act_0_37_21, act_0_37_22, act_0_37_23 : lut_output_t_0;
  signal act_0_37_24, act_0_37_26, act_0_37_27, act_0_37_28, act_0_37_29, act_0_37_30, act_0_37_31, act_0_38_0, act_0_38_3, act_0_38_4, act_0_38_5, act_0_38_6, act_0_38_8, act_0_38_9, act_0_38_10, act_0_38_11 : lut_output_t_0;
  signal act_0_38_12, act_0_38_13, act_0_38_14, act_0_38_15, act_0_38_16, act_0_38_18, act_0_38_19, act_0_38_20, act_0_38_23, act_0_38_24, act_0_38_25, act_0_38_26, act_0_38_27, act_0_38_28, act_0_38_29, act_0_38_30 : lut_output_t_0;
  signal act_0_38_31, act_0_39_0, act_0_39_1, act_0_39_2, act_0_39_3, act_0_39_4, act_0_39_5, act_0_39_6, act_0_39_8, act_0_39_9, act_0_39_11, act_0_39_12, act_0_39_13, act_0_39_15, act_0_39_16, act_0_39_17 : lut_output_t_0;
  signal act_0_39_19, act_0_39_20, act_0_39_21, act_0_39_22, act_0_39_23, act_0_39_24, act_0_39_27, act_0_39_28, act_0_40_1, act_0_40_2, act_0_40_3, act_0_40_4, act_0_40_5, act_0_40_6, act_0_40_7, act_0_40_8 : lut_output_t_0;
  signal act_0_40_10, act_0_40_11, act_0_40_12, act_0_40_13, act_0_40_14, act_0_40_15, act_0_40_18, act_0_40_19, act_0_40_20, act_0_40_21, act_0_40_22, act_0_40_23, act_0_40_24, act_0_40_25, act_0_40_27, act_0_40_28 : lut_output_t_0;
  signal act_0_40_29, act_0_40_30, act_0_41_0, act_0_41_2, act_0_41_3, act_0_41_5, act_0_41_6, act_0_41_7, act_0_41_8, act_0_41_9, act_0_41_10, act_0_41_11, act_0_41_13, act_0_41_14, act_0_41_15, act_0_41_16 : lut_output_t_0;
  signal act_0_41_17, act_0_41_18, act_0_41_19, act_0_41_21, act_0_41_22, act_0_41_23, act_0_41_24, act_0_41_27, act_0_41_28, act_0_41_29, act_0_42_1, act_0_42_2, act_0_42_3, act_0_42_4, act_0_42_5, act_0_42_6 : lut_output_t_0;
  signal act_0_42_7, act_0_42_8, act_0_42_10, act_0_42_11, act_0_42_12, act_0_42_13, act_0_42_14, act_0_42_15, act_0_42_16, act_0_42_18, act_0_42_19, act_0_42_20, act_0_42_21, act_0_42_22, act_0_42_23, act_0_42_24 : lut_output_t_0;
  signal act_0_42_25, act_0_42_26, act_0_42_27, act_0_42_28, act_0_42_29, act_0_42_30, act_0_42_31, act_0_43_0, act_0_43_1, act_0_43_2, act_0_43_3, act_0_43_4, act_0_43_5, act_0_43_6, act_0_43_7, act_0_43_8 : lut_output_t_0;
  signal act_0_43_9, act_0_43_10, act_0_43_11, act_0_43_12, act_0_43_14, act_0_43_15, act_0_43_16, act_0_43_17, act_0_43_18, act_0_43_19, act_0_43_20, act_0_43_21, act_0_43_22, act_0_43_23, act_0_43_24, act_0_43_25 : lut_output_t_0;
  signal act_0_43_26, act_0_43_27, act_0_43_28, act_0_43_29, act_0_43_30, act_0_43_31, act_0_44_0, act_0_44_1, act_0_44_2, act_0_44_4, act_0_44_5, act_0_44_6, act_0_44_7, act_0_44_8, act_0_44_10, act_0_44_11 : lut_output_t_0;
  signal act_0_44_12, act_0_44_13, act_0_44_14, act_0_44_15, act_0_44_16, act_0_44_17, act_0_44_18, act_0_44_19, act_0_44_20, act_0_44_21, act_0_44_22, act_0_44_25, act_0_44_27, act_0_44_29, act_0_45_0, act_0_45_2 : lut_output_t_0;
  signal act_0_45_3, act_0_45_4, act_0_45_5, act_0_45_6, act_0_45_8, act_0_45_10, act_0_45_11, act_0_45_12, act_0_45_13, act_0_45_14, act_0_45_15, act_0_45_16, act_0_45_17, act_0_45_18, act_0_45_20, act_0_45_22 : lut_output_t_0;
  signal act_0_45_23, act_0_45_24, act_0_45_25, act_0_45_26, act_0_45_27, act_0_46_0, act_0_46_1, act_0_46_2, act_0_46_3, act_0_46_4, act_0_46_6, act_0_46_8, act_0_46_9, act_0_46_10, act_0_46_11, act_0_46_12 : lut_output_t_0;
  signal act_0_46_13, act_0_46_14, act_0_46_15, act_0_46_16, act_0_46_17, act_0_46_18, act_0_46_19, act_0_46_20, act_0_46_21, act_0_46_22, act_0_46_23, act_0_46_25, act_0_46_26, act_0_46_27, act_0_46_28, act_0_46_29 : lut_output_t_0;
  signal act_0_46_30, act_0_47_0, act_0_47_1, act_0_47_2, act_0_47_3, act_0_47_4, act_0_47_5, act_0_47_6, act_0_47_7, act_0_47_8, act_0_47_9, act_0_47_10, act_0_47_11, act_0_47_13, act_0_47_14, act_0_47_15 : lut_output_t_0;
  signal act_0_47_16, act_0_47_17, act_0_47_18, act_0_47_19, act_0_47_20, act_0_47_21, act_0_47_22, act_0_47_24, act_0_47_25, act_0_47_26, act_0_47_27, act_0_47_29, act_0_47_30, act_0_48_0, act_0_48_1, act_0_48_2 : lut_output_t_0;
  signal act_0_48_3, act_0_48_4, act_0_48_5, act_0_48_6, act_0_48_8, act_0_48_9, act_0_48_10, act_0_48_11, act_0_48_12, act_0_48_13, act_0_48_14, act_0_48_15, act_0_48_16, act_0_48_17, act_0_48_18, act_0_48_19 : lut_output_t_0;
  signal act_0_48_21, act_0_48_25, act_0_48_27, act_0_48_28, act_0_48_30, act_0_48_31, act_0_49_0, act_0_49_1, act_0_49_2, act_0_49_3, act_0_49_4, act_0_49_7, act_0_49_9, act_0_49_10, act_0_49_12, act_0_49_13 : lut_output_t_0;
  signal act_0_49_14, act_0_49_15, act_0_49_17, act_0_49_18, act_0_49_19, act_0_49_20, act_0_49_21, act_0_49_23, act_0_49_24, act_0_49_25, act_0_49_26, act_0_49_27, act_0_49_28, act_0_49_29 : lut_output_t_0;
  signal out0_0, out0_1, out0_2, out0_3, out0_4, out0_5, out0_6, out0_7, out0_8, out0_9, out0_10, out0_11, out0_12, out0_13, out0_14, out0_15 : lut_output_t_0;
  signal out0_16, out0_17, out0_18, out0_19, out0_20, out0_21, out0_22, out0_23, out0_24, out0_25, out0_26, out0_27, out0_28, out0_29, out0_30, out0_31 : lut_output_t_0;
  signal out0_0_reg, out0_1_reg, out0_2_reg, out0_3_reg, out0_4_reg, out0_5_reg, out0_6_reg, out0_7_reg, out0_8_reg, out0_9_reg, out0_10_reg, out0_11_reg, out0_12_reg, out0_13_reg, out0_14_reg, out0_15_reg : lut_output_t_0;
  signal out0_16_reg, out0_17_reg, out0_18_reg, out0_19_reg, out0_20_reg, out0_21_reg, out0_22_reg, out0_23_reg, out0_24_reg, out0_25_reg, out0_26_reg, out0_27_reg, out0_28_reg, out0_29_reg, out0_30_reg, out0_31_reg : lut_output_t_0;

-- Layer 1 (32->10)
  signal act_1_0_0, act_1_0_1, act_1_0_2, act_1_0_3, act_1_0_4, act_1_0_6, act_1_0_7, act_1_0_8, act_1_0_9, act_1_1_0, act_1_1_1, act_1_1_2, act_1_1_3, act_1_1_4, act_1_1_5, act_1_1_6 : lut_output_t_1;
  signal act_1_1_7, act_1_1_8, act_1_2_0, act_1_2_1, act_1_2_4, act_1_2_5, act_1_2_6, act_1_2_7, act_1_2_8, act_1_2_9, act_1_3_0, act_1_3_1, act_1_3_2, act_1_3_3, act_1_3_4, act_1_3_5 : lut_output_t_1;
  signal act_1_3_6, act_1_3_7, act_1_3_8, act_1_3_9, act_1_4_0, act_1_4_1, act_1_4_2, act_1_4_3, act_1_4_4, act_1_4_5, act_1_4_6, act_1_4_7, act_1_4_8, act_1_5_0, act_1_5_1, act_1_5_3 : lut_output_t_1;
  signal act_1_5_4, act_1_5_5, act_1_5_6, act_1_5_7, act_1_5_8, act_1_5_9, act_1_6_0, act_1_6_1, act_1_6_2, act_1_6_3, act_1_6_4, act_1_6_6, act_1_6_7, act_1_6_8, act_1_6_9, act_1_7_0 : lut_output_t_1;
  signal act_1_7_1, act_1_7_2, act_1_7_3, act_1_7_4, act_1_7_5, act_1_7_6, act_1_7_7, act_1_7_8, act_1_7_9, act_1_8_0, act_1_8_1, act_1_8_2, act_1_8_3, act_1_8_4, act_1_8_5, act_1_8_6 : lut_output_t_1;
  signal act_1_8_7, act_1_8_8, act_1_8_9, act_1_9_1, act_1_9_2, act_1_9_3, act_1_9_4, act_1_9_5, act_1_9_6, act_1_9_8, act_1_9_9, act_1_10_1, act_1_10_2, act_1_10_3, act_1_10_5, act_1_10_6 : lut_output_t_1;
  signal act_1_10_7, act_1_10_8, act_1_10_9, act_1_11_0, act_1_11_1, act_1_11_2, act_1_11_3, act_1_11_4, act_1_11_5, act_1_11_6, act_1_11_7, act_1_11_8, act_1_12_0, act_1_12_1, act_1_12_2, act_1_12_3 : lut_output_t_1;
  signal act_1_12_4, act_1_12_5, act_1_12_6, act_1_12_7, act_1_12_8, act_1_12_9, act_1_13_0, act_1_13_1, act_1_13_3, act_1_13_4, act_1_13_5, act_1_13_6, act_1_13_7, act_1_13_9, act_1_14_0, act_1_14_1 : lut_output_t_1;
  signal act_1_14_2, act_1_14_5, act_1_14_6, act_1_14_7, act_1_14_8, act_1_15_0, act_1_15_1, act_1_15_2, act_1_15_3, act_1_15_4, act_1_15_5, act_1_15_6, act_1_15_7, act_1_15_8, act_1_15_9, act_1_16_0 : lut_output_t_1;
  signal act_1_16_1, act_1_16_2, act_1_16_3, act_1_16_4, act_1_16_5, act_1_16_6, act_1_16_7, act_1_16_9, act_1_17_0, act_1_17_2, act_1_17_4, act_1_17_5, act_1_17_6, act_1_17_8, act_1_17_9, act_1_18_0 : lut_output_t_1;
  signal act_1_18_1, act_1_18_2, act_1_18_3, act_1_18_4, act_1_18_5, act_1_18_6, act_1_18_7, act_1_18_8, act_1_19_0, act_1_19_1, act_1_19_2, act_1_19_3, act_1_19_4, act_1_19_5, act_1_19_6, act_1_19_7 : lut_output_t_1;
  signal act_1_19_8, act_1_19_9, act_1_20_0, act_1_20_1, act_1_20_4, act_1_20_5, act_1_20_6, act_1_20_7, act_1_20_8, act_1_20_9, act_1_21_0, act_1_21_1, act_1_21_2, act_1_21_3, act_1_21_4, act_1_21_6 : lut_output_t_1;
  signal act_1_21_7, act_1_21_8, act_1_21_9, act_1_22_0, act_1_22_1, act_1_22_2, act_1_22_3, act_1_22_4, act_1_22_6, act_1_22_8, act_1_23_0, act_1_23_1, act_1_23_4, act_1_23_5, act_1_23_6, act_1_23_7 : lut_output_t_1;
  signal act_1_23_8, act_1_23_9, act_1_24_0, act_1_24_1, act_1_24_2, act_1_24_3, act_1_24_4, act_1_24_5, act_1_24_6, act_1_24_7, act_1_24_8, act_1_25_0, act_1_25_1, act_1_25_2, act_1_25_3, act_1_25_4 : lut_output_t_1;
  signal act_1_25_5, act_1_25_6, act_1_25_7, act_1_25_8, act_1_25_9, act_1_26_0, act_1_26_1, act_1_26_3, act_1_26_4, act_1_26_5, act_1_26_6, act_1_26_8, act_1_26_9, act_1_27_0, act_1_27_1, act_1_27_2 : lut_output_t_1;
  signal act_1_27_3, act_1_27_4, act_1_27_6, act_1_27_8, act_1_28_0, act_1_28_1, act_1_28_2, act_1_28_3, act_1_28_4, act_1_28_5, act_1_28_7, act_1_28_8, act_1_28_9, act_1_29_1, act_1_29_2, act_1_29_3 : lut_output_t_1;
  signal act_1_29_4, act_1_29_5, act_1_29_6, act_1_29_7, act_1_29_8, act_1_29_9, act_1_30_0, act_1_30_1, act_1_30_2, act_1_30_3, act_1_30_4, act_1_30_5, act_1_30_6, act_1_30_7, act_1_30_8, act_1_30_9 : lut_output_t_1;
  signal act_1_31_0, act_1_31_1, act_1_31_2, act_1_31_3, act_1_31_4, act_1_31_5, act_1_31_6, act_1_31_7, act_1_31_8, act_1_31_9 : lut_output_t_1;
begin

  -- === auto: layer blocks ===
  -- LAYER 0, ch 0
  gen_l0c0 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_0;
  signal s2_0, s2_1, s2_2 : sum_t_0_0;
  signal sum_0_0 : sum_t_0_0;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_0.mem") port map (clk, input(1), act_0_1_0);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_0.mem") port map (clk, input(2), act_0_2_0);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_0.mem") port map (clk, input(3), act_0_3_0);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_0.mem") port map (clk, input(4), act_0_4_0);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_0.mem") port map (clk, input(6), act_0_6_0);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_0.mem") port map (clk, input(7), act_0_7_0);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_0.mem") port map (clk, input(8), act_0_8_0);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_0.mem") port map (clk, input(9), act_0_9_0);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_0.mem") port map (clk, input(10), act_0_10_0);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_0.mem") port map (clk, input(12), act_0_12_0);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_0.mem") port map (clk, input(13), act_0_13_0);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_0.mem") port map (clk, input(14), act_0_14_0);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_0.mem") port map (clk, input(15), act_0_15_0);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_0.mem") port map (clk, input(16), act_0_16_0);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_0.mem") port map (clk, input(17), act_0_17_0);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_0.mem") port map (clk, input(18), act_0_18_0);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_0.mem") port map (clk, input(19), act_0_19_0);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_0.mem") port map (clk, input(22), act_0_22_0);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_0.mem") port map (clk, input(23), act_0_23_0);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_0.mem") port map (clk, input(24), act_0_24_0);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_0.mem") port map (clk, input(27), act_0_27_0);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_0.mem") port map (clk, input(30), act_0_30_0);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_0.mem") port map (clk, input(31), act_0_31_0);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_0.mem") port map (clk, input(32), act_0_32_0);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_0.mem") port map (clk, input(33), act_0_33_0);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_0.mem") port map (clk, input(34), act_0_34_0);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_0.mem") port map (clk, input(35), act_0_35_0);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_0.mem") port map (clk, input(36), act_0_36_0);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_0.mem") port map (clk, input(37), act_0_37_0);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_0.mem") port map (clk, input(38), act_0_38_0);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_0.mem") port map (clk, input(39), act_0_39_0);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_0.mem") port map (clk, input(41), act_0_41_0);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_0.mem") port map (clk, input(43), act_0_43_0);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_0.mem") port map (clk, input(44), act_0_44_0);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_0.mem") port map (clk, input(45), act_0_45_0);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_0.mem") port map (clk, input(46), act_0_46_0);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_0.mem") port map (clk, input(47), act_0_47_0);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_0.mem") port map (clk, input(48), act_0_48_0);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_0.mem") port map (clk, input(49), act_0_49_0);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_0, SUM_WIDTH_0_0) + resize(act_0_2_0, SUM_WIDTH_0_0) + resize(act_0_3_0, SUM_WIDTH_0_0) + resize(act_0_4_0, SUM_WIDTH_0_0);
        s1_1 <= resize(act_0_6_0, SUM_WIDTH_0_0) + resize(act_0_7_0, SUM_WIDTH_0_0) + resize(act_0_8_0, SUM_WIDTH_0_0) + resize(act_0_9_0, SUM_WIDTH_0_0);
        s1_2 <= resize(act_0_10_0, SUM_WIDTH_0_0) + resize(act_0_12_0, SUM_WIDTH_0_0) + resize(act_0_13_0, SUM_WIDTH_0_0) + resize(act_0_14_0, SUM_WIDTH_0_0);
        s1_3 <= resize(act_0_15_0, SUM_WIDTH_0_0) + resize(act_0_16_0, SUM_WIDTH_0_0) + resize(act_0_17_0, SUM_WIDTH_0_0) + resize(act_0_18_0, SUM_WIDTH_0_0);
        s1_4 <= resize(act_0_19_0, SUM_WIDTH_0_0) + resize(act_0_22_0, SUM_WIDTH_0_0) + resize(act_0_23_0, SUM_WIDTH_0_0) + resize(act_0_24_0, SUM_WIDTH_0_0);
        s1_5 <= resize(act_0_27_0, SUM_WIDTH_0_0) + resize(act_0_30_0, SUM_WIDTH_0_0) + resize(act_0_31_0, SUM_WIDTH_0_0) + resize(act_0_32_0, SUM_WIDTH_0_0);
        s1_6 <= resize(act_0_33_0, SUM_WIDTH_0_0) + resize(act_0_34_0, SUM_WIDTH_0_0) + resize(act_0_35_0, SUM_WIDTH_0_0) + resize(act_0_36_0, SUM_WIDTH_0_0);
        s1_7 <= resize(act_0_37_0, SUM_WIDTH_0_0) + resize(act_0_38_0, SUM_WIDTH_0_0) + resize(act_0_39_0, SUM_WIDTH_0_0) + resize(act_0_41_0, SUM_WIDTH_0_0);
        s1_8 <= resize(act_0_43_0, SUM_WIDTH_0_0) + resize(act_0_44_0, SUM_WIDTH_0_0) + resize(act_0_45_0, SUM_WIDTH_0_0) + resize(act_0_46_0, SUM_WIDTH_0_0);
        s1_9 <= resize(act_0_47_0, SUM_WIDTH_0_0) + resize(act_0_48_0, SUM_WIDTH_0_0) + resize(act_0_49_0, SUM_WIDTH_0_0);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_0 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_0 <= saturate(sum_0_0, 16);
  end block;

  -- LAYER 0, ch 1
  gen_l0c1 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8 : sum_t_0_1;
  signal s2_0, s2_1, s2_2 : sum_t_0_1;
  signal sum_0_1 : sum_t_0_1;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_1.mem") port map (clk, input(1), act_0_1_1);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_1.mem") port map (clk, input(2), act_0_2_1);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_1.mem") port map (clk, input(4), act_0_4_1);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_1.mem") port map (clk, input(6), act_0_6_1);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_1.mem") port map (clk, input(7), act_0_7_1);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_1.mem") port map (clk, input(8), act_0_8_1);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_1.mem") port map (clk, input(9), act_0_9_1);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_1.mem") port map (clk, input(10), act_0_10_1);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_1.mem") port map (clk, input(11), act_0_11_1);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_1.mem") port map (clk, input(12), act_0_12_1);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_1.mem") port map (clk, input(13), act_0_13_1);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_1.mem") port map (clk, input(14), act_0_14_1);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_1.mem") port map (clk, input(15), act_0_15_1);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_1.mem") port map (clk, input(18), act_0_18_1);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_1.mem") port map (clk, input(19), act_0_19_1);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_1.mem") port map (clk, input(20), act_0_20_1);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_1.mem") port map (clk, input(21), act_0_21_1);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_1.mem") port map (clk, input(22), act_0_22_1);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_1.mem") port map (clk, input(23), act_0_23_1);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_1.mem") port map (clk, input(24), act_0_24_1);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_1.mem") port map (clk, input(26), act_0_26_1);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_1.mem") port map (clk, input(28), act_0_28_1);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_1.mem") port map (clk, input(29), act_0_29_1);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_1.mem") port map (clk, input(32), act_0_32_1);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_1.mem") port map (clk, input(33), act_0_33_1);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_1.mem") port map (clk, input(34), act_0_34_1);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_1.mem") port map (clk, input(37), act_0_37_1);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_1.mem") port map (clk, input(39), act_0_39_1);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_1.mem") port map (clk, input(40), act_0_40_1);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_1.mem") port map (clk, input(42), act_0_42_1);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_1.mem") port map (clk, input(43), act_0_43_1);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_1.mem") port map (clk, input(44), act_0_44_1);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_1.mem") port map (clk, input(46), act_0_46_1);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_1.mem") port map (clk, input(47), act_0_47_1);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_1.mem") port map (clk, input(48), act_0_48_1);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_1.mem") port map (clk, input(49), act_0_49_1);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_1, SUM_WIDTH_0_1) + resize(act_0_2_1, SUM_WIDTH_0_1) + resize(act_0_4_1, SUM_WIDTH_0_1) + resize(act_0_6_1, SUM_WIDTH_0_1);
        s1_1 <= resize(act_0_7_1, SUM_WIDTH_0_1) + resize(act_0_8_1, SUM_WIDTH_0_1) + resize(act_0_9_1, SUM_WIDTH_0_1) + resize(act_0_10_1, SUM_WIDTH_0_1);
        s1_2 <= resize(act_0_11_1, SUM_WIDTH_0_1) + resize(act_0_12_1, SUM_WIDTH_0_1) + resize(act_0_13_1, SUM_WIDTH_0_1) + resize(act_0_14_1, SUM_WIDTH_0_1);
        s1_3 <= resize(act_0_15_1, SUM_WIDTH_0_1) + resize(act_0_18_1, SUM_WIDTH_0_1) + resize(act_0_19_1, SUM_WIDTH_0_1) + resize(act_0_20_1, SUM_WIDTH_0_1);
        s1_4 <= resize(act_0_21_1, SUM_WIDTH_0_1) + resize(act_0_22_1, SUM_WIDTH_0_1) + resize(act_0_23_1, SUM_WIDTH_0_1) + resize(act_0_24_1, SUM_WIDTH_0_1);
        s1_5 <= resize(act_0_26_1, SUM_WIDTH_0_1) + resize(act_0_28_1, SUM_WIDTH_0_1) + resize(act_0_29_1, SUM_WIDTH_0_1) + resize(act_0_32_1, SUM_WIDTH_0_1);
        s1_6 <= resize(act_0_33_1, SUM_WIDTH_0_1) + resize(act_0_34_1, SUM_WIDTH_0_1) + resize(act_0_37_1, SUM_WIDTH_0_1) + resize(act_0_39_1, SUM_WIDTH_0_1);
        s1_7 <= resize(act_0_40_1, SUM_WIDTH_0_1) + resize(act_0_42_1, SUM_WIDTH_0_1) + resize(act_0_43_1, SUM_WIDTH_0_1) + resize(act_0_44_1, SUM_WIDTH_0_1);
        s1_8 <= resize(act_0_46_1, SUM_WIDTH_0_1) + resize(act_0_47_1, SUM_WIDTH_0_1) + resize(act_0_48_1, SUM_WIDTH_0_1) + resize(act_0_49_1, SUM_WIDTH_0_1);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8;
        -- Stage 3
        sum_0_1 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_1 <= saturate(sum_0_1, 16);
  end block;

  -- LAYER 0, ch 2
  gen_l0c2 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_2;
  signal s2_0, s2_1, s2_2 : sum_t_0_2;
  signal sum_0_2 : sum_t_0_2;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_2.mem") port map (clk, input(2), act_0_2_2);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_2.mem") port map (clk, input(3), act_0_3_2);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_2.mem") port map (clk, input(4), act_0_4_2);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_2.mem") port map (clk, input(6), act_0_6_2);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_2.mem") port map (clk, input(7), act_0_7_2);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_2.mem") port map (clk, input(8), act_0_8_2);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_2.mem") port map (clk, input(9), act_0_9_2);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_2.mem") port map (clk, input(10), act_0_10_2);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_2.mem") port map (clk, input(11), act_0_11_2);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_2.mem") port map (clk, input(12), act_0_12_2);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_2.mem") port map (clk, input(13), act_0_13_2);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_2.mem") port map (clk, input(14), act_0_14_2);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_2.mem") port map (clk, input(15), act_0_15_2);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_2.mem") port map (clk, input(16), act_0_16_2);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_2.mem") port map (clk, input(17), act_0_17_2);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_2.mem") port map (clk, input(18), act_0_18_2);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_2.mem") port map (clk, input(19), act_0_19_2);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_2.mem") port map (clk, input(20), act_0_20_2);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_2.mem") port map (clk, input(21), act_0_21_2);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_2.mem") port map (clk, input(22), act_0_22_2);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_2.mem") port map (clk, input(23), act_0_23_2);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_2.mem") port map (clk, input(24), act_0_24_2);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_2.mem") port map (clk, input(26), act_0_26_2);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_2.mem") port map (clk, input(27), act_0_27_2);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_2.mem") port map (clk, input(28), act_0_28_2);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_2.mem") port map (clk, input(29), act_0_29_2);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_2.mem") port map (clk, input(30), act_0_30_2);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_2.mem") port map (clk, input(32), act_0_32_2);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_2.mem") port map (clk, input(33), act_0_33_2);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_2.mem") port map (clk, input(34), act_0_34_2);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_2.mem") port map (clk, input(35), act_0_35_2);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_2.mem") port map (clk, input(36), act_0_36_2);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_2.mem") port map (clk, input(37), act_0_37_2);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_2.mem") port map (clk, input(39), act_0_39_2);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_2.mem") port map (clk, input(40), act_0_40_2);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_2.mem") port map (clk, input(41), act_0_41_2);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_2.mem") port map (clk, input(42), act_0_42_2);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_2.mem") port map (clk, input(43), act_0_43_2);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_2.mem") port map (clk, input(44), act_0_44_2);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_2.mem") port map (clk, input(45), act_0_45_2);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_2.mem") port map (clk, input(46), act_0_46_2);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_2.mem") port map (clk, input(47), act_0_47_2);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_2.mem") port map (clk, input(48), act_0_48_2);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_2.mem") port map (clk, input(49), act_0_49_2);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_2_2, SUM_WIDTH_0_2) + resize(act_0_3_2, SUM_WIDTH_0_2) + resize(act_0_4_2, SUM_WIDTH_0_2) + resize(act_0_6_2, SUM_WIDTH_0_2);
        s1_1 <= resize(act_0_7_2, SUM_WIDTH_0_2) + resize(act_0_8_2, SUM_WIDTH_0_2) + resize(act_0_9_2, SUM_WIDTH_0_2) + resize(act_0_10_2, SUM_WIDTH_0_2);
        s1_2 <= resize(act_0_11_2, SUM_WIDTH_0_2) + resize(act_0_12_2, SUM_WIDTH_0_2) + resize(act_0_13_2, SUM_WIDTH_0_2) + resize(act_0_14_2, SUM_WIDTH_0_2);
        s1_3 <= resize(act_0_15_2, SUM_WIDTH_0_2) + resize(act_0_16_2, SUM_WIDTH_0_2) + resize(act_0_17_2, SUM_WIDTH_0_2) + resize(act_0_18_2, SUM_WIDTH_0_2);
        s1_4 <= resize(act_0_19_2, SUM_WIDTH_0_2) + resize(act_0_20_2, SUM_WIDTH_0_2) + resize(act_0_21_2, SUM_WIDTH_0_2) + resize(act_0_22_2, SUM_WIDTH_0_2);
        s1_5 <= resize(act_0_23_2, SUM_WIDTH_0_2) + resize(act_0_24_2, SUM_WIDTH_0_2) + resize(act_0_26_2, SUM_WIDTH_0_2) + resize(act_0_27_2, SUM_WIDTH_0_2);
        s1_6 <= resize(act_0_28_2, SUM_WIDTH_0_2) + resize(act_0_29_2, SUM_WIDTH_0_2) + resize(act_0_30_2, SUM_WIDTH_0_2) + resize(act_0_32_2, SUM_WIDTH_0_2);
        s1_7 <= resize(act_0_33_2, SUM_WIDTH_0_2) + resize(act_0_34_2, SUM_WIDTH_0_2) + resize(act_0_35_2, SUM_WIDTH_0_2) + resize(act_0_36_2, SUM_WIDTH_0_2);
        s1_8 <= resize(act_0_37_2, SUM_WIDTH_0_2) + resize(act_0_39_2, SUM_WIDTH_0_2) + resize(act_0_40_2, SUM_WIDTH_0_2) + resize(act_0_41_2, SUM_WIDTH_0_2);
        s1_9 <= resize(act_0_42_2, SUM_WIDTH_0_2) + resize(act_0_43_2, SUM_WIDTH_0_2) + resize(act_0_44_2, SUM_WIDTH_0_2) + resize(act_0_45_2, SUM_WIDTH_0_2);
        s1_10 <= resize(act_0_46_2, SUM_WIDTH_0_2) + resize(act_0_47_2, SUM_WIDTH_0_2) + resize(act_0_48_2, SUM_WIDTH_0_2) + resize(act_0_49_2, SUM_WIDTH_0_2);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_2 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_2 <= saturate(sum_0_2, 16);
  end block;

  -- LAYER 0, ch 3
  gen_l0c3 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_3;
  signal s2_0, s2_1, s2_2 : sum_t_0_3;
  signal sum_0_3 : sum_t_0_3;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_3.mem") port map (clk, input(0), act_0_0_3);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_3.mem") port map (clk, input(1), act_0_1_3);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_3.mem") port map (clk, input(2), act_0_2_3);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_3.mem") port map (clk, input(3), act_0_3_3);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_3.mem") port map (clk, input(4), act_0_4_3);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_3.mem") port map (clk, input(5), act_0_5_3);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_3.mem") port map (clk, input(6), act_0_6_3);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_3.mem") port map (clk, input(7), act_0_7_3);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_3.mem") port map (clk, input(8), act_0_8_3);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_3.mem") port map (clk, input(9), act_0_9_3);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_3.mem") port map (clk, input(10), act_0_10_3);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_3.mem") port map (clk, input(11), act_0_11_3);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_3.mem") port map (clk, input(12), act_0_12_3);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_3.mem") port map (clk, input(14), act_0_14_3);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_3.mem") port map (clk, input(15), act_0_15_3);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_3.mem") port map (clk, input(16), act_0_16_3);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_3.mem") port map (clk, input(17), act_0_17_3);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_3.mem") port map (clk, input(18), act_0_18_3);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_3.mem") port map (clk, input(19), act_0_19_3);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_3.mem") port map (clk, input(21), act_0_21_3);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_3.mem") port map (clk, input(22), act_0_22_3);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_3.mem") port map (clk, input(23), act_0_23_3);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_3.mem") port map (clk, input(24), act_0_24_3);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_3.mem") port map (clk, input(27), act_0_27_3);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_3.mem") port map (clk, input(30), act_0_30_3);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_3.mem") port map (clk, input(31), act_0_31_3);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_3.mem") port map (clk, input(32), act_0_32_3);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_3.mem") port map (clk, input(34), act_0_34_3);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_3.mem") port map (clk, input(35), act_0_35_3);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_3.mem") port map (clk, input(36), act_0_36_3);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_3.mem") port map (clk, input(37), act_0_37_3);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_3.mem") port map (clk, input(38), act_0_38_3);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_3.mem") port map (clk, input(39), act_0_39_3);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_3.mem") port map (clk, input(40), act_0_40_3);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_3.mem") port map (clk, input(41), act_0_41_3);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_3.mem") port map (clk, input(42), act_0_42_3);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_3.mem") port map (clk, input(43), act_0_43_3);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_3.mem") port map (clk, input(45), act_0_45_3);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_3.mem") port map (clk, input(46), act_0_46_3);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_3.mem") port map (clk, input(47), act_0_47_3);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_3.mem") port map (clk, input(48), act_0_48_3);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_3.mem") port map (clk, input(49), act_0_49_3);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_3, SUM_WIDTH_0_3) + resize(act_0_1_3, SUM_WIDTH_0_3) + resize(act_0_2_3, SUM_WIDTH_0_3) + resize(act_0_3_3, SUM_WIDTH_0_3);
        s1_1 <= resize(act_0_4_3, SUM_WIDTH_0_3) + resize(act_0_5_3, SUM_WIDTH_0_3) + resize(act_0_6_3, SUM_WIDTH_0_3) + resize(act_0_7_3, SUM_WIDTH_0_3);
        s1_2 <= resize(act_0_8_3, SUM_WIDTH_0_3) + resize(act_0_9_3, SUM_WIDTH_0_3) + resize(act_0_10_3, SUM_WIDTH_0_3) + resize(act_0_11_3, SUM_WIDTH_0_3);
        s1_3 <= resize(act_0_12_3, SUM_WIDTH_0_3) + resize(act_0_14_3, SUM_WIDTH_0_3) + resize(act_0_15_3, SUM_WIDTH_0_3) + resize(act_0_16_3, SUM_WIDTH_0_3);
        s1_4 <= resize(act_0_17_3, SUM_WIDTH_0_3) + resize(act_0_18_3, SUM_WIDTH_0_3) + resize(act_0_19_3, SUM_WIDTH_0_3) + resize(act_0_21_3, SUM_WIDTH_0_3);
        s1_5 <= resize(act_0_22_3, SUM_WIDTH_0_3) + resize(act_0_23_3, SUM_WIDTH_0_3) + resize(act_0_24_3, SUM_WIDTH_0_3) + resize(act_0_27_3, SUM_WIDTH_0_3);
        s1_6 <= resize(act_0_30_3, SUM_WIDTH_0_3) + resize(act_0_31_3, SUM_WIDTH_0_3) + resize(act_0_32_3, SUM_WIDTH_0_3) + resize(act_0_34_3, SUM_WIDTH_0_3);
        s1_7 <= resize(act_0_35_3, SUM_WIDTH_0_3) + resize(act_0_36_3, SUM_WIDTH_0_3) + resize(act_0_37_3, SUM_WIDTH_0_3) + resize(act_0_38_3, SUM_WIDTH_0_3);
        s1_8 <= resize(act_0_39_3, SUM_WIDTH_0_3) + resize(act_0_40_3, SUM_WIDTH_0_3) + resize(act_0_41_3, SUM_WIDTH_0_3) + resize(act_0_42_3, SUM_WIDTH_0_3);
        s1_9 <= resize(act_0_43_3, SUM_WIDTH_0_3) + resize(act_0_45_3, SUM_WIDTH_0_3) + resize(act_0_46_3, SUM_WIDTH_0_3) + resize(act_0_47_3, SUM_WIDTH_0_3);
        s1_10 <= resize(act_0_48_3, SUM_WIDTH_0_3) + resize(act_0_49_3, SUM_WIDTH_0_3);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_3 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_3 <= saturate(sum_0_3, 16);
  end block;

  -- LAYER 0, ch 4
  gen_l0c4 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_4;
  signal s2_0, s2_1, s2_2 : sum_t_0_4;
  signal sum_0_4 : sum_t_0_4;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_4.mem") port map (clk, input(0), act_0_0_4);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_4.mem") port map (clk, input(3), act_0_3_4);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_4.mem") port map (clk, input(4), act_0_4_4);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_4.mem") port map (clk, input(6), act_0_6_4);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_4.mem") port map (clk, input(7), act_0_7_4);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_4.mem") port map (clk, input(8), act_0_8_4);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_4.mem") port map (clk, input(10), act_0_10_4);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_4.mem") port map (clk, input(11), act_0_11_4);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_4.mem") port map (clk, input(12), act_0_12_4);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_4.mem") port map (clk, input(14), act_0_14_4);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_4.mem") port map (clk, input(16), act_0_16_4);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_4.mem") port map (clk, input(17), act_0_17_4);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_4.mem") port map (clk, input(18), act_0_18_4);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_4.mem") port map (clk, input(19), act_0_19_4);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_4.mem") port map (clk, input(20), act_0_20_4);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_4.mem") port map (clk, input(21), act_0_21_4);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_4.mem") port map (clk, input(22), act_0_22_4);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_4.mem") port map (clk, input(23), act_0_23_4);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_4.mem") port map (clk, input(24), act_0_24_4);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_4.mem") port map (clk, input(25), act_0_25_4);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_4.mem") port map (clk, input(26), act_0_26_4);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_4.mem") port map (clk, input(27), act_0_27_4);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_4.mem") port map (clk, input(28), act_0_28_4);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_4.mem") port map (clk, input(29), act_0_29_4);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_4.mem") port map (clk, input(31), act_0_31_4);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_4.mem") port map (clk, input(32), act_0_32_4);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_4.mem") port map (clk, input(34), act_0_34_4);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_4.mem") port map (clk, input(35), act_0_35_4);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_4.mem") port map (clk, input(36), act_0_36_4);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_4.mem") port map (clk, input(37), act_0_37_4);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_4.mem") port map (clk, input(38), act_0_38_4);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_4.mem") port map (clk, input(39), act_0_39_4);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_4.mem") port map (clk, input(40), act_0_40_4);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_4.mem") port map (clk, input(42), act_0_42_4);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_4.mem") port map (clk, input(43), act_0_43_4);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_4.mem") port map (clk, input(44), act_0_44_4);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_4.mem") port map (clk, input(45), act_0_45_4);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_4.mem") port map (clk, input(46), act_0_46_4);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_4.mem") port map (clk, input(47), act_0_47_4);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_4.mem") port map (clk, input(48), act_0_48_4);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_4.mem") port map (clk, input(49), act_0_49_4);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_4, SUM_WIDTH_0_4) + resize(act_0_3_4, SUM_WIDTH_0_4) + resize(act_0_4_4, SUM_WIDTH_0_4) + resize(act_0_6_4, SUM_WIDTH_0_4);
        s1_1 <= resize(act_0_7_4, SUM_WIDTH_0_4) + resize(act_0_8_4, SUM_WIDTH_0_4) + resize(act_0_10_4, SUM_WIDTH_0_4) + resize(act_0_11_4, SUM_WIDTH_0_4);
        s1_2 <= resize(act_0_12_4, SUM_WIDTH_0_4) + resize(act_0_14_4, SUM_WIDTH_0_4) + resize(act_0_16_4, SUM_WIDTH_0_4) + resize(act_0_17_4, SUM_WIDTH_0_4);
        s1_3 <= resize(act_0_18_4, SUM_WIDTH_0_4) + resize(act_0_19_4, SUM_WIDTH_0_4) + resize(act_0_20_4, SUM_WIDTH_0_4) + resize(act_0_21_4, SUM_WIDTH_0_4);
        s1_4 <= resize(act_0_22_4, SUM_WIDTH_0_4) + resize(act_0_23_4, SUM_WIDTH_0_4) + resize(act_0_24_4, SUM_WIDTH_0_4) + resize(act_0_25_4, SUM_WIDTH_0_4);
        s1_5 <= resize(act_0_26_4, SUM_WIDTH_0_4) + resize(act_0_27_4, SUM_WIDTH_0_4) + resize(act_0_28_4, SUM_WIDTH_0_4) + resize(act_0_29_4, SUM_WIDTH_0_4);
        s1_6 <= resize(act_0_31_4, SUM_WIDTH_0_4) + resize(act_0_32_4, SUM_WIDTH_0_4) + resize(act_0_34_4, SUM_WIDTH_0_4) + resize(act_0_35_4, SUM_WIDTH_0_4);
        s1_7 <= resize(act_0_36_4, SUM_WIDTH_0_4) + resize(act_0_37_4, SUM_WIDTH_0_4) + resize(act_0_38_4, SUM_WIDTH_0_4) + resize(act_0_39_4, SUM_WIDTH_0_4);
        s1_8 <= resize(act_0_40_4, SUM_WIDTH_0_4) + resize(act_0_42_4, SUM_WIDTH_0_4) + resize(act_0_43_4, SUM_WIDTH_0_4) + resize(act_0_44_4, SUM_WIDTH_0_4);
        s1_9 <= resize(act_0_45_4, SUM_WIDTH_0_4) + resize(act_0_46_4, SUM_WIDTH_0_4) + resize(act_0_47_4, SUM_WIDTH_0_4) + resize(act_0_48_4, SUM_WIDTH_0_4);
        s1_10 <= resize(act_0_49_4, SUM_WIDTH_0_4);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_4 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_4 <= saturate(sum_0_4, 16);
  end block;

  -- LAYER 0, ch 5
  gen_l0c5 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_5;
  signal s2_0, s2_1, s2_2 : sum_t_0_5;
  signal sum_0_5 : sum_t_0_5;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_5.mem") port map (clk, input(1), act_0_1_5);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_5.mem") port map (clk, input(2), act_0_2_5);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_5.mem") port map (clk, input(3), act_0_3_5);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_5.mem") port map (clk, input(4), act_0_4_5);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_5.mem") port map (clk, input(5), act_0_5_5);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_5.mem") port map (clk, input(6), act_0_6_5);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_5.mem") port map (clk, input(7), act_0_7_5);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_5.mem") port map (clk, input(8), act_0_8_5);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_5.mem") port map (clk, input(9), act_0_9_5);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_5.mem") port map (clk, input(10), act_0_10_5);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_5.mem") port map (clk, input(11), act_0_11_5);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_5.mem") port map (clk, input(12), act_0_12_5);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_5.mem") port map (clk, input(13), act_0_13_5);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_5.mem") port map (clk, input(14), act_0_14_5);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_5.mem") port map (clk, input(15), act_0_15_5);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_5.mem") port map (clk, input(16), act_0_16_5);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_5.mem") port map (clk, input(17), act_0_17_5);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_5.mem") port map (clk, input(18), act_0_18_5);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_5.mem") port map (clk, input(19), act_0_19_5);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_5.mem") port map (clk, input(20), act_0_20_5);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_5.mem") port map (clk, input(21), act_0_21_5);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_5.mem") port map (clk, input(23), act_0_23_5);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_5.mem") port map (clk, input(25), act_0_25_5);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_5.mem") port map (clk, input(27), act_0_27_5);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_5.mem") port map (clk, input(28), act_0_28_5);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_5.mem") port map (clk, input(29), act_0_29_5);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_5.mem") port map (clk, input(30), act_0_30_5);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_5.mem") port map (clk, input(31), act_0_31_5);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_5.mem") port map (clk, input(33), act_0_33_5);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_5.mem") port map (clk, input(34), act_0_34_5);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_5.mem") port map (clk, input(35), act_0_35_5);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_5.mem") port map (clk, input(36), act_0_36_5);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_5.mem") port map (clk, input(37), act_0_37_5);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_5.mem") port map (clk, input(38), act_0_38_5);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_5.mem") port map (clk, input(39), act_0_39_5);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_5.mem") port map (clk, input(40), act_0_40_5);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_5.mem") port map (clk, input(41), act_0_41_5);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_5.mem") port map (clk, input(42), act_0_42_5);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_5.mem") port map (clk, input(43), act_0_43_5);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_5.mem") port map (clk, input(44), act_0_44_5);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_5.mem") port map (clk, input(45), act_0_45_5);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_5.mem") port map (clk, input(47), act_0_47_5);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_5.mem") port map (clk, input(48), act_0_48_5);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_5, SUM_WIDTH_0_5) + resize(act_0_2_5, SUM_WIDTH_0_5) + resize(act_0_3_5, SUM_WIDTH_0_5) + resize(act_0_4_5, SUM_WIDTH_0_5);
        s1_1 <= resize(act_0_5_5, SUM_WIDTH_0_5) + resize(act_0_6_5, SUM_WIDTH_0_5) + resize(act_0_7_5, SUM_WIDTH_0_5) + resize(act_0_8_5, SUM_WIDTH_0_5);
        s1_2 <= resize(act_0_9_5, SUM_WIDTH_0_5) + resize(act_0_10_5, SUM_WIDTH_0_5) + resize(act_0_11_5, SUM_WIDTH_0_5) + resize(act_0_12_5, SUM_WIDTH_0_5);
        s1_3 <= resize(act_0_13_5, SUM_WIDTH_0_5) + resize(act_0_14_5, SUM_WIDTH_0_5) + resize(act_0_15_5, SUM_WIDTH_0_5) + resize(act_0_16_5, SUM_WIDTH_0_5);
        s1_4 <= resize(act_0_17_5, SUM_WIDTH_0_5) + resize(act_0_18_5, SUM_WIDTH_0_5) + resize(act_0_19_5, SUM_WIDTH_0_5) + resize(act_0_20_5, SUM_WIDTH_0_5);
        s1_5 <= resize(act_0_21_5, SUM_WIDTH_0_5) + resize(act_0_23_5, SUM_WIDTH_0_5) + resize(act_0_25_5, SUM_WIDTH_0_5) + resize(act_0_27_5, SUM_WIDTH_0_5);
        s1_6 <= resize(act_0_28_5, SUM_WIDTH_0_5) + resize(act_0_29_5, SUM_WIDTH_0_5) + resize(act_0_30_5, SUM_WIDTH_0_5) + resize(act_0_31_5, SUM_WIDTH_0_5);
        s1_7 <= resize(act_0_33_5, SUM_WIDTH_0_5) + resize(act_0_34_5, SUM_WIDTH_0_5) + resize(act_0_35_5, SUM_WIDTH_0_5) + resize(act_0_36_5, SUM_WIDTH_0_5);
        s1_8 <= resize(act_0_37_5, SUM_WIDTH_0_5) + resize(act_0_38_5, SUM_WIDTH_0_5) + resize(act_0_39_5, SUM_WIDTH_0_5) + resize(act_0_40_5, SUM_WIDTH_0_5);
        s1_9 <= resize(act_0_41_5, SUM_WIDTH_0_5) + resize(act_0_42_5, SUM_WIDTH_0_5) + resize(act_0_43_5, SUM_WIDTH_0_5) + resize(act_0_44_5, SUM_WIDTH_0_5);
        s1_10 <= resize(act_0_45_5, SUM_WIDTH_0_5) + resize(act_0_47_5, SUM_WIDTH_0_5) + resize(act_0_48_5, SUM_WIDTH_0_5);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_5 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_5 <= saturate(sum_0_5, 16);
  end block;

  -- LAYER 0, ch 6
  gen_l0c6 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_6;
  signal s2_0, s2_1, s2_2 : sum_t_0_6;
  signal sum_0_6 : sum_t_0_6;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_6.mem") port map (clk, input(1), act_0_1_6);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_6.mem") port map (clk, input(2), act_0_2_6);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_6.mem") port map (clk, input(3), act_0_3_6);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_6.mem") port map (clk, input(5), act_0_5_6);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_6.mem") port map (clk, input(6), act_0_6_6);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_6.mem") port map (clk, input(7), act_0_7_6);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_6.mem") port map (clk, input(8), act_0_8_6);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_6.mem") port map (clk, input(9), act_0_9_6);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_6.mem") port map (clk, input(10), act_0_10_6);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_6.mem") port map (clk, input(12), act_0_12_6);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_6.mem") port map (clk, input(13), act_0_13_6);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_6.mem") port map (clk, input(14), act_0_14_6);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_6.mem") port map (clk, input(15), act_0_15_6);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_6.mem") port map (clk, input(16), act_0_16_6);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_6.mem") port map (clk, input(18), act_0_18_6);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_6.mem") port map (clk, input(19), act_0_19_6);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_6.mem") port map (clk, input(20), act_0_20_6);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_6.mem") port map (clk, input(21), act_0_21_6);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_6.mem") port map (clk, input(22), act_0_22_6);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_6.mem") port map (clk, input(23), act_0_23_6);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_6.mem") port map (clk, input(24), act_0_24_6);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_6.mem") port map (clk, input(27), act_0_27_6);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_6.mem") port map (clk, input(28), act_0_28_6);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_6.mem") port map (clk, input(31), act_0_31_6);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_6.mem") port map (clk, input(33), act_0_33_6);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_6.mem") port map (clk, input(34), act_0_34_6);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_6.mem") port map (clk, input(36), act_0_36_6);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_6.mem") port map (clk, input(37), act_0_37_6);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_6.mem") port map (clk, input(38), act_0_38_6);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_6.mem") port map (clk, input(39), act_0_39_6);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_6.mem") port map (clk, input(40), act_0_40_6);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_6.mem") port map (clk, input(41), act_0_41_6);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_6.mem") port map (clk, input(42), act_0_42_6);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_6.mem") port map (clk, input(43), act_0_43_6);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_6.mem") port map (clk, input(44), act_0_44_6);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_6.mem") port map (clk, input(45), act_0_45_6);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_6.mem") port map (clk, input(46), act_0_46_6);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_6.mem") port map (clk, input(47), act_0_47_6);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_6.mem") port map (clk, input(48), act_0_48_6);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_6, SUM_WIDTH_0_6) + resize(act_0_2_6, SUM_WIDTH_0_6) + resize(act_0_3_6, SUM_WIDTH_0_6) + resize(act_0_5_6, SUM_WIDTH_0_6);
        s1_1 <= resize(act_0_6_6, SUM_WIDTH_0_6) + resize(act_0_7_6, SUM_WIDTH_0_6) + resize(act_0_8_6, SUM_WIDTH_0_6) + resize(act_0_9_6, SUM_WIDTH_0_6);
        s1_2 <= resize(act_0_10_6, SUM_WIDTH_0_6) + resize(act_0_12_6, SUM_WIDTH_0_6) + resize(act_0_13_6, SUM_WIDTH_0_6) + resize(act_0_14_6, SUM_WIDTH_0_6);
        s1_3 <= resize(act_0_15_6, SUM_WIDTH_0_6) + resize(act_0_16_6, SUM_WIDTH_0_6) + resize(act_0_18_6, SUM_WIDTH_0_6) + resize(act_0_19_6, SUM_WIDTH_0_6);
        s1_4 <= resize(act_0_20_6, SUM_WIDTH_0_6) + resize(act_0_21_6, SUM_WIDTH_0_6) + resize(act_0_22_6, SUM_WIDTH_0_6) + resize(act_0_23_6, SUM_WIDTH_0_6);
        s1_5 <= resize(act_0_24_6, SUM_WIDTH_0_6) + resize(act_0_27_6, SUM_WIDTH_0_6) + resize(act_0_28_6, SUM_WIDTH_0_6) + resize(act_0_31_6, SUM_WIDTH_0_6);
        s1_6 <= resize(act_0_33_6, SUM_WIDTH_0_6) + resize(act_0_34_6, SUM_WIDTH_0_6) + resize(act_0_36_6, SUM_WIDTH_0_6) + resize(act_0_37_6, SUM_WIDTH_0_6);
        s1_7 <= resize(act_0_38_6, SUM_WIDTH_0_6) + resize(act_0_39_6, SUM_WIDTH_0_6) + resize(act_0_40_6, SUM_WIDTH_0_6) + resize(act_0_41_6, SUM_WIDTH_0_6);
        s1_8 <= resize(act_0_42_6, SUM_WIDTH_0_6) + resize(act_0_43_6, SUM_WIDTH_0_6) + resize(act_0_44_6, SUM_WIDTH_0_6) + resize(act_0_45_6, SUM_WIDTH_0_6);
        s1_9 <= resize(act_0_46_6, SUM_WIDTH_0_6) + resize(act_0_47_6, SUM_WIDTH_0_6) + resize(act_0_48_6, SUM_WIDTH_0_6);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_6 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_6 <= saturate(sum_0_6, 16);
  end block;

  -- LAYER 0, ch 7
  gen_l0c7 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_7;
  signal s2_0, s2_1, s2_2 : sum_t_0_7;
  signal sum_0_7 : sum_t_0_7;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_7.mem") port map (clk, input(1), act_0_1_7);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_7.mem") port map (clk, input(2), act_0_2_7);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_7.mem") port map (clk, input(3), act_0_3_7);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_7.mem") port map (clk, input(4), act_0_4_7);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_7.mem") port map (clk, input(5), act_0_5_7);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_7.mem") port map (clk, input(6), act_0_6_7);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_7.mem") port map (clk, input(7), act_0_7_7);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_7.mem") port map (clk, input(8), act_0_8_7);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_7.mem") port map (clk, input(9), act_0_9_7);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_7.mem") port map (clk, input(10), act_0_10_7);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_7.mem") port map (clk, input(11), act_0_11_7);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_7.mem") port map (clk, input(12), act_0_12_7);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_7.mem") port map (clk, input(13), act_0_13_7);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_7.mem") port map (clk, input(14), act_0_14_7);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_7.mem") port map (clk, input(15), act_0_15_7);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_7.mem") port map (clk, input(17), act_0_17_7);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_7.mem") port map (clk, input(19), act_0_19_7);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_7.mem") port map (clk, input(21), act_0_21_7);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_7.mem") port map (clk, input(22), act_0_22_7);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_7.mem") port map (clk, input(23), act_0_23_7);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_7.mem") port map (clk, input(24), act_0_24_7);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_7.mem") port map (clk, input(25), act_0_25_7);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_7.mem") port map (clk, input(26), act_0_26_7);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_7.mem") port map (clk, input(27), act_0_27_7);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_7.mem") port map (clk, input(28), act_0_28_7);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_7.mem") port map (clk, input(29), act_0_29_7);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_7.mem") port map (clk, input(30), act_0_30_7);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_7.mem") port map (clk, input(31), act_0_31_7);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_7.mem") port map (clk, input(32), act_0_32_7);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_7.mem") port map (clk, input(33), act_0_33_7);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_7.mem") port map (clk, input(34), act_0_34_7);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_7.mem") port map (clk, input(35), act_0_35_7);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_7.mem") port map (clk, input(36), act_0_36_7);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_7.mem") port map (clk, input(37), act_0_37_7);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_7.mem") port map (clk, input(40), act_0_40_7);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_7.mem") port map (clk, input(41), act_0_41_7);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_7.mem") port map (clk, input(42), act_0_42_7);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_7.mem") port map (clk, input(43), act_0_43_7);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_7.mem") port map (clk, input(44), act_0_44_7);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_7.mem") port map (clk, input(47), act_0_47_7);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_7.mem") port map (clk, input(49), act_0_49_7);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_7, SUM_WIDTH_0_7) + resize(act_0_2_7, SUM_WIDTH_0_7) + resize(act_0_3_7, SUM_WIDTH_0_7) + resize(act_0_4_7, SUM_WIDTH_0_7);
        s1_1 <= resize(act_0_5_7, SUM_WIDTH_0_7) + resize(act_0_6_7, SUM_WIDTH_0_7) + resize(act_0_7_7, SUM_WIDTH_0_7) + resize(act_0_8_7, SUM_WIDTH_0_7);
        s1_2 <= resize(act_0_9_7, SUM_WIDTH_0_7) + resize(act_0_10_7, SUM_WIDTH_0_7) + resize(act_0_11_7, SUM_WIDTH_0_7) + resize(act_0_12_7, SUM_WIDTH_0_7);
        s1_3 <= resize(act_0_13_7, SUM_WIDTH_0_7) + resize(act_0_14_7, SUM_WIDTH_0_7) + resize(act_0_15_7, SUM_WIDTH_0_7) + resize(act_0_17_7, SUM_WIDTH_0_7);
        s1_4 <= resize(act_0_19_7, SUM_WIDTH_0_7) + resize(act_0_21_7, SUM_WIDTH_0_7) + resize(act_0_22_7, SUM_WIDTH_0_7) + resize(act_0_23_7, SUM_WIDTH_0_7);
        s1_5 <= resize(act_0_24_7, SUM_WIDTH_0_7) + resize(act_0_25_7, SUM_WIDTH_0_7) + resize(act_0_26_7, SUM_WIDTH_0_7) + resize(act_0_27_7, SUM_WIDTH_0_7);
        s1_6 <= resize(act_0_28_7, SUM_WIDTH_0_7) + resize(act_0_29_7, SUM_WIDTH_0_7) + resize(act_0_30_7, SUM_WIDTH_0_7) + resize(act_0_31_7, SUM_WIDTH_0_7);
        s1_7 <= resize(act_0_32_7, SUM_WIDTH_0_7) + resize(act_0_33_7, SUM_WIDTH_0_7) + resize(act_0_34_7, SUM_WIDTH_0_7) + resize(act_0_35_7, SUM_WIDTH_0_7);
        s1_8 <= resize(act_0_36_7, SUM_WIDTH_0_7) + resize(act_0_37_7, SUM_WIDTH_0_7) + resize(act_0_40_7, SUM_WIDTH_0_7) + resize(act_0_41_7, SUM_WIDTH_0_7);
        s1_9 <= resize(act_0_42_7, SUM_WIDTH_0_7) + resize(act_0_43_7, SUM_WIDTH_0_7) + resize(act_0_44_7, SUM_WIDTH_0_7) + resize(act_0_47_7, SUM_WIDTH_0_7);
        s1_10 <= resize(act_0_49_7, SUM_WIDTH_0_7);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_7 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_7 <= saturate(sum_0_7, 16);
  end block;

  -- LAYER 0, ch 8
  gen_l0c8 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_8;
  signal s2_0, s2_1, s2_2 : sum_t_0_8;
  signal sum_0_8 : sum_t_0_8;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_8.mem") port map (clk, input(1), act_0_1_8);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_8.mem") port map (clk, input(2), act_0_2_8);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_8.mem") port map (clk, input(3), act_0_3_8);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_8.mem") port map (clk, input(4), act_0_4_8);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_8.mem") port map (clk, input(5), act_0_5_8);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_8.mem") port map (clk, input(6), act_0_6_8);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_8.mem") port map (clk, input(7), act_0_7_8);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_8.mem") port map (clk, input(10), act_0_10_8);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_8.mem") port map (clk, input(11), act_0_11_8);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_8.mem") port map (clk, input(12), act_0_12_8);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_8.mem") port map (clk, input(13), act_0_13_8);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_8.mem") port map (clk, input(14), act_0_14_8);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_8.mem") port map (clk, input(15), act_0_15_8);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_8.mem") port map (clk, input(16), act_0_16_8);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_8.mem") port map (clk, input(17), act_0_17_8);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_8.mem") port map (clk, input(18), act_0_18_8);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_8.mem") port map (clk, input(19), act_0_19_8);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_8.mem") port map (clk, input(21), act_0_21_8);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_8.mem") port map (clk, input(22), act_0_22_8);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_8.mem") port map (clk, input(23), act_0_23_8);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_8.mem") port map (clk, input(26), act_0_26_8);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_8.mem") port map (clk, input(27), act_0_27_8);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_8.mem") port map (clk, input(28), act_0_28_8);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_8.mem") port map (clk, input(29), act_0_29_8);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_8.mem") port map (clk, input(31), act_0_31_8);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_8.mem") port map (clk, input(32), act_0_32_8);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_8.mem") port map (clk, input(33), act_0_33_8);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_8.mem") port map (clk, input(34), act_0_34_8);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_8.mem") port map (clk, input(35), act_0_35_8);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_8.mem") port map (clk, input(36), act_0_36_8);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_8.mem") port map (clk, input(37), act_0_37_8);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_8.mem") port map (clk, input(38), act_0_38_8);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_8.mem") port map (clk, input(39), act_0_39_8);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_8.mem") port map (clk, input(40), act_0_40_8);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_8.mem") port map (clk, input(41), act_0_41_8);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_8.mem") port map (clk, input(42), act_0_42_8);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_8.mem") port map (clk, input(43), act_0_43_8);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_8.mem") port map (clk, input(44), act_0_44_8);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_8.mem") port map (clk, input(45), act_0_45_8);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_8.mem") port map (clk, input(46), act_0_46_8);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_8.mem") port map (clk, input(47), act_0_47_8);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_8.mem") port map (clk, input(48), act_0_48_8);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_8, SUM_WIDTH_0_8) + resize(act_0_2_8, SUM_WIDTH_0_8) + resize(act_0_3_8, SUM_WIDTH_0_8) + resize(act_0_4_8, SUM_WIDTH_0_8);
        s1_1 <= resize(act_0_5_8, SUM_WIDTH_0_8) + resize(act_0_6_8, SUM_WIDTH_0_8) + resize(act_0_7_8, SUM_WIDTH_0_8) + resize(act_0_10_8, SUM_WIDTH_0_8);
        s1_2 <= resize(act_0_11_8, SUM_WIDTH_0_8) + resize(act_0_12_8, SUM_WIDTH_0_8) + resize(act_0_13_8, SUM_WIDTH_0_8) + resize(act_0_14_8, SUM_WIDTH_0_8);
        s1_3 <= resize(act_0_15_8, SUM_WIDTH_0_8) + resize(act_0_16_8, SUM_WIDTH_0_8) + resize(act_0_17_8, SUM_WIDTH_0_8) + resize(act_0_18_8, SUM_WIDTH_0_8);
        s1_4 <= resize(act_0_19_8, SUM_WIDTH_0_8) + resize(act_0_21_8, SUM_WIDTH_0_8) + resize(act_0_22_8, SUM_WIDTH_0_8) + resize(act_0_23_8, SUM_WIDTH_0_8);
        s1_5 <= resize(act_0_26_8, SUM_WIDTH_0_8) + resize(act_0_27_8, SUM_WIDTH_0_8) + resize(act_0_28_8, SUM_WIDTH_0_8) + resize(act_0_29_8, SUM_WIDTH_0_8);
        s1_6 <= resize(act_0_31_8, SUM_WIDTH_0_8) + resize(act_0_32_8, SUM_WIDTH_0_8) + resize(act_0_33_8, SUM_WIDTH_0_8) + resize(act_0_34_8, SUM_WIDTH_0_8);
        s1_7 <= resize(act_0_35_8, SUM_WIDTH_0_8) + resize(act_0_36_8, SUM_WIDTH_0_8) + resize(act_0_37_8, SUM_WIDTH_0_8) + resize(act_0_38_8, SUM_WIDTH_0_8);
        s1_8 <= resize(act_0_39_8, SUM_WIDTH_0_8) + resize(act_0_40_8, SUM_WIDTH_0_8) + resize(act_0_41_8, SUM_WIDTH_0_8) + resize(act_0_42_8, SUM_WIDTH_0_8);
        s1_9 <= resize(act_0_43_8, SUM_WIDTH_0_8) + resize(act_0_44_8, SUM_WIDTH_0_8) + resize(act_0_45_8, SUM_WIDTH_0_8) + resize(act_0_46_8, SUM_WIDTH_0_8);
        s1_10 <= resize(act_0_47_8, SUM_WIDTH_0_8) + resize(act_0_48_8, SUM_WIDTH_0_8);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_8 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_8 <= saturate(sum_0_8, 16);
  end block;

  -- LAYER 0, ch 9
  gen_l0c9 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_9;
  signal s2_0, s2_1, s2_2 : sum_t_0_9;
  signal sum_0_9 : sum_t_0_9;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_9.mem") port map (clk, input(2), act_0_2_9);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_9.mem") port map (clk, input(3), act_0_3_9);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_9.mem") port map (clk, input(4), act_0_4_9);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_9.mem") port map (clk, input(6), act_0_6_9);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_9.mem") port map (clk, input(7), act_0_7_9);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_9.mem") port map (clk, input(8), act_0_8_9);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_9.mem") port map (clk, input(9), act_0_9_9);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_9.mem") port map (clk, input(10), act_0_10_9);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_9.mem") port map (clk, input(11), act_0_11_9);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_9.mem") port map (clk, input(12), act_0_12_9);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_9.mem") port map (clk, input(13), act_0_13_9);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_9.mem") port map (clk, input(14), act_0_14_9);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_9.mem") port map (clk, input(15), act_0_15_9);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_9.mem") port map (clk, input(17), act_0_17_9);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_9.mem") port map (clk, input(18), act_0_18_9);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_9.mem") port map (clk, input(19), act_0_19_9);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_9.mem") port map (clk, input(21), act_0_21_9);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_9.mem") port map (clk, input(23), act_0_23_9);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_9.mem") port map (clk, input(25), act_0_25_9);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_9.mem") port map (clk, input(26), act_0_26_9);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_9.mem") port map (clk, input(27), act_0_27_9);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_9.mem") port map (clk, input(28), act_0_28_9);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_9.mem") port map (clk, input(29), act_0_29_9);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_9.mem") port map (clk, input(30), act_0_30_9);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_9.mem") port map (clk, input(31), act_0_31_9);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_9.mem") port map (clk, input(32), act_0_32_9);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_9.mem") port map (clk, input(33), act_0_33_9);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_9.mem") port map (clk, input(34), act_0_34_9);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_9.mem") port map (clk, input(35), act_0_35_9);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_9.mem") port map (clk, input(36), act_0_36_9);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_9.mem") port map (clk, input(37), act_0_37_9);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_9.mem") port map (clk, input(38), act_0_38_9);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_9.mem") port map (clk, input(39), act_0_39_9);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_9.mem") port map (clk, input(41), act_0_41_9);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_9.mem") port map (clk, input(43), act_0_43_9);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_9.mem") port map (clk, input(46), act_0_46_9);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_9.mem") port map (clk, input(47), act_0_47_9);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_9.mem") port map (clk, input(48), act_0_48_9);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_9.mem") port map (clk, input(49), act_0_49_9);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_2_9, SUM_WIDTH_0_9) + resize(act_0_3_9, SUM_WIDTH_0_9) + resize(act_0_4_9, SUM_WIDTH_0_9) + resize(act_0_6_9, SUM_WIDTH_0_9);
        s1_1 <= resize(act_0_7_9, SUM_WIDTH_0_9) + resize(act_0_8_9, SUM_WIDTH_0_9) + resize(act_0_9_9, SUM_WIDTH_0_9) + resize(act_0_10_9, SUM_WIDTH_0_9);
        s1_2 <= resize(act_0_11_9, SUM_WIDTH_0_9) + resize(act_0_12_9, SUM_WIDTH_0_9) + resize(act_0_13_9, SUM_WIDTH_0_9) + resize(act_0_14_9, SUM_WIDTH_0_9);
        s1_3 <= resize(act_0_15_9, SUM_WIDTH_0_9) + resize(act_0_17_9, SUM_WIDTH_0_9) + resize(act_0_18_9, SUM_WIDTH_0_9) + resize(act_0_19_9, SUM_WIDTH_0_9);
        s1_4 <= resize(act_0_21_9, SUM_WIDTH_0_9) + resize(act_0_23_9, SUM_WIDTH_0_9) + resize(act_0_25_9, SUM_WIDTH_0_9) + resize(act_0_26_9, SUM_WIDTH_0_9);
        s1_5 <= resize(act_0_27_9, SUM_WIDTH_0_9) + resize(act_0_28_9, SUM_WIDTH_0_9) + resize(act_0_29_9, SUM_WIDTH_0_9) + resize(act_0_30_9, SUM_WIDTH_0_9);
        s1_6 <= resize(act_0_31_9, SUM_WIDTH_0_9) + resize(act_0_32_9, SUM_WIDTH_0_9) + resize(act_0_33_9, SUM_WIDTH_0_9) + resize(act_0_34_9, SUM_WIDTH_0_9);
        s1_7 <= resize(act_0_35_9, SUM_WIDTH_0_9) + resize(act_0_36_9, SUM_WIDTH_0_9) + resize(act_0_37_9, SUM_WIDTH_0_9) + resize(act_0_38_9, SUM_WIDTH_0_9);
        s1_8 <= resize(act_0_39_9, SUM_WIDTH_0_9) + resize(act_0_41_9, SUM_WIDTH_0_9) + resize(act_0_43_9, SUM_WIDTH_0_9) + resize(act_0_46_9, SUM_WIDTH_0_9);
        s1_9 <= resize(act_0_47_9, SUM_WIDTH_0_9) + resize(act_0_48_9, SUM_WIDTH_0_9) + resize(act_0_49_9, SUM_WIDTH_0_9);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_9 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_9 <= saturate(sum_0_9, 16);
  end block;

  -- LAYER 0, ch 10
  gen_l0c10 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_10;
  signal s2_0, s2_1, s2_2 : sum_t_0_10;
  signal sum_0_10 : sum_t_0_10;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_10.mem") port map (clk, input(1), act_0_1_10);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_10.mem") port map (clk, input(2), act_0_2_10);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_10.mem") port map (clk, input(3), act_0_3_10);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_10.mem") port map (clk, input(5), act_0_5_10);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_10.mem") port map (clk, input(6), act_0_6_10);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_10.mem") port map (clk, input(7), act_0_7_10);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_10.mem") port map (clk, input(8), act_0_8_10);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_10.mem") port map (clk, input(9), act_0_9_10);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_10.mem") port map (clk, input(11), act_0_11_10);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_10.mem") port map (clk, input(12), act_0_12_10);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_10.mem") port map (clk, input(13), act_0_13_10);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_10.mem") port map (clk, input(14), act_0_14_10);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_10.mem") port map (clk, input(15), act_0_15_10);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_10.mem") port map (clk, input(16), act_0_16_10);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_10.mem") port map (clk, input(17), act_0_17_10);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_10.mem") port map (clk, input(18), act_0_18_10);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_10.mem") port map (clk, input(19), act_0_19_10);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_10.mem") port map (clk, input(20), act_0_20_10);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_10.mem") port map (clk, input(22), act_0_22_10);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_10.mem") port map (clk, input(23), act_0_23_10);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_10.mem") port map (clk, input(24), act_0_24_10);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_10.mem") port map (clk, input(25), act_0_25_10);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_10.mem") port map (clk, input(27), act_0_27_10);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_10.mem") port map (clk, input(28), act_0_28_10);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_10.mem") port map (clk, input(29), act_0_29_10);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_10.mem") port map (clk, input(31), act_0_31_10);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_10.mem") port map (clk, input(32), act_0_32_10);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_10.mem") port map (clk, input(33), act_0_33_10);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_10.mem") port map (clk, input(34), act_0_34_10);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_10.mem") port map (clk, input(35), act_0_35_10);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_10.mem") port map (clk, input(37), act_0_37_10);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_10.mem") port map (clk, input(38), act_0_38_10);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_10.mem") port map (clk, input(40), act_0_40_10);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_10.mem") port map (clk, input(41), act_0_41_10);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_10.mem") port map (clk, input(42), act_0_42_10);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_10.mem") port map (clk, input(43), act_0_43_10);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_10.mem") port map (clk, input(44), act_0_44_10);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_10.mem") port map (clk, input(45), act_0_45_10);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_10.mem") port map (clk, input(46), act_0_46_10);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_10.mem") port map (clk, input(47), act_0_47_10);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_10.mem") port map (clk, input(48), act_0_48_10);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_10.mem") port map (clk, input(49), act_0_49_10);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_10, SUM_WIDTH_0_10) + resize(act_0_2_10, SUM_WIDTH_0_10) + resize(act_0_3_10, SUM_WIDTH_0_10) + resize(act_0_5_10, SUM_WIDTH_0_10);
        s1_1 <= resize(act_0_6_10, SUM_WIDTH_0_10) + resize(act_0_7_10, SUM_WIDTH_0_10) + resize(act_0_8_10, SUM_WIDTH_0_10) + resize(act_0_9_10, SUM_WIDTH_0_10);
        s1_2 <= resize(act_0_11_10, SUM_WIDTH_0_10) + resize(act_0_12_10, SUM_WIDTH_0_10) + resize(act_0_13_10, SUM_WIDTH_0_10) + resize(act_0_14_10, SUM_WIDTH_0_10);
        s1_3 <= resize(act_0_15_10, SUM_WIDTH_0_10) + resize(act_0_16_10, SUM_WIDTH_0_10) + resize(act_0_17_10, SUM_WIDTH_0_10) + resize(act_0_18_10, SUM_WIDTH_0_10);
        s1_4 <= resize(act_0_19_10, SUM_WIDTH_0_10) + resize(act_0_20_10, SUM_WIDTH_0_10) + resize(act_0_22_10, SUM_WIDTH_0_10) + resize(act_0_23_10, SUM_WIDTH_0_10);
        s1_5 <= resize(act_0_24_10, SUM_WIDTH_0_10) + resize(act_0_25_10, SUM_WIDTH_0_10) + resize(act_0_27_10, SUM_WIDTH_0_10) + resize(act_0_28_10, SUM_WIDTH_0_10);
        s1_6 <= resize(act_0_29_10, SUM_WIDTH_0_10) + resize(act_0_31_10, SUM_WIDTH_0_10) + resize(act_0_32_10, SUM_WIDTH_0_10) + resize(act_0_33_10, SUM_WIDTH_0_10);
        s1_7 <= resize(act_0_34_10, SUM_WIDTH_0_10) + resize(act_0_35_10, SUM_WIDTH_0_10) + resize(act_0_37_10, SUM_WIDTH_0_10) + resize(act_0_38_10, SUM_WIDTH_0_10);
        s1_8 <= resize(act_0_40_10, SUM_WIDTH_0_10) + resize(act_0_41_10, SUM_WIDTH_0_10) + resize(act_0_42_10, SUM_WIDTH_0_10) + resize(act_0_43_10, SUM_WIDTH_0_10);
        s1_9 <= resize(act_0_44_10, SUM_WIDTH_0_10) + resize(act_0_45_10, SUM_WIDTH_0_10) + resize(act_0_46_10, SUM_WIDTH_0_10) + resize(act_0_47_10, SUM_WIDTH_0_10);
        s1_10 <= resize(act_0_48_10, SUM_WIDTH_0_10) + resize(act_0_49_10, SUM_WIDTH_0_10);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_10 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_10 <= saturate(sum_0_10, 16);
  end block;

  -- LAYER 0, ch 11
  gen_l0c11 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_11;
  signal s2_0, s2_1, s2_2 : sum_t_0_11;
  signal sum_0_11 : sum_t_0_11;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_11.mem") port map (clk, input(2), act_0_2_11);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_11.mem") port map (clk, input(3), act_0_3_11);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_11.mem") port map (clk, input(4), act_0_4_11);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_11.mem") port map (clk, input(5), act_0_5_11);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_11.mem") port map (clk, input(6), act_0_6_11);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_11.mem") port map (clk, input(8), act_0_8_11);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_11.mem") port map (clk, input(9), act_0_9_11);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_11.mem") port map (clk, input(10), act_0_10_11);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_11.mem") port map (clk, input(11), act_0_11_11);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_11.mem") port map (clk, input(12), act_0_12_11);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_11.mem") port map (clk, input(13), act_0_13_11);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_11.mem") port map (clk, input(14), act_0_14_11);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_11.mem") port map (clk, input(15), act_0_15_11);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_11.mem") port map (clk, input(16), act_0_16_11);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_11.mem") port map (clk, input(17), act_0_17_11);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_11.mem") port map (clk, input(18), act_0_18_11);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_11.mem") port map (clk, input(19), act_0_19_11);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_11.mem") port map (clk, input(20), act_0_20_11);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_11.mem") port map (clk, input(21), act_0_21_11);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_11.mem") port map (clk, input(22), act_0_22_11);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_11.mem") port map (clk, input(23), act_0_23_11);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_11.mem") port map (clk, input(27), act_0_27_11);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_11.mem") port map (clk, input(29), act_0_29_11);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_11.mem") port map (clk, input(30), act_0_30_11);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_11.mem") port map (clk, input(31), act_0_31_11);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_11.mem") port map (clk, input(32), act_0_32_11);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_11.mem") port map (clk, input(33), act_0_33_11);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_11.mem") port map (clk, input(34), act_0_34_11);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_11.mem") port map (clk, input(35), act_0_35_11);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_11.mem") port map (clk, input(38), act_0_38_11);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_11.mem") port map (clk, input(39), act_0_39_11);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_11.mem") port map (clk, input(40), act_0_40_11);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_11.mem") port map (clk, input(41), act_0_41_11);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_11.mem") port map (clk, input(42), act_0_42_11);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_11.mem") port map (clk, input(43), act_0_43_11);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_11.mem") port map (clk, input(44), act_0_44_11);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_11.mem") port map (clk, input(45), act_0_45_11);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_11.mem") port map (clk, input(46), act_0_46_11);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_11.mem") port map (clk, input(47), act_0_47_11);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_11.mem") port map (clk, input(48), act_0_48_11);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_2_11, SUM_WIDTH_0_11) + resize(act_0_3_11, SUM_WIDTH_0_11) + resize(act_0_4_11, SUM_WIDTH_0_11) + resize(act_0_5_11, SUM_WIDTH_0_11);
        s1_1 <= resize(act_0_6_11, SUM_WIDTH_0_11) + resize(act_0_8_11, SUM_WIDTH_0_11) + resize(act_0_9_11, SUM_WIDTH_0_11) + resize(act_0_10_11, SUM_WIDTH_0_11);
        s1_2 <= resize(act_0_11_11, SUM_WIDTH_0_11) + resize(act_0_12_11, SUM_WIDTH_0_11) + resize(act_0_13_11, SUM_WIDTH_0_11) + resize(act_0_14_11, SUM_WIDTH_0_11);
        s1_3 <= resize(act_0_15_11, SUM_WIDTH_0_11) + resize(act_0_16_11, SUM_WIDTH_0_11) + resize(act_0_17_11, SUM_WIDTH_0_11) + resize(act_0_18_11, SUM_WIDTH_0_11);
        s1_4 <= resize(act_0_19_11, SUM_WIDTH_0_11) + resize(act_0_20_11, SUM_WIDTH_0_11) + resize(act_0_21_11, SUM_WIDTH_0_11) + resize(act_0_22_11, SUM_WIDTH_0_11);
        s1_5 <= resize(act_0_23_11, SUM_WIDTH_0_11) + resize(act_0_27_11, SUM_WIDTH_0_11) + resize(act_0_29_11, SUM_WIDTH_0_11) + resize(act_0_30_11, SUM_WIDTH_0_11);
        s1_6 <= resize(act_0_31_11, SUM_WIDTH_0_11) + resize(act_0_32_11, SUM_WIDTH_0_11) + resize(act_0_33_11, SUM_WIDTH_0_11) + resize(act_0_34_11, SUM_WIDTH_0_11);
        s1_7 <= resize(act_0_35_11, SUM_WIDTH_0_11) + resize(act_0_38_11, SUM_WIDTH_0_11) + resize(act_0_39_11, SUM_WIDTH_0_11) + resize(act_0_40_11, SUM_WIDTH_0_11);
        s1_8 <= resize(act_0_41_11, SUM_WIDTH_0_11) + resize(act_0_42_11, SUM_WIDTH_0_11) + resize(act_0_43_11, SUM_WIDTH_0_11) + resize(act_0_44_11, SUM_WIDTH_0_11);
        s1_9 <= resize(act_0_45_11, SUM_WIDTH_0_11) + resize(act_0_46_11, SUM_WIDTH_0_11) + resize(act_0_47_11, SUM_WIDTH_0_11) + resize(act_0_48_11, SUM_WIDTH_0_11);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_11 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_11 <= saturate(sum_0_11, 16);
  end block;

  -- LAYER 0, ch 12
  gen_l0c12 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_12;
  signal s2_0, s2_1, s2_2 : sum_t_0_12;
  signal sum_0_12 : sum_t_0_12;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_12.mem") port map (clk, input(0), act_0_0_12);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_12.mem") port map (clk, input(1), act_0_1_12);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_12.mem") port map (clk, input(2), act_0_2_12);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_12.mem") port map (clk, input(3), act_0_3_12);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_12.mem") port map (clk, input(4), act_0_4_12);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_12.mem") port map (clk, input(6), act_0_6_12);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_12.mem") port map (clk, input(7), act_0_7_12);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_12.mem") port map (clk, input(8), act_0_8_12);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_12.mem") port map (clk, input(10), act_0_10_12);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_12.mem") port map (clk, input(11), act_0_11_12);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_12.mem") port map (clk, input(12), act_0_12_12);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_12.mem") port map (clk, input(13), act_0_13_12);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_12.mem") port map (clk, input(14), act_0_14_12);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_12.mem") port map (clk, input(17), act_0_17_12);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_12.mem") port map (clk, input(18), act_0_18_12);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_12.mem") port map (clk, input(21), act_0_21_12);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_12.mem") port map (clk, input(22), act_0_22_12);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_12.mem") port map (clk, input(23), act_0_23_12);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_12.mem") port map (clk, input(24), act_0_24_12);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_12.mem") port map (clk, input(25), act_0_25_12);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_12.mem") port map (clk, input(26), act_0_26_12);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_12.mem") port map (clk, input(27), act_0_27_12);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_12.mem") port map (clk, input(29), act_0_29_12);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_12.mem") port map (clk, input(30), act_0_30_12);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_12.mem") port map (clk, input(31), act_0_31_12);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_12.mem") port map (clk, input(32), act_0_32_12);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_12.mem") port map (clk, input(33), act_0_33_12);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_12.mem") port map (clk, input(34), act_0_34_12);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_12.mem") port map (clk, input(35), act_0_35_12);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_12.mem") port map (clk, input(36), act_0_36_12);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_12.mem") port map (clk, input(37), act_0_37_12);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_12.mem") port map (clk, input(38), act_0_38_12);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_12.mem") port map (clk, input(39), act_0_39_12);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_12.mem") port map (clk, input(40), act_0_40_12);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_12.mem") port map (clk, input(42), act_0_42_12);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_12.mem") port map (clk, input(43), act_0_43_12);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_12.mem") port map (clk, input(44), act_0_44_12);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_12.mem") port map (clk, input(45), act_0_45_12);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_12.mem") port map (clk, input(46), act_0_46_12);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_12.mem") port map (clk, input(48), act_0_48_12);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_12.mem") port map (clk, input(49), act_0_49_12);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_12, SUM_WIDTH_0_12) + resize(act_0_1_12, SUM_WIDTH_0_12) + resize(act_0_2_12, SUM_WIDTH_0_12) + resize(act_0_3_12, SUM_WIDTH_0_12);
        s1_1 <= resize(act_0_4_12, SUM_WIDTH_0_12) + resize(act_0_6_12, SUM_WIDTH_0_12) + resize(act_0_7_12, SUM_WIDTH_0_12) + resize(act_0_8_12, SUM_WIDTH_0_12);
        s1_2 <= resize(act_0_10_12, SUM_WIDTH_0_12) + resize(act_0_11_12, SUM_WIDTH_0_12) + resize(act_0_12_12, SUM_WIDTH_0_12) + resize(act_0_13_12, SUM_WIDTH_0_12);
        s1_3 <= resize(act_0_14_12, SUM_WIDTH_0_12) + resize(act_0_17_12, SUM_WIDTH_0_12) + resize(act_0_18_12, SUM_WIDTH_0_12) + resize(act_0_21_12, SUM_WIDTH_0_12);
        s1_4 <= resize(act_0_22_12, SUM_WIDTH_0_12) + resize(act_0_23_12, SUM_WIDTH_0_12) + resize(act_0_24_12, SUM_WIDTH_0_12) + resize(act_0_25_12, SUM_WIDTH_0_12);
        s1_5 <= resize(act_0_26_12, SUM_WIDTH_0_12) + resize(act_0_27_12, SUM_WIDTH_0_12) + resize(act_0_29_12, SUM_WIDTH_0_12) + resize(act_0_30_12, SUM_WIDTH_0_12);
        s1_6 <= resize(act_0_31_12, SUM_WIDTH_0_12) + resize(act_0_32_12, SUM_WIDTH_0_12) + resize(act_0_33_12, SUM_WIDTH_0_12) + resize(act_0_34_12, SUM_WIDTH_0_12);
        s1_7 <= resize(act_0_35_12, SUM_WIDTH_0_12) + resize(act_0_36_12, SUM_WIDTH_0_12) + resize(act_0_37_12, SUM_WIDTH_0_12) + resize(act_0_38_12, SUM_WIDTH_0_12);
        s1_8 <= resize(act_0_39_12, SUM_WIDTH_0_12) + resize(act_0_40_12, SUM_WIDTH_0_12) + resize(act_0_42_12, SUM_WIDTH_0_12) + resize(act_0_43_12, SUM_WIDTH_0_12);
        s1_9 <= resize(act_0_44_12, SUM_WIDTH_0_12) + resize(act_0_45_12, SUM_WIDTH_0_12) + resize(act_0_46_12, SUM_WIDTH_0_12) + resize(act_0_48_12, SUM_WIDTH_0_12);
        s1_10 <= resize(act_0_49_12, SUM_WIDTH_0_12);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_12 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_12 <= saturate(sum_0_12, 16);
  end block;

  -- LAYER 0, ch 13
  gen_l0c13 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_13;
  signal s2_0, s2_1, s2_2 : sum_t_0_13;
  signal sum_0_13 : sum_t_0_13;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_13.mem") port map (clk, input(1), act_0_1_13);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_13.mem") port map (clk, input(2), act_0_2_13);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_13.mem") port map (clk, input(3), act_0_3_13);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_13.mem") port map (clk, input(4), act_0_4_13);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_13.mem") port map (clk, input(7), act_0_7_13);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_13.mem") port map (clk, input(8), act_0_8_13);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_13.mem") port map (clk, input(9), act_0_9_13);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_13.mem") port map (clk, input(10), act_0_10_13);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_13.mem") port map (clk, input(11), act_0_11_13);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_13.mem") port map (clk, input(12), act_0_12_13);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_13.mem") port map (clk, input(13), act_0_13_13);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_13.mem") port map (clk, input(14), act_0_14_13);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_13.mem") port map (clk, input(17), act_0_17_13);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_13.mem") port map (clk, input(18), act_0_18_13);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_13.mem") port map (clk, input(19), act_0_19_13);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_13.mem") port map (clk, input(20), act_0_20_13);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_13.mem") port map (clk, input(21), act_0_21_13);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_13.mem") port map (clk, input(22), act_0_22_13);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_13.mem") port map (clk, input(25), act_0_25_13);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_13.mem") port map (clk, input(26), act_0_26_13);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_13.mem") port map (clk, input(27), act_0_27_13);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_13.mem") port map (clk, input(28), act_0_28_13);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_13.mem") port map (clk, input(29), act_0_29_13);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_13.mem") port map (clk, input(32), act_0_32_13);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_13.mem") port map (clk, input(33), act_0_33_13);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_13.mem") port map (clk, input(34), act_0_34_13);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_13.mem") port map (clk, input(36), act_0_36_13);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_13.mem") port map (clk, input(37), act_0_37_13);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_13.mem") port map (clk, input(38), act_0_38_13);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_13.mem") port map (clk, input(39), act_0_39_13);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_13.mem") port map (clk, input(40), act_0_40_13);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_13.mem") port map (clk, input(41), act_0_41_13);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_13.mem") port map (clk, input(42), act_0_42_13);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_13.mem") port map (clk, input(44), act_0_44_13);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_13.mem") port map (clk, input(45), act_0_45_13);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_13.mem") port map (clk, input(46), act_0_46_13);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_13.mem") port map (clk, input(47), act_0_47_13);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_13.mem") port map (clk, input(48), act_0_48_13);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_13.mem") port map (clk, input(49), act_0_49_13);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_13, SUM_WIDTH_0_13) + resize(act_0_2_13, SUM_WIDTH_0_13) + resize(act_0_3_13, SUM_WIDTH_0_13) + resize(act_0_4_13, SUM_WIDTH_0_13);
        s1_1 <= resize(act_0_7_13, SUM_WIDTH_0_13) + resize(act_0_8_13, SUM_WIDTH_0_13) + resize(act_0_9_13, SUM_WIDTH_0_13) + resize(act_0_10_13, SUM_WIDTH_0_13);
        s1_2 <= resize(act_0_11_13, SUM_WIDTH_0_13) + resize(act_0_12_13, SUM_WIDTH_0_13) + resize(act_0_13_13, SUM_WIDTH_0_13) + resize(act_0_14_13, SUM_WIDTH_0_13);
        s1_3 <= resize(act_0_17_13, SUM_WIDTH_0_13) + resize(act_0_18_13, SUM_WIDTH_0_13) + resize(act_0_19_13, SUM_WIDTH_0_13) + resize(act_0_20_13, SUM_WIDTH_0_13);
        s1_4 <= resize(act_0_21_13, SUM_WIDTH_0_13) + resize(act_0_22_13, SUM_WIDTH_0_13) + resize(act_0_25_13, SUM_WIDTH_0_13) + resize(act_0_26_13, SUM_WIDTH_0_13);
        s1_5 <= resize(act_0_27_13, SUM_WIDTH_0_13) + resize(act_0_28_13, SUM_WIDTH_0_13) + resize(act_0_29_13, SUM_WIDTH_0_13) + resize(act_0_32_13, SUM_WIDTH_0_13);
        s1_6 <= resize(act_0_33_13, SUM_WIDTH_0_13) + resize(act_0_34_13, SUM_WIDTH_0_13) + resize(act_0_36_13, SUM_WIDTH_0_13) + resize(act_0_37_13, SUM_WIDTH_0_13);
        s1_7 <= resize(act_0_38_13, SUM_WIDTH_0_13) + resize(act_0_39_13, SUM_WIDTH_0_13) + resize(act_0_40_13, SUM_WIDTH_0_13) + resize(act_0_41_13, SUM_WIDTH_0_13);
        s1_8 <= resize(act_0_42_13, SUM_WIDTH_0_13) + resize(act_0_44_13, SUM_WIDTH_0_13) + resize(act_0_45_13, SUM_WIDTH_0_13) + resize(act_0_46_13, SUM_WIDTH_0_13);
        s1_9 <= resize(act_0_47_13, SUM_WIDTH_0_13) + resize(act_0_48_13, SUM_WIDTH_0_13) + resize(act_0_49_13, SUM_WIDTH_0_13);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_13 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_13 <= saturate(sum_0_13, 16);
  end block;

  -- LAYER 0, ch 14
  gen_l0c14 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_14;
  signal s2_0, s2_1, s2_2 : sum_t_0_14;
  signal sum_0_14 : sum_t_0_14;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_14.mem") port map (clk, input(0), act_0_0_14);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_14.mem") port map (clk, input(1), act_0_1_14);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_14.mem") port map (clk, input(2), act_0_2_14);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_14.mem") port map (clk, input(3), act_0_3_14);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_14.mem") port map (clk, input(4), act_0_4_14);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_14.mem") port map (clk, input(5), act_0_5_14);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_14.mem") port map (clk, input(6), act_0_6_14);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_14.mem") port map (clk, input(7), act_0_7_14);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_14.mem") port map (clk, input(8), act_0_8_14);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_14.mem") port map (clk, input(9), act_0_9_14);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_14.mem") port map (clk, input(10), act_0_10_14);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_14.mem") port map (clk, input(11), act_0_11_14);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_14.mem") port map (clk, input(12), act_0_12_14);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_14.mem") port map (clk, input(13), act_0_13_14);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_14.mem") port map (clk, input(15), act_0_15_14);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_14.mem") port map (clk, input(16), act_0_16_14);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_14.mem") port map (clk, input(17), act_0_17_14);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_14.mem") port map (clk, input(18), act_0_18_14);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_14.mem") port map (clk, input(19), act_0_19_14);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_14.mem") port map (clk, input(20), act_0_20_14);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_14.mem") port map (clk, input(21), act_0_21_14);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_14.mem") port map (clk, input(22), act_0_22_14);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_14.mem") port map (clk, input(23), act_0_23_14);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_14.mem") port map (clk, input(28), act_0_28_14);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_14.mem") port map (clk, input(29), act_0_29_14);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_14.mem") port map (clk, input(30), act_0_30_14);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_14.mem") port map (clk, input(31), act_0_31_14);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_14.mem") port map (clk, input(32), act_0_32_14);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_14.mem") port map (clk, input(33), act_0_33_14);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_14.mem") port map (clk, input(35), act_0_35_14);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_14.mem") port map (clk, input(36), act_0_36_14);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_14.mem") port map (clk, input(37), act_0_37_14);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_14.mem") port map (clk, input(38), act_0_38_14);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_14.mem") port map (clk, input(40), act_0_40_14);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_14.mem") port map (clk, input(41), act_0_41_14);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_14.mem") port map (clk, input(42), act_0_42_14);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_14.mem") port map (clk, input(43), act_0_43_14);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_14.mem") port map (clk, input(44), act_0_44_14);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_14.mem") port map (clk, input(45), act_0_45_14);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_14.mem") port map (clk, input(46), act_0_46_14);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_14.mem") port map (clk, input(47), act_0_47_14);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_14.mem") port map (clk, input(48), act_0_48_14);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_14.mem") port map (clk, input(49), act_0_49_14);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_14, SUM_WIDTH_0_14) + resize(act_0_1_14, SUM_WIDTH_0_14) + resize(act_0_2_14, SUM_WIDTH_0_14) + resize(act_0_3_14, SUM_WIDTH_0_14);
        s1_1 <= resize(act_0_4_14, SUM_WIDTH_0_14) + resize(act_0_5_14, SUM_WIDTH_0_14) + resize(act_0_6_14, SUM_WIDTH_0_14) + resize(act_0_7_14, SUM_WIDTH_0_14);
        s1_2 <= resize(act_0_8_14, SUM_WIDTH_0_14) + resize(act_0_9_14, SUM_WIDTH_0_14) + resize(act_0_10_14, SUM_WIDTH_0_14) + resize(act_0_11_14, SUM_WIDTH_0_14);
        s1_3 <= resize(act_0_12_14, SUM_WIDTH_0_14) + resize(act_0_13_14, SUM_WIDTH_0_14) + resize(act_0_15_14, SUM_WIDTH_0_14) + resize(act_0_16_14, SUM_WIDTH_0_14);
        s1_4 <= resize(act_0_17_14, SUM_WIDTH_0_14) + resize(act_0_18_14, SUM_WIDTH_0_14) + resize(act_0_19_14, SUM_WIDTH_0_14) + resize(act_0_20_14, SUM_WIDTH_0_14);
        s1_5 <= resize(act_0_21_14, SUM_WIDTH_0_14) + resize(act_0_22_14, SUM_WIDTH_0_14) + resize(act_0_23_14, SUM_WIDTH_0_14) + resize(act_0_28_14, SUM_WIDTH_0_14);
        s1_6 <= resize(act_0_29_14, SUM_WIDTH_0_14) + resize(act_0_30_14, SUM_WIDTH_0_14) + resize(act_0_31_14, SUM_WIDTH_0_14) + resize(act_0_32_14, SUM_WIDTH_0_14);
        s1_7 <= resize(act_0_33_14, SUM_WIDTH_0_14) + resize(act_0_35_14, SUM_WIDTH_0_14) + resize(act_0_36_14, SUM_WIDTH_0_14) + resize(act_0_37_14, SUM_WIDTH_0_14);
        s1_8 <= resize(act_0_38_14, SUM_WIDTH_0_14) + resize(act_0_40_14, SUM_WIDTH_0_14) + resize(act_0_41_14, SUM_WIDTH_0_14) + resize(act_0_42_14, SUM_WIDTH_0_14);
        s1_9 <= resize(act_0_43_14, SUM_WIDTH_0_14) + resize(act_0_44_14, SUM_WIDTH_0_14) + resize(act_0_45_14, SUM_WIDTH_0_14) + resize(act_0_46_14, SUM_WIDTH_0_14);
        s1_10 <= resize(act_0_47_14, SUM_WIDTH_0_14) + resize(act_0_48_14, SUM_WIDTH_0_14) + resize(act_0_49_14, SUM_WIDTH_0_14);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_14 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_14 <= saturate(sum_0_14, 16);
  end block;

  -- LAYER 0, ch 15
  gen_l0c15 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_15;
  signal s2_0, s2_1, s2_2 : sum_t_0_15;
  signal sum_0_15 : sum_t_0_15;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_15.mem") port map (clk, input(1), act_0_1_15);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_15.mem") port map (clk, input(2), act_0_2_15);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_15.mem") port map (clk, input(3), act_0_3_15);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_15.mem") port map (clk, input(4), act_0_4_15);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_15.mem") port map (clk, input(5), act_0_5_15);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_15.mem") port map (clk, input(6), act_0_6_15);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_15.mem") port map (clk, input(7), act_0_7_15);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_15.mem") port map (clk, input(8), act_0_8_15);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_15.mem") port map (clk, input(9), act_0_9_15);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_15.mem") port map (clk, input(11), act_0_11_15);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_15.mem") port map (clk, input(12), act_0_12_15);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_15.mem") port map (clk, input(13), act_0_13_15);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_15.mem") port map (clk, input(14), act_0_14_15);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_15.mem") port map (clk, input(15), act_0_15_15);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_15.mem") port map (clk, input(16), act_0_16_15);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_15.mem") port map (clk, input(17), act_0_17_15);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_15.mem") port map (clk, input(18), act_0_18_15);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_15.mem") port map (clk, input(19), act_0_19_15);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_15.mem") port map (clk, input(20), act_0_20_15);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_15.mem") port map (clk, input(21), act_0_21_15);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_15.mem") port map (clk, input(22), act_0_22_15);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_15.mem") port map (clk, input(23), act_0_23_15);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_15.mem") port map (clk, input(24), act_0_24_15);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_15.mem") port map (clk, input(27), act_0_27_15);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_15.mem") port map (clk, input(28), act_0_28_15);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_15.mem") port map (clk, input(29), act_0_29_15);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_15.mem") port map (clk, input(30), act_0_30_15);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_15.mem") port map (clk, input(31), act_0_31_15);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_15.mem") port map (clk, input(32), act_0_32_15);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_15.mem") port map (clk, input(34), act_0_34_15);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_15.mem") port map (clk, input(35), act_0_35_15);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_15.mem") port map (clk, input(36), act_0_36_15);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_15.mem") port map (clk, input(37), act_0_37_15);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_15.mem") port map (clk, input(38), act_0_38_15);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_15.mem") port map (clk, input(39), act_0_39_15);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_15.mem") port map (clk, input(40), act_0_40_15);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_15.mem") port map (clk, input(41), act_0_41_15);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_15.mem") port map (clk, input(42), act_0_42_15);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_15.mem") port map (clk, input(43), act_0_43_15);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_15.mem") port map (clk, input(44), act_0_44_15);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_15.mem") port map (clk, input(45), act_0_45_15);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_15.mem") port map (clk, input(46), act_0_46_15);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_15.mem") port map (clk, input(47), act_0_47_15);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_15.mem") port map (clk, input(48), act_0_48_15);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_15.mem") port map (clk, input(49), act_0_49_15);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_15, SUM_WIDTH_0_15) + resize(act_0_2_15, SUM_WIDTH_0_15) + resize(act_0_3_15, SUM_WIDTH_0_15) + resize(act_0_4_15, SUM_WIDTH_0_15);
        s1_1 <= resize(act_0_5_15, SUM_WIDTH_0_15) + resize(act_0_6_15, SUM_WIDTH_0_15) + resize(act_0_7_15, SUM_WIDTH_0_15) + resize(act_0_8_15, SUM_WIDTH_0_15);
        s1_2 <= resize(act_0_9_15, SUM_WIDTH_0_15) + resize(act_0_11_15, SUM_WIDTH_0_15) + resize(act_0_12_15, SUM_WIDTH_0_15) + resize(act_0_13_15, SUM_WIDTH_0_15);
        s1_3 <= resize(act_0_14_15, SUM_WIDTH_0_15) + resize(act_0_15_15, SUM_WIDTH_0_15) + resize(act_0_16_15, SUM_WIDTH_0_15) + resize(act_0_17_15, SUM_WIDTH_0_15);
        s1_4 <= resize(act_0_18_15, SUM_WIDTH_0_15) + resize(act_0_19_15, SUM_WIDTH_0_15) + resize(act_0_20_15, SUM_WIDTH_0_15) + resize(act_0_21_15, SUM_WIDTH_0_15);
        s1_5 <= resize(act_0_22_15, SUM_WIDTH_0_15) + resize(act_0_23_15, SUM_WIDTH_0_15) + resize(act_0_24_15, SUM_WIDTH_0_15) + resize(act_0_27_15, SUM_WIDTH_0_15);
        s1_6 <= resize(act_0_28_15, SUM_WIDTH_0_15) + resize(act_0_29_15, SUM_WIDTH_0_15) + resize(act_0_30_15, SUM_WIDTH_0_15) + resize(act_0_31_15, SUM_WIDTH_0_15);
        s1_7 <= resize(act_0_32_15, SUM_WIDTH_0_15) + resize(act_0_34_15, SUM_WIDTH_0_15) + resize(act_0_35_15, SUM_WIDTH_0_15) + resize(act_0_36_15, SUM_WIDTH_0_15);
        s1_8 <= resize(act_0_37_15, SUM_WIDTH_0_15) + resize(act_0_38_15, SUM_WIDTH_0_15) + resize(act_0_39_15, SUM_WIDTH_0_15) + resize(act_0_40_15, SUM_WIDTH_0_15);
        s1_9 <= resize(act_0_41_15, SUM_WIDTH_0_15) + resize(act_0_42_15, SUM_WIDTH_0_15) + resize(act_0_43_15, SUM_WIDTH_0_15) + resize(act_0_44_15, SUM_WIDTH_0_15);
        s1_10 <= resize(act_0_45_15, SUM_WIDTH_0_15) + resize(act_0_46_15, SUM_WIDTH_0_15) + resize(act_0_47_15, SUM_WIDTH_0_15) + resize(act_0_48_15, SUM_WIDTH_0_15);
        s1_11 <= resize(act_0_49_15, SUM_WIDTH_0_15);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_15 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_15 <= saturate(sum_0_15, 16);
  end block;

  -- LAYER 0, ch 16
  gen_l0c16 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_16;
  signal s2_0, s2_1, s2_2 : sum_t_0_16;
  signal sum_0_16 : sum_t_0_16;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_16.mem") port map (clk, input(0), act_0_0_16);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_16.mem") port map (clk, input(2), act_0_2_16);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_16.mem") port map (clk, input(3), act_0_3_16);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_16.mem") port map (clk, input(4), act_0_4_16);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_16.mem") port map (clk, input(5), act_0_5_16);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_16.mem") port map (clk, input(6), act_0_6_16);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_16.mem") port map (clk, input(7), act_0_7_16);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_16.mem") port map (clk, input(8), act_0_8_16);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_16.mem") port map (clk, input(9), act_0_9_16);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_16.mem") port map (clk, input(10), act_0_10_16);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_16.mem") port map (clk, input(11), act_0_11_16);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_16.mem") port map (clk, input(12), act_0_12_16);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_16.mem") port map (clk, input(13), act_0_13_16);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_16.mem") port map (clk, input(14), act_0_14_16);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_16.mem") port map (clk, input(15), act_0_15_16);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_16.mem") port map (clk, input(16), act_0_16_16);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_16.mem") port map (clk, input(17), act_0_17_16);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_16.mem") port map (clk, input(18), act_0_18_16);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_16.mem") port map (clk, input(20), act_0_20_16);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_16.mem") port map (clk, input(21), act_0_21_16);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_16.mem") port map (clk, input(23), act_0_23_16);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_16.mem") port map (clk, input(24), act_0_24_16);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_16.mem") port map (clk, input(25), act_0_25_16);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_16.mem") port map (clk, input(26), act_0_26_16);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_16.mem") port map (clk, input(27), act_0_27_16);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_16.mem") port map (clk, input(28), act_0_28_16);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_16.mem") port map (clk, input(29), act_0_29_16);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_16.mem") port map (clk, input(30), act_0_30_16);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_16.mem") port map (clk, input(32), act_0_32_16);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_16.mem") port map (clk, input(33), act_0_33_16);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_16.mem") port map (clk, input(35), act_0_35_16);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_16.mem") port map (clk, input(36), act_0_36_16);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_16.mem") port map (clk, input(37), act_0_37_16);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_16.mem") port map (clk, input(38), act_0_38_16);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_16.mem") port map (clk, input(39), act_0_39_16);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_16.mem") port map (clk, input(41), act_0_41_16);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_16.mem") port map (clk, input(42), act_0_42_16);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_16.mem") port map (clk, input(43), act_0_43_16);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_16.mem") port map (clk, input(44), act_0_44_16);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_16.mem") port map (clk, input(45), act_0_45_16);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_16.mem") port map (clk, input(46), act_0_46_16);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_16.mem") port map (clk, input(47), act_0_47_16);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_16.mem") port map (clk, input(48), act_0_48_16);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_16, SUM_WIDTH_0_16) + resize(act_0_2_16, SUM_WIDTH_0_16) + resize(act_0_3_16, SUM_WIDTH_0_16) + resize(act_0_4_16, SUM_WIDTH_0_16);
        s1_1 <= resize(act_0_5_16, SUM_WIDTH_0_16) + resize(act_0_6_16, SUM_WIDTH_0_16) + resize(act_0_7_16, SUM_WIDTH_0_16) + resize(act_0_8_16, SUM_WIDTH_0_16);
        s1_2 <= resize(act_0_9_16, SUM_WIDTH_0_16) + resize(act_0_10_16, SUM_WIDTH_0_16) + resize(act_0_11_16, SUM_WIDTH_0_16) + resize(act_0_12_16, SUM_WIDTH_0_16);
        s1_3 <= resize(act_0_13_16, SUM_WIDTH_0_16) + resize(act_0_14_16, SUM_WIDTH_0_16) + resize(act_0_15_16, SUM_WIDTH_0_16) + resize(act_0_16_16, SUM_WIDTH_0_16);
        s1_4 <= resize(act_0_17_16, SUM_WIDTH_0_16) + resize(act_0_18_16, SUM_WIDTH_0_16) + resize(act_0_20_16, SUM_WIDTH_0_16) + resize(act_0_21_16, SUM_WIDTH_0_16);
        s1_5 <= resize(act_0_23_16, SUM_WIDTH_0_16) + resize(act_0_24_16, SUM_WIDTH_0_16) + resize(act_0_25_16, SUM_WIDTH_0_16) + resize(act_0_26_16, SUM_WIDTH_0_16);
        s1_6 <= resize(act_0_27_16, SUM_WIDTH_0_16) + resize(act_0_28_16, SUM_WIDTH_0_16) + resize(act_0_29_16, SUM_WIDTH_0_16) + resize(act_0_30_16, SUM_WIDTH_0_16);
        s1_7 <= resize(act_0_32_16, SUM_WIDTH_0_16) + resize(act_0_33_16, SUM_WIDTH_0_16) + resize(act_0_35_16, SUM_WIDTH_0_16) + resize(act_0_36_16, SUM_WIDTH_0_16);
        s1_8 <= resize(act_0_37_16, SUM_WIDTH_0_16) + resize(act_0_38_16, SUM_WIDTH_0_16) + resize(act_0_39_16, SUM_WIDTH_0_16) + resize(act_0_41_16, SUM_WIDTH_0_16);
        s1_9 <= resize(act_0_42_16, SUM_WIDTH_0_16) + resize(act_0_43_16, SUM_WIDTH_0_16) + resize(act_0_44_16, SUM_WIDTH_0_16) + resize(act_0_45_16, SUM_WIDTH_0_16);
        s1_10 <= resize(act_0_46_16, SUM_WIDTH_0_16) + resize(act_0_47_16, SUM_WIDTH_0_16) + resize(act_0_48_16, SUM_WIDTH_0_16);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_16 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_16 <= saturate(sum_0_16, 16);
  end block;

  -- LAYER 0, ch 17
  gen_l0c17 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8 : sum_t_0_17;
  signal s2_0, s2_1, s2_2 : sum_t_0_17;
  signal sum_0_17 : sum_t_0_17;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_17.mem") port map (clk, input(0), act_0_0_17);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_17.mem") port map (clk, input(1), act_0_1_17);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_17.mem") port map (clk, input(2), act_0_2_17);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_17.mem") port map (clk, input(3), act_0_3_17);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_17.mem") port map (clk, input(4), act_0_4_17);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_17.mem") port map (clk, input(6), act_0_6_17);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_17.mem") port map (clk, input(8), act_0_8_17);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_17.mem") port map (clk, input(9), act_0_9_17);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_17.mem") port map (clk, input(13), act_0_13_17);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_17.mem") port map (clk, input(14), act_0_14_17);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_17.mem") port map (clk, input(16), act_0_16_17);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_17.mem") port map (clk, input(17), act_0_17_17);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_17.mem") port map (clk, input(18), act_0_18_17);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_17.mem") port map (clk, input(19), act_0_19_17);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_17.mem") port map (clk, input(21), act_0_21_17);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_17.mem") port map (clk, input(22), act_0_22_17);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_17.mem") port map (clk, input(23), act_0_23_17);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_17.mem") port map (clk, input(24), act_0_24_17);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_17.mem") port map (clk, input(25), act_0_25_17);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_17.mem") port map (clk, input(29), act_0_29_17);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_17.mem") port map (clk, input(30), act_0_30_17);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_17.mem") port map (clk, input(31), act_0_31_17);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_17.mem") port map (clk, input(33), act_0_33_17);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_17.mem") port map (clk, input(34), act_0_34_17);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_17.mem") port map (clk, input(35), act_0_35_17);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_17.mem") port map (clk, input(36), act_0_36_17);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_17.mem") port map (clk, input(37), act_0_37_17);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_17.mem") port map (clk, input(39), act_0_39_17);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_17.mem") port map (clk, input(41), act_0_41_17);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_17.mem") port map (clk, input(43), act_0_43_17);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_17.mem") port map (clk, input(44), act_0_44_17);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_17.mem") port map (clk, input(45), act_0_45_17);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_17.mem") port map (clk, input(46), act_0_46_17);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_17.mem") port map (clk, input(47), act_0_47_17);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_17.mem") port map (clk, input(48), act_0_48_17);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_17.mem") port map (clk, input(49), act_0_49_17);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_17, SUM_WIDTH_0_17) + resize(act_0_1_17, SUM_WIDTH_0_17) + resize(act_0_2_17, SUM_WIDTH_0_17) + resize(act_0_3_17, SUM_WIDTH_0_17);
        s1_1 <= resize(act_0_4_17, SUM_WIDTH_0_17) + resize(act_0_6_17, SUM_WIDTH_0_17) + resize(act_0_8_17, SUM_WIDTH_0_17) + resize(act_0_9_17, SUM_WIDTH_0_17);
        s1_2 <= resize(act_0_13_17, SUM_WIDTH_0_17) + resize(act_0_14_17, SUM_WIDTH_0_17) + resize(act_0_16_17, SUM_WIDTH_0_17) + resize(act_0_17_17, SUM_WIDTH_0_17);
        s1_3 <= resize(act_0_18_17, SUM_WIDTH_0_17) + resize(act_0_19_17, SUM_WIDTH_0_17) + resize(act_0_21_17, SUM_WIDTH_0_17) + resize(act_0_22_17, SUM_WIDTH_0_17);
        s1_4 <= resize(act_0_23_17, SUM_WIDTH_0_17) + resize(act_0_24_17, SUM_WIDTH_0_17) + resize(act_0_25_17, SUM_WIDTH_0_17) + resize(act_0_29_17, SUM_WIDTH_0_17);
        s1_5 <= resize(act_0_30_17, SUM_WIDTH_0_17) + resize(act_0_31_17, SUM_WIDTH_0_17) + resize(act_0_33_17, SUM_WIDTH_0_17) + resize(act_0_34_17, SUM_WIDTH_0_17);
        s1_6 <= resize(act_0_35_17, SUM_WIDTH_0_17) + resize(act_0_36_17, SUM_WIDTH_0_17) + resize(act_0_37_17, SUM_WIDTH_0_17) + resize(act_0_39_17, SUM_WIDTH_0_17);
        s1_7 <= resize(act_0_41_17, SUM_WIDTH_0_17) + resize(act_0_43_17, SUM_WIDTH_0_17) + resize(act_0_44_17, SUM_WIDTH_0_17) + resize(act_0_45_17, SUM_WIDTH_0_17);
        s1_8 <= resize(act_0_46_17, SUM_WIDTH_0_17) + resize(act_0_47_17, SUM_WIDTH_0_17) + resize(act_0_48_17, SUM_WIDTH_0_17) + resize(act_0_49_17, SUM_WIDTH_0_17);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8;
        -- Stage 3
        sum_0_17 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_17 <= saturate(sum_0_17, 16);
  end block;

  -- LAYER 0, ch 18
  gen_l0c18 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_18;
  signal s2_0, s2_1, s2_2 : sum_t_0_18;
  signal sum_0_18 : sum_t_0_18;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_18.mem") port map (clk, input(0), act_0_0_18);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_18.mem") port map (clk, input(1), act_0_1_18);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_18.mem") port map (clk, input(2), act_0_2_18);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_18.mem") port map (clk, input(3), act_0_3_18);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_18.mem") port map (clk, input(4), act_0_4_18);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_18.mem") port map (clk, input(5), act_0_5_18);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_18.mem") port map (clk, input(7), act_0_7_18);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_18.mem") port map (clk, input(8), act_0_8_18);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_18.mem") port map (clk, input(10), act_0_10_18);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_18.mem") port map (clk, input(11), act_0_11_18);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_18.mem") port map (clk, input(12), act_0_12_18);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_18.mem") port map (clk, input(13), act_0_13_18);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_18.mem") port map (clk, input(14), act_0_14_18);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_18.mem") port map (clk, input(15), act_0_15_18);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_18.mem") port map (clk, input(16), act_0_16_18);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_18.mem") port map (clk, input(17), act_0_17_18);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_18.mem") port map (clk, input(18), act_0_18_18);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_18.mem") port map (clk, input(19), act_0_19_18);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_18.mem") port map (clk, input(21), act_0_21_18);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_18.mem") port map (clk, input(22), act_0_22_18);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_18.mem") port map (clk, input(23), act_0_23_18);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_18.mem") port map (clk, input(24), act_0_24_18);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_18.mem") port map (clk, input(26), act_0_26_18);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_18.mem") port map (clk, input(27), act_0_27_18);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_18.mem") port map (clk, input(28), act_0_28_18);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_18.mem") port map (clk, input(29), act_0_29_18);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_18.mem") port map (clk, input(30), act_0_30_18);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_18.mem") port map (clk, input(31), act_0_31_18);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_18.mem") port map (clk, input(32), act_0_32_18);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_18.mem") port map (clk, input(33), act_0_33_18);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_18.mem") port map (clk, input(35), act_0_35_18);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_18.mem") port map (clk, input(36), act_0_36_18);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_18.mem") port map (clk, input(37), act_0_37_18);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_18.mem") port map (clk, input(38), act_0_38_18);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_18.mem") port map (clk, input(40), act_0_40_18);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_18.mem") port map (clk, input(41), act_0_41_18);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_18.mem") port map (clk, input(42), act_0_42_18);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_18.mem") port map (clk, input(43), act_0_43_18);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_18.mem") port map (clk, input(44), act_0_44_18);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_18.mem") port map (clk, input(45), act_0_45_18);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_18.mem") port map (clk, input(46), act_0_46_18);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_18.mem") port map (clk, input(47), act_0_47_18);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_18.mem") port map (clk, input(48), act_0_48_18);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_18.mem") port map (clk, input(49), act_0_49_18);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_18, SUM_WIDTH_0_18) + resize(act_0_1_18, SUM_WIDTH_0_18) + resize(act_0_2_18, SUM_WIDTH_0_18) + resize(act_0_3_18, SUM_WIDTH_0_18);
        s1_1 <= resize(act_0_4_18, SUM_WIDTH_0_18) + resize(act_0_5_18, SUM_WIDTH_0_18) + resize(act_0_7_18, SUM_WIDTH_0_18) + resize(act_0_8_18, SUM_WIDTH_0_18);
        s1_2 <= resize(act_0_10_18, SUM_WIDTH_0_18) + resize(act_0_11_18, SUM_WIDTH_0_18) + resize(act_0_12_18, SUM_WIDTH_0_18) + resize(act_0_13_18, SUM_WIDTH_0_18);
        s1_3 <= resize(act_0_14_18, SUM_WIDTH_0_18) + resize(act_0_15_18, SUM_WIDTH_0_18) + resize(act_0_16_18, SUM_WIDTH_0_18) + resize(act_0_17_18, SUM_WIDTH_0_18);
        s1_4 <= resize(act_0_18_18, SUM_WIDTH_0_18) + resize(act_0_19_18, SUM_WIDTH_0_18) + resize(act_0_21_18, SUM_WIDTH_0_18) + resize(act_0_22_18, SUM_WIDTH_0_18);
        s1_5 <= resize(act_0_23_18, SUM_WIDTH_0_18) + resize(act_0_24_18, SUM_WIDTH_0_18) + resize(act_0_26_18, SUM_WIDTH_0_18) + resize(act_0_27_18, SUM_WIDTH_0_18);
        s1_6 <= resize(act_0_28_18, SUM_WIDTH_0_18) + resize(act_0_29_18, SUM_WIDTH_0_18) + resize(act_0_30_18, SUM_WIDTH_0_18) + resize(act_0_31_18, SUM_WIDTH_0_18);
        s1_7 <= resize(act_0_32_18, SUM_WIDTH_0_18) + resize(act_0_33_18, SUM_WIDTH_0_18) + resize(act_0_35_18, SUM_WIDTH_0_18) + resize(act_0_36_18, SUM_WIDTH_0_18);
        s1_8 <= resize(act_0_37_18, SUM_WIDTH_0_18) + resize(act_0_38_18, SUM_WIDTH_0_18) + resize(act_0_40_18, SUM_WIDTH_0_18) + resize(act_0_41_18, SUM_WIDTH_0_18);
        s1_9 <= resize(act_0_42_18, SUM_WIDTH_0_18) + resize(act_0_43_18, SUM_WIDTH_0_18) + resize(act_0_44_18, SUM_WIDTH_0_18) + resize(act_0_45_18, SUM_WIDTH_0_18);
        s1_10 <= resize(act_0_46_18, SUM_WIDTH_0_18) + resize(act_0_47_18, SUM_WIDTH_0_18) + resize(act_0_48_18, SUM_WIDTH_0_18) + resize(act_0_49_18, SUM_WIDTH_0_18);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_18 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_18 <= saturate(sum_0_18, 16);
  end block;

  -- LAYER 0, ch 19
  gen_l0c19 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_19;
  signal s2_0, s2_1, s2_2 : sum_t_0_19;
  signal sum_0_19 : sum_t_0_19;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_19.mem") port map (clk, input(1), act_0_1_19);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_19.mem") port map (clk, input(3), act_0_3_19);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_19.mem") port map (clk, input(5), act_0_5_19);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_19.mem") port map (clk, input(6), act_0_6_19);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_19.mem") port map (clk, input(8), act_0_8_19);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_19.mem") port map (clk, input(9), act_0_9_19);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_19.mem") port map (clk, input(11), act_0_11_19);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_19.mem") port map (clk, input(12), act_0_12_19);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_19.mem") port map (clk, input(14), act_0_14_19);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_19.mem") port map (clk, input(15), act_0_15_19);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_19.mem") port map (clk, input(16), act_0_16_19);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_19.mem") port map (clk, input(17), act_0_17_19);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_19.mem") port map (clk, input(18), act_0_18_19);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_19.mem") port map (clk, input(19), act_0_19_19);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_19.mem") port map (clk, input(22), act_0_22_19);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_19.mem") port map (clk, input(23), act_0_23_19);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_19.mem") port map (clk, input(24), act_0_24_19);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_19.mem") port map (clk, input(26), act_0_26_19);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_19.mem") port map (clk, input(27), act_0_27_19);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_19.mem") port map (clk, input(28), act_0_28_19);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_19.mem") port map (clk, input(29), act_0_29_19);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_19.mem") port map (clk, input(30), act_0_30_19);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_19.mem") port map (clk, input(31), act_0_31_19);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_19.mem") port map (clk, input(32), act_0_32_19);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_19.mem") port map (clk, input(33), act_0_33_19);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_19.mem") port map (clk, input(34), act_0_34_19);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_19.mem") port map (clk, input(35), act_0_35_19);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_19.mem") port map (clk, input(36), act_0_36_19);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_19.mem") port map (clk, input(37), act_0_37_19);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_19.mem") port map (clk, input(38), act_0_38_19);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_19.mem") port map (clk, input(39), act_0_39_19);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_19.mem") port map (clk, input(40), act_0_40_19);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_19.mem") port map (clk, input(41), act_0_41_19);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_19.mem") port map (clk, input(42), act_0_42_19);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_19.mem") port map (clk, input(43), act_0_43_19);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_19.mem") port map (clk, input(44), act_0_44_19);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_19.mem") port map (clk, input(46), act_0_46_19);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_19.mem") port map (clk, input(47), act_0_47_19);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_19.mem") port map (clk, input(48), act_0_48_19);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_19.mem") port map (clk, input(49), act_0_49_19);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_19, SUM_WIDTH_0_19) + resize(act_0_3_19, SUM_WIDTH_0_19) + resize(act_0_5_19, SUM_WIDTH_0_19) + resize(act_0_6_19, SUM_WIDTH_0_19);
        s1_1 <= resize(act_0_8_19, SUM_WIDTH_0_19) + resize(act_0_9_19, SUM_WIDTH_0_19) + resize(act_0_11_19, SUM_WIDTH_0_19) + resize(act_0_12_19, SUM_WIDTH_0_19);
        s1_2 <= resize(act_0_14_19, SUM_WIDTH_0_19) + resize(act_0_15_19, SUM_WIDTH_0_19) + resize(act_0_16_19, SUM_WIDTH_0_19) + resize(act_0_17_19, SUM_WIDTH_0_19);
        s1_3 <= resize(act_0_18_19, SUM_WIDTH_0_19) + resize(act_0_19_19, SUM_WIDTH_0_19) + resize(act_0_22_19, SUM_WIDTH_0_19) + resize(act_0_23_19, SUM_WIDTH_0_19);
        s1_4 <= resize(act_0_24_19, SUM_WIDTH_0_19) + resize(act_0_26_19, SUM_WIDTH_0_19) + resize(act_0_27_19, SUM_WIDTH_0_19) + resize(act_0_28_19, SUM_WIDTH_0_19);
        s1_5 <= resize(act_0_29_19, SUM_WIDTH_0_19) + resize(act_0_30_19, SUM_WIDTH_0_19) + resize(act_0_31_19, SUM_WIDTH_0_19) + resize(act_0_32_19, SUM_WIDTH_0_19);
        s1_6 <= resize(act_0_33_19, SUM_WIDTH_0_19) + resize(act_0_34_19, SUM_WIDTH_0_19) + resize(act_0_35_19, SUM_WIDTH_0_19) + resize(act_0_36_19, SUM_WIDTH_0_19);
        s1_7 <= resize(act_0_37_19, SUM_WIDTH_0_19) + resize(act_0_38_19, SUM_WIDTH_0_19) + resize(act_0_39_19, SUM_WIDTH_0_19) + resize(act_0_40_19, SUM_WIDTH_0_19);
        s1_8 <= resize(act_0_41_19, SUM_WIDTH_0_19) + resize(act_0_42_19, SUM_WIDTH_0_19) + resize(act_0_43_19, SUM_WIDTH_0_19) + resize(act_0_44_19, SUM_WIDTH_0_19);
        s1_9 <= resize(act_0_46_19, SUM_WIDTH_0_19) + resize(act_0_47_19, SUM_WIDTH_0_19) + resize(act_0_48_19, SUM_WIDTH_0_19) + resize(act_0_49_19, SUM_WIDTH_0_19);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_19 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_19 <= saturate(sum_0_19, 16);
  end block;

  -- LAYER 0, ch 20
  gen_l0c20 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_20;
  signal s2_0, s2_1, s2_2 : sum_t_0_20;
  signal sum_0_20 : sum_t_0_20;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_20.mem") port map (clk, input(0), act_0_0_20);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_20.mem") port map (clk, input(1), act_0_1_20);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_20.mem") port map (clk, input(2), act_0_2_20);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_20.mem") port map (clk, input(3), act_0_3_20);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_20.mem") port map (clk, input(5), act_0_5_20);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_20.mem") port map (clk, input(6), act_0_6_20);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_20.mem") port map (clk, input(7), act_0_7_20);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_20.mem") port map (clk, input(8), act_0_8_20);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_20.mem") port map (clk, input(9), act_0_9_20);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_20.mem") port map (clk, input(11), act_0_11_20);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_20.mem") port map (clk, input(12), act_0_12_20);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_20.mem") port map (clk, input(13), act_0_13_20);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_20.mem") port map (clk, input(15), act_0_15_20);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_20.mem") port map (clk, input(16), act_0_16_20);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_20.mem") port map (clk, input(17), act_0_17_20);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_20.mem") port map (clk, input(18), act_0_18_20);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_20.mem") port map (clk, input(19), act_0_19_20);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_20.mem") port map (clk, input(20), act_0_20_20);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_20.mem") port map (clk, input(21), act_0_21_20);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_20.mem") port map (clk, input(22), act_0_22_20);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_20.mem") port map (clk, input(23), act_0_23_20);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_20.mem") port map (clk, input(27), act_0_27_20);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_20.mem") port map (clk, input(28), act_0_28_20);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_20.mem") port map (clk, input(29), act_0_29_20);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_20.mem") port map (clk, input(30), act_0_30_20);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_20.mem") port map (clk, input(32), act_0_32_20);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_20.mem") port map (clk, input(33), act_0_33_20);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_20.mem") port map (clk, input(34), act_0_34_20);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_20.mem") port map (clk, input(35), act_0_35_20);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_20.mem") port map (clk, input(36), act_0_36_20);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_20.mem") port map (clk, input(37), act_0_37_20);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_20.mem") port map (clk, input(38), act_0_38_20);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_20.mem") port map (clk, input(39), act_0_39_20);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_20.mem") port map (clk, input(40), act_0_40_20);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_20.mem") port map (clk, input(42), act_0_42_20);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_20.mem") port map (clk, input(43), act_0_43_20);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_20.mem") port map (clk, input(44), act_0_44_20);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_20.mem") port map (clk, input(45), act_0_45_20);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_20.mem") port map (clk, input(46), act_0_46_20);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_20.mem") port map (clk, input(47), act_0_47_20);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_20.mem") port map (clk, input(49), act_0_49_20);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_20, SUM_WIDTH_0_20) + resize(act_0_1_20, SUM_WIDTH_0_20) + resize(act_0_2_20, SUM_WIDTH_0_20) + resize(act_0_3_20, SUM_WIDTH_0_20);
        s1_1 <= resize(act_0_5_20, SUM_WIDTH_0_20) + resize(act_0_6_20, SUM_WIDTH_0_20) + resize(act_0_7_20, SUM_WIDTH_0_20) + resize(act_0_8_20, SUM_WIDTH_0_20);
        s1_2 <= resize(act_0_9_20, SUM_WIDTH_0_20) + resize(act_0_11_20, SUM_WIDTH_0_20) + resize(act_0_12_20, SUM_WIDTH_0_20) + resize(act_0_13_20, SUM_WIDTH_0_20);
        s1_3 <= resize(act_0_15_20, SUM_WIDTH_0_20) + resize(act_0_16_20, SUM_WIDTH_0_20) + resize(act_0_17_20, SUM_WIDTH_0_20) + resize(act_0_18_20, SUM_WIDTH_0_20);
        s1_4 <= resize(act_0_19_20, SUM_WIDTH_0_20) + resize(act_0_20_20, SUM_WIDTH_0_20) + resize(act_0_21_20, SUM_WIDTH_0_20) + resize(act_0_22_20, SUM_WIDTH_0_20);
        s1_5 <= resize(act_0_23_20, SUM_WIDTH_0_20) + resize(act_0_27_20, SUM_WIDTH_0_20) + resize(act_0_28_20, SUM_WIDTH_0_20) + resize(act_0_29_20, SUM_WIDTH_0_20);
        s1_6 <= resize(act_0_30_20, SUM_WIDTH_0_20) + resize(act_0_32_20, SUM_WIDTH_0_20) + resize(act_0_33_20, SUM_WIDTH_0_20) + resize(act_0_34_20, SUM_WIDTH_0_20);
        s1_7 <= resize(act_0_35_20, SUM_WIDTH_0_20) + resize(act_0_36_20, SUM_WIDTH_0_20) + resize(act_0_37_20, SUM_WIDTH_0_20) + resize(act_0_38_20, SUM_WIDTH_0_20);
        s1_8 <= resize(act_0_39_20, SUM_WIDTH_0_20) + resize(act_0_40_20, SUM_WIDTH_0_20) + resize(act_0_42_20, SUM_WIDTH_0_20) + resize(act_0_43_20, SUM_WIDTH_0_20);
        s1_9 <= resize(act_0_44_20, SUM_WIDTH_0_20) + resize(act_0_45_20, SUM_WIDTH_0_20) + resize(act_0_46_20, SUM_WIDTH_0_20) + resize(act_0_47_20, SUM_WIDTH_0_20);
        s1_10 <= resize(act_0_49_20, SUM_WIDTH_0_20);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_20 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_20 <= saturate(sum_0_20, 16);
  end block;

  -- LAYER 0, ch 21
  gen_l0c21 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_21;
  signal s2_0, s2_1, s2_2 : sum_t_0_21;
  signal sum_0_21 : sum_t_0_21;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_21.mem") port map (clk, input(0), act_0_0_21);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_21.mem") port map (clk, input(2), act_0_2_21);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_21.mem") port map (clk, input(3), act_0_3_21);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_21.mem") port map (clk, input(4), act_0_4_21);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_21.mem") port map (clk, input(6), act_0_6_21);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_21.mem") port map (clk, input(8), act_0_8_21);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_21.mem") port map (clk, input(9), act_0_9_21);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_21.mem") port map (clk, input(10), act_0_10_21);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_21.mem") port map (clk, input(11), act_0_11_21);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_21.mem") port map (clk, input(12), act_0_12_21);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_21.mem") port map (clk, input(13), act_0_13_21);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_21.mem") port map (clk, input(14), act_0_14_21);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_21.mem") port map (clk, input(15), act_0_15_21);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_21.mem") port map (clk, input(16), act_0_16_21);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_21.mem") port map (clk, input(17), act_0_17_21);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_21.mem") port map (clk, input(18), act_0_18_21);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_21.mem") port map (clk, input(19), act_0_19_21);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_21.mem") port map (clk, input(20), act_0_20_21);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_21.mem") port map (clk, input(21), act_0_21_21);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_21.mem") port map (clk, input(22), act_0_22_21);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_21.mem") port map (clk, input(26), act_0_26_21);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_21.mem") port map (clk, input(27), act_0_27_21);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_21.mem") port map (clk, input(28), act_0_28_21);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_21.mem") port map (clk, input(29), act_0_29_21);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_21.mem") port map (clk, input(31), act_0_31_21);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_21.mem") port map (clk, input(32), act_0_32_21);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_21.mem") port map (clk, input(33), act_0_33_21);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_21.mem") port map (clk, input(34), act_0_34_21);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_21.mem") port map (clk, input(36), act_0_36_21);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_21.mem") port map (clk, input(37), act_0_37_21);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_21.mem") port map (clk, input(39), act_0_39_21);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_21.mem") port map (clk, input(40), act_0_40_21);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_21.mem") port map (clk, input(41), act_0_41_21);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_21.mem") port map (clk, input(42), act_0_42_21);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_21.mem") port map (clk, input(43), act_0_43_21);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_21.mem") port map (clk, input(44), act_0_44_21);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_21.mem") port map (clk, input(46), act_0_46_21);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_21.mem") port map (clk, input(47), act_0_47_21);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_21.mem") port map (clk, input(48), act_0_48_21);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_21.mem") port map (clk, input(49), act_0_49_21);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_21, SUM_WIDTH_0_21) + resize(act_0_2_21, SUM_WIDTH_0_21) + resize(act_0_3_21, SUM_WIDTH_0_21) + resize(act_0_4_21, SUM_WIDTH_0_21);
        s1_1 <= resize(act_0_6_21, SUM_WIDTH_0_21) + resize(act_0_8_21, SUM_WIDTH_0_21) + resize(act_0_9_21, SUM_WIDTH_0_21) + resize(act_0_10_21, SUM_WIDTH_0_21);
        s1_2 <= resize(act_0_11_21, SUM_WIDTH_0_21) + resize(act_0_12_21, SUM_WIDTH_0_21) + resize(act_0_13_21, SUM_WIDTH_0_21) + resize(act_0_14_21, SUM_WIDTH_0_21);
        s1_3 <= resize(act_0_15_21, SUM_WIDTH_0_21) + resize(act_0_16_21, SUM_WIDTH_0_21) + resize(act_0_17_21, SUM_WIDTH_0_21) + resize(act_0_18_21, SUM_WIDTH_0_21);
        s1_4 <= resize(act_0_19_21, SUM_WIDTH_0_21) + resize(act_0_20_21, SUM_WIDTH_0_21) + resize(act_0_21_21, SUM_WIDTH_0_21) + resize(act_0_22_21, SUM_WIDTH_0_21);
        s1_5 <= resize(act_0_26_21, SUM_WIDTH_0_21) + resize(act_0_27_21, SUM_WIDTH_0_21) + resize(act_0_28_21, SUM_WIDTH_0_21) + resize(act_0_29_21, SUM_WIDTH_0_21);
        s1_6 <= resize(act_0_31_21, SUM_WIDTH_0_21) + resize(act_0_32_21, SUM_WIDTH_0_21) + resize(act_0_33_21, SUM_WIDTH_0_21) + resize(act_0_34_21, SUM_WIDTH_0_21);
        s1_7 <= resize(act_0_36_21, SUM_WIDTH_0_21) + resize(act_0_37_21, SUM_WIDTH_0_21) + resize(act_0_39_21, SUM_WIDTH_0_21) + resize(act_0_40_21, SUM_WIDTH_0_21);
        s1_8 <= resize(act_0_41_21, SUM_WIDTH_0_21) + resize(act_0_42_21, SUM_WIDTH_0_21) + resize(act_0_43_21, SUM_WIDTH_0_21) + resize(act_0_44_21, SUM_WIDTH_0_21);
        s1_9 <= resize(act_0_46_21, SUM_WIDTH_0_21) + resize(act_0_47_21, SUM_WIDTH_0_21) + resize(act_0_48_21, SUM_WIDTH_0_21) + resize(act_0_49_21, SUM_WIDTH_0_21);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_21 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_21 <= saturate(sum_0_21, 16);
  end block;

  -- LAYER 0, ch 22
  gen_l0c22 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_22;
  signal s2_0, s2_1, s2_2 : sum_t_0_22;
  signal sum_0_22 : sum_t_0_22;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_22.mem") port map (clk, input(1), act_0_1_22);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_22.mem") port map (clk, input(2), act_0_2_22);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_22.mem") port map (clk, input(3), act_0_3_22);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_22.mem") port map (clk, input(4), act_0_4_22);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_22.mem") port map (clk, input(5), act_0_5_22);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_22.mem") port map (clk, input(6), act_0_6_22);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_22.mem") port map (clk, input(7), act_0_7_22);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_22.mem") port map (clk, input(8), act_0_8_22);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_22.mem") port map (clk, input(9), act_0_9_22);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_22.mem") port map (clk, input(10), act_0_10_22);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_22.mem") port map (clk, input(11), act_0_11_22);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_22.mem") port map (clk, input(12), act_0_12_22);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_22.mem") port map (clk, input(15), act_0_15_22);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_22.mem") port map (clk, input(16), act_0_16_22);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_22.mem") port map (clk, input(17), act_0_17_22);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_22.mem") port map (clk, input(18), act_0_18_22);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_22.mem") port map (clk, input(20), act_0_20_22);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_22.mem") port map (clk, input(21), act_0_21_22);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_22.mem") port map (clk, input(22), act_0_22_22);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_22.mem") port map (clk, input(24), act_0_24_22);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_22.mem") port map (clk, input(25), act_0_25_22);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_22.mem") port map (clk, input(26), act_0_26_22);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_22.mem") port map (clk, input(28), act_0_28_22);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_22.mem") port map (clk, input(30), act_0_30_22);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_22.mem") port map (clk, input(31), act_0_31_22);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_22.mem") port map (clk, input(33), act_0_33_22);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_22.mem") port map (clk, input(34), act_0_34_22);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_22.mem") port map (clk, input(35), act_0_35_22);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_22.mem") port map (clk, input(36), act_0_36_22);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_22.mem") port map (clk, input(37), act_0_37_22);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_22.mem") port map (clk, input(39), act_0_39_22);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_22.mem") port map (clk, input(40), act_0_40_22);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_22.mem") port map (clk, input(41), act_0_41_22);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_22.mem") port map (clk, input(42), act_0_42_22);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_22.mem") port map (clk, input(43), act_0_43_22);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_22.mem") port map (clk, input(44), act_0_44_22);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_22.mem") port map (clk, input(45), act_0_45_22);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_22.mem") port map (clk, input(46), act_0_46_22);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_22.mem") port map (clk, input(47), act_0_47_22);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_22, SUM_WIDTH_0_22) + resize(act_0_2_22, SUM_WIDTH_0_22) + resize(act_0_3_22, SUM_WIDTH_0_22) + resize(act_0_4_22, SUM_WIDTH_0_22);
        s1_1 <= resize(act_0_5_22, SUM_WIDTH_0_22) + resize(act_0_6_22, SUM_WIDTH_0_22) + resize(act_0_7_22, SUM_WIDTH_0_22) + resize(act_0_8_22, SUM_WIDTH_0_22);
        s1_2 <= resize(act_0_9_22, SUM_WIDTH_0_22) + resize(act_0_10_22, SUM_WIDTH_0_22) + resize(act_0_11_22, SUM_WIDTH_0_22) + resize(act_0_12_22, SUM_WIDTH_0_22);
        s1_3 <= resize(act_0_15_22, SUM_WIDTH_0_22) + resize(act_0_16_22, SUM_WIDTH_0_22) + resize(act_0_17_22, SUM_WIDTH_0_22) + resize(act_0_18_22, SUM_WIDTH_0_22);
        s1_4 <= resize(act_0_20_22, SUM_WIDTH_0_22) + resize(act_0_21_22, SUM_WIDTH_0_22) + resize(act_0_22_22, SUM_WIDTH_0_22) + resize(act_0_24_22, SUM_WIDTH_0_22);
        s1_5 <= resize(act_0_25_22, SUM_WIDTH_0_22) + resize(act_0_26_22, SUM_WIDTH_0_22) + resize(act_0_28_22, SUM_WIDTH_0_22) + resize(act_0_30_22, SUM_WIDTH_0_22);
        s1_6 <= resize(act_0_31_22, SUM_WIDTH_0_22) + resize(act_0_33_22, SUM_WIDTH_0_22) + resize(act_0_34_22, SUM_WIDTH_0_22) + resize(act_0_35_22, SUM_WIDTH_0_22);
        s1_7 <= resize(act_0_36_22, SUM_WIDTH_0_22) + resize(act_0_37_22, SUM_WIDTH_0_22) + resize(act_0_39_22, SUM_WIDTH_0_22) + resize(act_0_40_22, SUM_WIDTH_0_22);
        s1_8 <= resize(act_0_41_22, SUM_WIDTH_0_22) + resize(act_0_42_22, SUM_WIDTH_0_22) + resize(act_0_43_22, SUM_WIDTH_0_22) + resize(act_0_44_22, SUM_WIDTH_0_22);
        s1_9 <= resize(act_0_45_22, SUM_WIDTH_0_22) + resize(act_0_46_22, SUM_WIDTH_0_22) + resize(act_0_47_22, SUM_WIDTH_0_22);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_22 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_22 <= saturate(sum_0_22, 16);
  end block;

  -- LAYER 0, ch 23
  gen_l0c23 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_23;
  signal s2_0, s2_1, s2_2 : sum_t_0_23;
  signal sum_0_23 : sum_t_0_23;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_23.mem") port map (clk, input(0), act_0_0_23);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_23.mem") port map (clk, input(1), act_0_1_23);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_23.mem") port map (clk, input(2), act_0_2_23);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_23.mem") port map (clk, input(3), act_0_3_23);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_23.mem") port map (clk, input(5), act_0_5_23);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_23.mem") port map (clk, input(6), act_0_6_23);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_23.mem") port map (clk, input(7), act_0_7_23);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_23.mem") port map (clk, input(9), act_0_9_23);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_23.mem") port map (clk, input(11), act_0_11_23);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_23.mem") port map (clk, input(12), act_0_12_23);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_23.mem") port map (clk, input(13), act_0_13_23);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_23.mem") port map (clk, input(14), act_0_14_23);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_23.mem") port map (clk, input(15), act_0_15_23);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_23.mem") port map (clk, input(16), act_0_16_23);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_23.mem") port map (clk, input(17), act_0_17_23);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_23.mem") port map (clk, input(18), act_0_18_23);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_23.mem") port map (clk, input(20), act_0_20_23);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_23.mem") port map (clk, input(21), act_0_21_23);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_23.mem") port map (clk, input(25), act_0_25_23);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_23.mem") port map (clk, input(26), act_0_26_23);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_23.mem") port map (clk, input(27), act_0_27_23);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_23.mem") port map (clk, input(28), act_0_28_23);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_23.mem") port map (clk, input(29), act_0_29_23);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_23.mem") port map (clk, input(31), act_0_31_23);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_23.mem") port map (clk, input(32), act_0_32_23);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_23.mem") port map (clk, input(33), act_0_33_23);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_23.mem") port map (clk, input(35), act_0_35_23);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_23.mem") port map (clk, input(36), act_0_36_23);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_23.mem") port map (clk, input(37), act_0_37_23);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_23.mem") port map (clk, input(38), act_0_38_23);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_23.mem") port map (clk, input(39), act_0_39_23);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_23.mem") port map (clk, input(40), act_0_40_23);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_23.mem") port map (clk, input(41), act_0_41_23);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_23.mem") port map (clk, input(42), act_0_42_23);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_23.mem") port map (clk, input(43), act_0_43_23);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_23.mem") port map (clk, input(45), act_0_45_23);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_23.mem") port map (clk, input(46), act_0_46_23);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_23.mem") port map (clk, input(49), act_0_49_23);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_23, SUM_WIDTH_0_23) + resize(act_0_1_23, SUM_WIDTH_0_23) + resize(act_0_2_23, SUM_WIDTH_0_23) + resize(act_0_3_23, SUM_WIDTH_0_23);
        s1_1 <= resize(act_0_5_23, SUM_WIDTH_0_23) + resize(act_0_6_23, SUM_WIDTH_0_23) + resize(act_0_7_23, SUM_WIDTH_0_23) + resize(act_0_9_23, SUM_WIDTH_0_23);
        s1_2 <= resize(act_0_11_23, SUM_WIDTH_0_23) + resize(act_0_12_23, SUM_WIDTH_0_23) + resize(act_0_13_23, SUM_WIDTH_0_23) + resize(act_0_14_23, SUM_WIDTH_0_23);
        s1_3 <= resize(act_0_15_23, SUM_WIDTH_0_23) + resize(act_0_16_23, SUM_WIDTH_0_23) + resize(act_0_17_23, SUM_WIDTH_0_23) + resize(act_0_18_23, SUM_WIDTH_0_23);
        s1_4 <= resize(act_0_20_23, SUM_WIDTH_0_23) + resize(act_0_21_23, SUM_WIDTH_0_23) + resize(act_0_25_23, SUM_WIDTH_0_23) + resize(act_0_26_23, SUM_WIDTH_0_23);
        s1_5 <= resize(act_0_27_23, SUM_WIDTH_0_23) + resize(act_0_28_23, SUM_WIDTH_0_23) + resize(act_0_29_23, SUM_WIDTH_0_23) + resize(act_0_31_23, SUM_WIDTH_0_23);
        s1_6 <= resize(act_0_32_23, SUM_WIDTH_0_23) + resize(act_0_33_23, SUM_WIDTH_0_23) + resize(act_0_35_23, SUM_WIDTH_0_23) + resize(act_0_36_23, SUM_WIDTH_0_23);
        s1_7 <= resize(act_0_37_23, SUM_WIDTH_0_23) + resize(act_0_38_23, SUM_WIDTH_0_23) + resize(act_0_39_23, SUM_WIDTH_0_23) + resize(act_0_40_23, SUM_WIDTH_0_23);
        s1_8 <= resize(act_0_41_23, SUM_WIDTH_0_23) + resize(act_0_42_23, SUM_WIDTH_0_23) + resize(act_0_43_23, SUM_WIDTH_0_23) + resize(act_0_45_23, SUM_WIDTH_0_23);
        s1_9 <= resize(act_0_46_23, SUM_WIDTH_0_23) + resize(act_0_49_23, SUM_WIDTH_0_23);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_23 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_23 <= saturate(sum_0_23, 16);
  end block;

  -- LAYER 0, ch 24
  gen_l0c24 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_24;
  signal s2_0, s2_1, s2_2 : sum_t_0_24;
  signal sum_0_24 : sum_t_0_24;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_24.mem") port map (clk, input(0), act_0_0_24);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_24.mem") port map (clk, input(1), act_0_1_24);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_24.mem") port map (clk, input(2), act_0_2_24);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_24.mem") port map (clk, input(3), act_0_3_24);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_24.mem") port map (clk, input(4), act_0_4_24);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_24.mem") port map (clk, input(5), act_0_5_24);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_24.mem") port map (clk, input(6), act_0_6_24);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_24.mem") port map (clk, input(7), act_0_7_24);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_24.mem") port map (clk, input(8), act_0_8_24);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_24.mem") port map (clk, input(9), act_0_9_24);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_24.mem") port map (clk, input(11), act_0_11_24);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_24.mem") port map (clk, input(12), act_0_12_24);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_24.mem") port map (clk, input(13), act_0_13_24);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_24.mem") port map (clk, input(14), act_0_14_24);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_24.mem") port map (clk, input(15), act_0_15_24);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_24.mem") port map (clk, input(16), act_0_16_24);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_24.mem") port map (clk, input(17), act_0_17_24);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_24.mem") port map (clk, input(18), act_0_18_24);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_24.mem") port map (clk, input(19), act_0_19_24);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_24.mem") port map (clk, input(22), act_0_22_24);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_24.mem") port map (clk, input(24), act_0_24_24);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_24.mem") port map (clk, input(26), act_0_26_24);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_24.mem") port map (clk, input(27), act_0_27_24);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_24.mem") port map (clk, input(28), act_0_28_24);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_24.mem") port map (clk, input(31), act_0_31_24);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_24.mem") port map (clk, input(32), act_0_32_24);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_24.mem") port map (clk, input(33), act_0_33_24);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_24.mem") port map (clk, input(34), act_0_34_24);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_24.mem") port map (clk, input(35), act_0_35_24);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_24.mem") port map (clk, input(36), act_0_36_24);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_24.mem") port map (clk, input(37), act_0_37_24);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_24.mem") port map (clk, input(38), act_0_38_24);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_24.mem") port map (clk, input(39), act_0_39_24);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_24.mem") port map (clk, input(40), act_0_40_24);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_24.mem") port map (clk, input(41), act_0_41_24);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_24.mem") port map (clk, input(42), act_0_42_24);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_24.mem") port map (clk, input(43), act_0_43_24);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_24.mem") port map (clk, input(45), act_0_45_24);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_24.mem") port map (clk, input(47), act_0_47_24);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_24.mem") port map (clk, input(49), act_0_49_24);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_24, SUM_WIDTH_0_24) + resize(act_0_1_24, SUM_WIDTH_0_24) + resize(act_0_2_24, SUM_WIDTH_0_24) + resize(act_0_3_24, SUM_WIDTH_0_24);
        s1_1 <= resize(act_0_4_24, SUM_WIDTH_0_24) + resize(act_0_5_24, SUM_WIDTH_0_24) + resize(act_0_6_24, SUM_WIDTH_0_24) + resize(act_0_7_24, SUM_WIDTH_0_24);
        s1_2 <= resize(act_0_8_24, SUM_WIDTH_0_24) + resize(act_0_9_24, SUM_WIDTH_0_24) + resize(act_0_11_24, SUM_WIDTH_0_24) + resize(act_0_12_24, SUM_WIDTH_0_24);
        s1_3 <= resize(act_0_13_24, SUM_WIDTH_0_24) + resize(act_0_14_24, SUM_WIDTH_0_24) + resize(act_0_15_24, SUM_WIDTH_0_24) + resize(act_0_16_24, SUM_WIDTH_0_24);
        s1_4 <= resize(act_0_17_24, SUM_WIDTH_0_24) + resize(act_0_18_24, SUM_WIDTH_0_24) + resize(act_0_19_24, SUM_WIDTH_0_24) + resize(act_0_22_24, SUM_WIDTH_0_24);
        s1_5 <= resize(act_0_24_24, SUM_WIDTH_0_24) + resize(act_0_26_24, SUM_WIDTH_0_24) + resize(act_0_27_24, SUM_WIDTH_0_24) + resize(act_0_28_24, SUM_WIDTH_0_24);
        s1_6 <= resize(act_0_31_24, SUM_WIDTH_0_24) + resize(act_0_32_24, SUM_WIDTH_0_24) + resize(act_0_33_24, SUM_WIDTH_0_24) + resize(act_0_34_24, SUM_WIDTH_0_24);
        s1_7 <= resize(act_0_35_24, SUM_WIDTH_0_24) + resize(act_0_36_24, SUM_WIDTH_0_24) + resize(act_0_37_24, SUM_WIDTH_0_24) + resize(act_0_38_24, SUM_WIDTH_0_24);
        s1_8 <= resize(act_0_39_24, SUM_WIDTH_0_24) + resize(act_0_40_24, SUM_WIDTH_0_24) + resize(act_0_41_24, SUM_WIDTH_0_24) + resize(act_0_42_24, SUM_WIDTH_0_24);
        s1_9 <= resize(act_0_43_24, SUM_WIDTH_0_24) + resize(act_0_45_24, SUM_WIDTH_0_24) + resize(act_0_47_24, SUM_WIDTH_0_24) + resize(act_0_49_24, SUM_WIDTH_0_24);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_24 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_24 <= saturate(sum_0_24, 16);
  end block;

  -- LAYER 0, ch 25
  gen_l0c25 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_25;
  signal s2_0, s2_1, s2_2 : sum_t_0_25;
  signal sum_0_25 : sum_t_0_25;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_25.mem") port map (clk, input(1), act_0_1_25);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_25.mem") port map (clk, input(2), act_0_2_25);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_25.mem") port map (clk, input(3), act_0_3_25);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_25.mem") port map (clk, input(4), act_0_4_25);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_25.mem") port map (clk, input(5), act_0_5_25);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_25.mem") port map (clk, input(6), act_0_6_25);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_25.mem") port map (clk, input(7), act_0_7_25);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_25.mem") port map (clk, input(8), act_0_8_25);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_25.mem") port map (clk, input(10), act_0_10_25);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_25.mem") port map (clk, input(11), act_0_11_25);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_25.mem") port map (clk, input(12), act_0_12_25);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_25.mem") port map (clk, input(13), act_0_13_25);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_25.mem") port map (clk, input(14), act_0_14_25);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_25.mem") port map (clk, input(15), act_0_15_25);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_25.mem") port map (clk, input(16), act_0_16_25);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_25.mem") port map (clk, input(17), act_0_17_25);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_25.mem") port map (clk, input(18), act_0_18_25);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_25.mem") port map (clk, input(19), act_0_19_25);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_25.mem") port map (clk, input(20), act_0_20_25);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_25.mem") port map (clk, input(21), act_0_21_25);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_25.mem") port map (clk, input(22), act_0_22_25);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_25.mem") port map (clk, input(23), act_0_23_25);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_25.mem") port map (clk, input(24), act_0_24_25);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_25.mem") port map (clk, input(26), act_0_26_25);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_25.mem") port map (clk, input(27), act_0_27_25);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_25.mem") port map (clk, input(28), act_0_28_25);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_25.mem") port map (clk, input(29), act_0_29_25);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_25.mem") port map (clk, input(30), act_0_30_25);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_25.mem") port map (clk, input(32), act_0_32_25);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_25.mem") port map (clk, input(33), act_0_33_25);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_25.mem") port map (clk, input(34), act_0_34_25);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_25.mem") port map (clk, input(36), act_0_36_25);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_25.mem") port map (clk, input(38), act_0_38_25);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_25.mem") port map (clk, input(40), act_0_40_25);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_25.mem") port map (clk, input(42), act_0_42_25);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_25.mem") port map (clk, input(43), act_0_43_25);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_25.mem") port map (clk, input(44), act_0_44_25);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_25.mem") port map (clk, input(45), act_0_45_25);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_25.mem") port map (clk, input(46), act_0_46_25);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_25.mem") port map (clk, input(47), act_0_47_25);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_25.mem") port map (clk, input(48), act_0_48_25);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_25.mem") port map (clk, input(49), act_0_49_25);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_25, SUM_WIDTH_0_25) + resize(act_0_2_25, SUM_WIDTH_0_25) + resize(act_0_3_25, SUM_WIDTH_0_25) + resize(act_0_4_25, SUM_WIDTH_0_25);
        s1_1 <= resize(act_0_5_25, SUM_WIDTH_0_25) + resize(act_0_6_25, SUM_WIDTH_0_25) + resize(act_0_7_25, SUM_WIDTH_0_25) + resize(act_0_8_25, SUM_WIDTH_0_25);
        s1_2 <= resize(act_0_10_25, SUM_WIDTH_0_25) + resize(act_0_11_25, SUM_WIDTH_0_25) + resize(act_0_12_25, SUM_WIDTH_0_25) + resize(act_0_13_25, SUM_WIDTH_0_25);
        s1_3 <= resize(act_0_14_25, SUM_WIDTH_0_25) + resize(act_0_15_25, SUM_WIDTH_0_25) + resize(act_0_16_25, SUM_WIDTH_0_25) + resize(act_0_17_25, SUM_WIDTH_0_25);
        s1_4 <= resize(act_0_18_25, SUM_WIDTH_0_25) + resize(act_0_19_25, SUM_WIDTH_0_25) + resize(act_0_20_25, SUM_WIDTH_0_25) + resize(act_0_21_25, SUM_WIDTH_0_25);
        s1_5 <= resize(act_0_22_25, SUM_WIDTH_0_25) + resize(act_0_23_25, SUM_WIDTH_0_25) + resize(act_0_24_25, SUM_WIDTH_0_25) + resize(act_0_26_25, SUM_WIDTH_0_25);
        s1_6 <= resize(act_0_27_25, SUM_WIDTH_0_25) + resize(act_0_28_25, SUM_WIDTH_0_25) + resize(act_0_29_25, SUM_WIDTH_0_25) + resize(act_0_30_25, SUM_WIDTH_0_25);
        s1_7 <= resize(act_0_32_25, SUM_WIDTH_0_25) + resize(act_0_33_25, SUM_WIDTH_0_25) + resize(act_0_34_25, SUM_WIDTH_0_25) + resize(act_0_36_25, SUM_WIDTH_0_25);
        s1_8 <= resize(act_0_38_25, SUM_WIDTH_0_25) + resize(act_0_40_25, SUM_WIDTH_0_25) + resize(act_0_42_25, SUM_WIDTH_0_25) + resize(act_0_43_25, SUM_WIDTH_0_25);
        s1_9 <= resize(act_0_44_25, SUM_WIDTH_0_25) + resize(act_0_45_25, SUM_WIDTH_0_25) + resize(act_0_46_25, SUM_WIDTH_0_25) + resize(act_0_47_25, SUM_WIDTH_0_25);
        s1_10 <= resize(act_0_48_25, SUM_WIDTH_0_25) + resize(act_0_49_25, SUM_WIDTH_0_25);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_25 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_25 <= saturate(sum_0_25, 16);
  end block;

  -- LAYER 0, ch 26
  gen_l0c26 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8 : sum_t_0_26;
  signal s2_0, s2_1, s2_2 : sum_t_0_26;
  signal sum_0_26 : sum_t_0_26;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_26.mem") port map (clk, input(3), act_0_3_26);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_26.mem") port map (clk, input(5), act_0_5_26);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_26.mem") port map (clk, input(6), act_0_6_26);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_26.mem") port map (clk, input(7), act_0_7_26);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_26.mem") port map (clk, input(8), act_0_8_26);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_26.mem") port map (clk, input(9), act_0_9_26);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_26.mem") port map (clk, input(10), act_0_10_26);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_26.mem") port map (clk, input(11), act_0_11_26);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_26.mem") port map (clk, input(12), act_0_12_26);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_26.mem") port map (clk, input(13), act_0_13_26);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_26.mem") port map (clk, input(14), act_0_14_26);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_26.mem") port map (clk, input(16), act_0_16_26);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_26.mem") port map (clk, input(17), act_0_17_26);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_26.mem") port map (clk, input(18), act_0_18_26);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_26.mem") port map (clk, input(19), act_0_19_26);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_26.mem") port map (clk, input(24), act_0_24_26);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_26.mem") port map (clk, input(25), act_0_25_26);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_26.mem") port map (clk, input(26), act_0_26_26);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_26.mem") port map (clk, input(28), act_0_28_26);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_26.mem") port map (clk, input(30), act_0_30_26);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_26.mem") port map (clk, input(31), act_0_31_26);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_26.mem") port map (clk, input(32), act_0_32_26);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_26.mem") port map (clk, input(33), act_0_33_26);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_26.mem") port map (clk, input(34), act_0_34_26);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_26.mem") port map (clk, input(35), act_0_35_26);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_26.mem") port map (clk, input(36), act_0_36_26);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_26.mem") port map (clk, input(37), act_0_37_26);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_26.mem") port map (clk, input(38), act_0_38_26);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_26.mem") port map (clk, input(42), act_0_42_26);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_26.mem") port map (clk, input(43), act_0_43_26);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_26.mem") port map (clk, input(45), act_0_45_26);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_26.mem") port map (clk, input(46), act_0_46_26);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_26.mem") port map (clk, input(47), act_0_47_26);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_26.mem") port map (clk, input(49), act_0_49_26);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_3_26, SUM_WIDTH_0_26) + resize(act_0_5_26, SUM_WIDTH_0_26) + resize(act_0_6_26, SUM_WIDTH_0_26) + resize(act_0_7_26, SUM_WIDTH_0_26);
        s1_1 <= resize(act_0_8_26, SUM_WIDTH_0_26) + resize(act_0_9_26, SUM_WIDTH_0_26) + resize(act_0_10_26, SUM_WIDTH_0_26) + resize(act_0_11_26, SUM_WIDTH_0_26);
        s1_2 <= resize(act_0_12_26, SUM_WIDTH_0_26) + resize(act_0_13_26, SUM_WIDTH_0_26) + resize(act_0_14_26, SUM_WIDTH_0_26) + resize(act_0_16_26, SUM_WIDTH_0_26);
        s1_3 <= resize(act_0_17_26, SUM_WIDTH_0_26) + resize(act_0_18_26, SUM_WIDTH_0_26) + resize(act_0_19_26, SUM_WIDTH_0_26) + resize(act_0_24_26, SUM_WIDTH_0_26);
        s1_4 <= resize(act_0_25_26, SUM_WIDTH_0_26) + resize(act_0_26_26, SUM_WIDTH_0_26) + resize(act_0_28_26, SUM_WIDTH_0_26) + resize(act_0_30_26, SUM_WIDTH_0_26);
        s1_5 <= resize(act_0_31_26, SUM_WIDTH_0_26) + resize(act_0_32_26, SUM_WIDTH_0_26) + resize(act_0_33_26, SUM_WIDTH_0_26) + resize(act_0_34_26, SUM_WIDTH_0_26);
        s1_6 <= resize(act_0_35_26, SUM_WIDTH_0_26) + resize(act_0_36_26, SUM_WIDTH_0_26) + resize(act_0_37_26, SUM_WIDTH_0_26) + resize(act_0_38_26, SUM_WIDTH_0_26);
        s1_7 <= resize(act_0_42_26, SUM_WIDTH_0_26) + resize(act_0_43_26, SUM_WIDTH_0_26) + resize(act_0_45_26, SUM_WIDTH_0_26) + resize(act_0_46_26, SUM_WIDTH_0_26);
        s1_8 <= resize(act_0_47_26, SUM_WIDTH_0_26) + resize(act_0_49_26, SUM_WIDTH_0_26);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8;
        -- Stage 3
        sum_0_26 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_26 <= saturate(sum_0_26, 16);
  end block;

  -- LAYER 0, ch 27
  gen_l0c27 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_27;
  signal s2_0, s2_1, s2_2 : sum_t_0_27;
  signal sum_0_27 : sum_t_0_27;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_27.mem") port map (clk, input(1), act_0_1_27);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_27.mem") port map (clk, input(3), act_0_3_27);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_27.mem") port map (clk, input(4), act_0_4_27);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_27.mem") port map (clk, input(6), act_0_6_27);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_27.mem") port map (clk, input(7), act_0_7_27);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_27.mem") port map (clk, input(8), act_0_8_27);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_27.mem") port map (clk, input(9), act_0_9_27);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_27.mem") port map (clk, input(10), act_0_10_27);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_27.mem") port map (clk, input(11), act_0_11_27);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_27.mem") port map (clk, input(12), act_0_12_27);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_27.mem") port map (clk, input(13), act_0_13_27);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_27.mem") port map (clk, input(14), act_0_14_27);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_27.mem") port map (clk, input(15), act_0_15_27);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_27.mem") port map (clk, input(16), act_0_16_27);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_27.mem") port map (clk, input(17), act_0_17_27);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_27.mem") port map (clk, input(18), act_0_18_27);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_27.mem") port map (clk, input(19), act_0_19_27);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_27.mem") port map (clk, input(20), act_0_20_27);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_27.mem") port map (clk, input(21), act_0_21_27);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_27.mem") port map (clk, input(22), act_0_22_27);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_27.mem") port map (clk, input(23), act_0_23_27);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_27.mem") port map (clk, input(24), act_0_24_27);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_27.mem") port map (clk, input(25), act_0_25_27);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_27.mem") port map (clk, input(27), act_0_27_27);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_27.mem") port map (clk, input(28), act_0_28_27);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_27.mem") port map (clk, input(29), act_0_29_27);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_27.mem") port map (clk, input(31), act_0_31_27);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_27.mem") port map (clk, input(33), act_0_33_27);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_27.mem") port map (clk, input(34), act_0_34_27);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_27.mem") port map (clk, input(35), act_0_35_27);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_27.mem") port map (clk, input(36), act_0_36_27);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_27.mem") port map (clk, input(37), act_0_37_27);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_27.mem") port map (clk, input(38), act_0_38_27);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_27.mem") port map (clk, input(39), act_0_39_27);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_27.mem") port map (clk, input(40), act_0_40_27);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_27.mem") port map (clk, input(41), act_0_41_27);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_27.mem") port map (clk, input(42), act_0_42_27);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_27.mem") port map (clk, input(43), act_0_43_27);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_27.mem") port map (clk, input(44), act_0_44_27);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_27.mem") port map (clk, input(45), act_0_45_27);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_27.mem") port map (clk, input(46), act_0_46_27);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_27.mem") port map (clk, input(47), act_0_47_27);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_27.mem") port map (clk, input(48), act_0_48_27);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_27.mem") port map (clk, input(49), act_0_49_27);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_27, SUM_WIDTH_0_27) + resize(act_0_3_27, SUM_WIDTH_0_27) + resize(act_0_4_27, SUM_WIDTH_0_27) + resize(act_0_6_27, SUM_WIDTH_0_27);
        s1_1 <= resize(act_0_7_27, SUM_WIDTH_0_27) + resize(act_0_8_27, SUM_WIDTH_0_27) + resize(act_0_9_27, SUM_WIDTH_0_27) + resize(act_0_10_27, SUM_WIDTH_0_27);
        s1_2 <= resize(act_0_11_27, SUM_WIDTH_0_27) + resize(act_0_12_27, SUM_WIDTH_0_27) + resize(act_0_13_27, SUM_WIDTH_0_27) + resize(act_0_14_27, SUM_WIDTH_0_27);
        s1_3 <= resize(act_0_15_27, SUM_WIDTH_0_27) + resize(act_0_16_27, SUM_WIDTH_0_27) + resize(act_0_17_27, SUM_WIDTH_0_27) + resize(act_0_18_27, SUM_WIDTH_0_27);
        s1_4 <= resize(act_0_19_27, SUM_WIDTH_0_27) + resize(act_0_20_27, SUM_WIDTH_0_27) + resize(act_0_21_27, SUM_WIDTH_0_27) + resize(act_0_22_27, SUM_WIDTH_0_27);
        s1_5 <= resize(act_0_23_27, SUM_WIDTH_0_27) + resize(act_0_24_27, SUM_WIDTH_0_27) + resize(act_0_25_27, SUM_WIDTH_0_27) + resize(act_0_27_27, SUM_WIDTH_0_27);
        s1_6 <= resize(act_0_28_27, SUM_WIDTH_0_27) + resize(act_0_29_27, SUM_WIDTH_0_27) + resize(act_0_31_27, SUM_WIDTH_0_27) + resize(act_0_33_27, SUM_WIDTH_0_27);
        s1_7 <= resize(act_0_34_27, SUM_WIDTH_0_27) + resize(act_0_35_27, SUM_WIDTH_0_27) + resize(act_0_36_27, SUM_WIDTH_0_27) + resize(act_0_37_27, SUM_WIDTH_0_27);
        s1_8 <= resize(act_0_38_27, SUM_WIDTH_0_27) + resize(act_0_39_27, SUM_WIDTH_0_27) + resize(act_0_40_27, SUM_WIDTH_0_27) + resize(act_0_41_27, SUM_WIDTH_0_27);
        s1_9 <= resize(act_0_42_27, SUM_WIDTH_0_27) + resize(act_0_43_27, SUM_WIDTH_0_27) + resize(act_0_44_27, SUM_WIDTH_0_27) + resize(act_0_45_27, SUM_WIDTH_0_27);
        s1_10 <= resize(act_0_46_27, SUM_WIDTH_0_27) + resize(act_0_47_27, SUM_WIDTH_0_27) + resize(act_0_48_27, SUM_WIDTH_0_27) + resize(act_0_49_27, SUM_WIDTH_0_27);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_27 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_27 <= saturate(sum_0_27, 16);
  end block;

  -- LAYER 0, ch 28
  gen_l0c28 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_28;
  signal s2_0, s2_1, s2_2 : sum_t_0_28;
  signal sum_0_28 : sum_t_0_28;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_28.mem") port map (clk, input(0), act_0_0_28);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_28.mem") port map (clk, input(1), act_0_1_28);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_28.mem") port map (clk, input(2), act_0_2_28);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_28.mem") port map (clk, input(5), act_0_5_28);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_28.mem") port map (clk, input(6), act_0_6_28);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_28.mem") port map (clk, input(7), act_0_7_28);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_28.mem") port map (clk, input(8), act_0_8_28);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_28.mem") port map (clk, input(9), act_0_9_28);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_28.mem") port map (clk, input(10), act_0_10_28);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_28.mem") port map (clk, input(11), act_0_11_28);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_28.mem") port map (clk, input(12), act_0_12_28);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_28.mem") port map (clk, input(13), act_0_13_28);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_28.mem") port map (clk, input(14), act_0_14_28);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_28.mem") port map (clk, input(16), act_0_16_28);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_28.mem") port map (clk, input(17), act_0_17_28);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_28.mem") port map (clk, input(18), act_0_18_28);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_28.mem") port map (clk, input(19), act_0_19_28);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_28.mem") port map (clk, input(21), act_0_21_28);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_28.mem") port map (clk, input(22), act_0_22_28);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_28.mem") port map (clk, input(23), act_0_23_28);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_28.mem") port map (clk, input(24), act_0_24_28);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_28.mem") port map (clk, input(26), act_0_26_28);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_28.mem") port map (clk, input(27), act_0_27_28);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_28.mem") port map (clk, input(28), act_0_28_28);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_28.mem") port map (clk, input(30), act_0_30_28);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_28.mem") port map (clk, input(31), act_0_31_28);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_28.mem") port map (clk, input(32), act_0_32_28);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_28.mem") port map (clk, input(33), act_0_33_28);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_28.mem") port map (clk, input(34), act_0_34_28);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_28.mem") port map (clk, input(35), act_0_35_28);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_28.mem") port map (clk, input(37), act_0_37_28);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_28.mem") port map (clk, input(38), act_0_38_28);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_28.mem") port map (clk, input(39), act_0_39_28);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_28.mem") port map (clk, input(40), act_0_40_28);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_28.mem") port map (clk, input(41), act_0_41_28);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_28.mem") port map (clk, input(42), act_0_42_28);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_28.mem") port map (clk, input(43), act_0_43_28);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_28.mem") port map (clk, input(46), act_0_46_28);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_28.mem") port map (clk, input(48), act_0_48_28);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_28.mem") port map (clk, input(49), act_0_49_28);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_28, SUM_WIDTH_0_28) + resize(act_0_1_28, SUM_WIDTH_0_28) + resize(act_0_2_28, SUM_WIDTH_0_28) + resize(act_0_5_28, SUM_WIDTH_0_28);
        s1_1 <= resize(act_0_6_28, SUM_WIDTH_0_28) + resize(act_0_7_28, SUM_WIDTH_0_28) + resize(act_0_8_28, SUM_WIDTH_0_28) + resize(act_0_9_28, SUM_WIDTH_0_28);
        s1_2 <= resize(act_0_10_28, SUM_WIDTH_0_28) + resize(act_0_11_28, SUM_WIDTH_0_28) + resize(act_0_12_28, SUM_WIDTH_0_28) + resize(act_0_13_28, SUM_WIDTH_0_28);
        s1_3 <= resize(act_0_14_28, SUM_WIDTH_0_28) + resize(act_0_16_28, SUM_WIDTH_0_28) + resize(act_0_17_28, SUM_WIDTH_0_28) + resize(act_0_18_28, SUM_WIDTH_0_28);
        s1_4 <= resize(act_0_19_28, SUM_WIDTH_0_28) + resize(act_0_21_28, SUM_WIDTH_0_28) + resize(act_0_22_28, SUM_WIDTH_0_28) + resize(act_0_23_28, SUM_WIDTH_0_28);
        s1_5 <= resize(act_0_24_28, SUM_WIDTH_0_28) + resize(act_0_26_28, SUM_WIDTH_0_28) + resize(act_0_27_28, SUM_WIDTH_0_28) + resize(act_0_28_28, SUM_WIDTH_0_28);
        s1_6 <= resize(act_0_30_28, SUM_WIDTH_0_28) + resize(act_0_31_28, SUM_WIDTH_0_28) + resize(act_0_32_28, SUM_WIDTH_0_28) + resize(act_0_33_28, SUM_WIDTH_0_28);
        s1_7 <= resize(act_0_34_28, SUM_WIDTH_0_28) + resize(act_0_35_28, SUM_WIDTH_0_28) + resize(act_0_37_28, SUM_WIDTH_0_28) + resize(act_0_38_28, SUM_WIDTH_0_28);
        s1_8 <= resize(act_0_39_28, SUM_WIDTH_0_28) + resize(act_0_40_28, SUM_WIDTH_0_28) + resize(act_0_41_28, SUM_WIDTH_0_28) + resize(act_0_42_28, SUM_WIDTH_0_28);
        s1_9 <= resize(act_0_43_28, SUM_WIDTH_0_28) + resize(act_0_46_28, SUM_WIDTH_0_28) + resize(act_0_48_28, SUM_WIDTH_0_28) + resize(act_0_49_28, SUM_WIDTH_0_28);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_28 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_28 <= saturate(sum_0_28, 16);
  end block;

  -- LAYER 0, ch 29
  gen_l0c29 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_29;
  signal s2_0, s2_1, s2_2 : sum_t_0_29;
  signal sum_0_29 : sum_t_0_29;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_29.mem") port map (clk, input(1), act_0_1_29);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_29.mem") port map (clk, input(2), act_0_2_29);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_29.mem") port map (clk, input(3), act_0_3_29);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_29.mem") port map (clk, input(4), act_0_4_29);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_29.mem") port map (clk, input(5), act_0_5_29);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_29.mem") port map (clk, input(6), act_0_6_29);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_29.mem") port map (clk, input(7), act_0_7_29);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_29.mem") port map (clk, input(8), act_0_8_29);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_29.mem") port map (clk, input(9), act_0_9_29);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_29.mem") port map (clk, input(10), act_0_10_29);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_29.mem") port map (clk, input(11), act_0_11_29);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_29.mem") port map (clk, input(12), act_0_12_29);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_29.mem") port map (clk, input(13), act_0_13_29);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_29.mem") port map (clk, input(14), act_0_14_29);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_29.mem") port map (clk, input(15), act_0_15_29);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_29.mem") port map (clk, input(16), act_0_16_29);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_29.mem") port map (clk, input(17), act_0_17_29);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_29.mem") port map (clk, input(19), act_0_19_29);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_29.mem") port map (clk, input(20), act_0_20_29);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_29.mem") port map (clk, input(21), act_0_21_29);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_29.mem") port map (clk, input(22), act_0_22_29);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_29.mem") port map (clk, input(23), act_0_23_29);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_29.mem") port map (clk, input(24), act_0_24_29);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_29.mem") port map (clk, input(25), act_0_25_29);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_29.mem") port map (clk, input(26), act_0_26_29);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_29.mem") port map (clk, input(27), act_0_27_29);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_29.mem") port map (clk, input(28), act_0_28_29);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_29.mem") port map (clk, input(29), act_0_29_29);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_29.mem") port map (clk, input(31), act_0_31_29);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_29.mem") port map (clk, input(33), act_0_33_29);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_29.mem") port map (clk, input(34), act_0_34_29);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_29.mem") port map (clk, input(35), act_0_35_29);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_29.mem") port map (clk, input(37), act_0_37_29);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_29.mem") port map (clk, input(38), act_0_38_29);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_29.mem") port map (clk, input(40), act_0_40_29);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_29.mem") port map (clk, input(41), act_0_41_29);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_29.mem") port map (clk, input(42), act_0_42_29);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_29.mem") port map (clk, input(43), act_0_43_29);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_29.mem") port map (clk, input(44), act_0_44_29);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_29.mem") port map (clk, input(46), act_0_46_29);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_29.mem") port map (clk, input(47), act_0_47_29);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_29.mem") port map (clk, input(49), act_0_49_29);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_29, SUM_WIDTH_0_29) + resize(act_0_2_29, SUM_WIDTH_0_29) + resize(act_0_3_29, SUM_WIDTH_0_29) + resize(act_0_4_29, SUM_WIDTH_0_29);
        s1_1 <= resize(act_0_5_29, SUM_WIDTH_0_29) + resize(act_0_6_29, SUM_WIDTH_0_29) + resize(act_0_7_29, SUM_WIDTH_0_29) + resize(act_0_8_29, SUM_WIDTH_0_29);
        s1_2 <= resize(act_0_9_29, SUM_WIDTH_0_29) + resize(act_0_10_29, SUM_WIDTH_0_29) + resize(act_0_11_29, SUM_WIDTH_0_29) + resize(act_0_12_29, SUM_WIDTH_0_29);
        s1_3 <= resize(act_0_13_29, SUM_WIDTH_0_29) + resize(act_0_14_29, SUM_WIDTH_0_29) + resize(act_0_15_29, SUM_WIDTH_0_29) + resize(act_0_16_29, SUM_WIDTH_0_29);
        s1_4 <= resize(act_0_17_29, SUM_WIDTH_0_29) + resize(act_0_19_29, SUM_WIDTH_0_29) + resize(act_0_20_29, SUM_WIDTH_0_29) + resize(act_0_21_29, SUM_WIDTH_0_29);
        s1_5 <= resize(act_0_22_29, SUM_WIDTH_0_29) + resize(act_0_23_29, SUM_WIDTH_0_29) + resize(act_0_24_29, SUM_WIDTH_0_29) + resize(act_0_25_29, SUM_WIDTH_0_29);
        s1_6 <= resize(act_0_26_29, SUM_WIDTH_0_29) + resize(act_0_27_29, SUM_WIDTH_0_29) + resize(act_0_28_29, SUM_WIDTH_0_29) + resize(act_0_29_29, SUM_WIDTH_0_29);
        s1_7 <= resize(act_0_31_29, SUM_WIDTH_0_29) + resize(act_0_33_29, SUM_WIDTH_0_29) + resize(act_0_34_29, SUM_WIDTH_0_29) + resize(act_0_35_29, SUM_WIDTH_0_29);
        s1_8 <= resize(act_0_37_29, SUM_WIDTH_0_29) + resize(act_0_38_29, SUM_WIDTH_0_29) + resize(act_0_40_29, SUM_WIDTH_0_29) + resize(act_0_41_29, SUM_WIDTH_0_29);
        s1_9 <= resize(act_0_42_29, SUM_WIDTH_0_29) + resize(act_0_43_29, SUM_WIDTH_0_29) + resize(act_0_44_29, SUM_WIDTH_0_29) + resize(act_0_46_29, SUM_WIDTH_0_29);
        s1_10 <= resize(act_0_47_29, SUM_WIDTH_0_29) + resize(act_0_49_29, SUM_WIDTH_0_29);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_29 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_29 <= saturate(sum_0_29, 16);
  end block;

  -- LAYER 0, ch 30
  gen_l0c30 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_30;
  signal s2_0, s2_1, s2_2 : sum_t_0_30;
  signal sum_0_30 : sum_t_0_30;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_30.mem") port map (clk, input(1), act_0_1_30);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_30.mem") port map (clk, input(2), act_0_2_30);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_30.mem") port map (clk, input(3), act_0_3_30);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_30.mem") port map (clk, input(4), act_0_4_30);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_30.mem") port map (clk, input(5), act_0_5_30);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_30.mem") port map (clk, input(6), act_0_6_30);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_30.mem") port map (clk, input(7), act_0_7_30);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_30.mem") port map (clk, input(8), act_0_8_30);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_30.mem") port map (clk, input(9), act_0_9_30);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_30.mem") port map (clk, input(12), act_0_12_30);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_30.mem") port map (clk, input(13), act_0_13_30);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_30.mem") port map (clk, input(14), act_0_14_30);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_30.mem") port map (clk, input(16), act_0_16_30);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_30.mem") port map (clk, input(17), act_0_17_30);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_30.mem") port map (clk, input(18), act_0_18_30);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_30.mem") port map (clk, input(19), act_0_19_30);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_30.mem") port map (clk, input(20), act_0_20_30);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_30.mem") port map (clk, input(21), act_0_21_30);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_30.mem") port map (clk, input(22), act_0_22_30);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_30.mem") port map (clk, input(23), act_0_23_30);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_30.mem") port map (clk, input(24), act_0_24_30);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_30.mem") port map (clk, input(26), act_0_26_30);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_30.mem") port map (clk, input(27), act_0_27_30);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_30.mem") port map (clk, input(28), act_0_28_30);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_30.mem") port map (clk, input(29), act_0_29_30);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_30.mem") port map (clk, input(30), act_0_30_30);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_30.mem") port map (clk, input(31), act_0_31_30);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_30.mem") port map (clk, input(32), act_0_32_30);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_30.mem") port map (clk, input(34), act_0_34_30);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_30.mem") port map (clk, input(35), act_0_35_30);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_30.mem") port map (clk, input(37), act_0_37_30);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_30.mem") port map (clk, input(38), act_0_38_30);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_30.mem") port map (clk, input(40), act_0_40_30);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_30.mem") port map (clk, input(42), act_0_42_30);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_30.mem") port map (clk, input(43), act_0_43_30);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_30.mem") port map (clk, input(46), act_0_46_30);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_30.mem") port map (clk, input(47), act_0_47_30);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_30.mem") port map (clk, input(48), act_0_48_30);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_30, SUM_WIDTH_0_30) + resize(act_0_2_30, SUM_WIDTH_0_30) + resize(act_0_3_30, SUM_WIDTH_0_30) + resize(act_0_4_30, SUM_WIDTH_0_30);
        s1_1 <= resize(act_0_5_30, SUM_WIDTH_0_30) + resize(act_0_6_30, SUM_WIDTH_0_30) + resize(act_0_7_30, SUM_WIDTH_0_30) + resize(act_0_8_30, SUM_WIDTH_0_30);
        s1_2 <= resize(act_0_9_30, SUM_WIDTH_0_30) + resize(act_0_12_30, SUM_WIDTH_0_30) + resize(act_0_13_30, SUM_WIDTH_0_30) + resize(act_0_14_30, SUM_WIDTH_0_30);
        s1_3 <= resize(act_0_16_30, SUM_WIDTH_0_30) + resize(act_0_17_30, SUM_WIDTH_0_30) + resize(act_0_18_30, SUM_WIDTH_0_30) + resize(act_0_19_30, SUM_WIDTH_0_30);
        s1_4 <= resize(act_0_20_30, SUM_WIDTH_0_30) + resize(act_0_21_30, SUM_WIDTH_0_30) + resize(act_0_22_30, SUM_WIDTH_0_30) + resize(act_0_23_30, SUM_WIDTH_0_30);
        s1_5 <= resize(act_0_24_30, SUM_WIDTH_0_30) + resize(act_0_26_30, SUM_WIDTH_0_30) + resize(act_0_27_30, SUM_WIDTH_0_30) + resize(act_0_28_30, SUM_WIDTH_0_30);
        s1_6 <= resize(act_0_29_30, SUM_WIDTH_0_30) + resize(act_0_30_30, SUM_WIDTH_0_30) + resize(act_0_31_30, SUM_WIDTH_0_30) + resize(act_0_32_30, SUM_WIDTH_0_30);
        s1_7 <= resize(act_0_34_30, SUM_WIDTH_0_30) + resize(act_0_35_30, SUM_WIDTH_0_30) + resize(act_0_37_30, SUM_WIDTH_0_30) + resize(act_0_38_30, SUM_WIDTH_0_30);
        s1_8 <= resize(act_0_40_30, SUM_WIDTH_0_30) + resize(act_0_42_30, SUM_WIDTH_0_30) + resize(act_0_43_30, SUM_WIDTH_0_30) + resize(act_0_46_30, SUM_WIDTH_0_30);
        s1_9 <= resize(act_0_47_30, SUM_WIDTH_0_30) + resize(act_0_48_30, SUM_WIDTH_0_30);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_30 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_30 <= saturate(sum_0_30, 16);
  end block;

  -- LAYER 0, ch 31
  gen_l0c31 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_31;
  signal s2_0, s2_1, s2_2 : sum_t_0_31;
  signal sum_0_31 : sum_t_0_31;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_31.mem") port map (clk, input(0), act_0_0_31);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_31.mem") port map (clk, input(1), act_0_1_31);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_31.mem") port map (clk, input(3), act_0_3_31);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_31.mem") port map (clk, input(4), act_0_4_31);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_31.mem") port map (clk, input(5), act_0_5_31);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_31.mem") port map (clk, input(6), act_0_6_31);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_31.mem") port map (clk, input(7), act_0_7_31);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_31.mem") port map (clk, input(8), act_0_8_31);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_31.mem") port map (clk, input(9), act_0_9_31);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_31.mem") port map (clk, input(10), act_0_10_31);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_31.mem") port map (clk, input(11), act_0_11_31);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_31.mem") port map (clk, input(12), act_0_12_31);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_31.mem") port map (clk, input(13), act_0_13_31);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_31.mem") port map (clk, input(14), act_0_14_31);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_31.mem") port map (clk, input(15), act_0_15_31);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_31.mem") port map (clk, input(16), act_0_16_31);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_31.mem") port map (clk, input(17), act_0_17_31);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_31.mem") port map (clk, input(18), act_0_18_31);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_31.mem") port map (clk, input(19), act_0_19_31);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_31.mem") port map (clk, input(21), act_0_21_31);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_31.mem") port map (clk, input(22), act_0_22_31);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_31.mem") port map (clk, input(23), act_0_23_31);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_31.mem") port map (clk, input(26), act_0_26_31);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_31.mem") port map (clk, input(27), act_0_27_31);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_31.mem") port map (clk, input(28), act_0_28_31);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_31.mem") port map (clk, input(29), act_0_29_31);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_31.mem") port map (clk, input(31), act_0_31_31);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_31.mem") port map (clk, input(32), act_0_32_31);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_31.mem") port map (clk, input(33), act_0_33_31);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_31.mem") port map (clk, input(34), act_0_34_31);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_31.mem") port map (clk, input(35), act_0_35_31);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_31.mem") port map (clk, input(36), act_0_36_31);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_31.mem") port map (clk, input(37), act_0_37_31);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_31.mem") port map (clk, input(38), act_0_38_31);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_31.mem") port map (clk, input(42), act_0_42_31);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_31.mem") port map (clk, input(43), act_0_43_31);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_31.mem") port map (clk, input(48), act_0_48_31);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_31, SUM_WIDTH_0_31) + resize(act_0_1_31, SUM_WIDTH_0_31) + resize(act_0_3_31, SUM_WIDTH_0_31) + resize(act_0_4_31, SUM_WIDTH_0_31);
        s1_1 <= resize(act_0_5_31, SUM_WIDTH_0_31) + resize(act_0_6_31, SUM_WIDTH_0_31) + resize(act_0_7_31, SUM_WIDTH_0_31) + resize(act_0_8_31, SUM_WIDTH_0_31);
        s1_2 <= resize(act_0_9_31, SUM_WIDTH_0_31) + resize(act_0_10_31, SUM_WIDTH_0_31) + resize(act_0_11_31, SUM_WIDTH_0_31) + resize(act_0_12_31, SUM_WIDTH_0_31);
        s1_3 <= resize(act_0_13_31, SUM_WIDTH_0_31) + resize(act_0_14_31, SUM_WIDTH_0_31) + resize(act_0_15_31, SUM_WIDTH_0_31) + resize(act_0_16_31, SUM_WIDTH_0_31);
        s1_4 <= resize(act_0_17_31, SUM_WIDTH_0_31) + resize(act_0_18_31, SUM_WIDTH_0_31) + resize(act_0_19_31, SUM_WIDTH_0_31) + resize(act_0_21_31, SUM_WIDTH_0_31);
        s1_5 <= resize(act_0_22_31, SUM_WIDTH_0_31) + resize(act_0_23_31, SUM_WIDTH_0_31) + resize(act_0_26_31, SUM_WIDTH_0_31) + resize(act_0_27_31, SUM_WIDTH_0_31);
        s1_6 <= resize(act_0_28_31, SUM_WIDTH_0_31) + resize(act_0_29_31, SUM_WIDTH_0_31) + resize(act_0_31_31, SUM_WIDTH_0_31) + resize(act_0_32_31, SUM_WIDTH_0_31);
        s1_7 <= resize(act_0_33_31, SUM_WIDTH_0_31) + resize(act_0_34_31, SUM_WIDTH_0_31) + resize(act_0_35_31, SUM_WIDTH_0_31) + resize(act_0_36_31, SUM_WIDTH_0_31);
        s1_8 <= resize(act_0_37_31, SUM_WIDTH_0_31) + resize(act_0_38_31, SUM_WIDTH_0_31) + resize(act_0_42_31, SUM_WIDTH_0_31) + resize(act_0_43_31, SUM_WIDTH_0_31);
        s1_9 <= resize(act_0_48_31, SUM_WIDTH_0_31);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_31 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_31 <= saturate(sum_0_31, 16);
  end block;

  -- Register block for layer 0
  out_layer0_reg : process(clk)
    begin
      if rising_edge(clk) then
        out0_0_reg <= out0_0;
        out0_1_reg <= out0_1;
        out0_2_reg <= out0_2;
        out0_3_reg <= out0_3;
        out0_4_reg <= out0_4;
        out0_5_reg <= out0_5;
        out0_6_reg <= out0_6;
        out0_7_reg <= out0_7;
        out0_8_reg <= out0_8;
        out0_9_reg <= out0_9;
        out0_10_reg <= out0_10;
        out0_11_reg <= out0_11;
        out0_12_reg <= out0_12;
        out0_13_reg <= out0_13;
        out0_14_reg <= out0_14;
        out0_15_reg <= out0_15;
        out0_16_reg <= out0_16;
        out0_17_reg <= out0_17;
        out0_18_reg <= out0_18;
        out0_19_reg <= out0_19;
        out0_20_reg <= out0_20;
        out0_21_reg <= out0_21;
        out0_22_reg <= out0_22;
        out0_23_reg <= out0_23;
        out0_24_reg <= out0_24;
        out0_25_reg <= out0_25;
        out0_26_reg <= out0_26;
        out0_27_reg <= out0_27;
        out0_28_reg <= out0_28;
        out0_29_reg <= out0_29;
        out0_30_reg <= out0_30;
        out0_31_reg <= out0_31;
      end if;
  end process;

  -- LAYER 1, ch 0
  gen_l1c0 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_1_0;
  signal s2_0, s2_1 : sum_t_1_0;
  signal sum_1_0 : sum_t_1_0;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_0.mem") port map (clk, out0_0_reg, act_1_0_0);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_0.mem") port map (clk, out0_1_reg, act_1_1_0);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_0.mem") port map (clk, out0_2_reg, act_1_2_0);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_0.mem") port map (clk, out0_3_reg, act_1_3_0);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_0.mem") port map (clk, out0_4_reg, act_1_4_0);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_0.mem") port map (clk, out0_5_reg, act_1_5_0);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_0.mem") port map (clk, out0_6_reg, act_1_6_0);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_0.mem") port map (clk, out0_7_reg, act_1_7_0);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_0.mem") port map (clk, out0_8_reg, act_1_8_0);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_0.mem") port map (clk, out0_11_reg, act_1_11_0);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_0.mem") port map (clk, out0_12_reg, act_1_12_0);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_0.mem") port map (clk, out0_13_reg, act_1_13_0);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_0.mem") port map (clk, out0_14_reg, act_1_14_0);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_0.mem") port map (clk, out0_15_reg, act_1_15_0);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_0.mem") port map (clk, out0_16_reg, act_1_16_0);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_0.mem") port map (clk, out0_17_reg, act_1_17_0);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_0.mem") port map (clk, out0_18_reg, act_1_18_0);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_0.mem") port map (clk, out0_19_reg, act_1_19_0);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_0.mem") port map (clk, out0_20_reg, act_1_20_0);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_0.mem") port map (clk, out0_21_reg, act_1_21_0);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_0.mem") port map (clk, out0_22_reg, act_1_22_0);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_0.mem") port map (clk, out0_23_reg, act_1_23_0);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_0.mem") port map (clk, out0_24_reg, act_1_24_0);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_0.mem") port map (clk, out0_25_reg, act_1_25_0);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_0.mem") port map (clk, out0_26_reg, act_1_26_0);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_0.mem") port map (clk, out0_27_reg, act_1_27_0);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_0.mem") port map (clk, out0_28_reg, act_1_28_0);
    i27 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_0.mem") port map (clk, out0_30_reg, act_1_30_0);
    i28 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_0.mem") port map (clk, out0_31_reg, act_1_31_0);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_0, SUM_WIDTH_1_0) + resize(act_1_1_0, SUM_WIDTH_1_0) + resize(act_1_2_0, SUM_WIDTH_1_0) + resize(act_1_3_0, SUM_WIDTH_1_0);
        s1_1 <= resize(act_1_4_0, SUM_WIDTH_1_0) + resize(act_1_5_0, SUM_WIDTH_1_0) + resize(act_1_6_0, SUM_WIDTH_1_0) + resize(act_1_7_0, SUM_WIDTH_1_0);
        s1_2 <= resize(act_1_8_0, SUM_WIDTH_1_0) + resize(act_1_11_0, SUM_WIDTH_1_0) + resize(act_1_12_0, SUM_WIDTH_1_0) + resize(act_1_13_0, SUM_WIDTH_1_0);
        s1_3 <= resize(act_1_14_0, SUM_WIDTH_1_0) + resize(act_1_15_0, SUM_WIDTH_1_0) + resize(act_1_16_0, SUM_WIDTH_1_0) + resize(act_1_17_0, SUM_WIDTH_1_0);
        s1_4 <= resize(act_1_18_0, SUM_WIDTH_1_0) + resize(act_1_19_0, SUM_WIDTH_1_0) + resize(act_1_20_0, SUM_WIDTH_1_0) + resize(act_1_21_0, SUM_WIDTH_1_0);
        s1_5 <= resize(act_1_22_0, SUM_WIDTH_1_0) + resize(act_1_23_0, SUM_WIDTH_1_0) + resize(act_1_24_0, SUM_WIDTH_1_0) + resize(act_1_25_0, SUM_WIDTH_1_0);
        s1_6 <= resize(act_1_26_0, SUM_WIDTH_1_0) + resize(act_1_27_0, SUM_WIDTH_1_0) + resize(act_1_28_0, SUM_WIDTH_1_0) + resize(act_1_30_0, SUM_WIDTH_1_0);
        s1_7 <= resize(act_1_31_0, SUM_WIDTH_1_0);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_1_0 <= s2_0 + s2_1;
      end if;
    end process;
    output(0) <= saturate(sum_1_0, 16);
  end block;

  -- LAYER 1, ch 1
  gen_l1c1 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_1_1;
  signal s2_0, s2_1 : sum_t_1_1;
  signal sum_1_1 : sum_t_1_1;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_1.mem") port map (clk, out0_0_reg, act_1_0_1);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_1.mem") port map (clk, out0_1_reg, act_1_1_1);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_1.mem") port map (clk, out0_2_reg, act_1_2_1);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_1.mem") port map (clk, out0_3_reg, act_1_3_1);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_1.mem") port map (clk, out0_4_reg, act_1_4_1);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_1.mem") port map (clk, out0_5_reg, act_1_5_1);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_1.mem") port map (clk, out0_6_reg, act_1_6_1);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_1.mem") port map (clk, out0_7_reg, act_1_7_1);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_1.mem") port map (clk, out0_8_reg, act_1_8_1);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_1.mem") port map (clk, out0_9_reg, act_1_9_1);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_1.mem") port map (clk, out0_10_reg, act_1_10_1);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_1.mem") port map (clk, out0_11_reg, act_1_11_1);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_1.mem") port map (clk, out0_12_reg, act_1_12_1);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_1.mem") port map (clk, out0_13_reg, act_1_13_1);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_1.mem") port map (clk, out0_14_reg, act_1_14_1);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_1.mem") port map (clk, out0_15_reg, act_1_15_1);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_1.mem") port map (clk, out0_16_reg, act_1_16_1);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_1.mem") port map (clk, out0_18_reg, act_1_18_1);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_1.mem") port map (clk, out0_19_reg, act_1_19_1);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_1.mem") port map (clk, out0_20_reg, act_1_20_1);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_1.mem") port map (clk, out0_21_reg, act_1_21_1);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_1.mem") port map (clk, out0_22_reg, act_1_22_1);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_1.mem") port map (clk, out0_23_reg, act_1_23_1);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_1.mem") port map (clk, out0_24_reg, act_1_24_1);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_1.mem") port map (clk, out0_25_reg, act_1_25_1);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_1.mem") port map (clk, out0_26_reg, act_1_26_1);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_1.mem") port map (clk, out0_27_reg, act_1_27_1);
    i27 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_1.mem") port map (clk, out0_28_reg, act_1_28_1);
    i28 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_1.mem") port map (clk, out0_29_reg, act_1_29_1);
    i29 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_1.mem") port map (clk, out0_30_reg, act_1_30_1);
    i30 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_1.mem") port map (clk, out0_31_reg, act_1_31_1);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_1, SUM_WIDTH_1_1) + resize(act_1_1_1, SUM_WIDTH_1_1) + resize(act_1_2_1, SUM_WIDTH_1_1) + resize(act_1_3_1, SUM_WIDTH_1_1);
        s1_1 <= resize(act_1_4_1, SUM_WIDTH_1_1) + resize(act_1_5_1, SUM_WIDTH_1_1) + resize(act_1_6_1, SUM_WIDTH_1_1) + resize(act_1_7_1, SUM_WIDTH_1_1);
        s1_2 <= resize(act_1_8_1, SUM_WIDTH_1_1) + resize(act_1_9_1, SUM_WIDTH_1_1) + resize(act_1_10_1, SUM_WIDTH_1_1) + resize(act_1_11_1, SUM_WIDTH_1_1);
        s1_3 <= resize(act_1_12_1, SUM_WIDTH_1_1) + resize(act_1_13_1, SUM_WIDTH_1_1) + resize(act_1_14_1, SUM_WIDTH_1_1) + resize(act_1_15_1, SUM_WIDTH_1_1);
        s1_4 <= resize(act_1_16_1, SUM_WIDTH_1_1) + resize(act_1_18_1, SUM_WIDTH_1_1) + resize(act_1_19_1, SUM_WIDTH_1_1) + resize(act_1_20_1, SUM_WIDTH_1_1);
        s1_5 <= resize(act_1_21_1, SUM_WIDTH_1_1) + resize(act_1_22_1, SUM_WIDTH_1_1) + resize(act_1_23_1, SUM_WIDTH_1_1) + resize(act_1_24_1, SUM_WIDTH_1_1);
        s1_6 <= resize(act_1_25_1, SUM_WIDTH_1_1) + resize(act_1_26_1, SUM_WIDTH_1_1) + resize(act_1_27_1, SUM_WIDTH_1_1) + resize(act_1_28_1, SUM_WIDTH_1_1);
        s1_7 <= resize(act_1_29_1, SUM_WIDTH_1_1) + resize(act_1_30_1, SUM_WIDTH_1_1) + resize(act_1_31_1, SUM_WIDTH_1_1);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_1_1 <= s2_0 + s2_1;
      end if;
    end process;
    output(1) <= saturate(sum_1_1, 16);
  end block;

  -- LAYER 1, ch 2
  gen_l1c2 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_1_2;
  signal s2_0, s2_1 : sum_t_1_2;
  signal sum_1_2 : sum_t_1_2;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_2.mem") port map (clk, out0_0_reg, act_1_0_2);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_2.mem") port map (clk, out0_1_reg, act_1_1_2);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_2.mem") port map (clk, out0_3_reg, act_1_3_2);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_2.mem") port map (clk, out0_4_reg, act_1_4_2);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_2.mem") port map (clk, out0_6_reg, act_1_6_2);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_2.mem") port map (clk, out0_7_reg, act_1_7_2);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_2.mem") port map (clk, out0_8_reg, act_1_8_2);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_2.mem") port map (clk, out0_9_reg, act_1_9_2);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_2.mem") port map (clk, out0_10_reg, act_1_10_2);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_2.mem") port map (clk, out0_11_reg, act_1_11_2);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_2.mem") port map (clk, out0_12_reg, act_1_12_2);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_2.mem") port map (clk, out0_14_reg, act_1_14_2);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_2.mem") port map (clk, out0_15_reg, act_1_15_2);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_2.mem") port map (clk, out0_16_reg, act_1_16_2);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_2.mem") port map (clk, out0_17_reg, act_1_17_2);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_2.mem") port map (clk, out0_18_reg, act_1_18_2);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_2.mem") port map (clk, out0_19_reg, act_1_19_2);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_2.mem") port map (clk, out0_21_reg, act_1_21_2);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_2.mem") port map (clk, out0_22_reg, act_1_22_2);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_2.mem") port map (clk, out0_24_reg, act_1_24_2);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_2.mem") port map (clk, out0_25_reg, act_1_25_2);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_2.mem") port map (clk, out0_27_reg, act_1_27_2);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_2.mem") port map (clk, out0_28_reg, act_1_28_2);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_2.mem") port map (clk, out0_29_reg, act_1_29_2);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_2.mem") port map (clk, out0_30_reg, act_1_30_2);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_2.mem") port map (clk, out0_31_reg, act_1_31_2);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_2, SUM_WIDTH_1_2) + resize(act_1_1_2, SUM_WIDTH_1_2) + resize(act_1_3_2, SUM_WIDTH_1_2) + resize(act_1_4_2, SUM_WIDTH_1_2);
        s1_1 <= resize(act_1_6_2, SUM_WIDTH_1_2) + resize(act_1_7_2, SUM_WIDTH_1_2) + resize(act_1_8_2, SUM_WIDTH_1_2) + resize(act_1_9_2, SUM_WIDTH_1_2);
        s1_2 <= resize(act_1_10_2, SUM_WIDTH_1_2) + resize(act_1_11_2, SUM_WIDTH_1_2) + resize(act_1_12_2, SUM_WIDTH_1_2) + resize(act_1_14_2, SUM_WIDTH_1_2);
        s1_3 <= resize(act_1_15_2, SUM_WIDTH_1_2) + resize(act_1_16_2, SUM_WIDTH_1_2) + resize(act_1_17_2, SUM_WIDTH_1_2) + resize(act_1_18_2, SUM_WIDTH_1_2);
        s1_4 <= resize(act_1_19_2, SUM_WIDTH_1_2) + resize(act_1_21_2, SUM_WIDTH_1_2) + resize(act_1_22_2, SUM_WIDTH_1_2) + resize(act_1_24_2, SUM_WIDTH_1_2);
        s1_5 <= resize(act_1_25_2, SUM_WIDTH_1_2) + resize(act_1_27_2, SUM_WIDTH_1_2) + resize(act_1_28_2, SUM_WIDTH_1_2) + resize(act_1_29_2, SUM_WIDTH_1_2);
        s1_6 <= resize(act_1_30_2, SUM_WIDTH_1_2) + resize(act_1_31_2, SUM_WIDTH_1_2);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_1_2 <= s2_0 + s2_1;
      end if;
    end process;
    output(2) <= saturate(sum_1_2, 16);
  end block;

  -- LAYER 1, ch 3
  gen_l1c3 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_1_3;
  signal s2_0, s2_1 : sum_t_1_3;
  signal sum_1_3 : sum_t_1_3;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_3.mem") port map (clk, out0_0_reg, act_1_0_3);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_3.mem") port map (clk, out0_1_reg, act_1_1_3);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_3.mem") port map (clk, out0_3_reg, act_1_3_3);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_3.mem") port map (clk, out0_4_reg, act_1_4_3);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_3.mem") port map (clk, out0_5_reg, act_1_5_3);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_3.mem") port map (clk, out0_6_reg, act_1_6_3);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_3.mem") port map (clk, out0_7_reg, act_1_7_3);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_3.mem") port map (clk, out0_8_reg, act_1_8_3);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_3.mem") port map (clk, out0_9_reg, act_1_9_3);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_3.mem") port map (clk, out0_10_reg, act_1_10_3);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_3.mem") port map (clk, out0_11_reg, act_1_11_3);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_3.mem") port map (clk, out0_12_reg, act_1_12_3);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_3.mem") port map (clk, out0_13_reg, act_1_13_3);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_3.mem") port map (clk, out0_15_reg, act_1_15_3);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_3.mem") port map (clk, out0_16_reg, act_1_16_3);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_3.mem") port map (clk, out0_18_reg, act_1_18_3);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_3.mem") port map (clk, out0_19_reg, act_1_19_3);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_3.mem") port map (clk, out0_21_reg, act_1_21_3);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_3.mem") port map (clk, out0_22_reg, act_1_22_3);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_3.mem") port map (clk, out0_24_reg, act_1_24_3);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_3.mem") port map (clk, out0_25_reg, act_1_25_3);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_3.mem") port map (clk, out0_26_reg, act_1_26_3);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_3.mem") port map (clk, out0_27_reg, act_1_27_3);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_3.mem") port map (clk, out0_28_reg, act_1_28_3);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_3.mem") port map (clk, out0_29_reg, act_1_29_3);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_3.mem") port map (clk, out0_30_reg, act_1_30_3);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_3.mem") port map (clk, out0_31_reg, act_1_31_3);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_3, SUM_WIDTH_1_3) + resize(act_1_1_3, SUM_WIDTH_1_3) + resize(act_1_3_3, SUM_WIDTH_1_3) + resize(act_1_4_3, SUM_WIDTH_1_3);
        s1_1 <= resize(act_1_5_3, SUM_WIDTH_1_3) + resize(act_1_6_3, SUM_WIDTH_1_3) + resize(act_1_7_3, SUM_WIDTH_1_3) + resize(act_1_8_3, SUM_WIDTH_1_3);
        s1_2 <= resize(act_1_9_3, SUM_WIDTH_1_3) + resize(act_1_10_3, SUM_WIDTH_1_3) + resize(act_1_11_3, SUM_WIDTH_1_3) + resize(act_1_12_3, SUM_WIDTH_1_3);
        s1_3 <= resize(act_1_13_3, SUM_WIDTH_1_3) + resize(act_1_15_3, SUM_WIDTH_1_3) + resize(act_1_16_3, SUM_WIDTH_1_3) + resize(act_1_18_3, SUM_WIDTH_1_3);
        s1_4 <= resize(act_1_19_3, SUM_WIDTH_1_3) + resize(act_1_21_3, SUM_WIDTH_1_3) + resize(act_1_22_3, SUM_WIDTH_1_3) + resize(act_1_24_3, SUM_WIDTH_1_3);
        s1_5 <= resize(act_1_25_3, SUM_WIDTH_1_3) + resize(act_1_26_3, SUM_WIDTH_1_3) + resize(act_1_27_3, SUM_WIDTH_1_3) + resize(act_1_28_3, SUM_WIDTH_1_3);
        s1_6 <= resize(act_1_29_3, SUM_WIDTH_1_3) + resize(act_1_30_3, SUM_WIDTH_1_3) + resize(act_1_31_3, SUM_WIDTH_1_3);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_1_3 <= s2_0 + s2_1;
      end if;
    end process;
    output(3) <= saturate(sum_1_3, 16);
  end block;

  -- LAYER 1, ch 4
  gen_l1c4 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_1_4;
  signal s2_0, s2_1 : sum_t_1_4;
  signal sum_1_4 : sum_t_1_4;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_4.mem") port map (clk, out0_0_reg, act_1_0_4);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_4.mem") port map (clk, out0_1_reg, act_1_1_4);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_4.mem") port map (clk, out0_2_reg, act_1_2_4);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_4.mem") port map (clk, out0_3_reg, act_1_3_4);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_4.mem") port map (clk, out0_4_reg, act_1_4_4);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_4.mem") port map (clk, out0_5_reg, act_1_5_4);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_4.mem") port map (clk, out0_6_reg, act_1_6_4);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_4.mem") port map (clk, out0_7_reg, act_1_7_4);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_4.mem") port map (clk, out0_8_reg, act_1_8_4);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_4.mem") port map (clk, out0_9_reg, act_1_9_4);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_4.mem") port map (clk, out0_11_reg, act_1_11_4);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_4.mem") port map (clk, out0_12_reg, act_1_12_4);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_4.mem") port map (clk, out0_13_reg, act_1_13_4);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_4.mem") port map (clk, out0_15_reg, act_1_15_4);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_4.mem") port map (clk, out0_16_reg, act_1_16_4);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_4.mem") port map (clk, out0_17_reg, act_1_17_4);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_4.mem") port map (clk, out0_18_reg, act_1_18_4);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_4.mem") port map (clk, out0_19_reg, act_1_19_4);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_4.mem") port map (clk, out0_20_reg, act_1_20_4);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_4.mem") port map (clk, out0_21_reg, act_1_21_4);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_4.mem") port map (clk, out0_22_reg, act_1_22_4);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_4.mem") port map (clk, out0_23_reg, act_1_23_4);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_4.mem") port map (clk, out0_24_reg, act_1_24_4);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_4.mem") port map (clk, out0_25_reg, act_1_25_4);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_4.mem") port map (clk, out0_26_reg, act_1_26_4);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_4.mem") port map (clk, out0_27_reg, act_1_27_4);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_4.mem") port map (clk, out0_28_reg, act_1_28_4);
    i27 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_4.mem") port map (clk, out0_29_reg, act_1_29_4);
    i28 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_4.mem") port map (clk, out0_30_reg, act_1_30_4);
    i29 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_4.mem") port map (clk, out0_31_reg, act_1_31_4);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_4, SUM_WIDTH_1_4) + resize(act_1_1_4, SUM_WIDTH_1_4) + resize(act_1_2_4, SUM_WIDTH_1_4) + resize(act_1_3_4, SUM_WIDTH_1_4);
        s1_1 <= resize(act_1_4_4, SUM_WIDTH_1_4) + resize(act_1_5_4, SUM_WIDTH_1_4) + resize(act_1_6_4, SUM_WIDTH_1_4) + resize(act_1_7_4, SUM_WIDTH_1_4);
        s1_2 <= resize(act_1_8_4, SUM_WIDTH_1_4) + resize(act_1_9_4, SUM_WIDTH_1_4) + resize(act_1_11_4, SUM_WIDTH_1_4) + resize(act_1_12_4, SUM_WIDTH_1_4);
        s1_3 <= resize(act_1_13_4, SUM_WIDTH_1_4) + resize(act_1_15_4, SUM_WIDTH_1_4) + resize(act_1_16_4, SUM_WIDTH_1_4) + resize(act_1_17_4, SUM_WIDTH_1_4);
        s1_4 <= resize(act_1_18_4, SUM_WIDTH_1_4) + resize(act_1_19_4, SUM_WIDTH_1_4) + resize(act_1_20_4, SUM_WIDTH_1_4) + resize(act_1_21_4, SUM_WIDTH_1_4);
        s1_5 <= resize(act_1_22_4, SUM_WIDTH_1_4) + resize(act_1_23_4, SUM_WIDTH_1_4) + resize(act_1_24_4, SUM_WIDTH_1_4) + resize(act_1_25_4, SUM_WIDTH_1_4);
        s1_6 <= resize(act_1_26_4, SUM_WIDTH_1_4) + resize(act_1_27_4, SUM_WIDTH_1_4) + resize(act_1_28_4, SUM_WIDTH_1_4) + resize(act_1_29_4, SUM_WIDTH_1_4);
        s1_7 <= resize(act_1_30_4, SUM_WIDTH_1_4) + resize(act_1_31_4, SUM_WIDTH_1_4);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_1_4 <= s2_0 + s2_1;
      end if;
    end process;
    output(4) <= saturate(sum_1_4, 16);
  end block;

  -- LAYER 1, ch 5
  gen_l1c5 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_1_5;
  signal s2_0, s2_1 : sum_t_1_5;
  signal sum_1_5 : sum_t_1_5;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_5.mem") port map (clk, out0_1_reg, act_1_1_5);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_5.mem") port map (clk, out0_2_reg, act_1_2_5);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_5.mem") port map (clk, out0_3_reg, act_1_3_5);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_5.mem") port map (clk, out0_4_reg, act_1_4_5);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_5.mem") port map (clk, out0_5_reg, act_1_5_5);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_5.mem") port map (clk, out0_7_reg, act_1_7_5);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_5.mem") port map (clk, out0_8_reg, act_1_8_5);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_5.mem") port map (clk, out0_9_reg, act_1_9_5);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_5.mem") port map (clk, out0_10_reg, act_1_10_5);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_5.mem") port map (clk, out0_11_reg, act_1_11_5);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_5.mem") port map (clk, out0_12_reg, act_1_12_5);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_5.mem") port map (clk, out0_13_reg, act_1_13_5);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_5.mem") port map (clk, out0_14_reg, act_1_14_5);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_5.mem") port map (clk, out0_15_reg, act_1_15_5);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_5.mem") port map (clk, out0_16_reg, act_1_16_5);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_5.mem") port map (clk, out0_17_reg, act_1_17_5);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_5.mem") port map (clk, out0_18_reg, act_1_18_5);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_5.mem") port map (clk, out0_19_reg, act_1_19_5);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_5.mem") port map (clk, out0_20_reg, act_1_20_5);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_5.mem") port map (clk, out0_23_reg, act_1_23_5);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_5.mem") port map (clk, out0_24_reg, act_1_24_5);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_5.mem") port map (clk, out0_25_reg, act_1_25_5);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_5.mem") port map (clk, out0_26_reg, act_1_26_5);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_5.mem") port map (clk, out0_28_reg, act_1_28_5);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_5.mem") port map (clk, out0_29_reg, act_1_29_5);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_5.mem") port map (clk, out0_30_reg, act_1_30_5);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_5.mem") port map (clk, out0_31_reg, act_1_31_5);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_1_5, SUM_WIDTH_1_5) + resize(act_1_2_5, SUM_WIDTH_1_5) + resize(act_1_3_5, SUM_WIDTH_1_5) + resize(act_1_4_5, SUM_WIDTH_1_5);
        s1_1 <= resize(act_1_5_5, SUM_WIDTH_1_5) + resize(act_1_7_5, SUM_WIDTH_1_5) + resize(act_1_8_5, SUM_WIDTH_1_5) + resize(act_1_9_5, SUM_WIDTH_1_5);
        s1_2 <= resize(act_1_10_5, SUM_WIDTH_1_5) + resize(act_1_11_5, SUM_WIDTH_1_5) + resize(act_1_12_5, SUM_WIDTH_1_5) + resize(act_1_13_5, SUM_WIDTH_1_5);
        s1_3 <= resize(act_1_14_5, SUM_WIDTH_1_5) + resize(act_1_15_5, SUM_WIDTH_1_5) + resize(act_1_16_5, SUM_WIDTH_1_5) + resize(act_1_17_5, SUM_WIDTH_1_5);
        s1_4 <= resize(act_1_18_5, SUM_WIDTH_1_5) + resize(act_1_19_5, SUM_WIDTH_1_5) + resize(act_1_20_5, SUM_WIDTH_1_5) + resize(act_1_23_5, SUM_WIDTH_1_5);
        s1_5 <= resize(act_1_24_5, SUM_WIDTH_1_5) + resize(act_1_25_5, SUM_WIDTH_1_5) + resize(act_1_26_5, SUM_WIDTH_1_5) + resize(act_1_28_5, SUM_WIDTH_1_5);
        s1_6 <= resize(act_1_29_5, SUM_WIDTH_1_5) + resize(act_1_30_5, SUM_WIDTH_1_5) + resize(act_1_31_5, SUM_WIDTH_1_5);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_1_5 <= s2_0 + s2_1;
      end if;
    end process;
    output(5) <= saturate(sum_1_5, 16);
  end block;

  -- LAYER 1, ch 6
  gen_l1c6 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_1_6;
  signal s2_0, s2_1 : sum_t_1_6;
  signal sum_1_6 : sum_t_1_6;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_6.mem") port map (clk, out0_0_reg, act_1_0_6);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_6.mem") port map (clk, out0_1_reg, act_1_1_6);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_6.mem") port map (clk, out0_2_reg, act_1_2_6);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_6.mem") port map (clk, out0_3_reg, act_1_3_6);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_6.mem") port map (clk, out0_4_reg, act_1_4_6);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_6.mem") port map (clk, out0_5_reg, act_1_5_6);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_6.mem") port map (clk, out0_6_reg, act_1_6_6);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_6.mem") port map (clk, out0_7_reg, act_1_7_6);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_6.mem") port map (clk, out0_8_reg, act_1_8_6);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_6.mem") port map (clk, out0_9_reg, act_1_9_6);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_6.mem") port map (clk, out0_10_reg, act_1_10_6);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_6.mem") port map (clk, out0_11_reg, act_1_11_6);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_6.mem") port map (clk, out0_12_reg, act_1_12_6);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_6.mem") port map (clk, out0_13_reg, act_1_13_6);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_6.mem") port map (clk, out0_14_reg, act_1_14_6);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_6.mem") port map (clk, out0_15_reg, act_1_15_6);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_6.mem") port map (clk, out0_16_reg, act_1_16_6);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_6.mem") port map (clk, out0_17_reg, act_1_17_6);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_6.mem") port map (clk, out0_18_reg, act_1_18_6);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_6.mem") port map (clk, out0_19_reg, act_1_19_6);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_6.mem") port map (clk, out0_20_reg, act_1_20_6);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_6.mem") port map (clk, out0_21_reg, act_1_21_6);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_6.mem") port map (clk, out0_22_reg, act_1_22_6);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_6.mem") port map (clk, out0_23_reg, act_1_23_6);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_6.mem") port map (clk, out0_24_reg, act_1_24_6);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_6.mem") port map (clk, out0_25_reg, act_1_25_6);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_6.mem") port map (clk, out0_26_reg, act_1_26_6);
    i27 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_6.mem") port map (clk, out0_27_reg, act_1_27_6);
    i28 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_6.mem") port map (clk, out0_29_reg, act_1_29_6);
    i29 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_6.mem") port map (clk, out0_30_reg, act_1_30_6);
    i30 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_6.mem") port map (clk, out0_31_reg, act_1_31_6);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_6, SUM_WIDTH_1_6) + resize(act_1_1_6, SUM_WIDTH_1_6) + resize(act_1_2_6, SUM_WIDTH_1_6) + resize(act_1_3_6, SUM_WIDTH_1_6);
        s1_1 <= resize(act_1_4_6, SUM_WIDTH_1_6) + resize(act_1_5_6, SUM_WIDTH_1_6) + resize(act_1_6_6, SUM_WIDTH_1_6) + resize(act_1_7_6, SUM_WIDTH_1_6);
        s1_2 <= resize(act_1_8_6, SUM_WIDTH_1_6) + resize(act_1_9_6, SUM_WIDTH_1_6) + resize(act_1_10_6, SUM_WIDTH_1_6) + resize(act_1_11_6, SUM_WIDTH_1_6);
        s1_3 <= resize(act_1_12_6, SUM_WIDTH_1_6) + resize(act_1_13_6, SUM_WIDTH_1_6) + resize(act_1_14_6, SUM_WIDTH_1_6) + resize(act_1_15_6, SUM_WIDTH_1_6);
        s1_4 <= resize(act_1_16_6, SUM_WIDTH_1_6) + resize(act_1_17_6, SUM_WIDTH_1_6) + resize(act_1_18_6, SUM_WIDTH_1_6) + resize(act_1_19_6, SUM_WIDTH_1_6);
        s1_5 <= resize(act_1_20_6, SUM_WIDTH_1_6) + resize(act_1_21_6, SUM_WIDTH_1_6) + resize(act_1_22_6, SUM_WIDTH_1_6) + resize(act_1_23_6, SUM_WIDTH_1_6);
        s1_6 <= resize(act_1_24_6, SUM_WIDTH_1_6) + resize(act_1_25_6, SUM_WIDTH_1_6) + resize(act_1_26_6, SUM_WIDTH_1_6) + resize(act_1_27_6, SUM_WIDTH_1_6);
        s1_7 <= resize(act_1_29_6, SUM_WIDTH_1_6) + resize(act_1_30_6, SUM_WIDTH_1_6) + resize(act_1_31_6, SUM_WIDTH_1_6);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_1_6 <= s2_0 + s2_1;
      end if;
    end process;
    output(6) <= saturate(sum_1_6, 16);
  end block;

  -- LAYER 1, ch 7
  gen_l1c7 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_1_7;
  signal s2_0, s2_1 : sum_t_1_7;
  signal sum_1_7 : sum_t_1_7;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_7.mem") port map (clk, out0_0_reg, act_1_0_7);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_7.mem") port map (clk, out0_1_reg, act_1_1_7);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_7.mem") port map (clk, out0_2_reg, act_1_2_7);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_7.mem") port map (clk, out0_3_reg, act_1_3_7);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_7.mem") port map (clk, out0_4_reg, act_1_4_7);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_7.mem") port map (clk, out0_5_reg, act_1_5_7);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_7.mem") port map (clk, out0_6_reg, act_1_6_7);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_7.mem") port map (clk, out0_7_reg, act_1_7_7);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_7.mem") port map (clk, out0_8_reg, act_1_8_7);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_7.mem") port map (clk, out0_10_reg, act_1_10_7);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_7.mem") port map (clk, out0_11_reg, act_1_11_7);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_7.mem") port map (clk, out0_12_reg, act_1_12_7);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_7.mem") port map (clk, out0_13_reg, act_1_13_7);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_7.mem") port map (clk, out0_14_reg, act_1_14_7);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_7.mem") port map (clk, out0_15_reg, act_1_15_7);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_7.mem") port map (clk, out0_16_reg, act_1_16_7);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_7.mem") port map (clk, out0_18_reg, act_1_18_7);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_7.mem") port map (clk, out0_19_reg, act_1_19_7);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_7.mem") port map (clk, out0_20_reg, act_1_20_7);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_7.mem") port map (clk, out0_21_reg, act_1_21_7);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_7.mem") port map (clk, out0_23_reg, act_1_23_7);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_7.mem") port map (clk, out0_24_reg, act_1_24_7);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_7.mem") port map (clk, out0_25_reg, act_1_25_7);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_7.mem") port map (clk, out0_28_reg, act_1_28_7);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_7.mem") port map (clk, out0_29_reg, act_1_29_7);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_7.mem") port map (clk, out0_30_reg, act_1_30_7);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_7.mem") port map (clk, out0_31_reg, act_1_31_7);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_7, SUM_WIDTH_1_7) + resize(act_1_1_7, SUM_WIDTH_1_7) + resize(act_1_2_7, SUM_WIDTH_1_7) + resize(act_1_3_7, SUM_WIDTH_1_7);
        s1_1 <= resize(act_1_4_7, SUM_WIDTH_1_7) + resize(act_1_5_7, SUM_WIDTH_1_7) + resize(act_1_6_7, SUM_WIDTH_1_7) + resize(act_1_7_7, SUM_WIDTH_1_7);
        s1_2 <= resize(act_1_8_7, SUM_WIDTH_1_7) + resize(act_1_10_7, SUM_WIDTH_1_7) + resize(act_1_11_7, SUM_WIDTH_1_7) + resize(act_1_12_7, SUM_WIDTH_1_7);
        s1_3 <= resize(act_1_13_7, SUM_WIDTH_1_7) + resize(act_1_14_7, SUM_WIDTH_1_7) + resize(act_1_15_7, SUM_WIDTH_1_7) + resize(act_1_16_7, SUM_WIDTH_1_7);
        s1_4 <= resize(act_1_18_7, SUM_WIDTH_1_7) + resize(act_1_19_7, SUM_WIDTH_1_7) + resize(act_1_20_7, SUM_WIDTH_1_7) + resize(act_1_21_7, SUM_WIDTH_1_7);
        s1_5 <= resize(act_1_23_7, SUM_WIDTH_1_7) + resize(act_1_24_7, SUM_WIDTH_1_7) + resize(act_1_25_7, SUM_WIDTH_1_7) + resize(act_1_28_7, SUM_WIDTH_1_7);
        s1_6 <= resize(act_1_29_7, SUM_WIDTH_1_7) + resize(act_1_30_7, SUM_WIDTH_1_7) + resize(act_1_31_7, SUM_WIDTH_1_7);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_1_7 <= s2_0 + s2_1;
      end if;
    end process;
    output(7) <= saturate(sum_1_7, 16);
  end block;

  -- LAYER 1, ch 8
  gen_l1c8 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_1_8;
  signal s2_0, s2_1 : sum_t_1_8;
  signal sum_1_8 : sum_t_1_8;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_8.mem") port map (clk, out0_0_reg, act_1_0_8);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_8.mem") port map (clk, out0_1_reg, act_1_1_8);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_8.mem") port map (clk, out0_2_reg, act_1_2_8);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_8.mem") port map (clk, out0_3_reg, act_1_3_8);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_8.mem") port map (clk, out0_4_reg, act_1_4_8);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_8.mem") port map (clk, out0_5_reg, act_1_5_8);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_8.mem") port map (clk, out0_6_reg, act_1_6_8);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_8.mem") port map (clk, out0_7_reg, act_1_7_8);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_8.mem") port map (clk, out0_8_reg, act_1_8_8);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_8.mem") port map (clk, out0_9_reg, act_1_9_8);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_8.mem") port map (clk, out0_10_reg, act_1_10_8);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_8.mem") port map (clk, out0_11_reg, act_1_11_8);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_8.mem") port map (clk, out0_12_reg, act_1_12_8);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_8.mem") port map (clk, out0_14_reg, act_1_14_8);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_8.mem") port map (clk, out0_15_reg, act_1_15_8);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_8.mem") port map (clk, out0_17_reg, act_1_17_8);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_18_8.mem") port map (clk, out0_18_reg, act_1_18_8);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_8.mem") port map (clk, out0_19_reg, act_1_19_8);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_8.mem") port map (clk, out0_20_reg, act_1_20_8);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_8.mem") port map (clk, out0_21_reg, act_1_21_8);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_22_8.mem") port map (clk, out0_22_reg, act_1_22_8);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_8.mem") port map (clk, out0_23_reg, act_1_23_8);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_24_8.mem") port map (clk, out0_24_reg, act_1_24_8);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_8.mem") port map (clk, out0_25_reg, act_1_25_8);
    i24 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_8.mem") port map (clk, out0_26_reg, act_1_26_8);
    i25 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_27_8.mem") port map (clk, out0_27_reg, act_1_27_8);
    i26 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_8.mem") port map (clk, out0_28_reg, act_1_28_8);
    i27 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_8.mem") port map (clk, out0_29_reg, act_1_29_8);
    i28 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_8.mem") port map (clk, out0_30_reg, act_1_30_8);
    i29 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_8.mem") port map (clk, out0_31_reg, act_1_31_8);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_8, SUM_WIDTH_1_8) + resize(act_1_1_8, SUM_WIDTH_1_8) + resize(act_1_2_8, SUM_WIDTH_1_8) + resize(act_1_3_8, SUM_WIDTH_1_8);
        s1_1 <= resize(act_1_4_8, SUM_WIDTH_1_8) + resize(act_1_5_8, SUM_WIDTH_1_8) + resize(act_1_6_8, SUM_WIDTH_1_8) + resize(act_1_7_8, SUM_WIDTH_1_8);
        s1_2 <= resize(act_1_8_8, SUM_WIDTH_1_8) + resize(act_1_9_8, SUM_WIDTH_1_8) + resize(act_1_10_8, SUM_WIDTH_1_8) + resize(act_1_11_8, SUM_WIDTH_1_8);
        s1_3 <= resize(act_1_12_8, SUM_WIDTH_1_8) + resize(act_1_14_8, SUM_WIDTH_1_8) + resize(act_1_15_8, SUM_WIDTH_1_8) + resize(act_1_17_8, SUM_WIDTH_1_8);
        s1_4 <= resize(act_1_18_8, SUM_WIDTH_1_8) + resize(act_1_19_8, SUM_WIDTH_1_8) + resize(act_1_20_8, SUM_WIDTH_1_8) + resize(act_1_21_8, SUM_WIDTH_1_8);
        s1_5 <= resize(act_1_22_8, SUM_WIDTH_1_8) + resize(act_1_23_8, SUM_WIDTH_1_8) + resize(act_1_24_8, SUM_WIDTH_1_8) + resize(act_1_25_8, SUM_WIDTH_1_8);
        s1_6 <= resize(act_1_26_8, SUM_WIDTH_1_8) + resize(act_1_27_8, SUM_WIDTH_1_8) + resize(act_1_28_8, SUM_WIDTH_1_8) + resize(act_1_29_8, SUM_WIDTH_1_8);
        s1_7 <= resize(act_1_30_8, SUM_WIDTH_1_8) + resize(act_1_31_8, SUM_WIDTH_1_8);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_1_8 <= s2_0 + s2_1;
      end if;
    end process;
    output(8) <= saturate(sum_1_8, 16);
  end block;

  -- LAYER 1, ch 9
  gen_l1c9 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5 : sum_t_1_9;
  signal s2_0, s2_1 : sum_t_1_9;
  signal sum_1_9 : sum_t_1_9;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_9.mem") port map (clk, out0_0_reg, act_1_0_9);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_9.mem") port map (clk, out0_2_reg, act_1_2_9);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_9.mem") port map (clk, out0_3_reg, act_1_3_9);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_9.mem") port map (clk, out0_5_reg, act_1_5_9);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_9.mem") port map (clk, out0_6_reg, act_1_6_9);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_9.mem") port map (clk, out0_7_reg, act_1_7_9);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_9.mem") port map (clk, out0_8_reg, act_1_8_9);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_9.mem") port map (clk, out0_9_reg, act_1_9_9);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_9.mem") port map (clk, out0_10_reg, act_1_10_9);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_9.mem") port map (clk, out0_12_reg, act_1_12_9);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_9.mem") port map (clk, out0_13_reg, act_1_13_9);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_9.mem") port map (clk, out0_15_reg, act_1_15_9);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_16_9.mem") port map (clk, out0_16_reg, act_1_16_9);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_17_9.mem") port map (clk, out0_17_reg, act_1_17_9);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_19_9.mem") port map (clk, out0_19_reg, act_1_19_9);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_20_9.mem") port map (clk, out0_20_reg, act_1_20_9);
    i16 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_21_9.mem") port map (clk, out0_21_reg, act_1_21_9);
    i17 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_23_9.mem") port map (clk, out0_23_reg, act_1_23_9);
    i18 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_25_9.mem") port map (clk, out0_25_reg, act_1_25_9);
    i19 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_26_9.mem") port map (clk, out0_26_reg, act_1_26_9);
    i20 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_28_9.mem") port map (clk, out0_28_reg, act_1_28_9);
    i21 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_29_9.mem") port map (clk, out0_29_reg, act_1_29_9);
    i22 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_30_9.mem") port map (clk, out0_30_reg, act_1_30_9);
    i23 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_31_9.mem") port map (clk, out0_31_reg, act_1_31_9);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_9, SUM_WIDTH_1_9) + resize(act_1_2_9, SUM_WIDTH_1_9) + resize(act_1_3_9, SUM_WIDTH_1_9) + resize(act_1_5_9, SUM_WIDTH_1_9);
        s1_1 <= resize(act_1_6_9, SUM_WIDTH_1_9) + resize(act_1_7_9, SUM_WIDTH_1_9) + resize(act_1_8_9, SUM_WIDTH_1_9) + resize(act_1_9_9, SUM_WIDTH_1_9);
        s1_2 <= resize(act_1_10_9, SUM_WIDTH_1_9) + resize(act_1_12_9, SUM_WIDTH_1_9) + resize(act_1_13_9, SUM_WIDTH_1_9) + resize(act_1_15_9, SUM_WIDTH_1_9);
        s1_3 <= resize(act_1_16_9, SUM_WIDTH_1_9) + resize(act_1_17_9, SUM_WIDTH_1_9) + resize(act_1_19_9, SUM_WIDTH_1_9) + resize(act_1_20_9, SUM_WIDTH_1_9);
        s1_4 <= resize(act_1_21_9, SUM_WIDTH_1_9) + resize(act_1_23_9, SUM_WIDTH_1_9) + resize(act_1_25_9, SUM_WIDTH_1_9) + resize(act_1_26_9, SUM_WIDTH_1_9);
        s1_5 <= resize(act_1_28_9, SUM_WIDTH_1_9) + resize(act_1_29_9, SUM_WIDTH_1_9) + resize(act_1_30_9, SUM_WIDTH_1_9) + resize(act_1_31_9, SUM_WIDTH_1_9);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5;
        -- Stage 3
        sum_1_9 <= s2_0 + s2_1;
      end if;
    end process;
    output(9) <= saturate(sum_1_9, 16);
  end block;

end architecture;