/*
create or replace PACKAGE "J_A_HITEL_T" as 

  -- 1,2,3-nál is ezt használjuk most
  PROCEDURE HITELINTEZET(c_sema varchar2, c_lepes VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2);-- Hitelintézet
                                                           -- 6419 és 6492 JELZÁLOGBANKOK
                                                           -- JELZÁLOGBANK
                                                           -- és
                                                           -- 6419 Hitelintézeti fióktelep
  -- ezt most nem használjuk
  PROCEDURE HITELINTEZET_FIOK(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2, c_m003 VARCHAR2);-- Fióktelep
                                                                -- 6419 Hitelintézeti fióktelep
  PROCEDURE FISIM_TERM(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema varchar2,c_m003 VARCHAR2); -- FISIM termelők
                                                         --  6491, 6492, 6499-ből FISIM-termelők
  PROCEDURE kettosok(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2,c_m003 VARCHAR2, 
                    c_lepes VARCHAR2 DEFAULT '0'); --  6491, 6492 FISIM-felhasználók....                                                         
  -- kettősök futtatásánl számít még a lépés, de csak itt (11-es futtatásánál)
  PROCEDURE scv(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2,c_m003 VARCHAR2, c_lepes VARCHAR2); -- Zártkörűek: SCV-k, holdingok, csoportfinanszírozók


end J_A_HITEL_T;
*/


create or replace PACKAGE BODY "J_A_HITEL_T" as

v_j j_szekt_semamutatok;
v_k j_kettosok;
p PAIR;

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-------------------------------HITELINTEZET-------------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
-- 6419 és 6492 JELZÁLOGBANKOK
-- 6419 Hitelintézeti fióktelep
PROCEDURE HITELINTEZET(c_sema VARCHAR2, c_lepes VARCHAR2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2) AS
 c_k NUMBER;
 p PAIR;
 pfc004 NUMBER(15);
 pfc061 NUMBER(15);
 k NUMBER(15);
BEGIN

--DBMS_OUTPUT.PUT_LINE('START J_A_HITEL_T.HITELINTEZET');

p := PAIR.INIT;
v_j := j_szekt_semamutatok.getnull(v_j); 
c_k := TO_NUMBER(c_sema);
v_k :=  J_KETTOSOK.GETNULL(v_k); --uj

v_k :=  J_KETTOS_FUGG_T.KETTOS_FUGG_UJ(c_sema, c_m003, c_lepes, v_year, v_verzio, v_teszt);
--DBMS_OUTPUT.PUT_LINE('J_KETTOS_FUGG_T.KETTOS_FUGG_UJ lefutott!');


--p11 kiszámítás
v_j.p_118 := 0; --VT 20170327
             
                                J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); 
                                                                 --VT 20170327

--p := J_KORR.KORR_FUGG(c_sema,c_m003, 'P_119');
p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003, 'P_119', v_betoltes);
IF p.f = 2 THEN
 v_j.p_119 := p.v;
ELSE
 v_j.p_119 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);
                                                                     --FISIM 

--p111 kiszámítás
v_j.p_11111 := 0;               J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;               J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);
v_j.p_1111 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);

v_j.p_1112 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);
v_j.p_1113 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);
v_j.p_111 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC021', v_year, v_verzio, v_teszt); 
                                J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

v_j.p_11 := v_j.p_118 + v_j.p_119 + v_j.p_112; --VT 20170327              

                                J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);

--p113
v_j.p_1131 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);
v_j.p_113 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p115-p116
v_j.p_1151 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);
v_j.p_115 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

v_j.p_116 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

--p12 kiszámítás
v_j.p_1211 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_1212 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);

v_j.p_121 := 0; -- kivezetve 2017.06.23-án: E.D.
--v_j.p_121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC166', v_year, v_verzio, v_teszt) 
--             + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC168', v_year, v_verzio, v_teszt);--javitva 2011.09.15  
                                J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_1221 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);


v_j.p_12 := v_j.p_121-v_j.p_122;
                                J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
 v_j.p_1361 := J_KETTOS_FUGG_T.p_1361(c_sema, c_m003, v_year, v_verzio, v_teszt); -- WZ
                                J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1364', v_betoltes);
IF p.f = 2 THEN
 v_j.p_1364 := p.v;
ELSE
 v_j.p_1364 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1365', v_betoltes);
IF p.f = 2 THEN
 v_j.p_1365 := p.v;
ELSE
 v_j.p_1365 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

 v_j.p_1312 := J_KETTOS_FUGG_T.p_1312(c_sema,c_m003, v_year, v_verzio, v_teszt); --WZ
                                J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;        J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132-v_j.p_131;
                                J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13); -- ez eredetileg 131 - 132 volt
						
								
--p14   --p16
 -- WZ
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_14', v_betoltes);
IF p.f = 2 THEN
v_j.p_14 := p.v;
ELSE
v_j.p_14 := J_KETTOS_FUGG_T.p_14(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);


v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)')
            * J_KONST_T.P_15_TERM_SZORZO;
--v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.3356; -- 0.0691 volt 2017.04.26;

                                J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);

v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_m003, 'NVL(PRJA045,0)')
            * J_KONST_T.P_16_TERM_SZORZO;
--v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.5787; -- 1.4548 volt 2017.04.26

                                J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12-v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'HIC056', v_year, v_verzio, v_teszt)
            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC058', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);

								
								
								
								
								
								
								
--p23
 -- WZ
v_j.p_2331 := J_KETTOS_FUGG_T.p_2331(c_sema,c_m003, v_year, v_verzio, v_teszt); 
--J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC167', v_year, v_verzio, v_teszt)
--+J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC169', v_year, v_verzio, v_teszt);--javítva 2011.09.15 
--J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC388', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

--itt volt a p_233
--itt volt a p_23
v_j.p_231 := J_KETTOS_FUGG_T.p_231(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_232', v_betoltes);
IF p.f = 2 THEN
 v_j.p_232 := p.v;
ELSE
 v_j.p_232 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
								
								
								
								
 -- WZ
v_j.p_2321 := J_KETTOS_FUGG_T.p_2321(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);

v_j.p_233 := v_j.p_2331-v_j.p_231-v_j.p_2321;
                                J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_2322 := 0;                J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_23 := v_j.p_231 + v_j.p_232 + v_j.p_233;
                                J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23); 
                        --ide került h meglegyenek a forrás adatok mire számol


--át kellett tenni, mert a P_23-at ki kell belőle vonni!!!
v_j.p_22 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'HIC059', v_year, v_verzio, v_teszt)
            + J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'HIC060', v_year, v_verzio, v_teszt)
            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC061', v_year, v_verzio, v_teszt)
            - v_j.p_23;
                                J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);



--p24
v_j.p_24 := 0; -- kivezetve 2017.06.23-án: E.D.
--v_j.p_24 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PIC167', v_year, v_verzio, v_teszt)
--            + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PIC169', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);


--p27
v_j.p_27 := 0; -- mindehol 0 | 2017.04.26

--v_j.p_27 := J_KETTOS_FUGG_T.P_27(c_sema, c_m003, v_year, v_verzio, v_teszt) + 0; --egyedi korrekció
                                J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);

v_j.p_28 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC026', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);
								
								
								
								
								
								
								
 -- WZ: előre nem várt hiba
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_291', v_betoltes);
IF p.f = 2 THEN
v_j.p_291 := p.v;
ELSE
v_j.p_291 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

v_j.p_292 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);

v_j.p_293 := 0; --VT 20170327
        
                                J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); --VT 20170327

v_j.p_29 := v_j.p_291 + v_j.p_292 + v_j.p_293;  --VT 20170327
         
                                J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);


--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27 + v_j.p_28 + v_j.p_29; 
                                J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
------------------------------------B.1g kiszámítása
v_j.b_1g := v_j.p_1-v_j.p_2;    J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);


 k := 0;

IF v_j.b_1g < 0 THEN 
    pfc061 := v_k.c_prca150 + v_k.c_prca151;
    v_j.b_1g := v_j.b_1g + pfc061; 
    IF v_j.b_1g >= 0 THEN
      k := pfc061 - v_j.b_1g;
      v_j.b_1g := 0; 
    ELSE 
      k := pfc061;
      v_j.b_1g := v_j.b_1g; 
    END IF;

--    v_j.p_121 := v_j.p_121 + k;    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);--v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;
--    v_j.p_12 := v_j.p_12 + k;      J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);-- v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;
--    v_j.p_1 := v_j.p_1 + k;        J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);--v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;

                                   J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);--v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;
END IF;
----------------------------------------

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'K_1', v_betoltes);
IF p.f = 2 THEN
v_j.K_1 := p.v;
ELSE
v_j.K_1 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC062', v_year, v_verzio, v_teszt)-v_j.p_27+p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);

v_j.b_1n := v_j.b_1g-v_j.K_1;   J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;        J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;                J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;      J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;      J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;       J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;     J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;      J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;       J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;      J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 := 0  ;              J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;               J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;      J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;
                                J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása
c_k := 2*(1-0.5*c_k);
--d_111
v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC052', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC053', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);


								
								
								
								
								
								
								
								
								
								
								
								
								
								
								

--p26 (ide áthozva)
v_j.p_262 := v_j.d_11121 * J_KONST_T.p_262_term_szorzo;
--v_j.p_262 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC398', v_year, v_verzio, v_teszt) * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PIC398', v_year, v_verzio, v_teszt) * 0.05; -- 0.0379 volt 2017.04.26

                                J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;          J_SZEKT_EVES_T.feltolt('P_26', v_j.p_26);




p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11124', v_betoltes);
IF p.f = 2 THEN
v_j.d_11124 := p.v;
ELSE
v_j.d_11124 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11123', v_betoltes);
IF p.f = 2 THEN
v_j.d_11123 := p.v;
ELSE
v_j.d_11123 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,
                c_sema,
                c_m003, 
                'NVL(LALA064,0)+NVL(LALA072,0)+NVL(LALA045,0)') - v_j.d_11124;
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11125', v_betoltes);
IF p.f = 2 THEN
v_j.d_11125 := p.v;
ELSE
v_j.d_11125 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA026,0)') + p.v;        
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11126', v_betoltes);
IF p.f = 2 THEN
v_j.d_11126 := p.v;
ELSE
v_j.d_11126 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA056,0)') + p.v;        
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);
 -- WZ
v_j.d_11127 := J_KETTOS_FUGG_T.d_11127(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11128', v_betoltes);
IF p.f = 2 THEN
v_j.d_11128 := p.v;
ELSE
v_j.d_11128 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);

v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA044,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);

--*********************************
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA135,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);--LALA135!!!!
--*********************************

-- beszúrva d_11124: 2017.08.11.
-- régen: 
-- D.11121-D.11123 -D.11125-D.11126-D.11127-D.11128-D.11129-D.11130-D.11131
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125 
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112

v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)')
            * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)')
--            * 0.3525; 
                                J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);

v_j.d_1122 := v_j.p_15;         J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);

 -- WZ
v_j.d_1123 := J_KETTOS_FUGG_T.d_1123(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);

								
v_j.d_1124 := v_j.p_262;        J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;      J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;      J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;      J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;      J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125 + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;
                                J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;    J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

 -- WZ
--d121
v_j.d_1212 := J_KETTOS_FUGG_T.d_1212(c_sema,c_m003, v_year, v_verzio, v_teszt);--+J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_1212');
                                J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);

		
 -- WZ		
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_1211', v_betoltes);
IF p.f = 2 THEN
v_j.d_1211 := p.v;
ELSE
v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC054', v_year, v_verzio, v_teszt)-J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'LALA175')-J_KETTOS_FUGG_T.d_29c2(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);

	

v_j.d_1213 := v_j.d_11125;      J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;      J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;      J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;      J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;      J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122;
                                J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12; 
                                J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);

------------D.29

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29C1', v_betoltes);
IF p.f = 2 THEN
v_j.d_29C1 := p.v;
ELSE
v_j.d_29C1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'LALA175') + p.v;
--J_KETTOS_FUGG_T.d_29c1(c_sema,c_m003, v_year, v_verzio, v_teszt)+J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29C1');
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
 -- WZ
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29C2', v_betoltes);
IF p.f = 2 THEN
  v_j.d_29C2 := p.v;
ELSE
v_j.d_29C2 := J_KETTOS_FUGG_T.d_29c2(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;--J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29C2');
                                J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);

v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);
 -- WZ
IF c_m003=10803828 or c_m003=19670780 or c_sema=2 THEN
   v_j.d_29b1 := 0;

ELSE

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B1', v_betoltes);
IF p.f = 2 THEN
v_j.d_29b1 := p.v;
ELSE
v_j.d_29b1 := J_KETTOS_FUGG_T.d_29b1(c_sema,c_m003, '', v_year, v_verzio, v_teszt) + p.v;
END IF;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);


IF c_m003=10803828 or c_m003=19670780 or c_sema=2 THEN
   v_j.d_29b3 := 0;
ELSE

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B3', v_betoltes);
IF p.f = 2 THEN
v_j.d_29b3 := p.v;
ELSE
v_j.d_29b3 := J_KETTOS_FUGG_T.d_29b3(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
END IF;
--J_KETTOS_FUGG_T.d_29b3(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);


v_j.d_29A11 := 0;               J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;               J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;                J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29E3', v_betoltes);
IF p.f = 2 THEN
v_j.d_29E3 := p.v;
ELSE
v_j.d_29E3 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC066', v_year, v_verzio, v_teszt) + p.v;
--J_KETTOS_FUGG_T.d_29E3(c_sema,c_m003, v_year, v_verzio, v_teszt);--PFD0M603 
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 + v_j.d_29E3; 
                                J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_3911', v_betoltes);
IF p.f = 2 THEN
v_j.d_3911 := p.v;
ELSE
v_j.d_3911 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;        J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_39251', v_betoltes);
IF p.f = 2 THEN
v_j.d_39251 := p.v;
ELSE
v_j.d_39251 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);

 -- WZ
								
v_j.d_39253 := J_KETTOS_FUGG_T.d_39253(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
								
								
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;        J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g-v_j.d_1-v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n-v_j.d_1-v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);

 -- WZ
------------D.42-------
v_j.d_41211 := J_KETTOS_FUGG_T.d_41211(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

								
								
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41212', v_betoltes);
IF p.f = 2 THEN
v_j.d_41212 := p.v;
ELSE
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC001', v_year, v_verzio, v_teszt)-v_j.d_41211+p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412131', v_betoltes);
IF p.f = 2 THEN
v_j.d_412131 := 0 + p.v;
ELSE
v_j.d_412131 := 0 + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);
v_j.d_412132 := 0;              J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);
 -- WZ
v_j.d_41221 := J_KETTOS_FUGG_T.d_41221(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41222', v_betoltes);
IF p.f = 2 THEN
v_j.d_41222 := p.v;
ELSE
v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC010', v_year, v_verzio, v_teszt)-v_j.d_41221+p.v;
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412231', v_betoltes);
IF p.f = 2 THEN
v_j.d_412231 := p.v;
ELSE
v_j.d_412231 := 0 + p.v;
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);


v_j.d_412232 := 0;              J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231-v_j.d_412232;
                                J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121-v_j.d_4122; J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;        J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;
                                J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_421', v_betoltes);
IF p.f = 2 THEN
v_j.d_421 := p.v;
ELSE
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_421') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); --2009-es adat

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4221', v_betoltes);
IF p.f = 2 THEN
v_j.d_4221 := p.v;
ELSE
v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4221') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4222', v_betoltes);
IF p.f = 2 THEN
v_j.d_4222 := p.v;
ELSE
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4222') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4223', v_betoltes);
IF p.f = 2 THEN
v_j.d_4223 := p.v;
ELSE
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4223');
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4224', v_betoltes);
IF p.f = 2 THEN
v_j.d_4224 := p.v;
ELSE
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4224') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4225', v_betoltes);
IF p.f = 2 THEN
v_j.d_4225 := p.v;
ELSE
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4225') + p.v;                 
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4226', v_betoltes);
IF p.f = 2 THEN
v_j.d_4226 := 0 + p.v; 
ELSE
v_j.d_4226 := 0 + p.v; 
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421-v_j.d_422;
                                J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);

v_j.d_44131 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_44132', v_betoltes);
IF p.f = 2 THEN
v_j.d_44132 := 0 + p.v;
ELSE
v_j.d_44132 := 0 + p.v;
END IF;

                                 J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);

v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);

v_j.d_44231 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_44232 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);
 -- WZ előre nem várt hiba
-----------------D.4---------------
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_431', v_betoltes);
IF p.f = 2 THEN
v_j.d_431 := 0 + p.v;
ELSE
v_j.d_431 := 0 + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_432', v_betoltes);
IF p.f = 2 THEN
v_j.d_432 := 0 + p.v;
ELSE
v_j.d_432 := 0 + p.v;    
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
								
								
v_j.d_43 := v_j.d_431-v_j.d_432;
                                J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
v_j.d_44 := v_j.d_441-v_j.d_442;
                                J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
								
	-- WZ
v_j.d_45 := J_KETTOS_FUGG_T.d_45(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
								
								
v_j.d_46 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);

---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);

---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4; 
                                J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4; 
                                J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);

 -- WZ
---------------D.5---------------
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_51B11', v_betoltes);
IF p.f = 2 THEN
 v_j.d_51B11 := p.v;
ELSE
 v_j.d_51B11 := J_KETTOS_FUGG_T.d_51b11(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_51B12', v_betoltes);
IF p.f = 2 THEN
v_j.d_51B12 := p.v;
ELSE
v_j.d_51B12 := J_KETTOS_FUGG_T.d_51B12(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
								
								
v_j.d_51B13 := 0;--J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_51B13'); 
                                J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------


v_j.d_611 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;         J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := 0;                J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);

v_j.d_621 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122;         J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614-v_j.d_61SC;
                                J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61-v_j.d_62;   J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_711 := 0;  J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_712 := 0;  J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_71 := v_j.d_711 + v_j.d_712;
                                J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);

v_j.d_721 := v_j.p_2321-v_j.p_232;
                                J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_722 := 0;  
                                J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_72 := v_j.d_721 + v_j.d_722;
                                J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);
 -- WZ
v_j.d_7511 := J_KETTOS_FUGG_T.d_7511(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
								
								
v_j.d_7512 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;
                                J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;
                                J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;
                                J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);

 -- WZ
v_j.d_7522 := J_KETTOS_FUGG_T.d_7522(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);

								
v_j.d_7523 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;
                                J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;
                                J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751-v_j.d_752;
                                J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8; 
                                J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8; 
                                J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);



DBMS_OUTPUT.PUT_LINE('END J_A_HITEL_T.HITELINTEZET');

END HITELINTEZET;



-- EZT MOST NEM HASZNÁLJUK
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
----------------------------------FIÓKTELEP-------------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
 -- 6419 Hitelintézeti fióktelep
