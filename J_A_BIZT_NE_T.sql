/*
create or replace PACKAGE        "J_A_BIZT_NE_T" as 

--14  --BÍZTOSÍTÓ INTÉZET            (NEM ÉLET)
--15  --BÍZTOSÍTÓ EGYYESÜLET TELJES  (NEM ÉLET)
--16  --BÍZTOSÍTÓ EGYYESÜLET EGYSZER (NEM ÉLET)
--17  --BÍZTOSÍTÓ FIÓKTELEPEI        (NEM ÉLET)

-- 6512-1 Biztosítóintézetek nem-élet
PROCEDURE BIZT_INTEZET_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2); 
-- 6512-2 BIZTOSÍTÓ EGYESÜLET TELJES BESZÁMOLÓ(NEM ÉLET)
PROCEDURE BIZT_EGY_TELJES_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2);
-- 6512-3 BIZTOSÍTÓ EGYESÜLET EGYSZERŰSÍTETT BESZÁMOLÓ(nem ÉLET)
PROCEDURE BIZT_EGY_EGYSZERU_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2);
-- 6512-4,5 BIZTOSÍTÓ FIÓKTELEP BESZÁMOLÓ(NEM ÉLET)
PROCEDURE BIZT_FIOK_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2); 

end J_A_BIZT_NE_T;
*/




create or replace PACKAGE BODY        "J_A_BIZT_NE_T" as

-- 6512-1 Biztosítóintézetek nem-élet
PROCEDURE BIZT_INTEZET_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 v_beta NUMBER(15, 10);
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);
v_beta := J_SELECT_T.BIZT_BETA(c_m003, v_year, v_verzio, v_betoltes, v_teszt);

IF v_beta = 1
 THEN v_beta := 1;
 ELSE v_beta := (1 - v_beta);
END IF;

--p11 kiszámítás

v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); 
             /*2015v: külön adat*/
                                                                -- ED 20170327
v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1111', v_betoltes); 
IF p.f = 2 THEN
 v_j.p_1111 := p.v;
ELSE
 v_j.p_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC002', v_year, v_verzio, v_teszt) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);

v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC004', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);                                    
v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC142', v_year, v_verzio, v_teszt) 
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC145', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);

v_j.p_1114 := 0;   	                J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 - v_j.p_1112 - v_j.p_1113;
                                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC069', v_year, v_verzio, v_teszt)
               - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC133', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC070', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC071', v_year, v_verzio, v_teszt)) * v_beta;

v_j.p_1121 := v_j.p_1121
                - (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC122', v_year, v_verzio, v_teszt) 
                   - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC134', v_year, v_verzio, v_teszt)) 
                * v_beta;
v_j.p_1121 := v_j.p_1121;--J_KORR_T.KORR_FUGG(c_sema, c_m003, 'P_1121');

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1121', v_betoltes); 
IF p.f = 2 THEN
 v_j.p_1121 := p.v;
ELSE
 v_j.p_1121 := v_j.p_1121 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

IF J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM001', v_year, v_verzio, v_teszt) 
   + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM807', v_year, v_verzio, v_teszt) 
   + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM844', v_year, v_verzio, v_teszt) = 0
THEN v_j.p_1122 := 0;
ELSE  
  v_j.p_1122 := (1 - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM001', v_year, v_verzio, v_teszt) 
                 / (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM001', v_year, v_verzio, v_teszt) 
                 + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM807', v_year, v_verzio, v_teszt) 
                 + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBBOM844', v_year, v_verzio, v_teszt))
                ) * 100000;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);


v_j.p_1123 := 0;--J_KORR_T.KORR_FUGG(c_sema, c_m003, 'P_1123');   
                                    J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

--DIREKT P_1121-et használtunk!!! 2015-12-07

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1121', v_betoltes); 
IF p.f = 1 THEN
 v_j.p_112 := ((v_j.p_1121-p.v) * v_j.p_1122 / 100000 - v_j.p_1123) + p.v;
ELSIF p.f = 2 THEN
 v_j.p_112 := p.v;
ELSE
 v_j.p_112 := v_j.p_1121 * v_j.p_1122 / 100000 - v_j.p_1123;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1131', v_betoltes); 
IF p.f = 2 THEN
 v_j.p_1131 := p.v;
ELSE
 v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC017', v_year, v_verzio, v_teszt) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);

v_j.p_1132 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC136', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC139', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC028', v_year, v_verzio, v_teszt);

                                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);
