/*
create or replace PACKAGE "J_A_EVA_T" as 

 PROCEDURE EVA_43(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2,c_teaor VARCHAR2,c_m003 VARCHAR2); --eva 43
 PROCEDURE EVA_71(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2, c_teaor varchar2, c_m003 VARCHAR2); -- EVA 71 KETTŐSÖK

 PROCEDURE KATA(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2,c_teaor varchar2,c_m003 VARCHAR2); --eva 71 kettősök kata
 PROCEDURE kiva(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2,c_teaor VARCHAR2,c_m003 VARCHAR2); --eva 71 kettősök kiva

end J_A_EVA_T;
*/


create or replace PACKAGE BODY "J_A_EVA_T" as

 v_j j_szekt_semamutatok;
 --v_k j_kettosok;

 p PAIR;

-- EVA 1043 (vagy EVA 43)
PROCEDURE EVA_43(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2, c_teaor VARCHAR2, c_m003 VARCHAR2) AS
 p PAIR;
 p_1221_koef NUMBER(15, 3);
 p_2_koef NUMBER(15, 3);
 v_temp NUMBER(15, 3);
BEGIN
p  :=  PAIR.INIT;
p_1221_koef := J_SELECT_T.EVA_P1221(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;
p_2_koef := J_SELECT_T.EVA_P2(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;

--v_arr1.EXTEND(226); -- ?          -- FELTOLTES: J_SZEKT_EVES_T.FELTOLT PROC. - ED 20170328
--v_arr2.EXTEND(226); -- ?
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j); 

--p11 kiszámítás
v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119); --v_arr1(1) := 'P_119'; v_arr2(1) := v_j.p_119;

--p111 kiszámítás
v_j.p_11111 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111); --v_arr1(2) := 'P_11111'; v_arr2(2) := v_j.p_11111;

v_j.p_11112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112); --v_arr1(3) := 'P_11112';v_arr2(3) := v_j.p_11112;
v_j.p_1111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111); --v_arr1(4) := 'P_1111';v_arr2(4) := v_j.p_1111;

v_j.p_1112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112); --v_arr1(5) := 'P_1112';v_arr2(5) := v_j.p_1112;
v_j.p_1113 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113); --v_arr1(6) := 'P_1113';v_arr2(6) := v_j.p_1113;
v_j.p_1114 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114); --v_arr1(7) := 'P_1114';v_arr2(7) := v_j.p_1114;
v_j.p_111 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111); --v_arr1(8) := 'P_111';v_arr2(8) := v_j.p_111;

--p112
v_j.p_1121 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121); --v_arr1(9) := 'P_1121';v_arr2(9) := v_j.p_1121;
v_j.p_1122 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122); --v_arr1(10) := 'P_1122';v_arr2(10) := v_j.p_1122;
v_j.p_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123); --v_arr1(11) := 'P_1123';v_arr2(11) := v_j.p_1123;
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                   J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112); --v_arr1(12) := 'P_112';v_arr2(12) := v_j.p_112;


--p113
v_j.p_1131 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131); --v_arr1(13) := 'P_1131';v_arr2(13) := v_j.p_1131;
v_j.p_1132 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132); --v_arr1(14) := 'P_1132';v_arr2(14) := v_j.p_1132;
v_j.p_113 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113); --v_arr1(15) := 'P_113';v_arr2(15) := v_j.p_113;

--p115-p116
v_j.p_1151 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151); --v_arr1(16) := 'P_1151';v_arr2(16) := v_j.p_1151;
v_j.p_1152 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152); --v_arr1(17) := 'P_1152';v_arr2(17) := v_j.p_1152;
v_j.p_115 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115); --v_arr1(18) := 'P_115';v_arr2(18) := v_j.p_115;

v_j.p_116 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116); --v_arr1(19) := 'P_116';v_arr2(19) := v_j.p_116;

v_j.p_11 := v_j.p_119 + v_j.p_112 + v_j.p_118;
                                   J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --v_arr1(20) := 'P_11';v_arr2(20) := v_j.p_11;


--p12 kiszámítás
v_j.p_1211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003,'PRCA108', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211); --v_arr1(25) := 'P_1211';v_arr2(25) := v_j.p_1211;
v_j.p_1212 := 0;  
                                   J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212); --v_arr1(26) := 'P_1212';v_arr2(26) := v_j.p_1212;

v_j.p_121 := v_j.p_1211 - v_j.p_1212;
                                   J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121); --v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;

v_j.p_1363 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003,'PRJA106', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);  --v_arr1(28) := 'P_1363';v_arr2(28) := v_j.p_1363;

v_j.p_1221 := (v_j.p_1211 - v_j.p_1363) * p_1221_koef;
              /*2015v:  koefficiens P.1221-hez: 50 millió Ft
                  nettó árbevétel alatti kettősök elábé/ért.nettó
                  árbev. aránya szakágazatonként (PFC0M092/PRCA103)*/
              /*2015e: koefficiens P.1221-hez: 50 millió Ft nettó árbevétel
                alatti kettősök elábé/ért.nettó 
                árbev. aránya szakágazatonként (PFC0M092/PFC0M103)*/
                                   J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221); --v_arr1(21) := 'P_1221';v_arr2(21) := v_j.p_1221;
v_j.p_1222 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); --v_arr1(22) := 'P_1222';v_arr2(22) := v_j.p_1222;
v_j.p_122 := v_j.p_1221;           J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);   --v_arr1(23) := 'P_122';v_arr2(23) := v_j.p_122;

v_j.p_12 := v_j.p_121 - v_j.p_122; 
                                   J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);  --v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;

--p13 kiszámítás

v_j.p_1361 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);  --v_arr1(29) := 'P_1361';v_arr2(29) := v_j.p_1361;
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);  --v_arr1(30) := 'P_1362';v_arr2(30) := v_j.p_1362;

v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);  --v_arr1(31) := 'P_1364';v_arr2(31) := v_j.p_1364;
v_j.p_1365 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);  --v_arr1(32) := 'P_1365';v_arr2(32) := v_j.p_1365;
v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);  --v_arr1(33) := 'P_1366';v_arr2(33) := v_j.p_1366;
v_j.p_1367 := 0;
                                   J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);  --v_arr1(34) := 'P_1367';v_arr2(34) := v_j.p_1367;

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 
             + v_j.p_1366 + v_j.p_1367;
                                   J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132);  --v_arr1(35) := 'P_132';v_arr2(35) := v_j.p_132; 

--v_j.p_1311 := 0;                 v_arr1(-4+62) := 'P_1311';v_arr2(-4+62) := v_j.p_1311;
v_j.p_1312 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);  --v_arr1(36) := 'P_1312';v_arr2(36) := v_j.p_1312;
v_j.p_131 := v_j.p_1312;           J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);  --v_arr1(37) := 'P_131';v_arr2(37) := v_j.p_131;

v_j.p_13 := v_j.p_132 - v_j.p_131; 
                                   J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);  --v_arr1(38) := 'P_13';v_arr2(38) := v_j.p_13;

--p14   --p16
v_j.p_14 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14); --v_arr1(39) := 'P_14';v_arr2(39) := v_j.p_14;
v_j.p_15 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15); --v_arr1(40) := 'P_15';v_arr2(40) := v_j.p_15;
v_j.p_16 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16); --v_arr1(41) := 'P_16';v_arr2(41) := v_j.p_16;
-- itt p.15, p.16 teljesen 0.

--P1
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1); --v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;
--P.21
v_j.p_21 := 0.21 * 0.44 * v_j.p_1;
            /*2015v: 0,21*0,44*P.1*/
            /*2015e: külön adat*/
                                   J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21); -- v_arr1(43) := 'P_21';v_arr2(43) := v_j.p_21;
--P.22
v_j.p_22 := 0.69 * 0.44 * v_j.p_1; 
                                   J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22); --v_arr1(44) := 'P_22';v_arr2(44) := v_j.p_22;
           /*2015v: 0,69*0,44*P.1*/
           /*2015e: külön adat*/
--P.23
v_j.p_2331 := 0.1 * 0.44 * v_j.p_1;
                                   J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331); --;v_arr1(45) := 'P_2331';v_arr2(45) := v_j.p_2331;
              /*2015v: 0,1*0,44*P.1*/
              /*2015e: külön adat*/

v_j.p_231 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);     --v_arr1(46) := 'P_231';v_arr2(46) := v_j.p_231;
v_j.p_232 := 0;/*KÜLÖN SZÁMÍÁS*/   J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);     --v_arr1(47) := 'P_232';v_arr2(47) := v_j.p_232;
v_j.p_2321 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);     --v_arr1(48) := 'P_2321';v_arr2(48) := v_j.p_2321;
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);     --v_arr1(49) := 'P_2322';v_arr2(49) := v_j.p_2322;

v_j.p_233 := v_j.p_2331 - v_j.p_231 - v_j.p_2321;
                                   J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);            --v_arr1(50) := 'P_233';v_arr2(50) := v_j.p_233;
v_j.p_23 := v_j.p_233;             J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);  --v_arr1(51) := 'P_23';v_arr2(51) := v_j.p_23;

--p24
v_j.p_24 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);    --v_arr1(52) := 'P_24';v_arr2(52) := v_j.p_24;

--p26
--v_j.p_261 := 0;                  v_arr1(-4+63) := 'P_261';v_arr2(-4+63) := v_j.p_261;
v_j.p_262 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);    --v_arr1(53) := 'P_262';v_arr2(53) := v_j.p_262;
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;             J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);    --v_arr1(54) := 'P_26';v_arr2(54) := v_j.p_26;

--p27
v_j.p_27 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);   --v_arr1(55) := 'P_27';v_arr2(55) := v_j.p_27;
v_j.p_28 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);   --v_arr1(56) := 'P_28';v_arr2(56) := v_j.p_28;

v_j.p_291 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);    --v_arr1(57) := 'P_291';v_arr2(57) := v_j.p_291;
v_j.p_292 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);    --v_arr1(58) := 'P_292';v_arr2(58) := v_j.p_292;
v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);    
            /*2015v: külön adat*/
v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                   J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);    --v_arr1(59) := 'P_29';v_arr2(59) := v_j.p_29;

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26
           + v_j.p_27 + v_j.p_28 + v_j.p_29;
--v_j.p_1* p_2_koef; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);      --v_arr1(60) := 'P_2';v_arr2(60) := v_j.p_2;
--b.1g kiszámítása
v_j.b_1g := v_j.p_1-v_j.p_2;       J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);      --v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;
v_j.K_1 := 0;                      J_SZEKT_EVES_T.FELTOLT('K_1', v_j.K_1);      --v_arr1(-4+66) := 'K_1';v_arr2(62) := v_j.k_1;
v_j.b_1n := v_j.b_1g-v_j.K_1;      J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);   --v_arr1(63) := 'B_1n';v_arr2(63) := v_j.b_1n;

--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);   --v_arr1(64) := 'D_2111';v_arr2(64) := v_j.d_2111;
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);   --v_arr1(65) := 'D_211';v_arr2(65) := v_j.d_211;

v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);  --v_arr1(66) := 'D_212';v_arr2(66) := v_j.d_212;

v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214D);  --v_arr1(67) := 'D_214D';v_arr2(67) := v_j.d_214d;
v_j.d_214F := v_j.p_1361;          J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);   --v_arr1(68) := 'D_214F';v_arr2(68) := v_j.d_214F;
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);  --v_arr1(69) := 'D_214G1';v_arr2(69) := v_j.d_214G1;
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);  --v_arr1(70) := 'D_214E';v_arr2(70) := v_j.d_214E;
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);  -- v_arr1(71) := 'D_214I73';v_arr2(71) := v_j.d_214I73;
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);  --v_arr1(72) := 'D_214I3';v_arr2(72) := v_j.d_214I3;
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);  --v_arr1(73) := 'D_214I';v_arr2(73) := v_j.d_214I;
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);  --v_arr1(74) := 'D_214BA';v_arr2(74) := v_j.d_214BA;

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E
             + v_j.d_214I73 + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA; 
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);  --v_arr1(75) := 'D_214';v_arr2(75) := v_j.d_214;
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                   J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);  --v_arr1(76) := 'D_21';v_arr2(76) := v_j.d_21;

--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);  --v_arr1(77) := 'D_312';v_arr2(77) := v_j.d_312;
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);  --v_arr1(78) := 'D_31922';v_arr2(78) := v_j.d_31922;
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);  --v_arr1(79) := 'D_3192';v_arr2(79) := v_j.d_3192;
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);  --v_arr1(80) := 'D_319';v_arr2(80) := v_j.d_319;
v_j.d_31 := v_j.d_319 + v_j.d_312; 
                                   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);  --v_arr1(81) := 'D_31';v_arr2(81) := v_j.d_31;

-- ------------D.1 kiszámítása

--d_111

v_temp := v_j.b_1g;
IF v_temp > 0 THEN
 v_j.d_1111 := v_temp;  
ELSE 
 v_j.d_1111 := 0;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111); --v_arr1(82) := 'D_1111';v_arr2(82) := v_j.d_1111;

v_j.d_11121 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);--v_arr1(83) := 'D_11121';v_arr2(83) := v_j.d_11121;
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);--v_arr1(84) := 'D_11124';v_arr2(84) := v_j.d_11124;