PROCEDURE HITELINTEZET_FIOK(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2,c_m003 VARCHAR2) AS
 v_j J_SZEKT_SEMAMUTATOK;
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j);  


v_j.p_118 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
            /*2015v: külön adat*/


--p11 kiszámítás
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_119', v_betoltes);
IF p.f = 2 THEN
 v_j.p_119 := p.v;
ELSE
 v_j.p_119 := p.v;--J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_119');                               
END IF;
                                 J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p111 kiszámítás
v_j.p_11111 := 0;                J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;                J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);
v_j.p_1111 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);

v_j.p_1112 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);
v_j.p_1113 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);
v_j.p_111 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'HIC021', v_year, v_verzio, v_teszt);
                                 J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);
v_j.p_1123 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                 J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

v_j.p_11 := v_j.p_118 + v_j.p_119 + v_j.p_112;
            /*2015v: P.118+P.119+P.112*/
            /*2015e: P.119+P.112*/
                                J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);

--p113
v_j.p_1131 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);
v_j.p_113 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p115-p116
v_j.p_1151 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);
v_j.p_115 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

v_j.p_116 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

--p12 kiszámítás
v_j.p_1211 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_1212 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_121 := 0; -- kivezettük 2017.06.23-án: E.D.
--v_j.p_121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC166')
--             + J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'FHC168');
                                J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_1221 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222);
v_j.p_122 := v_j.p_1221 + v_j.p_1222;
                                J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);

v_j.p_12 := v_j.p_121-v_j.p_122;
                                J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1361 := J_KETTOS_FUGG_T.p_1361(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);
v_j.p_1363 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1364', v_betoltes);
IF p.f = 2 THEN
v_j.p_1364 := 0 + p.v;
ELSE
v_j.p_1364 := 0 + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1365', v_betoltes);
IF p.f = 2 THEN
v_j.p_1365 := 0 + p.v;
ELSE
v_j.p_1365 := 0 + p.v;
END IF;

                                J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);

v_j.p_1366 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/  J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365 + v_j.p_1366 + v_j.p_1367;
                                J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132);
v_j.p_1312 := J_KETTOS_FUGG_T.p_1312(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;        J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

--P13 ez fordítva volt előtte
v_j.p_13 := v_j.p_132-v_j.p_131;
                                J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
v_j.p_14 := J_KETTOS_FUGG_T.P_14(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);
v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * J_KONST_T.P_15_TERM_SZORZO;
--v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.3356; -- 0.0691 volt 2017.04.26
            /*2015v: (1508A-01-01/02c)*0,3356 (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*0,0691 (előzetes sémában előző évi TÁSA számok)*/
                                J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003,'NVL(PRJA045,0)') * J_KONST_T.P_16_TERM_SZORZO;
--v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003,'NVL(PRJA045,0)') * 0.5787; -- 1.4548 volt 2017.04.26;
            /*2015v: (1508A-01-01/02c)*0,5787 (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*1,4548(előzetes sémában előző évi TÁSA számok)*/
                                J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16); 

 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p21-p22
v_j.p_21 := J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'HIC056', v_year, v_verzio, v_teszt)
            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC058', v_year, v_verzio, v_teszt);                
                                J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);

--p23
v_j.p_2331 := J_KETTOS_FUGG_T.p_2331(c_sema,c_m003, v_year, v_verzio, v_teszt);
--J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC167')
--+J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC169');
                                J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

--itt volt a P233
-- itt volt a P23 eredetileg
v_j.p_231 := J_KETTOS_FUGG_T.p_231(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_232', v_betoltes);
IF p.f = 2 THEN
v_j.p_232 := p.v;
ELSE
v_j.p_232 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);



v_j.p_2321 := J_KETTOS_FUGG_T.p_2321(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);

v_j.p_233 := v_j.p_2331-v_j.p_231-v_j.p_2321;
                                J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_2322 := 0;                J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_23 := v_j.p_231 + v_j.p_232 + v_j.p_233;
                                J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--Át kellett helyezni, mert a P_23-at le kell belőle vonni!!!
v_j.p_22 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC059', v_year, v_verzio, v_teszt)
            + J_SZEKT_EVES_T.fugg(c_sema, c_m003, 'HIC060', v_year, v_verzio, v_teszt)
            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC061', v_year, v_verzio, v_teszt)
            - v_j.p_23;
                                J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);


--p24
v_j.p_24 := 0; -- kivezetve 2017.06.23-án: E.D.
--v_j.p_24 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC167') 
--            + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC169');
                                J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);
--p26

v_j.p_262 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC398', v_year, v_verzio, v_teszt) * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC398') * 0.05; -- 0.0379 volt 2017.04.26;
            /*2015v: D.11121*0,05*/
            /*2015e: D.11121*0,0379*/
                                J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;          J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0; -- 2017.04.26
            /*2015v: 0*/
            /*2015e: 1529-A-02-01/12a első 'a' oszlop + egyedi korrekció*/
--v_j.p_27 := J_KETTOS_FUGG_T.p_27(c_sema,c_m003)+0;/*egyedi korrekció*/
                                J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);
v_j.p_28 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC026', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_291', v_betoltes);
IF p.f = 2 THEN
v_j.p_291 := p.v;
ELSE
v_j.p_291 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);

v_j.p_292 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);

v_j.p_293 := 0;
             /*2015v: külön adat*/

v_j.p_29 := v_j.p_291 + v_j.p_292 + v_j.p_293;
            /*2015v: P.291+P.292+P.293*/
            /*2015e: P.291+292*/
                                J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 
           - v_j.p_26 + v_j.p_27 + v_j.p_28 + v_j.p_29; 
                                J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);

------------------------B.1g kiszámítása---------------------------------------
v_j.b_1g := v_j.p_1-v_j.p_2;   J_SZEKT_EVES_T.feltolt('B_1g', v_j.b_1g);
v_j.K_1 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC062', v_year, v_verzio, v_teszt)-v_j.p_27;
                               J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g-v_j.K_1;  
                               J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;               J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;       J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/ 
                                J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;      J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;      J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;       J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;     J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;      J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;       J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;      J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);
--D.31 kiszámítása
v_j.d_312 := 0  ;              J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/ 
                                J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;      J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;
                                J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

--d_111
v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC052', v_year, v_verzio, v_teszt); 
                                J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);

v_j.d_11121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC053', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);
v_j.d_11124 := 0;/*KÜLÖN ADAT*/ 
                                J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);

v_j.d_11123 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA064, 0)
                                    + NVL(LALA072,0) + NVL(LALA045,0)') 
                                    - v_j.d_11124;
                                J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA026,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA056,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11127', v_betoltes);
IF p.f = 2 THEN
 v_j.d_11127 := p.v;
ELSE
 v_j.d_11127 := J_KETTOS_FUGG_T.d_11127(c_sema, c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);
v_j.d_11128 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA044,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA135,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);


-- beszúrva d_11124: 2017.08.11
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16
              + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16
--              + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.3525;
              /*2015v: P.16+(1508A-01-01/02c)*0,0,3525 (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+(1508A-01-01/02c)*0,4641 (előzetes sémában előző évi TÁSA számok)*/
                                                      -- 0.4641 volt 2017.04.26
                                J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;         J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := J_KETTOS_FUGG_T.d_1123(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;        J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;      J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;      J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;      J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;      J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125 + v_j.d_1126
            + v_j.d_1127 + v_j.d_1128;
                                J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;
                                J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                J_SZEKT_EVES_T.feltolt('D_1212', v_j.d_1212);
v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC054', v_year, v_verzio, v_teszt)
              - J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'LALA175')
              - J_KETTOS_FUGG_T.d_29c2(c_sema,c_m003, v_year, v_verzio, v_teszt);         
                                J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;      J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;      J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;      J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;      J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;      J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122;
                                J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12; 
                                J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'LALA175');--J_KETTOS_FUGG_T.d_29c1(c_sema,c_m003);
                                J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := J_KETTOS_FUGG_T.d_29c2(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2; J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

v_j.d_29b1 := J_KETTOS_FUGG_T.d_29b1(c_sema,c_m003, '', v_year, v_verzio, v_teszt)*0;--+J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B1');      
                                J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);
v_j.d_29b3 := J_KETTOS_FUGG_T.d_29b3(c_sema,c_m003, v_year, v_verzio, v_teszt)*0;--+J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B3');  
                                J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);
v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);
v_j.d_2953 := 0;/*KÜLÖN ADAT */ 
                                J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29E3', v_betoltes);
IF p.f = 2 THEN
v_j.d_29E3 := p.v;
ELSE
v_j.d_29E3 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'FHC423', v_year, v_verzio, v_teszt) + p.v;/*J_KETTOS_FUGG_T.d_29E3(c_sema,c_m003);*/
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 + v_j.d_29E3;
                                J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */ J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;        J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := J_KETTOS_FUGG_T.d_39253(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;        J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g-v_j.d_1-v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n-v_j.d_1-v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);



------------D.42-------

v_j.d_41211 := J_KETTOS_FUGG_T.d_41211(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.feltolt('D_41211', v_j.d_41211);
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC001', v_year, v_verzio, v_teszt) - v_j.d_41211;
                                J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412131', v_betoltes);
IF p.f = 2 THEN
v_j.d_412131 := 0 + p.v;
ELSE
v_j.d_412131 := 0 + p.v;/*KÜLÖN ADAT */   
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);

v_j.d_412132 := 0;/*KÜLÖN ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_KETTOS_FUGG_T.d_41221(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.feltolt('D_41221', v_j.d_41221);
v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'HIC010', v_year, v_verzio, v_teszt)-v_j.d_41221;
                                J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412231', v_betoltes);
IF p.f = 2 THEN
v_j.d_412231 := 0 + p.v;
ELSE
v_j.d_412231 := 0 + p.v;/*KÜLÖN ADAT */
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

v_j.d_412232 := 0;/*KÜLÖN ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231-v_j.d_412232;
                                J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121-v_j.d_4122;
                                J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;        J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;
                                J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_421');
                                J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421); --2009-es adat

v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4221');
                                J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4222');
                                J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4223');
                                J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4224');
                                J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4225');                 
                                J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);
v_j.d_4226 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421 - v_j.d_422;
                                J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);


v_j.d_44131 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_44132 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44231 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_44232 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);


-----------------D.4---------------
v_j.d_431 := 0;/*KÜLÖN ADAT MNB */
                                J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_432', v_betoltes);
IF p.f = 2 THEN
v_j.d_432 := 0 + p.v;
ELSE
v_j.d_432 := 0 + p.v;/*KÜLÖN ADAT MNB */
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
v_j.d_43 := v_j.d_431-v_j.d_432;

                                J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
v_j.d_44 := v_j.d_441-v_j.d_442;
                                J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := J_KETTOS_FUGG_T.d_45(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4; 
                                J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4; 
                                J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);



---------------D.5---------------
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_51B11', v_betoltes);
IF p.f = 2 THEN
 v_j.d_51B11 := p.v;
ELSE
 v_j.d_51B11 := J_KETTOS_FUGG_T.d_51B11(c_sema, c_m003, v_year, v_verzio, v_teszt) + p.v;
END IF;
/*2015v: 1529-01-01/15c*/
/*2015e: 1529-01-01/15c*/
                                J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);

v_j.d_51B12 := J_KETTOS_FUGG_T.d_51B12(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);
v_j.d_51B13 := 0;/*Külön adat*/ 
                                J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------


v_j.d_61SC := 0;                J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);
v_j.d_614 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_613 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_612 := v_j.d_122;         J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_611 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614-v_j.d_61SC;
                                J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);


v_j.d_621 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122;         J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);

v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61-v_j.d_62;   J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_712 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_711 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_71 := v_j.d_711 + v_j.d_712;
                                J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);

v_j.d_722 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_721 := v_j.p_2321-v_j.p_232;
                                J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_72 := v_j.d_721 + v_j.d_722;
                                J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := J_KETTOS_FUGG_T.d_7511(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := J_KETTOS_FUGG_T.d_7522(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751-v_j.d_752; 
                                J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g - v_j.d_8; J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n - v_j.d_8; J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

/*
IF c_agrr=2 THEN J_SZEKT_EVES_T.kiir;
END IF;
*/
END HITELINTEZET_FIOK;


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
--------------------------------FISIM TERMELŐK----------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--

PROCEDURE FISIM_TERM(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2,c_m003 VARCHAR2) AS
 t_variable NUMBER;
 p PAIR;
BEGIN
p := PAIR.INIT;
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j); 


--p11 kiszámítás
v_j.p_118 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
            /*2015v: külön adat*/
                                                                 --ED 20170327

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_119', v_betoltes);
IF p.f = 2 THEN
v_j.p_119 := p.v;
ELSE
v_j.p_119 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);

--p111 kiszámítás
v_j.p_11111 := 0;               J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);
v_j.p_11112 := 0;               J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);
v_j.p_1111 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);

v_j.p_1112 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);
v_j.p_1113 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);
v_j.p_1114 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);
v_j.p_111 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);

--p112
v_j.p_1121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC007', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);
v_j.p_1122 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);

IF c_m003 = 19670780 THEN
 v_j.p_1123 := 0;
ELSE
 v_j.p_1123 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC012', v_year, v_verzio, v_teszt)
               - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC013', v_year, v_verzio, v_teszt)
               + J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC014', v_year, v_verzio, v_teszt)
               - J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC015', v_year, v_verzio, v_teszt);
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);
v_j.p_112 := v_j.p_1121 + v_j.p_1123; 
                                J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);

v_j.p_11 := v_j.p_118 + v_j.p_119 + v_j.p_112;
            /*2015v: P.118+P.119+P.112*/
            /*2015e: P.119+P.112*/
                                J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11); --ED 20170327

--p113
v_j.p_1131 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);
v_j.p_1132 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);
v_j.p_113 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);

--p115-p116
v_j.p_1151 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);
v_j.p_1152 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);
v_j.p_115 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);

v_j.p_116 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);

--p12 kiszámítás
v_j.p_1211 := 0; -- kivezetve 2017.06.23-án: E.D.
--v_j.p_1211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC010');
                                J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);
v_j.p_1212 := 0; -- kivezetve 2017.06.23-án: E.D.
--v_j.p_1212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC011');
                                J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);
v_j.p_121 := v_j.p_1211-v_j.p_1212; 
                                J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);

v_j.p_1221 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);
v_j.p_1222 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222); 
v_j.p_122 := v_j.p_1221 + v_j.p_1222; 
                                J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);


v_j.p_12 := v_j.p_121-v_j.p_122;
                                J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);

--p13 kiszámítás
v_j.p_1363 := J_KETTOS_FUGG_T.p_1363(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);
v_j.p_1361 := J_KETTOS_FUGG_T.p_1361(c_sema,c_m003, v_year, v_verzio, v_teszt)-v_j.p_1363;
                                J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);
v_j.p_1362 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);

v_j.p_1364 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_1365', v_betoltes);
IF p.f = 2 THEN
v_j.p_1365 := p.v;
ELSE
v_j.p_1365 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);
v_j.p_1366 := 0;                J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);
v_j.p_1367 := 0;/*KÜLÖN ADAT*/  J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 + v_j.p_1365
             + v_j.p_1366 + v_j.p_1367;
                                J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); 

v_j.p_1312 := J_KETTOS_FUGG_T.p_1312(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);
v_j.p_131 := v_j.p_1312;        J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);

v_j.p_13 := v_j.p_132-v_j.p_131;
                                J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);

--p14   --p16
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_14', v_betoltes);
IF p.f = 2 THEN
v_j.p_14 := p.v;
ELSE
v_j.p_14 := J_KETTOS_FUGG_T.p_14(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;  
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);

v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * J_KONST_T.P_15_TERM_SZORZO;
--v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.3356; -- 0.0691 volt 2017.04.26 
                                J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);
            /*2015v: (1508A-01-01/02c)*0,3356 (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*0,0691 (előzetes sémában előző évi TÁSA számok)*/
v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * J_KONST_T.P_16_TERM_SZORZO;
--v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.5787; -- 1.4548 volt 2017.04.26;
                                J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);
            /*2015v: (1508A-01-01/02c)*0,5787 (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*1,4548(előzetes sémában előző évi TÁSA számok)*/


 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);

--p23
v_j.p_2331 := J_KETTOS_FUGG_T.p_2331(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);

v_j.p_231 := J_KETTOS_FUGG_T.p_231(c_sema, c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003, 'P_232', v_betoltes);
IF p.f = 2 THEN
v_j.p_232 := p.v;
ELSE
v_j.p_232 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);
                                J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);

v_j.p_2321 := J_KETTOS_FUGG_T.p_2321(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);

v_j.p_233 := v_j.p_2331-v_j.p_231-v_j.p_2321;
                                J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);

v_j.p_2322 := 0;                J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);

v_j.p_23 := v_j.p_231 + v_j.p_232 + v_j.p_233;
                                J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);

--Be kellett tenni a P_23-at is, ezért került ide!!!
--p21-p22
t_variable := (J_KETTOS_FUGG_T.p_22(c_sema, c_m003, v_year, v_verzio, v_teszt)
               + J_KETTOS_FUGG_T.p_21(c_sema, c_m003, v_year, v_verzio, v_teszt));
IF t_variable = 0 THEN 
  v_j.p_21 := 0;
ELSE
  v_j.p_21 := (J_SZEKT_EVES_T.FUGG(c_sema,c_m003, 'PVC031', v_year, v_verzio, v_teszt) - v_j.p_23)
              * ((J_KETTOS_FUGG_T.p_21(c_sema, c_m003, v_year, v_verzio, v_teszt)) / t_variable);
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21);
IF t_variable = 0 THEN
  v_j.p_22 := 0;
ELSE
  v_j.p_22 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC031', v_year, v_verzio, v_teszt) - v_j.p_23)
              * ((J_KETTOS_FUGG_T.p_22(c_sema, c_m003, v_year, v_verzio, v_teszt)) / t_variable);
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);


--p24
v_j.p_24 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);

--p26
t_variable := J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema, c_m003,'PRCA019', '', v_year, v_verzio, v_teszt);
IF t_variable = 0 THEN
  v_j.p_262 := 0;
ELSE
  v_j.p_262 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC030', v_year, v_verzio, v_teszt)
                * (J_KETTOS_FUGG_T.d_11121(c_sema, c_m003, v_year, v_verzio, v_teszt) / t_variable)) * J_KONST_T.P_262_TERM_SZORZO;
--  v_j.p_262 := (J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC030')
--                * (J_KETTOS_FUGG_T.d_11121(c_sema, c_m003) / t_variable)) * 0.05; 
                                                      -- 0.0379 volt 2017.04.26
  --(J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC030')/t_variable)
  --                 * J_KETTOS_FUGG_T.p_262(c_sema,c_m003);
END IF;
/*2015v: D.11121*0,05*/
/*2015e: D.11121*0,0379*/
                                J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);