v_j.p_113 := v_j.p_1131 + v_j.p_1132; 
                                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);


--p_115
-- töröltem pbc147-et: 2017.09.13
v_j.p_1151 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC033', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC036', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC039', v_year, v_verzio, v_teszt)
              /*+ J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC147')*/
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC149', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC152', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);

v_j.p_1152 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 + v_j.p_1152;
                                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_116', v_betoltes); 
IF p.f = 2 THEN
 v_j.p_116 := p.v;
ELSE
 v_j.p_116 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC014', v_year, v_verzio, v_teszt) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_116 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.116+P118*/
            /*2015e: P.111+P.112-P.113-P.115+P.116*/
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); 
                                                                -- ED 20170327
--p12 kiszámítás
v_j.p_1221 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122;  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1362', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1362 := 0 + p.v; 
ELSE
v_j.p_1362 := 0 + p.v; 
END IF;
J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);

v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1365', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1365 := p.v;
ELSE
v_j.p_1365 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1366', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1366 := 0 + p.v;  
ELSE
v_j.p_1366 := 0 + p.v;  
END IF;
J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1367', v_betoltes); 
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
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_14', v_betoltes); 
IF p.f = 2 THEN 
 v_j.p_14 := p.v;
ELSE
 v_j.p_14 := J_KETTOS_FUGG_T.P_14(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);

v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)')
            * J_KONST_T.P_15_TERM_SZORZO * v_beta;
--v_j.p_15 := J_SELECT_T.MESG_SZAMOK(c_sema, c_m003, 'NVL(PRJA045,0)')
--            * 0.3356 * v_beta; -- 0.0691 volt 2017.04.27
            /*2015v: (1508A-01-01/02c)*0,3356*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*0,0691*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)')
            * J_KONST_T.P_16_TERM_SZORZO * v_beta;
--v_j.p_16 := J_SELECT_T.MESG_SZAMOK(c_sema, c_m003, 'NVL(PRJA045,0)')
--            * 0.5787 * v_beta; -- 1.4548 volt 2017.04.27
            /*2015v: (1508A-01-01/02c)*0,5787*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*1,4548*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_KETTOS_FUGG_T.P_21(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;   
                                    J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);

v_j.p_22 := J_KETTOS_FUGG_T.P_22(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := J_KETTOS_FUGG_T.P_2331(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := J_KETTOS_FUGG_T.P_231(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_232', v_betoltes); 
IF p.f = 2 THEN 
v_j.p_232 := p.v;
ELSE
v_j.p_232 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);

v_j.p_2321 := J_KETTOS_FUGG_T.P_2321(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);

v_j.p_2322 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := v_j.p_2331 - v_j.p_231 - v_j.p_2321;
                                    J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);
v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                    J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PBC063', v_year, v_verzio, v_teszt)
            + (J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PRCA092', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003,'PRCA091', v_year, v_verzio, v_teszt)) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := J_KETTOS_FUGG_T.P_262(c_sema, c_m003, v_year, v_verzio, v_teszt) * J_KONST_T.P_262_TERM_SZORZO * v_beta; /*0.0379 volt 2017.04.27*/
--v_j.p_262 := J_KETTOS_FUGG_T.P_262(c_sema, c_m003) * 0.05 * v_beta; /*0.0379 volt 2017.04.27*/
            /*2015v: D.11121*0,05*/
            /*2015e: D.11121*0,0379*/
                                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0; /*2017.04.27*/
            /*2015v: 0*/
            /*2015e: (1529-A-02-01/12a)*(1-ß) első 'a' oszlop + egyedi korrekció*/
--v_j.p_27 := J_KETTOS_FUGG_T.P_27(c_sema, c_m003) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);

v_j.p_28 := J_SELECT_T.bizt_viszont(c_sema, c_m003, v_year, v_verzio, v_betoltes, v_teszt) + v_j.p_1123; 
                                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_292', v_betoltes); 
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
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24  - v_j.p_26 + v_j.p_27 
           + v_j.p_28 + v_j.p_29; 
                                    J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);

