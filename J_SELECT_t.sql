/*
create or replace PACKAGE "J_SELECT_T" as 

--sémaváltozók--
FUNCTION MUTATO_DB_SZAM RETURN  NUMBER; -- MUTATÓ DB.SZÁMÁNAK KISZÁMÍTÁSA A LOOP-OKHOZ
FUNCTION MUTATO_DB_SZAM_SBS RETURN  NUMBER; -- MUTATÓ DB.SZÁMÁNAK KISZÁMÍTÁSA A LOOP-OKHOZ Sbs
FUNCTION MUTATO_DB_SZAM_BIZT RETURN  NUMBER; -- MUTATÓ DB.SZÁMÁNAK KISZÁMÍTÁSA A LOOP-OKHOZ Biztosító
FUNCTION mutato_db_szam_nyp RETURN  NUMBER; -- MUTATÓ DB.SZÁMÁNAK KISZÁMÍTÁSA A LOOP-OKHOZ Nyugdíjpénztár
--táblaválasztás--
FUNCTION PSZAF_SELECT(C_SEMA VARCHAR2, c_lepes varchar2 default '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN  VARCHAR2; -- PSZAF TÁBLÁK VÁLAZTÁSA
FUNCTION TASA_SELECT(C_SEMA VARCHAR2, c_lepes VARCHAR2 DEFAULT '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN  VARCHAR2; -- TÁSA TÁBLÁK VÁLAZTÁSA
FUNCTION hitel_select(c_sema VARCHAR2) RETURN  VARCHAR2; -- HITELINZÉZET VÁLAZTÁSA
--mesg--
FUNCTION sema_lepes_szetvalaszt(c_sema_lepes VARCHAR2) RETURN pair;
FUNCTION mesg_szamok(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, c_sema VARCHAR2,c_m003 VARCHAR2,c_nev VARCHAR2, c_lepes VARCHAR2 DEFAULT '0') RETURN  NUMBER; -- (1508A-01-01/02c)
--pénztárak--
FUNCTION onk_penzt_d1111(v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- D.1111 MUTATÓ  KISZÁMÍTÁSA ÖNKÉNTES PÉNZTÁRAKNÁL
--biztosítók--
FUNCTION BIZT_VISZONT(C_SEMA VARCHAR2,C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER; -- 2012. Viszontbiztosítók adatainak kiszámolása
FUNCTION BIZT_BETA(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- BETA KOEEFICIENS KISZÁMÍTÁSA BÍZTOSÍTÓ INTÉZETEKNÉL
FUNCTION BIZT_P28_E(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- p28 Élet
FUNCTION BIZT_P28_NE(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- p28 Nem élet
FUNCTION BIZT_P28_EGY(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- p28 Egyszerűsített
FUNCTION bizt_d1111(c_komp VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- D.1111 MUTATÓ KISZÁMÍTÁSA BÍZTOSÍTÓKHOZ
--eva--
FUNCTION EVA_P2(C_TEAOR VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- P.2 MUTATÓ  KISZÁMÍTÁSA RÉGI ÉS ÚJ EVÁSOKNÁL
FUNCTION EVA_P1221(C_TEAOR VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- P.2 MUTATÓ KISZÁMÍTÁSA RÉGI ÉS ÚJ EVÁSOKNÁL
--összesítő--
PROCEDURE osszesito_select(c_sema VARCHAR2, c_teaor VARCHAR2); -- ÖSSZESYTŐ ADATOK LISTÁZÁSA
--scv--
FUNCTION scv_afa(c_m003 VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER; -- Áfa számláló

end J_SELECT_T;
*/



create or replace PACKAGE BODY "J_SELECT_T" as

c_db NUMBER:= j_select.mutato_db_szam;
sql_statement VARCHAR2(200);

------------------ TÁBLANEVEK ----------------------------------
v_a003_list VARCHAR2(20) := 'A_M003_LIST';

