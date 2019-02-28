/*
create or replace PACKAGE        "J_A_BIZT_E_T" as 

  --12  --BÍZTOSÍTÓ INTÉZET            (ÉLET)        6511-1
  --13  --BÍZTOSÍTÓ EGYYESÜLET TELJES  (ÉLET)        6511-2
 

PROCEDURE BIZT_INTEZET_E    (c_sema VARCHAR2,
                             c_m003 VARCHAR2,
							 v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2
							 );-- BIZTOSÍTÓ INTÉZET (ÉLET)
                                              -- 6511-1 Biztosítóintézetek élet

PROCEDURE BIZT_EGY_TELJES_E(c_sema VARCHAR2,
                            c_m003 VARCHAR2,
							v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2
							); -- BÍZTOSÍTÓ EGYESÜLET 
                                              -- TELJES BESZÁMOLÓ (ÉLET)
                                              -- 6511-2 Biztosító egyesület
                                              -- teljes beszámoló

end J_A_BIZT_E_T;



*/

create or replace PACKAGE BODY        "J_A_BIZT_E_T" as

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-----------------------------BIZTOSÍTÓ INTÉZET (ÉLET)---------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--

-- RÉGEBBEN A J_KONST-BÓL SZEDTEM A KONSTANSOKAT. ITT VISSZATÉRTEM A SZÁMOKRA.
--  A TÖBBINÉL MÉG VAN HIVATKOZÁS J_KONST-RA.
-- 2017.09.13

PROCEDURE BIZT_INTEZET_E(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 v_beta NUMBER(15, 10);
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  

v_beta := J_SELECT_T.BIZT_BETA(c_m003, v_year, v_verzio, v_betoltes, v_teszt);
--dbms_output.put_line(c_sema||'     '||c_m003||'      '||v_beta);
--p11 kiszámítás

v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);  
    /*2015v: külön adat*/                                                            
    /*2015e: ebben még nem volt*/
    --ED 20170327                                                                
v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111
v_j.p_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC002', v_year, v_verzio, v_teszt);

                                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);
v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC004', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);
v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC142', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC145', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 :=  0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 - v_j.p_1112 - v_j.p_1113;
                                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--******************************************************************************
--********************* !!!!!!!!!!!!! NÉZZ MEG !!!!!!!!!!!! ********************
--p112
-- itt egy kétszeri összeadás van.
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC007', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC108', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC109', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC131', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC117', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC120', v_year, v_verzio, v_teszt);
v_j.p_1121 := v_j.p_1121 + 
              (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC069', v_year, v_verzio, v_teszt)
               - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC133', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC070', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC071', v_year, v_verzio, v_teszt))
               * v_beta;
v_j.p_1121 := v_j.p_1121 - 
              (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC122', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC134', v_year, v_verzio, v_teszt)) 
              * v_beta;

--v_j.p_1121 := 92248256 / 122431183 * v_j.p_1121;
--v_j.p_1121 := 90361902 / 130437906 * v_j.p_1121; -- új számláló 2017.09.15
v_j.p_1121 := 90418096 / 130437906 * v_j.p_1121; -- új számláló 2018.09.12


/* P1121 nél első futtatáskor araányt törölni, 
   és az így kapott szám megy a nevezőbe, és Gábor ad kitevőt hozzá
   - azt kell végül megkapni amit ad!*/
                                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

--******************************************************************************
--******************************************************************************

--v_j.p_1122 := 0; /*  HIBÁS!!!!  2017.09.05.  */

v_j.p_1122 := (1-J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBBOM001', v_year, v_verzio, v_teszt)
               / (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBBOM001', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBBOM807', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBBOM844', v_year, v_verzio, v_teszt)))
               * 1000000;

                                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003,'P_1123', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1123 := p.v;
ELSE
v_j.p_1123 := p.v;
END IF;
J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121 * v_j.p_1122 / 1000000 - v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC017', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC136', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC139', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);


--p_115
-- A biztosítói eredménykimutatásban megszüntették a PXC147 mutatót,
-- nem pótoljuk mással
-- ed 2017.09.13
v_j.p_1151 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC110', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC033', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC036', v_year, v_verzio, v_teszt)
              /*+ J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC147')*/
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC149', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC152', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC112', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003,'P_1152', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1152 := p.v;
ELSE
v_j.p_1152 := p.v;
END IF;
J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 + v_j.p_1152;
                                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC014', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_116 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.116+P.118*/
            /*2015e: P.111+P.112-P.113-P.115+P.116*/
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); 
                                                                --ED 20170327
--p12 kiszámítás
v_j.p_1212 := 0;    	            J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_1221 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122;  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003,'P_1365', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1365 := p.v;
ELSE
v_j.p_1365 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003,'P_1367', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1367 := p.v;
ELSE
v_j.p_1367 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 
             + v_j.p_1366 + v_j.p_1367;
                                    J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;            J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131;  J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003,'P_14', v_betoltes); 