v_j.d_11123 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11123'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);--v_arr1(85) := 'D_11123';v_arr2(85) := v_j.d_11123;
v_j.d_11125 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11125'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);--v_arr1(86) := 'D_11125';v_arr2(86) := v_j.d_11125;
v_j.d_11126 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11126'); --ki volt kommentelve?!
                                   J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);--v_arr1(87) := 'D_11126';v_arr2(87) := v_j.d_11126;
v_j.d_11127 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);--v_arr1(88) := 'D_11127'; v_arr2(88) := v_j.d_11127;
v_j.d_11128 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);--v_arr1(89) := 'D_11128';v_arr2(89) := v_j.d_11128;
v_j.d_11129 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);--v_arr1(90) := 'D_11129';v_arr2(90) := v_j.d_11129;
v_j.d_11130 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11130'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);--v_arr1(91) := 'D_11130';v_arr2(91) := v_j.d_11130;

v_j.d_11131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);--v_arr1(214) := 'D_11131';v_arr2(214) := v_j.d_11131;

-- d.11124 bekerült: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;                                                        
                                   J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);--v_arr1(92) := 'D_1112';v_arr2(92) := v_j.d_1112;
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);--v_arr1(93) := 'D_111';v_arr2(93) := v_j.d_111;

--d112
v_j.d_1121 := v_j.p_16 * J_KONST_T.D_1121_TERM_SZORZO; -- 0.4641 volt 2017.04.27
--v_j.d_1121 := v_j.p_16 * 0.3525; -- 0.4641 volt 2017.04.27
                                   J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);--       v_arr1(94) := 'D_1121';v_arr2(94) := v_j.d_1121;
v_j.d_1122 := v_j.p_15;            J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);--v_arr1(95) := 'D_1122';v_arr2(95) := v_j.d_1122;
v_j.d_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);--v_arr1(96) := 'D_1123';v_arr2(96) := v_j.d_1123;
v_j.d_1124 := v_j.p_262;           J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);--v_arr1(97) := 'D_1124';v_arr2(97) := v_j.d_1124;
v_j.d_1125 := v_j.d_11127;         J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);--                     v_arr1(98) := 'D_1125';v_arr2(98) := v_j.d_1125;
v_j.d_1126 := v_j.d_11129;         J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);--                     v_arr1(99) := 'D_1126';v_arr2(99) := v_j.d_1126;
v_j.d_1127 := v_j.d_11130;         J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);--                     v_arr1(100) := 'D_1127';v_arr2(100) := v_j.d_1127;
v_j.d_1128 := v_j.d_11131;         J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);--                     v_arr1(215) := 'D_1128';v_arr2(215) := v_j.d_1128;
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124
             + v_j.d_1125 + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;                                                         
                                   J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);--                     v_arr1(208) := 'D_112';v_arr2(208) := v_j.d_112;

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112; 
                                   J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);--                     v_arr1(101) := 'D_11';v_arr2(101) := v_j.d_11;


--d121
v_j.d_1212 := 0;
                                   J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);--    v_arr1(102) := 'D_1212';v_arr2(102) := v_j.d_1212;
v_j.d_1211 := v_j.d_111 * 0.27;    J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);--   v_arr1(103) := 'D_1211';v_arr2(103) := v_j.d_1211;
v_j.d_1213 := v_j.d_11125;         J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);--                                               v_arr1(104) := 'D_1213';v_arr2(104) := v_j.d_1213;
v_j.d_1214 := v_j.d_11124;         J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);--                                               v_arr1(105) := 'D_1214';v_arr2(105) := v_j.d_1214;
v_j.d_1215 := v_j.d_11128;         J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);--                                               v_arr1(106) := 'D_1215';v_arr2(106) := v_j.d_1215;
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 
             + v_j.d_1215;  J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);            --   v_arr1(107) := 'D_121';v_arr2(107) := v_j.d_121;


--d122
v_j.d_1221 := v_j.d_11126;         J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221); --     v_arr1(-4+112) := 'D_1221';v_arr2(-4+112) := v_j.d_1221;
v_j.d_1222 := v_j.d_11123;         J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222); --     v_arr1(-4+113) := 'D_1222';v_arr2(-4+113) := v_j.d_1222;
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                   J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122); --     v_arr1(-4+114) := 'D_122';v_arr2(-4+114) := v_j.d_122;

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122; 
                                   J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12); --     v_arr1(-4+115) := 'D_12';v_arr2(-4+115) := v_j.d_12;

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;    J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1); --     v_arr1(-4+116) := 'D_1';v_arr2(-4+116) := v_j.d_1;

------------D.29

v_j.d_29C1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);--        v_arr1(-4+117) := 'D_29C1';v_arr2(-4+117) := v_j.d_29C1;
v_j.d_29C2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);--        v_arr1(-4+118) := 'D_29C2';v_arr2(-4+118) := v_j.d_29C2;
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);--        v_arr1(-4+213) := 'D_29C';v_arr2(-4+213) := v_j.d_29C;

v_j.d_29b1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);--        v_arr1(-4+119) := 'D_29B1';v_arr2(-4+119) := v_j.d_29b1;
v_j.d_29b3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);--        v_arr1(-4+120) := 'D_29B3';v_arr2(-4+120) := v_j.d_29b3;

v_j.d_29A11 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);--        v_arr1(-4+121) := 'D_29A11';v_arr2(-4+121) := v_j.d_29A11;
v_j.d_29A12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);--        v_arr1(-4+122) := 'D_29A12';v_arr2(-4+122) := v_j.d_29A12;
v_j.d_29A2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);--        v_arr1(-4+123) := 'D_29A2';v_arr2(-4+123) := v_j.d_29A2;
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;                           
                                   J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);--        v_arr1(-4+124) := 'D_29A';v_arr2(-4+124) := v_j.d_29A;
v_j.d_2953 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);--        v_arr1(-4+125) := 'D_2953';v_arr2(-4+125) := v_j.d_2953;
v_j.d_29E3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);--        v_arr1(216) := 'D_29E3';v_arr2(216) := v_j.d_29E3;

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 + v_j.d_29E3;                    
                                   J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);--        v_arr1(-4+126) := 'D_29';v_arr2(-4+126) := v_j.d_29;

--v_j.d_3912 := 0;                            v_arr1(-4+64) := 'D_3912';v_arr2(-4+64) := v_j.d_3912;
v_j.d_3911 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);--        v_arr1(-4+127) := 'D_3911';v_arr2(-4+127) := v_j.d_3911;
v_j.d_391 := v_j.d_3911;           J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);--        v_arr1(-4+128) := 'D_391';v_arr2(-4+128) := v_j.d_391;

v_j.d_39251 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);--        v_arr1(-4+129) := 'D_39251';v_arr2(-4+129) := v_j.d_39251;
--v_j.d_39254 := 0;                           v_arr1(-4+65) := 'D_39254';v_arr2(-4+65) := v_j.d_39254;
v_j.d_39253 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);--        v_arr1(-4+130) := 'D_39253';v_arr2(-4+130) := v_j.d_39253;
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                   J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);--     v_arr1(-4+131) := 'D_3925';v_arr2(-4+131) := v_j.d_3925;
v_j.d_392 := v_j.d_3925;           J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);--     v_arr1(-4+132) := 'D_392';v_arr2(-4+132) := v_j.d_392;

v_j.d_394 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);--     v_arr1(-4+133) := 'D_394';v_arr2(-4+133) := v_j.d_394;
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                   J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);--  v_arr1(-4+134) := 'D_39';v_arr2(-4+134) := v_j.d_39;

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;                                      
                                   J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);--     v_arr1(-4+135) := 'B_2g';v_arr2(-4+135) := v_j.b_2g;
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);--     v_arr1(-4+136) := 'B_2n';v_arr2(-4+136) := v_j.b_2n;

------------D.42-------
v_j.d_41211 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);--     v_arr1(-4+137) := 'D_41211';v_arr2(-4+137) := v_j.d_41211;
v_j.d_41212 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);--     v_arr1(-4+138) := 'D_41212';v_arr2(-4+138) := v_j.d_41212;

v_j.d_412131 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);--     v_arr1(-4+139) := 'D_412131';v_arr2(-4+139) := v_j.d_412131;
v_j.d_412132 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);  --   v_arr1(-4+140) := 'D_412132';v_arr2(-4+140) := v_j.d_412132;
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                   J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);--                                         v_arr1(-4+141) := 'D_41213';v_arr2(-4+141) := v_j.d_41213;
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);--   v_arr1(-4+142) := 'D_4121';v_arr2(-4+142) := v_j.d_4121;

v_j.d_41221 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);--   v_arr1(-4+143) := 'D_41221';v_arr2(-4+143) := v_j.d_41221;
v_j.d_41222 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);--   v_arr1(-4+144) := 'D_41222';v_arr2(-4+144) := v_j.d_41222;

v_j.d_412231 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);--   v_arr1(-4+145) := 'D_412231';v_arr2(-4+145) := v_j.d_412231;
v_j.d_412232 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);--   v_arr1(-4+146) := 'D_412232';v_arr2(-4+146) := v_j.d_412232;
v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                   J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);--   v_arr1(-4+147) := 'D_41223';v_arr2(-4+147) := v_j.d_41223;

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                   J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);--   v_arr1(-4+148) := 'D_4122';v_arr2(-4+148) := v_j.d_4122;
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                   J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);--   v_arr1(-4+149) := 'D_412';v_arr2(-4+149) := v_j.d_412;
--d41
v_j.d_413 := v_j.d_1123;           J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);--                                            v_arr1(-4+150) := 'D_413';v_arr2(-4+150) := v_j.d_413;
v_j.d_41 := v_j.d_412 + v_j.d_413; 
                                   J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);--                                            v_arr1(-4+151) := 'D_41';v_arr2(-4+151) := v_j.d_41;

--d42
v_j.d_421 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_421'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);--  v_arr1(-4+152) := 'D_421';v_arr2(-4+152) := v_j.d_421; 
v_j.d_4221 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4221'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);--  v_arr1(-4+153) := 'D_4221';v_arr2(-4+153) := v_j.d_4221;
v_j.d_4222 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4222'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);--  v_arr1(-4+154) := 'D_4222';v_arr2(-4+154) := v_j.d_4222;
v_j.d_4223 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4223'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);--  v_arr1(-4+155) := 'D_4223';v_arr2(-4+155) := v_j.d_4223;
v_j.d_4224 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4224'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);--  v_arr1(-4+156) := 'D_4224';v_arr2(-4+156) := v_j.d_4224;
v_j.d_4225 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4225'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                   J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);--  v_arr1(-4+157) := 'D_4225';v_arr2(-4+157) := v_j.d_4225;

v_j.d_4226 := 0;                                                                     
                                   J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);--   v_arr1(-4+158) := 'D_4226';v_arr2(-4+158) := v_j.d_4226;
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;  
                                   J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);--   v_arr1(-4+159) := 'D_422';v_arr2(-4+159) := v_j.d_422;

v_j.d_42 := v_j.d_421 - v_j.d_422;                                                     
                                   J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);--   v_arr1(-4+160) := 'D_42';v_arr2(-4+160) := v_j.d_42;

v_j.d_44131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);--     v_arr1(209) := 'D_44131';v_arr2(209) := v_j.d_44131; --217
v_j.d_44132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);--     v_arr1(210) := 'D_44132';v_arr2(210) := v_j.d_44132; --218
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                   J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);--     v_arr1(211) := 'D_4413';v_arr2(211) := v_j.d_4413;   --219
v_j.d_4412 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412); --     v_arr1(212) := 'D_4412';v_arr2(212) := v_j.d_4412;   --220
v_j.d_4411 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);--     v_arr1(213) := 'D_4411';v_arr2(213) := v_j.d_4411;   --221 - ez a sor nem volt!
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                   J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);--   v_arr1(214) := 'D_441';v_arr2(214) := v_j.d_441;     --221!!!



v_j.d_44231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);--    v_arr1(215) := 'D_44231';v_arr2(215) := v_j.d_44231; --217
v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);--    v_arr1(216) := 'D_44232';v_arr2(216) := v_j.d_44232; --218
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                   J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);--    v_arr1(217) := 'D_4423';v_arr2(217) := v_j.d_4423;   --219
v_j.d_4422 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);--    v_arr1(218) := 'D_4422';v_arr2(218) := v_j.d_4422;   --220
v_j.d_4421 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);--    v_arr1(219) := 'D_4421';v_arr2(219) := v_j.d_4421;   --221 - ez a sor nem volt!
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                   J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);--   v_arr1(220) := 'D_442';v_arr2(220) := v_j.d_442;     --221!!!



-----------------D.4---------------
v_j.d_431 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);--v_arr1(-4+161) := 'D_431';v_arr2(-4+161) := v_j.d_431;
v_j.d_432 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);--v_arr1(-4+162) := 'D_432';v_arr2(-4+162) := v_j.d_432;
v_j.d_43 := v_j.d_431 - v_j.d_432; 
                                   J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);--v_arr1(-4+163) := 'D_43';v_arr2(-4+163) := v_j.d_43;

v_j.d_44 := v_j.d_441 - v_j.d_442; 
                                   J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);--v_arr1(-4+164) := 'D_44';v_arr2(-4+164) := v_j.d_44;