v_j.p_26 := v_j.p_262;          J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);

--p27
v_j.p_27 := 0; -- 2017.04.26
            /*2015v: 0*/
            /*2015e: 1529-A-02-01/12a első 'a' oszlop + egyedi korrekció*/
--v_j.p_27 := J_KETTOS_FUGG_T.p_27(c_sema,c_m003)+0;--egyedi korrekció
                                J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);

v_j.p_28 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC008', v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'P_291', v_betoltes);
IF p.f = 2 THEN
v_j.p_291 := p.v;
ELSE
v_j.p_291 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);


v_j.p_292 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);

v_j.p_293 := 0;                 J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293); --ED 20170327
            /*2015v: külön adat*/

v_j.p_29 := v_j.p_291 + v_j.p_292 + v_j.p_293;
            /*2015v: P.291+P.292+P.293*/
            /*2015e: P.291+292*/
                                J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);   --ED 20170327

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 + v_j.p_27 + v_j.p_28 + v_j.p_29; 
                                J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);
--b.1g kiszámítása
v_j.b_1g := v_j.p_1-v_j.p_2;    J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);
v_j.K_1 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC032', v_year, v_verzio, v_teszt)-v_j.p_27;
                                J_SZEKT_EVES_T.FELTOLT('K_1', v_j.k_1);
v_j.b_1n := v_j.b_1g-v_j.K_1;   J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);

--D21 kiszámolása
v_j.d_2111 := 0;                J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);
v_j.d_211 := v_j.d_2111;        J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);

v_j.d_212 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);

v_j.d_214D := 0;/*KÜLÖN ADAT*/  J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214d);
v_j.d_214F := v_j.p_1361 ;      J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);
v_j.d_214G1 := v_j.p_1362;      J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);
v_j.d_214E := v_j.p_1363;       J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);
v_j.d_214I73 := v_j.p_1366;     J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);
v_j.d_214I3 := v_j.p_1367;      J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);
v_j.d_214I := v_j.p_1365;       J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);
v_j.d_214BA := v_j.p_1364;      J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E 
             + v_j.d_214I73 + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA;
                                J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);

--D.31 kiszámítása
v_j.d_312 := 0  ;              J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);
v_j.d_31922 := 0;/*KÜLÖN ADAT*/ 
                                J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);
v_j.d_3192 := v_j.d_31922;      J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);
v_j.d_31 := v_j.d_319 + v_j.d_312;
                                J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);


-- ------------D.1 kiszámítása

t_variable := J_KETTOS_FUGG_T.kettos_fugg(c_sema, c_m003, 'PRCA019', '', v_year, v_verzio, v_teszt);
IF t_variable = 0 THEN 
  v_j.d_1111 := 0;
ELSE
  v_j.d_1111 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC030', v_year, v_verzio, v_teszt)
                * (J_KETTOS_FUGG_T.d_1111(c_sema,c_m003, v_year, v_verzio, v_teszt)/t_variable);
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);
IF t_variable = 0 THEN 
  v_j.d_11121 := 0;
ELSE
  v_j.d_11121 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC030', v_year, v_verzio, v_teszt)
                 * (J_KETTOS_FUGG_T.d_11121(c_sema, c_m003, v_year, v_verzio, v_teszt) / t_variable);
END IF;

                                J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);

v_j.d_11124 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);
v_j.d_11123 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, 
                                  c_m003,
                                  'NVL(LALA064,0)+NVL(LALA072,0)+NVL(LALA045,0)')
              - v_j.d_11124;
                                J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);
v_j.d_11125 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003, 'NVL(LALA026,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);
v_j.d_11126 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA056,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);

-- itt már nincsen szükség korrekcióra. 2017.09.15
/*
p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_11127');
IF p.f = 2 THEN
v_j.d_11127 := p.v;
ELSE
v_j.d_11127 := J_KETTOS_FUGG_T.d_11127(c_sema,c_m003) + p.v;
END IF;
*/
v_j.d_11127 := J_KETTOS_FUGG_T.d_11127(c_sema,c_m003, v_year, v_verzio, v_teszt);

                                J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);

v_j.d_11128 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);
v_j.d_11129 := 0;               J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA044,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(LALA135,0)');        
                                J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);


-- beszúrva d_11124: 2017.08.11
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;
                                J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);

v_j.d_111 := v_j.d_1111 + v_j.d_1112; 
                                J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);

--d112
v_j.d_1121 := v_j.p_16 
              + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 
--              + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)') * 0.3525;
              /*2015v: P.16+(1508A-01-01/02c)*0,0,3525 (előzetes sémában előző évi TÁSA számok)*/
              /*2015e: P.16+(1408-01-01/02c)*0,4641 (előzetes sémában előző évi TÁSA számok)*/
                                                       --0.4641 volt 2017.04.26
                                J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;         J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
v_j.d_1123 := J_KETTOS_FUGG_T.d_1123(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;        J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;      J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;      J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;      J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
v_j.d_1128 := v_j.d_11131;      J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125 + v_j.d_1126
            + v_j.d_1127 + v_j.d_1128;
                                J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;
                                J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);

--d121
v_j.d_1212 := 0;                J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);

t_variable := J_KETTOS_FUGG_T.kettos_fugg(c_sema, c_m003, 'PRCA019', '', v_year, v_verzio, v_teszt);
IF t_variable = 0 THEN 
  v_j.d_1211 := 0;
ELSE
  v_j.d_1211 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC030', v_year, v_verzio, v_teszt)
                * (J_KETTOS_FUGG_T.kettos_fugg(c_sema, c_m003, 'PRCA094', '', v_year, v_verzio, v_teszt)
                   / t_variable);
END IF;

v_j.d_1211 := v_j.d_1211 - J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'LALA175')
              - J_KETTOS_FUGG_T.d_29c2(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);
v_j.d_1213 := v_j.d_11125;      J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);
v_j.d_1214 := v_j.d_11124;      J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);
v_j.d_1215 := v_j.d_11128;      J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);

--d122
v_j.d_1221 := v_j.d_11126;      J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);
v_j.d_1222 := v_j.d_11123;      J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);
v_j.d_122 := v_j.d_1221 + v_j.d_1222; 
                                J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122;
                                J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12; 
                                J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);


------------D.29

v_j.d_29C1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'LALA175');--J_KETTOS_FUGG_T.d_29c1(c_sema,c_m003);                                    
                                J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);
v_j.d_29C2 := J_KETTOS_FUGG_T.d_29c2(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2; 
                                J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B1', v_betoltes);
IF p.f = 2 THEN
v_j.d_29b1 := p.v;
ELSE
v_j.d_29b1 := J_KETTOS_FUGG_T.d_29b1(c_sema,c_m003,'', v_year, v_verzio, v_teszt) + p.v;
END IF;



                                J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_29B3', v_betoltes);
IF p.f = 2 THEN
v_j.d_29b3 := p.v;
ELSE
v_j.d_29b3 := J_KETTOS_FUGG_T.d_29b3(c_sema,c_m003, v_year, v_verzio, v_teszt) + p.v;
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
v_j.d_2953 := 0;/*KÜLÖN ADAT */ J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);
v_j.d_29E3 := 0;                J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);


v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953 + v_j.d_29E3;
                                J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);

v_j.d_3911 := 0;/*KÜLÖN ADAT */ J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);
v_j.d_391 := v_j.d_3911;        J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);

v_j.d_39251 := 0;/*KÜLÖN ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);
v_j.d_39253 := J_KETTOS_FUGG_T.d_39253(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);
v_j.d_392 := v_j.d_3925;        J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);

v_j.d_394 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g-v_j.d_1-v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);
v_j.b_2n := v_j.b_1n-v_j.d_1-v_j.d_29 + v_j.d_39;
                                J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);


------------D.42-------
v_j.d_41211 := J_KETTOS_FUGG_T.d_41211(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41212', v_betoltes);
IF p.f = 2 THEN
v_j.d_41212 := p.v;
ELSE
v_j.d_41212 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC001', v_year, v_verzio, v_teszt) - v_j.d_41211 + p.v;  
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412131', v_betoltes);
IF p.f = 2 THEN
v_j.d_412131 := 0 + p.v;
ELSE
v_j.d_412131 := 0 + p.v;/*KÜLÖN ADAT */
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);


v_j.d_412132 := 0;/*KÜLÖN ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);

v_j.d_41221 := J_KETTOS_FUGG_T.d_41221(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_41222', v_betoltes);
IF p.f = 2 THEN
v_j.d_41222 := p.v;
ELSE
v_j.d_41222 := J_SZEKT_EVES_T.FUGG(c_sema, c_m003, 'PVC002', v_year, v_verzio, v_teszt)-v_j.d_41221+p.v;              
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_412231', v_betoltes);
IF p.f = 2 THEN
v_j.d_412231 := 0 + p.v;/*KÜLÖN ADAT */
ELSE
v_j.d_412231 := 0 + p.v;/*KÜLÖN ADAT */
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);

v_j.d_412232 := 0;/*KÜLÖN ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);
v_j.d_41223 := v_j.d_412231-v_j.d_412232;
                                J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);
v_j.d_412 := v_j.d_4121-v_j.d_4122; 
                                J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);

--d41
v_j.d_413 := v_j.d_1123;        J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);
v_j.d_41 := v_j.d_412 + v_j.d_413;
                                J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);
--d42

v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_421');
                                J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4221', v_betoltes);
IF p.f = 2 THEN
v_j.d_4221 := p.v;
ELSE
v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4221') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4222', v_betoltes);
IF p.f = 2 THEN
v_j.d_4222 := p.v;
ELSE
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4222') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4223', v_betoltes);
IF p.f = 2 THEN
v_j.d_4223 := p.v;
ELSE
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4223') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4224', v_betoltes);
IF p.f = 2 THEN
v_j.d_4224 := p.v;
ELSE
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4224') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4225', v_betoltes);
IF p.f = 2 THEN
v_j.d_4225 := p.v;
ELSE
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'D_4225') + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_4226', v_betoltes);
IF p.f = 2 THEN
v_j.d_4226 := 0 + p.v;  
ELSE
v_j.d_4226 := 0 + p.v;  
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);

v_j.d_42 := v_j.d_421-v_j.d_422;
                                J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);


p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_44132', v_betoltes);
IF p.f = 2 THEN
v_j.d_44132 := 0 + p.v;
ELSE
v_j.d_44132 := 0 + p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);

v_j.d_44131 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);
v_j.d_4412 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);
v_j.d_4411 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);


v_j.d_44232 := 0;               J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);
v_j.d_44231 := v_j.d_44231 + v_j.d_44232;
                                J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);
v_j.d_4423 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423);
v_j.d_4422 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);
v_j.d_4421 := 0;                J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);

-----------------D.4---------------

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_431', v_betoltes);
IF p.f = 2 THEN
v_j.d_431 := 0 + p.v; 
ELSE
v_j.d_431 := 0 + p.v; 
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_432', v_betoltes);
IF p.f = 2 THEN
v_j.d_432 := 0 + p.v;/*KÜLÖN ADAT MNB */                             
ELSE
v_j.d_432 := 0 + p.v;/*KÜLÖN ADAT MNB */                             
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);

v_j.d_43 := v_j.d_431-v_j.d_432;
                                J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);
v_j.d_44 := v_j.d_441 + v_j.d_442;
                                J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);
v_j.d_45 := J_KETTOS_FUGG_T.d_45(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);
v_j.d_46 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);
v_j.d_4 := v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44-v_j.d_45-v_j.d_46;
                                J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4; J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);
v_j.b_5n := v_j.b_2n + v_j.d_4; J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);


---------------D.5---------------
v_j.d_51B11 := J_KETTOS_FUGG_T.d_51B11(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);
/*2015v: 1529-01-01/15c*/                                
/*2015e: 1529-01-01/15c*/
v_j.d_51B12 := J_KETTOS_FUGG_T.d_51B12(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);

p := J_KORR_T.KORR_FUGG(v_year, c_sema, c_m003, 'D_51B13', v_betoltes);
IF p.f = 2 THEN
v_j.d_51B13 := p.v;
ELSE
v_j.d_51B13 := p.v;
END IF;
                                J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;
                                J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);
---------------D.6---------------

v_j.d_611 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);
v_j.d_612 := v_j.d_122;         J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);
v_j.d_613 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);
v_j.d_614 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);
v_j.d_61SC := 0;                J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);
v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614-v_j.d_61SC;
                                J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);

v_j.d_621 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);
v_j.d_622 := v_j.d_122;         J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);
v_j.d_623 := 0;                 J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);


v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);
v_j.d_6 := v_j.d_61-v_j.d_62;   J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);

---------------D.7---------------
v_j.d_711 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);
v_j.d_712 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);
v_j.d_71 := v_j.d_711 + v_j.d_712;
                                J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);

v_j.d_721 := v_j.p_2321-v_j.p_232;
                                J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);
v_j.d_722 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);
v_j.d_72 := v_j.d_721 + v_j.d_722;
                                J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);

v_j.d_7511 := J_KETTOS_FUGG_T.d_7511(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);
v_j.d_7512 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);
v_j.d_7513 := 0;/*BECSÜLT ADAT */
                                J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);

v_j.d_7521 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);
v_j.d_7522 := J_KETTOS_FUGG_T.d_7522(c_sema,c_m003, v_year, v_verzio, v_teszt);
                                J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);
v_j.d_7523 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);
v_j.d_7524 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);
v_j.d_7525 := 0;                J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);
v_j.d_7526 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);
v_j.d_7527 := 0;/*KÜLÖN ADAT KÜLFÖLDTŐL */
                                J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);

v_j.d_75 := v_j.d_751-v_j.d_752;
                                J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);

v_j.d_7 := v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);


---------------B.6g---------------
v_j.b_6g := v_j.b_5g-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);
v_j.b_6n := v_j.b_5n-v_j.d_5 + v_j.d_61-v_j.d_62 + v_j.d_71-v_j.d_72 + v_j.d_75;
                                J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);
v_j.d_8 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);
v_j.b_8g := v_j.b_6g-v_j.d_8;   J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);
v_j.b_8n := v_j.b_6n-v_j.d_8;   J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);

END FISIM_TERM;


---------------------------------------------------------------------
-- Kettősök
-- 6491, 6492 FISIM-felhasználók, 6499, 6611, 6612, 6619, 6621, 6622, 6629,
-- 6630
-- Csak itt: 11-es futtatásához c_lepes bemeneti változó (1,2,3,4,5,6 v. 7)
-- Ehhez: mesg_szamok függvénybe bekerul még egy paraméter, a lépés. 
-- (2017.08.31)
PROCEDURE KETTOSOK(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2,c_m003 VARCHAR2,
                   c_lepes VARCHAR2 DEFAULT '0') AS
 pfc004 NUMBER(15);
 pfc061 NUMBER(15);
 k NUMBER(15);
--k1 number(15);
--temp number(15);
--type c_temp1d is table of varchar2(20) index by binary_integer;
 p PAIR;
BEGIN
p := PAIR.INIT;
--v_arr1.EXTEND(227);                   --ED 20170329
--v_arr2.extend(227);
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j); 
v_k :=  J_KETTOSOK.GETNULL(v_k);
v_k  :=  J_KETTOS_FUGG_T.KETTOS_FUGG_UJ(c_sema, c_m003, c_lepes, v_year, v_verzio, v_teszt);

--p11 kiszámítás
v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118); --v_arr1(1) := 'P_118'; v_arr2(1) := v_j.p_118; -- ED 20170327
            /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);  --v_arr1(1) := 'P_119'; v_arr2(1) := v_j.p_119;

--p111 kiszámítás
v_j.p_11111 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);  --v_arr1(2) := 'P_11111'; v_arr2(2) := v_j.p_11111;
v_j.p_11112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);   -- v_arr1(3) := 'P_11112';v_arr2(3) := v_j.p_11112;
v_j.p_1111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);  -- v_arr1(4) := 'P_1111';v_arr2(4) := v_j.p_1111;

v_j.p_1112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);  -- v_arr1(5) := 'P_1112';v_arr2(5) := v_j.p_1112;
v_j.p_1113 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);  -- v_arr1(6) := 'P_1113';v_arr2(6) := v_j.p_1113;
v_j.p_1114 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);  -- v_arr1(7) := 'P_1114';v_arr2(7) := v_j.p_1114;
v_j.p_111 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);  -- v_arr1(8) := 'P_111';v_arr2(8) := v_j.p_111;

--p112
v_j.p_1121 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);  -- v_arr1(9) := 'P_1121';v_arr2(9) := v_j.p_1121;
v_j.p_1122 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);  -- v_arr1(10) := 'P_1122';v_arr2(10) := v_j.p_1122;
v_j.p_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);  -- v_arr1(11) := 'P_1123';v_arr2(11) := v_j.p_1123;
v_j.p_112 := v_j.p_1121 + v_j.p_1123;
                                   J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);  -- v_arr1(12) := 'P_112';v_arr2(12) := v_j.p_112;

--p113
v_j.p_1131 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);  -- v_arr1(13) := 'P_1131';v_arr2(13) := v_j.p_1131;
v_j.p_1132 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);  -- v_arr1(14) := 'P_1132';v_arr2(14) := v_j.p_1132;
v_j.p_113 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);  -- v_arr1(15) := 'P_113';v_arr2(15) := v_j.p_113;

--p115-p116
v_j.p_1151 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);  -- v_arr1(16) := 'P_1151';v_arr2(16) := v_j.p_1151;
v_j.p_1152 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);  -- v_arr1(17) := 'P_1152';v_arr2(17) := v_j.p_1152;
v_j.p_115 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);  -- v_arr1(18) := 'P_115';v_arr2(18) := v_j.p_115;

v_j.p_116 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);  -- v_arr1(19) := 'P_116';v_arr2(19) := v_j.p_116;

--v_j.p_11 := v_j.p_119 + v_j.p_112 + v_j.p_118;   v_arr1(20) := 'P_11';
--v_arr2(20) := v_j.p_11; -- ED 20170327
v_j.p_11 := v_j.p_119 + v_j.p_112; 
                                   J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);   --v_arr1(20) := 'P_11';v_arr2(20) := v_j.p_11;

--p12 kiszámítás

v_j.p_1221 := v_k.c_prca092;       J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);  --v_arr1(21) := 'P_1221';v_arr2(21) := v_j.p_1221;
v_j.p_1222 := v_k.c_prca091;       J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222);  --v_arr1(22) := 'P_1222';v_arr2(22) := v_j.p_1222;


v_j.p_122 := v_j.p_1222 + v_j.p_1221;
                                   J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);  --v_arr1(23) := 'P_122';v_arr2(23) := v_j.p_122;


