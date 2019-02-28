/*
create or replace PACKAGE "J_SZEKT_EVES_T" AS 

--string segédfüggvények (select-ekhez)--
FUNCTION STR_AND (v_str VARCHAR2) RETURN VARCHAR2; -- STRING ÖSSZEFŰZÉS
FUNCTION str_or (v_str VARCHAR2) RETURN VARCHAR2; -- STRING ÖSSZEFŰZÉS
--pic lekérdezés--
FUNCTION fugg(c_sema VARCHAR2, c_m003 VARCHAR2, pic_kod VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) RETURN NUMBER;                
--kettős lekérdezés--
FUNCTION kettosok(c_sema VARCHAR2, c_m003 VARCHAR2, tabla_id NUMBER, pic_kod VARCHAR2) RETURN NUMBER; -- KETTOSOK
--feltöltő eljárások--
PROCEDURE FELTOLT_TABLABA(c_sema VARCHAR2, c_teaor VARCHAR2, v_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2); -- ADAT FELTÖLTÉS TÁBLÁBA
PROCEDURE FELTOLT_TABLABA_KETTOS(c_sema VARCHAR2, c_teaor VARCHAR2, v_m003 VARCHAR2); -- ADAT FELTÖLTÉS TÁBLÁBA
PROCEDURE FELTOLT(v_mutato_nev VARCHAR2, v_ertek NUMBER); -- ADAT FELTÖLTÉS TÖMBBE KIIRATÁSHOZ
PROCEDURE FELTOLT_SBS(v_mutato_nev VARCHAR2, v_ertek NUMBER); -- Adat feltöltés SBS (?)
PROCEDURE FELTOLT_BIZT(v_mutato_nev VARCHAR2, v_ertek NUMBER); -- Adat feltöltés Biztosító (?)
PROCEDURE feltolt_nyp(v_mutato_nev VARCHAR2, v_ertek NUMBER); -- Adat feltöltés Nyugdíjpénztár (?)
--teszt kiíratás--
PROCEDURE kiir; -- Kiíratás

FUNCTION SPLIT
(   p_list varchar2,
    p_del VARCHAR2 := ','
) return split_tbl pipelined;

function split2(
  list in varchar2,
  delimiter IN VARCHAR2 DEFAULT ','
) return split_tbl;

end;

*/

create or replace PACKAGE BODY  "J_SZEKT_EVES_T" as


v1 out_type := out_type();
v_1 out_var := out_var();
v_2 out_var := out_var();
v_arr1 out_var := out_var();
v_arr2 out_var := out_var();
i NUMBER := 1;
c_db NUMBER := J_SELECT_T.mutato_db_szam;
c_db_SBS NUMBER := J_SELECT_T.mutato_db_szam_SBS;
c_db_BIZT NUMBER := J_SELECT_T.mutato_db_szam_BIZT;
c_db_NYP NUMBER := J_SELECT_T.MUTATO_DB_SZAM_NYP;

v_w_w_elo_veg VARCHAR2(50) := '_W_W_ELOZETES'; -- PP17_W_W_ELOZETES_V02
v_w_w_hitsbs VARCHAR2(50) := '_W_W_HITSBS'; -- PP17_W_W_HITSBS
v_w_w_biztsbs VARCHAR2(50) := '_W_W_BIZTSBS'; -- PP17_W_W_BIZTSBS
v_w_w_nypsbs VARCHAR2(50) := '_W_W_NYPSBS'; -- PP17_W_W_NYPSBS
--v_w_w_elo_veg VARCHAR2(50) := 'PP17_W_W_ELOZETES_MARK';


--*********************************************--
---------------STRING ÖSSZEFŰZÉS-----------------
--*********************************************--
-- ők nem
FUNCTION STR_AND (v_str VARCHAR2) RETURN VARCHAR2 AS
v_str_sql VARCHAR2(4000);
temp_str VARCHAR2(4000);
BEGIN
  v_str_sql :=' m003 <>';
  temp_str:=v_str;
  temp_str:= temp_str||',';
    WHILE LENGTH(temp_str)>0 LOOP
      v_str_sql := v_str_sql||substr(temp_str,1,instr(temp_str,',')-1)
                   || ' and m003<>';
      temp_str := substr(temp_str,instr(temp_str,',')+1);
    END LOOP;
  v_str_sql := substr(v_str_sql,1,length(v_str_sql)-10);
