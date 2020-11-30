module gpio_control_block (mgmt_gpio_in,
    mgmt_gpio_oeb,
    mgmt_gpio_out,
    pad_gpio_ana_en,
    pad_gpio_ana_pol,
    pad_gpio_ana_sel,
    pad_gpio_holdover,
    pad_gpio_ib_mode_sel,
    pad_gpio_in,
    pad_gpio_inenb,
    pad_gpio_out,
    pad_gpio_outenb,
    pad_gpio_slow_sel,
    pad_gpio_vtrip_sel,
    resetn,
    serial_clock,
    serial_data_in,
    serial_data_out,
    user_gpio_in,
    user_gpio_oeb,
    user_gpio_out,
    pad_gpio_dm);
 output mgmt_gpio_in;
 input mgmt_gpio_oeb;
 input mgmt_gpio_out;
 output pad_gpio_ana_en;
 output pad_gpio_ana_pol;
 output pad_gpio_ana_sel;
 output pad_gpio_holdover;
 output pad_gpio_ib_mode_sel;
 input pad_gpio_in;
 output pad_gpio_inenb;
 output pad_gpio_out;
 output pad_gpio_outenb;
 output pad_gpio_slow_sel;
 output pad_gpio_vtrip_sel;
 input resetn;
 input serial_clock;
 input serial_data_in;
 output serial_data_out;
 output user_gpio_in;
 input user_gpio_oeb;
 input user_gpio_out;
 output [2:0] pad_gpio_dm;

 sky130_fd_sc_hd__or2_4 _039_ (.A(clknet_1_1_0_serial_clock),
    .B(resetn),
    .X(_027_));
 sky130_fd_sc_hd__buf_2 _040_ (.A(_027_),
    .X(_028_));
 sky130_fd_sc_hd__buf_2 _041_ (.A(_028_),
    .X(_025_));
 sky130_fd_sc_hd__buf_2 _042_ (.A(_025_),
    .X(_024_));
 sky130_fd_sc_hd__buf_2 _043_ (.A(_025_),
    .X(_023_));
 sky130_fd_sc_hd__buf_2 _044_ (.A(_025_),
    .X(_022_));
 sky130_fd_sc_hd__buf_2 _045_ (.A(_025_),
    .X(_021_));
 sky130_fd_sc_hd__buf_2 _046_ (.A(_028_),
    .X(_029_));
 sky130_fd_sc_hd__buf_2 _047_ (.A(_029_),
    .X(_020_));
 sky130_fd_sc_hd__buf_2 _048_ (.A(_029_),
    .X(_019_));
 sky130_fd_sc_hd__buf_2 _049_ (.A(_029_),
    .X(_018_));
 sky130_fd_sc_hd__buf_2 _050_ (.A(_029_),
    .X(_017_));
 sky130_fd_sc_hd__buf_2 _051_ (.A(_029_),
    .X(_016_));
 sky130_fd_sc_hd__buf_2 _052_ (.A(_028_),
    .X(_030_));
 sky130_fd_sc_hd__buf_2 _053_ (.A(_030_),
    .X(_015_));
 sky130_fd_sc_hd__buf_2 _054_ (.A(_030_),
    .X(_014_));
 sky130_fd_sc_hd__buf_2 _055_ (.A(_030_),
    .X(_013_));
 sky130_fd_sc_hd__buf_2 _056_ (.A(_030_),
    .X(_012_));
 sky130_fd_sc_hd__buf_2 _057_ (.A(_030_),
    .X(_011_));
 sky130_fd_sc_hd__buf_2 _058_ (.A(_028_),
    .X(_031_));
 sky130_fd_sc_hd__buf_2 _059_ (.A(_031_),
    .X(_010_));
 sky130_fd_sc_hd__buf_2 _060_ (.A(_031_),
    .X(_009_));
 sky130_fd_sc_hd__buf_2 _061_ (.A(_031_),
    .X(_008_));
 sky130_fd_sc_hd__buf_2 _062_ (.A(_031_),
    .X(_007_));
 sky130_fd_sc_hd__buf_2 _063_ (.A(_031_),
    .X(_006_));
 sky130_fd_sc_hd__buf_2 _064_ (.A(_027_),
    .X(_032_));
 sky130_fd_sc_hd__buf_2 _065_ (.A(_032_),
    .X(_005_));
 sky130_fd_sc_hd__buf_2 _066_ (.A(_032_),
    .X(_004_));
 sky130_fd_sc_hd__buf_2 _067_ (.A(_032_),
    .X(_003_));
 sky130_fd_sc_hd__buf_2 _068_ (.A(_032_),
    .X(_002_));
 sky130_fd_sc_hd__buf_2 _069_ (.A(_032_),
    .X(_001_));
 sky130_fd_sc_hd__inv_2 _070_ (.A(mgmt_ena),
    .Y(_033_));
 sky130_fd_sc_hd__a32o_4 _071_ (.A1(gpio_outenb),
    .A2(mgmt_gpio_oeb),
    .A3(mgmt_ena),
    .B1(user_gpio_oeb),
    .B2(_033_),
    .X(pad_gpio_outenb));
 sky130_fd_sc_hd__inv_2 _072_ (.A(pad_gpio_dm[2]),
    .Y(_034_));
 sky130_fd_sc_hd__and3_4 _073_ (.A(mgmt_gpio_oeb),
    .B(_034_),
    .C(pad_gpio_dm[1]),
    .X(_035_));
 sky130_fd_sc_hd__or2_4 _074_ (.A(mgmt_gpio_out),
    .B(_035_),
    .X(_036_));
 sky130_fd_sc_hd__nand2_4 _075_ (.A(pad_gpio_dm[0]),
    .B(_035_),
    .Y(_037_));
 sky130_fd_sc_hd__a32o_4 _076_ (.A1(mgmt_ena),
    .A2(_036_),
    .A3(_037_),
    .B1(_033_),
    .B2(user_gpio_out),
    .X(pad_gpio_out));
 sky130_fd_sc_hd__nand2_4 _077_ (.A(_033_),
    .B(pad_gpio_in),
    .Y(_000_));
 sky130_fd_sc_hd__inv_2 _078_ (.A(resetn),
    .Y(_038_));
 sky130_fd_sc_hd__and2_4 _079_ (.A(clknet_1_1_0_serial_clock),
    .B(_038_),
    .X(load_data));
 sky130_fd_sc_hd__and2_4 _080_ (.A(mgmt_ena),
    .B(pad_gpio_in),
    .X(mgmt_gpio_in));
 sky130_fd_sc_hd__buf_2 _081_ (.A(_028_),
    .X(_026_));
 sky130_fd_sc_hd__dfstp_4 _082_ (.D(\shift_register[0] ),
    .Q(mgmt_ena),
    .SET_B(_001_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _083_ (.D(\shift_register[2] ),
    .Q(pad_gpio_holdover),
    .RESET_B(_002_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _084_ (.D(\shift_register[8] ),
    .Q(pad_gpio_slow_sel),
    .RESET_B(_003_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _085_ (.D(\shift_register[9] ),
    .Q(pad_gpio_vtrip_sel),
    .RESET_B(_004_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _086_ (.D(\shift_register[3] ),
    .Q(pad_gpio_inenb),
    .RESET_B(_005_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _087_ (.D(\shift_register[4] ),
    .Q(pad_gpio_ib_mode_sel),
    .RESET_B(_006_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfstp_4 _088_ (.D(\shift_register[1] ),
    .Q(gpio_outenb),
    .SET_B(_007_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfstp_4 _089_ (.D(\shift_register[10] ),
    .Q(pad_gpio_dm[0]),
    .SET_B(_008_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _090_ (.D(\shift_register[11] ),
    .Q(pad_gpio_dm[1]),
    .RESET_B(_009_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _091_ (.D(serial_data_out),
    .Q(pad_gpio_dm[2]),
    .RESET_B(_010_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _092_ (.D(\shift_register[5] ),
    .Q(pad_gpio_ana_en),
    .RESET_B(_011_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _093_ (.D(\shift_register[6] ),
    .Q(pad_gpio_ana_sel),
    .RESET_B(_012_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _094_ (.D(\shift_register[7] ),
    .Q(pad_gpio_ana_pol),
    .RESET_B(_013_),
    .CLK(load_data));
 sky130_fd_sc_hd__dfrtp_4 _095_ (.D(serial_data_in),
    .Q(\shift_register[0] ),
    .RESET_B(_014_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _096_ (.D(\shift_register[0] ),
    .Q(\shift_register[1] ),
    .RESET_B(_015_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _097_ (.D(\shift_register[1] ),
    .Q(\shift_register[2] ),
    .RESET_B(_016_),
    .CLK(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _098_ (.D(\shift_register[2] ),
    .Q(\shift_register[3] ),
    .RESET_B(_017_),
    .CLK(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _099_ (.D(\shift_register[3] ),
    .Q(\shift_register[4] ),
    .RESET_B(_018_),
    .CLK(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _100_ (.D(\shift_register[4] ),
    .Q(\shift_register[5] ),
    .RESET_B(_019_),
    .CLK(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _101_ (.D(\shift_register[5] ),
    .Q(\shift_register[6] ),
    .RESET_B(_020_),
    .CLK(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _102_ (.D(\shift_register[6] ),
    .Q(\shift_register[7] ),
    .RESET_B(_021_),
    .CLK(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _103_ (.D(\shift_register[7] ),
    .Q(\shift_register[8] ),
    .RESET_B(_022_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _104_ (.D(\shift_register[8] ),
    .Q(\shift_register[9] ),
    .RESET_B(_023_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _105_ (.D(\shift_register[9] ),
    .Q(\shift_register[10] ),
    .RESET_B(_024_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _106_ (.D(\shift_register[10] ),
    .Q(\shift_register[11] ),
    .RESET_B(_025_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__dfrtp_4 _107_ (.D(\shift_register[11] ),
    .Q(serial_data_out),
    .RESET_B(_026_),
    .CLK(clknet_1_1_0_serial_clock));
 sky130_fd_sc_hd__einvp_8 gpio_in_buf (.A(_000_),
    .TE(gpio_logic1),
    .Z(user_gpio_in));
 sky130_fd_sc_hd__conb_1 gpio_logic_high (.HI(gpio_logic1));
 sky130_fd_sc_hd__decap_3 PHY_0 ();
 sky130_fd_sc_hd__decap_3 PHY_1 ();
 sky130_fd_sc_hd__decap_3 PHY_2 ();
 sky130_fd_sc_hd__decap_3 PHY_3 ();
 sky130_fd_sc_hd__decap_3 PHY_4 ();
 sky130_fd_sc_hd__decap_3 PHY_5 ();
 sky130_fd_sc_hd__decap_3 PHY_6 ();
 sky130_fd_sc_hd__decap_3 PHY_7 ();
 sky130_fd_sc_hd__decap_3 PHY_8 ();
 sky130_fd_sc_hd__decap_3 PHY_9 ();
 sky130_fd_sc_hd__decap_3 PHY_10 ();
 sky130_fd_sc_hd__decap_3 PHY_11 ();
 sky130_fd_sc_hd__decap_3 PHY_12 ();
 sky130_fd_sc_hd__decap_3 PHY_13 ();
 sky130_fd_sc_hd__decap_3 PHY_14 ();
 sky130_fd_sc_hd__decap_3 PHY_15 ();
 sky130_fd_sc_hd__decap_3 PHY_16 ();
 sky130_fd_sc_hd__decap_3 PHY_17 ();
 sky130_fd_sc_hd__decap_3 PHY_18 ();
 sky130_fd_sc_hd__decap_3 PHY_19 ();
 sky130_fd_sc_hd__decap_3 PHY_20 ();
 sky130_fd_sc_hd__decap_3 PHY_21 ();
 sky130_fd_sc_hd__decap_3 PHY_22 ();
 sky130_fd_sc_hd__decap_3 PHY_23 ();
 sky130_fd_sc_hd__decap_3 PHY_24 ();
 sky130_fd_sc_hd__decap_3 PHY_25 ();
 sky130_fd_sc_hd__decap_3 PHY_26 ();
 sky130_fd_sc_hd__decap_3 PHY_27 ();
 sky130_fd_sc_hd__decap_3 PHY_28 ();
 sky130_fd_sc_hd__decap_3 PHY_29 ();
 sky130_fd_sc_hd__decap_3 PHY_30 ();
 sky130_fd_sc_hd__decap_3 PHY_31 ();
 sky130_fd_sc_hd__decap_3 PHY_32 ();
 sky130_fd_sc_hd__decap_3 PHY_33 ();
 sky130_fd_sc_hd__decap_3 PHY_34 ();
 sky130_fd_sc_hd__decap_3 PHY_35 ();
 sky130_fd_sc_hd__decap_3 PHY_36 ();
 sky130_fd_sc_hd__decap_3 PHY_37 ();
 sky130_fd_sc_hd__decap_3 PHY_38 ();
 sky130_fd_sc_hd__decap_3 PHY_39 ();
 sky130_fd_sc_hd__decap_3 PHY_40 ();
 sky130_fd_sc_hd__decap_3 PHY_41 ();
 sky130_fd_sc_hd__decap_3 PHY_42 ();
 sky130_fd_sc_hd__decap_3 PHY_43 ();
 sky130_fd_sc_hd__decap_3 PHY_44 ();
 sky130_fd_sc_hd__decap_3 PHY_45 ();
 sky130_fd_sc_hd__decap_3 PHY_46 ();
 sky130_fd_sc_hd__decap_3 PHY_47 ();
 sky130_fd_sc_hd__decap_3 PHY_48 ();
 sky130_fd_sc_hd__decap_3 PHY_49 ();
 sky130_fd_sc_hd__decap_3 PHY_50 ();
 sky130_fd_sc_hd__decap_3 PHY_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_80 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_84 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_85 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_86 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_87 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_88 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_89 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_90 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_91 ();
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_serial_clock (.A(serial_clock),
    .X(clknet_0_serial_clock));
 sky130_fd_sc_hd__clkbuf_1 clkbuf_1_0_0_serial_clock (.A(clknet_0_serial_clock),
    .X(clknet_1_0_0_serial_clock));
 sky130_fd_sc_hd__clkbuf_1 clkbuf_1_1_0_serial_clock (.A(clknet_0_serial_clock),
    .X(clknet_1_1_0_serial_clock));
endmodule