-- p.121 új 2018.09.10
--dbms_output.put_line('-----eredeti értékek:---- prca103:' || v_k.c_prca103 || ', prca167:' || v_k.c_prca167);
IF v_k.c_prca103 <> 0 THEN
  v_j.p_121 := v_k.c_prca103;
--  dbms_output.put_line('prca103 kerül be, ami: ' || v_j.p_121);
ELSE
  v_j.p_121 := v_k.c_prca167;
--  dbms_output.put_line('prca167 kerül be, ami: ' || v_j.p_121);
END IF;


                                   J_SZEKT_EVES_T.feltolt('P_121', v_j.p_121);


--v_j.p_121 := v_k.c_prca103;        J_SZEKT_EVES_T.feltolt('P_121', v_j.p_121);  --v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;


v_j.p_1211 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);  --v_arr1(25) := 'P_1211';v_arr2(25) := v_j.p_1211;
v_j.p_1212 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);  --v_arr1(26) := 'P_1212';v_arr2(26) := v_j.p_1212;

v_j.p_12 := v_j.p_121 - v_j.p_122; 
                                   J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);  --v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;

--p13 kiszámítás
v_j.p_1363 := v_k.c_prja200*0.9;   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);  --v_arr1(28) := 'P_1363';v_arr2(28) := v_j.p_1363;

v_j.p_1361 := v_k.c_prja019 - v_j.p_1363;
                                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);  --v_arr1(29) := 'P_1361';v_arr2(29) := v_j.p_1361;
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);  --v_arr1(30) := 'P_1362';v_arr2(30) := v_j.p_1362;

v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);  --v_arr1(31) := 'P_1364';v_arr2(31) := v_j.p_1364;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_1365', v_betoltes);
IF p.f = 2 THEN
 v_j.p_1365 := p.v;
ELSE
 v_j.p_1365 := p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);    --v_arr1(32) := 'P_1365';v_arr2(32) := v_j.p_1365;

v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);  --v_arr1(33) := 'P_1366';v_arr2(33) := v_j.p_1366;


p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_1367', v_betoltes);
IF p.f = 2 THEN
 v_j.p_1367 := p.v;
ELSE
 v_j.p_1367 := p.v;
END IF;
--J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'P_1367',c_lepes);
                                   J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367); --v_arr1(34) := 'P_1367';v_arr2(34) := v_j.p_1367;

v_j.p_132 := v_j.p_1361 + v_j.p_1362 + v_j.p_1363 + v_j.p_1364 
             + v_j.p_1365 + v_j.p_1366 + v_j.p_1367;
                                   J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132); --v_arr1(35) := 'P_132';v_arr2(35) := v_j.p_132; 

--v_j.p_1311 := 0;                                                              v_arr1(-4+62) := 'P_1311';v_arr2(-4+62) := v_j.p_1311;
v_j.p_1312 := v_k.c_prja049;       J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312); --v_arr1(36) := 'P_1312';v_arr2(36) := v_j.p_1312;
v_j.p_131 := v_j.p_1312;           J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131); --v_arr1(37) := 'P_131';v_arr2(37) := v_j.p_131;

v_j.p_13 := v_j.p_132 - v_j.p_131; 
                                   J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13); --v_arr1(38) := 'P_13';v_arr2(38) := v_j.p_13;

--p14   --p16

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_14', v_betoltes);
IF p.f = 2 THEN
 v_j.p_14 := p.v;
ELSE
 v_j.p_14 := v_k.c_prca007 + p.v;   
END IF;

                                   J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);   --v_arr1(39) := 'P_14';v_arr2(39) := v_j.p_14;



v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)',c_lepes) * J_KONST_T.P_15_TERM_SZORZO;
--v_j.p_15 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)',c_lepes) * 0.3356; --0.0691 volt 2017.04.27
            /*2015v: (1508A-01-01/02c)*0,3356 (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*0,0691 (előzetes sémában előző évi TÁSA számok)*/
                                   J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);  --v_arr1(40) := 'P_15';v_arr2(40) := v_j.p_15;


v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)',c_lepes) * J_KONST_T.P_16_TERM_SZORZO;
--v_j.p_16 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema, c_m003, 'NVL(PRJA045,0)',c_lepes) * 0.5787; --1.4548 volt 2017.04.27S
            /*2015v: (1508A-01-01/02c)*0,5787 (előzetes sémában előző évi TÁSA számok)*/
            /*2015e: (1508A-01-01/02c)*1,4548 (előzetes sémában előző évi TÁSA számok)*/
                                   J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);  --v_arr1(41) := 'P_16';v_arr2(41) := v_j.p_16;


 --P1 kiszámítás
v_j.p_1 := v_j.p_11 + v_j.p_12 - v_j.p_13 + v_j.p_14 + v_j.p_15 + v_j.p_16;                   
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);  --v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;

--p21-p22
v_j.p_21 := v_k.c_prca008;         J_SZEKT_EVES_T.feltolt('P_21', v_j.p_21);  --v_arr1(43) := 'P_21';v_arr2(43) := v_j.p_21;


-- p22 új 2018.09.10
IF v_k.c_prca090 <> 0 THEN
  v_j.p_22 := v_k.c_prca090;
  --dbms_output.put_line('prca090 kerül be');
ELSE
  v_j.p_22 := v_k.c_prca172;
  --dbms_output.put_line('prca172 kerül be');
END IF;

--dbms_output.put_line('-bekerült-' || v_j.p_22);
--dbms_output.put_line('-eredeti értékek:-' || v_k.c_prca090 || ' ' || v_k.c_prca172);


                                    J_SZEKT_EVES_T.feltolt('P_22', v_j.p_22);
                                    

--v_j.p_22 := v_k.c_prca090;         J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22);  --v_arr1(44) := 'P_22';v_arr2(44) := v_j.p_22;

--p23
v_j.p_2331 := v_k.c_prca093;       J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);  --v_arr1(45) := 'P_2331';v_arr2(45) := v_j.p_2331;

v_j.p_231 := v_k.c_prca022;        J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);  --v_arr1(46) := 'P_231';v_arr2(46) := v_j.p_231;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_232', v_betoltes);
IF p.f = 2 THEN
 v_j.p_232 := p.v;
ELSE
 v_j.p_232 := p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);   --v_arr1(47) := 'P_232';v_arr2(47) := v_j.p_232;
v_j.p_2321 := v_k.c_prca023;       J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);   --v_arr1(48) := 'P_2321';v_arr2(48) := v_j.p_2321;
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);   --v_arr1(49) := 'P_2322';v_arr2(49) := v_j.p_2322;

v_j.p_233 := v_j.p_2331-v_j.p_231 - v_j.p_2321; 
                                   J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);   --v_arr1(50) := 'P_233';v_arr2(50) := v_j.p_233;
v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                   J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);--v_arr1(51) := 'P_23';v_arr2(51) := v_j.p_23;

--p24
v_j.p_24 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);   --v_arr1(52) := 'P_24';v_arr2(52) := v_j.p_24;

--p26
--v_j.p_261 := 0;                             v_arr1(-4+63) := 'P_261';v_arr2(-4+63) := v_j.p_261;
v_j.p_262 := v_k.c_prca017 * J_KONST_T.P_262_TERM_SZORZO;
--v_j.p_262 := v_k.c_prca017 * 0.05; --0.0379 volt 2017.04.27
             /*2015v: D.11121*0,05*/
             /*2015e: D.11121*0,0379*/
                                   J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);   --v_arr1(53) := 'P_262';v_arr2(53) := v_j.p_262;
v_j.p_26 := v_j.p_262;             J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);   --v_arr1(54) := 'P_26';v_arr2(54) := v_j.p_26;

--p27
v_j.p_27 := 0; -- 2017.04.27
            /*2015v: 0*/
            /*2015e: 1529-A-02-01/12a első 'a' oszlop + egyedi korrekció*/
--v_j.p_27 := v_k.c_prda082 + 0;
                                   J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);   --v_arr1(55) := 'P_27';v_arr2(55) := v_j.p_27;
v_j.p_28 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);   --v_arr1(56) := 'P_28';v_arr2(56) := v_j.p_28;


p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_291', v_betoltes);
IF p.f = 2 THEN
v_j.p_291 := p.v;
ELSE
v_j.p_291 := p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291); --v_arr1(57) := 'P_291';v_arr2(57) := v_j.p_291;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'P_292', v_betoltes);
IF p.f = 2 THEN
v_j.p_292 := p.v;
ELSE
v_j.p_292 := p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292); --v_arr1(58) := 'P_292';v_arr2(58) := v_j.p_292;

v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
             /*2015v: külön adat*/
--v_j.p_293 := 0;                                                                 v_arr( ) := 'P_293';v_arr2( ) := v_j.p_293;        -- ED 20170327
--v_j.p_29 := v_j.p_293 + v_j.p_292 + v_j.p_291;                                    v_arr1(59) := 'P_29';v_arr2(59) := v_j.p_29; -- ED 20170327
v_j.p_29 := v_j.p_291 + v_j.p_292 + v_j.p_293;
            /*2015v: P.291+P.292+P.293*/
            /*2015e: P.291+292*/
                                   J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);--     v_arr1(59) := 'P_29';v_arr2(59) := v_j.p_29;

--p2
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23 + v_j.p_24 - v_j.p_26 
           + v_j.p_27 + v_j.p_28 + v_j.p_29; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);--v_arr1(60) := 'P_2';v_arr2(60) := v_j.p_2;
--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;     J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);--v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;

IF v_j.b_1g < 0 THEN 
    pfc004 := v_k.c_prca004;
    v_j.b_1g := v_j.b_1g + pfc004; 
    IF v_j.b_1g >= 0 THEN
       k := pfc004 - v_j.b_1g;
       v_j.b_1g := 0; 
    ELSE 
      k := pfc004;
      v_j.b_1g := v_j.b_1g; 
    END IF;

    v_j.p_121 := v_j.p_121 + k;    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);--v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;
    v_j.p_12 := v_j.p_12 + k;      J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);--v_arr1(27) := 'P_12'; v_arr2(27) := v_j.p_12;
    v_j.p_1 := v_j.p_1 + k;        J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);--v_arr1(42) := 'P_1';  v_arr2(42) := v_j.p_1;
                                   J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);--v_arr1(61) := 'B_1g'; v_arr2(61) := v_j.b_1g;
END IF;

 k := 0;

IF v_j.b_1g < 0 THEN 
    pfc061 := v_k.c_prca150 + v_k.c_prca151;
    v_j.b_1g := v_j.b_1g + pfc061; 
    IF v_j.b_1g >= 0 THEN
      k := pfc061 - v_j.b_1g;
      v_j.b_1g := 0; 
    ELSE 
      k := pfc061;
      v_j.b_1g := v_j.b_1g; 
    END IF;

    v_j.p_121 := v_j.p_121 + k;    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);--v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;
    v_j.p_12 := v_j.p_12 + k;      J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);-- v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;
    v_j.p_1 := v_j.p_1 + k;        J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);--v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;

                                   J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);--v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;
END IF;

 /*
  dbms_output.put_line('  *********************************************  ');
  dbms_output.put_line(c_m003||'  k:     '||k);
  dbms_output.put_line(c_m003||'  b1g     '||v_j.b_1g);
  dbms_output.put_line(c_m003||'  p1    '||v_j.p_1);
  dbms_output.put_line(c_m003||'  p2     '||v_j.p_2);
     dbms_output.put_line(' *******************************************  ');
*/

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'K_1', v_betoltes);
IF p.f = 2 THEN
 v_j.K_1 := p.v;
ELSE
 v_j.K_1 := v_k.c_prca020 - v_j.p_27 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('K_1', v_j.K_1);  -- v_arr1(-4+66) := 'K_1';v_arr2(-4+66) := v_j.k_1;
v_j.b_1n := v_j.b_1g - v_j.K_1;    J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n); -- v_arr1(-4+67) := 'B_1n';v_arr2(-4+67) := v_j.b_1n;

--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);  -- v_arr1(-4+68) := 'D_2111';v_arr2(-4+68) := v_j.d_2111;
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);  -- v_arr1(-4+69) := 'D_211';v_arr2(-4+69) := v_j.d_211;

v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);  -- v_arr1(-4+70) := 'D_212';v_arr2(-4+70) := v_j.d_212;

v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214D);   -- v_arr1(-4+71) := 'D_214D';v_arr2(-4+71) := v_j.d_214d;
v_j.d_214F := v_j.p_1361;          J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);   -- v_arr1(-4+72) := 'D_214F';v_arr2(-4+72) := v_j.d_214F;
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);  -- v_arr1(-4+73) := 'D_214G1';v_arr2(-4+73) := v_j.d_214G1;
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);  -- v_arr1(-4+74) := 'D_214E';v_arr2(-4+74) := v_j.d_214E;
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);  --  v_arr1(-4+75) := 'D_214I73';v_arr2(-4+75) := v_j.d_214I73;
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);  -- v_arr1(-4+76) := 'D_214I3';v_arr2(-4+76) := v_j.d_214I3;
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);  -- v_arr1(-4+77) := 'D_214I';v_arr2(-4+77) := v_j.d_214I;
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);  -- v_arr1(-4+78) := 'D_214A2';v_arr2(-4+78) := v_j.d_214BA; --?

v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E 
             + v_j.d_214I73 + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA; 
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);  -- v_arr1(-4+79) := 'D_214';v_arr2(-4+79) := v_j.d_214;
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                   J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21); -- v_arr1(-4+80) := 'D_21';v_arr2(-4+80) := v_j.d_21;

--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);  -- v_arr1(-4+81) := 'D_312';v_arr2(-4+81) := v_j.d_312;
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);  -- v_arr1(-4+82) := 'D_31922';v_arr2(-4+82) := v_j.d_31922;
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);  -- v_arr1(-4+83) := 'D_3192';v_arr2(-4+83) := v_j.d_3192;
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);  -- v_arr1(-4+84) := 'D_319';v_arr2(-4+84) := v_j.d_319;
v_j.d_31 := v_j.d_319 + v_j.d_312; 
                                   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);  -- v_arr1(-4+85) := 'D_31';v_arr2(-4+85) := v_j.d_31;


-- ------------D.1 kiszámítása

--d_111
v_j.d_1111 := v_k.c_prca016;       J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111);   --v_arr1(-4+86) := 'D_1111';v_arr2(-4+86) := v_j.d_1111;

v_j.d_11121 := v_k.c_prca017;      J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121);   --v_arr1(-4+87) := 'D_11121';v_arr2(-4+87) := v_j.d_11121;
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124);   --v_arr1(-4+88) := 'D_11124';v_arr2(-4+88) := v_j.d_11124;

v_j.d_11123 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,
                                    c_m003,
                                    'NVL(LALA064,0)+NVL(LALA072,0)+NVL(LALA045,0)',
                                    c_lepes) 
               - v_j.d_11124;
                                   J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123);   --v_arr1(-4+89) := 'D_11123';v_arr2(-4+89) := v_j.d_11123;

v_j.d_11125 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'NVL(LALA026,0)',
                                    c_lepes);

                                   J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125);   --v_arr1(-4+90) := 'D_11125';v_arr2(-4+90) := v_j.d_11125;

v_j.d_11126 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'NVL(LALA056,0)',c_lepes);
                                   J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);   --v_arr1(-4+91) := 'D_11126';v_arr2(-4+91) := v_j.d_11126;

-- itt már nincs szükség korrekcióra. 2017.09.15
/*
p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_11127');
IF p.f = 2 THEN
v_j.d_11127 := p.v;
ELSE
v_j.d_11127 := v_k.c_prja087 / 0.1904 + p.v;  
END IF;
*/
-- új osztó és 0.5-ös szorzó (2017.09.15) Régi szorzó: 0.1904
v_j.d_11127 := (v_k.c_prja087 / J_KONST_T.d_11127_szorzo) * 0.5;
                                    J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);


v_j.d_11128 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);     --v_arr1(-4+93) := 'D_11128';v_arr2(-4+93) := v_j.d_11128;
v_j.d_11129 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);     --v_arr1(-4+94) := 'D_11129';v_arr2(-4+94) := v_j.d_11129;
v_j.d_11130 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'NVL(LALA044,0)',c_lepes);                                    
                                    J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);     --v_arr1(-4+95) := 'D_11130';v_arr2(-4+95) := v_j.d_11130;
--*********************************************************************************************
--HA NEM JÓ EZT FELTÉTLEN NÉZD MEG!!! (2014-09-03)
v_j.d_11131 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'NVL(LALA135,0)',c_lepes);
                                    J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);     --v_arr1(214) := 'D_11131';v_arr2(214) := v_j.d_11131;

--*********************************************************************************************
-- d_11124 bekerült: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125 - v_j.d_11126
              - v_j.d_11127 - v_j.d_11128 - v_j.d_11129 - v_j.d_11130
              - v_j.d_11131;
                                    J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);   --v_arr1(-4+96) := 'D_1112';v_arr2(-4+96) := v_j.d_1112;
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                    J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);   --v_arr1(93) := 'D_111';v_arr2(93) := v_j.d_111;

--d112
v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003, 'NVL(PRJA045,0)',c_lepes)
              * J_KONST_T.D_1121_TERM_SZORZO;
--v_j.d_1121 := v_j.p_16 + J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003, 'NVL(PRJA045,0)',c_lepes)
--              * 0.3525; --0.4641 volt 2017.04.27
              /*2015v: P.16+(1508A-01-01/02c)*0,0,3525 (előzetes sémában előző évi TÁSA számok)*/
--Előzetes
              /*2015e: P.16+(1508A-01-01/02c)*0,4641 (előzetes sémában előző évi TÁSA számok)*/
                                    J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);
v_j.d_1122 := v_j.p_15;             J_SZEKT_EVES_T.FELTOLT('D_1122', v_j.d_1122);
--v_j.d_1123 := v_k.c_prja088/0.54*0.5;
--v_j.d_1123 := (v_k.c_prja088 / 0.1785) * 0.5; -- új képlet: 2017.09.15
v_j.d_1123 := (v_k.c_prja088 / J_KONST_T.d_1123_szorzo) * 0.5; -- új képlet: 2017.09.15

                                    J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123);
v_j.d_1124 := v_j.p_262;            J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);
v_j.d_1125 := v_j.d_11127;          J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);
v_j.d_1126 := v_j.d_11129;          J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);
v_j.d_1127 := v_j.d_11130;          J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);
--**********************************************************************************************
--EZT IS!!! 2014-09-03
v_j.d_1128 := v_j.d_11131;          J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);  --v_arr1(215) := 'D_1128';v_arr2(215) := v_j.d_1128;
--**********************************************************************************************
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;                                                         
                                    J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);                    --v_arr1(208) := 'D_112';v_arr2(208) := v_j.d_112;

