/*
create or replace PACKAGE "J_A_PENZT_T" as 

  PROCEDURE PENZTAR_MNYP(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2, c_m003 VARCHAR2); -- 6530-2 MAGÁNNYUGDÍJPÉNZTÁR
  PROCEDURE PENZTAR_ONK(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2,c_m003 VARCHAR2); -- 6530-1 ÖNKÉNTES NYUGDÍJPÉNZTÁR
  PROCEDURE PENZTAR_ONSEG_EGESZ(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2,c_m003 VARCHAR2); --6512-4,5 ÖNSEG - EGÉSZSÉGPÉNZTÁR
  PROCEDURE PENZTAR_FOGL(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2,c_m003 VARCHAR2); -- 6530-3 FOGLALKOZTATÓI MAGÁNNYÚGDÍJPÉNZTÁR

end J_A_PENZT_T;
*/

create or replace PACKAGE BODY "J_A_PENZT_T" as

v_j J_SZEKT_SEMAMUTATOK;
p PAIR; 

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-------------------------------MAGÁNNYUGDÍJPÉNZTÁR------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-- 6530-2

PROCEDURE PENZTAR_MNYP(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2, c_m003 VARCHAR2) AS
 p PAIR;
BEGIN
p := PAIR.init;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  

v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); --ED 20170327
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111 
v_j.p_11111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC001', v_year, v_verzio, v_teszt);                    
                                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);

v_j.p_11112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_1112);
v_j.p_1111 := v_j.p_11111 + v_j.p_11112;
                                   J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_1112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);

v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1048', v_year, v_verzio, v_teszt); 	
                                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 + v_j.p_1112 + v_j.p_1113+ + v_j.p_1114;
                                   J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA015', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1008', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA016', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1064', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA014', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1065', v_year, v_verzio, v_teszt)
           - (
                J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA037', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1013', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1071', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1072', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA034', v_year, v_verzio, v_teszt)
              )
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB015', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1008', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB016', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1064', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB014', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1065', v_year, v_verzio, v_teszt)
           - (
                J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB037', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1013', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB034', v_year, v_verzio, v_teszt)
             )
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC015', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1008', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC016', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1064', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC014', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1065', v_year, v_verzio, v_teszt)
           - (
                J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC037', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1013', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC034', v_year, v_verzio, v_teszt)
             );

v_j.p_1121 := 0 * v_j.p_1121;

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1121', v_betoltes);

IF p.f = 2 THEN
 v_j.p_1121 := p.v;
 ELSE
 v_j.p_1121 := v_j.p_1121 + p.v;
 END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

v_j.p_1122 := 1;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0; /*KÜLÖN SZÁÁMÍTÁS*/
                                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121 * v_j.p_1122;
                                   J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMEA001', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMEA003', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMEA004', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMEA005', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                   J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);


--p_115
v_j.p_1151 := v_j.p_111 + v_j.p_112 - v_j.p_113
                  - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA026', v_year, v_verzio, v_teszt)
                  - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA027', v_year, v_verzio, v_teszt);
v_j.p_1151 := 0 * v_j.p_1151;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_1151', v_betoltes);  
        
IF p.f = 2 THEN
v_j.p_1151 := p.v;              
ELSE
v_j.p_1151 := v_j.p_1151+p.v;              
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;    	             J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);
v_j.p_115 := v_j.p_1151 - v_j.p_1152;
                                   J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.118*/
            /*2015e: P.111+P.112-P.113-P.115*/
                                   J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --ED 20170327
--p12 kiszámítás
v_j.p_1221 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                   J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_1211 := 0;    	             J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_1212 := 0;    	             J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_121 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122; 
                                   J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 
             + v_j.p_1366 + v_j.p_1367;
                                   J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;           J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131; 
                                   J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);
-- itt p.15, p.16 teljesen 0.

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1000', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
v_j.p_22 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA160', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA210', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA211', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB210', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB211', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC210', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC211', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);
v_j.p_232 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA172', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA173', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                   J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1076', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;             J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_292', v_betoltes);
 
IF p.f = 2 THEN
 v_j.p_292 := p.v;
ELSE
 v_j.p_292 := p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);

v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); --ED 20170327
             /*2015v: külön adat*/

v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                   J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   --ED 20170327;

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 
           - v_j.p_26 + v_j.p_27 + v_j.p_28 + v_j.p_29; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;       J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA028', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;      J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;         J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E
             + v_j.d_214I73 + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                   J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