v_j.d_45 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);--v_arr1(-4+165) := 'D_45';v_arr2(-4+165) := v_j.d_45;
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);-- v_arr1(-4+166) := 'D_46';v_arr2(-4+166) := v_j.d_46;
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);-- v_arr1(-4+167) := 'D_4';v_arr2(-4+167) := v_j.d_4;
---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44
            - v_j.d_45 - v_j.d_46;        
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g); -- v_arr1(-4+168) := 'B_4g';v_arr2(-4+168) := v_j.b_4g;
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);--  v_arr1(-4+169) := 'B_4n';v_arr2(-4+169) := v_j.b_4n;


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);--v_arr1(-4+170) := 'B_5g';v_arr2(-4+170) := v_j.b_5g;
v_j.b_5n := v_j.b_2n + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);-- v_arr1(-4+171) := 'B_5n';v_arr2(-4+171) := v_j.b_5n;


---------------D.5---------------
v_j.d_51B11 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);-- v_arr1(-4+172) := 'D_51B11';v_arr2(-4+172) := v_j.d_51B11;
v_j.d_51B12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);-- v_arr1(-4+173) := 'D_51B12';v_arr2(-4+173) := v_j.d_51B12;
v_j.d_51B13 := 0;/*Külön adat*/    J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);-- v_arr1(-4+174) := 'D_51B13';v_arr2(-4+174) := v_j.d_51B13;

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                   J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);-- v_arr1(-4+175) := 'D_5';v_arr2(-4+175) := v_j.d_5;
---------------D.6---------------

v_j.d_611 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);--    v_arr1(-4+181) := 'D_611';v_arr2(-4+181) := v_j.d_611;
v_j.d_612 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);--    v_arr1(-4+182) := 'D_612';v_arr2(-4+182) := v_j.d_612;
v_j.d_613 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);--    v_arr1(-4+176) := 'D_613';v_arr2(-4+176) := v_j.d_613;
v_j.d_614 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);--    v_arr1(222) := 'D_614';v_arr2(222) := v_j.d_614;
v_j.d_61SC := 0;                   J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);--    v_arr1(-4+177) := 'D_61SC';v_arr2(-4+177) := v_j.d_61SC;

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);--v_arr1(-4+186) := 'D_61';v_arr2(-4+186) := v_j.d_61;

v_j.d_621 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);--   v_arr1(-4+183) := 'D_621';v_arr2(-4+183) := v_j.d_621;
v_j.d_622 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);--   v_arr1(-4+184) := 'D_622';v_arr2(-4+184) := v_j.d_622;
v_j.d_623 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);--   v_arr1(-4+185) := 'D_623';v_arr2(-4+185) := v_j.d_623;

v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                   J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);--  v_arr1(-4+187) := 'D_62';v_arr2(-4+187) := v_j.d_62;
v_j.d_6 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);--  v_arr1(-4+188) := 'D_6';v_arr2(-4+188) := v_j.d_6;

---------------D.7---------------
v_j.d_711 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);--  v_arr1(221) := 'D_711';v_arr2(221) := v_j.d_711;
v_j.d_712 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);--  v_arr1(223) := 'D_712';v_arr2(223) := v_j.d_712;
v_j.d_71 := v_j.d_711 + v_j.d_712; 
                                   J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);--   v_arr1(-4+189) := 'D_71';v_arr2(-4+189) := v_j.d_71;
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                   J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);--  v_arr1(224) := 'D_721';v_arr2(224) := v_j.d_721;
v_j.d_722 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);--  v_arr1(225) := 'D_722';v_arr2(226) := v_j.d_722;
v_j.d_72 := v_j.d_721 + v_j.d_722; 
                                   J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);--   v_arr1(-4+190) := 'D_72';v_arr2(-4+190) := v_j.d_72;

v_j.d_7511 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);--  v_arr1(-4+191) := 'D_7511';v_arr2(-4+191) := v_j.d_7511;
v_j.d_7512 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);--  v_arr1(-4+192) := 'D_7512';v_arr2(-4+192) := v_j.d_7512;
v_j.d_7513 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);--  v_arr1(-4+193) := 'D_7513';v_arr2(-4+193) := v_j.d_7513;
v_j.d_7514 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);--  v_arr1(-4+194) := 'D_7514';v_arr2(-4+194) := v_j.d_7514;
v_j.d_7515 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);--  v_arr1(-4+195) := 'D_7515';v_arr2(-4+195) := v_j.d_7515;
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;                 
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);--  v_arr1(-4+196) := 'D_751';v_arr2(-4+196) := v_j.d_751;

v_j.d_7521 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);--  v_arr1(-4+197) := 'D_7521';v_arr2(-4+197) := v_j.d_7521;
v_j.d_7522 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);--  v_arr1(-4+198) := 'D_7522';v_arr2(-4+198) := v_j.d_7522;
v_j.d_7523 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);--  v_arr1(-4+199) := 'D_7523';v_arr2(-4+199) := v_j.d_7523;
v_j.d_7524 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);--  v_arr1(-4+200) := 'D_7524';v_arr2(-4+200) := v_j.d_7524;
v_j.d_7525 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);--  v_arr1(-4+201) := 'D_7525';v_arr2(-4+201) := v_j.d_7525;
v_j.d_7526 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);--  v_arr1(-4+202) := 'D_7526';v_arr2(-4+202) := v_j.d_7526;
v_j.d_7527 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);--  v_arr1(-4+203) := 'D_7527';v_arr2(-4+203) := v_j.d_7527;
v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;                 
                                   J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_7521);--  v_arr1(-4+204) := 'D_752';v_arr2(-4+204) := v_j.d_752;

v_j.d_75 := v_j.d_751 - v_j.d_752; 
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_75); --v_arr1(-4+205) := 'D_75';v_arr2(-4+205) := v_j.d_75;

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7); --  v_arr1(-4+206) := 'D_7';v_arr2(-4+206-4) := v_j.d_7;

---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);--  v_arr1(-4+207) := 'B_6g';v_arr2(-4+207) := v_j.b_6g;
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);--  v_arr1(-4+208) := 'B_6n';v_arr2(-4+208) := v_j.b_6n;
v_j.d_8 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);--  v_arr1(-4+209) := 'D_8';v_arr2(-4+209) := v_j.d_8;
v_j.b_8g := v_j.b_6g - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);--  v_arr1(-4+210) := 'B_8g';v_arr2(-4+210) := v_j.b_8g;
v_j.b_8n := v_j.b_6n - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);--  v_arr1(-4+211) := 'B_8n';v_arr2(-4+211) := v_j.b_8n;

--J_SZEKT_EVES_T.FELTOLT_t(v_arr1, v_arr2);

END eva_43;


PROCEDURE EVA_71(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2,c_teaor VARCHAR2, c_m003 VARCHAR2) AS
 p_1221_koef NUMBER(15,3);
 p_2_koef NUMBER(15,3);
 v_temp NUMBER(15,3);
 p PAIR;
BEGIN
p := PAIR.INIT;
p_1221_koef := J_SELECT_T.EVA_P1221(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;
p_2_koef := J_SELECT_T.EVA_P2(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  

--p11 kiszámítás
v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); --ED 20170327
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p111 kiszámítás
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);
v_j.p_1111 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);

v_j.p_1112 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);
v_j.p_1113 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);
v_j.p_111 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

v_j.p_11 := v_j.p_119 + v_j.p_112 + v_j.p_118;
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --ED 20170327

--p113
v_j.p_1131 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);
v_j.p_113 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p115-p116
v_j.p_1151 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);
v_j.p_115 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

v_j.p_116 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

--p12 kiszámítás
v_j.p_1211 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_1212 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_121 :=  J_KETTOS_FUGG_T.P_121(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_1221 := v_j.p_121*p_1221_koef;
              /*2015v: koefficiens P.1221-hez:
                50 millió Ft nettó árbevétel alatti kettősök 
                elábé/ért.nettó árb. aránya szakágazatonként 
                (PFC0M092/PRCA103)*/
              /*2015e:  koefficiens P.1221-hez:
                50 millió Ft nettó árbevétel alatti kettősök 
                elábé/ért.nettó árbev. aránya szakágazatonként 
                (PFC0M092/PFC0M103)*/
                                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221;            J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);


v_j.p_12 := v_j.p_121-v_j.p_122;    J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);

v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                    J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;            J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132-v_j.p_131;    J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 :=  J_KETTOS_FUGG_T.P_14(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);
-- itt p.15, p.16 teljesen 0.

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12-v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--P.21
v_j.p_21 := 0.21 * 0.44 * v_j.p_1;  J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
            /*2015v: 0,21*0,44*P.1*/
            /*2015e: külön adat*/
--P.22
v_j.p_22 := 0.69 * 0.44 * v_j.p_1;  J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
            /*2015v: 0,69*0,44*P.1*/
            /*2015e: külön adat*/
--P.23
v_j.p_2331 := 0.1 * 0.44 * v_j.p_1; 
                                    J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);
              /*2015v: 0,1*0,44*P.1*/
              /*2015e: külön adat*/
v_j.p_233 := v_j.p_2331;            J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);
v_j.p_23 := v_j.p_233;              J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);
v_j.p_231 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_232', v_betoltes);

IF p.f = 2 THEN
 v_j.p_232 := 0 + p.v;
ELSE
 v_j.p_232 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);


v_j.p_2321 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

--p24
v_j.p_24 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);
v_j.p_292 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); --ED 20170327
             /*2015v: külön adat*/
v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                    J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   --ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27
           + v_j.p_28 + v_j.p_29;
--módszertani váltás 2012.05.04
--v_j.p_1* p_2_koef; 

                                    J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);

--b.1g kiszámítása
v_j.b_1g := v_j.p_1-v_j.p_2;        J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := 0;                       J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g-v_j.K_1;       J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;            J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;          J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;          J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;           J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;         J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;          J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;           J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;          J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                    J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);

v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                    J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                  J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;          J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                    J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;  J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

--d_111
v_temp := v_j.b_1g - J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema,c_m003,'D_4221');
IF v_temp>0 THEN
v_j.d_1111 := v_temp;  
ELSE v_j.d_1111 := 0 ;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);

v_j.d_11123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- bekerült d.11124: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                    J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                    J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 * 0.3525; /*0.4641 volt, átírva 2017.04.27*/
                                    J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;             J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 :=  0;                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;          J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;          J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;          J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;          J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);

v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 
             + v_j.d_1125 + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                    J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;  J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 :=  0;--J_KETTOS_FUGG_T.d_1212(c_sema,c_m003);   
                                    J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := v_j.d_111 * 0.27;     J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;          J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;          J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;          J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                    J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;          J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;          J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                    J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122;  J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;     J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := 0;--J_SELECT_T.mesg_szamok(c_sema,c_m003,'LALA173');                         
            J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

v_j.d_29b1 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 + v_j.d_29E3;
                                    J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;            J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                    J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;            J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                    J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g-v_j.d_1-v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n-v_j.d_1-v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------
v_j.d_41211 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);
v_j.d_41212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);
v_j.d_412131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);
v_j.d_412132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                    J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 ;
                                    J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);
v_j.d_41222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);
v_j.d_412232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 :=  v_j.d_412231-v_j.d_412232;
                                    J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                    J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121-v_j.d_4122; 
                                    J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;            J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;  J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42

v_j.d_421 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema,c_m003,'D_4221');
                                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

v_j.d_4226 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                    J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421-v_j.d_422;    J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

v_j.d_44132 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);
v_j.d_44131 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                    J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                    J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44232 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_44231 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                    J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                    J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);



v_j.d_44 := v_j.d_441-v_j.d_442;    J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);

-----------------D.4---------------
v_j.d_431 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
v_j.d_432 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431-v_j.d_432;    J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);

v_j.d_45 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44-v_j.d_45-v_j.d_46;
                                    J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                    J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                    J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;/*Külön adat*/     J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13; 
                                    J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------

v_j.d_611 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;             J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := 0;                    J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);

v_j.d_621 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122;             J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614-v_j.d_61SC;
                                    J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                    J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61 - v_j.d_62;     J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                    J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722;  J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;                  
                                    J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;                  
                                    J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751 - v_j.d_752;  J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := 0;                       J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g-v_j.d_8;       J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n-v_j.d_8;       J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END EVA_71;

---------------------------------------------------------------------------
-- EVA 71 KETTŐSÖK KATA
PROCEDURE KATA(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2, c_teaor VARCHAR2, c_m003 VARCHAR2) AS
 p PAIR;
 p_1221_koef NUMBER(15, 3);
 p_2_koef NUMBER(15, 3);
 v_temp NUMBER(15, 3);