-------------------------------B.1g kiszámítása-------------------------------------
v_j.b_1g := v_j.p_1 - v_j.p_2;      J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'K_1', v_betoltes); 
IF p.f = 2 THEN
v_j.K_1 := p.v;
ELSE
v_j.K_1 := J_KETTOS_FUGG_T.k_1(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta - v_j.p_27+p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
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
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;  
                                    J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 := 0  ;                   J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;          J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192; --?
                                    J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);

v_j.d_31 := v_j.d_319 + v_j.d_312;  J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);

--------------D.1 kiszámítása

--d_111

v_j.d_1111 := J_KETTOS_FUGG_T.D_1111(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_KETTOS_FUGG_T.D_11121(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);



v_j.d_11123 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema,
                                    c_m003,
                                    'NVL(LALA064,0)+NVL(LALA072,0)+NVL(LALA045,0)')
                * v_beta - v_j.d_11124;
                                    J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11125', v_betoltes); 
IF p.f = 2 THEN
v_j.d_11125 := p.v;
ELSE
v_j.d_11125 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA026,0)') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA056,0)') * v_beta;        
                                    J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);

/*p := J_KORR_T.KORR_FUGG(c_sema, c_m003, 'D_11127'); 
IF p.f = 2 THEN
v_j.d_11127 := p.v;
ELSE
v_j.d_11127 := J_KETTOS_FUGG_T.D_11127(c_sema, c_m003) * v_beta + p.v;
END IF;*/

-- korábban korrekcióval ment, most sima. 2017.09.13
v_j.d_11127 := J_KETTOS_FUGG_T.D_11127(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta; /* * 0.5? */
                                    J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA044,0)') * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA135,0)') * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- bekerült d_11124: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125 
              - v_j.d_11126 - v_j.d_11127- v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                    J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                    J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)')
               * J_KONST_T.D_1121_TERM_SZORZO * v_beta; /*0.4641 volt 2017.04.27*/
--v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(c_sema, c_m003, 'NVL(PRJA045,0)')
--               * 0.3525 * v_beta; /*0.4641 volt 2017.04.27*/
              /*2015v: P.16+{(1508A-01-01/02c)*0,3525}*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+{(1508A-01-01/02c)*0,4641}*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;             J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := J_KETTOS_FUGG_T.D_1123(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
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
v_j.d_1212 := 0;--2013.09.09   J_KETTOS_FUGG_T.D_1212(c_sema, c_m003) * v_beta; 
                                    J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_1211', v_betoltes); 
IF p.f = 2 THEN
v_j.d_1211 := p.v;
ELSE
v_j.d_1211 := J_KETTOS_FUGG_T.D_1211(c_sema, c_m003, v_year, v_verzio, v_teszt)*(1-v_beta)
              - (J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'LALA175')
              + J_KETTOS_FUGG_T.D_29c2(c_sema, c_m003, v_year, v_verzio, v_teszt)) * v_beta + p.v;
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

v_j.d_29C1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'LALA175') * v_beta;
                            --J_KETTOS_FUGG_T.D_29c1(c_sema, c_m003) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := J_KETTOS_FUGG_T.D_29c2(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B1', v_betoltes); 
IF p.f = 2 THEN
 v_j.d_29b1 := p.v;
ELSE
 -- v_j.d_29b1 := p.v;
 v_j.d_29b1 := J_KETTOS_FUGG_T.D_29b1(c_sema, c_m003, '', v_year, v_verzio, v_teszt);
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B3', v_betoltes); 
IF p.f = 2 THEN
 v_j.d_29b3 := p.v;
ELSE
 -- v_j.d_29b3 := p.v;
 v_j.d_29b3 := J_KETTOS_FUGG_T.D_29b3(c_sema, c_m003, v_year, v_verzio, v_teszt);
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

--------------------------------B.2G-------------------------------------------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;                                       
                                    J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41211', v_betoltes); 
IF p.f = 2 THEN
v_j.d_41211 := p.v;
ELSE
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC070', v_year, v_verzio, v_teszt) * v_beta + p.v; 
END IF;

                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC071', v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412132', v_betoltes); 
IF p.f = 2 THEN
v_j.d_412132 := p.v;
ELSE
v_j.d_412132 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                    J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 ;
                                    J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41221', v_betoltes); 
IF p.f = 2 THEN
v_j.d_41221 := p.v;
ELSE
v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC122', v_year, v_verzio, v_teszt) * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);
v_j.d_41222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412232', v_betoltes); 
IF p.f = 2 THEN
v_j.d_412232 := 0 + p.v;
ELSE
v_j.d_412232 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231 - v_j.d_412232;
                                    J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                    J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                    J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;            J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;  J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);

--d42
v_j.d_421 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC069', v_year, v_verzio, v_teszt);
                            --J_SELECT_T.MESG_SZAMOK(c_sema, c_m003, 'D_421');
                                    J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); 

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4221', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4221 := p.v;
ELSE
v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4221') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4222', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4222 := p.v;
ELSE
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4222') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4223', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4223 := p.v;
ELSE
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4223') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4224', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4224 := p.v;
ELSE
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4224') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4225', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4225 := p.v;
ELSE
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4225') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4226', v_betoltes); 
IF p.f = 2 THEN
v_j.d_4226 := p.v;
ELSE
v_j.d_4226 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'D_4226') * v_beta + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);


v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                    J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422;  J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_44132', v_betoltes); 
IF p.f = 2 THEN
v_j.d_44132 := 0 + p.v;
ELSE
v_j.d_44132 := 0 + p.v;
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
v_j.d_431 := 0;/*KÜLÖN ADAT MNB */  J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_432', v_betoltes); 
IF p.f = 2 THEN
v_j.d_432 := 0 + p.v;/*KÜLÖN ADAT MNB */
ELSE
v_j.d_432 := 0 + p.v;/*KÜLÖN ADAT MNB */
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);