--d11
v_j.d_11 := v_j.d_111 + v_j.d_112;  J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);                    --v_arr1(101) := 'D_11';v_arr2(101) := v_j.d_11;

--d121
v_j.d_1212 := 0; /*ADAT HIÁNYÁBAN V_J.D_111*0.03*/ 
                                    J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212);--v_arr1(102) := 'D_1212';v_arr2(102) := v_j.d_1212;
v_j.d_1211 := v_k.c_prca094 - J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'LALA175',c_lepes)
              - v_k.c_prja013;
                                    J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);                   --v_arr1(103) := 'D_1211';v_arr2(103) := v_j.d_1211;
v_j.d_1213 := v_j.d_11125;          J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);                   --v_arr1(104) := 'D_1213';v_arr2(104) := v_j.d_1213;
v_j.d_1214 := v_j.d_11124;          J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);                   --v_arr1(105) := 'D_1214';v_arr2(105) := v_j.d_1214;
v_j.d_1215 := v_j.d_11128;          J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);                   --v_arr1(106) := 'D_1215';v_arr2(106) := v_j.d_1215;
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214 + v_j.d_1215;
                                    J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);                   --v_arr1(107) := 'D_121';v_arr2(107) := v_j.d_121;

--d122
v_j.d_1221 := v_j.d_11126;          J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);                   --v_arr1(-4+112) := 'D_1221';v_arr2(-4+112) := v_j.d_1221;
v_j.d_1222 := v_j.d_11123;          J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);                   --v_arr1(-4+113) := 'D_1222';v_arr2(-4+113) := v_j.d_1222;
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                    J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);                   --v_arr1(-4+114) := 'D_122';v_arr2(-4+114) := v_j.d_122;

--d12
v_j.d_12 := v_j.d_121 + v_j.d_122;  J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);                   --v_arr1(-4+115) := 'D_12';v_arr2(-4+115) := v_j.d_12;

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;     J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);                    --v_arr1(-4+116) := 'D_1';v_arr2(-4+116) := v_j.d_1;


------------D.29

v_j.d_29C1 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'LALA175',c_lepes);--v_k.c_paj0m061;                                                         
                                    J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);                    --v_arr1(-4+117) := 'D_29C1';v_arr2(-4+117) := v_j.d_29C1;
v_j.d_29C2 := v_k.c_prja013;        J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);                    --v_arr1(-4+118) := 'D_29C2';v_arr2(-4+118) := v_j.d_29C2;
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);                    --v_arr1(227) := 'D_29C';v_arr2(227) := v_j.d_29C;

--D.29B1 és D.29B3-ra nincs adat...
p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_29B1', v_betoltes);
IF p.f = 2 THEN
  v_j.d_29b1 := p.v;
ELSE
  --v_j.d_29b1 := p.v;
  v_j.d_29b1 := J_KETTOS_FUGG_T.D_29B1(c_sema, c_m003, c_lepes, v_year, v_verzio, v_teszt);
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1);                   --v_arr1(-4+119) := 'D_29B1';v_arr2(-4+119) := v_j.d_29b1;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_29B3', v_betoltes);
IF p.f = 2 THEN
  v_j.d_29b3 := p.v;
ELSE
  --v_j.d_29b3 := p.v;
  v_j.d_29b3 := v_k.c_prja050;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3);                   --v_arr1(-4+120) := 'D_29B3';v_arr2(-4+120) := v_j.d_29b3;

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/ 
                                    J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);--v_arr1(-4+121) := 'D_29A11';v_arr2(-4+121) := v_j.d_29A11;
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/   
                                    J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);--v_arr1(-4+122) := 'D_29A12';v_arr2(-4+122) := v_j.d_29A12;
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/ 
                                    J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);--v_arr1(-4+123) := 'D_29A2';v_arr2(-4+123) := v_j.d_29A2;
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                    J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A); --v_arr1(-4+124) := 'D_29A';v_arr2(-4+124) := v_j.d_29A;
v_j.d_2953 := 0;/*KÜLÖN ADAT */     J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);--v_arr1(-4+125) := 'D_2953';v_arr2(-4+125) := v_j.d_2953;
v_j.d_29E3 := 0;/*KÜLÖN ADAT */     J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);--v_arr1(216) := 'D_29E3';v_arr2(216) := v_j.d_29E3;

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;
                                    J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);                   --v_arr1(-4+126) := 'D_29';v_arr2(-4+126) := v_j.d_29;

--v_j.d_3912 := 0;/*KÜLÖN ADAT */                         --v_arr1(-4+64) := 'D_3912';v_arr2(-4+64) := v_j.d_3912;
v_j.d_3911 := 0;/*KÜLÖN ADAT */     J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);                    --v_arr1(-4+127) := 'D_3911';v_arr2(-4+127) := v_j.d_3911;
v_j.d_391 := v_j.d_3911;            J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);                    --v_arr1(-4+128) := 'D_391';v_arr2(-4+128) := v_j.d_391;

v_j.d_39251 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);                    --v_arr1(-4+129) := 'D_39251';v_arr2(-4+129) := v_j.d_39251;
--v_j.d_39254 := 0;/*KÜLÖN ADAT */                        --v_arr1(-4+65) := 'D_39254';v_arr2(-4+65) := v_j.d_39254;
v_j.d_39253 := v_k.c_prja065;       J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);                    --v_arr1(-4+130) := 'D_39253';v_arr2(-4+130) := v_j.d_39253;
v_j.d_3925 := v_j.d_39251 + v_j.d_39253; 
                                    J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);--v_arr1(-4+131) := 'D_3925';v_arr2(-4+131) := v_j.d_3925;
v_j.d_392 := v_j.d_3925;            J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);                    --v_arr1(-4+132) := 'D_392';v_arr2(-4+132) := v_j.d_392;

v_j.d_394 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);                     --v_arr1(-4+133) := 'D_394';v_arr2(-4+133) := v_j.d_394;
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394; 
                                    J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);--v_arr1(-4+134) := 'D_39';v_arr2(-4+134) := v_j.d_39;

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;           
                                    J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);--v_arr1(-4+135) := 'B_2g';v_arr2(-4+135) := v_j.b_2g;
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                    J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n); --v_arr1(-4+136) := 'B_2n';v_arr2(-4+136) := v_j.b_2n;


------------D.42-------
p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41211', v_betoltes);
IF p.f = 2 THEN
 v_j.d_41211 := p.v;
ELSE
 v_j.d_41211 := v_k.c_prca081 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211);                    --v_arr1(-4+137) := 'D_41211';v_arr2(-4+137) := v_j.d_41211;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41212', v_betoltes);
IF p.f = 2 THEN
 v_j.d_41212 := p.v;
ELSE
 v_j.d_41212 := v_k.c_prca150 + v_k.c_prca151 - v_j.d_41211 + p.v;
END IF;

                                    J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);                       --v_arr1(-4+138) := 'D_41212';v_arr2(-4+138) := v_j.d_41212;

v_j.d_412131 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);         --v_arr1(-4+139) := 'D_412131';v_arr2(-4+139) := v_j.d_412131;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412132', v_betoltes);
IF p.f = 2 THEN
 v_j.d_412132 := 0 + p.v;/*KÜLÖN ADAT */
ELSE
 v_j.d_412132 := 0 + p.v;/*KÜLÖN ADAT */
END IF;

                                    J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);         --v_arr1(-4+140) := 'D_412132';v_arr2(-4+140) := v_j.d_412132;
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                    J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);--v_arr1(-4+141) := 'D_41213';v_arr2(-4+141) := v_j.d_41213;
 --dbms_output.put_line('  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ');
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
 -- dbms_output.put_line(c_m003||'  d4121     '||v_j.d_4121);

v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213 - k;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);        --v_arr1(-4+142) := 'D_4121';v_arr2(-4+142) := v_j.d_4121;

--dbms_output.put_line(c_m003||'  d4121     '||v_j.d_4121);
--dbms_output.put_line('  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ');
v_j.d_41221 := v_k.c_prca078;       J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);--v_arr1(-4+143) := 'D_41221';v_arr2(-4+143) := v_j.d_41221;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41222', v_betoltes);
IF p.f = 2 THEN
v_j.d_41222 := p.v;
ELSE
v_j.d_41222 := v_k.c_prca149 + p.v;  
END IF;

                                    J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);--v_arr1(-4+144) := 'D_41222';v_arr2(-4+144) := v_j.d_41222;

v_j.d_412231 := 0; /*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);--v_arr1(-4+145) := 'D_412231';v_arr2(-4+145) := v_j.d_412231;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_412232', v_betoltes);
IF p.f = 2 THEN
 v_j.d_412232 := 0 + p.v;
ELSE
 v_j.d_412232 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);--v_arr1(-4+146) := 'D_412232';v_arr2(-4+146) := v_j.d_412232;


v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232; 
                                    J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);--v_arr1(-4+147) := 'D_41223';v_arr2(-4+147) := v_j.d_41223;

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                    J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);--v_arr1(-4+148) := 'D_4122';v_arr2(-4+148) := v_j.d_4122;
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                    J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);--v_arr1(-4+149) := 'D_412';v_arr2(-4+149) := v_j.d_412;

--d41
v_j.d_413 := v_j.d_1123;
                                    J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);--v_arr1(-4+150) := 'D_413';v_arr2(-4+150) := v_j.d_413;
v_j.d_41 := v_j.d_412 + v_j.d_413;
                                    J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);--v_arr1(-4+151) := 'D_41';v_arr2(-4+151) := v_j.d_41;
--d42
p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_421', v_betoltes);
IF p.f = 2 THEN
v_j.d_421 := p.v;
ELSE
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_421',c_lepes) + P.V; 
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);--v_arr1(-4+152) := 'D_421';v_arr2(-4+152) := v_j.d_421; --2009-es adat


p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4221', v_betoltes);
IF p.f = 2 THEN
 v_j.d_4221 := p.v;
ELSE
 v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4221',c_lepes) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);--v_arr1(-4+153) := 'D_4221';v_arr2(-4+153) := v_j.d_4221;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4222', v_betoltes);
IF p.f = 2 THEN
v_j.d_4222 := p.v;
ELSE
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4222',c_lepes) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);--v_arr1(-4+154) := 'D_4222';v_arr2(-4+154) := v_j.d_4222;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4223', v_betoltes);
IF p.f = 2 THEN
v_j.d_4223 := p.v;
ELSE
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4223',c_lepes) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223); --v_arr1(-4+155) := 'D_4223';v_arr2(-4+155) := v_j.d_4223;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4224', v_betoltes);
IF p.f = 2 THEN
v_j.d_4224 := p.v;
ELSE
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4224',c_lepes) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);--v_arr1(-4+156) := 'D_4224';v_arr2(-4+156) := v_j.d_4224;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4225', v_betoltes);
IF p.f = 2 THEN
v_j.d_4225 := p.v;
ELSE
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4225',c_lepes) + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);--v_arr1(-4+157) := 'D_4225';v_arr2(-4+157) := v_j.d_4225;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4226', v_betoltes);
IF p.f = 2 THEN
v_j.d_4226 := p.v;
ELSE
v_j.d_4226 := 0 + p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);--v_arr1(-4+158) := 'D_4226';v_arr2(-4+158) := v_j.d_4226;

v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                    J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);--v_arr1(-4+159) := 'D_422';v_arr2(-4+159) := v_j.d_422;

v_j.d_42 := v_j.d_421 - v_j.d_422;  J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);--v_arr1(-4+160) := 'D_42';v_arr2(-4+160) := v_j.d_42;

v_j.d_44131 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131);--v_arr1(209) := 'D_44131';v_arr2(209) := v_j.d_44131; --217

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_44132', v_betoltes);
IF p.f = 2 THEN
v_j.d_44132 := p.v;
ELSE
v_j.d_44132 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132);--v_arr1(210) := 'D_44132';v_arr2(210) := v_j.d_44132; --218

v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                    J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413);--v_arr1(211) := 'D_4413';v_arr2(211) := v_j.d_4413;   --219
v_j.d_4412 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412);--v_arr1(212) := 'D_4412';v_arr2(212) := v_j.d_4412;   --220
v_j.d_4411 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);--v_arr1(213) := 'D_4411';v_arr2(213) := v_j.d_4411;   --221 - ez a sor nem volt!
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                    J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);--v_arr1(214) := 'D_441';v_arr2(214) := v_j.d_441;     --221!!!

v_j.d_44231 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231);--v_arr1(215) := 'D_44231';v_arr2(215) := v_j.d_44231; --217
v_j.d_44232 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232);--v_arr1(216) := 'D_44232';v_arr2(216) := v_j.d_44232; --218
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;            
                                    J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423); --v_arr1(217) := 'D_4423';v_arr2(217) := v_j.d_4423;   --219
v_j.d_4422 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422);--v_arr1(218) := 'D_4422';v_arr2(218) := v_j.d_4422;   --220
v_j.d_4421 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);--v_arr1(219) := 'D_4421';v_arr2(219) := v_j.d_4421;   --221 - ez a sor nem volt!
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;    
                                    J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442);--v_arr1(220) := 'D_442';v_arr2(220) := v_j.d_442;     --221!!!


-----------------D.4---------------

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_431', v_betoltes);
IF p.f = 2 THEN
v_j.d_431 := 0+p.v;/*KÜLÖN ADAT MNB */
ELSE
v_j.d_431 := 0+p.v;/*KÜLÖN ADAT MNB */
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);--v_arr1(-4+161) := 'D_431';v_arr2(-4+161) := v_j.d_431;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_432', v_betoltes);
IF p.f = 2 THEN
v_j.d_432 := 0+p.v;/*KÜLÖN ADAT MNB */        
ELSE
v_j.d_432 := 0+p.v;/*KÜLÖN ADAT MNB */        
END IF;
--v_arr1(-4+162) := 'D_432';v_arr2(-4+162) := v_j.d_432;
v_j.d_43 := v_j.d_431 - v_j.d_432;  J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);--v_arr1(-4+163) := 'D_43';v_arr2(-4+163) := v_j.d_43;
v_j.d_44 := v_j.d_441 - v_j.d_442; /*SZÁMÍTOTT ADAT*/ 
                                    J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44); --v_arr1(-4+164) := 'D_44';v_arr2(-4+164) := v_j.d_44;
v_j.d_45 := v_k.c_prca024;
                                    J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45); --v_arr1(-4+165) := 'D_45';v_arr2(-4+165) := v_j.d_45;
v_j.d_46 := 0;
                                    J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);--v_arr1(-4+166) := 'D_46';v_arr2(-4+166) := v_j.d_46;
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44 - v_j.d_45 - v_j.d_46;
                                    J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);--v_arr1(-4+167) := 'D_4';v_arr2(-4+167) := v_j.d_4;


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45
            - v_j.d_46;        
                                    J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);--v_arr1(-4+168) := 'B_4g';v_arr2(-4+168) := v_j.b_4g;
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45
            - v_j.d_46;
                                    J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);               --v_arr1(-4+169) := 'B_4n';v_arr2(-4+169) := v_j.b_4n;


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);--v_arr1(-4+170) := 'B_5g';v_arr2(-4+170) := v_j.b_5g;
v_j.b_5n := v_j.b_2n + v_j.d_4;     J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);--v_arr1(-4+171) := 'B_5n';v_arr2(-4+171) := v_j.b_5n;


---------------D.5---------------
v_j.d_51B11 := v_k.c_TAB279;        J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);--v_arr1(-4+172) := 'D_51B11';v_arr2(-4+172) := v_j.d_51B11;
              /*2015v: 1529-01-01/15c*/
              /*2015e: 1529-01-01/15c*/
v_j.d_51B12 := v_k.c_prda102;       J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);--v_arr1(-4+173) := 'D_51B12';v_arr2(-4+173) := v_j.d_51B12;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_51B13', v_betoltes);
IF p.f = 2 THEN
 v_j.d_51B13 := p.v;
ELSE
 v_j.d_51B13 := p.v;
END IF;
                                    J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13);--v_arr1(-4+174) := 'D_51B13';v_arr2(-4+174) := v_j.d_51B13;

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;   
                                    J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);--v_arr1(-4+175) := 'D_5';v_arr2(-4+175) := v_j.d_5;
---------------D.6---------------
v_j.d_611 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611);--v_arr1(-4+181) := 'D_611';v_arr2(-4+181) := v_j.d_611;
v_j.d_612 := v_j.d_122;             J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612);--v_arr1(-4+182) := 'D_612';v_arr2(-4+182) := v_j.d_612;
v_j.d_613 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613);--v_arr1(-4+176) := 'D_613';v_arr2(-4+176) := v_j.d_613;
v_j.d_614 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614);--v_arr1(222) := 'D_614';v_arr2(222) := v_j.d_614;
v_j.d_61SC := 0;                    J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);--v_arr1(-4+177) := 'D_61SC';v_arr2(-4+177) := v_j.d_61SC;

v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;  
                                    J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);--v_arr1(-4+186) := 'D_61';v_arr2(-4+186) := v_j.d_61;

v_j.d_621 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);--v_arr1(-4+183) := 'D_621';v_arr2(-4+183) := v_j.d_621;
v_j.d_622 := v_j.d_122;             J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622);--v_arr1(-4+184) := 'D_622';v_arr2(-4+184) := v_j.d_622;
v_j.d_623 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);--v_arr1(-4+185) := 'D_623';v_arr2(-4+185) := v_j.d_623;

v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                    J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);--v_arr1(-4+187) := 'D_62';v_arr2(-4+187) := v_j.d_62;
v_j.d_6 := v_j.d_61 - v_j.d_62; 
                                    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);--v_arr1(-4+188) := 'D_6';v_arr2(-4+188) := v_j.d_6;

---------------D.7---------------
v_j.d_711 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711);--v_arr1(221) := 'D_711';v_arr2(221) := v_j.d_711;
v_j.d_712 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712);--v_arr1(223) := 'D_712';v_arr2(223) := v_j.d_712;
v_j.d_71 := v_j.d_711 + v_j.d_712;  
                                    J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71);--v_arr1(-4+189) := 'D_71';v_arr2(-4+189) := v_j.d_71;
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                    J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);--v_arr1(224) := 'D_721';v_arr2(224) := v_j.d_721;
v_j.d_722 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722);--v_arr1(225) := 'D_722';v_arr2(226) := v_j.d_722;
v_j.d_72 := v_j.d_721 + v_j.d_722;  J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72);--v_arr1(-4+190) := 'D_72';v_arr2(-4+190) := v_j.d_72;