--v_w_mesg_lala VARCHAR2(50) := 'PP17_W_MESG_LALA_v01';
--v_w_bizt VARCHAR2(50) := 'pp17_w_bizt';
--v_w_scv_afa VARCHAR2(50) := 'PP17_SCV_AFA_V01';
--v_w_w_elo_veg VARCHAR2(50) := 'PP17_W_W_ELOZETES_V02';
--v_w_w_elo_veg VARCHAR2(50) := 'PP17_W_W_ELOZETES_MARK';



-------------------------------------------------------------------
----------------- MUTATÓ DB.SZÁMÁNAK KISZÁMÍTÁSA-------------------
--------------------------------A LOOPOKHOZ------------------------
-------------------------------------------------------------------

  FUNCTION MUTATO_DB_SZAM RETURN  NUMBER AS
   c_db number(5,0);
   v_mutato_db VARCHAR2(100);
  BEGIN
   v_mutato_db:='select count(*) from A_SEMA_VALTOZOK '
                ||'where valid_m is null';
   EXECUTE IMMEDIATE v_mutato_db INTO c_db;
   return c_db;
  END MUTATO_DB_SZAM;

  FUNCTION MUTATO_DB_SZAM_SBS RETURN  NUMBER AS
   c_db number(5,0);
   v_mutato_db VARCHAR2(100);
  BEGIN
   v_mutato_db:='select count(*) from A_SEMA_VALTOZOK_SBS '
                ||'where valid_m =''HIT'' ';
   EXECUTE IMMEDIATE v_mutato_db INTO c_db;
   return c_db;
  END MUTATO_DB_SZAM_SBS;


  FUNCTION MUTATO_DB_SZAM_BIZT RETURN  NUMBER AS
   c_db number(5,0);
   v_mutato_db VARCHAR2(100);
  BEGIN
   v_mutato_db:='select count(*) from A_SEMA_VALTOZOK_SBS '
                ||'where valid_m =''BIZT'' ';
   execute immediate v_mutato_db into c_db;
   return c_db;
  END MUTATO_DB_SZAM_BIZT;

  FUNCTION MUTATO_DB_SZAM_NYP RETURN  NUMBER AS
   c_db number(5,0);
   v_mutato_db VARCHAR2(100);
  BEGIN
   v_mutato_db:='select count(*) from A_SEMA_VALTOZOK_SBS '
                ||'where valid_m =''NYP'' ';
   execute immediate v_mutato_db into c_db;
   return c_db;
  END MUTATO_DB_SZAM_NYP; 