v_j.d_43 := v_j.d_431 - v_j.d_432;  J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443; 
                                -- J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := J_KETTOS_FUGG_T.D_45(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46;
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
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_51B11', v_betoltes); 
IF p.f = 2 THEN
v_j.d_51B11 := p.v;
ELSE
v_j.d_51B11 := J_KETTOS_FUGG_T.D_51b11(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta + p.v;
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
v_j.d_711 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                    J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722;  J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := J_KETTOS_FUGG_T.D_7511(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
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
v_j.d_7522 := J_KETTOS_FUGG_T.D_7522(c_sema, c_m003, v_year, v_verzio, v_teszt) * v_beta;
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

END BIZT_INTEZET_NE;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--------------------BIZTOSÍTÓ EGYESÜLET TELJES BESZÁMOLÓ(NEM ÉLET)--------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- 6512-2
PROCEDURE BIZT_EGY_TELJES_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 c_d1111 NUMBER(20,3);
 v_beta NUMBER(5,0);
 test1 NUMBER;
 test2 NUMBER;
 test3 NUMBER;
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  
c_d1111 := J_SELECT_T.BIZT_D1111('NE', v_year, v_betoltes, v_verzio, v_teszt);

--Ezeket semmiképpen sem szabad BÉTÁZNI (még akkor sem ha ez van a sémában),
-- mert ide nem küldünk BÉA értéket
--és a NULL miatt elszáll az egeész számítás!!!! 2014-03-19

--------------D.1 kiszámítása
--d_111
v_j.d_1111 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC019', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC052', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC054', v_year, v_verzio, v_teszt)) * c_d1111;
--dbms_output.put_line('d_1111: ' || v_j.d_1111);
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);

v_j.d_11123 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA044,0)');
--dbms_output.put_line('d_11130: ' || v_j.d_11130);
                                    J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA135,0)');
--dbms_output.put_line('d_11130: ' || v_j.d_11130);
                                    J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);

-- bekerült d.11124: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125 
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
--dbms_output.put_line('d_1112: ' || v_j.d_1112);
                                    J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
--dbms_output.put_line('d_111: ' || v_j.d_111);
                                    J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.p_15 := 0;
            /*2015e,v: 0*/
v_j.p_16 := 0;
            /*2015e,v: 0*/
-- p.15, p.16 teljesen 0.
v_j.p_262 := v_j.d_11121 * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := v_j.d_11121 * 0.05; /* 0.0379 volt 2017.04.27 */
            /*2015v: D.11121*0,05*/
            /*2015e: D.11121*0,0379*/

