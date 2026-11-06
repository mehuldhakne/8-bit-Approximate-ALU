DSCH 3.9
VERSION 10/18/2026 9:21:18 AM
BB(-39,-104,134,680)
SYM  #button
BB(-39,601,-30,609)
TITLE -35 605  #B7
MODEL 59
PROP                                                                                                                                    
REC(-38,602,6,6,r)
VIS 1
PIN(-30,605,0.000,0.000)B7
LIG(-31,605,-30,605)
LIG(-39,609,-39,601)
LIG(-31,609,-39,609)
LIG(-31,601,-31,609)
LIG(-39,601,-31,601)
LIG(-38,608,-38,602)
LIG(-32,608,-38,608)
LIG(-32,602,-32,608)
LIG(-38,602,-32,602)
FSYM
SYM  #button
BB(-39,581,-30,589)
TITLE -35 585  #A7
MODEL 59
PROP                                                                                                                                    
REC(-38,582,6,6,r)
VIS 1
PIN(-30,585,0.000,0.000)A7
LIG(-31,585,-30,585)
LIG(-39,589,-39,581)
LIG(-31,589,-39,589)
LIG(-31,581,-31,589)
LIG(-39,581,-31,581)
LIG(-38,588,-38,582)
LIG(-32,588,-38,588)
LIG(-32,582,-32,588)
LIG(-38,582,-32,582)
FSYM
SYM  #LOR1bit
BB(50,-90,80,0)
TITLE 60 -97  #LOR1bit
MODEL 6000
PROP                                                                                                                                    
REC(55,-85,20,80,r)
VIS 5
PIN(50,-50,0.000,0.000)B_inv
PIN(50,-60,0.000,0.000)B
PIN(50,-80,0.000,0.000)A
PIN(50,-30,0.000,0.000)O_inv
PIN(50,-70,0.000,0.000)A_inv
PIN(50,-10,0.000,0.000)S1
PIN(50,-40,0.000,0.000)B_set
PIN(50,-20,0.000,0.000)S0
PIN(80,-80,0.010,0.003)O0
LIG(50,-50,55,-50)
LIG(50,-60,55,-60)
LIG(50,-80,55,-80)
LIG(50,-30,55,-30)
LIG(50,-70,55,-70)
LIG(50,-10,55,-10)
LIG(50,-40,55,-40)
LIG(50,-20,55,-20)
LIG(75,-80,80,-80)
LIG(55,-85,55,-5)
LIG(55,-85,75,-85)
LIG(75,-85,75,-5)
LIG(75,-5,55,-5)
VLG module LOR1bit( B_inv,B,A,O_inv,A_inv,S1,B_set,S0,
VLG input B_inv,B,A,O_inv,A_inv,S1,B_set,S0;
VLG output O0;
VLG wire w2,w3,w5,w6,w7,w8,w11,w13;
VLG wire w17,w20,w21,w22;
VLG tgmux21 #(2) TgMux21_1(w5,w2,w3,B_inv);
VLG not #(1) inv_2(w13,A);
VLG not #(1) inv_3(w3,w2);
VLG tgmux21 #(2) TgMux21_4(w2,B,vdd,B_set);
VLG tgmux21 #(2) TgMux21_5(w17,A,w13,A_inv);
VLG xor #(3) xor2_6(w7,w17,w5);
VLG nand #(3) nand2_7(w6,w5,w17);
VLG nor #(2) nor2_8(w8,w17,w5);
VLG tgmux21 #(2) TgMux21_9(O0,w11,w20,O_inv);
VLG not #(1) inv_10(w20,w11);
VLG mux #(5) mux_11(w21,w6,w8,S0);
VLG mux #(5) mux_12(w22,w6,w7,S0);
VLG mux #(6) mux_13(w11,w22,w21,S1);
VLG endmodule
FSYM
SYM  #LOR1bit
BB(50,0,80,90)
TITLE 60 -7  #LOR1bit
MODEL 6000
PROP                                                                                                                                    
REC(55,5,20,80,r)
VIS 5
PIN(50,40,0.000,0.000)B_inv
PIN(50,30,0.000,0.000)B
PIN(50,10,0.000,0.000)A
PIN(50,60,0.000,0.000)O_inv
PIN(50,20,0.000,0.000)A_inv
PIN(50,80,0.000,0.000)S1
PIN(50,50,0.000,0.000)B_set
PIN(50,70,0.000,0.000)S0
PIN(80,10,0.010,0.003)O0
LIG(50,40,55,40)
LIG(50,30,55,30)
LIG(50,10,55,10)
LIG(50,60,55,60)
LIG(50,20,55,20)
LIG(50,80,55,80)
LIG(50,50,55,50)
LIG(50,70,55,70)
LIG(75,10,80,10)
LIG(55,5,55,85)
LIG(55,5,75,5)
LIG(75,5,75,85)
LIG(75,85,55,85)
VLG module LOR1bit( B_inv,B,A,O_inv,A_inv,S1,B_set,S0,
VLG input B_inv,B,A,O_inv,A_inv,S1,B_set,S0;
VLG output O0;
VLG wire w2,w3,w5,w6,w7,w8,w11,w13;
VLG wire w17,w20,w21,w22;
VLG tgmux21 #(2) TgMux21_1(w5,w2,w3,B_inv);
VLG not #(1) inv_2(w13,A);
VLG not #(1) inv_3(w3,w2);
VLG tgmux21 #(2) TgMux21_4(w2,B,vdd,B_set);
VLG tgmux21 #(2) TgMux21_5(w17,A,w13,A_inv);
VLG xor #(3) xor2_6(w7,w17,w5);
VLG nand #(3) nand2_7(w6,w5,w17);
VLG nor #(2) nor2_8(w8,w17,w5);
VLG tgmux21 #(2) TgMux21_9(O0,w11,w20,O_inv);
VLG not #(1) inv_10(w20,w11);
VLG mux #(5) mux_11(w21,w6,w8,S0);
VLG mux #(5) mux_12(w22,w6,w7,S0);
VLG mux #(6) mux_13(w11,w22,w21,S1);
VLG endmodule
FSYM
SYM  #LOR1bit
BB(50,90,80,180)
TITLE 60 83  #LOR1bit
MODEL 6000
PROP                                                                                                                                    
REC(55,95,20,80,r)
VIS 5
PIN(50,130,0.000,0.000)B_inv
PIN(50,120,0.000,0.000)B
PIN(50,100,0.000,0.000)A
PIN(50,150,0.000,0.000)O_inv
PIN(50,110,0.000,0.000)A_inv
PIN(50,170,0.000,0.000)S1
PIN(50,140,0.000,0.000)B_set
PIN(50,160,0.000,0.000)S0
PIN(80,100,0.010,0.003)O0
LIG(50,130,55,130)
LIG(50,120,55,120)
LIG(50,100,55,100)
LIG(50,150,55,150)
LIG(50,110,55,110)
LIG(50,170,55,170)
LIG(50,140,55,140)
LIG(50,160,55,160)
LIG(75,100,80,100)
LIG(55,95,55,175)
LIG(55,95,75,95)
LIG(75,95,75,175)
LIG(75,175,55,175)
VLG module LOR1bit( B_inv,B,A,O_inv,A_inv,S1,B_set,S0,
VLG input B_inv,B,A,O_inv,A_inv,S1,B_set,S0;
VLG output O0;
VLG wire w2,w3,w5,w6,w7,w8,w11,w13;
VLG wire w17,w20,w21,w22;
VLG tgmux21 #(2) TgMux21_1(w5,w2,w3,B_inv);
VLG not #(1) inv_2(w13,A);
VLG not #(1) inv_3(w3,w2);
VLG tgmux21 #(2) TgMux21_4(w2,B,vdd,B_set);
VLG tgmux21 #(2) TgMux21_5(w17,A,w13,A_inv);
VLG xor #(3) xor2_6(w7,w17,w5);
VLG nand #(3) nand2_7(w6,w5,w17);
VLG nor #(2) nor2_8(w8,w17,w5);
VLG tgmux21 #(2) TgMux21_9(O0,w11,w20,O_inv);
VLG not #(1) inv_10(w20,w11);
VLG mux #(5) mux_11(w21,w6,w8,S0);
VLG mux #(5) mux_12(w22,w6,w7,S0);
VLG mux #(6) mux_13(w11,w22,w21,S1);
VLG endmodule
FSYM
SYM  #LOR1bit
BB(50,180,80,270)
TITLE 60 173  #LOR1bit
MODEL 6000
PROP                                                                                                                                    
REC(55,185,20,80,r)
VIS 5
PIN(50,220,0.000,0.000)B_inv
PIN(50,210,0.000,0.000)B
PIN(50,190,0.000,0.000)A
PIN(50,240,0.000,0.000)O_inv
PIN(50,200,0.000,0.000)A_inv
PIN(50,260,0.000,0.000)S1
PIN(50,230,0.000,0.000)B_set
PIN(50,250,0.000,0.000)S0
PIN(80,190,0.010,0.003)O0
LIG(50,220,55,220)
LIG(50,210,55,210)
LIG(50,190,55,190)
LIG(50,240,55,240)
LIG(50,200,55,200)
LIG(50,260,55,260)
LIG(50,230,55,230)
LIG(50,250,55,250)
LIG(75,190,80,190)
LIG(55,185,55,265)
LIG(55,185,75,185)
LIG(75,185,75,265)
LIG(75,265,55,265)
VLG module LOR1bit( B_inv,B,A,O_inv,A_inv,S1,B_set,S0,
VLG input B_inv,B,A,O_inv,A_inv,S1,B_set,S0;
VLG output O0;
VLG wire w2,w3,w5,w6,w7,w8,w11,w13;
VLG wire w17,w20,w21,w22;
VLG tgmux21 #(2) TgMux21_1(w5,w2,w3,B_inv);
VLG not #(1) inv_2(w13,A);
VLG not #(1) inv_3(w3,w2);
VLG tgmux21 #(2) TgMux21_4(w2,B,vdd,B_set);
VLG tgmux21 #(2) TgMux21_5(w17,A,w13,A_inv);
VLG xor #(3) xor2_6(w7,w17,w5);
VLG nand #(3) nand2_7(w6,w5,w17);
VLG nor #(2) nor2_8(w8,w17,w5);
VLG tgmux21 #(2) TgMux21_9(O0,w11,w20,O_inv);
VLG not #(1) inv_10(w20,w11);
VLG mux #(5) mux_11(w21,w6,w8,S0);
VLG mux #(5) mux_12(w22,w6,w7,S0);
VLG mux #(6) mux_13(w11,w22,w21,S1);
VLG endmodule
FSYM
SYM  #1bitaluapprfile
BB(50,575,90,675)
TITLE 60 568  #1bitaluacc 
MODEL 6000
PROP                                                                                                                                    
REC(55,580,30,90,r)
VIS 5
PIN(50,665,0.000,0.000)s1
PIN(50,655,0.000,0.000)S0
PIN(50,635,0.000,0.000)Cin
PIN(50,625,0.000,0.000)Bsel
PIN(50,585,0.000,0.000)A
PIN(50,605,0.000,0.000)B
PIN(50,615,0.000,0.000)Binv
PIN(50,595,0.000,0.000)Ainv
PIN(50,645,0.000,0.000)O_inv
PIN(90,595,0.005,0.003)output
PIN(90,585,0.005,0.003)Cout
LIG(50,665,55,665)
LIG(50,655,55,655)
LIG(50,635,55,635)
LIG(50,625,55,625)
LIG(50,585,55,585)
LIG(50,605,55,605)
LIG(50,615,55,615)
LIG(50,595,55,595)
LIG(50,645,55,645)
LIG(85,595,90,595)
LIG(85,585,90,585)
LIG(55,580,55,670)
LIG(55,580,85,580)
LIG(85,580,85,670)
LIG(85,670,55,670)
VLG module 1bitaluapprfile( s1,S0,Cin,Bsel,A,B,Binv,Ainv,
VLG O_inv,output,Cout);
VLG input s1,S0,Cin,Bsel,A,B,Binv,Ainv;
VLG input O_inv;
VLG output output,Cout;
VLG wire w10,w11,w12,w13,w14,w15,w16,w17;
VLG wire w19,w21,w22,w24,w25;
VLG tgmux21 #(2) TgMux21_1(w10,B,vdd,Bsel);
VLG not #(1) inv_2(w11,w10);
VLG not #(1) inv_3(w12,A);
VLG tgmux21 #(2) TgMux21_4(w19,w10,w11,Binv);
VLG tgmux21 #(2) TgMux21_5(w21,A,w12,Ainv);
VLG xor #(2) xor2_6(w13,Cin,w14);
VLG xor #(2) xor2_7(w14,w21,w19);
VLG nand #(2) nand2_8(w15,w19,w21);
VLG nor #(2) nor2_9(w16,w21,w19);
VLG tgmux21 #(1) TgMux21_10(output,w17,w22,O_inv);
VLG not #(1) inv_11(w22,w17);
VLG tgmux21 #(1) TgMux21_12(Cout,w16,w15,Cin);
VLG mux #(6) mux_13(w24,w15,w16,S0);
VLG mux #(6) mux_14(w25,w13,w14,S0);
VLG mux #(6) mux_15(w17,w25,w24,s1);
VLG endmodule
FSYM
SYM  #button
BB(-39,496,-30,504)
TITLE -35 500  #B6
MODEL 59
PROP                                                                                                                                    
REC(-38,497,6,6,r)
VIS 1
PIN(-30,500,0.000,0.000)B6
LIG(-31,500,-30,500)
LIG(-39,504,-39,496)
LIG(-31,504,-39,504)
LIG(-31,496,-31,504)
LIG(-39,496,-31,496)
LIG(-38,503,-38,497)
LIG(-32,503,-38,503)
LIG(-32,497,-32,503)
LIG(-38,497,-32,497)
FSYM
SYM  #1bitaluapprfile
BB(50,470,90,570)
TITLE 60 463  #1bitaluacc 
MODEL 6000
PROP                                                                                                                                    
REC(55,475,30,90,r)
VIS 5
PIN(50,560,0.000,0.000)s1
PIN(50,550,0.000,0.000)S0
PIN(50,530,0.000,0.000)Cin
PIN(50,520,0.000,0.000)Bsel
PIN(50,480,0.000,0.000)A
PIN(50,500,0.000,0.000)B
PIN(50,510,0.000,0.000)Binv
PIN(50,490,0.000,0.000)Ainv
PIN(50,540,0.000,0.000)O_inv
PIN(90,490,0.005,0.003)output
PIN(90,480,0.005,0.004)Cout
LIG(50,560,55,560)
LIG(50,550,55,550)
LIG(50,530,55,530)
LIG(50,520,55,520)
LIG(50,480,55,480)
LIG(50,500,55,500)
LIG(50,510,55,510)
LIG(50,490,55,490)
LIG(50,540,55,540)
LIG(85,490,90,490)
LIG(85,480,90,480)
LIG(55,475,55,565)
LIG(55,475,85,475)
LIG(85,475,85,565)
LIG(85,565,55,565)
VLG module 1bitaluapprfile( s1,S0,Cin,Bsel,A,B,Binv,Ainv,
VLG O_inv,output,Cout);
VLG input s1,S0,Cin,Bsel,A,B,Binv,Ainv;
VLG input O_inv;
VLG output output,Cout;
VLG wire w10,w11,w12,w13,w14,w15,w16,w17;
VLG wire w19,w21,w22,w24,w25;
VLG tgmux21 #(2) TgMux21_1(w10,B,vdd,Bsel);
VLG not #(1) inv_2(w11,w10);
VLG not #(1) inv_3(w12,A);
VLG tgmux21 #(2) TgMux21_4(w19,w10,w11,Binv);
VLG tgmux21 #(2) TgMux21_5(w21,A,w12,Ainv);
VLG xor #(2) xor2_6(w13,Cin,w14);
VLG xor #(2) xor2_7(w14,w21,w19);
VLG nand #(2) nand2_8(w15,w19,w21);
VLG nor #(2) nor2_9(w16,w21,w19);
VLG tgmux21 #(1) TgMux21_10(output,w17,w22,O_inv);
VLG not #(1) inv_11(w22,w17);
VLG tgmux21 #(1) TgMux21_12(Cout,w16,w15,Cin);
VLG mux #(6) mux_13(w24,w15,w16,S0);
VLG mux #(6) mux_14(w25,w13,w14,S0);
VLG mux #(6) mux_15(w17,w25,w24,s1);
VLG endmodule
FSYM
SYM  #1bitaluapprfile
BB(50,370,90,470)
TITLE 60 363  #1bitaluacc 
MODEL 6000
PROP                                                                                                                                    
REC(55,375,30,90,r)
VIS 5
PIN(50,460,0.000,0.000)s1
PIN(50,450,0.000,0.000)S0
PIN(50,430,0.000,0.000)Cin
PIN(50,420,0.000,0.000)Bsel
PIN(50,380,0.000,0.000)A
PIN(50,400,0.000,0.000)B
PIN(50,410,0.000,0.000)Binv
PIN(50,390,0.000,0.000)Ainv
PIN(50,440,0.000,0.000)O_inv
PIN(90,390,0.005,0.003)output
PIN(90,380,0.005,0.004)Cout
LIG(50,460,55,460)
LIG(50,450,55,450)
LIG(50,430,55,430)
LIG(50,420,55,420)
LIG(50,380,55,380)
LIG(50,400,55,400)
LIG(50,410,55,410)
LIG(50,390,55,390)
LIG(50,440,55,440)
LIG(85,390,90,390)
LIG(85,380,90,380)
LIG(55,375,55,465)
LIG(55,375,85,375)
LIG(85,375,85,465)
LIG(85,465,55,465)
VLG module 1bitaluapprfile( s1,S0,Cin,Bsel,A,B,Binv,Ainv,
VLG O_inv,output,Cout);
VLG input s1,S0,Cin,Bsel,A,B,Binv,Ainv;
VLG input O_inv;
VLG output output,Cout;
VLG wire w10,w11,w12,w13,w14,w15,w16,w17;
VLG wire w19,w21,w22,w24,w25;
VLG tgmux21 #(2) TgMux21_1(w10,B,vdd,Bsel);
VLG not #(1) inv_2(w11,w10);
VLG not #(1) inv_3(w12,A);
VLG tgmux21 #(2) TgMux21_4(w19,w10,w11,Binv);
VLG tgmux21 #(2) TgMux21_5(w21,A,w12,Ainv);
VLG xor #(2) xor2_6(w13,Cin,w14);
VLG xor #(2) xor2_7(w14,w21,w19);
VLG nand #(2) nand2_8(w15,w19,w21);
VLG nor #(2) nor2_9(w16,w21,w19);
VLG tgmux21 #(1) TgMux21_10(output,w17,w22,O_inv);
VLG not #(1) inv_11(w22,w17);
VLG tgmux21 #(1) TgMux21_12(Cout,w16,w15,Cin);
VLG mux #(6) mux_13(w24,w15,w16,S0);
VLG mux #(6) mux_14(w25,w13,w14,S0);
VLG mux #(6) mux_15(w17,w25,w24,s1);
VLG endmodule
FSYM
SYM  #light
BB(123,665,129,679)
TITLE 125 679  #Carry flag
MODEL 49
PROP                                                                                                                                    
REC(124,666,4,4,r)
VIS 1
PIN(125,680,0.000,0.000)Carry flag
LIG(128,671,128,666)
LIG(128,666,127,665)
LIG(124,666,124,671)
LIG(127,676,127,673)
LIG(126,676,129,676)
LIG(126,678,128,676)
LIG(127,678,129,676)
LIG(123,673,129,673)
LIG(125,673,125,680)
LIG(123,671,123,673)
LIG(129,671,123,671)
LIG(129,673,129,671)
LIG(125,665,124,666)
LIG(127,665,125,665)
FSYM
SYM  #light
BB(123,375,129,389)
TITLE 125 389  #O_5
MODEL 49
PROP                                                                                                                                    
REC(124,376,4,4,r)
VIS 1
PIN(125,390,0.000,0.000)O_5
LIG(128,381,128,376)
LIG(128,376,127,375)
LIG(124,376,124,381)
LIG(127,386,127,383)
LIG(126,386,129,386)
LIG(126,388,128,386)
LIG(127,388,129,386)
LIG(123,383,129,383)
LIG(125,383,125,390)
LIG(123,381,123,383)
LIG(129,381,123,381)
LIG(129,383,129,381)
LIG(125,375,124,376)
LIG(127,375,125,375)
FSYM
SYM  #button
BB(-39,476,-30,484)
TITLE -35 480  #A6
MODEL 59
PROP                                                                                                                                    
REC(-38,477,6,6,r)
VIS 1
PIN(-30,480,0.000,0.000)A6
LIG(-31,480,-30,480)
LIG(-39,484,-39,476)
LIG(-31,484,-39,484)
LIG(-31,476,-31,484)
LIG(-39,476,-31,476)
LIG(-38,483,-38,477)
LIG(-32,483,-38,483)
LIG(-32,477,-32,483)
LIG(-38,477,-32,477)
FSYM
SYM  #button
BB(-39,396,-30,404)
TITLE -35 400  #B5
MODEL 59
PROP                                                                                                                                    
REC(-38,397,6,6,r)
VIS 1
PIN(-30,400,0.000,0.000)B5
LIG(-31,400,-30,400)
LIG(-39,404,-39,396)
LIG(-31,404,-39,404)
LIG(-31,396,-31,404)
LIG(-39,396,-31,396)
LIG(-38,403,-38,397)
LIG(-32,403,-38,403)
LIG(-32,397,-32,403)
LIG(-38,397,-32,397)
FSYM
SYM  #button
BB(56,-104,64,-95)
TITLE 60 -100  #S0
MODEL 59
PROP                                                                                                                                    
REC(57,-103,6,6,r)
VIS 1
PIN(60,-95,0.000,0.000)S0
LIG(60,-96,60,-95)
LIG(56,-104,64,-104)
LIG(56,-96,56,-104)
LIG(64,-96,56,-96)
LIG(64,-104,64,-96)
LIG(57,-103,63,-103)
LIG(57,-97,57,-103)
LIG(63,-97,57,-97)
LIG(63,-103,63,-97)
FSYM
SYM  #button
BB(66,-104,74,-95)
TITLE 70 -100  #S1
MODEL 59
PROP                                                                                                                                    
REC(67,-103,6,6,r)
VIS 1
PIN(70,-95,0.000,0.000)S1
LIG(70,-96,70,-95)
LIG(66,-104,74,-104)
LIG(66,-96,66,-104)
LIG(74,-96,66,-96)
LIG(74,-104,74,-96)
LIG(67,-103,73,-103)
LIG(67,-97,67,-103)
LIG(73,-97,67,-97)
LIG(73,-103,73,-97)
FSYM
SYM  #button
BB(-39,376,-30,384)
TITLE -35 380  #A5
MODEL 59
PROP                                                                                                                                    
REC(-38,377,6,6,r)
VIS 1
PIN(-30,380,0.000,0.000)A5
LIG(-31,380,-30,380)
LIG(-39,384,-39,376)
LIG(-31,384,-39,384)
LIG(-31,376,-31,384)
LIG(-39,376,-31,376)
LIG(-38,383,-38,377)
LIG(-32,383,-38,383)
LIG(-32,377,-32,383)
LIG(-38,377,-32,377)
FSYM
SYM  #button
BB(36,-104,44,-95)
TITLE 40 -100  #O_inv
MODEL 59
PROP                                                                                                                                    
REC(37,-103,6,6,r)
VIS 1
PIN(40,-95,0.000,0.000)O_inv
LIG(40,-96,40,-95)
LIG(36,-104,44,-104)
LIG(36,-96,36,-104)
LIG(44,-96,36,-96)
LIG(44,-104,44,-96)
LIG(37,-103,43,-103)
LIG(37,-97,37,-103)
LIG(43,-97,37,-97)
LIG(43,-103,43,-97)
FSYM
SYM  #button
BB(-39,306,-30,314)
TITLE -35 310  #B4
MODEL 59
PROP                                                                                                                                    
REC(-38,307,6,6,r)
VIS 1
PIN(-30,310,0.000,0.000)B4
LIG(-31,310,-30,310)
LIG(-39,314,-39,306)
LIG(-31,314,-39,314)
LIG(-31,306,-31,314)
LIG(-39,306,-31,306)
LIG(-38,313,-38,307)
LIG(-32,313,-38,313)
LIG(-32,307,-32,313)
LIG(-38,307,-32,307)
FSYM
SYM  #button
BB(21,-104,29,-95)
TITLE 25 -100  #B_set
MODEL 59
PROP                                                                                                                                    
REC(22,-103,6,6,r)
VIS 1
PIN(25,-95,0.000,0.000)B_set
LIG(25,-96,25,-95)
LIG(21,-104,29,-104)
LIG(21,-96,21,-104)
LIG(29,-96,21,-96)
LIG(29,-104,29,-96)
LIG(22,-103,28,-103)
LIG(22,-97,22,-103)
LIG(28,-97,22,-97)
LIG(28,-103,28,-97)
FSYM
SYM  #button
BB(-39,286,-30,294)
TITLE -35 290  #A4
MODEL 59
PROP                                                                                                                                    
REC(-38,287,6,6,r)
VIS 1
PIN(-30,290,0.000,0.000)A4
LIG(-31,290,-30,290)
LIG(-39,294,-39,286)
LIG(-31,294,-39,294)
LIG(-31,286,-31,294)
LIG(-39,286,-31,286)
LIG(-38,293,-38,287)
LIG(-32,293,-38,293)
LIG(-32,287,-32,293)
LIG(-38,287,-32,287)
FSYM
SYM  #button
BB(-39,206,-30,214)
TITLE -35 210  #B3
MODEL 59
PROP                                                                                                                                    
REC(-38,207,6,6,r)
VIS 1
PIN(-30,210,0.000,0.000)B3
LIG(-31,210,-30,210)
LIG(-39,214,-39,206)
LIG(-31,214,-39,214)
LIG(-31,206,-31,214)
LIG(-39,206,-31,206)
LIG(-38,213,-38,207)
LIG(-32,213,-38,213)
LIG(-32,207,-32,213)
LIG(-38,207,-32,207)
FSYM
SYM  #button
BB(6,-104,14,-95)
TITLE 10 -100  #B_inv
MODEL 59
PROP                                                                                                                                    
REC(7,-103,6,6,r)
VIS 1
PIN(10,-95,0.000,0.000)B_inv
LIG(10,-96,10,-95)
LIG(6,-104,14,-104)
LIG(6,-96,6,-104)
LIG(14,-96,6,-96)
LIG(14,-104,14,-96)
LIG(7,-103,13,-103)
LIG(7,-97,7,-103)
LIG(13,-97,7,-97)
LIG(13,-103,13,-97)
FSYM
SYM  #button
BB(-9,-104,-1,-95)
TITLE -5 -100  #A_inv
MODEL 59
PROP                                                                                                                                    
REC(-8,-103,6,6,r)
VIS 1
PIN(-5,-95,0.000,0.000)A_inv
LIG(-5,-96,-5,-95)
LIG(-9,-104,-1,-104)
LIG(-9,-96,-9,-104)
LIG(-1,-96,-9,-96)
LIG(-1,-104,-1,-96)
LIG(-8,-103,-2,-103)
LIG(-8,-97,-8,-103)
LIG(-2,-97,-8,-97)
LIG(-2,-103,-2,-97)
FSYM
SYM  #button
BB(-39,186,-30,194)
TITLE -35 190  #A3
MODEL 59
PROP                                                                                                                                    
REC(-38,187,6,6,r)
VIS 1
PIN(-30,190,0.000,0.000)A3
LIG(-31,190,-30,190)
LIG(-39,194,-39,186)
LIG(-31,194,-39,194)
LIG(-31,186,-31,194)
LIG(-39,186,-31,186)
LIG(-38,193,-38,187)
LIG(-32,193,-38,193)
LIG(-32,187,-32,193)
LIG(-38,187,-32,187)
FSYM
SYM  #button
BB(-39,116,-30,124)
TITLE -35 120  #B2
MODEL 59
PROP                                                                                                                                    
REC(-38,117,6,6,r)
VIS 1
PIN(-30,120,0.000,0.000)B2
LIG(-31,120,-30,120)
LIG(-39,124,-39,116)
LIG(-31,124,-39,124)
LIG(-31,116,-31,124)
LIG(-39,116,-31,116)
LIG(-38,123,-38,117)
LIG(-32,123,-38,123)
LIG(-32,117,-32,123)
LIG(-38,117,-32,117)
FSYM
SYM  #button
BB(-39,96,-30,104)
TITLE -35 100  #A2
MODEL 59
PROP                                                                                                                                    
REC(-38,97,6,6,r)
VIS 1
PIN(-30,100,0.000,0.000)A2
LIG(-31,100,-30,100)
LIG(-39,104,-39,96)
LIG(-31,104,-39,104)
LIG(-31,96,-31,104)
LIG(-39,96,-31,96)
LIG(-38,103,-38,97)
LIG(-32,103,-38,103)
LIG(-32,97,-32,103)
LIG(-38,97,-32,97)
FSYM
SYM  #button
BB(-39,26,-30,34)
TITLE -35 30  #B1
MODEL 59
PROP                                                                                                                                    
REC(-38,27,6,6,r)
VIS 1
PIN(-30,30,0.000,0.000)B1
LIG(-31,30,-30,30)
LIG(-39,34,-39,26)
LIG(-31,34,-39,34)
LIG(-31,26,-31,34)
LIG(-39,26,-31,26)
LIG(-38,33,-38,27)
LIG(-32,33,-38,33)
LIG(-32,27,-32,33)
LIG(-38,27,-32,27)
FSYM
SYM  #button
BB(-39,6,-30,14)
TITLE -35 10  #A1
MODEL 59
PROP                                                                                                                                    
REC(-38,7,6,6,r)
VIS 1
PIN(-30,10,0.000,0.000)A1
LIG(-31,10,-30,10)
LIG(-39,14,-39,6)
LIG(-31,14,-39,14)
LIG(-31,6,-31,14)
LIG(-39,6,-31,6)
LIG(-38,13,-38,7)
LIG(-32,13,-38,13)
LIG(-32,7,-32,13)
LIG(-38,7,-32,7)
FSYM
SYM  #button
BB(-39,-84,-30,-76)
TITLE -35 -80  #A0
MODEL 59
PROP                                                                                                                                    
REC(-38,-83,6,6,r)
VIS 1
PIN(-30,-80,0.000,0.000)A0
LIG(-31,-80,-30,-80)
LIG(-39,-76,-39,-84)
LIG(-31,-76,-39,-76)
LIG(-31,-84,-31,-76)
LIG(-39,-84,-31,-84)
LIG(-38,-77,-38,-83)
LIG(-32,-77,-38,-77)
LIG(-32,-83,-32,-77)
LIG(-38,-83,-32,-83)
FSYM
SYM  #button
BB(-39,-64,-30,-56)
TITLE -35 -60  #B0
MODEL 59
PROP                                                                                                                                    
REC(-38,-63,6,6,r)
VIS 1
PIN(-30,-60,0.000,0.000)B0
LIG(-31,-60,-30,-60)
LIG(-39,-56,-39,-64)
LIG(-31,-56,-39,-56)
LIG(-31,-64,-31,-56)
LIG(-39,-64,-31,-64)
LIG(-38,-57,-38,-63)
LIG(-32,-57,-38,-57)
LIG(-32,-63,-32,-57)
LIG(-38,-63,-32,-63)
FSYM
SYM  #light
BB(113,175,119,189)
TITLE 115 189  #O_3
MODEL 49
PROP                                                                                                                                    
REC(114,176,4,4,r)
VIS 1
PIN(115,190,0.000,0.000)O_3
LIG(118,181,118,176)
LIG(118,176,117,175)
LIG(114,176,114,181)
LIG(117,186,117,183)
LIG(116,186,119,186)
LIG(116,188,118,186)
LIG(117,188,119,186)
LIG(113,183,119,183)
LIG(115,183,115,190)
LIG(113,181,113,183)
LIG(119,181,113,181)
LIG(119,183,119,181)
LIG(115,175,114,176)
LIG(117,175,115,175)
FSYM
SYM  #light
BB(113,85,119,99)
TITLE 115 99  #O_2
MODEL 49
PROP                                                                                                                                    
REC(114,86,4,4,r)
VIS 1
PIN(115,100,0.000,0.000)O_2
LIG(118,91,118,86)
LIG(118,86,117,85)
LIG(114,86,114,91)
LIG(117,96,117,93)
LIG(116,96,119,96)
LIG(116,98,118,96)
LIG(117,98,119,96)
LIG(113,93,119,93)
LIG(115,93,115,100)
LIG(113,91,113,93)
LIG(119,91,113,91)
LIG(119,93,119,91)
LIG(115,85,114,86)
LIG(117,85,115,85)
FSYM
SYM  #light
BB(113,-5,119,9)
TITLE 115 9  #O_1
MODEL 49
PROP                                                                                                                                    
REC(114,-4,4,4,r)
VIS 1
PIN(115,10,0.000,0.000)O_1
LIG(118,1,118,-4)
LIG(118,-4,117,-5)
LIG(114,-4,114,1)
LIG(117,6,117,3)
LIG(116,6,119,6)
LIG(116,8,118,6)
LIG(117,8,119,6)
LIG(113,3,119,3)
LIG(115,3,115,10)
LIG(113,1,113,3)
LIG(119,1,113,1)
LIG(119,3,119,1)
LIG(115,-5,114,-4)
LIG(117,-5,115,-5)
FSYM
SYM  #light
BB(113,-95,119,-81)
TITLE 115 -81  #O_0
MODEL 49
PROP                                                                                                                                    
REC(114,-94,4,4,r)
VIS 1
PIN(115,-80,0.000,0.000)O_0
LIG(118,-89,118,-94)
LIG(118,-94,117,-95)
LIG(114,-94,114,-89)
LIG(117,-84,117,-87)
LIG(116,-84,119,-84)
LIG(116,-82,118,-84)
LIG(117,-82,119,-84)
LIG(113,-87,119,-87)
LIG(115,-87,115,-80)
LIG(113,-89,113,-87)
LIG(119,-89,113,-89)
LIG(119,-87,119,-89)
LIG(115,-95,114,-94)
LIG(117,-95,115,-95)
FSYM
SYM  #light
BB(123,580,129,594)
TITLE 125 594  #O_7
MODEL 49
PROP                                                                                                                                    
REC(124,581,4,4,r)
VIS 1
PIN(125,595,0.000,0.000)O_7
LIG(128,586,128,581)
LIG(128,581,127,580)
LIG(124,581,124,586)
LIG(127,591,127,588)
LIG(126,591,129,591)
LIG(126,593,128,591)
LIG(127,593,129,591)
LIG(123,588,129,588)
LIG(125,588,125,595)
LIG(123,586,123,588)
LIG(129,586,123,586)
LIG(129,588,129,586)
LIG(125,580,124,581)
LIG(127,580,125,580)
FSYM
SYM  #light
BB(128,285,134,299)
TITLE 130 299  #O_4
MODEL 49
PROP                                                                                                                                    
REC(129,286,4,4,r)
VIS 1
PIN(130,300,0.000,0.000)O_4
LIG(133,291,133,286)
LIG(133,286,132,285)
LIG(129,286,129,291)
LIG(132,296,132,293)
LIG(131,296,134,296)
LIG(131,298,133,296)
LIG(132,298,134,296)
LIG(128,293,134,293)
LIG(130,293,130,300)
LIG(128,291,128,293)
LIG(134,291,128,291)
LIG(134,293,134,291)
LIG(130,285,129,286)
LIG(132,285,130,285)
FSYM
SYM  #light
BB(123,475,129,489)
TITLE 125 489  #O_6
MODEL 49
PROP                                                                                                                                    
REC(124,476,4,4,r)
VIS 1
PIN(125,490,0.000,0.000)O_6
LIG(128,481,128,476)
LIG(128,476,127,475)
LIG(124,476,124,481)
LIG(127,486,127,483)
LIG(126,486,129,486)
LIG(126,488,128,486)
LIG(127,488,129,486)
LIG(123,483,129,483)
LIG(125,483,125,490)
LIG(123,481,123,483)
LIG(129,481,123,481)
LIG(129,483,129,481)
LIG(125,475,124,476)
LIG(127,475,125,475)
FSYM
SYM  #lsbFORRIPPLECARRY
BB(55,280,80,370)
TITLE 65 273  #lsbFORRIPPLECARRY
MODEL 6000
PROP                                                                                                                                    
REC(60,285,15,80,r)
VIS 5
PIN(55,340,0.000,0.000)oinv
PIN(55,360,0.000,0.000)s1
PIN(55,350,0.000,0.000)s0
PIN(55,320,0.000,0.000)binv
PIN(55,300,0.000,0.000)ainv
PIN(55,310,0.000,0.000)B
PIN(55,290,0.000,0.000)A
PIN(55,330,0.000,0.000)Bsel
PIN(80,290,0.005,0.006)cout
PIN(80,300,0.005,0.003)Output
LIG(55,340,60,340)
LIG(55,360,60,360)
LIG(55,350,60,350)
LIG(55,320,60,320)
LIG(55,300,60,300)
LIG(55,310,60,310)
LIG(55,290,60,290)
LIG(55,330,60,330)
LIG(75,290,80,290)
LIG(75,300,80,300)
LIG(60,285,60,365)
LIG(60,285,75,285)
LIG(75,285,75,365)
LIG(75,365,60,365)
VLG module lsbFORRIPPLECARRY( oinv,s1,s0,binv,ainv,B,A,Bsel,
VLG cout,Output);
VLG input oinv,s1,s0,binv,ainv,B,A,Bsel;
VLG output cout,Output;
VLG wire w8,w9,w10,w13,w14,w15,w16,w17;
VLG wire w20,w21,w22;
VLG tgmux21 #(2) TgMux21_1(w13,B,vdd,Bsel);
VLG not #(1) inv_2(w14,w13);
VLG nand #(2) nand2_3(w9,w15,w16);
VLG nor #(3) nor2_4(cout,w16,w15);
VLG tgmux21 #(2) TgMux21_5(Output,w10,w17,oinv);
VLG not #(1) inv_6(w17,w10);
VLG tgmux21 #(2) TgMux21_7(w15,w13,w14,binv);
VLG not #(1) inv_8(w20,A);
VLG xor #(4) xor2_9(w8,w16,w15);
VLG tgmux21 #(2) TgMux21_10(w16,A,w20,ainv);
VLG mux #(5) mux_11(w21,w9,cout,s0);
VLG mux #(5) mux_12(w22,w8,w8,s0);
VLG mux #(6) mux_13(w10,w22,w21,s1);
VLG endmodule
FSYM
CNC(60 -20)
CNC(70 -10)
CNC(60 70)
CNC(70 80)
CNC(60 160)
CNC(70 170)
CNC(60 250)
CNC(70 260)
CNC(40 540)
CNC(70 360)
CNC(60 450)
CNC(70 460)
CNC(60 550)
CNC(70 560)
CNC(60 350)
CNC(40 -30)
CNC(25 -40)
CNC(10 -50)
CNC(-5 -70)
CNC(40 60)
CNC(25 50)
CNC(10 40)
CNC(-5 20)
CNC(40 150)
CNC(25 140)
CNC(10 130)
CNC(-5 110)
CNC(40 240)
CNC(25 230)
CNC(10 220)
CNC(-5 200)
CNC(40 340)
CNC(25 330)
CNC(10 320)
CNC(-5 300)
CNC(40 440)
CNC(25 420)
CNC(10 410)
CNC(-5 390)
CNC(-5 490)
CNC(10 510)
CNC(25 520)
LIG(95,680,125,680)
LIG(70,-95,70,-10)
LIG(50,-10,70,-10)
LIG(95,585,95,680)
LIG(60,-95,60,-20)
LIG(50,-20,60,-20)
LIG(50,655,60,655)
LIG(50,665,70,665)
LIG(50,70,60,70)
LIG(60,-20,60,70)
LIG(90,585,95,585)
LIG(50,80,70,80)
LIG(70,-10,70,80)
LIG(50,635,100,635)
LIG(50,160,60,160)
LIG(60,70,60,160)
LIG(100,480,100,635)
LIG(50,170,70,170)
LIG(70,80,70,170)
LIG(90,480,100,480)
LIG(50,250,60,250)
LIG(60,160,60,250)
LIG(90,490,125,490)
LIG(50,260,70,260)
LIG(70,170,70,260)
LIG(90,595,125,595)
LIG(50,530,95,530)
LIG(95,380,95,530)
LIG(90,380,95,380)
LIG(90,390,125,390)
LIG(80,300,130,300)
LIG(80,290,100,290)
LIG(50,450,60,450)
LIG(100,430,100,290)
LIG(50,430,100,430)
LIG(50,460,70,460)
LIG(70,360,70,460)
LIG(70,260,70,360)
LIG(50,550,60,550)
LIG(60,450,60,550)
LIG(60,550,60,655)
LIG(50,560,70,560)
LIG(70,460,70,560)
LIG(70,560,70,665)
LIG(55,360,70,360)
LIG(60,350,60,450)
LIG(60,250,60,350)
LIG(55,350,60,350)
LIG(-5,490,-5,595)
LIG(-5,110,-5,200)
LIG(-30,-80,50,-80)
LIG(50,-60,-30,-60)
LIG(-30,10,50,10)
LIG(50,30,-30,30)
LIG(-30,100,50,100)
LIG(50,120,-30,120)
LIG(-30,190,50,190)
LIG(50,210,-30,210)
LIG(-30,290,55,290)
LIG(55,310,-30,310)
LIG(50,200,-5,200)
LIG(50,595,-5,595)
LIG(-30,380,50,380)
LIG(50,400,-30,400)
LIG(-30,480,50,480)
LIG(50,500,-30,500)
LIG(10,130,10,220)
LIG(50,220,10,220)
LIG(-30,585,50,585)
LIG(50,605,-30,605)
LIG(10,510,10,615)
LIG(25,140,25,230)
LIG(50,230,25,230)
LIG(50,615,10,615)
LIG(50,-30,40,-30)
LIG(40,-95,40,-30)
LIG(40,150,40,240)
LIG(50,-40,25,-40)
LIG(25,-95,25,-40)
LIG(50,240,40,240)
LIG(50,-50,10,-50)
LIG(10,-95,10,-50)
LIG(-5,20,-5,110)
LIG(50,-70,-5,-70)
LIG(-5,-95,-5,-70)
LIG(50,110,-5,110)
LIG(10,40,10,130)
LIG(50,130,10,130)
LIG(25,50,25,140)
LIG(50,140,25,140)
LIG(40,60,40,150)
LIG(50,150,40,150)
LIG(-5,-70,-5,20)
LIG(50,20,-5,20)
LIG(50,60,40,60)
LIG(40,-30,40,60)
LIG(10,-50,10,40)
LIG(50,50,25,50)
LIG(25,-40,25,50)
LIG(50,40,10,40)
LIG(25,625,50,625)
LIG(25,520,25,625)
LIG(40,645,50,645)
LIG(40,540,40,645)
LIG(40,440,40,540)
LIG(50,540,40,540)
LIG(25,420,25,520)
LIG(50,520,25,520)
LIG(55,340,40,340)
LIG(40,240,40,340)
LIG(10,410,10,510)
LIG(55,330,25,330)
LIG(25,230,25,330)
LIG(50,510,10,510)
LIG(55,320,10,320)
LIG(10,220,10,320)
LIG(-5,390,-5,490)
LIG(55,300,-5,300)
LIG(-5,200,-5,300)
LIG(50,490,-5,490)
LIG(-5,300,-5,390)
LIG(50,390,-5,390)
LIG(10,320,10,410)
LIG(50,410,10,410)
LIG(25,330,25,420)
LIG(50,420,25,420)
LIG(40,340,40,440)
LIG(50,440,40,440)
LIG(80,-80,115,-80)
LIG(80,10,115,10)
LIG(80,100,115,100)
LIG(80,190,115,190)
FFIG C:\Users\Acer\Desktop\Major Project\My files\APPROX\LOA\8 bit with LOA.sch