IF p.f = 2 THEN
v_j.p_14 := p.v;
ELSE

v_j.p_14 := J_KETTOS_FUGG_T.p_14(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta+p.v;
END IF;
J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);

v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(PRJA045,0)') * J_KONST_T.P_15_TERM_SZORZO;
--v_j.p_15 := J_SELECT_T.MESG_SZAMOK(c_sema, c_m003,'NVL(PRJA045,0)') * 0.3356;
            /**/
            /*(1508A-01-01/02c)*0,3356*ß  (előzetes sémában előző évi TÁSA számok)*/
            /*régebben: (1508A-01-01/02c)*0,0691*ß  (előzetes sémában 
              előző évi TÁSA számok)*/
                                    /*0.0691 volt, átírva 2017.04.27*/
                                    J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);

v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(PRJA045,0)') * J_KONST_T.P_16_TERM_SZORZO;
--v_j.p_16 := J_SELECT_T.MESG_SZAMOK(c_sema, c_m003,'NVL(PRJA045,0)') * 0.5787;
                                    /*1.4548 volt, átírva 2017.04.27*/
            /*(1508A-01-01/02c)*0,5787*ß  (előzetes sémában 
              előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_KETTOS_FUGG_T.p_21(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;   
                                    J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
v_j.p_22 := J_KETTOS_FUGG_T.p_22(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := J_KETTOS_FUGG_T.p_2331(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := J_KETTOS_FUGG_T.p_231(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta; 
                                    J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003,'P_232', v_betoltes); 
IF p.f = 2 THEN
v_j.p_232 := p.v;
ELSE
v_j.p_232 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := J_KETTOS_FUGG_T.p_2321(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := v_j.p_2331 - v_j.p_231 - v_j.p_2321;
                                    J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);
v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                    J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC063', v_year, v_verzio, v_teszt)
            + (J_KETTOS_FUGG_T.P_24(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta);
                                    J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := J_KETTOS_FUGG_T.p_262(c_sema, c_m003, v_year, v_verzio, v_teszt) * J_KONST_T.P_262_TERM_SZORZO * v_beta;
--v_j.p_262 := J_KETTOS_FUGG_T.p_262(c_sema, c_m003) * 0.05 * v_beta;
             /*2015v: D.11121*0,05*/
             /*2015e: D.11121*0,0379*/
             /*0.0379 volt, átírva 2017.04.27*/
             /*D.11121*0,05*/
                                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0; /*2017.04.27*/
                /*2015v: 0*/
                /*2015e: (1529-A-02-01/12a)*ß első 'a' oszlop + egyedi korrekció*/
--v_j.p_27 := J_KETTOS_FUGG_T.p_27(c_sema, c_m003)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);

v_j.p_28 := J_SELECT_T.bizt_viszont(c_sema, c_m003, v_year, v_verzio, v_betoltes, v_teszt) + v_j.p_1123;
                                    --2010-es adat. 3118628/20 + v_j.p_1123;        
                                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;/*KÜLÖN ADAT*/       J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003,'P_292', v_betoltes); 
IF p.f = 2 THEN
v_j.p_292 := p.v;
ELSE
v_j.p_292 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
            /*2015v: külön adat*/
                                                                -- ED 20170327
v_j.p_29 := v_j.p_291 + v_j.p_292 + v_j.p_293;
            /*2015v: P.291+P.292+P.293*/
            /*2015e: P.291+292*/
                                    J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);
                                                                -- ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27 
           + v_j.p_28 + v_j.p_29; 
                                    J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;      J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003,'K_1', v_betoltes); 
IF p.f = 2 THEN
v_j.K_1 := p.v;
ELSE
v_j.K_1 := J_KETTOS_FUGG_T.k_1(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta - v_j.p_27 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;     J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;            J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214D);
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

v_j.d_21 := v_j.d_214 + v_j.d_211 + v_j.d_212;
                                    J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                  J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;          J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;       
                                    J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;  J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

--d_111
v_j.d_1111 := J_KETTOS_FUGG_T.d_1111(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_KETTOS_FUGG_T.d_11121(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0*v_beta;/*KÜLÖN ADAT*/
                                    J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);

v_j.d_11123 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema,
                                    c_m003,
                                    'NVL(LALA064,0)+NVL(LALA072,0)+NVL(LALA045,0)')
               * v_beta - v_j.d_11124;
                                    J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_11125', v_betoltes); 
