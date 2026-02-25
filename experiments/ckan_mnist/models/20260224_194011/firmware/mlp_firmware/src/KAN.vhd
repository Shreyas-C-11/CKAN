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
  -- Layer 0 (50->10)
  signal act_0_0_0, act_0_0_2, act_0_0_7, act_0_0_8, act_0_1_0, act_0_1_1, act_0_1_2, act_0_1_3, act_0_1_4, act_0_1_5, act_0_1_6, act_0_1_7, act_0_1_8, act_0_1_9, act_0_2_0, act_0_2_1 : lut_output_t_0;
  signal act_0_2_2, act_0_2_3, act_0_2_4, act_0_2_5, act_0_2_6, act_0_2_7, act_0_2_8, act_0_2_9, act_0_3_0, act_0_3_1, act_0_3_2, act_0_3_3, act_0_3_4, act_0_3_5, act_0_3_6, act_0_3_7 : lut_output_t_0;
  signal act_0_3_8, act_0_3_9, act_0_4_0, act_0_4_1, act_0_4_2, act_0_4_3, act_0_4_4, act_0_4_5, act_0_4_6, act_0_4_7, act_0_4_8, act_0_4_9, act_0_5_2, act_0_5_3, act_0_5_4, act_0_5_5 : lut_output_t_0;
  signal act_0_5_6, act_0_5_7, act_0_5_9, act_0_6_0, act_0_6_1, act_0_6_2, act_0_6_3, act_0_6_4, act_0_6_5, act_0_6_6, act_0_6_7, act_0_6_8, act_0_6_9, act_0_7_0, act_0_7_1, act_0_7_2 : lut_output_t_0;
  signal act_0_7_3, act_0_7_4, act_0_7_5, act_0_7_6, act_0_7_7, act_0_7_8, act_0_7_9, act_0_8_0, act_0_8_1, act_0_8_2, act_0_8_3, act_0_8_4, act_0_8_5, act_0_8_6, act_0_8_7, act_0_8_8 : lut_output_t_0;
  signal act_0_9_0, act_0_9_1, act_0_9_2, act_0_9_4, act_0_9_5, act_0_9_6, act_0_9_7, act_0_9_8, act_0_9_9, act_0_10_0, act_0_10_1, act_0_10_2, act_0_10_3, act_0_10_4, act_0_10_5, act_0_10_9 : lut_output_t_0;
  signal act_0_11_0, act_0_11_1, act_0_11_2, act_0_11_3, act_0_11_4, act_0_11_5, act_0_11_6, act_0_11_7, act_0_11_8, act_0_11_9, act_0_12_0, act_0_12_1, act_0_12_2, act_0_12_3, act_0_12_4, act_0_12_5 : lut_output_t_0;
  signal act_0_12_6, act_0_12_7, act_0_12_8, act_0_12_9, act_0_13_0, act_0_13_1, act_0_13_2, act_0_13_3, act_0_13_4, act_0_13_5, act_0_13_6, act_0_13_7, act_0_13_8, act_0_13_9, act_0_14_0, act_0_14_1 : lut_output_t_0;
  signal act_0_14_2, act_0_14_3, act_0_14_5, act_0_14_6, act_0_14_7, act_0_14_8, act_0_14_9, act_0_15_0, act_0_15_1, act_0_15_2, act_0_15_3, act_0_15_4, act_0_15_5, act_0_15_6, act_0_15_7, act_0_15_8 : lut_output_t_0;
  signal act_0_15_9, act_0_16_0, act_0_16_1, act_0_16_2, act_0_16_3, act_0_16_4, act_0_16_5, act_0_16_6, act_0_16_7, act_0_16_8, act_0_16_9, act_0_17_0, act_0_17_1, act_0_17_2, act_0_17_3, act_0_17_4 : lut_output_t_0;
  signal act_0_17_5, act_0_17_6, act_0_17_7, act_0_17_8, act_0_17_9, act_0_18_0, act_0_18_1, act_0_18_2, act_0_18_3, act_0_18_4, act_0_18_5, act_0_18_6, act_0_18_7, act_0_18_8, act_0_18_9, act_0_19_0 : lut_output_t_0;
  signal act_0_19_2, act_0_19_4, act_0_19_5, act_0_19_6, act_0_19_7, act_0_19_8, act_0_19_9, act_0_20_0, act_0_20_1, act_0_20_2, act_0_20_3, act_0_20_4, act_0_20_5, act_0_20_6, act_0_20_7, act_0_20_8 : lut_output_t_0;
  signal act_0_20_9, act_0_21_0, act_0_21_1, act_0_21_2, act_0_21_3, act_0_21_4, act_0_21_5, act_0_21_6, act_0_21_7, act_0_21_8, act_0_22_0, act_0_22_1, act_0_22_2, act_0_22_3, act_0_22_4, act_0_22_5 : lut_output_t_0;
  signal act_0_22_6, act_0_22_7, act_0_22_8, act_0_22_9, act_0_23_0, act_0_23_1, act_0_23_2, act_0_23_3, act_0_23_4, act_0_23_6, act_0_23_7, act_0_23_8, act_0_23_9, act_0_24_1, act_0_24_2, act_0_24_3 : lut_output_t_0;
  signal act_0_24_4, act_0_24_5, act_0_24_6, act_0_24_7, act_0_24_8, act_0_24_9, act_0_25_3, act_0_25_4, act_0_25_6, act_0_25_7, act_0_26_0, act_0_26_1, act_0_26_2, act_0_26_3, act_0_26_4, act_0_26_5 : lut_output_t_0;
  signal act_0_26_6, act_0_26_7, act_0_26_8, act_0_26_9, act_0_27_0, act_0_27_1, act_0_27_2, act_0_27_3, act_0_27_4, act_0_27_5, act_0_27_6, act_0_27_7, act_0_27_8, act_0_27_9, act_0_28_0, act_0_28_1 : lut_output_t_0;
  signal act_0_28_2, act_0_28_3, act_0_28_4, act_0_28_5, act_0_28_6, act_0_28_7, act_0_28_8, act_0_28_9, act_0_29_0, act_0_29_1, act_0_29_3, act_0_29_4, act_0_29_5, act_0_29_6, act_0_29_7, act_0_29_8 : lut_output_t_0;
  signal act_0_29_9, act_0_30_0, act_0_30_1, act_0_30_2, act_0_30_3, act_0_30_4, act_0_30_5, act_0_30_7, act_0_30_8, act_0_30_9, act_0_31_0, act_0_31_1, act_0_31_2, act_0_31_3, act_0_31_4, act_0_31_5 : lut_output_t_0;
  signal act_0_31_6, act_0_31_7, act_0_31_8, act_0_31_9, act_0_32_0, act_0_32_1, act_0_32_2, act_0_32_3, act_0_32_4, act_0_32_5, act_0_32_6, act_0_32_7, act_0_32_8, act_0_32_9, act_0_33_0, act_0_33_1 : lut_output_t_0;
  signal act_0_33_2, act_0_33_3, act_0_33_4, act_0_33_5, act_0_33_6, act_0_33_7, act_0_33_8, act_0_33_9, act_0_34_0, act_0_34_1, act_0_34_3, act_0_34_4, act_0_34_5, act_0_34_6, act_0_34_7, act_0_34_8 : lut_output_t_0;
  signal act_0_34_9, act_0_35_0, act_0_35_1, act_0_35_2, act_0_35_3, act_0_35_4, act_0_35_7, act_0_35_8, act_0_35_9, act_0_36_0, act_0_36_1, act_0_36_2, act_0_36_3, act_0_36_4, act_0_36_5, act_0_36_6 : lut_output_t_0;
  signal act_0_36_7, act_0_36_8, act_0_36_9, act_0_37_0, act_0_37_1, act_0_37_2, act_0_37_3, act_0_37_4, act_0_37_5, act_0_37_6, act_0_37_7, act_0_37_8, act_0_37_9, act_0_38_0, act_0_38_1, act_0_38_2 : lut_output_t_0;
  signal act_0_38_4, act_0_38_5, act_0_38_6, act_0_38_7, act_0_38_8, act_0_38_9, act_0_39_0, act_0_39_1, act_0_39_2, act_0_39_3, act_0_39_4, act_0_39_5, act_0_39_6, act_0_39_7, act_0_39_8, act_0_39_9 : lut_output_t_0;
  signal act_0_40_0, act_0_40_1, act_0_40_2, act_0_40_3, act_0_40_4, act_0_40_5, act_0_40_6, act_0_40_7, act_0_40_8, act_0_40_9, act_0_41_0, act_0_41_1, act_0_41_2, act_0_41_3, act_0_41_4, act_0_41_5 : lut_output_t_0;
  signal act_0_41_6, act_0_41_7, act_0_41_8, act_0_41_9, act_0_42_0, act_0_42_1, act_0_42_2, act_0_42_3, act_0_42_4, act_0_42_5, act_0_42_6, act_0_42_7, act_0_42_8, act_0_42_9, act_0_43_1, act_0_43_3 : lut_output_t_0;
  signal act_0_43_4, act_0_43_5, act_0_43_6, act_0_43_7, act_0_43_8, act_0_43_9, act_0_44_0, act_0_44_1, act_0_44_3, act_0_44_4, act_0_44_5, act_0_44_6, act_0_44_7, act_0_44_9, act_0_45_0, act_0_45_1 : lut_output_t_0;
  signal act_0_45_2, act_0_45_3, act_0_45_4, act_0_45_5, act_0_45_7, act_0_45_8, act_0_45_9, act_0_46_0, act_0_46_1, act_0_46_2, act_0_46_3, act_0_46_4, act_0_46_5, act_0_46_6, act_0_46_7, act_0_46_8 : lut_output_t_0;
  signal act_0_46_9, act_0_47_0, act_0_47_1, act_0_47_2, act_0_47_3, act_0_47_4, act_0_47_5, act_0_47_6, act_0_47_7, act_0_47_8, act_0_47_9, act_0_48_0, act_0_48_1, act_0_48_2, act_0_48_3, act_0_48_4 : lut_output_t_0;
  signal act_0_48_5, act_0_48_6, act_0_48_7, act_0_48_8, act_0_48_9, act_0_49_0, act_0_49_1, act_0_49_2, act_0_49_3, act_0_49_4, act_0_49_5, act_0_49_7, act_0_49_9 : lut_output_t_0;