RETURN v_str_sql;
END STR_AND;

--*********************************************--
---------------STRING ÖSSZEFŰZÉS-----------------
--*********************************************--
-- ők igen
FUNCTION STR_OR (v_str VARCHAR2) RETURN VARCHAR2 AS
 v_str_sql VARCHAR2(4000);
 temp_str VARCHAR2(4000);
BEGIN
v_str_sql := ' m003 =';
temp_str := v_str;
temp_str := temp_str||',';
WHILE LENGTH(temp_str) > 0
LOOP
  v_str_sql := v_str_sql||SUBSTR(temp_str,1,instr(temp_str,',')-1)
               || ' or m003 =';
  temp_str := SUBSTR(temp_str,instr(temp_str,',')+1);
END LOOP;
v_str_sql := SUBSTR(v_str_sql,1,LENGTH(v_str_sql)-10);
RETURN v_str_sql;
END STR_OR;


FUNCTION FUGG(c_sema VARCHAR2, c_m003 VARCHAR2, pic_kod VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2) 
RETURN NUMBER AS
  mind_ossz NUMBER(20,3);
  v_str VARCHAR2(4000);
  v_tabla VARCHAR2(400);
BEGIN
--dbms_output.put_line(C_SEMA); 
-------------------------------------------------
------- Tábla választás(PSZÁF)-------------------
v_tabla := J_SELECT_T.pszaf_select(c_sema, '', v_year, v_verzio, v_teszt); 
--dbms_output.put_line(V_TABLA); 
v_str := 'SELECT (NVL('|| pic_kod||',0)) FROM '||v_tabla
         ||' WHERE m003=''' || c_m003 || '''';
/*         ||' WHERE m003=' || c_m003; */
--dbms_output.put_line(V_STR);

EXECUTE IMMEDIATE v_str into mind_ossz;
RETURN MIND_OSSZ;

END FUGG;


--*********************************************--  
--------------KETTOSOK--------------------------
--*********************************************--
FUNCTION KETTOSOK(  c_sema varchar2,
          c_m003 VARCHAR2,
          tabla_id NUMBER, 
          pic_kod VARCHAR2)
RETURN number AS
mind_ossz number(20,3);
v_str VARCHAR2(4000);
v_tabla varchar2(400);

BEGIN

v_tabla := j_select.tasa_select(c_sema);  

v_str := 'select (NVL('|| pic_kod||',0)) from '||v_tabla
         ||' where m003='|| c_m003 ;
execute IMMEDIATE v_str into mind_ossz;
RETURN MIND_OSSZ;
END KETTOSOK;


--*********************************************--
----------ADAT FELTÖLTÉS TÖMBBE KIIRATÁSHOZ---- 
--*********************************************--
PROCEDURE FELTOLT (v_mutato_nev VARCHAR2, v_ertek NUMBER) AS
  v_str VARCHAR2(400);
  c_i NUMBER(5,0);
  c_space VARCHAR2(20) := '                ';
 BEGIN 
  v1.extend(c_db);
  v_str := 'SELECT SEMA_ID FROM A_SEMA_VALTOZOK WHERE sema_nev='
           ||''''||v_mutato_nev||'''';
  EXECUTE IMMEDIATE v_str INTO c_i;
  COMMIT;
  v1(c_i) := v_ertek;
  --DBMS_OUTPUT.PUT_LINE('J_SZEKT_EVES_T.FELTOLT lefutott!');
END FELTOLT;

-- Adat feltöltés SBS (?)
PROCEDURE FELTOLT_SBS (v_mutato_nev varchar2, v_ertek number) AS
  v_str varchar2(400);
  c_i_SBS number(5,0);
BEGIN
  v1.extend(c_db_SBS);
  v_str := 'select SEMA_ID from A_SEMA_VALTOZOK_SBS WHERE sema_nev='
           ||''''||v_mutato_nev||'''';
  execute IMMEDIATE v_str into c_i_SBS;
  commit;
  v1(c_i_sbs):= v_ertek; 
END FELTOLT_SBS;


-- Adat feltöltés Nyugdíjpénztár (?)
PROCEDURE FELTOLT_NYP (v_mutato_nev varchar2, v_ertek number) AS
  v_str varchar2(400);
  c_i_SBS number(5,0);
BEGIN
  v1.extend(c_db_NYP);
  v_str :='select SEMA_ID from A_SEMA_VALTOZOK_SBS WHERE sema_nev='||''''
           ||v_mutato_nev||'''';
  execute IMMEDIATE v_str into c_i_SBS;
  commit;
  v1(c_i_sbs):= v_ertek; 
END FELTOLT_NYP;


PROCEDURE FELTOLT_BIZT (v_mutato_nev varchar2, 
                  v_ertek number) 
AS
  v_str varchar2(400);
  c_i_BIZT number(5,0);
BEGIN
v1.extend(c_db_SBS);
v_str :='select SEMA_ID from A_SEMA_VALTOZOK_SBS WHERE sema_nev='||''''
        ||v_mutato_nev||'''';
execute IMMEDIATE v_str into c_i_BIZT;
commit;
v1(c_i_BIZT):= v_ertek; 
END FELTOLT_BIZT;


--*********************************************--
----------ADAT FELTÖLTÉS TÖMBBE KIIRATÁSHOZ (?)--
--*********************************************--
PROCEDURE FELTOLT_T (v_arr1 out_var, v_arr2 out_var) AS
   c_id  number(3,0);
   c_name  varchar(15);
   v_id    out_var:=out_var();
   v_1   out_var:=out_var();

   CURSOR c1 IS 
      SELECT sema_id, sema_nev
      FROM A_sema_valtozok
      where valid_m is null;
BEGIN
v_1.extend(c_db);
v_2.extend(c_db);
v_id.extend(C_DB);

  OPEN c1 ;
   LOOP
      FETCH c1 INTO c_id, c_name;
      EXIT WHEN  c1%NOTFOUND;
         v_id(c_id):=c_name;
   END LOOP;
 CLOSE c1;

 for i in 1..c_db loop
     for j in 1..c_db loop
        if v_arr1(i)=v_id(j) then
          v_1(j):= v_arr2(i);
          --dbms_output.put_line(v_arr1(i) || ' - ' || v_1(j));
        end if; 
      end loop;
 end loop;

v_2:=v_1;
END FELTOLT_T;


--*********************************************--
----------ADAT FELTÖLTÉS TÁBLÁBA---------------- 
--*********************************************--
PROCEDURE FELTOLT_TABLABA(c_sema VARCHAR2, c_teaor VARCHAR2, v_m003 VARCHAR2, v_year VARCHAR2, v_verzio VARCHAR2, v_teszt VARCHAR2, v_betoltes VARCHAR2) AS
 v_str_1 VARCHAR2(4000);
 v_tabla VARCHAR2(300);
 i NUMBER;
 db NUMBER := 0;
BEGIN

--dbms_output.put_line('J_SZEKT_EVES.FELTOLT_TABLABA START');

CASE
WHEN (0 < c_sema AND c_sema < 20) OR (50 <= c_sema AND c_sema <= 53) THEN 
     --1..19, 50..53
     --v_tabla:=' PP15_W_W_VEGLEGES_V01 ';
    --v_tabla:=  ' ' || v_w_w_elo_veg;
	v_tabla := 'PP'|| v_year ||''|| v_w_w_elo_veg ||''|| v_verzio ||''|| v_teszt ||' ';
WHEN 21 <= c_sema AND c_sema <= 23 THEN --21..23
    c_db := c_db_sbs;
    v_tabla := ' ' || v_w_w_hitsbs;
WHEN 31 <= c_sema AND c_sema <= 35 THEN --31..34
    c_db := c_db_bizt;
    v_tabla := ' ' || v_w_w_biztsbs;
WHEN 36 <= c_sema AND c_sema <= 38 THEN --36..38
    c_db := c_db_nyp;
    v_tabla := ' ' || v_w_w_nypsbs;
END CASE;

V1.EXTEND(c_db);
V_2.EXTEND(c_db);  
v_str_1 := '(20'|| v_year ||',' || v_m003 || ',' || c_teaor || ',' || c_sema;

FOR i IN 1..c_db LOOP
  v_str_1 := v_str_1 || ',' || v1(i);
END LOOP;

FOR I IN 1..3 LOOP
 v_str_1 := REPLACE(v_str_1, ',,', ',0,');
END LOOP;

v_str_1 := REPLACE(v_str_1, ',)',', 0)');

v_str_1 := 'INSERT INTO PP'|| v_year ||'.'||v_tabla||' values '||v_str_1||')';
v_Str_1 := REPLACE(v_str_1,',)',',0)');

--dbms_output.put_line(v_Str_1);

-- végrehajtás
EXECUTE IMMEDIATE v_str_1;
COMMIT;
--dbms_output.put_line('J_SZEKT_EVES.FELTOLT_TABLABA END');

END FELTOLT_TABLABA;


--*********************************************--
----------ADAT FELTÖLTÉS TÁBLÁBA----------------- 
--*********************************************--
PROCEDURE FELTOLT_TABLABA_KETTOS(c_sema VARCHAR2, c_teaor VARCHAR2,
                          v_m003 VARCHAR2) AS
 v_str_1 VARCHAR2(4000);
 i NUMBER;
BEGIN
v_2.extend(c_db);
v_str_1 := '(2017,'||v_m003||','||c_teaor||','||c_sema;

FOR i IN 1..c_db LOOP
 v_str_1 := v_str_1||','||v_2(i);
END LOOP;

FOR i IN 1..3 LOOP
 v_str_1 := REPLACE(v_str_1,',,',',0,');
END LOOP;

v_str_1 := REPLACE(v_str_1,',)',',0)');
v_str_1 := 'INSERT INTO '|| v_w_w_elo_veg ||' VALUES'||v_str_1||')';
v_Str_1 := REPLACE(v_str_1,',)',',0)');

--dbms_output.put_line(v_str_1);
EXECUTE immediate v_str_1;
COMMIT;

END FELTOLT_TABLABA_KETTOS;

-- Kiíratás
PROCEDURE KIIR AS
 i NUMBER;
BEGIN
FOR i IN 1..c_db_sbs LOOP
  dbms_output.put_line(v1(i));
END LOOP;
END kiir;



/* from :http://www.builderau.com.au/architect/database/soa/Create-functions-to-join-and-split-strings-in-Oracle/0,339024547,339129882,00.htm

select split('foo,bar,zoo') from dual;
select * from table(split('foo,bar,zoo'));

pipelined function is SQL only (no PL/SQL !)
*/
function split
(
    p_list varchar2,
    p_del varchar2 := ','
) return split_tbl pipelined is
    l_idx    pls_integer;
    l_list    varchar2(32767) := p_list;
    l_value    varchar2(32767);
begin
    loop
        l_idx := instr(l_list,p_del);
        if l_idx > 0 then
            pipe row(substr(l_list,1,l_idx-1));
            l_list := substr(l_list,l_idx+length(p_del));

        else
            pipe row(l_list);
            exit;
        end if;
    end loop;
    return;
  end split;

function split2(
  list in varchar2, 
  delimiter in varchar2 default ','
) return split_tbl as
  splitted split_tbl := split_tbl(); --array-t csinál
  
  i pls_integer := 0;
  list_ varchar2(32767) := list;
begin
  loop
    i := instr(list_, delimiter); --The Oracle/PLSQL INSTR function returns the location of a substring in a string
    if i > 0 then -- ha a listában több érték is van, akkor
      splitted.extend(1); -- 1 új eleme lesz az array-nek
      splitted(splitted.last) := substr(list_, 1, i - 1); 
      list_ := substr(list_, i + length(delimiter));
    else -- ha a listában csak 1 érték van (a visszadott érték 0), akkor
      splitted.extend(1); -- 1 új eleme lesz az array-nek
      splitted(splitted.last) := list_; -- beleteszi a lista elemét
      return splitted;
    end if;
  END LOOP;
  END split2;


end;