BEGIN
p := PAIR.INIT;
p_1221_koef := J_SELECT_T.EVA_P1221(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;
p_2_koef := J_SELECT_T.EVA_P2(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;
--v_arr1.EXTEND(226);                     -- ATIRVA J_SZEKT_EVES_T.FELTOLT HIVASOKKAL: ED 20170329
--v_arr2.EXTEND(226);
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j); 

--p11 kiszámítás
v_j.p_118 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/         J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119); --v_arr1(1) := 'P_119'; v_arr2(1) := v_j.p_119;
--p111 kiszámítás
v_j.p_11111 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111); --v_arr1(2) := 'P_11111'; v_arr2(2) := v_j.p_11111;
v_j.p_11112 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112); -- v_arr1(3) := 'P_11112';v_arr2(3) := v_j.p_11112;
v_j.p_1111 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111); -- v_arr1(4) := 'P_1111';v_arr2(4) := v_j.p_1111;
v_j.p_1112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112); -- v_arr1(5) := 'P_1112';v_arr2(5) := v_j.p_1112;
v_j.p_1113 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113); -- v_arr1(6) := 'P_1113';v_arr2(6) := v_j.p_1113;
v_j.p_1114 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114); -- v_arr1(7) := 'P_1114';v_arr2(7) := v_j.p_1114;
v_j.p_111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111); -- v_arr1(8) := 'P_111';v_arr2(8) := v_j.p_111;
--p112
v_j.p_1121 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121); -- v_arr1(9) := 'P_1121';v_arr2(9) := v_j.p_1121;
v_j.p_1122 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122); -- v_arr1(10) := 'P_1122';v_arr2(10) := v_j.p_1122;
v_j.p_1123 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123); -- v_arr1(11) := 'P_1123';v_arr2(11) := v_j.p_1123;
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                  J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112); -- v_arr1(12) := 'P_112';v_arr2(12) := v_j.p_112;
--p113
v_j.p_1131 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131); -- v_arr1(13) := 'P_1131';v_arr2(13) := v_j.p_1131;
v_j.p_1132 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132); -- v_arr1(14) := 'P_1132';v_arr2(14) := v_j.p_1132;
v_j.p_113 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113); -- v_arr1(15) := 'P_113';v_arr2(15) := v_j.p_113;
--p115-p116
v_j.p_1151 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151); -- v_arr1(16) := 'P_1151';v_arr2(16) := v_j.p_1151;
v_j.p_1152 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152); -- v_arr1(17) := 'P_1152';v_arr2(17) := v_j.p_1152;
v_j.p_115 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115); -- v_arr1(18) := 'P_115';v_arr2(18) := v_j.p_115;
v_j.p_116 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);  -- v_arr1(19) := 'P_116';v_arr2(19) := v_j.p_116;
v_j.p_11 := v_j.p_119 + v_j.p_112 + v_j.p_118;
                                  J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); -- v_arr1(20) := 'P_11';v_arr2(20) := v_j.p_11;
--p12 kiszámítás
v_j.p_1211 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);  --v_arr1(25) := 'P_1211';v_arr2(25) := v_j.p_1211;
v_j.p_1212 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);  --v_arr1(26) := 'P_1212';v_arr2(26) := v_j.p_1212;

v_j.p_121 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'PRCA103', v_year, v_verzio, v_teszt);
             /*2015v: 15KATA E*/
             /*2015e: P.1211-P.1212*/
                                  J_SZEKT_EVES_T.feltolt('P_121', v_j.p_121);   --v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;
v_j.p_1363 := 0; -- 2018.04.12 ED
--v_j.p_1363 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'PRJA215') + 12 * 37.5;
              /*2015v: 12*37,5+15KATA-01/04*/
              /*2015e: -*/
                                  J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);    --v_arr1(28) := 'P_1363';v_arr2(28) := v_j.p_1363;
v_j.p_1221 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);    --v_arr1(21) := 'P_1221';v_arr2(21) := v_j.p_1221;
v_j.p_1222 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222);    --v_arr1(22) := 'P_1222';v_arr2(22) := v_j.p_1222;
v_j.p_122 := v_j.p_1221;
                                  J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);    --v_arr1(23) := 'P_122';v_arr2(23) := v_j.p_122;
v_j.p_12 := v_j.p_121 - v_j.p_122;
                                  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);    --v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;
--p13 kiszámítás
v_j.p_1361 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);    --v_arr1(29) := 'P_1361';v_arr2(29) := v_j.p_1361;
v_j.p_1362 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);    --v_arr1(30) := 'P_1362';v_arr2(30) := v_j.p_1362;
v_j.p_1364 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);    --v_arr1(31) := 'P_1364';v_arr2(31) := v_j.p_1364;

v_j.p_1365 := 50;                 J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
              /*2015v: 50*/
              /*2015e: 0*/
--v_arr1(32) := 'P_1365';
--v_arr2(32) := v_j.p_1365;

v_j.p_1366 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);     --v_arr1(33) := 'P_1366';v_arr2(33) := v_j.p_1366;
v_j.p_1367 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);     --v_arr1(34) := 'P_1367';v_arr2(34) := v_j.p_1367;

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 + v_j.p_1366 + v_j.p_1367;
                                  J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132);     --v_arr1(35) := 'P_132';v_arr2(35) := v_j.p_132; 

--v_j.p_1311 := 0;                            v_arr1(-4+62) := 'P_1311';v_arr2(-4+62) := v_j.p_1311;
v_j.p_1312 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);      --v_arr1(36) := 'P_1312';v_arr2(36) := v_j.p_1312;
v_j.p_131 := v_j.p_1312;          J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);      --v_arr1(37) := 'P_131';v_arr2(37) := v_j.p_131;

v_j.p_13 := v_j.p_132 - v_j.p_131;
                                  J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);      --v_arr1(38) := 'P_13';v_arr2(38) := v_j.p_13;

--p14   --p16
v_j.p_14 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);       --v_arr1(39) := 'P_14';v_arr2(39) := v_j.p_14;
v_j.p_15 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);       --v_arr1(40) := 'P_15';v_arr2(40) := v_j.p_15;
v_j.p_16 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);       --v_arr1(41) := 'P_16';v_arr2(41) := v_j.p_16;
-- itt p.15, p.16 teljesen 0.

--P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;
                                  J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1); 	--v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;

--------------
--P.21 és P.22 és P.23 és P.2
--A számítás D.1-gyel is kalkulál, ezért utána számolom ki
--------------
v_j.p_24 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24); --v_arr1(52) := 'P_24';v_arr2(52) := v_j.p_24;
v_j.p_262 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262); --v_arr1(53) := 'P_262';v_arr2(53) := v_j.p_262;
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26); --v_arr1(54) := 'P_26';v_arr2(54) := v_j.p_26;
v_j.p_27 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27); --v_arr1(55) := 'P_27';v_arr2(55) := v_j.p_27;
v_j.p_28 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28); --v_arr1(56) := 'P_28';v_arr2(56) := v_j.p_28;
v_j.p_291 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291); --v_arr1(57) := 'P_291';v_arr2(57) := v_j.p_291;
v_j.p_292 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292); --v_arr1(58) := 'P_292';v_arr2(58) := v_j.p_292;
v_j.p_293 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
            /*2015v: külön adat*/
v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;	
                                  J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29); --v_arr1(59) := 'P_29';v_arr2(59) := v_j.p_29;
--D.21
v_j.d_2111 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111); --v_arr1(64) := 'D_2111';v_arr2(64) := v_j.d_2111;
v_j.d_211 := v_j.d_2111;          J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211); --v_arr1(65) := 'D_211';v_arr2(65) := v_j.d_211;
v_j.d_212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);  --v_arr1(66) := 'D_212';v_arr2(66) := v_j.d_212;
v_j.d_214D := 0;                  J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214D); 	--v_arr1(67) := 'D_214D';v_arr2(67) := v_j.d_214d;
v_j.d_214F := v_j.p_1361;         J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);  --v_arr1(68) := 'D_214F';v_arr2(68) := v_j.d_214F;
v_j.d_214G1 := v_j.p_1362;        J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);  --v_arr1(69) := 'D_214G1';v_arr2(69) := v_j.d_214G1;
v_j.d_214E := v_j.p_1363;         J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E); --v_arr1(70) := 'D_214E';v_arr2(70) := v_j.d_214E;
v_j.d_214I73 := v_j.p_1366;       J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73); --v_arr1(71) := 'D_214I73';v_arr2(71) := v_j.d_214I73;
v_j.d_214I3 := v_j.p_1367;        J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3); --v_arr1(72) := 'D_214I3';v_arr2(72) := v_j.d_214I3;
v_j.d_214I := v_j.p_1365;         J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);  --v_arr1(73) := 'D_214I';v_arr2(73) := v_j.d_214I;
v_j.d_214BA := v_j.p_1364;        J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);  --v_arr1(74) := 'D_214BA';v_arr2(74) := v_j.d_214BA;
v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA; 
                                  J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);  --v_arr1(75) := 'D_214';v_arr2(75) := v_j.d_214;
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;                                  --v_arr1(76) := 'D_21';
                                  J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);  --v_arr2(76) := v_j.d_21;
--D.31
v_j.d_312 :=  0;                  J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);  --v_arr1(77) := 'D_312';v_arr2(77) := v_j.d_312;
v_j.d_31922 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);  --v_arr1(78) := 'D_31922';v_arr2(78) := v_j.d_31922;
v_j.d_3192 := v_j.d_31922;        J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);  --v_arr1(79) := 'D_3192';v_arr2(79) := v_j.d_3192;
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                  J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);  --v_arr1(80) := 'D_319';v_arr2(80) := v_j.d_319;
v_j.d_31 := v_j.d_319 + v_j.d_312;
                                  J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);  --v_arr1(81) := 'D_31';v_arr2(81) := v_j.d_31;
--D.1
--D.111
v_j.d_1111 := 0.6 * J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PRCA103', v_year, v_verzio, v_teszt);
              /*2015v: 0,6* (15KATA E)*/
              /*2015e: Ha (B.1g>0, akkor B.1g, ha kisebb, akkor 0*/
                                  J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111); --v_arr1(82) := 'D_1111';v_arr2(82) := v_j.d_1111;
v_j.d_11121 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);  --v_arr1(83) := 'D_11121';v_arr2(83) := v_j.d_11121;
v_j.d_11124 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124); --v_arr1(84) := 'D_11124';v_arr2(84) := v_j.d_11124;
v_j.d_11123 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123); --v_arr1(85) := 'D_11123';v_arr2(85) := v_j.d_11123;
v_j.d_11125 := 0;	                J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125); --v_arr1(86) := 'D_11125';v_arr2(86) := v_j.d_11125;
v_j.d_11126 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126); --v_arr1(87) := 'D_11126';v_arr2(87) := v_j.d_11126;
v_j.d_11127 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127); --v_arr1(88) := 'D_11127'; v_arr2(88) := v_j.d_11127;
v_j.d_11128 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128); --v_arr1(89) := 'D_11128';v_arr2(89) := v_j.d_11128;
v_j.d_11129 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129); --v_arr1(90) := 'D_11129';v_arr2(90) := v_j.d_11129;
v_j.d_11130 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130); --v_arr1(91) := 'D_11130';v_arr2(91) := v_j.d_11130;
v_j.d_11131 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131); --v_arr1(214) := 'D_11131';v_arr2(214) := v_j.d_11131;
-- d.11124 hozzáadva: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                  J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112); --v_arr1(92) := 'D_1112';v_arr2(92) := v_j.d_1112;
v_j.d_111 := v_j.d_1111 + v_j.d_1112; 
                                  J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111); --v_arr1(93) := 'D_111';v_arr2(93) := v_j.d_111;
--D.112
v_j.d_1121 := v_j.p_16 * J_KONST_T.D_1121_TERM_SZORZO; --0.4641 volt 2017.04.27
--v_j.d_1121 := v_j.p_16 * 0.3525; --0.4641 volt 2017.04.27
                                  J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);  --v_arr1(94) := 'D_1121';v_arr2(94) := v_j.d_1121;
v_j.d_1122 := v_j.p_15;           J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122); --v_arr1(95) := 'D_1122';v_arr2(95) := v_j.d_1122;
v_j.d_1123 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);  --v_arr1(96) := 'D_1123';v_arr2(96) := v_j.d_1123;
v_j.d_1124 := v_j.p_262;          J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124); --v_arr1(97) := 'D_1124';v_arr2(97) := v_j.d_1124;
v_j.d_1125 := v_j.d_11127;        J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);  --v_arr1(98) := 'D_1125';v_arr2(98) := v_j.d_1125;
v_j.d_1126 := v_j.d_11129;        J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126); --v_arr1(99) := 'D_1126';v_arr2(99) := v_j.d_1126;
v_j.d_1127 := v_j.d_11130;        J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127); --v_arr1(100) := 'D_1127';v_arr2(100) := v_j.d_1127;
v_j.d_1128 := v_j.d_11131;        J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128); --v_arr1(215) := 'D_1128';v_arr2(215) := v_j.d_1128;
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                  J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112); 	--v_arr1(208) := 'D_112';v_arr2(208) := v_j.d_112;
--D.11
v_j.d_11 := v_j.d_111 + v_j.d_112;
                                  J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11); --v_arr1(101) := 'D_11';v_arr2(101) := v_j.d_11;
--D.121
v_j.d_1212 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);  --v_arr1(102) := 'D_1212';v_arr2(102) := v_j.d_1212;
v_j.d_1211 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);  --v_arr1(103) := 'D_1211';v_arr2(103) := v_j.d_1211;
v_j.d_1213 := v_j.d_11125;        J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);   --v_arr1(104) := 'D_1213';v_arr2(104) := v_j.d_1213;
v_j.d_1214 := v_j.d_11124;        J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);   --v_arr1(105) := 'D_1214';v_arr2(105) := v_j.d_1214;
v_j.d_1215 := v_j.d_11128;        J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);   --v_arr1(106) := 'D_1215';v_arr2(106) := v_j.d_1215;
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                  J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);   --v_arr1(107) := 'D_121';v_arr2(107) := v_j.d_121;
--D.122
v_j.d_1221 := v_j.d_11126;        J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);  --v_arr1(-4+112) := 'D_1221';v_arr2(-4+112) := v_j.d_1221;
v_j.d_1222 := v_j.d_11123;        J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);  --v_arr1(-4+113) := 'D_1222';v_arr2(-4+113) := v_j.d_1222;
v_j.d_122 := v_j.d_1221 + v_j.d_1222; 
                                  J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);  --v_arr1(-4+114) := 'D_122';v_arr2(-4+114) := v_j.d_122;
