module digital_pll (dco,
    enable,
    osc,
    resetb,
    clockp,
    div,
    ext_trim);
 input dco;
 input enable;
 input osc;
 input resetb;
 output [1:0] clockp;
 input [4:0] div;
 input [25:0] ext_trim;

 sky130_fd_sc_hd__inv_2 _259_ (.A(\pll_control.count0[4] ),
    .Y(_043_));
 sky130_fd_sc_hd__inv_2 _260_ (.A(\pll_control.count1[4] ),
    .Y(_044_));
 sky130_fd_sc_hd__inv_2 _261_ (.A(\pll_control.count0[3] ),
    .Y(_045_));
 sky130_fd_sc_hd__inv_2 _262_ (.A(\pll_control.count1[3] ),
    .Y(_046_));
 sky130_fd_sc_hd__inv_2 _263_ (.A(\pll_control.count0[2] ),
    .Y(_047_));
 sky130_fd_sc_hd__inv_2 _264_ (.A(\pll_control.count1[2] ),
    .Y(_048_));
 sky130_fd_sc_hd__inv_2 _265_ (.A(\pll_control.count0[1] ),
    .Y(_049_));
 sky130_fd_sc_hd__inv_2 _266_ (.A(\pll_control.count1[1] ),
    .Y(_050_));
 sky130_fd_sc_hd__inv_2 _267_ (.A(\pll_control.count0[0] ),
    .Y(_051_));
 sky130_fd_sc_hd__inv_2 _268_ (.A(\pll_control.prep[1] ),
    .Y(_052_));
 sky130_fd_sc_hd__inv_2 _269_ (.A(\pll_control.tint[4] ),
    .Y(_053_));
 sky130_fd_sc_hd__inv_2 _270_ (.A(\pll_control.tint[3] ),
    .Y(_054_));
 sky130_fd_sc_hd__inv_2 _271_ (.A(\pll_control.tint[2] ),
    .Y(_055_));
 sky130_fd_sc_hd__inv_2 _272_ (.A(\pll_control.tint[1] ),
    .Y(_056_));
 sky130_fd_sc_hd__inv_2 _273_ (.A(\pll_control.tint[0] ),
    .Y(_057_));
 sky130_fd_sc_hd__inv_2 _274_ (.A(\pll_control.tval[1] ),
    .Y(_058_));
 sky130_fd_sc_hd__inv_2 _275_ (.A(\pll_control.tval[0] ),
    .Y(_059_));
 sky130_fd_sc_hd__inv_2 _276_ (.A(\pll_control.oscbuf[1] ),
    .Y(_060_));
 sky130_fd_sc_hd__inv_2 _277_ (.A(div[0]),
    .Y(_061_));
 sky130_fd_sc_hd__inv_2 _278_ (.A(dco),
    .Y(_062_));
 sky130_fd_sc_hd__inv_2 _279_ (.A(ext_trim[1]),
    .Y(_063_));
 sky130_fd_sc_hd__inv_2 _280_ (.A(ext_trim[7]),
    .Y(_064_));
 sky130_fd_sc_hd__inv_2 _281_ (.A(ext_trim[9]),
    .Y(_065_));
 sky130_fd_sc_hd__inv_2 _282_ (.A(ext_trim[14]),
    .Y(_066_));
 sky130_fd_sc_hd__inv_2 _283_ (.A(ext_trim[15]),
    .Y(_067_));
 sky130_fd_sc_hd__inv_2 _284_ (.A(ext_trim[16]),
    .Y(_068_));
 sky130_fd_sc_hd__inv_2 _285_ (.A(ext_trim[17]),
    .Y(_069_));
 sky130_fd_sc_hd__a2bb2o_4 _286_ (.A1_N(_060_),
    .A2_N(\pll_control.oscbuf[2] ),
    .B1(_060_),
    .B2(\pll_control.oscbuf[2] ),
    .X(_070_));
 sky130_fd_sc_hd__inv_2 _287_ (.A(_070_),
    .Y(_071_));
 sky130_fd_sc_hd__a2bb2o_4 _288_ (.A1_N(_043_),
    .A2_N(_071_),
    .B1(\pll_control.count1[4] ),
    .B2(_071_),
    .X(_042_));
 sky130_fd_sc_hd__nand2_4 _289_ (.A(enable),
    .B(resetb),
    .Y(\ringosc.iss.reset ));
 sky130_fd_sc_hd__and3_4 _290_ (.A(enable),
    .B(resetb),
    .C(_062_),
    .X(_021_));
 sky130_fd_sc_hd__a2bb2o_4 _291_ (.A1_N(_045_),
    .A2_N(_071_),
    .B1(\pll_control.count1[3] ),
    .B2(_071_),
    .X(_041_));
 sky130_fd_sc_hd__a2bb2o_4 _292_ (.A1_N(_047_),
    .A2_N(_071_),
    .B1(\pll_control.count1[2] ),
    .B2(_071_),
    .X(_040_));
 sky130_fd_sc_hd__a2bb2o_4 _293_ (.A1_N(_049_),
    .A2_N(_071_),
    .B1(\pll_control.count1[1] ),
    .B2(_071_),
    .X(_039_));
 sky130_fd_sc_hd__a2bb2o_4 _294_ (.A1_N(_051_),
    .A2_N(_071_),
    .B1(\pll_control.count1[0] ),
    .B2(_071_),
    .X(_038_));
 sky130_fd_sc_hd__a2bb2o_4 _295_ (.A1_N(_052_),
    .A2_N(_071_),
    .B1(\pll_control.prep[2] ),
    .B2(_071_),
    .X(_037_));
 sky130_fd_sc_hd__a2bb2o_4 _296_ (.A1_N(_052_),
    .A2_N(_070_),
    .B1(\pll_control.prep[0] ),
    .B2(_070_),
    .X(_036_));
 sky130_fd_sc_hd__or2_4 _297_ (.A(\pll_control.prep[0] ),
    .B(_070_),
    .X(_035_));
 sky130_fd_sc_hd__a2bb2o_4 _298_ (.A1_N(_049_),
    .A2_N(_050_),
    .B1(_049_),
    .B2(_050_),
    .X(_072_));
 sky130_fd_sc_hd__nand2_4 _299_ (.A(\pll_control.count0[0] ),
    .B(\pll_control.count1[0] ),
    .Y(_073_));
 sky130_fd_sc_hd__a2bb2o_4 _300_ (.A1_N(_072_),
    .A2_N(_073_),
    .B1(_072_),
    .B2(_073_),
    .X(_074_));
 sky130_fd_sc_hd__and2_4 _301_ (.A(div[1]),
    .B(_074_),
    .X(_075_));
 sky130_fd_sc_hd__nor2_4 _302_ (.A(div[1]),
    .B(_074_),
    .Y(_076_));
 sky130_fd_sc_hd__o21a_4 _303_ (.A1(\pll_control.count0[0] ),
    .A2(\pll_control.count1[0] ),
    .B1(_073_),
    .X(_077_));
 sky130_fd_sc_hd__a211o_4 _304_ (.A1(_061_),
    .A2(_077_),
    .B1(_075_),
    .C1(_076_),
    .X(_078_));
 sky130_fd_sc_hd__inv_2 _305_ (.A(_078_),
    .Y(_079_));
 sky130_fd_sc_hd__or2_4 _306_ (.A(_075_),
    .B(_079_),
    .X(_080_));
 sky130_fd_sc_hd__and2_4 _307_ (.A(_045_),
    .B(_046_),
    .X(_081_));
 sky130_fd_sc_hd__a21o_4 _308_ (.A1(\pll_control.count0[3] ),
    .A2(\pll_control.count1[3] ),
    .B1(_081_),
    .X(_082_));
 sky130_fd_sc_hd__and2_4 _309_ (.A(_047_),
    .B(_048_),
    .X(_083_));
 sky130_fd_sc_hd__o22a_4 _310_ (.A1(_049_),
    .A2(_050_),
    .B1(_072_),
    .B2(_073_),
    .X(_084_));
 sky130_fd_sc_hd__o22a_4 _311_ (.A1(_047_),
    .A2(_048_),
    .B1(_083_),
    .B2(_084_),
    .X(_085_));
 sky130_fd_sc_hd__a2bb2o_4 _312_ (.A1_N(_082_),
    .A2_N(_085_),
    .B1(_082_),
    .B2(_085_),
    .X(_086_));
 sky130_fd_sc_hd__a21o_4 _313_ (.A1(\pll_control.count0[2] ),
    .A2(\pll_control.count1[2] ),
    .B1(_083_),
    .X(_087_));
 sky130_fd_sc_hd__or2_4 _314_ (.A(_084_),
    .B(_087_),
    .X(_088_));
 sky130_fd_sc_hd__a21bo_4 _315_ (.A1(_084_),
    .A2(_087_),
    .B1_N(_088_),
    .X(_089_));
 sky130_fd_sc_hd__a22oi_4 _316_ (.A1(div[3]),
    .A2(_086_),
    .B1(div[2]),
    .B2(_089_),
    .Y(_090_));
 sky130_fd_sc_hd__inv_2 _317_ (.A(_090_),
    .Y(_091_));
 sky130_fd_sc_hd__or2_4 _318_ (.A(div[3]),
    .B(_086_),
    .X(_092_));
 sky130_fd_sc_hd__or2_4 _319_ (.A(div[2]),
    .B(_089_),
    .X(_093_));
 sky130_fd_sc_hd__and3_4 _320_ (.A(_092_),
    .B(_093_),
    .C(_090_),
    .X(_094_));
 sky130_fd_sc_hd__inv_2 _321_ (.A(_094_),
    .Y(_095_));
 sky130_fd_sc_hd__a2bb2o_4 _322_ (.A1_N(_043_),
    .A2_N(_044_),
    .B1(_043_),
    .B2(_044_),
    .X(_096_));
 sky130_fd_sc_hd__o22a_4 _323_ (.A1(_045_),
    .A2(_046_),
    .B1(_081_),
    .B2(_085_),
    .X(_097_));
 sky130_fd_sc_hd__a2bb2o_4 _324_ (.A1_N(_096_),
    .A2_N(_097_),
    .B1(_096_),
    .B2(_097_),
    .X(_098_));
 sky130_fd_sc_hd__and2_4 _325_ (.A(div[4]),
    .B(_098_),
    .X(_099_));
 sky130_fd_sc_hd__and2_4 _326_ (.A(_091_),
    .B(_092_),
    .X(_100_));
 sky130_fd_sc_hd__a211o_4 _327_ (.A1(_080_),
    .A2(_094_),
    .B1(_099_),
    .C1(_100_),
    .X(_101_));
 sky130_fd_sc_hd__inv_2 _328_ (.A(_101_),
    .Y(_102_));
 sky130_fd_sc_hd__o22a_4 _329_ (.A1(_043_),
    .A2(_044_),
    .B1(_096_),
    .B2(_097_),
    .X(_103_));
 sky130_fd_sc_hd__o21ai_4 _330_ (.A1(div[4]),
    .A2(_098_),
    .B1(_103_),
    .Y(_104_));
 sky130_fd_sc_hd__or2_4 _331_ (.A(_102_),
    .B(_104_),
    .X(_105_));
 sky130_fd_sc_hd__inv_2 _332_ (.A(_105_),
    .Y(_106_));
 sky130_fd_sc_hd__or2_4 _333_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .X(_107_));
 sky130_fd_sc_hd__or2_4 _334_ (.A(\pll_control.tint[1] ),
    .B(\pll_control.tint[0] ),
    .X(_108_));
 sky130_fd_sc_hd__inv_2 _335_ (.A(_108_),
    .Y(_109_));
 sky130_fd_sc_hd__and4_4 _336_ (.A(_054_),
    .B(_055_),
    .C(_109_),
    .D(_053_),
    .X(_110_));
 sky130_fd_sc_hd__and4_4 _337_ (.A(_058_),
    .B(_059_),
    .C(_110_),
    .D(_106_),
    .X(_111_));
 sky130_fd_sc_hd__o21ai_4 _338_ (.A1(_061_),
    .A2(_077_),
    .B1(_079_),
    .Y(_112_));
 sky130_fd_sc_hd__or4_4 _339_ (.A(_095_),
    .B(_112_),
    .C(_099_),
    .D(_104_),
    .X(_113_));
 sky130_fd_sc_hd__inv_2 _340_ (.A(_113_),
    .Y(_114_));
 sky130_fd_sc_hd__and4_4 _341_ (.A(\pll_control.prep[1] ),
    .B(_070_),
    .C(\pll_control.prep[2] ),
    .D(\pll_control.prep[0] ),
    .X(_115_));
 sky130_fd_sc_hd__inv_2 _342_ (.A(_115_),
    .Y(_116_));
 sky130_fd_sc_hd__or3_4 _343_ (.A(_114_),
    .B(_116_),
    .C(_111_),
    .X(_117_));
 sky130_fd_sc_hd__or2_4 _344_ (.A(_054_),
    .B(_106_),
    .X(_118_));
 sky130_fd_sc_hd__or4_4 _345_ (.A(_055_),
    .B(_057_),
    .C(_058_),
    .D(_059_),
    .X(_119_));
 sky130_fd_sc_hd__or4_4 _346_ (.A(_053_),
    .B(_056_),
    .C(_119_),
    .D(_118_),
    .X(_120_));
 sky130_fd_sc_hd__inv_2 _347_ (.A(_120_),
    .Y(_121_));
 sky130_fd_sc_hd__or2_4 _348_ (.A(_117_),
    .B(_121_),
    .X(_122_));
 sky130_fd_sc_hd__inv_2 _349_ (.A(_122_),
    .Y(_123_));
 sky130_fd_sc_hd__o22a_4 _350_ (.A1(_058_),
    .A2(_105_),
    .B1(\pll_control.tval[1] ),
    .B2(_106_),
    .X(_124_));
 sky130_fd_sc_hd__nand2_4 _351_ (.A(\pll_control.tval[0] ),
    .B(_124_),
    .Y(_125_));
 sky130_fd_sc_hd__o21ai_4 _352_ (.A1(_058_),
    .A2(_105_),
    .B1(_125_),
    .Y(_126_));
 sky130_fd_sc_hd__o22a_4 _353_ (.A1(_056_),
    .A2(_106_),
    .B1(\pll_control.tint[1] ),
    .B2(_105_),
    .X(_127_));
 sky130_fd_sc_hd__inv_2 _354_ (.A(_127_),
    .Y(_128_));
 sky130_fd_sc_hd__or2_4 _355_ (.A(\pll_control.tint[1] ),
    .B(_057_),
    .X(_129_));
 sky130_fd_sc_hd__inv_2 _356_ (.A(_129_),
    .Y(_130_));
 sky130_fd_sc_hd__or2_4 _357_ (.A(_056_),
    .B(\pll_control.tint[0] ),
    .X(_131_));
 sky130_fd_sc_hd__inv_2 _358_ (.A(_131_),
    .Y(_132_));
 sky130_fd_sc_hd__and2_4 _359_ (.A(_129_),
    .B(_131_),
    .X(_133_));
 sky130_fd_sc_hd__a32o_4 _360_ (.A1(_128_),
    .A2(_133_),
    .A3(_126_),
    .B1(_106_),
    .B2(_108_),
    .X(_134_));
 sky130_fd_sc_hd__o22a_4 _361_ (.A1(_055_),
    .A2(_105_),
    .B1(\pll_control.tint[2] ),
    .B2(_106_),
    .X(_135_));
 sky130_fd_sc_hd__o21a_4 _362_ (.A1(\pll_control.tint[3] ),
    .A2(_105_),
    .B1(_118_),
    .X(_136_));
 sky130_fd_sc_hd__inv_2 _363_ (.A(_136_),
    .Y(_137_));
 sky130_fd_sc_hd__a32o_4 _364_ (.A1(_135_),
    .A2(_137_),
    .A3(_134_),
    .B1(_106_),
    .B2(_107_),
    .X(_138_));
 sky130_fd_sc_hd__o22a_4 _365_ (.A1(\pll_control.tint[4] ),
    .A2(_106_),
    .B1(_053_),
    .B2(_105_),
    .X(_139_));
 sky130_fd_sc_hd__or2_4 _366_ (.A(_138_),
    .B(_139_),
    .X(_140_));
 sky130_fd_sc_hd__nand2_4 _367_ (.A(_138_),
    .B(_139_),
    .Y(_141_));
 sky130_fd_sc_hd__a32o_4 _368_ (.A1(_123_),
    .A2(_141_),
    .A3(_140_),
    .B1(\pll_control.tint[4] ),
    .B2(_122_),
    .X(_034_));
 sky130_fd_sc_hd__nand2_4 _369_ (.A(_134_),
    .B(_135_),
    .Y(_142_));
 sky130_fd_sc_hd__o21a_4 _370_ (.A1(_055_),
    .A2(_105_),
    .B1(_142_),
    .X(_143_));
 sky130_fd_sc_hd__nand2_4 _371_ (.A(_136_),
    .B(_143_),
    .Y(_144_));
 sky130_fd_sc_hd__or2_4 _372_ (.A(_136_),
    .B(_143_),
    .X(_145_));
 sky130_fd_sc_hd__a32o_4 _373_ (.A1(_123_),
    .A2(_145_),
    .A3(_144_),
    .B1(\pll_control.tint[3] ),
    .B2(_122_),
    .X(_033_));
 sky130_fd_sc_hd__or2_4 _374_ (.A(_134_),
    .B(_135_),
    .X(_146_));
 sky130_fd_sc_hd__a32o_4 _375_ (.A1(_123_),
    .A2(_142_),
    .A3(_146_),
    .B1(\pll_control.tint[2] ),
    .B2(_122_),
    .X(_032_));
 sky130_fd_sc_hd__o22a_4 _376_ (.A1(_057_),
    .A2(_105_),
    .B1(\pll_control.tint[0] ),
    .B2(_106_),
    .X(_147_));
 sky130_fd_sc_hd__nand2_4 _377_ (.A(_126_),
    .B(_147_),
    .Y(_148_));
 sky130_fd_sc_hd__o21a_4 _378_ (.A1(_057_),
    .A2(_105_),
    .B1(_148_),
    .X(_149_));
 sky130_fd_sc_hd__nand2_4 _379_ (.A(_127_),
    .B(_149_),
    .Y(_150_));
 sky130_fd_sc_hd__or2_4 _380_ (.A(_127_),
    .B(_149_),
    .X(_151_));
 sky130_fd_sc_hd__a32o_4 _381_ (.A1(_123_),
    .A2(_151_),
    .A3(_150_),
    .B1(\pll_control.tint[1] ),
    .B2(_122_),
    .X(_031_));
 sky130_fd_sc_hd__or2_4 _382_ (.A(_126_),
    .B(_147_),
    .X(_152_));
 sky130_fd_sc_hd__a32o_4 _383_ (.A1(_123_),
    .A2(_148_),
    .A3(_152_),
    .B1(\pll_control.tint[0] ),
    .B2(_122_),
    .X(_030_));
 sky130_fd_sc_hd__or2_4 _384_ (.A(\pll_control.tval[0] ),
    .B(_124_),
    .X(_153_));
 sky130_fd_sc_hd__a32o_4 _385_ (.A1(_123_),
    .A2(_125_),
    .A3(_153_),
    .B1(\pll_control.tval[1] ),
    .B2(_122_),
    .X(_029_));
 sky130_fd_sc_hd__o22a_4 _386_ (.A1(_059_),
    .A2(_123_),
    .B1(\pll_control.tval[0] ),
    .B2(_117_),
    .X(_154_));
 sky130_fd_sc_hd__inv_2 _387_ (.A(_154_),
    .Y(_028_));
 sky130_fd_sc_hd__or2_4 _388_ (.A(_049_),
    .B(_051_),
    .X(_155_));
 sky130_fd_sc_hd__and3_4 _389_ (.A(\pll_control.count0[1] ),
    .B(\pll_control.count0[0] ),
    .C(\pll_control.count0[2] ),
    .X(_156_));
 sky130_fd_sc_hd__and2_4 _390_ (.A(\pll_control.count0[3] ),
    .B(_156_),
    .X(_157_));
 sky130_fd_sc_hd__o21a_4 _391_ (.A1(\pll_control.count0[4] ),
    .A2(_157_),
    .B1(_071_),
    .X(_027_));
 sky130_fd_sc_hd__nor2_4 _392_ (.A(\pll_control.count0[3] ),
    .B(_156_),
    .Y(_158_));
 sky130_fd_sc_hd__a211o_4 _393_ (.A1(_043_),
    .A2(_157_),
    .B1(_070_),
    .C1(_158_),
    .X(_159_));
 sky130_fd_sc_hd__inv_2 _394_ (.A(_159_),
    .Y(_026_));
 sky130_fd_sc_hd__and4_4 _395_ (.A(\pll_control.count0[3] ),
    .B(_156_),
    .C(\pll_control.count0[4] ),
    .D(_071_),
    .X(_160_));
 sky130_fd_sc_hd__a211o_4 _396_ (.A1(_047_),
    .A2(_155_),
    .B1(_070_),
    .C1(_156_),
    .X(_161_));
 sky130_fd_sc_hd__inv_2 _397_ (.A(_161_),
    .Y(_162_));
 sky130_fd_sc_hd__or2_4 _398_ (.A(_160_),
    .B(_162_),
    .X(_025_));
 sky130_fd_sc_hd__or2_4 _399_ (.A(\pll_control.count0[1] ),
    .B(\pll_control.count0[0] ),
    .X(_163_));
 sky130_fd_sc_hd__and3_4 _400_ (.A(_155_),
    .B(_163_),
    .C(_071_),
    .X(_164_));
 sky130_fd_sc_hd__or2_4 _401_ (.A(_160_),
    .B(_164_),
    .X(_024_));
 sky130_fd_sc_hd__a211o_4 _402_ (.A1(\pll_control.count0[4] ),
    .A2(_157_),
    .B1(_051_),
    .C1(_070_),
    .X(_023_));
 sky130_fd_sc_hd__or2_4 _403_ (.A(dco),
    .B(_110_),
    .X(_165_));
 sky130_fd_sc_hd__a21bo_4 _404_ (.A1(ext_trim[0]),
    .A2(dco),
    .B1_N(_165_),
    .X(\ringosc.dstage[0].id.trim[0] ));
 sky130_fd_sc_hd__or3_4 _405_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(\pll_control.tint[4] ),
    .X(_166_));
 sky130_fd_sc_hd__inv_2 _406_ (.A(_166_),
    .Y(_167_));
 sky130_fd_sc_hd__or2_4 _407_ (.A(_056_),
    .B(_057_),
    .X(_168_));
 sky130_fd_sc_hd__inv_2 _408_ (.A(_168_),
    .Y(_169_));
 sky130_fd_sc_hd__and4_4 _409_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(_053_),
    .D(_169_),
    .X(_170_));
 sky130_fd_sc_hd__and4_4 _410_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(_053_),
    .D(_132_),
    .X(_171_));
 sky130_fd_sc_hd__and4_4 _411_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(_053_),
    .D(_130_),
    .X(_172_));
 sky130_fd_sc_hd__or2_4 _412_ (.A(_171_),
    .B(_172_),
    .X(_173_));
 sky130_fd_sc_hd__o32a_4 _413_ (.A1(\pll_control.tint[3] ),
    .A2(_055_),
    .A3(_108_),
    .B1(_107_),
    .B2(_168_),
    .X(_174_));
 sky130_fd_sc_hd__nor2_4 _414_ (.A(\pll_control.tint[4] ),
    .B(_174_),
    .Y(_175_));
 sky130_fd_sc_hd__or4_4 _415_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .C(\pll_control.tint[4] ),
    .D(_133_),
    .X(_176_));
 sky130_fd_sc_hd__inv_2 _416_ (.A(_176_),
    .Y(_177_));
 sky130_fd_sc_hd__or2_4 _417_ (.A(_175_),
    .B(_177_),
    .X(_178_));
 sky130_fd_sc_hd__or2_4 _418_ (.A(_165_),
    .B(_178_),
    .X(_179_));
 sky130_fd_sc_hd__or2_4 _419_ (.A(_173_),
    .B(_179_),
    .X(_180_));
 sky130_fd_sc_hd__or2_4 _420_ (.A(_170_),
    .B(_180_),
    .X(_181_));
 sky130_fd_sc_hd__o22a_4 _421_ (.A1(_062_),
    .A2(_063_),
    .B1(_167_),
    .B2(_181_),
    .X(_182_));
 sky130_fd_sc_hd__inv_2 _422_ (.A(_182_),
    .Y(\ringosc.dstage[1].id.trim[0] ));
 sky130_fd_sc_hd__or2_4 _423_ (.A(_170_),
    .B(_171_),
    .X(_183_));
 sky130_fd_sc_hd__or2_4 _424_ (.A(_172_),
    .B(_175_),
    .X(_184_));
 sky130_fd_sc_hd__and4_4 _425_ (.A(_054_),
    .B(_055_),
    .C(_053_),
    .D(_132_),
    .X(_185_));
 sky130_fd_sc_hd__and4_4 _426_ (.A(_054_),
    .B(_055_),
    .C(_053_),
    .D(_130_),
    .X(_186_));
 sky130_fd_sc_hd__or2_4 _427_ (.A(_165_),
    .B(_186_),
    .X(_187_));
 sky130_fd_sc_hd__or2_4 _428_ (.A(_185_),
    .B(_187_),
    .X(_188_));
 sky130_fd_sc_hd__or2_4 _429_ (.A(_184_),
    .B(_188_),
    .X(_189_));
 sky130_fd_sc_hd__or2_4 _430_ (.A(_183_),
    .B(_189_),
    .X(_190_));
 sky130_fd_sc_hd__inv_2 _431_ (.A(_190_),
    .Y(_191_));
 sky130_fd_sc_hd__a21o_4 _432_ (.A1(dco),
    .A2(ext_trim[2]),
    .B1(_191_),
    .X(\ringosc.dstage[2].id.trim[0] ));
 sky130_fd_sc_hd__and4_4 _433_ (.A(_054_),
    .B(_055_),
    .C(_053_),
    .D(_169_),
    .X(_192_));
 sky130_fd_sc_hd__or2_4 _434_ (.A(_188_),
    .B(_192_),
    .X(_193_));
 sky130_fd_sc_hd__a21bo_4 _435_ (.A1(dco),
    .A2(ext_trim[3]),
    .B1_N(_193_),
    .X(\ringosc.dstage[3].id.trim[0] ));
 sky130_fd_sc_hd__o21a_4 _436_ (.A1(_109_),
    .A2(_130_),
    .B1(_167_),
    .X(_194_));
 sky130_fd_sc_hd__a2bb2o_4 _437_ (.A1_N(_181_),
    .A2_N(_194_),
    .B1(dco),
    .B2(ext_trim[4]),
    .X(\ringosc.dstage[4].id.trim[0] ));
 sky130_fd_sc_hd__a21bo_4 _438_ (.A1(dco),
    .A2(ext_trim[5]),
    .B1_N(_180_),
    .X(\ringosc.dstage[5].id.trim[0] ));
 sky130_fd_sc_hd__a21bo_4 _439_ (.A1(dco),
    .A2(ext_trim[6]),
    .B1_N(_187_),
    .X(\ringosc.dstage[6].id.trim[0] ));
 sky130_fd_sc_hd__and2_4 _440_ (.A(_167_),
    .B(_168_),
    .X(_195_));
 sky130_fd_sc_hd__or2_4 _441_ (.A(_173_),
    .B(_195_),
    .X(_196_));
 sky130_fd_sc_hd__and4_4 _442_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .C(_053_),
    .D(_109_),
    .X(_197_));
 sky130_fd_sc_hd__and2_4 _443_ (.A(_167_),
    .B(_169_),
    .X(_198_));
 sky130_fd_sc_hd__or2_4 _444_ (.A(_197_),
    .B(_198_),
    .X(_199_));
 sky130_fd_sc_hd__and4_4 _445_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(_109_),
    .D(_053_),
    .X(_200_));
 sky130_fd_sc_hd__or4_4 _446_ (.A(_170_),
    .B(_200_),
    .C(_199_),
    .D(_196_),
    .X(_201_));
 sky130_fd_sc_hd__o22a_4 _447_ (.A1(_062_),
    .A2(_064_),
    .B1(_193_),
    .B2(_201_),
    .X(_202_));
 sky130_fd_sc_hd__inv_2 _448_ (.A(_202_),
    .Y(\ringosc.dstage[7].id.trim[0] ));
 sky130_fd_sc_hd__a21bo_4 _449_ (.A1(dco),
    .A2(ext_trim[8]),
    .B1_N(_179_),
    .X(\ringosc.dstage[8].id.trim[0] ));
 sky130_fd_sc_hd__and2_4 _450_ (.A(_109_),
    .B(_167_),
    .X(_203_));
 sky130_fd_sc_hd__o22a_4 _451_ (.A1(_062_),
    .A2(_065_),
    .B1(_181_),
    .B2(_203_),
    .X(_204_));
 sky130_fd_sc_hd__inv_2 _452_ (.A(_204_),
    .Y(\ringosc.dstage[9].id.trim[0] ));
 sky130_fd_sc_hd__a21bo_4 _453_ (.A1(dco),
    .A2(ext_trim[10]),
    .B1_N(_188_),
    .X(\ringosc.dstage[10].id.trim[0] ));
 sky130_fd_sc_hd__or2_4 _454_ (.A(_190_),
    .B(_195_),
    .X(_205_));
 sky130_fd_sc_hd__a21bo_4 _455_ (.A1(dco),
    .A2(ext_trim[11]),
    .B1_N(_205_),
    .X(\ringosc.dstage[11].id.trim[0] ));
 sky130_fd_sc_hd__a21bo_4 _456_ (.A1(dco),
    .A2(ext_trim[12]),
    .B1_N(_189_),
    .X(\ringosc.iss.trim[0] ));
 sky130_fd_sc_hd__or4_4 _457_ (.A(_054_),
    .B(_055_),
    .C(\pll_control.tint[4] ),
    .D(\pll_control.tint[1] ),
    .X(_206_));
 sky130_fd_sc_hd__a32o_4 _458_ (.A1(_166_),
    .A2(_206_),
    .A3(_191_),
    .B1(dco),
    .B2(ext_trim[13]),
    .X(\ringosc.dstage[0].id.trim[1] ));
 sky130_fd_sc_hd__and4_4 _459_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .C(_053_),
    .D(_168_),
    .X(_207_));
 sky130_fd_sc_hd__or2_4 _460_ (.A(_173_),
    .B(_207_),
    .X(_208_));
 sky130_fd_sc_hd__and4_4 _461_ (.A(_054_),
    .B(_055_),
    .C(_109_),
    .D(\pll_control.tint[4] ),
    .X(_209_));
 sky130_fd_sc_hd__and4_4 _462_ (.A(_053_),
    .B(_169_),
    .C(\pll_control.tint[3] ),
    .D(\pll_control.tint[2] ),
    .X(_210_));
 sky130_fd_sc_hd__or2_4 _463_ (.A(_209_),
    .B(_210_),
    .X(_211_));
 sky130_fd_sc_hd__or2_4 _464_ (.A(_165_),
    .B(_211_),
    .X(_212_));
 sky130_fd_sc_hd__or4_4 _465_ (.A(_165_),
    .B(_211_),
    .C(_178_),
    .D(_208_),
    .X(_213_));
 sky130_fd_sc_hd__and4_4 _466_ (.A(_054_),
    .B(_055_),
    .C(\pll_control.tint[4] ),
    .D(\pll_control.tint[1] ),
    .X(_214_));
 sky130_fd_sc_hd__and4_4 _467_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(\pll_control.tint[4] ),
    .D(_056_),
    .X(_215_));
 sky130_fd_sc_hd__or2_4 _468_ (.A(_214_),
    .B(_215_),
    .X(_216_));
 sky130_fd_sc_hd__and4_4 _469_ (.A(\pll_control.tint[3] ),
    .B(_055_),
    .C(_053_),
    .D(_130_),
    .X(_217_));
 sky130_fd_sc_hd__a211o_4 _470_ (.A1(_129_),
    .A2(_167_),
    .B1(_216_),
    .C1(_217_),
    .X(_218_));
 sky130_fd_sc_hd__o32a_4 _471_ (.A1(_054_),
    .A2(\pll_control.tint[2] ),
    .A3(_108_),
    .B1(_107_),
    .B2(_129_),
    .X(_219_));
 sky130_fd_sc_hd__nor2_4 _472_ (.A(_053_),
    .B(_219_),
    .Y(_220_));
 sky130_fd_sc_hd__and4_4 _473_ (.A(\pll_control.tint[4] ),
    .B(\pll_control.tint[1] ),
    .C(_054_),
    .D(\pll_control.tint[2] ),
    .X(_221_));
 sky130_fd_sc_hd__or4_4 _474_ (.A(_170_),
    .B(_221_),
    .C(_220_),
    .D(_218_),
    .X(_222_));
 sky130_fd_sc_hd__o22a_4 _475_ (.A1(_062_),
    .A2(_066_),
    .B1(_213_),
    .B2(_222_),
    .X(_223_));
 sky130_fd_sc_hd__inv_2 _476_ (.A(_223_),
    .Y(\ringosc.dstage[1].id.trim[1] ));
 sky130_fd_sc_hd__nor2_4 _477_ (.A(_053_),
    .B(_174_),
    .Y(_224_));
 sky130_fd_sc_hd__or4_4 _478_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .C(_053_),
    .D(_133_),
    .X(_225_));
 sky130_fd_sc_hd__inv_2 _479_ (.A(_225_),
    .Y(_226_));
 sky130_fd_sc_hd__or4_4 _480_ (.A(_167_),
    .B(_170_),
    .C(_226_),
    .D(_224_),
    .X(_227_));
 sky130_fd_sc_hd__o22a_4 _481_ (.A1(_062_),
    .A2(_067_),
    .B1(_213_),
    .B2(_227_),
    .X(_228_));
 sky130_fd_sc_hd__inv_2 _482_ (.A(_228_),
    .Y(\ringosc.dstage[2].id.trim[1] ));
 sky130_fd_sc_hd__or2_4 _483_ (.A(_184_),
    .B(_207_),
    .X(_229_));
 sky130_fd_sc_hd__or2_4 _484_ (.A(_194_),
    .B(_211_),
    .X(_230_));
 sky130_fd_sc_hd__and2_4 _485_ (.A(\pll_control.tint[1] ),
    .B(_167_),
    .X(_231_));
 sky130_fd_sc_hd__or4_4 _486_ (.A(_183_),
    .B(_231_),
    .C(_230_),
    .D(_188_),
    .X(_232_));
 sky130_fd_sc_hd__o22a_4 _487_ (.A1(_062_),
    .A2(_068_),
    .B1(_229_),
    .B2(_232_),
    .X(_233_));
 sky130_fd_sc_hd__inv_2 _488_ (.A(_233_),
    .Y(\ringosc.dstage[3].id.trim[1] ));
 sky130_fd_sc_hd__or2_4 _489_ (.A(_197_),
    .B(_231_),
    .X(_234_));
 sky130_fd_sc_hd__and4_4 _490_ (.A(_054_),
    .B(\pll_control.tint[2] ),
    .C(\pll_control.tint[4] ),
    .D(_168_),
    .X(_235_));
 sky130_fd_sc_hd__or4_4 _491_ (.A(_054_),
    .B(_055_),
    .C(\pll_control.tint[4] ),
    .D(_133_),
    .X(_236_));
 sky130_fd_sc_hd__inv_2 _492_ (.A(_236_),
    .Y(_237_));
 sky130_fd_sc_hd__and4_4 _493_ (.A(_054_),
    .B(_055_),
    .C(\pll_control.tint[4] ),
    .D(_130_),
    .X(_238_));
 sky130_fd_sc_hd__or4_4 _494_ (.A(_237_),
    .B(_238_),
    .C(_235_),
    .D(_234_),
    .X(_239_));
 sky130_fd_sc_hd__or4_4 _495_ (.A(_183_),
    .B(_214_),
    .C(_230_),
    .D(_239_),
    .X(_240_));
 sky130_fd_sc_hd__o22a_4 _496_ (.A1(_062_),
    .A2(_069_),
    .B1(_189_),
    .B2(_240_),
    .X(_241_));
 sky130_fd_sc_hd__inv_2 _497_ (.A(_241_),
    .Y(\ringosc.dstage[4].id.trim[1] ));
 sky130_fd_sc_hd__or4_4 _498_ (.A(_167_),
    .B(_177_),
    .C(_238_),
    .D(_212_),
    .X(_242_));
 sky130_fd_sc_hd__or4_4 _499_ (.A(_183_),
    .B(_214_),
    .C(_242_),
    .D(_229_),
    .X(_243_));
 sky130_fd_sc_hd__a21bo_4 _500_ (.A1(dco),
    .A2(ext_trim[18]),
    .B1_N(_243_),
    .X(\ringosc.dstage[5].id.trim[1] ));
 sky130_fd_sc_hd__or2_4 _501_ (.A(_198_),
    .B(_207_),
    .X(_244_));
 sky130_fd_sc_hd__or2_4 _502_ (.A(_205_),
    .B(_244_),
    .X(_245_));
 sky130_fd_sc_hd__a21bo_4 _503_ (.A1(dco),
    .A2(ext_trim[19]),
    .B1_N(_245_),
    .X(\ringosc.dstage[6].id.trim[1] ));
 sky130_fd_sc_hd__or2_4 _504_ (.A(_211_),
    .B(_238_),
    .X(_246_));
 sky130_fd_sc_hd__or2_4 _505_ (.A(_216_),
    .B(_246_),
    .X(_247_));
 sky130_fd_sc_hd__and4_4 _506_ (.A(\pll_control.tint[3] ),
    .B(_055_),
    .C(\pll_control.tint[4] ),
    .D(_056_),
    .X(_248_));
 sky130_fd_sc_hd__or4_4 _507_ (.A(_221_),
    .B(_248_),
    .C(_247_),
    .D(_245_),
    .X(_249_));
 sky130_fd_sc_hd__a21bo_4 _508_ (.A1(dco),
    .A2(ext_trim[20]),
    .B1_N(_249_),
    .X(\ringosc.dstage[7].id.trim[1] ));
 sky130_fd_sc_hd__or4_4 _509_ (.A(dco),
    .B(_110_),
    .C(_170_),
    .D(_244_),
    .X(_250_));
 sky130_fd_sc_hd__or4_4 _510_ (.A(_178_),
    .B(_246_),
    .C(_196_),
    .D(_250_),
    .X(_251_));
 sky130_fd_sc_hd__a21bo_4 _511_ (.A1(dco),
    .A2(ext_trim[21]),
    .B1_N(_251_),
    .X(\ringosc.dstage[8].id.trim[1] ));
 sky130_fd_sc_hd__or4_4 _512_ (.A(_167_),
    .B(_170_),
    .C(_216_),
    .D(_165_),
    .X(_252_));
 sky130_fd_sc_hd__or4_4 _513_ (.A(_178_),
    .B(_246_),
    .C(_208_),
    .D(_252_),
    .X(_253_));
 sky130_fd_sc_hd__a21bo_4 _514_ (.A1(dco),
    .A2(ext_trim[22]),
    .B1_N(_253_),
    .X(\ringosc.dstage[9].id.trim[1] ));
 sky130_fd_sc_hd__o22a_4 _515_ (.A1(\pll_control.tint[4] ),
    .A2(dco),
    .B1(_062_),
    .B2(ext_trim[23]),
    .X(\ringosc.dstage[10].id.trim[1] ));
 sky130_fd_sc_hd__a211o_4 _516_ (.A1(_132_),
    .A2(_167_),
    .B1(_170_),
    .C1(_173_),
    .X(_254_));
 sky130_fd_sc_hd__or4_4 _517_ (.A(_194_),
    .B(_221_),
    .C(_244_),
    .D(_254_),
    .X(_255_));
 sky130_fd_sc_hd__or4_4 _518_ (.A(_165_),
    .B(_178_),
    .C(_255_),
    .D(_247_),
    .X(_256_));
 sky130_fd_sc_hd__a21bo_4 _519_ (.A1(dco),
    .A2(ext_trim[24]),
    .B1_N(_256_),
    .X(\ringosc.dstage[11].id.trim[1] ));
 sky130_fd_sc_hd__or4_4 _520_ (.A(_226_),
    .B(_237_),
    .C(_175_),
    .D(_199_),
    .X(_257_));
 sky130_fd_sc_hd__or4_4 _521_ (.A(_230_),
    .B(_254_),
    .C(_257_),
    .D(_188_),
    .X(_258_));
 sky130_fd_sc_hd__a21bo_4 _522_ (.A1(dco),
    .A2(ext_trim[25]),
    .B1_N(_258_),
    .X(\ringosc.iss.trim[1] ));
 sky130_fd_sc_hd__buf_2 _523_ (.A(_021_),
    .X(_020_));
 sky130_fd_sc_hd__buf_2 _524_ (.A(_021_),
    .X(_019_));
 sky130_fd_sc_hd__buf_2 _525_ (.A(_021_),
    .X(_018_));
 sky130_fd_sc_hd__buf_2 _526_ (.A(_021_),
    .X(_017_));
 sky130_fd_sc_hd__buf_2 _527_ (.A(_021_),
    .X(_016_));
 sky130_fd_sc_hd__buf_2 _528_ (.A(_021_),
    .X(_015_));
 sky130_fd_sc_hd__buf_2 _529_ (.A(_021_),
    .X(_014_));
 sky130_fd_sc_hd__buf_2 _530_ (.A(_021_),
    .X(_013_));
 sky130_fd_sc_hd__buf_2 _531_ (.A(_021_),
    .X(_012_));
 sky130_fd_sc_hd__buf_2 _532_ (.A(_021_),
    .X(_011_));
 sky130_fd_sc_hd__buf_2 _533_ (.A(_021_),
    .X(_010_));
 sky130_fd_sc_hd__buf_2 _534_ (.A(_021_),
    .X(_009_));
 sky130_fd_sc_hd__buf_2 _535_ (.A(_021_),
    .X(_008_));
 sky130_fd_sc_hd__buf_2 _536_ (.A(_021_),
    .X(_007_));
 sky130_fd_sc_hd__buf_2 _537_ (.A(_021_),
    .X(_006_));
 sky130_fd_sc_hd__buf_2 _538_ (.A(_021_),
    .X(_005_));
 sky130_fd_sc_hd__buf_2 _539_ (.A(_021_),
    .X(_004_));
 sky130_fd_sc_hd__buf_2 _540_ (.A(_021_),
    .X(_003_));
 sky130_fd_sc_hd__buf_2 _541_ (.A(_021_),
    .X(_002_));
 sky130_fd_sc_hd__buf_2 _542_ (.A(_021_),
    .X(_001_));
 sky130_fd_sc_hd__buf_2 _543_ (.A(_021_),
    .X(_000_));
 sky130_fd_sc_hd__buf_2 _544_ (.A(_021_),
    .X(_022_));
 sky130_fd_sc_hd__buf_2 _545_ (.A(\pll_control.clock ),
    .X(clockp[0]));
 sky130_fd_sc_hd__dfrtp_4 _546_ (.D(osc),
    .Q(\pll_control.oscbuf[0] ),
    .RESET_B(_000_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _547_ (.D(\pll_control.oscbuf[0] ),
    .Q(\pll_control.oscbuf[1] ),
    .RESET_B(_001_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _548_ (.D(\pll_control.oscbuf[1] ),
    .Q(\pll_control.oscbuf[2] ),
    .RESET_B(_002_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _549_ (.D(_023_),
    .Q(\pll_control.count0[0] ),
    .RESET_B(_003_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _550_ (.D(_024_),
    .Q(\pll_control.count0[1] ),
    .RESET_B(_004_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _551_ (.D(_025_),
    .Q(\pll_control.count0[2] ),
    .RESET_B(_005_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _552_ (.D(_026_),
    .Q(\pll_control.count0[3] ),
    .RESET_B(_006_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _553_ (.D(_027_),
    .Q(\pll_control.count0[4] ),
    .RESET_B(_007_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _554_ (.D(_028_),
    .Q(\pll_control.tval[0] ),
    .RESET_B(_008_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _555_ (.D(_029_),
    .Q(\pll_control.tval[1] ),
    .RESET_B(_009_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _556_ (.D(_030_),
    .Q(\pll_control.tint[0] ),
    .RESET_B(_010_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _557_ (.D(_031_),
    .Q(\pll_control.tint[1] ),
    .RESET_B(_011_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _558_ (.D(_032_),
    .Q(\pll_control.tint[2] ),
    .RESET_B(_012_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _559_ (.D(_033_),
    .Q(\pll_control.tint[3] ),
    .RESET_B(_013_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _560_ (.D(_034_),
    .Q(\pll_control.tint[4] ),
    .RESET_B(_014_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _561_ (.D(_035_),
    .Q(\pll_control.prep[0] ),
    .RESET_B(_015_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _562_ (.D(_036_),
    .Q(\pll_control.prep[1] ),
    .RESET_B(_016_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _563_ (.D(_037_),
    .Q(\pll_control.prep[2] ),
    .RESET_B(_017_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _564_ (.D(_038_),
    .Q(\pll_control.count1[0] ),
    .RESET_B(_018_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _565_ (.D(_039_),
    .Q(\pll_control.count1[1] ),
    .RESET_B(_019_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _566_ (.D(_040_),
    .Q(\pll_control.count1[2] ),
    .RESET_B(_020_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _567_ (.D(_041_),
    .Q(\pll_control.count1[3] ),
    .RESET_B(_021_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__dfrtp_4 _568_ (.D(_042_),
    .Q(\pll_control.count1[4] ),
    .RESET_B(_022_),
    .CLK(\pll_control.clock ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[0].id.delaybuf0  (.A(\ringosc.dstage[0].id.in ),
    .X(\ringosc.dstage[0].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[0].id.delaybuf1  (.A(\ringosc.dstage[0].id.ts ),
    .X(\ringosc.dstage[0].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[0].id.delayen0  (.A(\ringosc.dstage[0].id.d2 ),
    .TE(\ringosc.dstage[0].id.trim[0] ),
    .Z(\ringosc.dstage[0].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[0].id.delayen1  (.A(\ringosc.dstage[0].id.d0 ),
    .TE(\ringosc.dstage[0].id.trim[1] ),
    .Z(\ringosc.dstage[0].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[0].id.delayenb0  (.A(\ringosc.dstage[0].id.ts ),
    .TE_B(\ringosc.dstage[0].id.trim[0] ),
    .Z(\ringosc.dstage[0].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[0].id.delayenb1  (.A(\ringosc.dstage[0].id.ts ),
    .TE_B(\ringosc.dstage[0].id.trim[1] ),
    .Z(\ringosc.dstage[0].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[0].id.delayint0  (.A(\ringosc.dstage[0].id.d1 ),
    .Y(\ringosc.dstage[0].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[10].id.delaybuf0  (.A(\ringosc.dstage[10].id.in ),
    .X(\ringosc.dstage[10].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[10].id.delaybuf1  (.A(\ringosc.dstage[10].id.ts ),
    .X(\ringosc.dstage[10].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[10].id.delayen0  (.A(\ringosc.dstage[10].id.d2 ),
    .TE(\ringosc.dstage[10].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[10].id.delayen1  (.A(\ringosc.dstage[10].id.d0 ),
    .TE(\ringosc.dstage[10].id.trim[1] ),
    .Z(\ringosc.dstage[10].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[10].id.delayenb0  (.A(\ringosc.dstage[10].id.ts ),
    .TE_B(\ringosc.dstage[10].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[10].id.delayenb1  (.A(\ringosc.dstage[10].id.ts ),
    .TE_B(\ringosc.dstage[10].id.trim[1] ),
    .Z(\ringosc.dstage[10].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[10].id.delayint0  (.A(\ringosc.dstage[10].id.d1 ),
    .Y(\ringosc.dstage[10].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[11].id.delaybuf0  (.A(\ringosc.dstage[10].id.out ),
    .X(\ringosc.dstage[11].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[11].id.delaybuf1  (.A(\ringosc.dstage[11].id.ts ),
    .X(\ringosc.dstage[11].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[11].id.delayen0  (.A(\ringosc.dstage[11].id.d2 ),
    .TE(\ringosc.dstage[11].id.trim[0] ),
    .Z(\ringosc.dstage[11].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[11].id.delayen1  (.A(\ringosc.dstage[11].id.d0 ),
    .TE(\ringosc.dstage[11].id.trim[1] ),
    .Z(\ringosc.dstage[11].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[11].id.delayenb0  (.A(\ringosc.dstage[11].id.ts ),
    .TE_B(\ringosc.dstage[11].id.trim[0] ),
    .Z(\ringosc.dstage[11].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[11].id.delayenb1  (.A(\ringosc.dstage[11].id.ts ),
    .TE_B(\ringosc.dstage[11].id.trim[1] ),
    .Z(\ringosc.dstage[11].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[11].id.delayint0  (.A(\ringosc.dstage[11].id.d1 ),
    .Y(\ringosc.dstage[11].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[1].id.delaybuf0  (.A(\ringosc.dstage[0].id.out ),
    .X(\ringosc.dstage[1].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[1].id.delaybuf1  (.A(\ringosc.dstage[1].id.ts ),
    .X(\ringosc.dstage[1].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[1].id.delayen0  (.A(\ringosc.dstage[1].id.d2 ),
    .TE(\ringosc.dstage[1].id.trim[0] ),
    .Z(\ringosc.dstage[1].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[1].id.delayen1  (.A(\ringosc.dstage[1].id.d0 ),
    .TE(\ringosc.dstage[1].id.trim[1] ),
    .Z(\ringosc.dstage[1].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[1].id.delayenb0  (.A(\ringosc.dstage[1].id.ts ),
    .TE_B(\ringosc.dstage[1].id.trim[0] ),
    .Z(\ringosc.dstage[1].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[1].id.delayenb1  (.A(\ringosc.dstage[1].id.ts ),
    .TE_B(\ringosc.dstage[1].id.trim[1] ),
    .Z(\ringosc.dstage[1].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[1].id.delayint0  (.A(\ringosc.dstage[1].id.d1 ),
    .Y(\ringosc.dstage[1].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[2].id.delaybuf0  (.A(\ringosc.dstage[1].id.out ),
    .X(\ringosc.dstage[2].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[2].id.delaybuf1  (.A(\ringosc.dstage[2].id.ts ),
    .X(\ringosc.dstage[2].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[2].id.delayen0  (.A(\ringosc.dstage[2].id.d2 ),
    .TE(\ringosc.dstage[2].id.trim[0] ),
    .Z(\ringosc.dstage[2].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[2].id.delayen1  (.A(\ringosc.dstage[2].id.d0 ),
    .TE(\ringosc.dstage[2].id.trim[1] ),
    .Z(\ringosc.dstage[2].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[2].id.delayenb0  (.A(\ringosc.dstage[2].id.ts ),
    .TE_B(\ringosc.dstage[2].id.trim[0] ),
    .Z(\ringosc.dstage[2].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[2].id.delayenb1  (.A(\ringosc.dstage[2].id.ts ),
    .TE_B(\ringosc.dstage[2].id.trim[1] ),
    .Z(\ringosc.dstage[2].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[2].id.delayint0  (.A(\ringosc.dstage[2].id.d1 ),
    .Y(\ringosc.dstage[2].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[3].id.delaybuf0  (.A(\ringosc.dstage[2].id.out ),
    .X(\ringosc.dstage[3].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[3].id.delaybuf1  (.A(\ringosc.dstage[3].id.ts ),
    .X(\ringosc.dstage[3].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[3].id.delayen0  (.A(\ringosc.dstage[3].id.d2 ),
    .TE(\ringosc.dstage[3].id.trim[0] ),
    .Z(\ringosc.dstage[3].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[3].id.delayen1  (.A(\ringosc.dstage[3].id.d0 ),
    .TE(\ringosc.dstage[3].id.trim[1] ),
    .Z(\ringosc.dstage[3].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[3].id.delayenb0  (.A(\ringosc.dstage[3].id.ts ),
    .TE_B(\ringosc.dstage[3].id.trim[0] ),
    .Z(\ringosc.dstage[3].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[3].id.delayenb1  (.A(\ringosc.dstage[3].id.ts ),
    .TE_B(\ringosc.dstage[3].id.trim[1] ),
    .Z(\ringosc.dstage[3].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[3].id.delayint0  (.A(\ringosc.dstage[3].id.d1 ),
    .Y(\ringosc.dstage[3].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[4].id.delaybuf0  (.A(\ringosc.dstage[3].id.out ),
    .X(\ringosc.dstage[4].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[4].id.delaybuf1  (.A(\ringosc.dstage[4].id.ts ),
    .X(\ringosc.dstage[4].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[4].id.delayen0  (.A(\ringosc.dstage[4].id.d2 ),
    .TE(\ringosc.dstage[4].id.trim[0] ),
    .Z(\ringosc.dstage[4].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[4].id.delayen1  (.A(\ringosc.dstage[4].id.d0 ),
    .TE(\ringosc.dstage[4].id.trim[1] ),
    .Z(\ringosc.dstage[4].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[4].id.delayenb0  (.A(\ringosc.dstage[4].id.ts ),
    .TE_B(\ringosc.dstage[4].id.trim[0] ),
    .Z(\ringosc.dstage[4].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[4].id.delayenb1  (.A(\ringosc.dstage[4].id.ts ),
    .TE_B(\ringosc.dstage[4].id.trim[1] ),
    .Z(\ringosc.dstage[4].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[4].id.delayint0  (.A(\ringosc.dstage[4].id.d1 ),
    .Y(\ringosc.dstage[4].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[5].id.delaybuf0  (.A(\ringosc.dstage[4].id.out ),
    .X(\ringosc.dstage[5].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[5].id.delaybuf1  (.A(\ringosc.dstage[5].id.ts ),
    .X(\ringosc.dstage[5].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[5].id.delayen0  (.A(\ringosc.dstage[5].id.d2 ),
    .TE(\ringosc.dstage[5].id.trim[0] ),
    .Z(\ringosc.dstage[5].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[5].id.delayen1  (.A(\ringosc.dstage[5].id.d0 ),
    .TE(\ringosc.dstage[5].id.trim[1] ),
    .Z(\ringosc.dstage[5].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[5].id.delayenb0  (.A(\ringosc.dstage[5].id.ts ),
    .TE_B(\ringosc.dstage[5].id.trim[0] ),
    .Z(\ringosc.dstage[5].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[5].id.delayenb1  (.A(\ringosc.dstage[5].id.ts ),
    .TE_B(\ringosc.dstage[5].id.trim[1] ),
    .Z(\ringosc.dstage[5].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[5].id.delayint0  (.A(\ringosc.dstage[5].id.d1 ),
    .Y(\ringosc.dstage[5].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[6].id.delaybuf0  (.A(\ringosc.dstage[5].id.out ),
    .X(\ringosc.dstage[6].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[6].id.delaybuf1  (.A(\ringosc.dstage[6].id.ts ),
    .X(\ringosc.dstage[6].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[6].id.delayen0  (.A(\ringosc.dstage[6].id.d2 ),
    .TE(\ringosc.dstage[6].id.trim[0] ),
    .Z(\ringosc.dstage[6].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[6].id.delayen1  (.A(\ringosc.dstage[6].id.d0 ),
    .TE(\ringosc.dstage[6].id.trim[1] ),
    .Z(\ringosc.dstage[6].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[6].id.delayenb0  (.A(\ringosc.dstage[6].id.ts ),
    .TE_B(\ringosc.dstage[6].id.trim[0] ),
    .Z(\ringosc.dstage[6].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[6].id.delayenb1  (.A(\ringosc.dstage[6].id.ts ),
    .TE_B(\ringosc.dstage[6].id.trim[1] ),
    .Z(\ringosc.dstage[6].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[6].id.delayint0  (.A(\ringosc.dstage[6].id.d1 ),
    .Y(\ringosc.dstage[6].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[7].id.delaybuf0  (.A(\ringosc.dstage[6].id.out ),
    .X(\ringosc.dstage[7].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[7].id.delaybuf1  (.A(\ringosc.dstage[7].id.ts ),
    .X(\ringosc.dstage[7].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[7].id.delayen0  (.A(\ringosc.dstage[7].id.d2 ),
    .TE(\ringosc.dstage[7].id.trim[0] ),
    .Z(\ringosc.dstage[7].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[7].id.delayen1  (.A(\ringosc.dstage[7].id.d0 ),
    .TE(\ringosc.dstage[7].id.trim[1] ),
    .Z(\ringosc.dstage[7].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[7].id.delayenb0  (.A(\ringosc.dstage[7].id.ts ),
    .TE_B(\ringosc.dstage[7].id.trim[0] ),
    .Z(\ringosc.dstage[7].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[7].id.delayenb1  (.A(\ringosc.dstage[7].id.ts ),
    .TE_B(\ringosc.dstage[7].id.trim[1] ),
    .Z(\ringosc.dstage[7].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[7].id.delayint0  (.A(\ringosc.dstage[7].id.d1 ),
    .Y(\ringosc.dstage[7].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[8].id.delaybuf0  (.A(\ringosc.dstage[7].id.out ),
    .X(\ringosc.dstage[8].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[8].id.delaybuf1  (.A(\ringosc.dstage[8].id.ts ),
    .X(\ringosc.dstage[8].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[8].id.delayen0  (.A(\ringosc.dstage[8].id.d2 ),
    .TE(\ringosc.dstage[8].id.trim[0] ),
    .Z(\ringosc.dstage[8].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[8].id.delayen1  (.A(\ringosc.dstage[8].id.d0 ),
    .TE(\ringosc.dstage[8].id.trim[1] ),
    .Z(\ringosc.dstage[8].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[8].id.delayenb0  (.A(\ringosc.dstage[8].id.ts ),
    .TE_B(\ringosc.dstage[8].id.trim[0] ),
    .Z(\ringosc.dstage[8].id.out ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[8].id.delayenb1  (.A(\ringosc.dstage[8].id.ts ),
    .TE_B(\ringosc.dstage[8].id.trim[1] ),
    .Z(\ringosc.dstage[8].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[8].id.delayint0  (.A(\ringosc.dstage[8].id.d1 ),
    .Y(\ringosc.dstage[8].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[9].id.delaybuf0  (.A(\ringosc.dstage[8].id.out ),
    .X(\ringosc.dstage[9].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[9].id.delaybuf1  (.A(\ringosc.dstage[9].id.ts ),
    .X(\ringosc.dstage[9].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[9].id.delayen0  (.A(\ringosc.dstage[9].id.d2 ),
    .TE(\ringosc.dstage[9].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.in ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[9].id.delayen1  (.A(\ringosc.dstage[9].id.d0 ),
    .TE(\ringosc.dstage[9].id.trim[1] ),
    .Z(\ringosc.dstage[9].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[9].id.delayenb0  (.A(\ringosc.dstage[9].id.ts ),
    .TE_B(\ringosc.dstage[9].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.in ));
 sky130_fd_sc_hd__einvn_4 \ringosc.dstage[9].id.delayenb1  (.A(\ringosc.dstage[9].id.ts ),
    .TE_B(\ringosc.dstage[9].id.trim[1] ),
    .Z(\ringosc.dstage[9].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[9].id.delayint0  (.A(\ringosc.dstage[9].id.d1 ),
    .Y(\ringosc.dstage[9].id.d2 ));
 sky130_fd_sc_hd__clkinv_2 \ringosc.ibufp00  (.A(\ringosc.dstage[0].id.in ),
    .Y(\ringosc.c[0] ));
 sky130_fd_sc_hd__clkinv_8 \ringosc.ibufp01  (.A(\ringosc.c[0] ),
    .Y(\pll_control.clock ));
 sky130_fd_sc_hd__clkinv_2 \ringosc.ibufp10  (.A(\ringosc.dstage[5].id.out ),
    .Y(\ringosc.c[1] ));
 sky130_fd_sc_hd__clkinv_8 \ringosc.ibufp11  (.A(\ringosc.c[1] ),
    .Y(clockp[1]));
 sky130_fd_sc_hd__conb_1 \ringosc.iss.const1  (.HI(\ringosc.iss.one ));
 sky130_fd_sc_hd__or2_2 \ringosc.iss.ctrlen0  (.A(\ringosc.iss.reset ),
    .B(\ringosc.iss.trim[0] ),
    .X(\ringosc.iss.ctrl0 ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.iss.delaybuf0  (.A(\ringosc.dstage[11].id.out ),
    .X(\ringosc.iss.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.iss.delayen0  (.A(\ringosc.iss.d2 ),
    .TE(\ringosc.iss.trim[0] ),
    .Z(\ringosc.dstage[0].id.in ));
 sky130_fd_sc_hd__einvp_2 \ringosc.iss.delayen1  (.A(\ringosc.iss.d0 ),
    .TE(\ringosc.iss.trim[1] ),
    .Z(\ringosc.iss.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.iss.delayenb0  (.A(\ringosc.dstage[11].id.out ),
    .TE_B(\ringosc.iss.ctrl0 ),
    .Z(\ringosc.dstage[0].id.in ));
 sky130_fd_sc_hd__einvn_4 \ringosc.iss.delayenb1  (.A(\ringosc.dstage[11].id.out ),
    .TE_B(\ringosc.iss.trim[1] ),
    .Z(\ringosc.iss.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.iss.delayint0  (.A(\ringosc.iss.d1 ),
    .Y(\ringosc.iss.d2 ));
 sky130_fd_sc_hd__einvp_1 \ringosc.iss.reseten0  (.A(\ringosc.iss.one ),
    .TE(\ringosc.iss.reset ),
    .Z(\ringosc.dstage[0].id.in ));
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
 sky130_fd_sc_hd__decap_3 PHY_52 ();
 sky130_fd_sc_hd__decap_3 PHY_53 ();
 sky130_fd_sc_hd__decap_3 PHY_54 ();
 sky130_fd_sc_hd__decap_3 PHY_55 ();
 sky130_fd_sc_hd__decap_3 PHY_56 ();
 sky130_fd_sc_hd__decap_3 PHY_57 ();
 sky130_fd_sc_hd__decap_3 PHY_58 ();
 sky130_fd_sc_hd__decap_3 PHY_59 ();
 sky130_fd_sc_hd__decap_3 PHY_60 ();
 sky130_fd_sc_hd__decap_3 PHY_61 ();
 sky130_fd_sc_hd__decap_3 PHY_62 ();
 sky130_fd_sc_hd__decap_3 PHY_63 ();
 sky130_fd_sc_hd__decap_3 PHY_64 ();
 sky130_fd_sc_hd__decap_3 PHY_65 ();
 sky130_fd_sc_hd__decap_3 PHY_66 ();
 sky130_fd_sc_hd__decap_3 PHY_67 ();
 sky130_fd_sc_hd__decap_3 PHY_68 ();
 sky130_fd_sc_hd__decap_3 PHY_69 ();
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
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_92 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_93 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_94 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_95 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_96 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_97 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_98 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_99 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_100 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_101 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_102 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_103 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_104 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_105 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_106 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_107 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_108 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_109 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_110 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_111 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_112 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_113 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_114 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_115 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_116 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_117 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_118 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_119 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_120 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_121 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_122 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_123 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_124 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_125 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_126 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_127 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_128 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_129 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_130 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_131 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_132 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_133 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_134 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_135 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_136 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_137 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_138 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_139 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_140 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_141 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_142 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_143 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_144 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_145 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_146 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_147 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_148 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_149 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_150 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_151 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_152 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_153 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_154 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_155 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_156 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_157 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_158 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_159 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_160 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_161 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_162 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_163 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_164 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_165 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_166 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_167 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_168 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_169 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_170 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_171 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_172 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_173 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_174 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_175 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_176 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_177 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_178 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_179 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_180 ();
endmodule