IF p.f = 2 THEN
v_j.d_11125 := p.v;
ELSE
v_j.d_11125 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(LALA026,0)')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);

v_j.d_11126 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(LALA056,0)')*v_beta;        
                                    J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);

/*
P := J_KORR_T.korr_fugg(c_sema, c_m003, 'D_11127'); 
IF p.f = 2 THEN
v_j.d_11127 := p.v;
ELSE
v_j.d_11127 := J_KETTOS_FUGG_T.d_11127(c_sema, c_m003)*v_beta+p.v;
END IF;
*/
-- 2017-ben a 2015 végl.-től kijavítootuk az adatbetöltést, nincs korrekció
-- ed 2017.09.13
v_j.d_11127 := J_KETTOS_FUGG_T.d_11127(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;

                                    J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(LALA044,0)')*v_beta;        
                                    J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(LALA135,0)')*v_beta;        
                                    J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- bekerült a d.11124: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125 
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129 
              - v_j.d_11130 - v_j.d_11131;
                                    J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                    J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16
              + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(PRJA045,0)')
              * J_KONST_T.D_1121_TERM_SZORZO * v_beta; /*0.4641 volt a szorzó, átírva 2017.04.27
--v_j.d_1121 := v_j.p_16
--              + J_SELECT_T.MESG_SZAMOK(c_sema, c_m003,'NVL(PRJA045,0)')
--              * 0.3525 * v_beta; /*0.4641 volt a szorzó, átírva 2017.04.27*/
              /*2015v: P.16+{(1508A-01-01/02c)*0,3525}*ß (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+{(1508A-01-01/02c)*0,4641}*ß (előzetes sémában előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);

v_j.d_1122 := v_j.p_15;             J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);

/* {{(1608A-01-01/06c)/0,1785}*0,5}*ß PRJA088*/
v_j.d_1123 := J_KETTOS_FUGG_T.d_1123(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);

v_j.d_1124 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;          J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;          J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;          J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;          J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125 
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                    J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;  J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;--2013.0909 J_KETTOS_FUGG_T.d_1212(c_sema, c_m003)*v_beta;
                                    /*ADAT HIÁNYÁBAN V_J.D_111*0.03*/ 
                                    J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_1211', v_betoltes); 
IF p.f = 2 THEN
v_j.d_1211 := p.v;
ELSE
v_j.d_1211 := J_KETTOS_FUGG_T.D_1211(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta 
              - (J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'LALA175') /*2014-ben LALA173*/
                 + J_KETTOS_FUGG_T.D_29C2(c_sema, c_m003, v_year, v_verzio, v_teszt)) 
              + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
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

v_j.d_29C1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'LALA175') * v_beta;
                                --J_KETTOS_FUGG_T.d_29c1(c_sema, c_m003)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := J_KETTOS_FUGG_T.d_29c2(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta; --2017.09.13
                                    J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_29B1', v_betoltes); 
IF p.f = 2 THEN
v_j.d_29b1 := p.v;
ELSE

v_j.d_29b1 := J_KETTOS_FUGG_T.D_29B1(c_sema, c_m003, '', v_year, v_verzio, v_teszt)*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_29B3', v_betoltes); 
IF p.f = 2 THEN
v_j.d_29b3 := p.v;
ELSE
v_j.d_29b3 := J_KETTOS_FUGG_T.D_29B3(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                    J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                    J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/ 
                                    J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;/*KÜLÖN ADAT */     J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;/*KÜLÖN ADAT */     J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 
            + v_j.d_29E3;
                                    J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */     J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;            J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                    J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;            J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                    J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);

------------D.42-------

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_41211', v_betoltes); 
IF p.f = 2 THEN
v_j.d_41211 := p.v;
ELSE
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC010', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC070', v_year, v_verzio, v_teszt) * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC009', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC071', v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_412132', v_betoltes); 
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

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_41221', v_betoltes); 
IF p.f = 2 THEN
v_j.d_41221 := p.v;
ELSE
v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC117', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC122', v_year, v_verzio, v_teszt) * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);
v_j.d_41222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_412231', v_betoltes); 
IF p.f = 2 THEN
v_j.d_412231 := 0+p.v;/*KÜLÖN ADAT */         
ELSE
v_j.d_412231 := 0+p.v;/*KÜLÖN ADAT */         
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_412232', v_betoltes); 
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
v_j.d_413 := v_j.d_1123;            J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;  J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_421');
                                    J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); 
                                                                --2009-es adat

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_4221', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4221 := p.v;
ELSE
v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4221')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_4222', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4222 := p.v;
ELSE
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4222')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_4223', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4223 := p.v;
ELSE
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4223')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_4224', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4224 := p.v;
ELSE
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4224')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_4225', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4225 := p.v;
ELSE
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4225')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_4226', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4226 := p.v;
ELSE
v_j.d_4226 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4226')*v_beta+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                    J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422;  J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_44132', v_betoltes); 
IF p.f = 2 THEN
v_j.d_44132 := p.v;
ELSE
v_j.d_44132 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);
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
v_j.d_4421 := v_j.p_112;            J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                    J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);