v_j.d_7511 := v_k.c_prda066;        J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);--v_arr1(-4+191) := 'D_7511';v_arr2(-4+191) := v_j.d_7511;
v_j.d_7512 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);--v_arr1(-4+192) := 'D_7512';v_arr2(-4+192) := v_j.d_7512;
v_j.d_7513 := 0;/*BECSÜLT ADAT */ 
                                    J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);--v_arr1(-4+193) := 'D_7513';v_arr2(-4+193) := v_j.d_7513;
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */ 
                                    J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);--v_arr1(-4+194) := 'D_7514';v_arr2(-4+194) := v_j.d_7514;
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                    J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);--v_arr1(-4+195) := 'D_7515';v_arr2(-4+195) := v_j.d_7515;
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7513 + v_j.d_7514 + v_j.d_7515;
                                    J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);--v_arr1(-4+196) := 'D_751';v_arr2(-4+196) := v_j.d_751;

v_j.d_7521 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);--v_arr1(-4+197) := 'D_7521';v_arr2(-4+197) := v_j.d_7521;
v_j.d_7522 := v_k.c_prda068;        J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);--v_arr1(-4+198) := 'D_7522';v_arr2(-4+198) := v_j.d_7522;
v_j.d_7523 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);--v_arr1(-4+199) := 'D_7523';v_arr2(-4+199) := v_j.d_7523;
v_j.d_7524 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);--v_arr1(-4+200) := 'D_7524';v_arr2(-4+200) := v_j.d_7524;
v_j.d_7525 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);--v_arr1(-4+201) := 'D_7525';v_arr2(-4+201) := v_j.d_7525;
v_j.d_7526 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);--v_arr1(-4+202) := 'D_7526';v_arr2(-4+202) := v_j.d_7526;
v_j.d_7527 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);--v_arr1(-4+203) := 'D_7527';v_arr2(-4+203) := v_j.d_7527;

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7525 + v_j.d_7526 + v_j.d_7527;
                                    J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);--v_arr1(-4+204) := 'D_752';v_arr2(-4+204) := v_j.d_752;

v_j.d_75 := v_j.d_751 - v_j.d_752;  J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);--v_arr1(-4+205) := 'D_75';v_arr2(-4+205) := v_j.d_75;

  v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);--v_arr1(-4+206) := 'D_7';v_arr2(-4+206) := v_j.d_7;


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);--v_arr1(-4+207) := 'B_6g';v_arr2(-4+207) := v_j.b_6g;
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                    J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);--v_arr1(-4+208) := 'B_6n';v_arr2(-4+208) := v_j.b_6n;
v_j.d_8 := 0;                       J_SZEKT_EVES_T.FELTOLT('D_8', v_j.d_8);--v_arr1(-4+209) := 'D_8';v_arr2(-4+209) := v_j.d_8;
v_j.b_8g := v_j.b_6g - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);--v_arr1(-4+210) := 'B_8g';v_arr2(-4+210) := v_j.b_8g;
v_j.b_8n := v_j.b_6n - v_j.d_8;     J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);--v_arr1(-4+211) := 'B_8n';v_arr2(-4+211) := v_j.b_8n;
            /*Ha a B1g negatív, akkor vegye a 1429-07-01/04b-ből 
             (PFC0M004) a 0-ig hiányzó értéket,és adja hozzá a P.121-hez. 
              */
            /*Ha így is negatív a B1g, 
              akkor a nulláig hiányzó értéket a 
              1429-07-02/(30+31)a-ból(PFC0M061+PFC0M062), 
              azaz a kapott kamatokból kell pótolni oly módon, 
              hogy a D.4121 ezzel kevesebb lesz. */


--J_SZEKT_EVES_T.FELTOLT_t(v_arr1, v_arr2);

END kettosok;

--------------------------------------------------------------------------
-- Zártkörűek: SCV-k, holdingok, csoportfinanszírozók  
PROCEDURE SCV(v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2, c_sema VARCHAR2, c_m003 VARCHAR2, c_lepes VARCHAR2) AS
 pfc004 NUMBER(15);
 pfc061 NUMBER(15);
 k NUMBER(15);
 p PAIR;
 --k1 number(15);
 --temp number(15);
 --type c_temp1d is table of varchar2(20) index by binary_integer;
BEGIN
p := PAIR.INIT;
--v_arr1.EXTEND(226);
--v_arr2.EXTEND(226);
v_j := J_SZEKT_SEMAMUTATOK.GETNULL(v_j); 
v_k :=  J_KETTOSOK.GETNULL(v_k);
v_k  :=  J_KETTOS_FUGG_T.KETTOS_FUGG_UJ(c_sema, c_m003, c_lepes, v_year, v_verzio, v_teszt);

--dbms_output.put_line(c_m003||'----'||v_k.c_pfc0m103);

v_j.p_118 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_118', v_j.p_118);
             /*2015v: külön adat*/
v_j.p_119 := 0; /*FISIM*/          J_SZEKT_EVES_T.FELTOLT('P_119', v_j.p_119);  --v_arr1(1) := 'P_119'; v_arr2(1) := v_j.p_119;
v_j.p_11111 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11111', v_j.p_11111);  --v_arr1(2) := 'P_11111'; v_arr2(2) := v_j.p_11111;
v_j.p_11112 := 0;                  J_SZEKT_EVES_T.FELTOLT('P_11112', v_j.p_11112);  -- v_arr1(3) := 'P_11112';v_arr2(3) := v_j.p_11112;
v_j.p_1111 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1111', v_j.p_1111);  -- v_arr1(4) := 'P_1111';v_arr2(4) := v_j.p_1111;
v_j.p_1112 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1112', v_j.p_1112);  -- v_arr1(5) := 'P_1112';v_arr2(5) := v_j.p_1112;
v_j.p_1113 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1113', v_j.p_1113);  -- v_arr1(6) := 'P_1113';v_arr2(6) := v_j.p_1113;
v_j.p_1114 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1114', v_j.p_1114);  -- v_arr1(7) := 'P_1114';v_arr2(7) := v_j.p_1114;
v_j.p_111 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_111', v_j.p_111);  -- v_arr1(8) := 'P_111';v_arr2(8) := v_j.p_111;
v_j.p_1121 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1121', v_j.p_1121);  -- v_arr1(9) := 'P_1121';v_arr2(9) := v_j.p_1121;
v_j.p_1122 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1122', v_j.p_1122);  -- v_arr1(10) := 'P_1122';v_arr2(10) := v_j.p_1122;
v_j.p_1123 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1123', v_j.p_1123);  -- v_arr1(11) := 'P_1123';v_arr2(11) := v_j.p_1123;
v_j.p_112 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_112', v_j.p_112);  -- v_arr1(12) := 'P_112';v_arr2(12) := v_j.p_112;
v_j.p_1131 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1131', v_j.p_1131);   -- v_arr1(13) := 'P_1131';v_arr2(13) := v_j.p_1131;
v_j.p_1132 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1132', v_j.p_1132);   -- v_arr1(14) := 'P_1132';v_arr2(14) := v_j.p_1132;
v_j.p_113 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_113', v_j.p_113);   -- v_arr1(15) := 'P_113';v_arr2(15) := v_j.p_113;
v_j.p_1151 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1151', v_j.p_1151);   -- v_arr1(16) := 'P_1151';v_arr2(16) := v_j.p_1151;
v_j.p_1152 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1152', v_j.p_1152);   -- v_arr1(17) := 'P_1152';v_arr2(17) := v_j.p_1152;
v_j.p_115 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_115', v_j.p_115);   -- v_arr1(18) := 'P_115';v_arr2(18) := v_j.p_115;
v_j.p_116 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_116', v_j.p_116);   -- v_arr1(19) := 'P_116';v_arr2(19) := v_j.p_116;
v_j.p_11 := v_j.p_118;             J_SZEKT_EVES_T.FELTOLT('P_11', v_j.p_11);   -- v_arr1(20) := 'P_11';v_arr2(20) := v_j.p_11;
v_j.p_1221 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1221', v_j.p_1221);   -- v_arr1(21) := 'P_1221';v_arr2(21) := v_j.p_1221;
v_j.p_1222 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1222', v_j.p_1222);   -- v_arr1(22) := 'P_1222';v_arr2(22) := v_j.p_1222;
v_j.p_122 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_122', v_j.p_122);   -- v_arr1(23) := 'P_122';v_arr2(23) := v_j.p_122;
v_j.p_121 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_121', v_j.p_121);   -- v_arr1(24) := 'P_121';v_arr2(24) := v_j.p_121;
v_j.p_1211 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1211', v_j.p_1211);   -- v_arr1(25) := 'P_1211';v_arr2(25) := v_j.p_1211;
v_j.p_1212 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1212', v_j.p_1212);   -- v_arr1(26) := 'P_1212';v_arr2(26) := v_j.p_1212;
v_j.p_12 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_12', v_j.p_12);   -- v_arr1(27) := 'P_12';v_arr2(27) := v_j.p_12;
v_j.p_1363 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1363', v_j.p_1363);   -- v_arr1(28) := 'P_1363';v_arr2(28) := v_j.p_1363;
v_j.p_1361 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1361', v_j.p_1361);   --v_arr1(29) := 'P_1361';v_arr2(29) := v_j.p_1361;
v_j.p_1362 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1362', v_j.p_1362);   --v_arr1(30) := 'P_1362';v_arr2(30) := v_j.p_1362;
v_j.p_1364 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1364', v_j.p_1364);   --v_arr1(31) := 'P_1364';v_arr2(31) := v_j.p_1364;
v_j.p_1365 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1365', v_j.p_1365);   --v_arr1(32) := 'P_1365';v_arr2(32) := v_j.p_1365;
v_j.p_1366 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1366', v_j.p_1366);   --v_arr1(33) := 'P_1366';v_arr2(33) := v_j.p_1366;
v_j.p_1367 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1367', v_j.p_1367);   --v_arr1(34) := 'P_1367';v_arr2(34) := v_j.p_1367;
v_j.p_132 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_132', v_j.p_132);   --v_arr1(35) := 'P_132';v_arr2(35) := v_j.p_132; 
v_j.p_1312 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_1312', v_j.p_1312);   --v_arr1(36) := 'P_1312';v_arr2(36) := v_j.p_1312;
v_j.p_131 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_131', v_j.p_131);   --v_arr1(37) := 'P_131';v_arr2(37) := v_j.p_131;
v_j.p_13 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_13', v_j.p_13);   --v_arr1(38) := 'P_13';v_arr2(38) := v_j.p_13;
v_j.p_14 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_14', v_j.p_14);    --v_arr1(39) := 'P_14';v_arr2(39) := v_j.p_14;
v_j.p_15 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_15', v_j.p_15);    --v_arr1(40) := 'P_15';v_arr2(40) := v_j.p_15;
v_j.p_16 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_16', v_j.p_16);    --v_arr1(41) := 'P_16';v_arr2(41) := v_j.p_16;
-- itt p.15, p.16 teljesen 0.
--p21-p22
v_j.p_21 := J_SELECT_T.SCV_AFA(c_m003, v_year, v_betoltes, v_verzio, v_teszt) * 0.1;/*v_k.c_pfc0m008;*/
                                   J_SZEKT_EVES_T.FELTOLT('P_21', v_j.p_21); --                v_arr1(43) := 'P_21';v_arr2(43) := v_j.p_21;
--dbms_output.put_line(v_j.p_21);
v_j.p_22 := J_SELECT_T.SCV_AFA(c_m003, v_year, v_betoltes, v_verzio, v_teszt) * 0.9;/*v_k.c_pfc0m090;*/
                                   J_SZEKT_EVES_T.FELTOLT('P_22', v_j.p_22); --                v_arr1(44) := 'P_22';v_arr2(44) := v_j.p_22;
                                   
--p23
v_j.p_2331 := 0;/*v_k.c_pfc0m093;*/
                                   J_SZEKT_EVES_T.FELTOLT('P_2331', v_j.p_2331);      --v_arr1(45) := 'P_2331';v_arr2(45) := v_j.p_2331;
v_j.p_231 := 0;/*v_k.c_pfc0m022;*/ 
                                   J_SZEKT_EVES_T.FELTOLT('P_231', v_j.p_231);      --v_arr1(46) := 'P_231';v_arr2(46) := v_j.p_231;
v_j.p_232 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_232', v_j.p_232);      --v_arr1(47) := 'P_232';v_arr2(47) := v_j.p_232;
v_j.p_2321 := 0;/*v_k.c_pfc0m023;*/
                                   J_SZEKT_EVES_T.FELTOLT('P_2321', v_j.p_2321);      --v_arr1(48) := 'P_2321';v_arr2(48) := v_j.p_2321;
v_j.p_2322 := 0;                   J_SZEKT_EVES_T.FELTOLT('P_2322', v_j.p_2322);      --v_arr1(49) := 'P_2322';v_arr2(49) := v_j.p_2322;
v_j.p_233 := v_j.p_2331-v_j.p_231 - v_j.p_2321;
                                   J_SZEKT_EVES_T.FELTOLT('P_233', v_j.p_233);    --v_arr1(50) := 'P_233';v_arr2(50) := v_j.p_233;
v_j.p_23 := v_j.p_233 + v_j.p_232 + v_j.p_231;
                                   J_SZEKT_EVES_T.FELTOLT('P_23', v_j.p_23);    --v_arr1(51) := 'P_23';v_arr2(51) := v_j.p_23;
v_j.p_24 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_24', v_j.p_24);    --v_arr1(52) := 'P_24';v_arr2(52) := v_j.p_24;
v_j.p_262 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_262', v_j.p_262);    --v_arr1(53) := 'P_262';v_arr2(53) := v_j.p_262;
-- itt p.262 teljesen 0.
v_j.p_26 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_26', v_j.p_26);    --v_arr1(54) := 'P_26';v_arr2(54) := v_j.p_26;
v_j.p_27 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_27', v_j.p_27);    --v_arr1(55) := 'P_27';v_arr2(55) := v_j.p_27;
v_j.p_28 := 0;                     J_SZEKT_EVES_T.FELTOLT('P_28', v_j.p_28);    --v_arr1(56) := 'P_28';v_arr2(56) := v_j.p_28;
v_j.p_291 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_291', v_j.p_291);    --v_arr1(57) := 'P_291';v_arr2(57) := v_j.p_291;
v_j.p_292 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_292', v_j.p_292);    --v_arr1(58) := 'P_292';v_arr2(58) := v_j.p_292;
v_j.p_293 := 0;                    J_SZEKT_EVES_T.FELTOLT('P_293', v_j.p_293);
             /*2015v: külön adat*/
v_j.p_29 := v_j.p_293;             J_SZEKT_EVES_T.FELTOLT('P_29', v_j.p_29);    --v_arr1(59) := 'P_29';v_arr2(59) := v_j.p_29;
v_j.p_2 := v_j.p_21 + v_j.p_22 + v_j.p_23- v_j.p_26 + v_j.p_27 + v_j.p_28 + v_j.p_29; 
                                   J_SZEKT_EVES_T.FELTOLT('P_2', v_j.p_2);    --v_arr1(60) := 'P_2';v_arr2(60) := v_j.p_2;
v_j.K_1 := 0;                      J_SZEKT_EVES_T.FELTOLT('K_1', v_j.K_1);    --v_arr1(-4+66) := 'K_1';v_arr2(-4+66) := v_j.k_1;
--D21 kiszámolása
v_j.d_2111 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_2111', v_j.d_2111);    --v_arr1(-4+68) := 'D_2111';v_arr2(-4+68) := v_j.d_2111;
v_j.d_211 := v_j.d_2111;           J_SZEKT_EVES_T.FELTOLT('D_211', v_j.d_211);    --v_arr1(-4+69) := 'D_211';v_arr2(-4+69) := v_j.d_211;
v_j.d_212 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_212', v_j.d_212);    --v_arr1(-4+70) := 'D_212';v_arr2(-4+70) := v_j.d_212;
v_j.d_214D := 0;/*KÜLÖN ADAT*/     J_SZEKT_EVES_T.FELTOLT('D_214D', v_j.d_214D);    --v_arr1(-4+71) := 'D_214D';v_arr2(-4+71) := v_j.d_214d;
v_j.d_214F := v_j.p_1361 ;         J_SZEKT_EVES_T.FELTOLT('D_214F', v_j.d_214F);    --v_arr1(-4+72) := 'D_214F';v_arr2(-4+72) := v_j.d_214F;
v_j.d_214G1 := v_j.p_1362;         J_SZEKT_EVES_T.FELTOLT('D_214G1', v_j.d_214G1);    --v_arr1(-4+73) := 'D_214G1';v_arr2(-4+73) := v_j.d_214G1;
v_j.d_214E := v_j.p_1363;          J_SZEKT_EVES_T.FELTOLT('D_214E', v_j.d_214E);    --v_arr1(-4+74) := 'D_214E';v_arr2(-4+74) := v_j.d_214E;
v_j.d_214I73 := v_j.p_1366;        J_SZEKT_EVES_T.FELTOLT('D_214I73', v_j.d_214I73);    -- v_arr1(-4+75) := 'D_214I73';v_arr2(-4+75) := v_j.d_214I73;
v_j.d_214I3 := v_j.p_1367;         J_SZEKT_EVES_T.FELTOLT('D_214I3', v_j.d_214I3);    --v_arr1(-4+76) := 'D_214I3';v_arr2(-4+76) := v_j.d_214I3;
v_j.d_214I := v_j.p_1365;          J_SZEKT_EVES_T.FELTOLT('D_214I', v_j.d_214I);    --v_arr1(-4+77) := 'D_214I';v_arr2(-4+77) := v_j.d_214I;
v_j.d_214BA := v_j.p_1364;         J_SZEKT_EVES_T.FELTOLT('D_214BA', v_j.d_214BA);    --v_arr1(-4+78) := 'D_214BA';v_arr2(-4+78) := v_j.d_214BA;
v_j.d_214 := v_j.d_214D + v_j.d_214F + v_j.d_214G1 + v_j.d_214E + v_j.d_214I73 
             + v_j.d_214I3 + v_j.d_214I + v_j.d_214BA; 
                                   J_SZEKT_EVES_T.FELTOLT('D_214', v_j.d_214);    --v_arr1(-4+79) := 'D_214';v_arr2(-4+79) := v_j.d_214;
v_j.d_21 := v_j.d_211 + v_j.d_212 + v_j.d_214;
                                   J_SZEKT_EVES_T.FELTOLT('D_21', v_j.d_21);    --v_arr1(-4+80) := 'D_21';v_arr2(-4+80) := v_j.d_21;
--D.31 kiszámítása
v_j.d_312 :=  0  ;                 J_SZEKT_EVES_T.FELTOLT('D_312', v_j.d_312);    --v_arr1(-4+81) := 'D_312';v_arr2(-4+81) := v_j.d_312;
v_j.d_31922 := 0;/*KÜLÖN ADAT*/    J_SZEKT_EVES_T.FELTOLT('D_31922', v_j.d_31922);    --v_arr1(-4+82) := 'D_31922';v_arr2(-4+82) := v_j.d_31922;
v_j.d_3192 := v_j.d_31922;         J_SZEKT_EVES_T.FELTOLT('D_3192', v_j.d_3192);    --v_arr1(-4+83) := 'D_3192';v_arr2(-4+83) := v_j.d_3192;
v_j.d_319 := v_j.p_1312 + v_j.d_3192;
                                   J_SZEKT_EVES_T.FELTOLT('D_319', v_j.d_319);    --v_arr1(-4+84) := 'D_319';v_arr2(-4+84) := v_j.d_319;