--D.12
v_j.d_12 := v_j.d_121 + v_j.d_122;
                                  J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);  --v_arr1(-4+115) := 'D_12';v_arr2(-4+115) := v_j.d_12;
--D.1
v_j.d_1 := v_j.d_11 + v_j.d_12;   J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);  --v_arr1(-4+116) := 'D_1';v_arr2(-4+116) := v_j.d_1;

--P.21
IF v_j.p_1 - v_j.d_1 > 0 
 THEN v_j.p_21 := (v_j.p_1 - v_j.d_1) * 0.21;
 ELSE v_j.p_21 := 0; 
END IF; 
/*2015v: (P.1-D.1)*0,21, ha (P.1-D.1)>0, egyébként 0*/
/*2015e: külön adat*/
                                  J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);   --v_arr1(43) := 'P_21';v_arr2(43) := v_j.p_21;

--P.22
IF v_j.p_1 - v_j.d_1 > 0 
 THEN v_j.p_22 := (v_j.p_1 - v_j.d_1) * 0.69; 
 ELSE v_j.p_22 := 0; 
END IF; 
/*2015v: (P.1-D.1)*0,69, ha (P.1-D.1)>0, egyébként 0*/
/*2015e: külön adat*/
                                  J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22); --v_arr1(44) := 'P_22';v_arr2(44) := v_j.p_22;
--P.2331
IF v_j.p_1 - v_j.d_1 > 0 
THEN v_j.p_2331 := (v_j.p_1 - v_j.d_1) * 0.1; 
ELSE v_j.p_2331 := 0; 
END IF;
/*2015v: (P.1-D.1)*0,1, ha (P.1-D.1)>0, egyébként 0*/
/*2015e: külön adat*/
                                  J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);  --v_arr1(45) := 'P_2331';v_arr2(45) := v_j.p_2331;

v_j.p_231 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231); --v_arr1(46) := 'P_231';v_arr2(46) := v_j.p_231;
v_j.p_232 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);  --v_arr1(47) := 'P_232';v_arr2(47) := v_j.p_232;
v_j.p_2321 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321); --v_arr1(48) := 'P_2321';v_arr2(48) := v_j.p_2321;
v_j.p_2322 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322); --v_arr1(49) := 'P_2322';v_arr2(49) := v_j.p_2322;
v_j.p_233 := v_j.p_2331 - v_j.p_231 - v_j.p_2321;
                                  J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233); --v_arr1(50) := 'P_233';v_arr2(50) := v_j.p_233;
v_j.p_23 := v_j.p_233;            J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23); --v_arr1(51) := 'P_23';--v_arr2(51) := v_j.p_23;
--P. 2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27
           + v_j.p_28 + v_j.p_29;
                                  J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2); --v_arr1(60) := 'P_2';v_arr2(60) := v_j.p_2;
--B.1G és B.1N
v_j.b_1g := v_j.p_1 - v_j.p_2;    J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);  --v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;
v_j.K_1 := 0;                     J_SZEKT_EVES_T.FELTOLT('K_1', v_j.K_1); --v_arr1(-4+66) := 'K_1';v_arr2(62) := v_j.k_1;
v_j.b_1n := v_j.b_1g - v_j.K_1;   J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n); --v_arr1(63) := 'B_1n';v_arr2(63) := v_j.b_1n;
------------D.29
v_j.d_29C1 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);     --v_arr1(-4+117) := 'D_29C1';v_arr2(-4+117) := v_j.d_29C1;
v_j.d_29C2 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);     --v_arr1(-4+118) := 'D_29C2';v_arr2(-4+118) := v_j.d_29C2;
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2; 
                                  J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);     --v_arr1(-4+213) := 'D_29C';v_arr2(-4+213) := v_j.d_29C;

v_j.d_29b1 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);      --v_arr1(-4+119) := 'D_29B1';v_arr2(-4+119) := v_j.d_29b1;
v_j.d_29b3 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);      --v_arr1(-4+120) := 'D_29B3';v_arr2(-4+120) := v_j.d_29b3;

v_j.d_29a11 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'PRJA215', v_year, v_verzio, v_teszt) + 12 * 37.5;
                                  J_SZEKT_EVES_T.feltolt('D_29A11', v_j.d_29a11);
-- 2018.04.12 ED
--v_j.d_29a11 := 0;

v_j.d_29A12 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);      --v_arr1(-4+122) := 'D_29A12';v_arr2(-4+122) := v_j.d_29A12;
v_j.d_29A2 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);      --v_arr1(-4+123) := 'D_29A2';v_arr2(-4+123) := v_j.d_29A2;
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;                           
                                  J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);      --v_arr1(-4+124) := 'D_29A';v_arr2(-4+124) := v_j.d_29A;
v_j.d_2953 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);      --v_arr1(-4+125) := 'D_2953';v_arr2(-4+125) := v_j.d_2953;
v_j.d_29E3 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);      --v_arr1(216) := 'D_29E3';v_arr2(216) := v_j.d_29E3;

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 + v_j.d_29E3;                    
                                  J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);      --v_arr1(-4+126) := 'D_29';v_arr2(-4+126) := v_j.d_29;

--v_j.d_3912 := 0;                                                                v_arr1(-4+64) := 'D_3912';v_arr2(-4+64) := v_j.d_3912;
v_j.d_3911 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);      --v_arr1(-4+127) := 'D_3911';v_arr2(-4+127) := v_j.d_3911;
v_j.d_391 := v_j.d_3911;          J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);      --v_arr1(-4+128) := 'D_391';v_arr2(-4+128) := v_j.d_391;

v_j.d_39251 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);      --v_arr1(-4+129) := 'D_39251';v_arr2(-4+129) := v_j.d_39251;
--v_j.d_39254 := 0;                                                           v_arr1(-4+65) := 'D_39254';v_arr2(-4+65) := v_j.d_39254;
v_j.d_39253 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);      --v_arr1(-4+130) := 'D_39253';v_arr2(-4+130) := v_j.d_39253;
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                  J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);      --v_arr1(-4+131) := 'D_3925';v_arr2(-4+131) := v_j.d_3925;
v_j.d_392 := v_j.d_3925;          J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);      --v_arr1(-4+132) := 'D_392';v_arr2(-4+132) := v_j.d_392;

v_j.d_394 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);      --v_arr1(-4+133) := 'D_394';v_arr2(-4+133) := v_j.d_394;
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                  J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39); --v_arr1(-4+134) := 'D_39';v_arr2(-4+134) := v_j.d_39;

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;                                      
                                  J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);     --v_arr1(-4+135) := 'B_2g';v_arr2(-4+135) := v_j.b_2g;
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                  J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);    -- v_arr1(-4+136) := 'B_2n';v_arr2(-4+136) := v_j.b_2n;

------------D.42-------
v_j.d_41211 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);     --v_arr1(-4+137) := 'D_41211';v_arr2(-4+137) := v_j.d_41211;
v_j.d_41212 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);     --v_arr1(-4+138) := 'D_41212';v_arr2(-4+138) := v_j.d_41212;

v_j.d_412131 := 0;                J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);     --v_arr1(-4+139) := 'D_412131';v_arr2(-4+139) := v_j.d_412131;
v_j.d_412132 := 0;                J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);    -- v_arr1(-4+140) := 'D_412132';v_arr2(-4+140) := v_j.d_412132;
v_j.d_41213 := v_j.d_412131 + v_j.d_412132; 
                                  J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213); 		--v_arr1(-4+141) := 'D_41213';v_arr2(-4+141) := v_j.d_41213;
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                  J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);    --v_arr1(-4+142) := 'D_4121';v_arr2(-4+142) := v_j.d_4121;

v_j.d_41221 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);     --v_arr1(-4+143) := 'D_41221';v_arr2(-4+143) := v_j.d_41221;
v_j.d_41222 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);     --v_arr1(-4+144) := 'D_41222';v_arr2(-4+144) := v_j.d_41222;

v_j.d_412231 := 0;                J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);    -- v_arr1(-4+145) := 'D_412231';v_arr2(-4+145) := v_j.d_412231;
v_j.d_412232 := 0;                J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);    -- v_arr1(-4+146) := 'D_412232';v_arr2(-4+146) := v_j.d_412232;
v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                  J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);    -- v_arr1(-4+147) := 'D_41223';v_arr2(-4+147) := v_j.d_41223;

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                  J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);    -- v_arr1(-4+148) := 'D_4122';v_arr2(-4+148) := v_j.d_4122;
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                  J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);    -- v_arr1(-4+149) := 'D_412';v_arr2(-4+149) := v_j.d_412;

--d41
v_j.d_413 := v_j.d_1123;          J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);      --v_arr1(-4+150) := 'D_413';v_arr2(-4+150) := v_j.d_413;
v_j.d_41 := v_j.d_412 + v_j.d_413;
                                  J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);           --v_arr1(-4+151) := 'D_41';v_arr2(-4+151) := v_j.d_41;
--d42
v_j.d_421 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_421',c_lepes); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                  J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);    --v_arr1(-4+152) := 'D_421';v_arr2(-4+152) := v_j.d_421; 
v_j.d_4221 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4221',c_lepes); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                  J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);    --v_arr1(-4+153) := 'D_4221';v_arr2(-4+153) := v_j.d_4221;
v_j.d_4222 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4222',c_lepes); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                  J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);    --v_arr1(-4+154) := 'D_4222';v_arr2(-4+154) := v_j.d_4222;
v_j.d_4223 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4223',c_lepes); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                  J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);    --v_arr1(-4+155) := 'D_4223';v_arr2(-4+155) := v_j.d_4223;
v_j.d_4224 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4224',c_lepes); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                  J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);    --v_arr1(-4+156) := 'D_4224';v_arr2(-4+156) := v_j.d_4224;
v_j.d_4225 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4225',c_lepes); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                  J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);    --v_arr1(-4+157) := 'D_4225';v_arr2(-4+157) := v_j.d_4225;

v_j.d_4226 := 0;                                                                     
                                  J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);     --v_arr1(-4+158) := 'D_4226';v_arr2(-4+158) := v_j.d_4226;
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;                 
                                  J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);     --v_arr1(-4+159) := 'D_422';v_arr2(-4+159) := v_j.d_422;

v_j.d_42 := v_j.d_421 - v_j.d_422;                                                     
                                  J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);    -- v_arr1(-4+160) := 'D_42';v_arr2(-4+160) := v_j.d_42;


v_j.d_44131 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);            --v_arr1(209) := 'D_44131';v_arr2(209) := v_j.d_44131; --217
v_j.d_44132 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);            --v_arr1(210) := 'D_44132';v_arr2(210) := v_j.d_44132; --218
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                  J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);            --v_arr1(211) := 'D_4413';v_arr2(211) := v_j.d_4413;   --219
v_j.d_4412 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);            --v_arr1(212) := 'D_4412';v_arr2(212) := v_j.d_4412;   --220
v_j.d_4411 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);            --v_arr1(213) := 'D_4411';v_arr2(213) := v_j.d_4411;   --221 - ez a sor nem volt!
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413; 
                                  J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441); 		--v_arr1(214) := 'D_441';v_arr2(214) := v_j.d_441;     --221!!!



v_j.d_44231 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);        --v_arr1(215) := 'D_44231';v_arr2(215) := v_j.d_44231; --217
v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);        --v_arr1(216) := 'D_44232';v_arr2(216) := v_j.d_44232; --218
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;   
                                  J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);        --v_arr1(217) := 'D_4423';v_arr2(217) := v_j.d_4423;   --219
v_j.d_4422 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);        --v_arr1(218) := 'D_4422';v_arr2(218) := v_j.d_4422;   --220
v_j.d_4421 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);        --v_arr1(219) := 'D_4421';v_arr2(219) := v_j.d_4421;   --221 - ez a sor nem volt!
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423; 
                                  J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);  -- v_arr1(220) := 'D_442';v_arr2(220) := v_j.d_442;     --221!!!



-----------------D.4---------------
v_j.d_431 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);   --v_arr1(-4+161) := 'D_431';v_arr2(-4+161) := v_j.d_431;
v_j.d_432 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);   --v_arr1(-4+162) := 'D_432';v_arr2(-4+162) := v_j.d_432;
v_j.d_43 := v_j.d_431 - v_j.d_432;
                                   J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);   --v_arr1(-4+163) := 'D_43';v_arr2(-4+163) := v_j.d_43;
v_j.d_44 := v_j.d_441 - v_j.d_442; 
                                   J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);  --v_arr1(-4+164) := 'D_44';v_arr2(-4+164) := v_j.d_44;
v_j.d_45 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);    --v_arr1(-4+165) := 'D_45';v_arr2(-4+165) := v_j.d_45;
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);   --v_arr1(-4+166) := 'D_46';v_arr2(-4+166) := v_j.d_46;
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);   --v_arr1(-4+167) := 'D_4';v_arr2(-4+167) := v_j.d_4;


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45 - v_j.d_46;        
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);     --v_arr1(-4+168) := 'B_4g';v_arr2(-4+168) := v_j.b_4g;
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);     --v_arr1(-4+169) := 'B_4n';v_arr2(-4+169) := v_j.b_4n;


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);  --v_arr1(-4+170) := 'B_5g';v_arr2(-4+170) := v_j.b_5g;
v_j.b_5n := v_j.b_2n + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);  --v_arr1(-4+171) := 'B_5n';v_arr2(-4+171) := v_j.b_5n;