v_j.d_44 := v_j.d_441 - v_j.d_442;  J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
-----------------D.4---------------

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_431', v_betoltes); 
IF p.f = 2 THEN
v_j.d_431 := 0+p.v;/*KÜLÖN ADAT MNB */
ELSE
v_j.d_431 := 0+p.v;/*KÜLÖN ADAT MNB */
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_432', v_betoltes); 
IF p.f = 2 THEN
v_j.d_432 := 0+p.v;
ELSE
v_j.d_432 := 0+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);

v_j.d_43 := v_j.d_431 - v_j.d_432;  J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;                    
                                  --J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := J_KETTOS_FUGG_T.d_45(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;    
                                    J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
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
v_j.b_5g := v_j.b_2g + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------

p := J_KORR_T.korr_fugg(v_year, c_sema, c_m003, 'D_51B11', v_betoltes); 
IF p.f = 2 THEN
v_j.d_51B11 := p.v;
ELSE
v_j.d_51B11 := J_KETTOS_FUGG_T.d_51b11(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta+p.v;
END IF;

                                    J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
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

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
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


v_j.d_7511 := J_KETTOS_FUGG_T.d_7511(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */   J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                    J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                    J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515; 
                                    J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := J_KETTOS_FUGG_T.d_7522(c_sema, c_m003, v_year, v_verzio, v_teszt)*v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7524 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT koRMÁNYZAT */
                                    J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                    J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                    J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751 - v_j.d_752;  J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 
            + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 
            + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := 0;                       J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END BIZT_INTEZET_E;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-------------------BÍZTOSÍTÓ EGYESÜLET TELJES BESZÁMOLÓ(ÉLET)-------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PROCEDURE BIZT_EGY_TELJES_E(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 c_d1111 NUMBER(20,3);
 v_beta NUMBER(15,3);
 p PAIR;
BEGIN

p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  
v_beta := J_SELECT_T.BIZT_BETA(c_m003, v_year, v_verzio, v_betoltes, v_teszt);
--dbms_output.put_line(c_sema||'     '||c_m003||'      '||v_beta);
c_d1111 := J_SELECT_T.BIZT_D1111('E', v_year, v_betoltes, v_verzio, v_teszt);

--------------D.1 kiszámítása
--d_111
v_j.d_1111 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC019', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC052', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC054', v_year, v_verzio, v_teszt)) * c_d1111;
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);
v_j.d_11123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(LALA044,0)');        
                                    J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(LALA135,0)');        
                                    J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- bekerült d.11124: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125 
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129 
              - v_j.d_11130 - v_j.d_11131;
                                    J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                    J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.p_15 := 0;
v_j.p_16 := 0;
-- itt p.15, p.16 teljesen 0.
v_j.p_262 := v_j.d_11121 * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := v_j.d_11121 * 0.05; /*0.0207 volt, átírva 2017.04.27*/
             /*2015v: D.11121*0,05*/
             /*2015e: D.11121*0,0379*/ 
                                 /*D.11121*0,05*/
                                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);

v_j.d_1121 := v_j.p_16
              + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003,'NVL(PRJA045,0)')
              * J_KONST_T.D_1121_TERM_SZORZO * v_beta; /*0.4641 volt a szorzó, átírva 2017.04.27
--v_j.d_1121 := v_j.p_16
--              + J_SELECT_T.MESG_SZAMOK(c_sema, c_m003,'NVL(PRJA045,0)')
--              * 0.3525 * v_beta; /*0.4641 volt a szorzó, átírva 2017.04.27*/
              /*2015v: P.16+{(1408-01-01/02c)*0,3525}*ß (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+{(1408-01-01/02c)*0,4641}*ß (előzetes sémában előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);

v_j.d_1122 := v_j.p_15;             J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;          J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;          J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;          J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;          J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125 
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                    J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);
--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;  J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := v_j.d_111*0.27;       J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
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


v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
    /*2015v: külön adat*/
    /*2015e: ebben még nem volt*/

--p11 kiszámítás
v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111
v_j.p_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC002', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);
v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC004', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);
v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC142', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC145', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 :=  0;   	            J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 - v_j.p_1112 - v_j.p_1113;
                                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC007', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC108', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC109', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC131', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC117', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC120', v_year, v_verzio, v_teszt);

