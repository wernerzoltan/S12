/*
create or replace PACKAGE "J_KETTOS_FUGG_T" as 

FUNCTION KETTOS_FUGG (c_sema VARCHAR2,c_m003 VARCHAR2,PIC_KOD VARCHAR2,c_lepes VARCHAR2 DEFAULT '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER; --Fő függvény
FUNCTION KETTOS_FUGG_UJ (c_sema varchar2,c_m003 VARCHAR2,c_lepes varchar2 default '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN j_kettosok;
FUNCTION p_1221 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M092    
FUNCTION p_1222 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M091    
FUNCTION p_121  (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M103     
FUNCTION p_1363 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M200
FUNCTION p_1361 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M019
FUNCTION p_1312 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M049            
FUNCTION p_14   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M007 
FUNCTION p_15   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M045,PAJ0M196
FUNCTION p_16   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M045,PAJ0M196
FUNCTION p_21   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M008
FUNCTION p_22   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M090
FUNCTION p_2331 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M093
FUNCTION p_24 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M091+PFC0M091
FUNCTION p_231  (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M022
FUNCTION p_2321 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M023
FUNCTION p_262  (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M017
FUNCTION p_27   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFD0M082
FUNCTION K_1    (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M020
FUNCTION d_1111 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M016
FUNCTION d_1111_eva (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M016
FUNCTION b1g_kettos (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M016
FUNCTION d_11121(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M017
FUNCTION d_11127(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M087
FUNCTION d_1121 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M045,PAJ0M196
FUNCTION d_1123 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M088
FUNCTION d_1212 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M198,ADAT HIÁNYÁBAN V_J.D_111*0.03  
FUNCTION d_1211 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M094,PAJ0M061,PAJ0M013
FUNCTION d_29C1 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M061                      
FUNCTION d_29C2 (c_sema VARCHAR2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M013                      
FUNCTION d_29b1 (c_sema varchar2,c_m003 VARCHAR2, c_lepes varchar2 default '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PRDA107+ PRDA108
FUNCTION d_29b3 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PRJA050
FUNCTION d_29E3 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFD0M603
FUNCTION d_39253(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PAJ0M065                     
FUNCTION d_41211(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M081                     
FUNCTION d_41212(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M061,PFC0M062
FUNCTION d_41221(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M078            
FUNCTION d_41222(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M804            
FUNCTION d_45   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M024               
FUNCTION d_51B11(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFC0M054            
FUNCTION d_51B12(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFD0M102            
FUNCTION d_7511 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFD0M066             
FUNCTION d_7522 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER;  --PFD0M068          

end J_KETTOS_FUGG_T;
*/


create or replace PACKAGE BODY "J_KETTOS_FUGG_T" as

v_k j_kettosok;
v_k j_kettosok;

-- Mutatókból meghívott függvény, számmal tér vissza.
FUNCTION KETTOS_FUGG (c_sema VARCHAR2, c_m003 VARCHAR2, PIC_KOD VARCHAR2,
                      c_lepes VARCHAR2 DEFAULT '0',
					  v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)
RETURN NUMBER AS
  mind_ossz NUMBER(15,0);
  v_str VARCHAR2(2000);
  v_tabla VARCHAR2(1000);
BEGIN
  v_tabla := J_SELECT_T.tasa_select(c_sema, c_lepes, v_year, v_verzio, v_teszt);
  v_str :='SELECT (NVL(' || pic_kod || ',0)) FROM ' || v_tabla
           ||' WHERE m003=' || c_m003;
  --dbms_output.put_line(v_str);
  EXECUTE IMMEDIATE v_str INTO mind_ossz;
  RETURN MIND_OSSZ;
END KETTOS_FUGG;

--TODO: EZ LEHET HOGY HIBÁS ÉRTÉKEKET TESZ BE!

FUNCTION KETTOS_FUGG_UJ (c_sema VARCHAR2, c_m003 VARCHAR2,
                         c_lepes VARCHAR2 DEFAULT '0', 
						 v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)
RETURN j_kettosok AS
 mind_ossz INTEGER;
 v_str VARCHAR2(2000);
 v_tabla VARCHAR2(1000);
BEGIN

--DBMS_OUTPUT.PUT_LINE('J_SELECT_T.TASA_SELECT futás: ');
v_tabla := J_SELECT_T.TASA_SELECT(c_sema, c_lepes, v_year, v_verzio, v_teszt);
--DBMS_OUTPUT.PUT_LINE(v_tabla);