---------------D.5---------------
v_j.d_51B11 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);  --v_arr1(-4+172) := 'D_51B11';v_arr2(-4+172) := v_j.d_51B11;
v_j.d_51B12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);  --v_arr1(-4+173) := 'D_51B12';v_arr2(-4+173) := v_j.d_51B12;
v_j.d_51B13 := 0;/*Külön adat*/     J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);  --v_arr1(-4+174) := 'D_51B13';v_arr2(-4+174) := v_j.d_51B13;

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                    J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);  --v_arr1(-4+175) := 'D_5';v_arr2(-4+175) := v_j.d_5;
---------------D.6---------------

v_j.d_611 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);    --v_arr1(-4+181) := 'D_611';v_arr2(-4+181) := v_j.d_611;
v_j.d_612 := v_j.d_122;             J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);     --v_arr1(-4+182) := 'D_612';v_arr2(-4+182) := v_j.d_612;
v_j.d_613 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);     --v_arr1(-4+176) := 'D_613';v_arr2(-4+176) := v_j.d_613;
v_j.d_614 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);     --v_arr1(222) := 'D_614';v_arr2(222) := v_j.d_614;
v_j.d_61SC := 0;                    J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);     --v_arr1(-4+177) := 'D_61SC';v_arr2(-4+177) := v_j.d_61SC;

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC; 
                                    J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61); --v_arr1(-4+186) := 'D_61';v_arr2(-4+186) := v_j.d_61;

v_j.d_621 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);     --v_arr1(-4+183) := 'D_621';v_arr2(-4+183) := v_j.d_621;
v_j.d_622 := v_j.d_122;             J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);     --v_arr1(-4+184) := 'D_622';v_arr2(-4+184) := v_j.d_622;
v_j.d_623 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);     --v_arr1(-4+185) := 'D_623';v_arr2(-4+185) := v_j.d_623;


v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                    J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);    --v_arr1(-4+187) := 'D_62';v_arr2(-4+187) := v_j.d_62;
v_j.d_6 := v_j.d_61 - v_j.d_62;     J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);    --v_arr1(-4+188) := 'D_6';v_arr2(-4+188) := v_j.d_6;

---------------D.7---------------
v_j.d_711 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);  --v_arr1(221) := 'D_711';v_arr2(221) := v_j.d_711;
v_j.d_712 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);  --v_arr1(223) := 'D_712';v_arr2(223) := v_j.d_712;
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);  --v_arr1(-4+189) := 'D_71';v_arr2(-4+189) := v_j.d_71;
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                    J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);  --v_arr1(224) := 'D_721';v_arr2(224) := v_j.d_721;
v_j.d_722 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);  --v_arr1(225) := 'D_722';v_arr2(226) := v_j.d_722;
v_j.d_72 := v_j.d_721 + v_j.d_722;  J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);  --v_arr1(-4+190) := 'D_72';v_arr2(-4+190) := v_j.d_72;

v_j.d_7511 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);  --v_arr1(-4+191) := 'D_7511';v_arr2(-4+191) := v_j.d_7511;
v_j.d_7512 := 0;                                                                     
                                    J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);  --v_arr1(-4+192) := 'D_7512';v_arr2(-4+192) := v_j.d_7512;
v_j.d_7513 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);   --v_arr1(-4+193) := 'D_7513';v_arr2(-4+193) := v_j.d_7513;
v_j.d_7514 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);   --v_arr1(-4+194) := 'D_7514';v_arr2(-4+194) := v_j.d_7514;
v_j.d_7515 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);   --v_arr1(-4+195) := 'D_7515';v_arr2(-4+195) := v_j.d_7515;
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;                 
                                    J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);  --v_arr1(-4+196) := 'D_751';v_arr2(-4+196) := v_j.d_751;

v_j.d_7521 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);   --v_arr1(-4+197) := 'D_7521';v_arr2(-4+197) := v_j.d_7521;
v_j.d_7522 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);   --v_arr1(-4+198) := 'D_7522';v_arr2(-4+198) := v_j.d_7522;
v_j.d_7523 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);   --v_arr1(-4+199) := 'D_7523';v_arr2(-4+199) := v_j.d_7523;
v_j.d_7524 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);   --v_arr1(-4+200) := 'D_7524';v_arr2(-4+200) := v_j.d_7524;
v_j.d_7525 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);   --v_arr1(-4+201) := 'D_7525';v_arr2(-4+201) := v_j.d_7525;
v_j.d_7526 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);   --v_arr1(-4+202) := 'D_7526';v_arr2(-4+202) := v_j.d_7526;
v_j.d_7527 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);   --v_arr1(-4+203) := 'D_7527';v_arr2(-4+203) := v_j.d_7527;

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;                 
                                    J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);   --v_arr1(-4+204) := 'D_752';v_arr2(-4+204) := v_j.d_752;

v_j.d_75 := v_j.d_751 - v_j.d_752;  J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);  --v_arr1(-4+205) := 'D_75';v_arr2(-4+205) := v_j.d_75;

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);   --v_arr1(-4+206) := 'D_7';v_arr2(-4+206-4) := v_j.d_7;


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);    --v_arr1(-4+207) := 'B_6g';v_arr2(-4+207) := v_j.b_6g;
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);    --v_arr1(-4+208) := 'B_6n';v_arr2(-4+208) := v_j.b_6n;
v_j.d_8 := 0;                       J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);    --v_arr1(-4+209) := 'D_8';v_arr2(-4+209) := v_j.d_8;
v_j.b_8g := v_j.b_6g - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);    --v_arr1(-4+210) := 'B_8g';v_arr2(-4+210) := v_j.b_8g;
v_j.b_8n := v_j.b_6n - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);    --v_arr1(-4+211) := 'B_8n';v_arr2(-4+211) := v_j.b_8n;

--J_SZEKT_EVES_T.FELTOLT_t(v_arr1, v_arr2);
END KATA;

---------------------------------------------------------------------------
-- EVA 71 KETTŐSÖK KIVA
PROCEDURE KIVA(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2, c_teaor VARCHAR2, c_m003 VARCHAR2) AS 
  p PAIR;
  p_1221_koef NUMBER(15,3);
  p_2_koef NUMBER(15,3);
  v_temp NUMBER(15,3);
BEGIN 
p := PAIR.INIT;
p_1221_koef := J_SELECT_T.EVA_P1221(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;
p_2_koef := J_SELECT_T.EVA_P2(c_teaor, v_year, v_betoltes, v_verzio, v_teszt) / 1000;

--v_arr1.EXTEND(226);           -- ED 20170329
--v_arr2.EXTEND(226);

v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j); 

v_j.p_118 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/         J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119); --v_arr1(1) := 'P_119'; v_arr2(1) := v_j.p_119;
v_j.p_11111 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111); --v_arr1(2) := 'P_11111'; v_arr2(2) := v_j.p_11111;
v_j.p_11112 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112); --v_arr1(3) := 'P_11112';v_arr2(3) := v_j.p_11112;
v_j.p_1111 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111); --v_arr1(4) := 'P_1111';v_arr2(4) := v_j.p_1111;
v_j.p_1112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112); --v_arr1(5) := 'P_1112';v_arr2(5) := v_j.p_1112;
v_j.p_1113 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113); --v_arr1(6) := 'P_1113';v_arr2(6) := v_j.p_1113;
v_j.p_1114 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114); --v_arr1(7) := 'P_1114';v_arr2(7) := v_j.p_1114;
v_j.p_111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111); --v_arr1(8) := 'P_111';v_arr2(8) := v_j.p_111;
v_j.p_1121 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121); --v_arr1(9) := 'P_1121';v_arr2(9) := v_j.p_1121;
v_j.p_1122 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122); --v_arr1(10) := 'P_1122';v_arr2(10) := v_j.p_1122;
v_j.p_1123 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123); --v_arr1(11) := 'P_1123';v_arr2(11) := v_j.p_1123;
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                  J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112); --v_arr1(12) := 'P_112';v_arr2(12) := v_j.p_112;
v_j.p_1131 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131); --v_arr1(13) := 'P_1131';v_arr2(13) := v_j.p_1131;
v_j.p_1132 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132); --v_arr1(14) := 'P_1132';v_arr2(14) := v_j.p_1132;
v_j.p_113 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113); --v_arr1(15) := 'P_113';v_arr2(15) := v_j.p_113;
v_j.p_1151 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151); --v_arr1(16) := 'P_1151';v_arr2(16) := v_j.p_1151;
v_j.p_1152 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152); --v_arr1(17) := 'P_1152';v_arr2(17) := v_j.p_1152;
v_j.p_115 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115); --v_arr1(18) := 'P_115';v_arr2(18) := v_j.p_115;
v_j.p_116 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116); --v_arr1(19) := 'P_116';v_arr2(19) := v_j.p_116;
v_j.p_11 := v_j.p_119 + v_j.p_112 + v_j.p_118;
                                  J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --v_arr1(20) := 'P_11';v_arr2(20) := v_j.p_11;
v_j.p_1211 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211); --v_arr1(25) := 'P_1211';v_arr2(25) := v_j.p_1211;
v_j.p_1212 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212); --v_arr1(26) := 'P_1212';v_arr2(26) := v_j.p_1212;

v_j.p_121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003,'PRJA216', v_year, v_verzio, v_teszt) * 15.7;
             /*2015v:  15,7*(15KIVA-02/D12)*/
                                  J_SZEKT_EVES_T.feltolt('P_121', v_j.p_121); --v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;
v_j.p_1363 := 0; -- 2018.04.12 ED
                                  J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1221 := 0;
                                  J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221); --v_arr1(21) := 'P_1221';v_arr2(21) := v_j.p_1221;

v_j.p_1222 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); --v_arr1(22) := 'P_1222';v_arr2(22) := v_j.p_1222;
v_j.p_122 := v_j.p_1221;          J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122); --v_arr1(23) := 'P_122';v_arr2(23) := v_j.p_122;
v_j.p_12 := v_j.p_121 - v_j.p_122;
                                  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12); --v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;

--p13 kiszámítás
v_j.p_1361 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361); --v_arr1(29) := 'P_1361';v_arr2(29) := v_j.p_1361;
v_j.p_1362 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362); --v_arr1(30) := 'P_1362';v_arr2(30) := v_j.p_1362;
v_j.p_1364 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364); --v_arr1(31) := 'P_1364';v_arr2(31) := v_j.p_1364;
v_j.p_1365 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365); --v_arr1(32) := 'P_1365';v_arr2(32) := v_j.p_1365;
v_j.p_1366 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366); --v_arr1(33) := 'P_1366';v_arr2(33) := v_j.p_1366;
v_j.p_1367 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367); --v_arr1(34) := 'P_1367';v_arr2(34) := v_j.p_1367;
v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                  J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); --v_arr1(35) := 'P_132';v_arr2(35) := v_j.p_132; 

--v_j.p_1311 := 0;                            v_arr1(-4+62) := 'P_1311';v_arr2(-4+62) := v_j.p_1311;
v_j.p_1312 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);  --v_arr1(36) := 'P_1312';v_arr2(36) := v_j.p_1312;
v_j.p_131 := v_j.p_1312;          J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);  --v_arr1(37) := 'P_131';v_arr2(37) := v_j.p_131;

v_j.p_13 := v_j.p_132 - v_j.p_131;
                                  J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);  --v_arr1(38) := 'P_13';v_arr2(38) := v_j.p_13;

--p14   --p16
v_j.p_14 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);  --v_arr1(39) := 'P_14';v_arr2(39) := v_j.p_14;
v_j.p_15 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);  --v_arr1(40) := 'P_15';v_arr2(40) := v_j.p_15;
v_j.p_16 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);  --v_arr1(41) := 'P_16';v_arr2(41) := v_j.p_16;
-- itt p.15, p.16 teljesen 0.

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                  J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);  --v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003,'PRJA216', v_year, v_verzio, v_teszt) * 0.77 * 0.35 * 15.7;
            /*2015v:  0,77*0,35*(15,7*(15KIVA-02/D12)*/
                                  J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);  --v_arr1(43) := 'P_21';v_arr2(43) := v_j.p_21;                                  

v_j.p_22 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003,'PRJA216', v_year, v_verzio, v_teszt) * 0.23 * 0.35 * 15.7;
            /*2015v:  0,23*0,35*(15,7*(15KIVA-02/D12)*/
                                  J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);  --v_arr1(44) := 'P_22';v_arr2(44) := v_j.p_22;

--p23

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_2331', v_betoltes);

IF p.f = 2 THEN
v_j.p_2331 := p.v;
ELSE
v_j.p_2331 := p.v;
END IF;
                                  J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);  --v_arr1(45) := 'P_2331';v_arr2(45) := v_j.p_2331;