--d_111
v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA149', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA157', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);
v_j.d_11123 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- beszúrva d_11124: 2017.08.11
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                   J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 * J_KONST.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 * 0.3525; -- 0.4641 volt 2017.04.27
                                   J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;            J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;           J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;         J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;         J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;         J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;         J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                   J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112; J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1077', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;         J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;         J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;         J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                   J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;         J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;         J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                   J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122; J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;    J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

v_j.d_29b1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;
                                   J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;           J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                   J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;           J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                   J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA015', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1064', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB015', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1064', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC015', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1064', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003, 'D_41211', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41211 := p.v;
ELSE
 v_j.d_41211 := v_j.d_41211+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA014', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB014', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC014', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412132', v_betoltes);

IF p.f = 2 THEN
 v_j.d_412132 := 0+p.v;/*KÜLÖN ADAT */
ELSE
 v_j.d_412132 := 0+p.v;/*KÜLÖN ADAT */
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);


v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                   J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA037', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1071', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB037', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC037', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41221', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41221 := p.v;
ELSE
 v_j.d_41221 := v_j.d_41221 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);

v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA034', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB034', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC034', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003, 'D_41222', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41222 := p.v;
ELSE
 v_j.d_41222 := v_j.d_41222 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412232', v_betoltes);


IF p.f = 2 THEN
v_j.d_412232 := 0+p.v;/*KÜLÖN ADAT */ 
ELSE
v_j.d_412232 := 0+p.v;/*KÜLÖN ADAT */ 
END IF;

                                   J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);

v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                   J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                   J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                   J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;           J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413; 
                                   J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);

--d42
/* v_j.d_421 := J_SELECT_T.mesg_szamok(c_sema,c_m003,'D_421');
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); 
                                   --20**-es adat*/

v_j.d_421 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA016', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1065', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB016', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1065', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC016', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1065', v_year, v_verzio, v_teszt);
             --+J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMCB016')
             --+ J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMCB1065');
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

v_j.d_4221 := 0;
                                   J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);
v_j.d_4226 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                   J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422; 
                                   J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_44132', v_betoltes);

IF p.f = 2 THEN
v_j.d_44132 := 0+p.v;
ELSE
v_j.d_44132 := 0+p.v;
END IF;
J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);

v_j.d_44131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                   J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                   J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_44231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                   J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := v_j.p_112;           J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                   J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);

v_j.d_44 := v_j.d_441 - v_j.d_442; 
                                   J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
-----------------D.4---------------
v_j.d_431 := 0;/*KÜLÖN ADAT MNB */ 
                                   J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
v_j.d_432 := 0;/*KÜLÖN ADAT MNB */ 
                                   J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431 - v_j.d_432; 
                                   J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;/*SZÁMÍTOT ADAT*/ 
-- J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);

v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;/*Külön adat*/    J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                   J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------
v_j.d_611 := v_j.p_1113;           J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := v_j.p_1111 + v_j.p_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := v_j.p_112;            J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := v_j.p_1;             J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);

v_j.d_621 := v_j.p_113;            J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                   J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712; 
                                   J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := 0/* v_j.p_2321 - v_j.p_232*/;
                                   J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722; 
                                   J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */  
                                   J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                   J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                   J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                   J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751 - v_j.d_752; 
                                   J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END PENZTAR_MNYP;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
--------------------------ÖNKÉNTES NYUGDÍJPÉNZTÁR-------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-- 6530-1
PROCEDURE PENZTAR_ONK(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2,c_m003 VARCHAR2) AS
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  

v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); --ED 20170327
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);
--p_111

v_j.p_11111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA001', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA006', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB001', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB006', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC001', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC006', v_year, v_verzio, v_teszt);                               	                          
                                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_1112);
v_j.p_1111 := v_j.p_11111 + v_j.p_11112;
                                   J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_1112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);

v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA004', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA007', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA008', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB004', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB007', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB008', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC004', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC007', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC008', v_year, v_verzio, v_teszt); 	
                                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 + v_j.p_1112 + v_j.p_1113+ + v_j.p_1114;
                                   J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 :=  J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA015', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1008', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA016', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1053', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA014', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1054', v_year, v_verzio, v_teszt)
                - (
                  J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA037', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1013', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1060', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA034', v_year, v_verzio, v_teszt)
                  )
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB015', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1008', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB016', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1053', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB014', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1054', v_year, v_verzio, v_teszt)
                - (
                  J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB037', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1013', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB034', v_year, v_verzio, v_teszt)
                  )
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC015', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1008', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC016', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1053', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC014', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1054', v_year, v_verzio, v_teszt)
                - (
                  J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC037', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1013', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC034', v_year, v_verzio, v_teszt)
                  );