v_k := j_kettosok.getNull(v_k);
v_str:='SELECT
      NVL(PRCA103,0),
      NVL(PRCA092,0),
      NVL(PRCA091,0),
      NVL(PRJA019,0),
      NVL(PRJA200,0),
      NVL(PRCA007,0),
      NVL(PRJA045,0),
      NVL(PRJA196,0),
      NVL(PRCA008,0),
      NVL(PRCA090,0),
      NVL(PRCA022,0),
      NVL(PRCA023,0),
      NVL(PRCA093,0),
      NVL(PRDA082,0),
      NVL(PRCA020,0),
      NVL(PRCA016,0),
      NVL(PRCA017,0),
      NVL(PRJA087,0),
      NVL(PRJA088,0),
      NVL(PRCA094,0),
      NVL(PRJA013,0),
      NVL(PRDA084,0), 
      NVL(PRJA050,0),
      NVL(PRCA081,0),
      NVL(PRCA150,0),
      NVL(PRCA151,0),
      NVL(PRCA078,0),
      NVL(PRCA149,0),
      NVL(PRCA024,0),
      NVL(PRCA054,0),
      nvl(PRDA102,0),
      NVL(PRDA066,0),
      NVL(PRDA068,0),
      NVL(PRCA004,0),
      NVL(PRJA061,0),
      0,
      0
FROM '||v_tabla||'
WHERE m003='|| c_m003;
--NVL(PAJ0M065,0),<<--- a második nulla helyére!!!
--NVL(PAJ0M049,0),<<--- az első nulla helyére!!!
--dbms_output.put_line(v_str);
EXECUTE immediate v_str INTO 
v_k.c_PRCA103, 
v_k.c_PRCA092, 
v_k.c_PRCA091, 
v_k.c_PRJA019, 
v_k.c_PRJA200, 
v_k.c_PRCA007, 
v_k.c_PRJA045, 
v_k.c_PRJA196, 
v_k.c_PRCA008, 
v_k.c_PRCA090, 
v_k.c_PRCA022, 
v_k.c_PRCA023, 
v_k.c_PRCA093, 
v_k.c_PRDA082, 
v_k.c_PRCA020, 
v_k.c_PRCA016, 
v_k.c_PRCA017, 
v_k.c_PRJA087, 
v_k.c_PRJA088, 
v_k.c_PRCA094,
v_k.c_PRJA013, 
v_k.c_PRDA084, --c_PFD0M084
v_k.c_PRJA050, 
v_k.c_PRCA081, 
v_k.c_PRCA150, 
v_k.c_PRCA151, 
v_k.c_PRCA078, 
v_k.c_PRCA149, 
v_k.c_PRCA024, 
v_k.c_TAB279, 
v_k.c_PRDA102, 
v_k.c_PRDA066, 
v_k.c_PRDA068, 
v_k.c_PRCA004,
v_k.c_PRJA061,
v_k.c_PRJA065,
v_k.c_prja049
;


RETURN v_k;
EXCEPTION WHEN OTHERS THEN
  return v_k;
END KETTOS_FUGG_UJ;


FUNCTION p_1221 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
  v_func number(15);
  BEGIN
    v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA092', '', v_year, v_verzio, v_teszt);
    RETURN v_func;
END p_1221;

FUNCTION p_1222 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
BEGIN
    v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA091', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
END p_1222;


FUNCTION p_121  (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
  v_func number(15);
BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA103', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
END p_121;


FUNCTION p_1363 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
  v_func number(15);
BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA200', '', v_year, v_verzio, v_teszt)*0.9;
   RETURN v_func;
END p_1363;


FUNCTION p_1361 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
BEGIN
     v_func := J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA019', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
END p_1361;


FUNCTION p_1312 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
 v_func number(15);
BEGIN
  v_func := J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA049', '', v_year, v_verzio, v_teszt);
  --v_func:= 0;--J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PAJ0M049');
  RETURN v_func;
END p_1312;


FUNCTION p_14   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
 v_func number(15);
BEGIN
  v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA007', '', v_year, v_verzio, v_teszt);
  RETURN v_func;
END p_14;

  FUNCTION p_15   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     --v_func:= (J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045')+J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA196'))*0.2164;javíítva 2012.02.29

    --új szorzó 2013.01.31 lecserélve:0.4078;

   --ELŐZETETES
     --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045')*0.4078;

   --VÉGLEGES 2015
   v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045', '', v_year, v_verzio, v_teszt)*1.2676; 
   RETURN v_func;
  END p_15;

  FUNCTION p_16   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
    -- v_func:= (J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045')+J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA196'))*0.4297; javíítva 2012.02.29

   --új szorzó 2013.01.31 lecserélve:0.5966;

   --ELŐZETETES
   --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045')*0.5966;

   --VÉGLEGES 2015
   v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045', '', v_year, v_verzio, v_teszt)*1.0237;
   RETURN v_func;
  END p_16;

  FUNCTION p_21   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA008', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END p_21;

  FUNCTION p_22   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA090', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END p_22;

  FUNCTION p_2331 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA093', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END p_2331;

--******************************************************************************
--*************** BIZTOSITOHOZ *************************************************
 FUNCTION p_24 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA092', '', v_year, v_verzio, v_teszt)
              +J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA091', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END p_24;