test1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)');
--dbms_output.put_line('test1: ' || test1);
--dbms_output.put_line('beta: ' || v_beta);
v_j.d_1121 := v_j.p_16 + test1 * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 + test1 * 0.3525; /*0.4641 volt 2017.04.27*/
              /*2015v: P.16+{(1508A-01-01/02c)*0,3525}*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+{(1508A-01-01/02c)*0,4641}*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
                                         --*(1-v_beta); -- v_j.p_16+
--dbms_output.put_line('d_1121: ' || v_j.d_1121);
                                    J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;             J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;          J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;          J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;          J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;          J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 
             + v_j.d_1125 + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
--dbms_output.put_line('d_112: ' || v_j.d_112);
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



--p11 kiszámítás
v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); 
             /*2015v: külön adat*/
                                                                -- ED 20170327
v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111
v_j.p_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC002', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);

v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC004', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);

v_j.p_1113 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC142', v_year, v_verzio, v_teszt) 
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC145', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;   	                J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 - v_j.p_1112 - v_j.p_1113;
                                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC069', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC133', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC070', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC071', v_year, v_verzio, v_teszt);

v_j.p_1121 := v_j.p_1121
              - (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC122', v_year, v_verzio, v_teszt)
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC134', v_year, v_verzio, v_teszt));
v_j.p_1121 := v_j.p_1121;
                                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);

v_j.p_1122 := 1;
                                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121*v_j.p_1122 + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC017', v_year, v_verzio, v_teszt);    	 
                                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC136', v_year, v_verzio, v_teszt) 
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC139', v_year, v_verzio, v_teszt)
              + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC028', v_year, v_verzio, v_teszt); 
                                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p_115
v_j.p_1151 := 0;   	 	            J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 + v_j.p_1152;
                                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_116 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.116+P.118*/
            /*2015e: P.111+P.112-P.113-P.115+P.116*/
                                                                -- ED 20170327
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);
--p12 kiszámítás
v_j.p_1221 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122;  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1362', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1362 := 0 + p.v;
ELSE
v_j.p_1362 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);

v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1366', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1366 := 0 + p.v;
ELSE
v_j.p_1366 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);

v_j.p_1367 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

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
--dbms_output.put_line('p_1: ' || v_j.p_1);
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
test1 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC019', v_year, v_verzio, v_teszt);
test2 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC052', v_year, v_verzio, v_teszt);
test3 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC054', v_year, v_verzio, v_teszt);
v_j.p_21 := test1+test2+test3 - v_j.d_1;

-- v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC019') 
-- + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC052') 
-- + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC054')  - v_j.d_1;
--dbms_output.put_line('p_21a: ' || J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC019'));
--dbms_output.put_line('p_21b: ' || J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC052'));
--dbms_output.put_line('p_21c: ' || J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC054'));
--dbms_output.put_line('p_21: ' || v_j.p_21);
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
v_j.p_24 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := v_j.d_11121 * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := v_j.d_11121 * 0.05; /*0.0379 volt 2017.04.27*/
                                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
            /*2015v: 0*/
            /*2015e: -*/
v_j.p_28 := J_SELECT_T.bizt_viszont(c_sema, c_m003, v_year, v_verzio, v_betoltes, v_teszt) + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);
v_j.p_292 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); -- ED 20170327
            /*2015v: külön adat*/
v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
            /*2015e,v: 0*/
                                    J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   -- ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24  - v_j.p_26 + v_j.p_27 
            + v_j.p_28 + v_j.p_29; 
--dbms_output.put_line('p_2: ' || v_j.p_2);
                                    J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása

v_j.b_1g := v_j.p_1 - v_j.p_2; 
--dbms_output.put_line('B_1G: ' || v_j.b_1g);
J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := 0;                       J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g - v_j.K_1;     J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);


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
v_j.d_21 := v_j.d_214 + v_j.d_211 + v_j.d_212;
                                    J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 := 0  ;                   J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
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
v_j.d_29b1 := J_KETTOS_FUGG_T.D_29b1(c_sema, c_m003, '', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
-- v_j.d_29b3 := 0;                          
v_j.d_29b3 := J_KETTOS_FUGG_T.D_29b3(c_sema, c_m003, v_year, v_verzio, v_teszt);
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
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC070', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC071', v_year, v_verzio, v_teszt);
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
v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC122', v_year, v_verzio, v_teszt) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);
v_j.d_41222 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);
v_j.d_412232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231 - v_j.d_412232; 
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
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46; 
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
v_j.d_51B11 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC095', v_year, v_verzio, v_teszt);
-- v_j.d_51B11 := 0;
J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PBC095', v_year, v_verzio, v_teszt);   
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
v_j.d_711 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
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
END BIZT_EGY_TELJES_NE;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
----------------BIZTOSÍTÓ EGYESÜLET EGYSZERŰSÍTETT BESZÁMOLÓ(nem ÉLET)----------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- 6512-3
-- 16. séma
PROCEDURE BIZT_EGY_EGYSZERU_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 c_d1111 NUMBER(20, 3);
 v_beta NUMBER(15, 10);
 p PAIR;
