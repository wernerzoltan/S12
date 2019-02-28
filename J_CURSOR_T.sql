/*
create or replace PACKAGE "J_CURSOR_T" as 

TYPE d_crs IS REF CURSOR;

-- kurzornyitás
PROCEDURE J_SEL(tab_name in VARCHAR2,
                 v_str in VARCHAR2,
                 crs in out d_crs); -- tényleges kurzor nyitás

-- teáorok keresése
FUNCTION TEAOR_SELECT(c_sema VARCHAR2, 
                      r_m3 VARCHAR2,
                      c_lepes varchar2 default '0'
					  , v_year varchar2, v_verzio varchar2, v_teszt varchar2
                      ) RETURN VARCHAR2; -- TEÁOR azonosító választó. String-et ad vissza.
                                                      -- TEÁOR: Gazdasági tevékenységek egységes ágazati osztályozási rendszere.
-- kurzornyitás, belső eljárás
PROCEDURE OPENCURSOR(c_sema VARCHAR2,
                     c_lepes VARCHAR2,
                     v_table VARCHAR2,
                     b_teszt BOOLEAN DEFAULT FALSE --ha teszt, akkor nem kerülnek be az adatok,
                                                   --csak a cégek a sémákkal, az értékek 0-k lesznek.
                     , v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2
					 ); -- kurzor indító és táblafeltöltő eljárás
                                        -- ez végzi a tényleges séma futtatást!
                                        -- sémánként eltérhetnek a feldolgozó csomagok, eljárások.
                                        -- c_sema: séma szám

end J_CURSOR_T;
*/


create or replace PACKAGE BODY "J_CURSOR_T" as

-- tényleges kurzor nyitás
PROCEDURE J_SEL (TAB_NAME IN VARCHAR2, V_STR IN VARCHAR2, CRS IN OUT D_CRS) IS
 STMT VARCHAR2(5000);
BEGIN
    stmt := 'SELECT M003 FROM ' || tab_name || v_str;
   -- DBMS_OUTPUT.PUT_LINE('JSEL: '); 
	-- DBMS_OUTPUT.PUT_LINE(stmt);
    OPEN CRS FOR STMT;
END J_SEL;

-- TEÁOR azonosító választó. String-et ad vissza.
-- TEÁOR: Gazdasági tevékenységek egységes ágazati osztályozási rendszere.
FUNCTION TEAOR_SELECT(C_SEMA VARCHAR2, R_M3 VARCHAR2, c_lepes varchar2, v_year varchar2, v_verzio varchar2, v_teszt varchar2)
RETURN VARCHAR2 AS
 C_TEAOR VARCHAR2(10);
 C_STR VARCHAR2(200);
 C_TABLA VARCHAR2(50);
 BEGIN
   C_TABLA := J_SELECT_T.TASA_SELECT(C_SEMA, c_lepes, v_year, v_verzio, v_teszt);
   c_str := 'SELECT M0581 FROM ' || c_tabla || ' WHERE M003=' || r_m3;
   --DBMS_OUTPUT.PUT_LINE(C_STR); 
   EXECUTE IMMEDIATE C_STR INTO C_TEAOR;
   RETURN C_TEAOR;
END TEAOR_SELECT;

-- kurzor indító és táblafeltöltő eljárás
-- ez végzi a tényleges séma futtatást!
-- sémánként eltérhetnek a feldolgozó csomagok, eljárások.
-- c_sema: séma szám
PROCEDURE OPENCURSOR(c_sema VARCHAR2, c_lepes VARCHAR2, v_table VARCHAR2, 
                     b_teszt BOOLEAN DEFAULT FALSE, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2) IS
    v_sem_delim NUMBER := 0;
    c_m3 d_crs;
    r_m3 VARCHAR2(50);
    v_m003 NUMBER;
    c_str VARCHAR2(10000);
    c_str_kihagy_9_11 VARCHAR2(5000);
    c_str_kihagy_9 VARCHAR2(200);
    c_str_kihagy_52 varchar2(200);
    c_teaor VARCHAR2(5);
    v_beta NUMBER(15,10);
    sor NUMBER(3);
    i NUMBER(15,0);