-------------------------------------------------------------------
----------------- PSZAF TÁBLÁK VÁLASZTÁSA---------------------------
-------------------------------------------------------------------
  FUNCTION PSZAF_SELECT(C_SEMA VARCHAR2, C_LEPES varchar2 DEFAULT '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN  VARCHAR2 AS
  V_TABLA_STR VARCHAR2(50);
  BEGIN

 -- dbms_output.put_line('START PSZAF_SELECT');
  
    CASE C_SEMA 
      WHEN '1' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_HIT'|| v_teszt ||' ';
      WHEN '2' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_HIT'|| v_teszt ||' ';
      WHEN '3' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_HIT'|| v_teszt ||' ';
      WHEN '4' THEN V_TABLA_STR:=' PP'|| v_year ||'_FISIM_PSZAF'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '5' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_PENZT_MNYP'|| v_teszt ||' ';
      WHEN '6' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_PENZT_ONK'|| v_teszt ||' ';
      WHEN '7' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_PENZT_EGESZ'|| v_teszt ||' ';
      WHEN '8' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_PENZT_EGESZ'|| v_teszt ||' ';
      WHEN '9' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_TASA_'|| v_year ||'43'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '10' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_TASA_'|| v_year ||'71'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '11' THEN -- 7 különböző lépés
         CASE 
           WHEN c_lepes = 1 THEN -- 1.
              v_tabla_str := ' PP'|| v_year ||'_KETTOSOK_R01'|| v_verzio ||''|| v_teszt ||' ';
           WHEN c_lepes >= 2 AND c_lepes <= 5 THEN -- 2-5.
              v_tabla_str := ' PP'|| v_year ||'_KETTOSOK_R00'|| v_verzio ||''|| v_teszt ||' ';
           WHEN c_lepes >= 6 AND c_lepes <= 7 THEN -- 6-7.
              v_tabla_str := ' PP'|| v_year ||'_KETTOSOK_R02'|| v_verzio ||''|| v_teszt ||' ';
         END CASE;      
      WHEN '12' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '13' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '14' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '15' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '16' THEN v_tabla_str:=' PP'|| v_year ||'_BIZT'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '17' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT_FIOK_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '19' THEN V_TABLA_STR:=' PP'|| v_year ||'_W_PENZT_FOGL'|| v_teszt ||' ';
      WHEN '21' THEN v_tabla_str:= ' PP'|| v_year ||'_SBS_HIT_SUM'|| v_teszt ||' '; 
      WHEN '22' THEN v_tabla_str:= ' PP'|| v_year ||'_SBS_HIT_SUM'|| v_teszt ||' ';
      WHEN '23' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_HIT_SUM'|| v_teszt ||' '; 
      WHEN '31' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_BIZT'|| v_teszt ||' ';
      WHEN '32' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_BIZT'|| v_teszt ||' ';
      WHEN '33' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_BIZT'|| v_teszt ||' ';
      WHEN '34' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_BIZT'|| v_teszt ||' ';
      WHEN '35' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_BIZT'|| v_teszt ||' ';
      WHEN '36' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_MNYP'|| v_teszt ||' ';
      WHEN '37' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_ONYP'|| v_teszt ||' ';
      WHEN '38' THEN V_TABLA_STR:= ' PP'|| v_year ||'_SBS_MUNYP'|| v_teszt ||' ';
      WHEN '50' THEN V_TABLA_STR:=' PP'|| v_year ||'_SCV_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '51' THEN V_TABLA_STR:=' PP'|| v_year ||'_SCV_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '52' THEN V_TABLA_STR:= ' PP'|| v_year ||'_KATA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '53' THEN V_TABLA_STR:= ' PP'|| v_year ||'_KIVA'|| v_verzio ||''|| v_teszt ||' ';
      ELSE V_TABLA_STR:='';   
    END CASE;
    
	--  dbms_output.put_line('END PSZAF_SELECT');
	
	RETURN V_TABLA_STR;
		
  END PSZAF_SELECT;
-------------------------------------------------------------------
----------------- TÁSA TÁBLÁK VÁLAZTÁSA----------------------------
-------------------------------------------------------------------
FUNCTION TASA_SELECT(C_SEMA VARCHAR2, c_lepes varchar2 default '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN VARCHAR2 AS
  V_TABLA_STR VARCHAR2(50);
BEGIN
 
 --DBMS_OUTPUT.PUT_LINE('START TASA_SELECT');
 
 CASE C_SEMA
      WHEN '1' THEN v_tabla_str:='PP'|| v_year ||'_HIT_TASA'|| v_verzio ||''|| v_teszt ||'';
	  WHEN '2' THEN V_TABLA_STR:='PP'|| v_year ||'_HIT_TASA'|| v_verzio ||''|| v_teszt ||'';
      WHEN '3' THEN v_tabla_str:='PP'|| v_year ||'_HIT_TASA'|| v_verzio ||''|| v_teszt ||'';
      WHEN '4' THEN v_tabla_str:='PP'|| v_year ||'_FISIMTERM_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '9' THEN V_TABLA_STR:='PP'|| v_year ||'_EVA_'|| v_year ||'43'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '10' THEN V_TABLA_STR:='PP'|| v_year ||'_W_TASA_'|| v_year ||'71'|| v_verzio ||''|| v_teszt ||'';
      WHEN '11' THEN -- 7 különböző lépés
         --dbms_output.put_line('mi a c_lepes? ' || c_lepes);
         CASE
           WHEN c_lepes = 1 THEN -- 1.
              v_tabla_str := ' PP'|| v_year ||'_KETTOSOK_R01'|| v_verzio ||''|| v_teszt ||' ';
           WHEN c_lepes >= 2 AND c_lepes <= 5 THEN -- 2-5.
              v_tabla_str := ' PP'|| v_year ||'_KETTOSOK_R00'|| v_verzio ||''|| v_teszt ||' ';
           WHEN c_lepes >= 6 AND c_lepes <= 7 THEN -- 6-7.
              v_tabla_str := ' PP'|| v_year ||'_KETTOSOK_R02'|| v_verzio ||''|| v_teszt ||' ';
         END CASE; 
      WHEN '12' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '13' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '14' THEN v_tabla_str:=' PP'|| v_year ||'_BIZT_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '15' THEN v_tabla_str:=' PP'|| v_year ||'_BIZT_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '16' THEN v_tabla_str:=' PP'|| v_year ||'_BIZT_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '17' THEN V_TABLA_STR:=' PP'|| v_year ||'_BIZT_FIOK_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '50' THEN V_TABLA_STR:=' PP'|| v_year ||'_SCV_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '51' THEN V_TABLA_STR:=' PP'|| v_year ||'_SCV_TASA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '52' THEN V_TABLA_STR:= ' PP'|| v_year ||'_KATA'|| v_verzio ||''|| v_teszt ||' ';
      WHEN '53' THEN V_TABLA_STR:= ' PP'|| v_year ||'_KIVA'|| v_verzio ||''|| v_teszt ||' ';
      ELSE V_TABLA_STR:='';    
 END CASE;
 
  -- dbms_output.put_line('END TASA_SELECT');
 
 RETURN V_TABLA_STR; 
END TASA_SELECT;
-------------------------------------------------------------------
--------------------- HITELINZÉZET VÁLASZTÁSA-----------------------
-------------------------------------------------------------------
FUNCTION HITEL_SELECT(C_SEMA VARCHAR2) RETURN  VARCHAR2 AS
  
	v_temp_jel VARCHAR2(200);
	v_temp_hit VARCHAR2(200);
	v_temp_fiok VARCHAR2(200);
	v_temp_fisimterm VARCHAR2(200);
	v_str_hitel VARCHAR2(400);

    BEGIN

	sql_statement := 'SELECT M003 FROM '|| v_a003_list ||' WHERE VAR_TYPE = ''v_temp_jel'' ';
	EXECUTE IMMEDIATE sql_statement INTO v_temp_jel;
		
	sql_statement := 'SELECT M003 FROM '|| v_a003_list ||' WHERE VAR_TYPE = ''v_temp_hit'' ';
	EXECUTE IMMEDIATE sql_statement INTO v_temp_hit;
		
	sql_statement := 'SELECT M003 FROM '|| v_a003_list ||' WHERE VAR_TYPE = ''v_temp_fiok'' ';
	EXECUTE IMMEDIATE sql_statement INTO v_temp_fiok;
	
	sql_statement := 'SELECT M003 FROM '|| v_a003_list ||' WHERE VAR_TYPE = ''v_temp_fisimterm'' ';
	EXECUTE IMMEDIATE sql_statement INTO v_temp_fisimterm;
    
    CASE c_sema
       WHEN 1 THEN 
          v_str_hitel := J_SZEKT_EVES_T.str_and(v_temp_hit)||' and '
                         || J_SZEKT_EVES_T.str_and(v_temp_jel)||' and '
                         || J_SZEKT_EVES_T.str_and(v_temp_fiok);
       WHEN 2 THEN
          v_str_hitel := J_SZEKT_EVES_T.str_and(v_temp_hit)||' and '
                         || J_SZEKT_EVES_T.str_and(v_temp_fiok)
                         ||' and ('|| J_SZEKT_EVES_T.str_or(v_temp_jel)||')';
       WHEN 3 THEN
          v_str_hitel:= J_SZEKT_EVES_T.str_or(v_temp_fiok);
		
		WHEN 4 THEN
		 v_str_hitel:= J_SZEKT_EVES_T.str_or(v_temp_fisimterm);
		  
    END CASE;
    --dbms_output.put_line(v_str_hitel);
    RETURN v_str_hitel;
END HITEL_SELECT;


-----FUTTATÁSNÁL A SÉMA KÓD ÉS A LÉPÉS SZÁMÁNAK SZÉTVÁLASZTÁSA a bemenetből.
FUNCTION sema_lepes_szetvalaszt(c_sema_lepes VARCHAR2) RETURN pair AS
    v_sem_delim NUMBER;
    c_sema VARCHAR2(20);
    c_lepes VARCHAR2(20);
    p pair;
begin
--dbms_output.put_line('START J_SELECT_T.sema_lepes_szetvalaszt');
    v_sem_delim := instr(c_sema_lepes, '.');
    IF v_sem_delim > 0 THEN
        c_sema := substr(c_sema_lepes, 0, v_sem_delim-1);
        c_lepes := substr(c_sema_lepes, v_sem_delim+1);
    ELSE
        c_sema := c_sema_lepes;
    END IF;

    P := pair.init;
    P.V := c_sema;
    P.F := c_lepes;
--	dbms_output.put_line('END J_SELECT_T.sema_lepes_szetvalaszt');
	
    return p;
end sema_lepes_szetvalaszt;


-------------------------------------------------------------------
----------------- MESG ADATOK VÁLASZTÁSA---------------------------
-------------------------------------------------------------------
-- (1608A-01-01/02c)
-- előzetes sémában előző évi TÁSA számok)
FUNCTION MESG_SZAMOK(v_year varchar2, v_verzio varchar2, v_teszt varchar2, v_betoltes varchar2, C_SEMA VARCHAR2, C_M003 VARCHAR2, C_NEV VARCHAR2,
                     c_lepes varchar2 default '0')
RETURN NUMBER AS
  v_str VARCHAR2(250);
  c_d NUMBER(20,0);
  kell VARCHAR2(2);
  V_SEMA VARCHAR2(10);
  v_table VARCHAR2(20);
  
BEGIN

 v_table := '_W_MESG_LALA';


  kell := 'y';
  --***************************************************************************
  IF c_sema = '11' THEN -- csak 11-nél: 6-7 sémában minde mesg szám 0.
    IF c_lepes >= 6 AND c_lepes <= 7 THEN
       kell := 'ny';
    end if;
  end if;
  /*
  --11-es sémában van amikor egyáltalán nem szabad menjen,
  --ilyenkor az "y" helyére tegyünk bármi mást!
  kell := 'y';    -- 11/1,2,3,4,5 futtatás és az összes többi séma
  --kell := 'ny';  -- csak 11/ 6,7. futtatás (nullázós rész)
  */

  --***************************************************************************
  IF kell = 'y' THEN
     --dbms_output.put_line('kell a mesg lala');
     sql_statement := 'SELECT COUNT(m003) FROM PP'|| v_year ||''|| v_table ||''|| v_verzio ||''|| v_teszt ||'  
     WHERE m003= '''|| c_m003 ||''' AND sema_tipus= '''|| c_sema ||''' ';
	 
	 EXECUTE IMMEDIATE sql_statement INTO c_d;

     --dbms_output.put_line(c_d);
     IF c_d <> 0 AND c_nev <> 'D_4226' THEN
         v_str := 'SELECT NVL('|| c_nev||',0) FROM PP'|| v_year ||''|| v_table ||''|| v_verzio ||''|| v_teszt ||'  '
                  || 'WHERE sema_tipus ='|| c_sema||' AND M003='||c_m003;
         --dbms_output.put_line( v_str||'      '||c_sema||'  '||c_m003);

         EXECUTE immediate v_str INTO c_d;
     ELSE
        c_d := 0;
     END IF;
  ELSE
        c_d := 0;
  END IF;
    --dbms_output.put_line(c_d);
RETURN c_d;
END MESG_SZAMOK;

-------------------------------------------------------------------
----------------- P.2 MUTATÓ  KISZÁMÍTÁSA--------------------------
------------------RÉGI ÉS ÚJ EVÁSOKNÁL-----------------------------
-------------------------------------------------------------------

FUNCTION EVA_P2(C_TEAOR VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN  NUMBER AS
 v_str VARCHAR2(200);
 P_2 number(15,10);
 BEGIN
  /* -------------VÉGLEGES------------*/
    v_str := ' select sum(p_2)/sum(p_1)*1000 from PP'|| v_year ||'_W_W_'|| v_betoltes ||''|| v_verzio ||''|| v_teszt ||' '
             || 'where p_121 < 50000 and sema_tipus=11 and m0581=' || c_teaor;
  execute immediate v_str into P_2;
  RETURN P_2;
END EVA_P2;


-------------------------------------------------------------------
-----------------P.1221 MUTATÓ KISZÁMÍTÁSA-------------------------
------------------RÉGI ÉS ÚJ EVÁSOKNÁL-----------------------------
-------------------------------------------------------------------

FUNCTION EVA_P1221(C_TEAOR VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS
v_str VARCHAR2(200);
P_1221 number(15,10);
BEGIN
/* -------------előzetes tábla volt: PP15_W_W_ELOZETES_V01------------*/
/* -------------VÉGLEGES------------*/
v_str := ' select sum(p_1221)/sum(p_121)*1000 from PP'|| v_year ||'_W_W_'|| v_betoltes ||''|| v_verzio ||''|| v_teszt ||' '
         || 'where p_121<50000 and sema_tipus=11 and m0581='||c_teaor;

execute immediate v_str into P_1221;

RETURN P_1221;
END EVA_P1221;


-------------------------------------------------------------------
----------------- D.1111 MUTATÓ  KISZÁMÍTÁSA-----------------------
----------------------ÖNKÉNTES PÉNZTÁRAKNÁL------------------------
-------------------------------------------------------------------

FUNCTION ONK_PENZT_D1111(v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS
v_str VARCHAR2(200);
c_d1111 number(15,10);

BEGIN
-------------előzetes volt: PP15_W_W_ELOZETES_V01------------
-------------VÉGLEGES------------
v_str := 'select sum(d_1111)/sum(d_1) from PP'|| v_year ||'_W_W_'|| v_betoltes ||''|| v_verzio ||''|| v_teszt ||' where sema_tipus=6';

execute immediate v_str into c_d1111;

RETURN c_d1111;
END ONK_PENZT_D1111;


-------------------------------------------------------------------
---------- 2012. Viszontbiztosítók adatainak kiszámolása-----------
-------------------------------------------------------------------

FUNCTION BIZT_VISZONT(C_SEMA VARCHAR2,C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS
v_str VARCHAR2(400);
c_d  number(15,0);

BEGIN
      case c_sema
        WHEN '12' THEN  
                  v_str := 'select nvl(pxC003,0)-nvl(PxC005,0)-nvl(PxC018,0)'
                            ||'-(nvl(PxC137,0)+nvl(pxC140,0))-(nvl(PBC100,0)'
                            ||'+nvl(PxC034,0)+nvl(PxC037,0)+nvl(PxC143,0)'
                            ||'+nvl(PxC146,0)+nvl(PxC150,0)+nvl(PxC153,0)'
                            ||'+nvl(PBC113,0))+0-nvl(PxC055,0)
                            from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where  M003='||c_m003; 
       WHEN '13' THEN  
                  v_str := 'select nvl(pxC003,0)-nvl(PxC005,0)-nvl(PxC018,0)'
                           ||'-(nvl(PxC137,0)+nvl(pxC140,0))-(nvl(PBC100,0)'
                           ||'+nvl(PxC034,0)+nvl(PxC037,0)+nvl(PxC143,0)'
                           ||'+nvl(PxC146,0)+nvl(PxC150,0)+nvl(PxC153,0)'
                           ||'+nvl(PBC113,0))+0-nvl(PxC055,0)
                            from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where  M003='||c_m003; 
       WHEN '14' THEN  
                  v_str := 'select nvl(pBC003,0)-nvl(PBC005,0)-nvl(PBC018,0)'
                            ||'-(nvl(PBC137,0)+nvl(pBC140,0))-(nvl(PBC034,0)'
                            ||'+nvl(PBC037,0)+nvl(PBC040,0)+nvl(PBC143,0)'
                            ||'+nvl(PBC146,0)+nvl(PBC150,0)+nvl(PBC153,0))'
                            ||'+0-nvl(PBC055,0)
                            from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where  M003='||c_m003; 
       WHEN '15' THEN  
                  v_str := 'select nvl(pBC003,0)-nvl(PBC005,0)-nvl(PBC018,0)'
                            ||'-(nvl(PBC137,0)+nvl(pBC140,0))-(nvl(PBC034,0)'
                            ||'+nvl(PBC037,0)+nvl(PBC040,0)+nvl(PBC143,0)'
                            ||'+nvl(PBC146,0)+nvl(PBC150,0)+nvl(PBC153,0))'
                            ||'+0-nvl(PBC055,0)
                            from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where  M003='||c_m003; 
       WHEN '16' THEN  
                  v_str := 'select nvl(POC003,0)-nvl(POC053,0)-nvl(POC010,0)'
                            ||'-nvl(POC015,0)-nvl(POC018,0)+0-nvl(POC023,0)
                            from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where  M003='||c_m003; 
      end case;
      execute immediate v_str into c_d;

   RETURN c_d;
END BIZT_VISZONT;


-------------------------------------------------------------------
----------------- BETA KOEEFICIENS KISZÁMÍTÁSA---------------------
----------------------BÍZTOSÍTÓ INTÉZETEKNÉL-----------------------
-------------------------------------------------------------------
-- ha kompozit egy cég, ezeket a mutatókat használja a függvény:
-- pxc019, pxc052, pxc054, pxc019, pbc019, pbc052, pbc054
-- ha ezek NULL-ok, akkor nem tudja kiszámítani, lehet hogy hibásan lettek
-- betöltve a biztosító adatok!
FUNCTION BIZT_BETA(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2)
RETURN NUMBER AS
 v_str_kompozit VARCHAR2(200);
 v_str VARCHAR2(200);
 c_kompozit varchar(5);
 c_beta number(15,10);
BEGIN
v_str_kompozit := 'select kompozit from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where m003=' || c_m003;
execute immediate v_str_kompozit into c_kompozit;
--dbms_output.put_line(c_kompozit); ------------------------------------------

  IF c_kompozit='K' THEN     
         v_str:='select (nvl(PXC019,0)+nvl(PXC052,0)+nvl(PXC054,0))'
                || '/(nvl(PXC019,0)+nvl(PXC052,0)+nvl(PXC054,0)+nvl(PBC019,0)'
                || '+nvl(PBC052,0)+nvl(PBC054,0)) 
                from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where m003='||c_m003;
         EXECUTE IMMEDIATE v_str INTO c_beta;
  else c_beta:=1;
  end if;

RETURN c_beta;
END BIZT_BETA;


-- p28 nem élet
FUNCTION BIZT_P28_NE(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS
v_str VARCHAR2(1000);
v_p28 number(15,0);
BEGIN
v_str:='select  
          nvl(pbc003,0)-nvl(pbc005,0)-nvl(pbc018,0) -
          (nvl(pbc137,0)+nvl(pbc140,0))- 
          (nvl(pbc034,0)+nvl(pbc037,0)+nvl(pbc040,0)+nvl(pbc143,0)'
          || '+nvl(pbc146,0)+nvl(pbc150,0)+nvl(pbc153,0))-
          nvl(pbc055,0)
        from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where m003=' || c_m003;

EXECUTE immediate v_str INTO v_p28;

RETURN v_p28;
END BIZT_P28_NE;


-- p28 élet
FUNCTION BIZT_P28_E(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS

v_str VARCHAR2(1000);
v_p28 number(15,0);
BEGIN
v_str:='select  
          nvl(pxc003,0)-nvl(pxc005,0)-nvl(pxc018,0) -
          (nvl(pxc137,0)+nvl(pxc140,0))- 
          (nvl(pbc100,0)+nvl(pxc034,0)+nvl(pxc037,0)+nvl(pxc143,0)'
          || '+nvl(pxc146,0)+nvl(pxc150,0)+nvl(pxc153,0)+nvl(pbc113,0))-
          nvl(pxc055,0)
        from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where m003=' || c_m003;

execute immediate v_str into v_p28;

RETURN v_p28;
END BIZT_P28_E;


-- p28 egyszerűsített
FUNCTION BIZT_P28_EGY(C_M003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_betoltes VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS

v_str VARCHAR2(200);
v_p28 number(15,0);
BEGIN
v_str:='select  
          nvl(pbc003,0)-nvl(pbc005,0)-nvl(pbc018,0) -
          (nvl(pbc137,0)+nvl(pbc140,0))- 
          (nvl(pbc034,0)+nvl(pbc037,0)+nvl(pbc040,0)+nvl(pbc143,0)'
          || '+nvl(pbc146,0)+nvl(pbc150,0)+nvl(pbc153,0))-
          nvl(pbc055,0)
        from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' where m003='||c_m003;
execute immediate v_str into v_p28;

RETURN v_p28;
END BIZT_P28_EGY;
-------------------------------------------------------------------
----------------- D.1111 MUTATÓ  KISZÁMÍTÁSA-----------------------
--------------------------BÍZTOSÍTÓKHOZ----------------------------
-------------------------------------------------------------------

FUNCTION BIZT_D1111(c_komp VARCHAR2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN  NUMBER AS
v_str_d VARCHAR2(200);
v_str VARCHAR2(200);
c_d1111 number(20);
c_sum number(20,5);

BEGIN
/* HIBÁS, 0-T TETTEM IDE IDEIGLENESEN. 2017.09.05*/
--c_sum := 0;

case c_komp
    WHEN 'E' THEN 
                v_str_d := 'select sum(D_1111) from PP'|| v_year ||'_W_W_'|| v_betoltes ||''|| v_verzio ||''|| v_teszt ||' '
                           || 'where sema_tipus=12';
                EXECUTE IMMEDIATE v_str_d INTO c_d1111;

                v_str:='select sum(nvl(PXC019,0))+sum(nvl(PXC052,0))'
                       || '+sum(nvl(PXC054,0)) 
                from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' 
                where INT_EGY='||'''I'''||' and (KOMPOZIT='||'''K'''
                      ||' OR KOMPOZIT='''||c_komp||''')' ;
                --dbms_output.put_line(v_str);
                execute immediate v_str into c_sum;

    WHEN 'NE' THEN
                v_str_d := 'select sum(D_1111) from PP'|| v_year ||'_W_W_'|| v_betoltes ||''|| v_verzio ||''|| v_teszt ||' '
                           || 'where sema_tipus=14';
                EXECUTE IMMEDIATE v_str_d INTO c_d1111;

                v_str:='select sum(nvl(PBC019,0))+sum(nvl(PBC052,0))'
                        || '+sum(nvl(PBC054,0)) 
                from PP'|| v_year ||'_W_BIZT'|| v_teszt ||' 
                where  INT_EGY='||'''I'''||' and (KOMPOZIT='||'''K'''
                       ||' OR KOMPOZIT='''||c_komp||''')' ;
                --dbms_output.put_line(v_str);
                execute immediate v_str into c_sum;
end case;  
c_sum:=c_d1111/c_sum;

RETURN c_sum;
END BIZT_D1111;



-- KIKAPCSOLVA!!!
-------------------------------------------------------------------
----------------- ÖSSZESYTŐ ADATOK LISTÁZÁSA-----------------------
-------------------------------------------------------------------
PROCEDURE OSSZESITO_SELECT(C_SEMA VARCHAR2, C_TEAOR VARCHAR2) as
BEGIN
null;
END OSSZESITO_SELECT; 



-- Áfa számláló
FUNCTION SCV_AFA(C_M003 varchar2, v_year VARCHAR2, v_betoltes VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER AS
 v_str VARCHAR2(300); 
 c_d NUMBER(20,0);
BEGIN

--Nem minden cég volt meg az ÁFA-ban - ezért megszámoljuk 
-- h hányszor fordul elő (a bemeneti tábla miatt maximum 1-szer)
--Ha pedig nem szerepel a cég akkor nullát ad.
v_str := 'SELECT COUNT(osszeg) FROM PP'|| v_year ||'_SCV_AFA'|| v_verzio ||''|| v_teszt ||' WHERE m003=' || c_m003;
execute immediate v_str into c_d;

IF c_d <> 0 THEN
 v_str := 'SELECT osszeg FROM PP'|| v_year ||'_SCV_AFA'|| v_verzio ||''|| v_teszt ||' WHERE m003=' || c_m003;
 execute immediate v_str into c_d;
end if;

return c_d;
end SCV_AFA;

end J_SELECT_T;