BEGIN
p := PAIR.init;
v_beta := J_SELECT_T.BIZT_BETA(c_m003, v_year, v_verzio, v_betoltes, v_teszt);

IF v_beta = 1
 THEN v_beta := 1;
 ELSE v_beta := (1 - v_beta);
END IF;

v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  
c_d1111 := J_SELECT_T.BIZT_D1111('NE', v_year, v_betoltes, v_verzio, v_teszt);

--dbms_output.put_line(c_d1111);

--------------D.1 kiszámítása
--d_111
v_j.d_1111 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC011', v_year, v_verzio, v_teszt) 
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC020', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC022', v_year, v_verzio, v_teszt))
               * c_d1111;
v_j.d_1111 := v_j.d_1111; --+J_KORR_T.KORR_FUGG(c_sema, c_m003, 'D_1111');
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);

v_j.d_11123 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
v_j.d_11127 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
-- v_j.d_11130 := 0;                                  
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA044,0)') * v_beta;
                                    J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(LALA135,0)') * v_beta;
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
            /*2015e,v: 0*/
v_j.p_16 := 0;
            /*2015e,v: 0*/
-- itt p.15, p.16 teljesen 0.
v_j.p_262 := v_j.d_11121 * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := v_j.d_11121 * 0.05; /*0.0379 volt 2017.04.27*/
            /*2015v: D.11121*0,05*/
            /*2015e: D.11121*0,0379*/

v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)')
              * J_KONST_T.D_1121_TERM_SZORZO * v_beta;
--v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(c_sema, c_m003, 'NVL(PRJA045,0)')
--              * 0.3525 * v_beta; /*0.4641 volt 2017.04.27*/
              /*2015v: P.16+{(1508A-01-01/02c)*0,3525}*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+{(1508A-01-01/02c)*0,4641}*(1-ß) (előzetes sémában előző évi TÁSA számok)*/
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
v_j.d_1211 := v_j.d_111 * 0.27;
v_j.d_1211 := v_j.d_1211;--+J_KORR_T.KORR_FUGG(c_sema, c_m003, 'D_1211');
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



--p11 kiszámítás
v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); 
             /*2015v: külön adat*/
                                                                 --ED 20170327

v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111
v_j.p_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC002', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);

--ez a rossz, ami volt:
--v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC052');
                                    J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_1112);
--ez kéne legyen:
v_j.p_1112 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC052', v_year, v_verzio, v_teszt);--PBC004?
                                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112); -- véletlenül P_11112 volt! 2017.08.22

v_j.p_1113 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;   	                J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);


v_j.p_111 := v_j.p_1111 - v_j.p_1112 - v_j.p_1113;
                                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);


--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC004', v_year, v_verzio, v_teszt) 
              - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC024', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 1;
                                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121*v_j.p_1122 + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
v_j.p_1131 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC009', v_year, v_verzio, v_teszt);    	 
                                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC014', v_year, v_verzio, v_teszt); 
                                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p_115