v_j.d_31 := v_j.d_319 + v_j.d_312; 
                                   J_SZEKT_EVES_T.FELTOLT('D_31', v_j.d_31);    --v_arr1(-4+85) := 'D_31';v_arr2(-4+85) := v_j.d_31;
--D.1 kiszámítása
v_j.d_1111 := v_k.c_prca016;       J_SZEKT_EVES_T.FELTOLT('D_1111', v_j.d_1111); --v_arr1(-4+86) := 'D_1111';v_arr2(-4+86) := v_j.d_1111;
v_j.d_11121 := v_k.c_prca017;      J_SZEKT_EVES_T.FELTOLT('D_11121', v_j.d_11121); --v_arr1(-4+87) := 'D_11121';v_arr2(-4+87) := v_j.d_11121;
v_j.d_11124 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11124', v_j.d_11124); --v_arr1(-4+88) := 'D_11124';v_arr2(-4+88) := v_j.d_11124;
v_j.d_11123 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11123', v_j.d_11123); --v_arr1(-4+89) := 'D_11123';v_arr2(-4+89) := v_j.d_11123;
v_j.d_11125 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11125', v_j.d_11125); --v_arr1(-4+90) := 'D_11125';v_arr2(-4+90) := v_j.d_11125;
v_j.d_11126 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11126', v_j.d_11126);  --v_arr1(-4+91) := 'D_11126';v_arr2(-4+91) := v_j.d_11126;
v_j.d_11127 := 0;/*v_k.c_paj0m087/0.1904;*/
                                   J_SZEKT_EVES_T.FELTOLT('D_11127', v_j.d_11127);  -- v_arr1(-4+92) := 'D_11127'; v_arr2(-4+92) := v_j.d_11127;
v_j.d_11128 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11128', v_j.d_11128);  --v_arr1(-4+93) := 'D_11128';v_arr2(-4+93) := v_j.d_11128;
v_j.d_11129 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11129', v_j.d_11129);  --v_arr1(-4+94) := 'D_11129';v_arr2(-4+94) := v_j.d_11129;
v_j.d_11130 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11130', v_j.d_11130);  --v_arr1(-4+95) := 'D_11130';v_arr2(-4+95) := v_j.d_11130;
v_j.d_11131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_11131', v_j.d_11131);  --v_arr1(214) := 'D_11131';v_arr2(214) := v_j.d_11131;

-- d.11124 hozzáadva: 2017.08.14
v_j.d_1112 := v_j.d_11121 - v_j.d_11123 - v_j.d_11124 - v_j.d_11125
              - v_j.d_11126 - v_j.d_11127 - v_j.d_11128 - v_j.d_11129
              - v_j.d_11130 - v_j.d_11131;                                                        
                                   J_SZEKT_EVES_T.FELTOLT('D_1112', v_j.d_1112);  --v_arr1(-4+96) := 'D_1112';v_arr2(-4+96) := v_j.d_1112;
v_j.d_111 := v_j.d_1111 + v_j.d_1112;
                                   J_SZEKT_EVES_T.FELTOLT('D_111', v_j.d_111);  --v_arr1(93) := 'D_111';v_arr2(93) := v_j.d_111;
--d112
v_j.d_1121 := v_j.p_16 * J_KONST_T.D_1121_TERM_SZORZO; -- 0.4641 volt 2017.04.27
--v_j.d_1121 := v_j.p_16 * 0.3525; -- 0.4641 volt 2017.04.27
                                   J_SZEKT_EVES_T.FELTOLT('D_1121', v_j.d_1121);   --v_arr1(94) := 'D_1121';v_arr2(94) := v_j.d_1121;
v_j.d_1122 := v_j.p_15;            J_SZEKT_EVES_T.feltolt('D_1122', v_j.d_1122);  --v_arr1(95) := 'D_1122';v_arr2(95) := v_j.d_1122;
--v_j.d_1123 := v_k.c_prja088 / 0.54 * 0.5;
v_j.d_1123 := v_k.c_prja088 / J_KONST_T.d_1123_szorzo * 0.5;
                                   J_SZEKT_EVES_T.FELTOLT('D_1123', v_j.d_1123); --v_arr1(96) := 'D_1123';v_arr2(96) := v_j.d_1123;
v_j.d_1124 := v_j.p_262;           J_SZEKT_EVES_T.FELTOLT('D_1124', v_j.d_1124);  --v_arr1(97) := 'D_1124';v_arr2(97) := v_j.d_1124;
v_j.d_1125 := v_j.d_11127;         J_SZEKT_EVES_T.FELTOLT('D_1125', v_j.d_1125);  --v_arr1(98) := 'D_1125';v_arr2(98) := v_j.d_1125;
v_j.d_1126 := v_j.d_11129;         J_SZEKT_EVES_T.FELTOLT('D_1126', v_j.d_1126);   --v_arr1(99) := 'D_1126';v_arr2(99) := v_j.d_1126;
v_j.d_1127 := v_j.d_11130;         J_SZEKT_EVES_T.FELTOLT('D_1127', v_j.d_1127);   --v_arr1(100) := 'D_1127';v_arr2(100) := v_j.d_1127;
v_j.d_1128 := v_j.d_11131;         J_SZEKT_EVES_T.FELTOLT('D_1128', v_j.d_1128);   --v_arr1(215) := 'D_1128';v_arr2(215) := v_j.d_1128;
v_j.d_112 := v_j.d_1121 + v_j.d_1122 + v_j.d_1123 + v_j.d_1124 + v_j.d_1125
             + v_j.d_1126 + v_j.d_1127 + v_j.d_1128;                                                         
                                  J_SZEKT_EVES_T.FELTOLT('D_112', v_j.d_112);   --v_arr1(208) := 'D_112';v_arr2(208) := v_j.d_112;
--d11
v_j.d_11 := v_j.d_111 + v_j.d_112; 
                                   J_SZEKT_EVES_T.FELTOLT('D_11', v_j.d_11);   --                     v_arr1(101) := 'D_11';v_arr2(101) := v_j.d_11;
--d121
v_j.d_1212 := 0; /*ADAT HIÁNYÁBAN V_J.D_111*0.03*/
                                   J_SZEKT_EVES_T.FELTOLT('D_1212', v_j.d_1212); --v_arr1(102) := 'D_1212'; v_arr2(102) := v_j.d_1212;
v_j.d_1211 := v_k.c_prca094;       J_SZEKT_EVES_T.FELTOLT('D_1211', v_j.d_1211);        --v_arr1(103) := 'D_1211';v_arr2(103) := v_j.d_1211;
v_j.d_1213 := v_j.d_11125;         J_SZEKT_EVES_T.FELTOLT('D_1213', v_j.d_1213);         --                                         v_arr1(104) := 'D_1213';v_arr2(104) := v_j.d_1213;
v_j.d_1214 := v_j.d_11124;         J_SZEKT_EVES_T.FELTOLT('D_1214', v_j.d_1214);         --                                         v_arr1(105) := 'D_1214';v_arr2(105) := v_j.d_1214;
v_j.d_1215 := v_j.d_11128;         J_SZEKT_EVES_T.FELTOLT('D_1215', v_j.d_1215);                                            --      v_arr1(106) := 'D_1215';v_arr2(106) := v_j.d_1215;
v_j.d_121 := v_j.d_1211 + v_j.d_1212 + v_j.d_1213 + v_j.d_1214
             + v_j.d_1215; 
                                   J_SZEKT_EVES_T.FELTOLT('D_121', v_j.d_121);          --      v_arr1(107) := 'D_121';v_arr2(107) := v_j.d_121;
--d122
v_j.d_1221 := v_j.d_11126;         J_SZEKT_EVES_T.FELTOLT('D_1221', v_j.d_1221);           --      v_arr1(-4+112) := 'D_1221';v_arr2(-4+112) := v_j.d_1221;
v_j.d_1222 := v_j.d_11123;         J_SZEKT_EVES_T.FELTOLT('D_1222', v_j.d_1222);                                          --      v_arr1(-4+113) := 'D_1222';v_arr2(-4+113) := v_j.d_1222;
v_j.d_122 := v_j.d_1221 + v_j.d_1222;
                                   J_SZEKT_EVES_T.FELTOLT('D_122', v_j.d_122);                                          --      v_arr1(-4+114) := 'D_122';v_arr2(-4+114) := v_j.d_122;
--d12
v_j.d_12 := v_j.d_121 + v_j.d_122; J_SZEKT_EVES_T.FELTOLT('D_12', v_j.d_12);                                          --      v_arr1(-4+115) := 'D_12';v_arr2(-4+115) := v_j.d_12;

--d1
v_j.d_1 := v_j.d_11 + v_j.d_12;    J_SZEKT_EVES_T.FELTOLT('D_1', v_j.d_1);                                          --      v_arr1(-4+116) := 'D_1';v_arr2(-4+116) := v_j.d_1;

--*******************************************************
 --P1 kiszámítás
v_j.p_1 := v_j.p_2 + v_j.d_1 + v_j.K_1;
                                   J_SZEKT_EVES_T.FELTOLT('P_1', v_j.p_1);                 
                                          --v_arr1(42) := 'P_1';v_arr2(42) := v_j.p_1;

--b.1g kiszámítása
v_j.b_1g := v_j.p_1 - v_j.p_2;     J_SZEKT_EVES_T.FELTOLT('B_1g', v_j.b_1g);    --v_arr1(61) := 'B_1g';v_arr2(61) := v_j.b_1g;

v_j.b_1n := v_j.b_1g - v_j.K_1;    J_SZEKT_EVES_T.FELTOLT('B_1n', v_j.b_1n);    --v_arr1(-4+67) := 'B_1n';v_arr2(-4+67) := v_j.b_1n;

------------D.29

v_j.d_29C1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C1', v_j.d_29C1);                                    --v_arr1(-4+117) := 'D_29C1';v_arr2(-4+117) := v_j.d_29C1;
v_j.d_29C2 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29C2', v_j.d_29C2);                                    --v_arr1(-4+118) := 'D_29C2';v_arr2(-4+118) := v_j.d_29C2;
v_j.d_29C := v_j.d_29C1 + v_j.d_29C2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29C', v_j.d_29C);                                                 --v_arr1(-4+213) := 'D_29C';v_arr2(-4+213) := v_j.d_29C;

v_j.d_29b1 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B1', v_j.d_29b1); 
--v_arr1(-4+119) := 'D_29B1';v_arr2(-4+119) := v_j.d_29b1;
v_j.d_29b3 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_29B3', v_j.d_29b3); 
--v_arr1(-4+120) := 'D_29B3';v_arr2(-4+120) := v_j.d_29b3;

v_j.d_29A11 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A11', v_j.d_29A11);                                      --v_arr1(-4+121) := 'D_29A11';v_arr2(-4+121) := v_j.d_29A11;
v_j.d_29A12 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A12', v_j.d_29A12);                                      --v_arr1(-4+122) := 'D_29A12';v_arr2(-4+122) := v_j.d_29A12;
v_j.d_29A2 := 0;/*KÜLÖN ADAT KORMÁNYZAT*/
                                   J_SZEKT_EVES_T.FELTOLT('D_29A2', v_j.d_29A2);                                      --v_arr1(-4+123) := 'D_29A2';v_arr2(-4+123) := v_j.d_29A2;
v_j.d_29A := v_j.d_29A11 + v_j.d_29A12 + v_j.d_29A2;
                                   J_SZEKT_EVES_T.FELTOLT('D_29A', v_j.d_29A);                                  --v_arr1(-4+124) := 'D_29A';v_arr2(-4+124) := v_j.d_29A;
v_j.d_2953 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_2953', v_j.d_2953);                                  --v_arr1(-4+125) := 'D_2953';v_arr2(-4+125) := v_j.d_2953;
v_j.d_29E3 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_29E3', v_j.d_29E3);                                   --v_arr1(216) := 'D_29E3';v_arr2(216) := v_j.d_29E3;

v_j.d_29 := v_j.d_29C + v_j.d_29B1 + v_j.d_29B3 + v_j.d_29A + v_j.d_2953
            + v_j.d_29E3;     
                                   J_SZEKT_EVES_T.FELTOLT('D_29', v_j.d_29);     --           v_arr1(-4+126) := 'D_29';v_arr2(-4+126) := v_j.d_29;

--v_j.d_3912 := 0;/*KÜLÖN ADAT */                                                   --   v_arr1(-4+64) := 'D_3912';v_arr2(-4+64) := v_j.d_3912;
v_j.d_3911 := 0;/*KÜLÖN ADAT */    J_SZEKT_EVES_T.FELTOLT('D_3911', v_j.d_3911);                                       --  v_arr1(-4+127) := 'D_3911';v_arr2(-4+127) := v_j.d_3911;
v_j.d_391 := v_j.d_3911;           J_SZEKT_EVES_T.FELTOLT('D_391', v_j.d_391);                                        -- v_arr1(-4+128) := 'D_391';v_arr2(-4+128) := v_j.d_391;

v_j.d_39251 := 0;/*KÜLÖN ADAT */   J_SZEKT_EVES_T.FELTOLT('D_39251', v_j.d_39251);                                    --     v_arr1(-4+129) := 'D_39251';v_arr2(-4+129) := v_j.d_39251;
--v_j.d_39254 := 0;/*KÜLÖN ADAT */                                                     v_arr1(-4+65) := 'D_39254';v_arr2(-4+65) := v_j.d_39254;
v_j.d_39253 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_39253', v_j.d_39253);                           -- v_arr1(-4+130) := 'D_39253';v_arr2(-4+130) := v_j.d_39253;
v_j.d_3925 := v_j.d_39251 + v_j.d_39253;
                                   J_SZEKT_EVES_T.FELTOLT('D_3925', v_j.d_3925);                                   --      v_arr1(-4+131) := 'D_3925';v_arr2(-4+131) := v_j.d_3925;
v_j.d_392 := v_j.d_3925;           J_SZEKT_EVES_T.FELTOLT('D_392', v_j.d_392);                                    --     v_arr1(-4+132) := 'D_392';v_arr2(-4+132) := v_j.d_392;

v_j.d_394 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_394', v_j.d_394);                                   --      v_arr1(-4+133) := 'D_394';v_arr2(-4+133) := v_j.d_394;
v_j.d_39 := v_j.d_391 + v_j.d_392 + v_j.d_394;
                                   J_SZEKT_EVES_T.FELTOLT('D_39', v_j.d_39);                                   --      v_arr1(-4+134) := 'D_39';v_arr2(-4+134) := v_j.d_39;

-------------B.2N---------------------
v_j.b_2g := v_j.b_1g - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2g', v_j.b_2g);                            --      v_arr1(-4+135) := 'B_2g';v_arr2(-4+135) := v_j.b_2g;
v_j.b_2n := v_j.b_1n - v_j.d_1 - v_j.d_29 + v_j.d_39;
                                   J_SZEKT_EVES_T.FELTOLT('B_2n', v_j.b_2n);                            --      v_arr1(-4+136) := 'B_2n';v_arr2(-4+136) := v_j.b_2n;


------------D.42-------
v_j.d_41211 := v_k.c_prca081;      J_SZEKT_EVES_T.FELTOLT('D_41211', v_j.d_41211); 

--v_arr1(-4+137) := 'D_41211';v_arr2(-4+137) := v_j.d_41211;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41212', v_betoltes);
IF p.f = 2 THEN  
 v_j.d_41212 := p.v;
ELSE
 v_j.d_41212 := v_k.c_prca150 + v_k.c_prca151 - v_j.d_41211 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41212', v_j.d_41212);                                    
--v_arr1(-4+138) := 'D_41212';v_arr2(-4+138) := v_j.d_41212;

v_j.d_412131 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412131', v_j.d_412131);                 --    v_arr1(-4+139) := 'D_412131';v_arr2(-4+139) := v_j.d_412131;
v_j.d_412132 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412132', v_j.d_412132);                 --    v_arr1(-4+140) := 'D_412132';v_arr2(-4+140) := v_j.d_412132;
v_j.d_41213 := v_j.d_412131 + v_j.d_412132;
                                   J_SZEKT_EVES_T.FELTOLT('D_41213', v_j.d_41213);                --    v_arr1(-4+141) := 'D_41213';v_arr2(-4+141) := v_j.d_41213;
 --dbms_output.put_line('  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ');
  --v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
 -- dbms_output.put_line(c_m003||'  d4121     '||v_j.d_4121);
v_j.d_4121 := v_j.d_41211 + v_j.d_41212 + v_j.d_41213;
                                   J_SZEKT_EVES_T.FELTOLT('D_4121', v_j.d_4121);                --   v_arr1(-4+142) := 'D_4121';v_arr2(-4+142) := v_j.d_4121;
--dbms_output.put_line(c_m003||'  d4121     '||v_j.d_4121);
--dbms_output.put_line('  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ');
v_j.d_41221 := v_k.c_prca078;      J_SZEKT_EVES_T.FELTOLT('D_41221', v_j.d_41221);                --    v_arr1(-4+143) := 'D_41221';v_arr2(-4+143) := v_j.d_41221;


p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_41222', v_betoltes);
IF p.f = 2 THEN  
v_j.d_41222 := p.v;
ELSE
v_j.d_41222 := v_k.c_prca149 + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_41222', v_j.d_41222);
--v_arr1(-4+144) := 'D_41222';v_arr2(-4+144) := v_j.d_41222;

v_j.d_412231 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412231', v_j.d_412231);              --     v_arr1(-4+145) := 'D_412231';v_arr2(-4+145) := v_j.d_412231;
v_j.d_412232 := 0;/*KÜLÖN ADAT */  J_SZEKT_EVES_T.FELTOLT('D_412232', v_j.d_412232);              --     v_arr1(-4+146) := 'D_412232';v_arr2(-4+146) := v_j.d_412232;
v_j.d_41223 :=  v_j.d_412231 - v_j.d_412232;
                                   J_SZEKT_EVES_T.FELTOLT('D_41223', v_j.d_41223);              --     v_arr1(-4+147) := 'D_41223';v_arr2(-4+147) := v_j.d_41223;

v_j.d_4122 := v_j.d_41221 + v_j.d_41222 + v_j.d_41223;
                                   J_SZEKT_EVES_T.FELTOLT('D_4122', v_j.d_4122);              --     v_arr1(-4+148) := 'D_4122';v_arr2(-4+148) := v_j.d_4122;