BEGIN
    
	--dbms_output.put_line('START J_CURSOR.OPENCURSOR');
	
	c_str := '';

    -- 9-es és 11-es: cégek kihagyása
    -- 2017.09.20
    -- + belevettem: 25057669.
    -- vissza 25057669
    c_str_kihagy_9_11 := '(10247620,11494533,11563446,11696333,11721284,'||
    '11964153,12324842,12357440,12508691,12564622,12712708,12736542,'||
    '12813689,13024875,13043140,13092931,13211956,13288080,13291532,'||
    '13432966,13505206,13696418,13762012,13804031,13950857,14035074,'||
    '14041691,14129492,14216552,14275579,14487660,14722387,14737707,'||
    '14750980,14912083,14922783,14952034,14967461,14976816,14978344,'||
    '14989681,20156574,20569880,20967532,20968337,21162699,21310919,'||
    '21522426,21532906,21779398,21912810,22121372,22164955,22229645,'||
    '22320722,22480242,22568225,22583046,22721226,22741853,22750057,'||
    '22786737,22794136,22938154,22973430,22988434,23011520,23011915,'||
    '23081561,23122936,23150261,23292637,23333356,23358074,23367151,'||
    '23383959,23390821,23402702,23425679,23465400,23466061,23729227,'||
    '23743803,23752083,23764118,23785519,23793592,23796265,23824724,'||
    '23830619,23841114,23844777,23847031,23853586,23857982,23877636,'||
    '23879944,23887044,23894404,23905573,23921065,23921993,23930245,'||
    '23978696,23989706,24060682,24105439,24140887,24149288,24194068,'||
    '24203946,24227340,24258719,24265650,24274342,24289054,24311225,'||
    '24311397,24325895,24390635,24394385,24679170,24705840,24722694,'||
    '24798095,24865614,24871626,24872658,24898755,24958165,24992165,'||
    '25016071,25380402,25399943,25686911,27265264,27269172,28410230,'||
    '28415187,29127403)';
    
    c_str_kihagy_9 := '(20733719,21197127,21539594,21921760,24581033,28699747)';
    
    c_str_kihagy_52 := '(21779398,20262514,25076006,25194322,28666675)';
       
    --11-es kihagyásokat a hozzájuk kapcsolódó nézetekben kezeltem le.

    -- séma futtatás
    CASE c_sema
    WHEN '1' THEN
        c_str := ' WHERE ' || J_SELECT_T.HITEL_SELECT(c_sema);
         J_SEL(v_table, c_str, c_m3);
         sor := 1;
	   
		LOOP
              FETCH c_m3 INTO r_m3;
    		    EXIT WHEN c_m3%NOTFOUND;
				 
              IF NOT b_teszt THEN 
				J_A_HITEL_T.HITELINTEZET(c_sema, c_lepes, r_m3, v_year, v_verzio, v_teszt, v_betoltes);
              end if;
				
              IF r_m3 = '19670780' THEN 
                J_SZEKT_EVES_T.FELTOLT_TABLABA('18', '6491', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
              ELSIF r_m3 = '10803828' then 
                J_SZEKT_EVES_T.FELTOLT_TABLABA('18', '6619', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
              ELSE
                J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6419', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
              END IF;

              COMMIT;
			  			
              sor := sor + 1;
			 
			
         END LOOP;
		 
    WHEN '2' THEN
          c_str := ' WHERE ' || J_SELECT_T.HITEL_SELECT(c_sema);
          J_SEL(v_table, c_str, c_m3);          
          LOOP
              FETCH c_m3 INTO r_m3;
              EXIT WHEN c_m3%NOTFOUND;

              IF NOT b_teszt THEN 
                J_A_HITEL_T.HITELINTEZET(c_sema, c_lepes, r_m3, v_year, v_verzio, v_teszt, v_betoltes);
              end if;

              J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6492', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
    WHEN '3' THEN    
          sor := 1;
          c_str := ' WHERE ' || J_SELECT_T.HITEL_SELECT(c_sema);
          J_SEL(v_table, c_str, c_m3);                
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;

            IF NOT b_teszt THEN 
               J_A_HITEL_T.HITELINTEZET(c_sema, c_lepes, r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            end if;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6419', r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
            sor := sor + 1;
            COMMIT;              
          END LOOP;
		  
    WHEN '4' THEN
          c_str :=' WHERE ' || J_SELECT_T.HITEL_SELECT(c_sema); -- Modified by Zoltán Werner
		  --c_str := ' WHERE m003!=25418734 and m003!=12292808 '; 
          J_SEL(v_table, c_str, c_m3);
          sor := 1;          
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;

            IF NOT b_teszt THEN
              J_A_HITEL_T.FISIM_TERM(v_year, v_verzio, v_teszt, v_betoltes,c_sema, r_m3);
            end if;

            c_teaor := TEAOR_SELECT(c_sema, r_m3, '', v_year, v_verzio, v_teszt);            
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, c_teaor, r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
            sor := sor + 1;            
            IF sor = 50 then
              COMMIT;
              sor := 1;
            END IF;            
          END LOOP;     
		  
    WHEN '5' THEN
          J_SEL(v_table,c_str, c_m3);          
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            

            IF NOT b_teszt THEN 
              J_A_PENZT_T.PENZTAR_MNYP(v_year, v_verzio, v_teszt, v_betoltes, c_sema, r_m3);
            end if;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6530', r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
          END LOOP;  
		  
    WHEN '6' THEN
          J_SEL(v_table,c_str, c_m3);          
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            

            IF NOT b_teszt THEN
              J_A_PENZT_T.PENZTAR_ONK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, r_m3);
            end if;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6530', r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
          END LOOP;
		  
    WHEN '7' THEN
          J_SEL(v_table,c_str, c_m3);          
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            

            IF NOT b_teszt THEN
              J_A_PENZT_T.PENZTAR_ONSEG_EGESZ(v_year, v_verzio, v_teszt, v_betoltes, c_sema, r_m3);
            end if;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6512', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
    WHEN '8' THEN
          J_SEL(v_table,c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;

            IF NOT b_teszt THEN
              J_A_PENZT_T.PENZTAR_ONSEG_EGESZ(v_year, v_verzio, v_teszt, v_betoltes, c_sema, r_m3);
            end if;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema,'6512', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
    WHEN '9' THEN
          c_str:= ' WHERE m0581 BETWEEN 6419 AND 6630 ';

          c_str := c_str || ' and m003 not in ' || c_str_kihagy_9_11;
          c_str := c_str || ' and m003 not in ' || c_str_kihagy_9;

          J_SEL(v_table,c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;
            C_TEAOR := TEAOR_SELECT('9', R_M3, '', v_year, v_verzio, v_teszt);


            IF NOT b_teszt THEN
              J_A_EVA_T.EVA_43(v_year, v_verzio, v_teszt, v_betoltes, '9', C_TEAOR, R_M3);
            END IF;

            --J_SZEKT_EVES_T.FELTOLT_TABLABA_KETTOS('9',C_TEAOR,R_M3);
            J_SZEKT_EVES_T.FELTOLT_TABLABA('9', C_TEAOR,R_M3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
    WHEN '10' THEN
          c_str:= ' where m0581 BETWEEN 6419 AND 6630  ';
          J_SEL(v_table,c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;
            c_teaor := TEAOR_SELECT(c_sema, r_m3, '', v_year, v_verzio, v_teszt);

            IF NOT b_teszt THEN
              J_A_EVA_T.EVA_71(v_year, v_verzio, v_teszt, v_betoltes, c_sema, c_teaor, r_m3);
            end if;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, c_teaor, r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            COMMIT;            
          END LOOP;
		  
     WHEN '11' THEN --itt kezeljük a c_lepes-t is.
          --dbms_output.put_line('ez a c_lepes: ' || c_lepes);
          CASE c_lepes
          WHEN '1' THEN --1.
            c_str := ' WHERE m003!=19670780 AND (m0581=6491'
                     || ' OR m0581=6492 OR m0581=6499) ';
          WHEN '2' THEN --2.
            c_str := ' WHERE m0581=6630 OR m0581=6629 ';
          WHEN '3' THEN --3.
            c_str := ' WHERE (m0581=6621 OR m0581=6612 OR m0581=6611) ';
          WHEN '4' THEN --4. 2400db
            c_str := ' WHERE m0581=6619 AND m003!=10803828';
          WHEN '5' THEN --5. 3700db
            c_str := ' WHERE m0581=6622 ';
          ELSE
            c_str := c_str;
          end case; --6,7. lépésnél c_str üres.

          -- globalisan erre a ceg ne keruljon be:
          -- 2017.09.20.

          IF c_lepes >= 1 AND c_lepes <= 5 THEN
            c_str := c_str || ' AND m003 != 14927032';
            c_str := c_str || ' and m003 not in ' || c_str_kihagy_9_11;
          ELSE
            c_str := c_str || ' where m003 != 14927032';
            c_str := c_str || ' and m003 not in ' || c_str_kihagy_9_11;
          end if;                    

          /*
          ezeket kell kapcsolgatni futtatás közben. Ne töröld ki. 
          c_str := ' WHERE m003!=19670780 AND (m0581=6491 OR m0581=6492 OR m0581=6499) ';  -- 1. futás (6491,6492,6499)
          --c_str := ' WHERE m0581=6630 OR m0581=6629 ';                 -- 2.
          --c_str := ' WHERE m0581=6621 OR m0581=6612 OR m0581=6611 ';   -- 3.
          --c_str := ' WHERE m0581=6619 AND m003!=10803828';             -- 4. 2400db
          --c_str := ' WHERE m0581=6622 ';                              -- 5. 3700db
          -- 6. (nem működik)
          -- 7. (nem működik)
          */

          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            
            CASE
            WHEN c_lepes >= 1 AND c_lepes <= 5 THEN --1-5.
              --dbms_output.put_line('megvolt c_lepes: ' || c_lepes || ', ' ||
              --                     'ez a c_str: ' || c_str);
              c_teaor := TEAOR_SELECT(c_sema, r_m3, c_lepes, v_year, v_verzio, v_teszt);

              IF NOT b_teszt THEN
                J_A_HITEL_T.KETTOSOK(v_year, v_verzio, v_teszt, v_betoltes, c_sema, r_m3, c_lepes);

              end if;

              J_SZEKT_EVES_T.FELTOLT_TABLABA('11', c_teaor, r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            WHEN c_lepes >= 6 AND c_lepes <= 7 THEN --6-7.
              c_teaor := TEAOR_SELECT('11', r_m3, c_lepes, v_year, v_verzio, v_teszt);
              --71-es sema tavalyio adattokkal
              IF NOT b_teszt THEN
                J_A_HITEL_T.KETTOSOK(v_year, v_verzio, v_teszt, v_betoltes, '11', r_m3, c_lepes);
              end if;
              --71-es sema tavalyio adattokkal                
              J_SZEKT_EVES_T.FELTOLT_TABLABA('11', c_teaor, r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            END CASE;

            /*
            --PP17_KETTOSOK_v01 -re /1./
            --és PP17_KETTOSOK_v00 /2,3,4,5./

            c_teaor := TEAOR_SELECT(c_sema, r_m3);
            J_A_EVA_UJ.KETTOSOK(c_sema, r_m3);
            J_SZEKT_EVES_T.FELTOLT_TABLABA('11', c_teaor, r_m3);

            --J_SZEKT_EVES_T.feltolt_tablaba(c_sema,c_teaor,r_m3);
            --J_SZEKT_EVES_T.feltolt_tablaba_kettos(c_sema,c_teaor,r_m3);

            /*
            --PP17_KETTOSOK_v02 -re /6,7./

            c_teaor := TEAOR_SELECT('11', r_m3);--71-es sema tavalyio adattokkal
            J_A_EVA_UJ.KETTOSOK('11', r_m3);--71-es sema tavalyio adattokkal                
            J_SZEKT_EVES_T.FELTOLT_TABLABA('11', c_teaor, r_m3);
            */

            COMMIT;
          END LOOP;
		  
    WHEN '12' THEN
          c_str := 'WHERE INT_EGY=' || '''I'''
                   || ' AND (KOMPOZIT=' || '''K'''
                   || ' OR KOMPOZIT=' || '''E''' || ')';
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;

            IF b_teszt THEN
              v_beta := 1;
            ELSE
              v_beta := J_SELECT_T.BIZT_BETA(r_m3, v_year, v_verzio, v_betoltes, v_teszt ); 
            end if;            

            IF NOT b_teszt THEN
              J_A_BIZT_E_T.BIZT_INTEZET_E(c_sema, r_m3, v_year, v_verzio, v_betoltes, v_teszt);
            END IF;

            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6511', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            COMMIT;            
          END LOOP;
		  
    WHEN '13' THEN
          c_str := 'where INT_EGY=' || '''E''' || ' and KOMPOZIT=' || '''K''';
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            
            IF NOT b_teszt THEN
              J_A_BIZT_E_T.BIZT_EGY_TELJES_E(c_sema, r_m3, v_year, v_verzio, v_betoltes, v_teszt);
            end if;
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema,'6511', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            COMMIT;
          END LOOP;
		  
    WHEN '14' THEN
          c_str := 'where INT_EGY=' || '''I'''
                   || ' and (KOMPOZIT=' || '''K'''
                   || ' OR KOMPOZIT=' || '''NE''' || ')';
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            
            IF NOT b_teszt THEN
              J_A_BIZT_NE_T.BIZT_INTEZET_NE(c_sema, r_m3, v_year, v_verzio, v_betoltes, v_teszt);
            end if;
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema,'6512', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
            COMMIT;
          END LOOP;
		  
    WHEN '15' THEN
          c_str := 'where INT_EGY=' || '''E''' || ' and KOMPOZIT=' || '''K''' ;
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            
            IF NOT b_teszt THEN
              J_A_BIZT_NE_T.BIZT_EGY_TELJES_NE(c_sema, r_m3, v_year, v_verzio, v_betoltes, v_teszt);
            end if;
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6512', r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
            COMMIT;
          END LOOP;
		  
    WHEN '16' THEN
          c_str := 'where INT_EGY=' || '''E''' || ' and KOMPOZIT=' || '''NE''' ;
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;            
            IF NOT b_teszt THEN
              J_A_BIZT_NE_T.BIZT_EGY_EGYSZERU_NE(c_sema, r_m3, v_year, v_verzio, v_betoltes, v_teszt);
            end if;
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6512', r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
            COMMIT;
          END LOOP;
		  
    WHEN '17' THEN
         -- c_str:='where INT_EGY='||'''I'''||' and KOMPOZIT='||'''K''' ;
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;
            --dbms_output.put_line(r_m3);            
            IF NOT b_teszt THEN
              J_A_BIZT_NE_T.BIZT_FIOK_NE(c_sema, r_m3, v_year, v_verzio, v_betoltes, v_teszt);
            end if;
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6512', r_m3, v_year, v_verzio, v_teszt, v_betoltes);            
            COMMIT;
          END LOOP;
		  
    WHEN '19' THEN
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;
            IF NOT b_teszt THEN
              J_A_PENZT_T.penztar_FOGL(v_year, v_verzio, v_teszt, v_betoltes, c_sema, r_m3);
            end if;
            J_SZEKT_EVES_T.FELTOLT_TABLABA(c_sema, '6530', r_m3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
    WHEN '50' THEN --SCV-k
          -- az 50, 51 egy táblából fut.
          -- itt azok a cégek vannak felsorolva, amik NEM holdingok, vagy egyik sem.
          c_str:=' where m003 not in (13663281,
                                      14458028,
                                      12581012,
                                      14541878,
                                      11877952,
                                      12575505,
                                      13277396,
                                      13431855,
                                      13534965,
                                      24873271,
                                      14772588,
                                      23997349,
                                      23184956,
                                      23292637) '; --Gránit bank holding lett (2018.09.06)
                                                   --új: 11858326
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;
            c_teaor := TEAOR_SELECT('50', r_m3, '', v_year, v_verzio, v_teszt);

            IF NOT b_teszt THEN
              J_A_HITEL_T.scv(v_year, v_verzio, v_teszt, '', '50', r_m3, '');
			 
            end if;
            --J_SZEKT_EVES_T.FELTOLT_TABLABA_kettos('50',c_teaor,r_m3);
            J_SZEKT_EVES_T.FELTOLT_TABLABA('50', c_teaor,r_m3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
    WHEN '51' THEN--holdingok
          -- az 50, 51 egy táblából fut.
          -- itt azok a cégek vannak felsorolva, amik nem scv-k, de holdingok.
          c_str:=' where m003 in (13663281,
                                  14458028,
                                  12581012,
                                  14541878,
                                  11877952,
                                  12575505,
                                  13277396,
                                  13431855,
                                  13534965,
                                  24873271,
                                  14772588,
                                  23997349,
                                  23184956,
                                  23292637)';  --Gránit bank holding lett (2018.09.06)
                                               --új: 11858326
          J_SEL(v_table, c_str, c_m3);
          LOOP
            FETCH c_m3 INTO r_m3;
            EXIT WHEN c_m3%NOTFOUND;
            c_teaor:=TEAOR_SELECT('51', r_m3, '', v_year, v_verzio, v_teszt);

            IF NOT b_teszt THEN
              J_A_HITEL_T.scv(v_year, v_verzio, v_teszt, '', '51', r_m3, '');

            end if;
            --J_SZEKT_EVES_T.FELTOLT_TABLABA_kettos('51',c_teaor,r_m3);
            J_SZEKT_EVES_T.FELTOLT_TABLABA('51', C_TEAOR,R_M3, v_year, v_verzio, v_teszt, v_betoltes);
          END LOOP;
		  
      WHEN '52' THEN --KATA
          -- az alábbi céget ki kell hagyni, hibásan került be.
          -- (ez benne van a c_str_kihagy változóban is)
          -- 2017.09.20.
          --c_str := ' where m003 !=  ';
          c_str := ' where m003 not in ' || c_str_kihagy_52;
          J_SEL(V_TABLE, C_STR, C_M3);
          LOOP
            FETCH C_M3 INTO R_M3;
            EXIT WHEN C_M3%NOTFOUND;
            C_TEAOR:=TEAOR_SELECT('52', R_M3, '', v_year, v_verzio, v_teszt);            
            IF NOT b_teszt THEN
              J_A_EVA_T.KATA(v_year, v_verzio, v_teszt, v_betoltes, '52', C_TEAOR, R_M3);
            end if;
            --J_SZEKT_EVES_T.FELTOLT_TABLABA_KETTOS('52', C_TEAOR,R_M3);
            J_SZEKT_EVES_T.FELTOLT_TABLABA('52', C_TEAOR,R_M3, v_year, v_verzio, v_teszt, v_betoltes);
            COMMIT;
          END LOOP;
		  
      WHEN '53' THEN --KIVA
          J_SEL(V_TABLE, C_STR, C_M3);
          LOOP
            FETCH C_M3 INTO R_M3;
            EXIT WHEN C_M3%NOTFOUND;
            C_TEAOR:=TEAOR_SELECT('53', R_M3, '', v_year, v_verzio, v_teszt);
            IF NOT b_teszt THEN
              J_A_EVA_T.KIVA(v_year, v_verzio, v_teszt, v_betoltes, '53', C_TEAOR, R_M3);
            end if;
            --J_SZEKT_EVES_T.FELTOLT_TABLABA_KETTOS('53',C_TEAOR,R_M3);
            J_SZEKT_EVES_T.FELTOLT_TABLABA('53', C_TEAOR,R_M3, v_year, v_verzio, v_teszt, v_betoltes);
            COMMIT;
          END LOOP;
      END CASE;
	  
	  	dbms_output.put_line('END J_CURSOR.OPENCURSOR');
	  
END OPENCURSOR;

end J_CURSOR_T;