v_j.p_1151 := 0;   	 	            J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 + v_j.p_1152;
                                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := v_j.p_111 + v_j.p_112 - v_j.p_113 - v_j.p_115 + v_j.p_116 + v_j.p_118;
            /*2015v: P.111+P.112-P.113-P.115+P.116+P.118*/
            /*2015e: P.111+P.112-P.113-P.115+P.116*/
                                                                    --ED 20170327
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);
--p12 kiszámítás
v_j.p_1221 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122;  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1362', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1362 := 0 + p.v;
ELSE
v_j.p_1362 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1366', v_betoltes); 
IF p.f = 2 THEN
v_j.p_1366 := 0 + p.v;
ELSE
v_j.p_1366 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 
            + v_j.p_1366 + v_j.p_1367;
                                    J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;            J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131;  J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC011', v_year, v_verzio, v_teszt) 
            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC020', v_year, v_verzio, v_teszt) 
            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC022', v_year, v_verzio, v_teszt)
            - v_j.d_1;
v_j.p_21 := v_j.p_21;--J_KORR_T.KORR_FUGG(c_sema, c_m003, 'P_21');                                          
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
v_j.p_24 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := V_J.D_11121 * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := V_J.D_11121 * 0.05; /*0.0379 volt 2017.04.27*/
                                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);

v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
            /*2015v: 0*/
            /*2015e: 0*/
v_j.p_28 := J_SELECT_T.bizt_viszont(c_sema, c_m003, v_year, v_verzio, v_betoltes, v_teszt) + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);
v_j.p_292 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
             /*külön adat*/
                                                                -- ED 20170327

v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
            /*2015e,v: 0*/
                                    J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   
                                                                -- ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24  - v_j.p_26 + v_j.p_27
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
v_j.d_312 := 0  ;                   J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
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
v_j.d_29b1 := J_KETTOS_FUGG_T.D_29b1(c_sema, c_m003, '', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
-- v_j.d_29b3 := 0;                          
v_j.d_29b3 := J_KETTOS_FUGG_T.D_29b3(c_sema, c_m003, v_year, v_verzio, v_teszt);
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
v_j.d_41211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC004', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC031', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);
v_j.d_412132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                    J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 ;
                                    J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC024', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41222', v_betoltes); 
IF p.f = 2 THEN
v_j.d_41222 := p.v;
ELSE
v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC032', v_year, v_verzio, v_teszt) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);
v_j.d_412232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231 - v_j.d_412232; 
                                    J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223; 
                                    J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                    J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;            J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;  J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42
v_j.d_421 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

v_j.d_4221 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

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
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46; 
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
v_j.d_51B11 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'POC045', v_year, v_verzio, v_teszt);   
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
v_j.d_711 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
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

END BIZT_EGY_EGYSZERU_NE;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------BIZTOSÍTÓ FIÓKTELEP BESZÁMOLÓ(NEM ÉLET)------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--6512-4,5
-- 17
PROCEDURE BIZT_FIOK_NE(c_sema VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 c_d1111 NUMBER(20, 3);
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  

--------------D.1 kiszámítása
--d_111

v_j.d_1111 := J_KETTOS_FUGG_T.D_1111(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_KETTOS_FUGG_T.D_11121(c_sema, c_m003,  v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
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
v_j.p_15 := 0;
v_j.p_16 := 0;
-- itt p.15, p.16 teljesen 0.
v_j.p_262 := 0;
-- itt p.262 teljesen 0.
v_j.d_1121 := v_j.p_16 * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 * 0.3525; /*=0 2017.04.27*/
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
v_j.d_1212 := 0;--2013.09.09  J_KETTOS_FUGG_T.D_1212(c_sema, c_m003);
                                    J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);
v_j.d_1211 := J_KETTOS_FUGG_T.D_1211(c_sema, c_m003, v_year, v_verzio, v_teszt) - 0 - 0;
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



--p11 kiszámítás
v_j.p_118 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
             /*2015v: külön adat*/
                                                                --ED 20170327

v_j.p_119 := 0; /*FISIM*/           J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p_111
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1111', v_betoltes);

IF p.f = 2 THEN
v_j.p_1111 := p.v;
ELSE
v_j.p_1111 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);
v_j.p_11111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);

--ez kéne legyen itt:
v_j.p_1112 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112); --itt is el volt írva P_11112 volt! 2017.08.22
--ez ami rossz és volt:
--v_j.p_1112 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_1112);

v_j.p_1113 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;   	                J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);

v_j.p_111 := v_j.p_1111 - v_j.p_1112 - v_j.p_1113;
                                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);


--p112
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1121', v_betoltes);
IF p.f = 2 THEN
v_j.p_1121 := p.v;
ELSE
v_j.p_1121 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);