v_j.p_1121 := 0 * v_j.p_1121;
--+J_KORR_T.KORR_FUGG(c_sema,c_m003,'P_1121');

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003, 'P_1121', v_betoltes);

IF p.f = 2 THEN
 v_j.p_1121 := p.v;
ELSE
 v_j.p_1121 := v_j.p_1121 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 1;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0; /*KÜLÖN SZÁÁMÍTÁS*/
                                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121*v_j.p_1122;
                                   J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNEA001', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNEA003', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNEA005', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);

v_j.p_1132 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                   J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);


--p_115
v_j.p_1151 := v_j.p_111 + v_j.p_112 - v_j.p_113 
                - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA026', v_year, v_verzio, v_teszt)
                - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA027', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_1151', v_betoltes);

IF p.f = 2 THEN
 v_j.p_1151 := p.v;  
ELSE
 v_j.p_1151 := 0 * v_j.p_1151 + p.v;  
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;    	             J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);
v_j.p_115 := v_j.p_1151 - v_j.p_1152;
                                   J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.118*/
            /*2015e: P.111+P.112-P.113-P.115*/
                                   J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --ED 20170327
--p12 kiszámítás
v_j.p_1221 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                   J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_1211 := 0;    	             J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_1212 := 0;    	             J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_121 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA019', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                   J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;           J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131; 
                                   J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);
-- itt p.15, p.16 teljesen 0.

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1000', v_year, v_verzio, v_teszt);   
                                   J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
v_j.p_22 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA160', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA210', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA211', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB210', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB211', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC210', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC211', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

v_j.p_232 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA822', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA172', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA038', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                   J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;             J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_292', v_betoltes);

IF p.f = 2 THEN
v_j.p_292 := 0+p.v;
ELSE
v_j.p_292 := 0+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);

v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); --ED 20170327
             /*2015v: külön adat*/

v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                   J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   --ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27
           + v_j.p_28 + v_j.p_29; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;     J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA028', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;    J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;         J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);

v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312; 
                                   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

--d_111
v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA149', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA157', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);

v_j.d_11123 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- beszúrva d_11124: 2017.08.11
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                   J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 * J_KONST.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 * 0.3525; -- 0.4641 volt 2017.04.27
                                   J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;            J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;           J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;         J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;         J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;         J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;         J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);

v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                   J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112; 
                                   J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1064', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;         J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;         J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;         J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                   J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;         J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;         J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                   J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122; J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;    J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

v_j.d_29b1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;
                                   J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;           J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                   J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;           J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                   J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA015', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1053', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB015', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1053', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC015', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1053', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41211', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41211 := p.v;
ELSE
 v_j.d_41211 := v_j.d_41211+p.v;
END IF;

                                   J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA014', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB014', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC014', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412132', v_betoltes);

IF p.f = 2 THEN
v_j.d_412132 := 0+p.v;/*KÜLÖN ADAT */
ELSE
v_j.d_412132 := 0+p.v;/*KÜLÖN ADAT */
END IF;
J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);


v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                   J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA037', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1060', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB037', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC037', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41221', v_betoltes);

IF p.f = 2 THEN
v_j.d_41221 := p.v;
ELSE
v_j.d_41221 := v_j.d_41221+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);

v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA1013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA034', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB1013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCB034', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC1013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCC034', v_year, v_verzio, v_teszt);         
p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41222', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41222 := p.v;
ELSE
 v_j.d_41222 := v_j.d_41222 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412232', v_betoltes);

IF p.f = 2 THEN
v_j.d_412232 := 0+p.v;
ELSE
v_j.d_412232 := 0+p.v;/*KÜLÖN ADAT */ 
END IF;
J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);


v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                   J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                   J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                   J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;           J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413; J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);

--d42
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema,c_m003, 'D_421');

                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); --2010-es adat
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);
v_j.d_4221 := 0;
                                   J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);
v_j.d_4226 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                   J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422; 
                                   J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_44132', v_betoltes);

IF p.f = 2 THEN
v_j.d_44132 := 0+p.v;
ELSE
v_j.d_44132 := 0+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);


v_j.d_44131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                   J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                   J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_44231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                   J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := v_j.p_112;           J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                   J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);

v_j.d_44 := v_j.d_441 - v_j.d_442; 
                                   J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);