begin

  -- === auto: layer blocks ===
  -- LAYER 0, ch 0
  gen_l0c0 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_0;
  signal s2_0, s2_1, s2_2 : sum_t_0_0;
  signal sum_0_0 : sum_t_0_0;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_0.mem") port map (clk, input(0), act_0_0_0);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_0.mem") port map (clk, input(1), act_0_1_0);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_0.mem") port map (clk, input(2), act_0_2_0);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_0.mem") port map (clk, input(3), act_0_3_0);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_0.mem") port map (clk, input(4), act_0_4_0);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_0.mem") port map (clk, input(6), act_0_6_0);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_0.mem") port map (clk, input(7), act_0_7_0);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_0.mem") port map (clk, input(8), act_0_8_0);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_0.mem") port map (clk, input(9), act_0_9_0);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_0.mem") port map (clk, input(10), act_0_10_0);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_0.mem") port map (clk, input(11), act_0_11_0);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_0.mem") port map (clk, input(12), act_0_12_0);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_0.mem") port map (clk, input(13), act_0_13_0);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_0.mem") port map (clk, input(14), act_0_14_0);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_0.mem") port map (clk, input(15), act_0_15_0);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_0.mem") port map (clk, input(16), act_0_16_0);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_0.mem") port map (clk, input(17), act_0_17_0);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_0.mem") port map (clk, input(18), act_0_18_0);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_0.mem") port map (clk, input(19), act_0_19_0);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_0.mem") port map (clk, input(20), act_0_20_0);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_0.mem") port map (clk, input(21), act_0_21_0);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_0.mem") port map (clk, input(22), act_0_22_0);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_0.mem") port map (clk, input(23), act_0_23_0);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_0.mem") port map (clk, input(26), act_0_26_0);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_0.mem") port map (clk, input(27), act_0_27_0);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_0.mem") port map (clk, input(28), act_0_28_0);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_0.mem") port map (clk, input(29), act_0_29_0);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_0.mem") port map (clk, input(30), act_0_30_0);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_0.mem") port map (clk, input(31), act_0_31_0);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_0.mem") port map (clk, input(32), act_0_32_0);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_0.mem") port map (clk, input(33), act_0_33_0);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_0.mem") port map (clk, input(34), act_0_34_0);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_0.mem") port map (clk, input(35), act_0_35_0);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_0.mem") port map (clk, input(36), act_0_36_0);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_0.mem") port map (clk, input(37), act_0_37_0);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_0.mem") port map (clk, input(38), act_0_38_0);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_0.mem") port map (clk, input(39), act_0_39_0);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_0.mem") port map (clk, input(40), act_0_40_0);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_0.mem") port map (clk, input(41), act_0_41_0);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_0.mem") port map (clk, input(42), act_0_42_0);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_0.mem") port map (clk, input(44), act_0_44_0);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_0.mem") port map (clk, input(45), act_0_45_0);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_0.mem") port map (clk, input(46), act_0_46_0);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_0.mem") port map (clk, input(47), act_0_47_0);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_0.mem") port map (clk, input(48), act_0_48_0);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_0.mem") port map (clk, input(49), act_0_49_0);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_0, SUM_WIDTH_0_0) + resize(act_0_1_0, SUM_WIDTH_0_0) + resize(act_0_2_0, SUM_WIDTH_0_0) + resize(act_0_3_0, SUM_WIDTH_0_0);
        s1_1 <= resize(act_0_4_0, SUM_WIDTH_0_0) + resize(act_0_6_0, SUM_WIDTH_0_0) + resize(act_0_7_0, SUM_WIDTH_0_0) + resize(act_0_8_0, SUM_WIDTH_0_0);
        s1_2 <= resize(act_0_9_0, SUM_WIDTH_0_0) + resize(act_0_10_0, SUM_WIDTH_0_0) + resize(act_0_11_0, SUM_WIDTH_0_0) + resize(act_0_12_0, SUM_WIDTH_0_0);
        s1_3 <= resize(act_0_13_0, SUM_WIDTH_0_0) + resize(act_0_14_0, SUM_WIDTH_0_0) + resize(act_0_15_0, SUM_WIDTH_0_0) + resize(act_0_16_0, SUM_WIDTH_0_0);
        s1_4 <= resize(act_0_17_0, SUM_WIDTH_0_0) + resize(act_0_18_0, SUM_WIDTH_0_0) + resize(act_0_19_0, SUM_WIDTH_0_0) + resize(act_0_20_0, SUM_WIDTH_0_0);
        s1_5 <= resize(act_0_21_0, SUM_WIDTH_0_0) + resize(act_0_22_0, SUM_WIDTH_0_0) + resize(act_0_23_0, SUM_WIDTH_0_0) + resize(act_0_26_0, SUM_WIDTH_0_0);
        s1_6 <= resize(act_0_27_0, SUM_WIDTH_0_0) + resize(act_0_28_0, SUM_WIDTH_0_0) + resize(act_0_29_0, SUM_WIDTH_0_0) + resize(act_0_30_0, SUM_WIDTH_0_0);
        s1_7 <= resize(act_0_31_0, SUM_WIDTH_0_0) + resize(act_0_32_0, SUM_WIDTH_0_0) + resize(act_0_33_0, SUM_WIDTH_0_0) + resize(act_0_34_0, SUM_WIDTH_0_0);
        s1_8 <= resize(act_0_35_0, SUM_WIDTH_0_0) + resize(act_0_36_0, SUM_WIDTH_0_0) + resize(act_0_37_0, SUM_WIDTH_0_0) + resize(act_0_38_0, SUM_WIDTH_0_0);
        s1_9 <= resize(act_0_39_0, SUM_WIDTH_0_0) + resize(act_0_40_0, SUM_WIDTH_0_0) + resize(act_0_41_0, SUM_WIDTH_0_0) + resize(act_0_42_0, SUM_WIDTH_0_0);
        s1_10 <= resize(act_0_44_0, SUM_WIDTH_0_0) + resize(act_0_45_0, SUM_WIDTH_0_0) + resize(act_0_46_0, SUM_WIDTH_0_0) + resize(act_0_47_0, SUM_WIDTH_0_0);
        s1_11 <= resize(act_0_48_0, SUM_WIDTH_0_0) + resize(act_0_49_0, SUM_WIDTH_0_0);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_0 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(0) <= saturate(sum_0_0, 8);
  end block;

  -- LAYER 0, ch 1
  gen_l0c1 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_1;
  signal s2_0, s2_1, s2_2 : sum_t_0_1;
  signal sum_0_1 : sum_t_0_1;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_1.mem") port map (clk, input(1), act_0_1_1);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_1.mem") port map (clk, input(2), act_0_2_1);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_1.mem") port map (clk, input(3), act_0_3_1);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_1.mem") port map (clk, input(4), act_0_4_1);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_1.mem") port map (clk, input(6), act_0_6_1);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_1.mem") port map (clk, input(7), act_0_7_1);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_1.mem") port map (clk, input(8), act_0_8_1);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_1.mem") port map (clk, input(9), act_0_9_1);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_1.mem") port map (clk, input(10), act_0_10_1);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_1.mem") port map (clk, input(11), act_0_11_1);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_1.mem") port map (clk, input(12), act_0_12_1);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_1.mem") port map (clk, input(13), act_0_13_1);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_1.mem") port map (clk, input(14), act_0_14_1);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_1.mem") port map (clk, input(15), act_0_15_1);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_1.mem") port map (clk, input(16), act_0_16_1);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_1.mem") port map (clk, input(17), act_0_17_1);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_1.mem") port map (clk, input(18), act_0_18_1);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_1.mem") port map (clk, input(20), act_0_20_1);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_1.mem") port map (clk, input(21), act_0_21_1);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_1.mem") port map (clk, input(22), act_0_22_1);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_1.mem") port map (clk, input(23), act_0_23_1);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_1.mem") port map (clk, input(24), act_0_24_1);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_1.mem") port map (clk, input(26), act_0_26_1);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_1.mem") port map (clk, input(27), act_0_27_1);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_1.mem") port map (clk, input(28), act_0_28_1);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_1.mem") port map (clk, input(29), act_0_29_1);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_1.mem") port map (clk, input(30), act_0_30_1);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_1.mem") port map (clk, input(31), act_0_31_1);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_1.mem") port map (clk, input(32), act_0_32_1);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_1.mem") port map (clk, input(33), act_0_33_1);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_1.mem") port map (clk, input(34), act_0_34_1);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_1.mem") port map (clk, input(35), act_0_35_1);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_1.mem") port map (clk, input(36), act_0_36_1);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_1.mem") port map (clk, input(37), act_0_37_1);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_1.mem") port map (clk, input(38), act_0_38_1);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_1.mem") port map (clk, input(39), act_0_39_1);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_1.mem") port map (clk, input(40), act_0_40_1);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_1.mem") port map (clk, input(41), act_0_41_1);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_1.mem") port map (clk, input(42), act_0_42_1);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_1.mem") port map (clk, input(43), act_0_43_1);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_1.mem") port map (clk, input(44), act_0_44_1);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_1.mem") port map (clk, input(45), act_0_45_1);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_1.mem") port map (clk, input(46), act_0_46_1);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_1.mem") port map (clk, input(47), act_0_47_1);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_1.mem") port map (clk, input(48), act_0_48_1);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_1.mem") port map (clk, input(49), act_0_49_1);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_1, SUM_WIDTH_0_1) + resize(act_0_2_1, SUM_WIDTH_0_1) + resize(act_0_3_1, SUM_WIDTH_0_1) + resize(act_0_4_1, SUM_WIDTH_0_1);
        s1_1 <= resize(act_0_6_1, SUM_WIDTH_0_1) + resize(act_0_7_1, SUM_WIDTH_0_1) + resize(act_0_8_1, SUM_WIDTH_0_1) + resize(act_0_9_1, SUM_WIDTH_0_1);
        s1_2 <= resize(act_0_10_1, SUM_WIDTH_0_1) + resize(act_0_11_1, SUM_WIDTH_0_1) + resize(act_0_12_1, SUM_WIDTH_0_1) + resize(act_0_13_1, SUM_WIDTH_0_1);
        s1_3 <= resize(act_0_14_1, SUM_WIDTH_0_1) + resize(act_0_15_1, SUM_WIDTH_0_1) + resize(act_0_16_1, SUM_WIDTH_0_1) + resize(act_0_17_1, SUM_WIDTH_0_1);
        s1_4 <= resize(act_0_18_1, SUM_WIDTH_0_1) + resize(act_0_20_1, SUM_WIDTH_0_1) + resize(act_0_21_1, SUM_WIDTH_0_1) + resize(act_0_22_1, SUM_WIDTH_0_1);
        s1_5 <= resize(act_0_23_1, SUM_WIDTH_0_1) + resize(act_0_24_1, SUM_WIDTH_0_1) + resize(act_0_26_1, SUM_WIDTH_0_1) + resize(act_0_27_1, SUM_WIDTH_0_1);
        s1_6 <= resize(act_0_28_1, SUM_WIDTH_0_1) + resize(act_0_29_1, SUM_WIDTH_0_1) + resize(act_0_30_1, SUM_WIDTH_0_1) + resize(act_0_31_1, SUM_WIDTH_0_1);
        s1_7 <= resize(act_0_32_1, SUM_WIDTH_0_1) + resize(act_0_33_1, SUM_WIDTH_0_1) + resize(act_0_34_1, SUM_WIDTH_0_1) + resize(act_0_35_1, SUM_WIDTH_0_1);
        s1_8 <= resize(act_0_36_1, SUM_WIDTH_0_1) + resize(act_0_37_1, SUM_WIDTH_0_1) + resize(act_0_38_1, SUM_WIDTH_0_1) + resize(act_0_39_1, SUM_WIDTH_0_1);
        s1_9 <= resize(act_0_40_1, SUM_WIDTH_0_1) + resize(act_0_41_1, SUM_WIDTH_0_1) + resize(act_0_42_1, SUM_WIDTH_0_1) + resize(act_0_43_1, SUM_WIDTH_0_1);
        s1_10 <= resize(act_0_44_1, SUM_WIDTH_0_1) + resize(act_0_45_1, SUM_WIDTH_0_1) + resize(act_0_46_1, SUM_WIDTH_0_1) + resize(act_0_47_1, SUM_WIDTH_0_1);
        s1_11 <= resize(act_0_48_1, SUM_WIDTH_0_1) + resize(act_0_49_1, SUM_WIDTH_0_1);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_1 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(1) <= saturate(sum_0_1, 8);
  end block;

  -- LAYER 0, ch 2
  gen_l0c2 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_2;
  signal s2_0, s2_1, s2_2 : sum_t_0_2;
  signal sum_0_2 : sum_t_0_2;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_2.mem") port map (clk, input(0), act_0_0_2);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_2.mem") port map (clk, input(1), act_0_1_2);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_2.mem") port map (clk, input(2), act_0_2_2);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_2.mem") port map (clk, input(3), act_0_3_2);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_2.mem") port map (clk, input(4), act_0_4_2);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_2.mem") port map (clk, input(5), act_0_5_2);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_2.mem") port map (clk, input(6), act_0_6_2);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_2.mem") port map (clk, input(7), act_0_7_2);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_2.mem") port map (clk, input(8), act_0_8_2);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_2.mem") port map (clk, input(9), act_0_9_2);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_2.mem") port map (clk, input(10), act_0_10_2);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_2.mem") port map (clk, input(11), act_0_11_2);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_2.mem") port map (clk, input(12), act_0_12_2);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_2.mem") port map (clk, input(13), act_0_13_2);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_2.mem") port map (clk, input(14), act_0_14_2);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_2.mem") port map (clk, input(15), act_0_15_2);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_2.mem") port map (clk, input(16), act_0_16_2);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_2.mem") port map (clk, input(17), act_0_17_2);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_2.mem") port map (clk, input(18), act_0_18_2);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_2.mem") port map (clk, input(19), act_0_19_2);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_2.mem") port map (clk, input(20), act_0_20_2);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_2.mem") port map (clk, input(21), act_0_21_2);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_2.mem") port map (clk, input(22), act_0_22_2);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_2.mem") port map (clk, input(23), act_0_23_2);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_2.mem") port map (clk, input(24), act_0_24_2);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_2.mem") port map (clk, input(26), act_0_26_2);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_2.mem") port map (clk, input(27), act_0_27_2);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_2.mem") port map (clk, input(28), act_0_28_2);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_2.mem") port map (clk, input(30), act_0_30_2);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_2.mem") port map (clk, input(31), act_0_31_2);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_2.mem") port map (clk, input(32), act_0_32_2);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_2.mem") port map (clk, input(33), act_0_33_2);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_2.mem") port map (clk, input(35), act_0_35_2);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_2.mem") port map (clk, input(36), act_0_36_2);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_2.mem") port map (clk, input(37), act_0_37_2);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_2.mem") port map (clk, input(38), act_0_38_2);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_2.mem") port map (clk, input(39), act_0_39_2);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_2.mem") port map (clk, input(40), act_0_40_2);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_2.mem") port map (clk, input(41), act_0_41_2);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_2.mem") port map (clk, input(42), act_0_42_2);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_2.mem") port map (clk, input(45), act_0_45_2);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_2.mem") port map (clk, input(46), act_0_46_2);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_2.mem") port map (clk, input(47), act_0_47_2);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_2.mem") port map (clk, input(48), act_0_48_2);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_2.mem") port map (clk, input(49), act_0_49_2);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_2, SUM_WIDTH_0_2) + resize(act_0_1_2, SUM_WIDTH_0_2) + resize(act_0_2_2, SUM_WIDTH_0_2) + resize(act_0_3_2, SUM_WIDTH_0_2);
        s1_1 <= resize(act_0_4_2, SUM_WIDTH_0_2) + resize(act_0_5_2, SUM_WIDTH_0_2) + resize(act_0_6_2, SUM_WIDTH_0_2) + resize(act_0_7_2, SUM_WIDTH_0_2);
        s1_2 <= resize(act_0_8_2, SUM_WIDTH_0_2) + resize(act_0_9_2, SUM_WIDTH_0_2) + resize(act_0_10_2, SUM_WIDTH_0_2) + resize(act_0_11_2, SUM_WIDTH_0_2);
        s1_3 <= resize(act_0_12_2, SUM_WIDTH_0_2) + resize(act_0_13_2, SUM_WIDTH_0_2) + resize(act_0_14_2, SUM_WIDTH_0_2) + resize(act_0_15_2, SUM_WIDTH_0_2);
        s1_4 <= resize(act_0_16_2, SUM_WIDTH_0_2) + resize(act_0_17_2, SUM_WIDTH_0_2) + resize(act_0_18_2, SUM_WIDTH_0_2) + resize(act_0_19_2, SUM_WIDTH_0_2);
        s1_5 <= resize(act_0_20_2, SUM_WIDTH_0_2) + resize(act_0_21_2, SUM_WIDTH_0_2) + resize(act_0_22_2, SUM_WIDTH_0_2) + resize(act_0_23_2, SUM_WIDTH_0_2);
        s1_6 <= resize(act_0_24_2, SUM_WIDTH_0_2) + resize(act_0_26_2, SUM_WIDTH_0_2) + resize(act_0_27_2, SUM_WIDTH_0_2) + resize(act_0_28_2, SUM_WIDTH_0_2);
        s1_7 <= resize(act_0_30_2, SUM_WIDTH_0_2) + resize(act_0_31_2, SUM_WIDTH_0_2) + resize(act_0_32_2, SUM_WIDTH_0_2) + resize(act_0_33_2, SUM_WIDTH_0_2);
        s1_8 <= resize(act_0_35_2, SUM_WIDTH_0_2) + resize(act_0_36_2, SUM_WIDTH_0_2) + resize(act_0_37_2, SUM_WIDTH_0_2) + resize(act_0_38_2, SUM_WIDTH_0_2);
        s1_9 <= resize(act_0_39_2, SUM_WIDTH_0_2) + resize(act_0_40_2, SUM_WIDTH_0_2) + resize(act_0_41_2, SUM_WIDTH_0_2) + resize(act_0_42_2, SUM_WIDTH_0_2);
        s1_10 <= resize(act_0_45_2, SUM_WIDTH_0_2) + resize(act_0_46_2, SUM_WIDTH_0_2) + resize(act_0_47_2, SUM_WIDTH_0_2) + resize(act_0_48_2, SUM_WIDTH_0_2);
        s1_11 <= resize(act_0_49_2, SUM_WIDTH_0_2);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_2 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(2) <= saturate(sum_0_2, 8);
  end block;

  -- LAYER 0, ch 3
  gen_l0c3 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_3;
  signal s2_0, s2_1, s2_2 : sum_t_0_3;
  signal sum_0_3 : sum_t_0_3;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_3.mem") port map (clk, input(1), act_0_1_3);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_3.mem") port map (clk, input(2), act_0_2_3);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_3.mem") port map (clk, input(3), act_0_3_3);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_3.mem") port map (clk, input(4), act_0_4_3);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_3.mem") port map (clk, input(5), act_0_5_3);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_3.mem") port map (clk, input(6), act_0_6_3);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_3.mem") port map (clk, input(7), act_0_7_3);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_3.mem") port map (clk, input(8), act_0_8_3);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_3.mem") port map (clk, input(10), act_0_10_3);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_3.mem") port map (clk, input(11), act_0_11_3);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_3.mem") port map (clk, input(12), act_0_12_3);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_3.mem") port map (clk, input(13), act_0_13_3);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_3.mem") port map (clk, input(14), act_0_14_3);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_3.mem") port map (clk, input(15), act_0_15_3);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_3.mem") port map (clk, input(16), act_0_16_3);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_3.mem") port map (clk, input(17), act_0_17_3);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_3.mem") port map (clk, input(18), act_0_18_3);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_3.mem") port map (clk, input(20), act_0_20_3);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_3.mem") port map (clk, input(21), act_0_21_3);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_3.mem") port map (clk, input(22), act_0_22_3);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_3.mem") port map (clk, input(23), act_0_23_3);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_3.mem") port map (clk, input(24), act_0_24_3);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_3.mem") port map (clk, input(25), act_0_25_3);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_3.mem") port map (clk, input(26), act_0_26_3);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_3.mem") port map (clk, input(27), act_0_27_3);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_3.mem") port map (clk, input(28), act_0_28_3);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_3.mem") port map (clk, input(29), act_0_29_3);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_3.mem") port map (clk, input(30), act_0_30_3);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_3.mem") port map (clk, input(31), act_0_31_3);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_3.mem") port map (clk, input(32), act_0_32_3);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_3.mem") port map (clk, input(33), act_0_33_3);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_3.mem") port map (clk, input(34), act_0_34_3);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_3.mem") port map (clk, input(35), act_0_35_3);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_3.mem") port map (clk, input(36), act_0_36_3);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_3.mem") port map (clk, input(37), act_0_37_3);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_3.mem") port map (clk, input(39), act_0_39_3);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_3.mem") port map (clk, input(40), act_0_40_3);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_3.mem") port map (clk, input(41), act_0_41_3);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_3.mem") port map (clk, input(42), act_0_42_3);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_3.mem") port map (clk, input(43), act_0_43_3);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_3.mem") port map (clk, input(44), act_0_44_3);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_3.mem") port map (clk, input(45), act_0_45_3);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_3.mem") port map (clk, input(46), act_0_46_3);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_3.mem") port map (clk, input(47), act_0_47_3);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_3.mem") port map (clk, input(48), act_0_48_3);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_3.mem") port map (clk, input(49), act_0_49_3);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_3, SUM_WIDTH_0_3) + resize(act_0_2_3, SUM_WIDTH_0_3) + resize(act_0_3_3, SUM_WIDTH_0_3) + resize(act_0_4_3, SUM_WIDTH_0_3);
        s1_1 <= resize(act_0_5_3, SUM_WIDTH_0_3) + resize(act_0_6_3, SUM_WIDTH_0_3) + resize(act_0_7_3, SUM_WIDTH_0_3) + resize(act_0_8_3, SUM_WIDTH_0_3);
        s1_2 <= resize(act_0_10_3, SUM_WIDTH_0_3) + resize(act_0_11_3, SUM_WIDTH_0_3) + resize(act_0_12_3, SUM_WIDTH_0_3) + resize(act_0_13_3, SUM_WIDTH_0_3);
        s1_3 <= resize(act_0_14_3, SUM_WIDTH_0_3) + resize(act_0_15_3, SUM_WIDTH_0_3) + resize(act_0_16_3, SUM_WIDTH_0_3) + resize(act_0_17_3, SUM_WIDTH_0_3);
        s1_4 <= resize(act_0_18_3, SUM_WIDTH_0_3) + resize(act_0_20_3, SUM_WIDTH_0_3) + resize(act_0_21_3, SUM_WIDTH_0_3) + resize(act_0_22_3, SUM_WIDTH_0_3);
        s1_5 <= resize(act_0_23_3, SUM_WIDTH_0_3) + resize(act_0_24_3, SUM_WIDTH_0_3) + resize(act_0_25_3, SUM_WIDTH_0_3) + resize(act_0_26_3, SUM_WIDTH_0_3);
        s1_6 <= resize(act_0_27_3, SUM_WIDTH_0_3) + resize(act_0_28_3, SUM_WIDTH_0_3) + resize(act_0_29_3, SUM_WIDTH_0_3) + resize(act_0_30_3, SUM_WIDTH_0_3);
        s1_7 <= resize(act_0_31_3, SUM_WIDTH_0_3) + resize(act_0_32_3, SUM_WIDTH_0_3) + resize(act_0_33_3, SUM_WIDTH_0_3) + resize(act_0_34_3, SUM_WIDTH_0_3);
        s1_8 <= resize(act_0_35_3, SUM_WIDTH_0_3) + resize(act_0_36_3, SUM_WIDTH_0_3) + resize(act_0_37_3, SUM_WIDTH_0_3) + resize(act_0_39_3, SUM_WIDTH_0_3);
        s1_9 <= resize(act_0_40_3, SUM_WIDTH_0_3) + resize(act_0_41_3, SUM_WIDTH_0_3) + resize(act_0_42_3, SUM_WIDTH_0_3) + resize(act_0_43_3, SUM_WIDTH_0_3);
        s1_10 <= resize(act_0_44_3, SUM_WIDTH_0_3) + resize(act_0_45_3, SUM_WIDTH_0_3) + resize(act_0_46_3, SUM_WIDTH_0_3) + resize(act_0_47_3, SUM_WIDTH_0_3);
        s1_11 <= resize(act_0_48_3, SUM_WIDTH_0_3) + resize(act_0_49_3, SUM_WIDTH_0_3);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_3 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(3) <= saturate(sum_0_3, 8);
  end block;

  -- LAYER 0, ch 4
  gen_l0c4 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_4;
  signal s2_0, s2_1, s2_2 : sum_t_0_4;
  signal sum_0_4 : sum_t_0_4;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_4.mem") port map (clk, input(1), act_0_1_4);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_4.mem") port map (clk, input(2), act_0_2_4);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_4.mem") port map (clk, input(3), act_0_3_4);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_4.mem") port map (clk, input(4), act_0_4_4);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_4.mem") port map (clk, input(5), act_0_5_4);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_4.mem") port map (clk, input(6), act_0_6_4);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_4.mem") port map (clk, input(7), act_0_7_4);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_4.mem") port map (clk, input(8), act_0_8_4);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_4.mem") port map (clk, input(9), act_0_9_4);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_4.mem") port map (clk, input(10), act_0_10_4);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_4.mem") port map (clk, input(11), act_0_11_4);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_4.mem") port map (clk, input(12), act_0_12_4);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_4.mem") port map (clk, input(13), act_0_13_4);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_4.mem") port map (clk, input(15), act_0_15_4);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_4.mem") port map (clk, input(16), act_0_16_4);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_4.mem") port map (clk, input(17), act_0_17_4);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_4.mem") port map (clk, input(18), act_0_18_4);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_4.mem") port map (clk, input(19), act_0_19_4);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_4.mem") port map (clk, input(20), act_0_20_4);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_4.mem") port map (clk, input(21), act_0_21_4);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_4.mem") port map (clk, input(22), act_0_22_4);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_4.mem") port map (clk, input(23), act_0_23_4);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_4.mem") port map (clk, input(24), act_0_24_4);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_4.mem") port map (clk, input(25), act_0_25_4);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_4.mem") port map (clk, input(26), act_0_26_4);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_4.mem") port map (clk, input(27), act_0_27_4);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_4.mem") port map (clk, input(28), act_0_28_4);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_4.mem") port map (clk, input(29), act_0_29_4);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_4.mem") port map (clk, input(30), act_0_30_4);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_4.mem") port map (clk, input(31), act_0_31_4);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_4.mem") port map (clk, input(32), act_0_32_4);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_4.mem") port map (clk, input(33), act_0_33_4);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_4.mem") port map (clk, input(34), act_0_34_4);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_4.mem") port map (clk, input(35), act_0_35_4);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_4.mem") port map (clk, input(36), act_0_36_4);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_4.mem") port map (clk, input(37), act_0_37_4);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_4.mem") port map (clk, input(38), act_0_38_4);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_4.mem") port map (clk, input(39), act_0_39_4);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_4.mem") port map (clk, input(40), act_0_40_4);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_4.mem") port map (clk, input(41), act_0_41_4);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_4.mem") port map (clk, input(42), act_0_42_4);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_4.mem") port map (clk, input(43), act_0_43_4);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_4.mem") port map (clk, input(44), act_0_44_4);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_4.mem") port map (clk, input(45), act_0_45_4);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_4.mem") port map (clk, input(46), act_0_46_4);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_4.mem") port map (clk, input(47), act_0_47_4);
    i46 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_4.mem") port map (clk, input(48), act_0_48_4);
    i47 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_4.mem") port map (clk, input(49), act_0_49_4);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_4, SUM_WIDTH_0_4) + resize(act_0_2_4, SUM_WIDTH_0_4) + resize(act_0_3_4, SUM_WIDTH_0_4) + resize(act_0_4_4, SUM_WIDTH_0_4);
        s1_1 <= resize(act_0_5_4, SUM_WIDTH_0_4) + resize(act_0_6_4, SUM_WIDTH_0_4) + resize(act_0_7_4, SUM_WIDTH_0_4) + resize(act_0_8_4, SUM_WIDTH_0_4);
        s1_2 <= resize(act_0_9_4, SUM_WIDTH_0_4) + resize(act_0_10_4, SUM_WIDTH_0_4) + resize(act_0_11_4, SUM_WIDTH_0_4) + resize(act_0_12_4, SUM_WIDTH_0_4);
        s1_3 <= resize(act_0_13_4, SUM_WIDTH_0_4) + resize(act_0_15_4, SUM_WIDTH_0_4) + resize(act_0_16_4, SUM_WIDTH_0_4) + resize(act_0_17_4, SUM_WIDTH_0_4);
        s1_4 <= resize(act_0_18_4, SUM_WIDTH_0_4) + resize(act_0_19_4, SUM_WIDTH_0_4) + resize(act_0_20_4, SUM_WIDTH_0_4) + resize(act_0_21_4, SUM_WIDTH_0_4);
        s1_5 <= resize(act_0_22_4, SUM_WIDTH_0_4) + resize(act_0_23_4, SUM_WIDTH_0_4) + resize(act_0_24_4, SUM_WIDTH_0_4) + resize(act_0_25_4, SUM_WIDTH_0_4);
        s1_6 <= resize(act_0_26_4, SUM_WIDTH_0_4) + resize(act_0_27_4, SUM_WIDTH_0_4) + resize(act_0_28_4, SUM_WIDTH_0_4) + resize(act_0_29_4, SUM_WIDTH_0_4);
        s1_7 <= resize(act_0_30_4, SUM_WIDTH_0_4) + resize(act_0_31_4, SUM_WIDTH_0_4) + resize(act_0_32_4, SUM_WIDTH_0_4) + resize(act_0_33_4, SUM_WIDTH_0_4);
        s1_8 <= resize(act_0_34_4, SUM_WIDTH_0_4) + resize(act_0_35_4, SUM_WIDTH_0_4) + resize(act_0_36_4, SUM_WIDTH_0_4) + resize(act_0_37_4, SUM_WIDTH_0_4);
        s1_9 <= resize(act_0_38_4, SUM_WIDTH_0_4) + resize(act_0_39_4, SUM_WIDTH_0_4) + resize(act_0_40_4, SUM_WIDTH_0_4) + resize(act_0_41_4, SUM_WIDTH_0_4);
        s1_10 <= resize(act_0_42_4, SUM_WIDTH_0_4) + resize(act_0_43_4, SUM_WIDTH_0_4) + resize(act_0_44_4, SUM_WIDTH_0_4) + resize(act_0_45_4, SUM_WIDTH_0_4);
        s1_11 <= resize(act_0_46_4, SUM_WIDTH_0_4) + resize(act_0_47_4, SUM_WIDTH_0_4) + resize(act_0_48_4, SUM_WIDTH_0_4) + resize(act_0_49_4, SUM_WIDTH_0_4);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_4 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(4) <= saturate(sum_0_4, 8);
  end block;

  -- LAYER 0, ch 5
  gen_l0c5 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_5;
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
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_5.mem") port map (clk, input(22), act_0_22_5);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_5.mem") port map (clk, input(24), act_0_24_5);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_5.mem") port map (clk, input(26), act_0_26_5);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_5.mem") port map (clk, input(27), act_0_27_5);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_5.mem") port map (clk, input(28), act_0_28_5);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_5.mem") port map (clk, input(29), act_0_29_5);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_5.mem") port map (clk, input(30), act_0_30_5);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_5.mem") port map (clk, input(31), act_0_31_5);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_5.mem") port map (clk, input(32), act_0_32_5);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_5.mem") port map (clk, input(33), act_0_33_5);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_5.mem") port map (clk, input(34), act_0_34_5);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_5.mem") port map (clk, input(36), act_0_36_5);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_5.mem") port map (clk, input(37), act_0_37_5);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_5.mem") port map (clk, input(38), act_0_38_5);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_5.mem") port map (clk, input(39), act_0_39_5);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_5.mem") port map (clk, input(40), act_0_40_5);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_5.mem") port map (clk, input(41), act_0_41_5);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_5.mem") port map (clk, input(42), act_0_42_5);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_5.mem") port map (clk, input(43), act_0_43_5);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_5.mem") port map (clk, input(44), act_0_44_5);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_5.mem") port map (clk, input(45), act_0_45_5);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_5.mem") port map (clk, input(46), act_0_46_5);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_5.mem") port map (clk, input(47), act_0_47_5);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_5.mem") port map (clk, input(48), act_0_48_5);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_5.mem") port map (clk, input(49), act_0_49_5);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_5, SUM_WIDTH_0_5) + resize(act_0_2_5, SUM_WIDTH_0_5) + resize(act_0_3_5, SUM_WIDTH_0_5) + resize(act_0_4_5, SUM_WIDTH_0_5);
        s1_1 <= resize(act_0_5_5, SUM_WIDTH_0_5) + resize(act_0_6_5, SUM_WIDTH_0_5) + resize(act_0_7_5, SUM_WIDTH_0_5) + resize(act_0_8_5, SUM_WIDTH_0_5);
        s1_2 <= resize(act_0_9_5, SUM_WIDTH_0_5) + resize(act_0_10_5, SUM_WIDTH_0_5) + resize(act_0_11_5, SUM_WIDTH_0_5) + resize(act_0_12_5, SUM_WIDTH_0_5);
        s1_3 <= resize(act_0_13_5, SUM_WIDTH_0_5) + resize(act_0_14_5, SUM_WIDTH_0_5) + resize(act_0_15_5, SUM_WIDTH_0_5) + resize(act_0_16_5, SUM_WIDTH_0_5);
        s1_4 <= resize(act_0_17_5, SUM_WIDTH_0_5) + resize(act_0_18_5, SUM_WIDTH_0_5) + resize(act_0_19_5, SUM_WIDTH_0_5) + resize(act_0_20_5, SUM_WIDTH_0_5);
        s1_5 <= resize(act_0_21_5, SUM_WIDTH_0_5) + resize(act_0_22_5, SUM_WIDTH_0_5) + resize(act_0_24_5, SUM_WIDTH_0_5) + resize(act_0_26_5, SUM_WIDTH_0_5);
        s1_6 <= resize(act_0_27_5, SUM_WIDTH_0_5) + resize(act_0_28_5, SUM_WIDTH_0_5) + resize(act_0_29_5, SUM_WIDTH_0_5) + resize(act_0_30_5, SUM_WIDTH_0_5);
        s1_7 <= resize(act_0_31_5, SUM_WIDTH_0_5) + resize(act_0_32_5, SUM_WIDTH_0_5) + resize(act_0_33_5, SUM_WIDTH_0_5) + resize(act_0_34_5, SUM_WIDTH_0_5);
        s1_8 <= resize(act_0_36_5, SUM_WIDTH_0_5) + resize(act_0_37_5, SUM_WIDTH_0_5) + resize(act_0_38_5, SUM_WIDTH_0_5) + resize(act_0_39_5, SUM_WIDTH_0_5);
        s1_9 <= resize(act_0_40_5, SUM_WIDTH_0_5) + resize(act_0_41_5, SUM_WIDTH_0_5) + resize(act_0_42_5, SUM_WIDTH_0_5) + resize(act_0_43_5, SUM_WIDTH_0_5);
        s1_10 <= resize(act_0_44_5, SUM_WIDTH_0_5) + resize(act_0_45_5, SUM_WIDTH_0_5) + resize(act_0_46_5, SUM_WIDTH_0_5) + resize(act_0_47_5, SUM_WIDTH_0_5);
        s1_11 <= resize(act_0_48_5, SUM_WIDTH_0_5) + resize(act_0_49_5, SUM_WIDTH_0_5);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_5 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(5) <= saturate(sum_0_5, 8);
  end block;

  -- LAYER 0, ch 6
  gen_l0c6 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_6;
  signal s2_0, s2_1, s2_2 : sum_t_0_6;
  signal sum_0_6 : sum_t_0_6;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_6.mem") port map (clk, input(1), act_0_1_6);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_6.mem") port map (clk, input(2), act_0_2_6);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_6.mem") port map (clk, input(3), act_0_3_6);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_6.mem") port map (clk, input(4), act_0_4_6);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_6.mem") port map (clk, input(5), act_0_5_6);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_6.mem") port map (clk, input(6), act_0_6_6);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_6.mem") port map (clk, input(7), act_0_7_6);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_6.mem") port map (clk, input(8), act_0_8_6);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_6.mem") port map (clk, input(9), act_0_9_6);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_6.mem") port map (clk, input(11), act_0_11_6);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_6.mem") port map (clk, input(12), act_0_12_6);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_6.mem") port map (clk, input(13), act_0_13_6);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_6.mem") port map (clk, input(14), act_0_14_6);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_6.mem") port map (clk, input(15), act_0_15_6);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_6.mem") port map (clk, input(16), act_0_16_6);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_6.mem") port map (clk, input(17), act_0_17_6);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_6.mem") port map (clk, input(18), act_0_18_6);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_6.mem") port map (clk, input(19), act_0_19_6);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_6.mem") port map (clk, input(20), act_0_20_6);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_6.mem") port map (clk, input(21), act_0_21_6);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_6.mem") port map (clk, input(22), act_0_22_6);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_6.mem") port map (clk, input(23), act_0_23_6);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_6.mem") port map (clk, input(24), act_0_24_6);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_6.mem") port map (clk, input(25), act_0_25_6);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_6.mem") port map (clk, input(26), act_0_26_6);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_6.mem") port map (clk, input(27), act_0_27_6);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_6.mem") port map (clk, input(28), act_0_28_6);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_6.mem") port map (clk, input(29), act_0_29_6);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_6.mem") port map (clk, input(31), act_0_31_6);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_6.mem") port map (clk, input(32), act_0_32_6);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_6.mem") port map (clk, input(33), act_0_33_6);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_6.mem") port map (clk, input(34), act_0_34_6);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_6.mem") port map (clk, input(36), act_0_36_6);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_6.mem") port map (clk, input(37), act_0_37_6);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_6.mem") port map (clk, input(38), act_0_38_6);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_6.mem") port map (clk, input(39), act_0_39_6);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_6.mem") port map (clk, input(40), act_0_40_6);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_6.mem") port map (clk, input(41), act_0_41_6);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_6.mem") port map (clk, input(42), act_0_42_6);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_6.mem") port map (clk, input(43), act_0_43_6);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_6.mem") port map (clk, input(44), act_0_44_6);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_6.mem") port map (clk, input(46), act_0_46_6);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_6.mem") port map (clk, input(47), act_0_47_6);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_6.mem") port map (clk, input(48), act_0_48_6);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_6, SUM_WIDTH_0_6) + resize(act_0_2_6, SUM_WIDTH_0_6) + resize(act_0_3_6, SUM_WIDTH_0_6) + resize(act_0_4_6, SUM_WIDTH_0_6);
        s1_1 <= resize(act_0_5_6, SUM_WIDTH_0_6) + resize(act_0_6_6, SUM_WIDTH_0_6) + resize(act_0_7_6, SUM_WIDTH_0_6) + resize(act_0_8_6, SUM_WIDTH_0_6);
        s1_2 <= resize(act_0_9_6, SUM_WIDTH_0_6) + resize(act_0_11_6, SUM_WIDTH_0_6) + resize(act_0_12_6, SUM_WIDTH_0_6) + resize(act_0_13_6, SUM_WIDTH_0_6);
        s1_3 <= resize(act_0_14_6, SUM_WIDTH_0_6) + resize(act_0_15_6, SUM_WIDTH_0_6) + resize(act_0_16_6, SUM_WIDTH_0_6) + resize(act_0_17_6, SUM_WIDTH_0_6);
        s1_4 <= resize(act_0_18_6, SUM_WIDTH_0_6) + resize(act_0_19_6, SUM_WIDTH_0_6) + resize(act_0_20_6, SUM_WIDTH_0_6) + resize(act_0_21_6, SUM_WIDTH_0_6);
        s1_5 <= resize(act_0_22_6, SUM_WIDTH_0_6) + resize(act_0_23_6, SUM_WIDTH_0_6) + resize(act_0_24_6, SUM_WIDTH_0_6) + resize(act_0_25_6, SUM_WIDTH_0_6);
        s1_6 <= resize(act_0_26_6, SUM_WIDTH_0_6) + resize(act_0_27_6, SUM_WIDTH_0_6) + resize(act_0_28_6, SUM_WIDTH_0_6) + resize(act_0_29_6, SUM_WIDTH_0_6);
        s1_7 <= resize(act_0_31_6, SUM_WIDTH_0_6) + resize(act_0_32_6, SUM_WIDTH_0_6) + resize(act_0_33_6, SUM_WIDTH_0_6) + resize(act_0_34_6, SUM_WIDTH_0_6);
        s1_8 <= resize(act_0_36_6, SUM_WIDTH_0_6) + resize(act_0_37_6, SUM_WIDTH_0_6) + resize(act_0_38_6, SUM_WIDTH_0_6) + resize(act_0_39_6, SUM_WIDTH_0_6);
        s1_9 <= resize(act_0_40_6, SUM_WIDTH_0_6) + resize(act_0_41_6, SUM_WIDTH_0_6) + resize(act_0_42_6, SUM_WIDTH_0_6) + resize(act_0_43_6, SUM_WIDTH_0_6);
        s1_10 <= resize(act_0_44_6, SUM_WIDTH_0_6) + resize(act_0_46_6, SUM_WIDTH_0_6) + resize(act_0_47_6, SUM_WIDTH_0_6) + resize(act_0_48_6, SUM_WIDTH_0_6);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_6 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(6) <= saturate(sum_0_6, 8);
  end block;

  -- LAYER 0, ch 7
  gen_l0c7 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11, s1_12 : sum_t_0_7;
  signal s2_0, s2_1, s2_2, s2_3 : sum_t_0_7;
  signal sum_0_7 : sum_t_0_7;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_7.mem") port map (clk, input(0), act_0_0_7);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_7.mem") port map (clk, input(1), act_0_1_7);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_7.mem") port map (clk, input(2), act_0_2_7);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_7.mem") port map (clk, input(3), act_0_3_7);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_7.mem") port map (clk, input(4), act_0_4_7);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_7.mem") port map (clk, input(5), act_0_5_7);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_7.mem") port map (clk, input(6), act_0_6_7);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_7.mem") port map (clk, input(7), act_0_7_7);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_7.mem") port map (clk, input(8), act_0_8_7);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_7.mem") port map (clk, input(9), act_0_9_7);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_7.mem") port map (clk, input(11), act_0_11_7);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_7.mem") port map (clk, input(12), act_0_12_7);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_7.mem") port map (clk, input(13), act_0_13_7);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_7.mem") port map (clk, input(14), act_0_14_7);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_7.mem") port map (clk, input(15), act_0_15_7);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_7.mem") port map (clk, input(16), act_0_16_7);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_7.mem") port map (clk, input(17), act_0_17_7);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_7.mem") port map (clk, input(18), act_0_18_7);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_7.mem") port map (clk, input(19), act_0_19_7);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_7.mem") port map (clk, input(20), act_0_20_7);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_7.mem") port map (clk, input(21), act_0_21_7);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_7.mem") port map (clk, input(22), act_0_22_7);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_7.mem") port map (clk, input(23), act_0_23_7);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_7.mem") port map (clk, input(24), act_0_24_7);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_7.mem") port map (clk, input(25), act_0_25_7);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_7.mem") port map (clk, input(26), act_0_26_7);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_7.mem") port map (clk, input(27), act_0_27_7);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_7.mem") port map (clk, input(28), act_0_28_7);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_7.mem") port map (clk, input(29), act_0_29_7);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_7.mem") port map (clk, input(30), act_0_30_7);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_7.mem") port map (clk, input(31), act_0_31_7);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_7.mem") port map (clk, input(32), act_0_32_7);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_7.mem") port map (clk, input(33), act_0_33_7);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_7.mem") port map (clk, input(34), act_0_34_7);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_7.mem") port map (clk, input(35), act_0_35_7);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_7.mem") port map (clk, input(36), act_0_36_7);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_7.mem") port map (clk, input(37), act_0_37_7);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_7.mem") port map (clk, input(38), act_0_38_7);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_7.mem") port map (clk, input(39), act_0_39_7);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_7.mem") port map (clk, input(40), act_0_40_7);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_7.mem") port map (clk, input(41), act_0_41_7);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_7.mem") port map (clk, input(42), act_0_42_7);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_7.mem") port map (clk, input(43), act_0_43_7);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_7.mem") port map (clk, input(44), act_0_44_7);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_7.mem") port map (clk, input(45), act_0_45_7);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_7.mem") port map (clk, input(46), act_0_46_7);
    i46 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_7.mem") port map (clk, input(47), act_0_47_7);
    i47 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_7.mem") port map (clk, input(48), act_0_48_7);
    i48 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_7.mem") port map (clk, input(49), act_0_49_7);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_7, SUM_WIDTH_0_7) + resize(act_0_1_7, SUM_WIDTH_0_7) + resize(act_0_2_7, SUM_WIDTH_0_7) + resize(act_0_3_7, SUM_WIDTH_0_7);
        s1_1 <= resize(act_0_4_7, SUM_WIDTH_0_7) + resize(act_0_5_7, SUM_WIDTH_0_7) + resize(act_0_6_7, SUM_WIDTH_0_7) + resize(act_0_7_7, SUM_WIDTH_0_7);
        s1_2 <= resize(act_0_8_7, SUM_WIDTH_0_7) + resize(act_0_9_7, SUM_WIDTH_0_7) + resize(act_0_11_7, SUM_WIDTH_0_7) + resize(act_0_12_7, SUM_WIDTH_0_7);
        s1_3 <= resize(act_0_13_7, SUM_WIDTH_0_7) + resize(act_0_14_7, SUM_WIDTH_0_7) + resize(act_0_15_7, SUM_WIDTH_0_7) + resize(act_0_16_7, SUM_WIDTH_0_7);
        s1_4 <= resize(act_0_17_7, SUM_WIDTH_0_7) + resize(act_0_18_7, SUM_WIDTH_0_7) + resize(act_0_19_7, SUM_WIDTH_0_7) + resize(act_0_20_7, SUM_WIDTH_0_7);
        s1_5 <= resize(act_0_21_7, SUM_WIDTH_0_7) + resize(act_0_22_7, SUM_WIDTH_0_7) + resize(act_0_23_7, SUM_WIDTH_0_7) + resize(act_0_24_7, SUM_WIDTH_0_7);
        s1_6 <= resize(act_0_25_7, SUM_WIDTH_0_7) + resize(act_0_26_7, SUM_WIDTH_0_7) + resize(act_0_27_7, SUM_WIDTH_0_7) + resize(act_0_28_7, SUM_WIDTH_0_7);
        s1_7 <= resize(act_0_29_7, SUM_WIDTH_0_7) + resize(act_0_30_7, SUM_WIDTH_0_7) + resize(act_0_31_7, SUM_WIDTH_0_7) + resize(act_0_32_7, SUM_WIDTH_0_7);
        s1_8 <= resize(act_0_33_7, SUM_WIDTH_0_7) + resize(act_0_34_7, SUM_WIDTH_0_7) + resize(act_0_35_7, SUM_WIDTH_0_7) + resize(act_0_36_7, SUM_WIDTH_0_7);
        s1_9 <= resize(act_0_37_7, SUM_WIDTH_0_7) + resize(act_0_38_7, SUM_WIDTH_0_7) + resize(act_0_39_7, SUM_WIDTH_0_7) + resize(act_0_40_7, SUM_WIDTH_0_7);
        s1_10 <= resize(act_0_41_7, SUM_WIDTH_0_7) + resize(act_0_42_7, SUM_WIDTH_0_7) + resize(act_0_43_7, SUM_WIDTH_0_7) + resize(act_0_44_7, SUM_WIDTH_0_7);
        s1_11 <= resize(act_0_45_7, SUM_WIDTH_0_7) + resize(act_0_46_7, SUM_WIDTH_0_7) + resize(act_0_47_7, SUM_WIDTH_0_7) + resize(act_0_48_7, SUM_WIDTH_0_7);
        s1_12 <= resize(act_0_49_7, SUM_WIDTH_0_7);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        s2_3 <= s1_12;
        -- Stage 3
        sum_0_7 <= s2_0 + s2_1 + s2_2 + s2_3;
      end if;
    end process;
    output(7) <= saturate(sum_0_7, 8);
  end block;

  -- LAYER 0, ch 8
  gen_l0c8 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_8;
  signal s2_0, s2_1, s2_2 : sum_t_0_8;
  signal sum_0_8 : sum_t_0_8;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_8.mem") port map (clk, input(0), act_0_0_8);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_8.mem") port map (clk, input(1), act_0_1_8);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_8.mem") port map (clk, input(2), act_0_2_8);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_8.mem") port map (clk, input(3), act_0_3_8);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_8.mem") port map (clk, input(4), act_0_4_8);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_8.mem") port map (clk, input(6), act_0_6_8);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_8.mem") port map (clk, input(7), act_0_7_8);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_8.mem") port map (clk, input(8), act_0_8_8);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_8.mem") port map (clk, input(9), act_0_9_8);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_8.mem") port map (clk, input(11), act_0_11_8);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_8.mem") port map (clk, input(12), act_0_12_8);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_8.mem") port map (clk, input(13), act_0_13_8);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_8.mem") port map (clk, input(14), act_0_14_8);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_8.mem") port map (clk, input(15), act_0_15_8);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_8.mem") port map (clk, input(16), act_0_16_8);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_8.mem") port map (clk, input(17), act_0_17_8);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_8.mem") port map (clk, input(18), act_0_18_8);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_8.mem") port map (clk, input(19), act_0_19_8);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_8.mem") port map (clk, input(20), act_0_20_8);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_8.mem") port map (clk, input(21), act_0_21_8);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_8.mem") port map (clk, input(22), act_0_22_8);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_8.mem") port map (clk, input(23), act_0_23_8);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_8.mem") port map (clk, input(24), act_0_24_8);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_8.mem") port map (clk, input(26), act_0_26_8);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_8.mem") port map (clk, input(27), act_0_27_8);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_8.mem") port map (clk, input(28), act_0_28_8);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_8.mem") port map (clk, input(29), act_0_29_8);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_8.mem") port map (clk, input(30), act_0_30_8);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_8.mem") port map (clk, input(31), act_0_31_8);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_8.mem") port map (clk, input(32), act_0_32_8);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_8.mem") port map (clk, input(33), act_0_33_8);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_8.mem") port map (clk, input(34), act_0_34_8);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_8.mem") port map (clk, input(35), act_0_35_8);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_8.mem") port map (clk, input(36), act_0_36_8);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_8.mem") port map (clk, input(37), act_0_37_8);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_8.mem") port map (clk, input(38), act_0_38_8);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_8.mem") port map (clk, input(39), act_0_39_8);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_8.mem") port map (clk, input(40), act_0_40_8);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_8.mem") port map (clk, input(41), act_0_41_8);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_8.mem") port map (clk, input(42), act_0_42_8);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_8.mem") port map (clk, input(43), act_0_43_8);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_8.mem") port map (clk, input(45), act_0_45_8);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_8.mem") port map (clk, input(46), act_0_46_8);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_8.mem") port map (clk, input(47), act_0_47_8);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_8.mem") port map (clk, input(48), act_0_48_8);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_8, SUM_WIDTH_0_8) + resize(act_0_1_8, SUM_WIDTH_0_8) + resize(act_0_2_8, SUM_WIDTH_0_8) + resize(act_0_3_8, SUM_WIDTH_0_8);
        s1_1 <= resize(act_0_4_8, SUM_WIDTH_0_8) + resize(act_0_6_8, SUM_WIDTH_0_8) + resize(act_0_7_8, SUM_WIDTH_0_8) + resize(act_0_8_8, SUM_WIDTH_0_8);
        s1_2 <= resize(act_0_9_8, SUM_WIDTH_0_8) + resize(act_0_11_8, SUM_WIDTH_0_8) + resize(act_0_12_8, SUM_WIDTH_0_8) + resize(act_0_13_8, SUM_WIDTH_0_8);
        s1_3 <= resize(act_0_14_8, SUM_WIDTH_0_8) + resize(act_0_15_8, SUM_WIDTH_0_8) + resize(act_0_16_8, SUM_WIDTH_0_8) + resize(act_0_17_8, SUM_WIDTH_0_8);
        s1_4 <= resize(act_0_18_8, SUM_WIDTH_0_8) + resize(act_0_19_8, SUM_WIDTH_0_8) + resize(act_0_20_8, SUM_WIDTH_0_8) + resize(act_0_21_8, SUM_WIDTH_0_8);
        s1_5 <= resize(act_0_22_8, SUM_WIDTH_0_8) + resize(act_0_23_8, SUM_WIDTH_0_8) + resize(act_0_24_8, SUM_WIDTH_0_8) + resize(act_0_26_8, SUM_WIDTH_0_8);
        s1_6 <= resize(act_0_27_8, SUM_WIDTH_0_8) + resize(act_0_28_8, SUM_WIDTH_0_8) + resize(act_0_29_8, SUM_WIDTH_0_8) + resize(act_0_30_8, SUM_WIDTH_0_8);
        s1_7 <= resize(act_0_31_8, SUM_WIDTH_0_8) + resize(act_0_32_8, SUM_WIDTH_0_8) + resize(act_0_33_8, SUM_WIDTH_0_8) + resize(act_0_34_8, SUM_WIDTH_0_8);
        s1_8 <= resize(act_0_35_8, SUM_WIDTH_0_8) + resize(act_0_36_8, SUM_WIDTH_0_8) + resize(act_0_37_8, SUM_WIDTH_0_8) + resize(act_0_38_8, SUM_WIDTH_0_8);
        s1_9 <= resize(act_0_39_8, SUM_WIDTH_0_8) + resize(act_0_40_8, SUM_WIDTH_0_8) + resize(act_0_41_8, SUM_WIDTH_0_8) + resize(act_0_42_8, SUM_WIDTH_0_8);
        s1_10 <= resize(act_0_43_8, SUM_WIDTH_0_8) + resize(act_0_45_8, SUM_WIDTH_0_8) + resize(act_0_46_8, SUM_WIDTH_0_8) + resize(act_0_47_8, SUM_WIDTH_0_8);
        s1_11 <= resize(act_0_48_8, SUM_WIDTH_0_8);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_8 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(8) <= saturate(sum_0_8, 8);
  end block;

  -- LAYER 0, ch 9
  gen_l0c9 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10, s1_11 : sum_t_0_9;
  signal s2_0, s2_1, s2_2 : sum_t_0_9;
  signal sum_0_9 : sum_t_0_9;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_9.mem") port map (clk, input(1), act_0_1_9);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_9.mem") port map (clk, input(2), act_0_2_9);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_9.mem") port map (clk, input(3), act_0_3_9);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_4_9.mem") port map (clk, input(4), act_0_4_9);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_5_9.mem") port map (clk, input(5), act_0_5_9);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_6_9.mem") port map (clk, input(6), act_0_6_9);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_7_9.mem") port map (clk, input(7), act_0_7_9);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_9.mem") port map (clk, input(9), act_0_9_9);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_9.mem") port map (clk, input(10), act_0_10_9);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_9.mem") port map (clk, input(11), act_0_11_9);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_9.mem") port map (clk, input(12), act_0_12_9);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_9.mem") port map (clk, input(13), act_0_13_9);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_9.mem") port map (clk, input(14), act_0_14_9);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_9.mem") port map (clk, input(15), act_0_15_9);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_9.mem") port map (clk, input(16), act_0_16_9);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_9.mem") port map (clk, input(17), act_0_17_9);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_9.mem") port map (clk, input(18), act_0_18_9);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_9.mem") port map (clk, input(19), act_0_19_9);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_20_9.mem") port map (clk, input(20), act_0_20_9);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_9.mem") port map (clk, input(22), act_0_22_9);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_9.mem") port map (clk, input(23), act_0_23_9);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_9.mem") port map (clk, input(24), act_0_24_9);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_9.mem") port map (clk, input(26), act_0_26_9);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_9.mem") port map (clk, input(27), act_0_27_9);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_9.mem") port map (clk, input(28), act_0_28_9);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_9.mem") port map (clk, input(29), act_0_29_9);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_9.mem") port map (clk, input(30), act_0_30_9);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_9.mem") port map (clk, input(31), act_0_31_9);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_9.mem") port map (clk, input(32), act_0_32_9);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_9.mem") port map (clk, input(33), act_0_33_9);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_9.mem") port map (clk, input(34), act_0_34_9);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_9.mem") port map (clk, input(35), act_0_35_9);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_9.mem") port map (clk, input(36), act_0_36_9);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_9.mem") port map (clk, input(37), act_0_37_9);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_9.mem") port map (clk, input(38), act_0_38_9);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_9.mem") port map (clk, input(39), act_0_39_9);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_9.mem") port map (clk, input(40), act_0_40_9);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_9.mem") port map (clk, input(41), act_0_41_9);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_9.mem") port map (clk, input(42), act_0_42_9);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_9.mem") port map (clk, input(43), act_0_43_9);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_9.mem") port map (clk, input(44), act_0_44_9);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_9.mem") port map (clk, input(45), act_0_45_9);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_9.mem") port map (clk, input(46), act_0_46_9);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_9.mem") port map (clk, input(47), act_0_47_9);
    i44 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_9.mem") port map (clk, input(48), act_0_48_9);
    i45 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_9.mem") port map (clk, input(49), act_0_49_9);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_9, SUM_WIDTH_0_9) + resize(act_0_2_9, SUM_WIDTH_0_9) + resize(act_0_3_9, SUM_WIDTH_0_9) + resize(act_0_4_9, SUM_WIDTH_0_9);
        s1_1 <= resize(act_0_5_9, SUM_WIDTH_0_9) + resize(act_0_6_9, SUM_WIDTH_0_9) + resize(act_0_7_9, SUM_WIDTH_0_9) + resize(act_0_9_9, SUM_WIDTH_0_9);
        s1_2 <= resize(act_0_10_9, SUM_WIDTH_0_9) + resize(act_0_11_9, SUM_WIDTH_0_9) + resize(act_0_12_9, SUM_WIDTH_0_9) + resize(act_0_13_9, SUM_WIDTH_0_9);
        s1_3 <= resize(act_0_14_9, SUM_WIDTH_0_9) + resize(act_0_15_9, SUM_WIDTH_0_9) + resize(act_0_16_9, SUM_WIDTH_0_9) + resize(act_0_17_9, SUM_WIDTH_0_9);
        s1_4 <= resize(act_0_18_9, SUM_WIDTH_0_9) + resize(act_0_19_9, SUM_WIDTH_0_9) + resize(act_0_20_9, SUM_WIDTH_0_9) + resize(act_0_22_9, SUM_WIDTH_0_9);
        s1_5 <= resize(act_0_23_9, SUM_WIDTH_0_9) + resize(act_0_24_9, SUM_WIDTH_0_9) + resize(act_0_26_9, SUM_WIDTH_0_9) + resize(act_0_27_9, SUM_WIDTH_0_9);
        s1_6 <= resize(act_0_28_9, SUM_WIDTH_0_9) + resize(act_0_29_9, SUM_WIDTH_0_9) + resize(act_0_30_9, SUM_WIDTH_0_9) + resize(act_0_31_9, SUM_WIDTH_0_9);
        s1_7 <= resize(act_0_32_9, SUM_WIDTH_0_9) + resize(act_0_33_9, SUM_WIDTH_0_9) + resize(act_0_34_9, SUM_WIDTH_0_9) + resize(act_0_35_9, SUM_WIDTH_0_9);
        s1_8 <= resize(act_0_36_9, SUM_WIDTH_0_9) + resize(act_0_37_9, SUM_WIDTH_0_9) + resize(act_0_38_9, SUM_WIDTH_0_9) + resize(act_0_39_9, SUM_WIDTH_0_9);
        s1_9 <= resize(act_0_40_9, SUM_WIDTH_0_9) + resize(act_0_41_9, SUM_WIDTH_0_9) + resize(act_0_42_9, SUM_WIDTH_0_9) + resize(act_0_43_9, SUM_WIDTH_0_9);
        s1_10 <= resize(act_0_44_9, SUM_WIDTH_0_9) + resize(act_0_45_9, SUM_WIDTH_0_9) + resize(act_0_46_9, SUM_WIDTH_0_9) + resize(act_0_47_9, SUM_WIDTH_0_9);
        s1_11 <= resize(act_0_48_9, SUM_WIDTH_0_9) + resize(act_0_49_9, SUM_WIDTH_0_9);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10 + s1_11;
        -- Stage 3
        sum_0_9 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    output(9) <= saturate(sum_0_9, 8);
  end block;

end architecture;