v_j.p_112 := v_j.p_1121 + v_j.p_1122 + v_j.p_1123;
                                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

--p_113
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1131', v_betoltes);
IF p.f = 2 THEN
v_j.p_1131 := p.v;
ELSE
v_j.p_1131 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);

v_j.p_113 := v_j.p_1131 + v_j.p_1132;
                                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p_115
v_j.p_1151 := 0;   	 	            J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;/*KÜLÖN SZÁMÍTÁS*/  J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);

v_j.p_115 := v_j.p_1151 + v_j.p_1152;
                                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

--p_116
v_j.p_116 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

v_j.p_11 := J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema, c_m003, 'PRCA103', '', v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);
--p12 kiszámítás
v_j.p_1221 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_121 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_12 := v_j.p_121 - v_j.p_122;  J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
 
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1362', v_betoltes);
IF p.f = 2 THEN
v_j.p_1362 := 0 + p.v;
ELSE
v_j.p_1362 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1364 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);
v_j.p_1365 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1366', v_betoltes);
IF p.f = 2 THEN
v_j.p_1366 := 0 + p.v; 
ELSE
v_j.p_1366 := 0 + p.v; 
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/      J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 
             + v_j.p_1366 + v_j.p_1367;
                                    J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;            J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132 - v_j.p_131;  J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := 0;  
                                    J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                    J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_KETTOS_FUGG_T.P_21(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);

v_j.p_22 := J_KETTOS_FUGG_T.P_22(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);
--p23
v_j.p_2331 := J_KETTOS_FUGG_T.P_2331(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := J_KETTOS_FUGG_T.P_231(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_232', v_betoltes);
IF p.f = 2 THEN
v_j.p_232 := p.v;
ELSE
v_j.p_232 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
v_j.p_2321 := J_KETTOS_FUGG_T.P_2321(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);
v_j.p_2322 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_233 := v_j.p_2331 - v_j.p_231 - v_j.p_2321;
                                    J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);
v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                    J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--p24
v_j.p_24 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
v_j.p_262 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;              J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := 0;                      J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);

v_j.p_291 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);
v_j.p_292 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);
v_j.p_293 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
             /*2015v: külön adat*/
                                                                --ED 20170327

v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;
                                    J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);
                                                                --ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24  - v_j.p_26 + v_j.p_27 
            + v_j.p_28 + v_j.p_29; 
                                    J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;      J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := J_KETTOS_FUGG_T.k_1(c_sema, c_m003, v_year, v_verzio, v_teszt) - v_j.p_27;
                                    J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
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
v_j.d_312 := 0  ;                   J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
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

v_j.d_29b1 := 0;                          
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := 0;                          
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
v_j.d_41211 := J_KETTOS_FUGG_T.D_41211(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);
v_j.d_41212 := J_KETTOS_FUGG_T.D_41212(c_sema, c_m003, v_year, v_verzio, v_teszt) - v_j.d_41211;
                                    J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

v_j.d_412131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);
v_j.d_412132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                    J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 ;
                                    J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_KETTOS_FUGG_T.D_41221(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41222', v_betoltes);
IF p.f = 2 THEN
v_j.d_41222 := p.v;
ELSE
v_j.d_41222 := J_KETTOS_FUGG_T.D_41222(c_sema, c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

v_j.d_412231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);
v_j.d_412232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231 - v_j.d_412232; 
                                    J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223; 
                                    J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                    J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;            J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;  J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42
v_j.d_421 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

v_j.d_4221 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

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

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_432', v_betoltes);
IF p.f = 2 THEN
v_j.d_432 := p.v;
ELSE
v_j.d_432 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431 - v_j.d_432;  
                                    J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
-- v_j.d_44 := v_j.d_441 + v_j.d_442 + v_j.d_443;                     
--J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                      J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 - v_j.d_44 - v_j.d_45 - v_j.d_46; 
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
v_j.d_51B11 := J_KETTOS_FUGG_T.D_51B11(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                    J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
v_j.d_51B12 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

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
v_j.d_711 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;  J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);
v_j.d_722 := v_j.p_113;             J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                    J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722;  
                                    J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);


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
v_j.d_8 := 0;                       J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END BIZT_FIOK_NE;


end J_A_BIZT_NE_T;