--******************************************************************************
--******************************************************************************
  FUNCTION p_231  (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA022', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END p_231;

  FUNCTION p_2321 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA023', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END p_2321;

  FUNCTION p_262  (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func NUMBER(15);
  BEGIN
     v_func:=0;
     --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA017');
   RETURN v_func;
  END p_262;

FUNCTION p_27 (c_sema varchar2, c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER AS
 v_func number(15);
BEGIN
 v_func := J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema, c_m003, 'PRDA082', '', v_year, v_verzio, v_teszt);
 RETURN v_func;
END p_27;

  FUNCTION K_1    (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA020', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END K_1;

  FUNCTION b1g_kettos    (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA004', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END b1g_kettos;

  FUNCTION d_1111 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA016', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_1111;

  -- jó??
   FUNCTION d_1111_eva (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PAJ0M082', '', v_year, v_verzio, v_teszt)-J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PAJ0M083', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_1111_eva;

  FUNCTION d_11121(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA017', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_11121;

  FUNCTION d_11127(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
    -- 6511-1 Biztosítóintézetek élet:	((1608A-01-01/05c)/0,1785)*0,5*ß,
    -- új szorzó került be 2017.09.13-án
    -- régi szorzó volt: 0.1904
    -- (0.5 * béta külsőleg szorzódik hozzá)
    --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA087')/0.1904;
    v_func:= (J_KETTOS_FUGG_T.kettos_fugg(c_sema,c_m003,'PRJA087', '', v_year, v_verzio, v_teszt)
              / j_konst.d_11127_szorzo) * 0.5;
   RETURN v_func;
  END d_11127;

  FUNCTION d_1121 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     --v_func:= (J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045')+J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA196'))*1.024;javíítva 2012.02.29

     --új szorzó 2013.01.31 lecserélve:1.1168;

     --ELŐZETES
     --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045')*1.1168;

     --VÉGLEGES  2015
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA045', '', v_year, v_verzio, v_teszt)*3.3066;
   RETURN v_func;
  END d_1121;

  FUNCTION d_1123 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     -- új szorzó: 2017.09.13
     -- 6511-1 Biztosítóintézetek élet: {{(1608A-01-01/06c)/0,1785}*0,5}*ß
     -- régi szorzó volt: 0.54
     --v_func:= (J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA088') / 0.54)
     --         * 0.5;
     /*--Az 1,19-es adóalapszorzó változatlan maradt, így az új szám: 0,1785.*/
     v_func:= (J_KETTOS_FUGG_T.kettos_fugg(c_sema,c_m003,'PRJA088', '', v_year, v_verzio, v_teszt) 
               / j_konst.d_1123_szorzo) * 0.5;
   RETURN v_func;
  END d_1123;

  FUNCTION d_1212 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PAJ0M198'); MEGSZÜNT 2013.09.03
      --J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA016')*0.015;  2013.09.05
      v_func:= 0;
   RETURN v_func;

  END d_1212;

  FUNCTION d_1211 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA094', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_1211;

  FUNCTION d_29C1 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA061', '', v_year, v_verzio, v_teszt); 
     --v_func:=0;
   RETURN v_func;
  END d_29C1;

  FUNCTION d_29C2 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA013', '', v_year, v_verzio, v_teszt); --ugyanaz maradt 2017.09.13
   RETURN v_func;
  END d_29C2;

  FUNCTION d_29b1 (c_sema varchar2,c_m003 VARCHAR2,c_lepes varchar2 default '0', v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN -- új mutató: 2017.09.13
     --v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PFD0M084',c_lepes);     
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRDA084',c_lepes, v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_29b1;

  FUNCTION d_29b3 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
    v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA050', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_29b3;

  FUNCTION d_29E3 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PFD0M603', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_29E3;

  FUNCTION d_39253(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     --v_func:= 0;--J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PAJ0M065');
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRJA065', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_39253;

  FUNCTION d_41211(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA081', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_41211;

  FUNCTION d_41212(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA150', '', v_year, v_verzio, v_teszt)
              +J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA151', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_41212;

  FUNCTION d_41221(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA078', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_41221;

  FUNCTION d_41222(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA149', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_41222;

  FUNCTION d_45   (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRCA024', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_45;

  FUNCTION d_51B11(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER AS
   v_func NUMBER(15);
  BEGIN
   v_func := J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema, c_m003, 'PRCA054', '', v_year, v_verzio, v_teszt); --TAB279?
   RETURN v_func;
  END d_51B11;

  FUNCTION d_51B12(c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRDA102', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_51B12;

  FUNCTION d_7511 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRDA066', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_7511;

  FUNCTION d_7522 (c_sema varchar2,c_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2)  RETURN NUMBER AS
   v_func number(15);
  BEGIN
     v_func:= J_KETTOS_FUGG_T.KETTOS_FUGG(c_sema,c_m003,'PRDA068', '', v_year, v_verzio, v_teszt);
   RETURN v_func;
  END d_7522;



end J_KETTOS_FUGG_T;