v_j.d_412 := v_j.d_4121 - v_j.d_4122;
                                   J_SZEKT_EVES_T.FELTOLT('D_412', v_j.d_412);               --     v_arr1(-4+149) := 'D_412';v_arr2(-4+149) := v_j.d_412;

--d41
v_j.d_413 := v_j.d_1123;           J_SZEKT_EVES_T.FELTOLT('D_413', v_j.d_413);               --     v_arr1(-4+150) := 'D_413';v_arr2(-4+150) := v_j.d_413;
v_j.d_41 := v_j.d_412 + v_j.d_413; J_SZEKT_EVES_T.FELTOLT('D_41', v_j.d_41);               --     v_arr1(-4+151) := 'D_41';v_arr2(-4+151) := v_j.d_41;
--d42

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_421', v_betoltes);
IF p.f = 2 THEN  
v_j.d_421 := p.v;
ELSE
v_j.d_421 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_421') + p.v;  
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_421', v_j.d_421);
--v_arr1(-4+152) := 'D_421';v_arr2(-4+152) := v_j.d_421; --2009-es adat
v_j.d_4221 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4221');
                                   J_SZEKT_EVES_T.FELTOLT('D_4221', v_j.d_4221);             --     v_arr1(-4+153) := 'D_4221';v_arr2(-4+153) := v_j.d_4221;
v_j.d_4222 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4222');
                                   J_SZEKT_EVES_T.FELTOLT('D_4222', v_j.d_4222);             --     v_arr1(-4+154) := 'D_4222';v_arr2(-4+154) := v_j.d_4222;
v_j.d_4223 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4223');
                                   J_SZEKT_EVES_T.FELTOLT('D_4223', v_j.d_4223);             --     v_arr1(-4+155) := 'D_4223';v_arr2(-4+155) := v_j.d_4223;
v_j.d_4224 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4224');
                                   J_SZEKT_EVES_T.FELTOLT('D_4224', v_j.d_4224);             --     v_arr1(-4+156) := 'D_4224';v_arr2(-4+156) := v_j.d_4224;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_4225', v_betoltes);
IF p.f = 2 THEN
v_j.d_4225 := p.v;
ELSE
v_j.d_4225 := J_SELECT_T.MESG_SZAMOK(v_year, v_verzio, v_teszt, v_betoltes,c_sema,c_m003,'D_4225') + p.v;
END IF;
                                   J_SZEKT_EVES_T.FELTOLT('D_4225', v_j.d_4225);
--v_arr1(-4+157) := 'D_4225';v_arr2(-4+157) := v_j.d_4225;
                                              
v_j.d_4226 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4226', v_j.d_4226);              --    v_arr1(-4+158) := 'D_4226';v_arr2(-4+158) := v_j.d_4226;
v_j.d_422 := v_j.d_4221 + v_j.d_4222 + v_j.d_4223 + v_j.d_4224 + v_j.d_4225;
                                   J_SZEKT_EVES_T.FELTOLT('D_422', v_j.d_422);          --     v_arr1(-4+159) := 'D_422';v_arr2(-4+159) := v_j.d_422;

v_j.d_42 := v_j.d_421 - v_j.d_422; 
                                   J_SZEKT_EVES_T.FELTOLT('D_42', v_j.d_42);           --    v_arr1(-4+160) := 'D_42';v_arr2(-4+160) := v_j.d_42;

v_j.d_44131 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44131', v_j.d_44131); --v_arr1(209) := 'D_44131';v_arr2(209) := v_j.d_44131; --217
v_j.d_44132 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44132', v_j.d_44132); --v_arr1(210) := 'D_44132';v_arr2(210) := v_j.d_44132; --218
v_j.d_4413 := v_j.d_44131 + v_j.d_44132;
                                   J_SZEKT_EVES_T.FELTOLT('D_4413', v_j.d_4413); --v_arr1(211) := 'D_4413';v_arr2(211) := v_j.d_4413;   --219
v_j.d_4412 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4412', v_j.d_4412); --v_arr1(212) := 'D_4412';v_arr2(212) := v_j.d_4412;   --220
v_j.d_4411 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4411', v_j.d_4411);  --v_arr1(213) := 'D_4411';v_arr2(213) := v_j.d_4411;   --221 - ez a sor nem volt!
v_j.d_441 := v_j.d_4411 + v_j.d_4412 + v_j.d_4413;
                                   J_SZEKT_EVES_T.FELTOLT('D_441', v_j.d_441);  --v_arr1(214) := 'D_441';v_arr2(214) := v_j.d_441;     --221!!!



v_j.d_44231 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44231', v_j.d_44231); --v_arr1(215) := 'D_44231';v_arr2(215) := v_j.d_44231; --217
v_j.d_44232 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_44232', v_j.d_44232); --v_arr1(216) := 'D_44232';v_arr2(216) := v_j.d_44232; --218
v_j.d_4423 := v_j.d_44231 + v_j.d_44232;
                                   J_SZEKT_EVES_T.FELTOLT('D_4423', v_j.d_4423); --v_arr1(217) := 'D_4423';v_arr2(217) := v_j.d_4423;   --219
v_j.d_4422 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4422', v_j.d_4422); --v_arr1(218) := 'D_4422';v_arr2(218) := v_j.d_4422;   --220
v_j.d_4421 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_4421', v_j.d_4421);  --v_arr1(219) := 'D_4421';v_arr2(219) := v_j.d_4421;   --221 - ez a sor nem volt!
v_j.d_442 := v_j.d_4421 + v_j.d_4422 + v_j.d_4423;
                                   J_SZEKT_EVES_T.FELTOLT('D_442', v_j.d_442); --v_arr1(220) := 'D_442';v_arr2(220) := v_j.d_442;     --221!!!

-----------------D.4---------------

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_431', v_betoltes);
IF p.f = 2 THEN
v_j.d_431 := 0+p.v;
ELSE
v_j.d_431 := 0+p.v;/*KÜLÖN ADAT MNB */
END IF;
									J_SZEKT_EVES_T.FELTOLT('D_431', v_j.d_431);
--v_arr1(-4+161) := 'D_431';v_arr2(-4+161) := v_j.d_431;

p := J_KORR_T.KORR_FUGG(v_year, c_sema,c_m003,'D_432', v_betoltes);
IF p.f = 2 THEN
v_j.d_432 := 0+p.v;
ELSE
v_j.d_432 := 0+p.v;/*KÜLÖN ADAT MNB */
END IF;
									J_SZEKT_EVES_T.FELTOLT('D_432', v_j.d_432);
--v_arr1(-4+162) := 'D_432';v_arr2(-4+162) := v_j.d_432;
v_j.d_43 := v_j.d_431 - v_j.d_432; J_SZEKT_EVES_T.FELTOLT('D_43', v_j.d_43);         --           v_arr1(-4+163) := 'D_43';v_arr2(-4+163) := v_j.d_43;
v_j.d_44 := v_j.d_441 + v_j.d_442; J_SZEKT_EVES_T.FELTOLT('D_44', v_j.d_44);         -- v_arr1(-4+164) := 'D_44';v_arr2(-4+164) := v_j.d_44;
v_j.d_45 := v_k.c_prca024;         J_SZEKT_EVES_T.FELTOLT('D_45', v_j.d_45);         --          v_arr1(-4+165) := 'D_45';v_arr2(-4+165) := v_j.d_45;
v_j.d_46 := 0;                     J_SZEKT_EVES_T.FELTOLT('D_46', v_j.d_46);         --           v_arr1(-4+166) := 'D_46';v_arr2(-4+166) := v_j.d_46;
v_j.d_4 :=  v_j.d_41 + v_j.d_42 + v_j.d_43 + v_j.d_44 - v_j.d_45;
                                   J_SZEKT_EVES_T.FELTOLT('D_4', v_j.d_4);         --  v_arr1(-4+167) := 'D_4';v_arr2(-4+167) := v_j.d_4;


---------------B.4g----------------
v_j.b_4g := v_j.b_2g + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45;
                                   J_SZEKT_EVES_T.FELTOLT('B_4g', v_j.b_4g);    --   v_arr1(-4+168) := 'B_4g';v_arr2(-4+168) := v_j.b_4g;
v_j.b_4n := v_j.b_2n + v_j.d_41 + v_j.d_421 + v_j.d_431 + v_j.d_44 - v_j.d_45;
                                   J_SZEKT_EVES_T.FELTOLT('B_4n', v_j.b_4n);    --   v_arr1(-4+169) := 'B_4n';v_arr2(-4+169) := v_j.b_4n;


---------------B.5g---------------
v_j.b_5g := v_j.b_2g + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5g', v_j.b_5g);          --           v_arr1(-4+170) := 'B_5g';v_arr2(-4+170) := v_j.b_5g;
v_j.b_5n := v_j.b_2n + v_j.d_4;    J_SZEKT_EVES_T.FELTOLT('B_5n', v_j.b_5n);          --           v_arr1(-4+171) := 'B_5n';v_arr2(-4+171) := v_j.b_5n;


---------------D.5---------------
v_j.d_51B11 := v_k.c_TAB279;       J_SZEKT_EVES_T.FELTOLT('D_51B11', v_j.d_51B11);          --         v_arr1(-4+172) := 'D_51B11';v_arr2(-4+172) := v_j.d_51B11;
v_j.d_51B12 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B12', v_j.d_51B12);          --          v_arr1(-4+173) := 'D_51B12';v_arr2(-4+173) := v_j.d_51B12;
--v_j.d_51B12 := v_k.c_prda102;
              /*2015v: 0*/
              /*2015e: 0*/
v_j.d_51B13 := 0;                  J_SZEKT_EVES_T.FELTOLT('D_51B13', v_j.d_51B13); --v_arr1(-4+174) := 'D_51B13';v_arr2(-4+174) := v_j.d_51B13;

v_j.d_5 := v_j.d_51B11 + v_j.d_51B12 + v_j.d_51B13;            J_SZEKT_EVES_T.FELTOLT('D_5', v_j.d_5);              --            v_arr1(-4+175) := 'D_5';v_arr2(-4+175) := v_j.d_5;
---------------D.6---------------
v_j.d_611 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_611', v_j.d_611); --v_arr1(-4+181) := 'D_611';v_arr2(-4+181) := v_j.d_611;
v_j.d_612 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_612', v_j.d_612); --v_arr1(-4+182) := 'D_612';v_arr2(-4+182) := v_j.d_612;
v_j.d_613 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_613', v_j.d_613); --v_arr1(-4+176) := 'D_613';v_arr2(-4+176) := v_j.d_613;
v_j.d_614 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_614', v_j.d_614); --v_arr1(222) := 'D_614';v_arr2(222) := v_j.d_614;
v_j.d_61SC := 0;                   J_SZEKT_EVES_T.FELTOLT('D_61SC', v_j.d_61SC);  --v_arr1(-4+177) := 'D_61SC';v_arr2(-4+177) := v_j.d_61SC;
 
v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_613 + v_j.d_614 - v_j.d_61SC;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);-- v_arr1(-4+186) := 'D_61';v_arr2(-4+186) := v_j.d_61;

v_j.d_621 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_621', v_j.d_621);  --v_arr1(-4+183) := 'D_621';v_arr2(-4+183) := v_j.d_621;
v_j.d_622 := v_j.d_122;            J_SZEKT_EVES_T.FELTOLT('D_622', v_j.d_622); -- v_arr1(-4+184) := 'D_622';v_arr2(-4+184) := v_j.d_622;
v_j.d_623 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_623', v_j.d_623);  --v_arr1(-4+185) := 'D_623';v_arr2(-4+185) := v_j.d_623;
v_j.d_61 := v_j.d_611 + v_j.d_612 + v_j.d_614;
                                   J_SZEKT_EVES_T.FELTOLT('D_61', v_j.d_61);                 --                v_arr1(-4+186) := 'D_61';v_arr2(-4+186) := v_j.d_61;
v_j.d_62 := v_j.d_621 + v_j.d_622 + v_j.d_623;
                                   J_SZEKT_EVES_T.FELTOLT('D_62', v_j.d_62);                 --      v_arr1(-4+187) := 'D_62';v_arr2(-4+187) := v_j.d_62;
v_j.d_6 := v_j.d_61 - v_j.d_62;    J_SZEKT_EVES_T.FELTOLT('D_6', v_j.d_6);                 --      v_arr1(-4+188) := 'D_6';v_arr2(-4+188) := v_j.d_6;

---------------D.7---------------
v_j.d_711 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_711', v_j.d_711); --v_arr1(221) := 'D_711';v_arr2(221) := v_j.d_711;
v_j.d_712 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_712', v_j.d_712); --v_arr1(223) := 'D_712';v_arr2(223) := v_j.d_712;
v_j.d_71 := v_j.d_711 + v_j.d_712; 
                                   J_SZEKT_EVES_T.FELTOLT('D_71', v_j.d_71); --v_arr1(-4+189) := 'D_71';v_arr2(-4+189) := v_j.d_71;
v_j.d_721 := v_j.p_2321 - v_j.p_232;
                                   J_SZEKT_EVES_T.FELTOLT('D_721', v_j.d_721);  --v_arr1(224) := 'D_721';v_arr2(224) := v_j.d_721;
v_j.d_722 := 0;                    J_SZEKT_EVES_T.FELTOLT('D_722', v_j.d_722); --v_arr1(225) := 'D_722';v_arr2(226) := v_j.d_722;
v_j.d_72 := v_j.d_721 + v_j.d_722; 
                                   J_SZEKT_EVES_T.FELTOLT('D_72', v_j.d_72); --v_arr1(-4+190) := 'D_72';v_arr2(-4+190) := v_j.d_72;

v_j.d_7511 := v_k.c_prda066;       J_SZEKT_EVES_T.FELTOLT('D_7511', v_j.d_7511);            --        v_arr1(-4+191) := 'D_7511';v_arr2(-4+191) := v_j.d_7511;
v_j.d_7512 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7512', v_j.d_7512);            --         v_arr1(-4+192) := 'D_7512';v_arr2(-4+192) := v_j.d_7512;
v_j.d_7513 := 0;/*BECSÜLT ADAT */  
                                   J_SZEKT_EVES_T.FELTOLT('D_7513', v_j.d_7513);            --         v_arr1(-4+193) := 'D_7513';v_arr2(-4+193) := v_j.d_7513;
v_j.d_7514 := 0;/*KÜLÖN ADAT KORMÁNYZAT */
                                   J_SZEKT_EVES_T.FELTOLT('D_7514', v_j.d_7514);            --         v_arr1(-4+194) := 'D_7514';v_arr2(-4+194) := v_j.d_7514;
v_j.d_7515 := 0;/*KÜLÖN ADAT KÜLFÖLD*/
                                   J_SZEKT_EVES_T.FELTOLT('D_7515', v_j.d_7515);            --         v_arr1(-4+195) := 'D_7515';v_arr2(-4+195) := v_j.d_7515;
v_j.d_751 := v_j.d_7511 + v_j.d_7512 + v_j.d_7514 + v_j.d_7515;
                                   J_SZEKT_EVES_T.FELTOLT('D_751', v_j.d_751);       --   v_arr1(-4+196) := 'D_751';v_arr2(-4+196) := v_j.d_751;

v_j.d_7521 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7521', v_j.d_7521);               --         v_arr1(-4+197) := 'D_7521';v_arr2(-4+197) := v_j.d_7521;
v_j.d_7522 := v_k.c_prda068;       J_SZEKT_EVES_T.FELTOLT('D_7522', v_j.d_7522);             --         v_arr1(-4+198) := 'D_7522';v_arr2(-4+198) := v_j.d_7522;
v_j.d_7523 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7523', v_j.d_7523);              --          v_arr1(-4+199) := 'D_7523';v_arr2(-4+199) := v_j.d_7523;
v_j.d_7524 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7524', v_j.d_7524);               --          v_arr1(-4+200) := 'D_7524';v_arr2(-4+200) := v_j.d_7524;
v_j.d_7525 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7525', v_j.d_7525);             --           v_arr1(-4+201) := 'D_7525';v_arr2(-4+201) := v_j.d_7525;
v_j.d_7526 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7526', v_j.d_7526);             --           v_arr1(-4+202) := 'D_7526';v_arr2(-4+202) := v_j.d_7526;
v_j.d_7527 := 0;                   J_SZEKT_EVES_T.FELTOLT('D_7527', v_j.d_7527);              --           v_arr1(-4+203) := 'D_7527';v_arr2(-4+203) := v_j.d_7527;

v_j.d_752 := v_j.d_7521 + v_j.d_7522 + v_j.d_7523 + v_j.d_7525 + v_j.d_7526
             + v_j.d_7527;  
                                   J_SZEKT_EVES_T.FELTOLT('D_752', v_j.d_752);--          v_arr1(-4+204) := 'D_752';v_arr2(-4+204) := v_j.d_752;

v_j.d_75 := v_j.d_751 - v_j.d_752; 
                                   J_SZEKT_EVES_T.FELTOLT('D_75', v_j.d_75);       --       v_arr1(-4+205) := 'D_75';v_arr2(-4+205) := v_j.d_75;

v_j.d_7 := v_j.d_71 - v_j.d_72 + v_j.d_75;
                                   J_SZEKT_EVES_T.FELTOLT('D_7', v_j.d_7);         --         v_arr1(-4+206) := 'D_7';v_arr2(-4+206) := v_j.d_7;


---------------B.6g---------------
v_j.b_6g := v_j.b_5g - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72
            + v_j.d_75;
                                  J_SZEKT_EVES_T.FELTOLT('B_6g', v_j.b_6g);             --           v_arr1(-4+207) := 'B_6g';v_arr2(-4+207) := v_j.b_6g;
v_j.b_6n := v_j.b_5n - v_j.d_5 + v_j.d_61 - v_j.d_62 + v_j.d_71 - v_j.d_72 + v_j.d_75;
                                  J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);              --          v_arr1(-4+208) := 'B_6n';v_arr2(-4+208) := v_j.b_6n;
v_j.d_8 := 0;                     J_SZEKT_EVES_T.FELTOLT('B_6n', v_j.b_6n);              --          v_arr1(-4+209) := 'D_8';v_arr2(-4+209) := v_j.d_8;
v_j.b_8g := v_j.b_6g - v_j.d_8;   J_SZEKT_EVES_T.FELTOLT('B_8g', v_j.b_8g);              --          v_arr1(-4+210) := 'B_8g';v_arr2(-4+210) := v_j.b_8g;
v_j.b_8n := v_j.b_6n - v_j.d_8;   J_SZEKT_EVES_T.FELTOLT('B_8n', v_j.b_8n);              --          v_arr1(-4+211) := 'B_8n';v_arr2(-4+211) := v_j.b_8n;

--J_SZEKT_EVES_T.FELTOLT_t(v_arr1, v_arr2);

END scv;

end J_A_HITEL_T;