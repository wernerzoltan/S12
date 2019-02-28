/*
create or replace PACKAGE "J_KORR_T" as 

FUNCTION KORR_FUGG (v_year VARCHAR2, c_sema VARCHAR2, c_m003 VARCHAR2, sema_valtozo VARCHAR2, v_betoltes VARCHAR2) RETURN PAIR;
-- 1529-01-01/15c

end J_KORR_T;
*/

create or replace PACKAGE BODY "J_KORR_T" as

-- 1529-01-01/15c
-- PP17_korrekciok_e01 -> v01

FUNCTION KORR_FUGG (v_year VARCHAR2, c_sema VARCHAR2, c_m003 VARCHAR2, sema_valtozo VARCHAR2, v_betoltes VARCHAR2) 
RETURN PAIR AS --number volt
 v_str VARCHAR2(1000);
 v_str2 VARCHAR2(1000);
 v_str3 VARCHAR2(1000);
 c_numb NUMBER(15,2);
 c_temp VARCHAR2(10); 
 p PAIR;
v_table VARCHAR2(50);
v_table_version VARCHAR2(10);
 
BEGIN

v_table := '_korrekciok_';

IF ''|| v_betoltes ||'' = 'elozetes' THEN 
	v_table_version := 'E01';
ELSE v_table_version := 'V01';
END IF;

p := PAIR.INIT;
c_temp := c_sema;

IF c_m003 = '10803828' OR c_m003 = '19670780' THEN
 c_temp := 18;
END IF;

v_str := 'SELECT NVL('||sema_valtozo||',0) FROM PP'|| v_year ||''|| v_table ||''|| v_table_version ||' '
         ||'WHERE m003='||c_m003||' AND sema_tipus='||c_temp;
v_str2 := 'SELECT NVL('||sema_valtozo||'_token,0) FROM PP'|| v_year ||''|| v_table ||''|| v_table_version ||' '
          ||'WHERE m003='||c_m003||' AND sema_tipus='||c_temp;

-- VIGYÁZZ! E01 és V01 van korrekciós táblánál!

/*
if c_m003='10803828' or c_m003='19670780' then 
    c_temp :=18;
    v_str := 'Select nvl('||sema_valtozo||',0) '
             ||'from pp13_korrekciok_v01 where m003='||c_m003||' and sema_tipus='
             ||c_temp;
    v_str2 := 'Select nvl('||sema_valtozo||'_token,0) '
              ||'from pp13_korrekciok_v01 where m003='||c_m003
              ||' and sema_tipus='||c_temp;
   else
    v_str := 'Select nvl('||sema_valtozo||',0) from pp13_korrekciok_v01 '
              ||'where m003='||c_m003||' and sema_tipus='||c_sema;
    v_str2 := 'Select nvl('||sema_valtozo||'_token,0) from pp13_korrekciok_v01 '
             ||'where m003='||c_m003||' and sema_tipus='||c_sema;
end if;*/

v_str3 := 'SELECT COUNT(m003) FROM PP'|| v_year ||''|| v_table ||''|| v_table_version ||' '
         ||'WHERE m003 = '''||c_m003||''' AND sema_tipus = '''||c_temp||''' ';

EXECUTE immediate v_str3 INTO c_numb;

IF c_numb <> 0 THEN
 EXECUTE immediate v_str INTO p.v;
 EXECUTE immediate v_str2 INTO p.f;
ELSE
  p.v := 0;
  p.f := 0;
END IF;

--DBMS_OUTPUT.PUT_LINE(p.v || ' ' || p.f);
--DBMS_OUTPUT.PUT_LINE('J_KORR_T.KORR_FUGG lefutott!');
RETURN p;
END KORR_FUGG;

end J_KORR_T;