v_j.p_231 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);  --v_arr1(46) := 'P_231';v_arr2(46) := v_j.p_231;
v_j.p_232 := 0;/*KÜLÖN SZÁMÍÁS*/  J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);  --v_arr1(47) := 'P_232';v_arr2(47) := v_j.p_232;
v_j.p_2321 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);  --v_arr1(48) := 'P_2321';v_arr2(48) := v_j.p_2321;
v_j.p_2322 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);  --v_arr1(49) := 'P_2322';v_arr2(49) := v_j.p_2322;

v_j.p_233 := v_j.p_2331 - v_j.p_231 - v_j.p_2321;
                                  J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);  --v_arr1(50) := 'P_233';v_arr2(50) := v_j.p_233;
v_j.p_23 := v_j.p_233 ;           J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);  --v_arr1(51) := 'P_23';v_arr2(51) := v_j.p_23;

--p24
v_j.p_24 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);  --v_arr1(52) := 'P_24';v_arr2(52) := v_j.p_24;

--p26
--v_j.p_261 := 0;                                                            v_arr1(-4+63) := 'P_261';v_arr2(-4+63) := v_j.p_261;
v_j.p_262 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);  --v_arr1(53) := 'P_262';v_arr2(53) := v_j.p_262;
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);  --v_arr1(54) := 'P_26';v_arr2(54) := v_j.p_26;

--p27
v_j.p_27 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);  --v_arr1(55) := 'P_27';v_arr2(55) := v_j.p_27;
v_j.p_28 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);  --v_arr1(56) := 'P_28';v_arr2(56) := v_j.p_28;

v_j.p_291 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);  --v_arr1(57) := 'P_291';v_arr2(57) := v_j.p_291;
v_j.p_292 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);  --v_arr1(58) := 'P_292';v_arr2(58) := v_j.p_292;
v_j.p_293 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
             /*2015v: külön adat*/
v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                  J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);  --v_arr1(59) := 'P_29';v_arr2(59) := v_j.p_29;

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27
           + v_j.p_28 + v_j.p_29;
--v_j.p_1* p_2_koef; 
                                  J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);  --v_arr1(60) := 'P_2';v_arr2(60) := v_j.p_2;
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;    J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);  --v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;
v_j.K_1 := 0;                     J_SZEKT_EVES_T.FELTOLT('K_1', v_j.K_1);  --v_arr1(-4+66) := 'K_1';v_arr2(62) := v_j.k_1;
v_j.b_1n := v_j.b_1g - v_j.K_1;   J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);  --v_arr1(63) := 'B_1n';v_arr2(63) := v_j.b_1n;

--D21 kiszámolása
v_j.d_2111 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);  --v_arr1(64) := 'D_2111';v_arr2(64) := v_j.d_2111;
v_j.d_211 := v_j.d_2111;          J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);  --v_arr1(65) := 'D_211';v_arr2(65) := v_j.d_211;

v_j.d_212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);  --v_arr1(66) := 'D_212';v_arr2(66) := v_j.d_212;

v_j.d_214D := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214D);  --v_arr1(67) := 'D_214D';v_arr2(67) := v_j.d_214d;
v_j.d_214F := v_j.p_1361 ;        J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);  --v_arr1(68) := 'D_214F';v_arr2(68) := v_j.d_214F;
v_j.d_214G1 := v_j.p_1362;        J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);  --v_arr1(69) := 'D_214G1';v_arr2(69) := v_j.d_214G1;
v_j.d_214E := v_j.p_1363;         J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);  --v_arr1(70) := 'D_214E';v_arr2(70) := v_j.d_214E;
v_j.d_214I73 := v_j.p_1366;       J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);  --v_arr1(71) := 'D_214I73';v_arr2(71) := v_j.d_214I73;
v_j.d_214I3 := v_j.p_1367;        J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);   --v_arr1(72) := 'D_214I3';v_arr2(72) := v_j.d_214I3;
v_j.d_214I := v_j.p_1365;         J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);  --v_arr1(73) := 'D_214I';v_arr2(73) := v_j.d_214I;
v_j.d_214BA := v_j.p_1364;        J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);  --v_arr1(74) := 'D_214BA';v_arr2(74) := v_j.d_214BA;

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA; 
                                  J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);  --v_arr1(75) := 'D_214';v_arr2(75) := v_j.d_214;
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                  J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);  --v_arr1(76) := 'D_21';v_arr2(76) := v_j.d_21;

--D.31 kiszámítása
v_j.d_312 :=  0  ;                J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);  --v_arr1(77) := 'D_312';v_arr2(77) := v_j.d_312;
v_j.d_31922 := 0;/*KÜLÖN ADAT*/   J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);  --v_arr1(78) := 'D_31922';v_arr2(78) := v_j.d_31922;
v_j.d_3192 := v_j.d_31922;        J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);  --v_arr1(79) := 'D_3192';v_arr2(79) := v_j.d_3192;
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                  J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);  --v_arr1(80) := 'D_319';v_arr2(80) := v_j.d_319;
v_j.d_31 := v_j.d_319 + v_j.d_312;
                                  J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);  --v_arr1(81) := 'D_31';v_arr2(81) := v_j.d_31;


-- ------------D.1 kiszámítása
v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003,'PRCA016', v_year, v_verzio, v_teszt); 
              /*2015v: 15KIVA-02/D07*/
                                  J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);  --v_arr1(82) := 'D_1111';v_arr2(82) := v_j.d_1111;

v_j.d_11121 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);  --v_arr1(83) := 'D_11121';v_arr2(83) := v_j.d_11121;
v_j.d_11124 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);  --v_arr1(84) := 'D_11124';v_arr2(84) := v_j.d_11124;

v_j.d_11123 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11123'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);  --v_arr1(85) := 'D_11123';v_arr2(85) := v_j.d_11123;
v_j.d_11125 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11125'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);  --v_arr1(86) := 'D_11125';v_arr2(86) := v_j.d_11125;
v_j.d_11126 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11126'); --ki volt kommentelve?!
                                J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);  --v_arr1(87) := 'D_11126';v_arr2(87) := v_j.d_11126;
v_j.d_11127 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);  --v_arr1(88) := 'D_11127'; v_arr2(88) := v_j.d_11127;
v_j.d_11128 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);  --v_arr1(89) := 'D_11128';v_arr2(89) := v_j.d_11128;
v_j.d_11129 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);  --v_arr1(90) := 'D_11129';v_arr2(90) := v_j.d_11129;
v_j.d_11130 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_11130'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);  --v_arr1(91) := 'D_11130';v_arr2(91) := v_j.d_11130;

v_j.d_11131 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);  --v_arr1(214) := 'D_11131';v_arr2(214) := v_j.d_11131;
-- d.11124 hozzáadva: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;                                                        
                                J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112); --v_arr1(92) := 'D_1112';v_arr2(92) := v_j.d_1112;

 v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);  --v_arr1(93) := 'D_111';v_arr2(93) := v_j.d_111;

--d112
v_j.d_1121 := v_j.p_16 * J_KONST_T.D_1121_TERM_SZORZO; --0.4641 volt 2017.04.27
--v_j.d_1121 := v_j.p_16 * 0.3525; --0.4641 volt 2017.04.27
                                J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);  --v_arr1(94) := 'D_1121';v_arr2(94) := v_j.d_1121;
v_j.d_1122 := v_j.p_15;         J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);  --v_arr1(95) := 'D_1122';v_arr2(95) := v_j.d_1122;
v_j.d_1123 := 0;                J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);  --v_arr1(96) := 'D_1123';v_arr2(96) := v_j.d_1123;
v_j.d_1124 := v_j.p_262;        J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);  --v_arr1(97) := 'D_1124';v_arr2(97) := v_j.d_1124;
v_j.d_1125 := v_j.d_11127;      J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);  --v_arr1(98) := 'D_1125';v_arr2(98) := v_j.d_1125;
v_j.d_1126 := v_j.d_11129;      J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);  --v_arr1(99) := 'D_1126';v_arr2(99) := v_j.d_1126;
v_j.d_1127 := v_j.d_11130;      J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);  --v_arr1(100) := 'D_1127';v_arr2(100) := v_j.d_1127;
v_j.d_1128 := v_j.d_11131;      J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);  --v_arr1(215) := 'D_1128';v_arr2(215) := v_j.d_1128;
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125 
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;                                                         
                                J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);  --v_arr1(208) := 'D_112';v_arr2(208) := v_j.d_112;
--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;
                                J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);  --v_arr1(101) := 'D_11';v_arr2(101) := v_j.d_11;
--d121
v_j.d_1212 := 0;                J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);  --v_arr1(102) := 'D_1212';v_arr2(102) := v_j.d_1212;
v_j.d_1211 := 0;                J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);  --v_arr1(103) := 'D_1211';v_arr2(103) := v_j.d_1211;

v_j.d_1213 := v_j.d_11125;      J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213); --v_arr1(104) := 'D_1213';v_arr2(104) := v_j.d_1213;
v_j.d_1214 := v_j.d_11124;      J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214); --v_arr1(105) := 'D_1214';v_arr2(105) := v_j.d_1214;
v_j.d_1215 := v_j.d_11128;      J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215); --v_arr1(106) := 'D_1215';v_arr2(106) := v_j.d_1215;
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121); --v_arr1(107) := 'D_121';v_arr2(107) := v_j.d_121;


--d122
v_j.d_1221 := v_j.d_11126;      J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);         --v_arr1(-4+112) := 'D_1221';v_arr2(-4+112) := v_j.d_1221;
v_j.d_1222 := v_j.d_11123;      J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);         --v_arr1(-4+113) := 'D_1222';v_arr2(-4+113) := v_j.d_1222;
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);         --v_arr1(-4+114) := 'D_122';v_arr2(-4+114) := v_j.d_122;

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122;
                                J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);         --v_arr1(-4+115) := 'D_12';v_arr2(-4+115) := v_j.d_12;

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12; 
                                J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);         --v_arr1(-4+116) := 'D_1';v_arr2(-4+116) := v_j.d_1;

------------D.29

v_j.d_29C1 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);           --v_arr1(-4+117) := 'D_29C1';v_arr2(-4+117) := v_j.d_29C1;
v_j.d_29C2 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);           --v_arr1(-4+118) := 'D_29C2';v_arr2(-4+118) := v_j.d_29C2;
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);         -- v_arr1(-4+213) := 'D_29C';v_arr2(-4+213) := v_j.d_29C;

v_j.d_29b1 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);           --v_arr1(-4+119) := 'D_29B1';v_arr2(-4+119) := v_j.d_29b1;
v_j.d_29b3 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);           --v_arr1(-4+120) := 'D_29B3';v_arr2(-4+120) := v_j.d_29b3;

v_j.d_29A11 := 0;               J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);           --v_arr1(-4+121) := 'D_29A11';v_arr2(-4+121) := v_j.d_29A11;
v_j.d_29A12 := 0;               J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);           --v_arr1(-4+122) := 'D_29A12';v_arr2(-4+122) := v_j.d_29A12;
v_j.d_29A2 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);           --v_arr1(-4+123) := 'D_29A2';v_arr2(-4+123) := v_j.d_29A2;
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;                           
                                J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);           --v_arr1(-4+124) := 'D_29A';v_arr2(-4+124) := v_j.d_29A;
v_j.d_2953 := 0;                J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);           --v_arr1(-4+125) := 'D_2953';v_arr2(-4+125) := v_j.d_2953;
v_j.d_29E3 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);           --v_arr1(216) := 'D_29E3';v_arr2(216) := v_j.d_29E3;

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;                    
                                J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);           --v_arr1(-4+126) := 'D_29';v_arr2(-4+126) := v_j.d_29;

--v_j.d_3912 := 0;                            v_arr1(-4+64) := 'D_3912';v_arr2(-4+64) := v_j.d_3912;
v_j.d_3911 := 0;                J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);           --v_arr1(-4+127) := 'D_3911';v_arr2(-4+127) := v_j.d_3911;
v_j.d_391 := v_j.d_3911;        J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);           --v_arr1(-4+128) := 'D_391';v_arr2(-4+128) := v_j.d_391;

v_j.d_39251 := 0;               J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);           --v_arr1(-4+129) := 'D_39251';v_arr2(-4+129) := v_j.d_39251;
--v_j.d_39254 := 0;                           v_arr1(-4+65) := 'D_39254';v_arr2(-4+65) := v_j.d_39254;
v_j.d_39253 := 0;               J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);           --v_arr1(-4+130) := 'D_39253';v_arr2(-4+130) := v_j.d_39253;
v_j.d_3925 := v_j.d_39251 + v_j.d_39253; 
                                J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);      --v_arr1(-4+131) := 'D_3925';v_arr2(-4+131) := v_j.d_3925;
v_j.d_392 := v_j.d_3925;        J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);           --v_arr1(-4+132) := 'D_392';v_arr2(-4+132) := v_j.d_392;

v_j.d_394 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);           --v_arr1(-4+133) := 'D_394';v_arr2(-4+133) := v_j.d_394;
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;  
                                J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39); --v_arr1(-4+134) := 'D_39';v_arr2(-4+134) := v_j.d_39;

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;                                      
                                J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);           --v_arr1(-4+135) := 'B_2g';v_arr2(-4+135) := v_j.b_2g;
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);           --v_arr1(-4+136) := 'B_2n';v_arr2(-4+136) := v_j.b_2n;

------------D.42-------
v_j.d_41211 := 0;               J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);           --v_arr1(-4+137) := 'D_41211';v_arr2(-4+137) := v_j.d_41211;
v_j.d_41212 := 0;               J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);           --v_arr1(-4+138) := 'D_41212';v_arr2(-4+138) := v_j.d_41212;