-----------------D.4---------------
v_j.d_431 := 0;/*KÜLÖN ADAT MNB */ J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
v_j.d_432 := 0;/*KÜLÖN ADAT MNB */ J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431 - v_j.d_432; 
                                   J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;/*SZÁMÍTOT ADAT*/                                               
--J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;/*Külön adat*/    J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PNCA039', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------
v_j.d_611 := v_j.p_1113;           J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := v_j.p_1111 + v_j.p_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := v_j.p_112;            J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := v_j.p_1;             J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);

v_j.d_621 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122 + v_j.p_113;
                                   J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                   J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712; 
                                   J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := 0/* v_j.p_2321 - v_j.p_232*/;
                                   J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722; 
                                   J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */  J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                   J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT koRMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                   J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                   J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751 - v_j.d_752; 
                                   J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);

v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);

v_j.d_8 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END PENZTAR_ONK;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-----------------------------ÖNSEG - EGÉSZSÉGPÉNZTÁR----------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--

-- 6512-4;5 Önkéntes egészség- és önsegélyző pénztár
PROCEDURE PENZTAR_ONSEG_EGESZ(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2,c_m003 VARCHAR2) AS
p PAIR;
BEGIN

p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  

v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); --ED 20170327
             /*2015v: külön adat*/

v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);
--p_111

v_j.p_11111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC008', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC018', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC025', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC041', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC047', v_year, v_verzio, v_teszt);                               	                          
                                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);

v_j.p_11112 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC073', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);

v_j.p_1111  := v_j.p_11111 + v_j.p_11112;
                                   J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);

v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC074', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);

v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC002', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC005', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC019', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC022', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC042', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC045', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);

v_j.p_1114 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 + v_j.p_1112 + v_j.p_1113+ + v_j.p_1114;
                                   J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC006', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC061', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC062', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC023', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC063', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC068', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC046', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC071', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC072', v_year, v_verzio, v_teszt); 
                                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

v_j.p_1122 := 1;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);

v_j.p_1123 := 0; /*KÜLÖN SZÁÁMÍTÁS*/
                                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121 * v_j.p_1122;
                                   J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC012', v_year, v_verzio, v_teszt) 
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC013', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);


--p_115
v_j.p_1151 := v_j.p_111 + v_j.p_112 - v_j.p_113 
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC064', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC065', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);

v_j.p_1152 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 - v_j.p_1152;
                                   J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.118*/
            /*2015e: P.111+P.112-P.113-P.115*/
                                   J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --ED 20170327
--p12 kiszámítás
v_j.p_1221 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                   J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);
v_j.p_1211 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_12 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC038', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                   J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;           J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131;
                                   J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);
-- itt p.15, p.16 teljesen 0.

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC064', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
v_j.p_22 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC069', v_year, v_verzio, v_teszt); 
                                   J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);
v_j.p_232 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := v_j.p_2331;           J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                   J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;             J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0; /*2017.04.27*/
--v_j.p_27 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC066');    
                                   J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC039', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_292', v_betoltes);

IF p.f = 2 THEN
v_j.p_292 := 0+p.v;
ELSE
v_j.p_292 := 0+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); --ED 20170327
             /*2015v: külön adat*/

v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                   J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   --ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27
           + v_j.p_28 + v_j.p_29; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);

-----------------B.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;     J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := 0;                      J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;    J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;         J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);                                   

v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                   J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312; 
                                   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);

-- ------------D.1 kiszámítása

--d_111

v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC065', v_year, v_verzio, v_teszt)
               * J_SELECT_T.ONK_PENZT_D1111(v_year, v_verzio, v_betoltes, v_teszt);
			 					   
                                   J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);
v_j.d_11123 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- beszúrva d_11124: 2017.08.11
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                   J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 * J_KONST.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 * 0.3525; -- 0.4641 volt 2017.04.27
                                   J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;            J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;           J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;         J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;         J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;         J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;         J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                   J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112; 
                                   J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC065', v_year, v_verzio, v_teszt) - v_j.d_1111;
                                   J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;         J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;         J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;         J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                   J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;         J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;         J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                   J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122; 
                                   J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;    J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

v_j.d_29b1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;
                                   J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;           J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                   J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;           J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                   J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC061', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC063', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC071', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41211', v_betoltes);

IF p.f = 2 THEN
v_j.d_41211 := p.v;
ELSE
v_j.d_41211 := v_j.d_41211+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC006', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC023', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC046', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412132', v_betoltes);