v_j.p_1121 := v_j.p_1121 + 
                  (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC069', v_year, v_verzio, v_teszt)
                 - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC133', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC070', v_year, v_verzio, v_teszt)
                 + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC071', v_year, v_verzio, v_teszt))
              * v_beta;

v_j.p_1121 := v_j.p_1121 - 
              ((J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC122', v_year, v_verzio, v_teszt)
               - J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC134', v_year, v_verzio, v_teszt))) * v_beta;

                                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

v_j.p_1122 := 1;                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121*v_j.p_1122 + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC017', v_year, v_verzio, v_teszt);    	 
                                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC136', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC139', v_year, v_verzio, v_teszt); 
                                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p_115
-- A biztosítói eredménykimutatásban megszüntették a PXC147 mutatót,
-- nem pótoljuk mással
-- ed 2017.09.13
v_j.p_1151 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC110', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC033', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC036', v_year, v_verzio, v_teszt)
              /*+ J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC147')*/
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC149', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC152', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC112', v_year, v_verzio, v_teszt);              
                    	 	        J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);

v_j.p_1152 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 + v_j.p_1152;
                                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC014', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 +
            v_j.p_116 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.116+P.118*/
            /*2015e: P.111+P.112-P.113-P.115+P.116*/
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);
--p12 kiszámítás
v_j.p_1212 := 0;    	            J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_1221 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122;  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 
             + v_j.p_1366 + v_j.p_1367;
                                    J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;            J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131;  J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC019', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC052', v_year, v_verzio, v_teszt)
             + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC054', v_year, v_verzio, v_teszt)) - v_j.d_1 * v_beta;

                                    J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
v_j.p_22 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);
v_j.p_232 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);
v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                    J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PXC063', v_year, v_verzio, v_teszt);    
                                    J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
/*v_j.p_262 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);*/
v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
    /*2015e/v: 0*/
v_j.p_28 := J_SELECT_T.BIZT_VISZONT(c_sema, c_m003 , v_year, v_verzio, v_betoltes, v_teszt) + v_j.p_1123;  
                                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);
v_j.p_292 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_29 := v_j.p_292 + v_j.p_291;  J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);
             /*2015e/v: 0*/

v_j.p_293 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
             /*2015v: külön adat*/

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27 
           + v_j.p_28 + v_j.p_29; 
                                    J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;      J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := 0;                       J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;     J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);


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

v_j.d_21 := v_j.d_214 + v_j.d_211 + v_j.d_212;
                                    J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 :=  0  ;                  J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;          J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                    J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;  J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);

------------D.29

v_j.d_29C1 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

-- v_j.d_29b1 := 0;                            
v_j.d_29b1 := J_KETTOS_FUGG_T.D_29B1(c_sema, c_m003, '', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
-- v_j.d_29b3 := 0;                            
v_j.d_29b3 := J_KETTOS_FUGG_T.D_29B3(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);

v_j.d_29A11 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 
            + v_j.d_29E3;
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
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC010', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC070', v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC009', v_year, v_verzio, v_teszt) 
                + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC071', v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);
v_j.d_412132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                    J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 ;
                                    J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41221', v_betoltes); 
IF p.f = 2 THEN
 v_j.d_41221 := p.v;
ELSE
 v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC117', v_year, v_verzio, v_teszt)
                + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC122', v_year, v_verzio, v_teszt) * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);
v_j.d_41222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);
v_j.d_412232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232; 
                                    J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223; 
                                    J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                    J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;            J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;  
                                    J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42
v_j.d_421 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_421');
                                    J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); 
                                                                --2009-es adat


v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4221');
                                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4222');
                                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4223');
                                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4224');
                                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4225');                 
                                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

v_j.d_422 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422;  J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

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
v_j.d_4421 := v_j.p_112;            J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                    J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);



v_j.d_44 := v_j.d_441 - v_j.d_442;  J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);

-----------------D.4---------------
v_j.d_431 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
v_j.d_432 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431 - v_j.d_432;  J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;
                                  --J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
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
v_j.b_5g := v_j.b_2g + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC095', v_year, v_verzio, v_teszt);
-- v_j.d_51B11 := 0;                         
J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC095', v_year, v_verzio, v_teszt);   
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

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC; 
                                    J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                    J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61 - v_j.d_62;     J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722;  J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */   J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                    J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
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
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 
            + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 
            + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := 0;                       J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END BIZT_EGY_TELJES_E;


end J_A_BIZT_E_T;