v_j.d_412131 := 0;              J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);           --v_arr1(-4+139) := 'D_412131';v_arr2(-4+139) := v_j.d_412131;
v_j.d_412132 := 0;              J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);           --v_arr1(-4+140) := 'D_412132';v_arr2(-4+140) := v_j.d_412132;
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;  
                                J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);           --v_arr1(-4+141) := 'D_41213';v_arr2(-4+141) := v_j.d_41213;
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);           --v_arr1(-4+142) := 'D_4121';v_arr2(-4+142) := v_j.d_4121;

v_j.d_41221 := 0;               J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);           --v_arr1(-4+143) := 'D_41221';v_arr2(-4+143) := v_j.d_41221;
v_j.d_41222 := 0;               J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);           --v_arr1(-4+144) := 'D_41222';v_arr2(-4+144) := v_j.d_41222;

v_j.d_412231 := 0;              J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);           --v_arr1(-4+145) := 'D_412231';v_arr2(-4+145) := v_j.d_412231;
v_j.d_412232 := 0;              J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);           --v_arr1(-4+146) := 'D_412232';v_arr2(-4+146) := v_j.d_412232;
v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);           --v_arr1(-4+147) := 'D_41223';v_arr2(-4+147) := v_j.d_41223;

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);           --v_arr1(-4+148) := 'D_4122';v_arr2(-4+148) := v_j.d_4122;
v_j.d_412 := v_j.d_4121 - v_j.d_4122; 
                                J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);         --v_arr1(-4+149) := 'D_412';v_arr2(-4+149) := v_j.d_412;

--d41
v_j.d_413 := v_j.d_1123;        J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);         --v_arr1(-4+150) := 'D_413';v_arr2(-4+150) := v_j.d_413;
v_j.d_41 := v_j.d_412 + v_j.d_413;
                                J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);         --v_arr1(-4+151) := 'D_41';v_arr2(-4+151) := v_j.d_41;
--d42
v_j.d_421 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_421'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);          --v_arr1(-4+152) := 'D_421';v_arr2(-4+152) := v_j.d_421; 
v_j.d_4221 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4221'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);          --v_arr1(-4+153) := 'D_4221';v_arr2(-4+153) := v_j.d_4221;
v_j.d_4222 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4222'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);         -- v_arr1(-4+154) := 'D_4222';v_arr2(-4+154) := v_j.d_4222;
v_j.d_4223 := 0; --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4223'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                                J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);          --v_arr1(-4+155) := 'D_4223';v_arr2(-4+155) := v_j.d_4223;
-- D.4224
IF v_j.b_2g > 0 
 THEN v_j.d_4224 := v_j.b_2g * 0.5;
 ELSE v_j.d_4224 := 0;
END IF;
/*2015v: B.2g*0,5, ha B.2g>0*/
                               J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);         --v_arr1(-4+156) := 'D_4224';v_arr2(-4+156) := v_j.d_4224;

v_j.d_4225 := 0;                 --J_SELECT_T.MESG_SZAMOK(c_sema,c_m003,'D_4225'); --ez ki volt kommentelve és =0; volt... kivéve kommentből 2014.03.06.
                               J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);           --v_arr1(-4+157) := 'D_4225';v_arr2(-4+157) := v_j.d_4225;

v_j.d_4226 := 0;                                                                     
                               J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);           --v_arr1(-4+158) := 'D_4226';v_arr2(-4+158) := v_j.d_4226;
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;                 
                               J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);           --v_arr1(-4+159) := 'D_422';v_arr2(-4+159) := v_j.d_422;

v_j.d_42 := v_j.d_421 - v_j.d_422;                                                     
                               J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42); --v_arr1(-4+160) := 'D_42';v_arr2(-4+160) := v_j.d_42;


v_j.d_44131 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);                  --v_arr1(209) := 'D_44131';v_arr2(209) := v_j.d_44131; --217
v_j.d_44132 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);                  --v_arr1(210) := 'D_44132';v_arr2(210) := v_j.d_44132; --218
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;  
                                J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);           --v_arr1(211) := 'D_4413';v_arr2(211) := v_j.d_4413;   --219
v_j.d_4412 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);                  --v_arr1(212) := 'D_4412';v_arr2(212) := v_j.d_4412;   --220
v_j.d_4411 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);            --v_arr1(213) := 'D_4411';v_arr2(213) := v_j.d_4411;   --221 - ez a sor nem volt!
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;  
                                J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);   --v_arr1(214) := 'D_441';v_arr2(214) := v_j.d_441;     --221!!!



v_j.d_44231 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);                  --v_arr1(215) := 'D_44231';v_arr2(215) := v_j.d_44231; --217
v_j.d_44232 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);                  --v_arr1(216) := 'D_44232';v_arr2(216) := v_j.d_44232; --218
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;     
                                J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);       -- v_arr1(217) := 'D_4423';v_arr2(217) := v_j.d_4423;   --219
v_j.d_4422 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);              -- v_arr1(218) := 'D_4422';v_arr2(218) := v_j.d_4422;   --220
v_j.d_4421 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);              -- v_arr1(219) := 'D_4421';v_arr2(219) := v_j.d_4421;   --221 - ez a sor nem volt!
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;  
                                J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);  -- v_arr1(220) := 'D_442';v_arr2(220) := v_j.d_442;     --221!!!



-----------------D.4---------------
v_j.d_431 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);           --v_arr1(-4+161) := 'D_431';v_arr2(-4+161) := v_j.d_431;
v_j.d_432 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);           --v_arr1(-4+162) := 'D_432';v_arr2(-4+162) := v_j.d_432;
v_j.d_43 := v_j.d_431 - v_j.d_432;
                                J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);           --v_arr1(-4+163) := 'D_43';v_arr2(-4+163) := v_j.d_43;
v_j.d_44 := v_j.d_441 - v_j.d_442;
                                J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);  -- v_arr1(-4+164) := 'D_44';v_arr2(-4+164) := v_j.d_44;
v_j.d_45 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);           --v_arr1(-4+165) := 'D_45';v_arr2(-4+165) := v_j.d_45;
v_j.d_46 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);           --v_arr1(-4+166) := 'D_46';v_arr2(-4+166) := v_j.d_46;
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44 - v_j.d_45 - v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);            --v_arr1(-4+167) := 'D_4';v_arr2(-4+167) := v_j.d_4;


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45
            - v_j.d_46;        
                               J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);            --v_arr1(-4+168) := 'B_4g';v_arr2(-4+168) := v_j.b_4g;
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45
            - v_j.d_46;
                               J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);            --v_arr1(-4+169) := 'B_4n';v_arr2(-4+169) := v_j.b_4n;


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;
                               J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);   --v_arr1(-4+170) := 'B_5g';v_arr2(-4+170) := v_j.b_5g;
v_j.b_5n := v_j.b_2n + v_j.d_4;
                               J_SZEKT_EVES_T.feltolt('B_5n', v_j.b_5n);   --v_arr1(-4+171) := 'B_5n';v_arr2(-4+171) := v_j.b_5n;


---------------D.5---------------
v_j.d_51B11 := 0;              J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);   --v_arr1(-4+172) := 'D_51B11';v_arr2(-4+172) := v_j.d_51B11;
v_j.d_51b12 := 0;              J_SZEKT_EVES_T.feltolt('D_51B12', v_j.d_51b12);   --v_arr1(-4+173) := 'D_51B12';v_arr2(-4+173) := v_j.d_51B12;
v_j.d_51b13 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'PRJA216', v_year, v_verzio, v_teszt); -- 2018.04.12 ED
--v_j.d_51b13 := 0; /*Külön adat*/
                               J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);   --v_arr1(-4+174) := 'D_51B13';v_arr2(-4+174) := v_j.d_51B13;

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                               J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);   --v_arr1(-4+175) := 'D_5';v_arr2(-4+175) := v_j.d_5;
---------------D.6---------------

v_j.d_611 := 0;                J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);     --v_arr1(-4+181) := 'D_611';v_arr2(-4+181) := v_j.d_611;
v_j.d_612 := v_j.d_122;        J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);     --v_arr1(-4+182) := 'D_612';v_arr2(-4+182) := v_j.d_612;
v_j.d_613 := 0;                J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);     --v_arr1(-4+176) := 'D_613';v_arr2(-4+176) := v_j.d_613;
v_j.d_614 := 0;                J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);     --v_arr1(222) := 'D_614';v_arr2(222) := v_j.d_614;
v_j.d_61SC := 0;               J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);     --v_arr1(-4+177) := 'D_61SC';v_arr2(-4+177) := v_j.d_61SC;

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;  
                               J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61); --v_arr1(-4+186) := 'D_61';v_arr2(-4+186) := v_j.d_61;

v_j.d_621 := 0;                J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);  --v_arr1(-4+183) := 'D_621';v_arr2(-4+183) := v_j.d_621;
v_j.d_622 := v_j.d_122;        J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);  --v_arr1(-4+184) := 'D_622';v_arr2(-4+184) := v_j.d_622;
v_j.d_623 := 0;                J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);  --v_arr1(-4+185) := 'D_623';v_arr2(-4+185) := v_j.d_623;


v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                               J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);  --v_arr1(-4+187) := 'D_62';v_arr2(-4+187) := v_j.d_62;
v_j.d_6 := v_j.d_61 - v_j.d_62;
                               J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);  --v_arr1(-4+188) := 'D_6';v_arr2(-4+188) := v_j.d_6;

---------------D.7---------------
v_j.d_711 := 0;                J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);  --v_arr1(221) := 'D_711';v_arr2(221) := v_j.d_711;
v_j.d_712 := 0;                J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);  --v_arr1(223) := 'D_712';v_arr2(223) := v_j.d_712;
v_j.d_71 := v_j.d_711 + v_j.d_712;
                               J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);  --v_arr1(-4+189) := 'D_71';v_arr2(-4+189) := v_j.d_71;
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                               J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);  --v_arr1(224) := 'D_721';v_arr2(224) := v_j.d_721;
v_j.d_722 := 0;                J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);  --v_arr1(225) := 'D_722';v_arr2(226) := v_j.d_722;
v_j.d_72 := v_j.d_721 + v_j.d_722;
                               J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);  --v_arr1(-4+190) := 'D_72';v_arr2(-4+190) := v_j.d_72;

v_j.d_7511 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511); --v_arr1(-4+191) := 'D_7511';v_arr2(-4+191) := v_j.d_7511;
v_j.d_7512 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512); --v_arr1(-4+192) := 'D_7512';v_arr2(-4+192) := v_j.d_7512;
v_j.d_7513 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513); --v_arr1(-4+193) := 'D_7513';v_arr2(-4+193) := v_j.d_7513;
v_j.d_7514 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514); --v_arr1(-4+194) := 'D_7514';v_arr2(-4+194) := v_j.d_7514;
v_j.d_7515 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515); --v_arr1(-4+195) := 'D_7515';v_arr2(-4+195) := v_j.d_7515;
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;                 
                               J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751); --v_arr1(-4+196) := 'D_751';v_arr2(-4+196) := v_j.d_751;

v_j.d_7521 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521); --v_arr1(-4+197) := 'D_7521';v_arr2(-4+197) := v_j.d_7521;
v_j.d_7522 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522); --v_arr1(-4+198) := 'D_7522';v_arr2(-4+198) := v_j.d_7522;
v_j.d_7523 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523); --v_arr1(-4+199) := 'D_7523';v_arr2(-4+199) := v_j.d_7523;
v_j.d_7524 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524); --v_arr1(-4+200) := 'D_7524';v_arr2(-4+200) := v_j.d_7524;
v_j.d_7525 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525); --v_arr1(-4+201) := 'D_7525';v_arr2(-4+201) := v_j.d_7525;
v_j.d_7526 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526); --v_arr1(-4+202) := 'D_7526';v_arr2(-4+202) := v_j.d_7526;
v_j.d_7527 := 0;               J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527); --v_arr1(-4+203) := 'D_7527';v_arr2(-4+203) := v_j.d_7527;

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;                 
                               J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752); --v_arr1(-4+204) := 'D_752';v_arr2(-4+204) := v_j.d_752;

v_j.d_75 := v_j.d_751 - v_j.d_752;
                               J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75); --v_arr1(-4+205) := 'D_75';v_arr2(-4+205) := v_j.d_75;

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                               J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7); --v_arr1(-4+206) := 'D_7';v_arr2(-4+206-4) := v_j.d_7;


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                               J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g); --v_arr1(-4+207) := 'B_6g';v_arr2(-4+207) := v_j.b_6g;
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                               J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n); --v_arr1(-4+208) := 'B_6n';v_arr2(-4+208) := v_j.b_6n;
v_j.d_8 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8); --v_arr1(-4+209) := 'D_8';v_arr2(-4+209) := v_j.d_8;
v_j.b_8g := v_j.b_6g - v_j.d_8;
                               J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g); -- v_arr1(-4+210) := 'B_8g';v_arr2(-4+210) := v_j.b_8g;
v_j.b_8n := v_j.b_6n - v_j.d_8;
                               J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);  --v_arr1(-4+211) := 'B_8n';v_arr2(-4+211) := v_j.b_8n;

--J_SZEKT_EVES_T.FELTOLT_t(v_arr1, v_arr2);

END kiva;

end J_A_EVA_T;