IF p.f = 2 THEN
 v_j.d_412132 := 0+p.v;/*KÜLÖN ADAT */
ELSE
 v_j.d_412132 := 0+p.v;/*KÜLÖN ADAT */
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);

v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                   J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 ;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);


p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41221', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41221 := p.v;
ELSE
 v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC062', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC068', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC072', v_year, v_verzio, v_teszt)
                + p.v;
END IF; 
                                   J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);
v_j.d_41222 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412232', v_betoltes);

IF p.f = 2 THEN
v_j.d_412232 := 0+p.v;/*KÜLÖN ADAT */ 
ELSE
v_j.d_412232 := 0+p.v;/*KÜLÖN ADAT */ 
END IF;

                                   J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);

v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                   J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                   J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                   J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;           J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413; 
                                   J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);

--d42
v_j.d_421 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

v_j.d_4221 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);
v_j.d_4226 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                   J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422; 
                                   J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003, 'D_44132', v_betoltes);

IF p.f = 2 THEN
 v_j.d_44132 := 0 + p.v;
ELSE
 v_j.d_44132 := 0 + p.v;
END IF;

J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);
v_j.d_44131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                   J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                   J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_44231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                   J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := v_j.p_112;           J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                   J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);

v_j.d_44 := v_j.d_441 - v_j.d_442; J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
-----------------D.4---------------
v_j.d_431 := 0;/*KÜLÖN ADAT MNB */ 
                                   J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
v_j.d_432 := 0;/*KÜLÖN ADAT MNB */ J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431 - v_j.d_432; 
                                   J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;/*SZÁMÍTOT ADAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC036', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0; /*Külön adat*/   J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PEC036', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------
v_j.d_611 := v_j.p_1113;           J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := v_j.p_1111 + v_j.p_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := v_j.p_112;            J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := v_j.p_1;             J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);

v_j.d_621 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122 + v_j.p_113;
                                   J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                   J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712; 
                                   J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := 0/* v_j.p_2321 - v_j.p_232*/;
                                   J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722; 
                                   J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */  J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                   J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT koRMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                   J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                   J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751 - v_j.d_752;
                                   J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);


END PENZTAR_ONSEG_EGESZ;

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
------------------------FOGLALKOZTATÓI MAGÁNNYÚGDÍJPÉNZTÁR----------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-- 6530-3
PROCEDURE PENZTAR_FOGL(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema varchar2, c_m003 VARCHAR2) AS
p PAIR;
BEGIN
p := PAIR.init;
v_j := j_szekt_semamutatok.getNull(v_j);  

v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);  --ED 20170327
             /*2015v: külön adat*/

v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111

v_j.p_11111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE001', v_year, v_verzio, v_teszt) ;                               	                          
                                  J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);

v_j.p_11112 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_1112);

v_j.p_1111  := v_j.p_11111 + v_j.p_11112;
                                  J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);

v_j.p_1112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);

v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA004', v_year, v_verzio, v_teszt) 
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB004', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOC004', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE004', v_year, v_verzio, v_teszt) ;
                                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);

v_j.p_1114 := 0;
                                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 + v_j.p_1112 + v_j.p_1113+ + v_j.p_1114;
                                   J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA015', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA016', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA014', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA020', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB015', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB016', v_year, v_verzio, v_teszt) 
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB014', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB020', v_year, v_verzio, v_teszt) 
              - (J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA037', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA1060', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA034', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA027', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB037', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB1060', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB034', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB027', v_year, v_verzio, v_teszt))
              + (J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD015', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD016', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD014', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD020', v_year, v_verzio, v_teszt))
              - (J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD037', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD1060', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD034', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD027', v_year, v_verzio, v_teszt));
v_j.p_1121 := v_j.p_1121;--+J_KORR_T.KORR_FUGG(c_sema,c_m003,'P_1121');            
                                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

v_j.p_1122 := 1;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);

v_j.p_1123 := 0; /*KÜLÖN SZÁÁMÍTÁS*/
                                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121 * v_j.p_1122;
                                   J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA017', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD017', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                   J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);


--p_115
v_j.p_1151 := v_j.p_111 + v_j.p_112 - v_j.p_113 
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE081', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE083', v_year, v_verzio, v_teszt);
v_j.p_1151 := v_j.p_1151; --+ J_KORR_T.KORR_FUGG(c_sema,c_m003,'P_1151');                                                                             
                                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);

v_j.p_1152 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 - v_j.p_1152;
                                   J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_118;
           /*2015v: P.111+P.112-P.113-P.115+P.118*/
           /*2015e: P.111+P.112-P.113-P.115*/
                                   J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); -- ED 20170327
--p12 kiszámítás
v_j.p_1212 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_1221 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                   J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_1211 := 0;    	           J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_121 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122; 
                                   J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                   J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;           J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131; 
                                   J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);
-- itt p.15, p.16 tejlesen 0.

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE081', v_year, v_verzio, v_teszt)
            - J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE082', v_year, v_verzio, v_teszt); 
                                   J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);

v_j.p_22 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE082', v_year, v_verzio, v_teszt);    
                                   J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);

--p23
v_j.p_2331 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);
v_j.p_232 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                   J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
-- itt p.262 teljesen 0.
v_j.p_26 := v_j.p_262;             J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);
v_j.p_292 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);  --ED 20170327
             /*2015v: külön adat*/

v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                   J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);    --ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27
            + v_j.p_28 + v_j.p_29; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);

--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;     J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE087', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;    J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;         J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73 
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);

v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                   J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312; 
                                   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

--d_111
v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE084', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE085', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);
v_j.d_11123 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- beszúrva d_11124: 2017.08.11
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129 
              - v_j.d_11130 - v_j.d_11131;
                                   J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 * J_KONST.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 * 0.3525; -- 0.4641 volt 2017.04.27;
--
                                   J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;            J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;           J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;         J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;         J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;         J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;         J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                   J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112; 
                                   J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE086', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;         J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;         J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;         J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                   J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;         J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;         J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                   J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122; 
                                   J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;    J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

v_j.d_29b1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;
                                   J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;           J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                   J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;           J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                   J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);

--@@@@@@@@@@@@@@@@@@@IDÁIG VAN MEGCSINÁLVA  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@v
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo--

------------D.42-------
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA015', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB015', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD015', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE015', v_year, v_verzio, v_teszt);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41211', v_betoltes);

IF p.f = 2 THEN
 v_j.d_41211 := p.v;
ELSE
 v_j.d_41211 := v_j.d_41211+p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA014', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA020', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB014', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD020', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE014', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE020', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);
v_j.d_412132 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                   J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA037', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA1060', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB037', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB1060', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD037', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD1060', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE037', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE1060', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41221', v_betoltes);

IF p.f = 2 THEN                                                                                    
v_j.d_41221 := p.v;
ELSE
v_j.d_41221 := v_j.d_41221+p.v;
END IF;

v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA034', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOA027', v_year, v_verzio, v_teszt) 
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOB027', v_year, v_verzio, v_teszt) 
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD034', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD034', v_year, v_verzio, v_teszt) 
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOD027', v_year, v_verzio, v_teszt) 
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE027', v_year, v_verzio, v_teszt) 
                + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE034', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);
v_j.d_412232 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                   J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223; 
                                   J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                   J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;           J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413; 
                                   J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);

--d42
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema,c_m003,'D_421');
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); 
                                   --2010-es adat

/* v_j.d_421 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA016') 
 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMA1065')
 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB016')
 + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMB1065')+
             J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC016') 
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMC1065') 
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMCB016') 
             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PMCB1065');
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);*/

v_j.d_4221 := 0;
                                   J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);
v_j.d_4226 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                   J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422; 
                                   J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

v_j.d_44132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);
v_j.d_44131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                   J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                   J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_44231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                   J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := v_j.p_112;           J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                   J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);

v_j.d_44 := v_j.d_441 - v_j.d_442; 
                                   J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
-----------------D.4---------------
v_j.d_431 := 0;/*KÜLÖN ADAT MNB */ 
                                   J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
v_j.d_432 := 0;/*KÜLÖN ADAT MNB */ 
                                   J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431 - v_j.d_432; 
                                   J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;/*SZÁMÍTOT ADAT*/
--J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 - v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FOE097', v_year, v_verzio, v_teszt);
                                   J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;/*Külön adat*/    J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                   J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------
v_j.d_611 := v_j.p_1113;           J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := v_j.p_1111 + v_j.p_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := v_j.p_112;            J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := v_j.p_1;             J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);

v_j.d_621 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122 + v_j.p_113;
                                   J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                   J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712; 
                                   J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := 0/* v_j.p_2321 - v_j.p_232*/;
                                   J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722; 
                                   J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */  
                                   J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                   J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT koRMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                   J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                   J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751 - v_j.d_752; 
                                   J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;    J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END PENZTAR_FOGL;

end J_A_PENZT_T;