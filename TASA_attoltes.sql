/*
select * from user_role_privs;
select * from role_tab_privs where owner = 'PP17';
grant PP_UPDATE TO BUD07128;
grant execute on PP17.a01_TASA_ATTOLTES TO PP_UPDATE;

select 'grant select on '||table_name||' to PP_SELECT;'
from user_tables 

select 'grant select on '||view_name||' to PP_SELECT;'
from user_views 

grant PP_SELECT TO BUD07128;

*/


-- TÁSA adatok áttöltése PR sémából

/*
create or replace PACKAGE a01_TASA_ATTOLTES AUTHID CURRENT_USER AS 
procedure tasa_attoltes;

END a01_TASA_ATTOLTES;
-------
*/

create or replace PACKAGE BODY a01_TASA_ATTOLTES AS 

z NUMERIC;
sql_statement VARCHAR2(300);
TYPE t_teaor IS TABLE OF VARCHAR2(20);
v_teaor t_teaor;

-- futtatandó táblák
v_1701 BOOLEAN := FALSE; -- 1701-es tábla import
v_scv_tasa BOOLEAN := FALSE; -- SCV_TÁSA import (output: PP17_scv_tasa_v01 tábla)
v_scv_upd_1701 BOOLEAN := FALSE; -- SCV_TÁSA update 1701 adatokkal (output: PP17_scv_tasa_v01 tábla)
v_scv_upd_1708 BOOLEAN := FALSE; -- SCV_TÁSA update 1708 adatokkal (output: PP17_scv_tasa_v01 tábla)
v_1708 BOOLEAN := FALSE; -- 1708-as tábla import
v_1711 BOOLEAN := FALSE; -- 1711-es tábla import---
v_1729 BOOLEAN := FALSE; -- 1729-es tábla import (output: PP17_W_TASA_1729_V01 tábla)
v_1729_upd_ifrs BOOLEAN := FALSE; -- 1729-es tábla SCV update (output: PP17_W_TASA_1729_V01 tábla)
v_1729_scv BOOLEAN := FALSE; -- 1729 SCV tábla SCV import (output: PP17_W_TASA_1729_SCV_V01 tábla)
v_scv_upd_scv BOOLEAN := FALSE; -- SCV_TÁSA update 1729 SCV tábla adatokkal (output: PP17_scv_tasa_v01 tábla)
v_1743 BOOLEAN := FALSE; -- 1743-as tábla import
v_1771 BOOLEAN := TRUE; -- 1771-es tábla import

-- input-output beállítások
evszam VARCHAR2(10) := '2017'; -- futtatandó évszám
v_year VARCHAR2(2) := SUBSTR(evszam, 3);

v_out_schema VARCHAR2(10) := 'PP17'; -- output séma
v_in_schema VARCHAR2(10) := 'PR17'; -- TÁSA input séma ÉLES

v_betoltes VARCHAR2(10) := 'vegleges'; -- előzetes / végleges
v_out VARCHAR2(5); -- out tábla elnevezése
v_in VARCHAR2(3); -- TÁSA input tábla elnevezése
v_ceglista_t VARCHAR2(20);
v_ceglista_scv VARCHAR2(40);

--1701-es tábla:
v_in_tasa_1701_t1 VARCHAR2(20) := '_P'; -- 1701 TÁSA input tábla: W_E_P1701_V01
v_in_tasa_1701_t2 VARCHAR2(20) := '01_V01'; -- 1701 TÁSA input tábla: W_E_P1701_V01
v_tasa_1701_t1 VARCHAR2(20) := '_W_TASA_'; -- adókötelezettségekről az államháztartással szemben: PP17_W_TASA_1701_V01
v_tasa_1701_t2 VARCHAR2(20) := '01_'; -- adókötelezettségekről az államháztartással szemben: PP17_W_TASA_1701_V01

--SCV_TÁSA adatok:
v_in_scv_tasa_t1 VARCHAR2(20) := '_P'; -- SCV_TÁSA / 1708 input tábla:  W_V_P1708_V01
v_in_scv_tasa_t2 VARCHAR2(20) := '08_V01'; -- SCV_TÁSA / 1708 input tábla:  W_V_P1708_V01
v_scv_tasa_t VARCHAR2(20) := '_scv_tasa_'; -- SCV_TÁSA output tábla: PP17_scv_tasa_v01

--1708-as tábla:
v_scv_1708_t1 VARCHAR2(20) := '_W_TASA_'; -- 1708 output tábla: PP17_W_TASA_1708_v01
v_scv_1708_t2 VARCHAR2(20) := '08_'; -- 1708 output tábla: PP17_W_TASA_1708_v01

--1711-es tábla:
v_in_tasa_1711_t1 VARCHAR2(20) := '_P'; -- 1711 TÁSA input tábla: W_E_p1711t_v01
v_in_tasa_1711_t2 VARCHAR2(20) := '11T_V01'; -- 1711 TÁSA input tábla: W_E_p1711t_v01
v_tasa_1711_t1 VARCHAR2(20) := '_W_TASA_'; -- 1711 output tábla: PP17_W_TASA_1711_V01
v_tasa_1711_t2 VARCHAR2(20) := '11_'; -- 1711 output tábla: PP17_W_TASA_1711_V01

--1729-es tábla:
v_in_tasa_1729_t1 VARCHAR2(20) := '_P'; -- 1729 TÁSA input tábla: W_E_P1729_V01
v_in_tasa_1729_t2 VARCHAR2(20) := '29_V01'; -- 1729 TÁSA input tábla: W_E_P1729_V01
v_tasa_1729_t1 VARCHAR2(20) := '_W_TASA_'; -- 1729 output tábla: PP17_W_TASA_1729_V01
v_tasa_1729_t2 VARCHAR2(20) := '29_'; -- 1729 output tábla: PP17_W_TASA_1729_V01
v_in_tasa_1729_ifrs_t1 VARCHAR2(40) :=  'w_e_ah'; -- 1729 TÁSA IFRS input tábla: w_e_ah1729_ifrs_17_v01
v_in_tasa_1729_ifrs_t2 VARCHAR2(40) :=  '29_ifrs_'; -- 1729 TÁSA IFRS input tábla: w_e_ah1729_ifrs_17_v01
v_in_tasa_1729_ifrs_t3 VARCHAR2(40) :=  '_V01'; -- 1729 TÁSA IFRS input tábla: w_e_ah1729_ifrs_17_v01

v_tasa_1729_scv_t1 VARCHAR2(20) := '_W_TASA_'; -- 1729 output tábla: PP17_W_TASA_1729_SCV_V01
v_tasa_1729_scv_t2 VARCHAR2(20) := '29_SCV_'; -- 1729 output tábla: PP17_W_TASA_1729_SCV_V01

--1743-as tábla:
v_in_tasa_1743_t1 VARCHAR2(20) := '_P'; -- 1743 TÁSA input tábla: W_E_p1743_v01
v_in_tasa_1743_t2 VARCHAR2(20) := '43_V01'; -- 1743 TÁSA input tábla: W_E_p1743_v01
v_tasa_1743_t1 VARCHAR2(20) := '_W_TASA_'; -- 1743 output tábla: PP17_W_TASA_1743_V01
v_tasa_1743_t2 VARCHAR2(20) := '43_'; -- 1743 output tábla: PP17_W_TASA_1743_V01

--1771-es tábla:
v_in_tasa_1771_t1 VARCHAR2(20) := '_P'; -- 1771 TÁSA input tábla: W_E_P1771EVA_V01
v_in_tasa_1771_t2 VARCHAR2(20) := '71EVA_V01'; -- 1771 TÁSA input tábla: W_E_P1771EVA_V01
v_tasa_1771_t1 VARCHAR2(20) := '_W_TASA_'; -- 1771 output tábla: PP17_W_TASA_1771_V01
v_tasa_1771_t2 VARCHAR2(20) := '71_'; -- 1771 output tábla: PP17_W_TASA_1771_V01


procedure tasa_attoltes AS

BEGIN

IF ''|| v_betoltes ||'' = 'elozetes' THEN	
	--v_out := 'v01'; -- ÉLES
	v_out := 'v01_t'; -- TESZT
	v_in := 'W_E';
	v_ceglista_t := 'CEGLISTA_ELOZETES';
	v_ceglista_scv := 'CEGLISTA_SCV_ELOZETES';
	
ELSE 
	--v_out := 'v02'; -- ÉLES
	v_out := 'v02_t'; -- TESZT
	v_in := 'W_V';
	v_ceglista_t := 'CEGLISTA';
	v_ceglista_scv := 'CEGLISTA_SCV';
	
END IF;

-- első körben szükséges a CEGLISTA és az SCV lista közötti eltéréseket megszüntetni:
EXECUTE IMMEDIATE'
DELETE FROM '|| v_out_schema ||'.'|| v_ceglista_t ||'
WHERE M003 IN (
SELECT M003 FROM 
(select a.M003 as M003, b.M003 as M003_scv from '|| v_out_schema ||'.'|| v_ceglista_t ||' a INNER JOIN '|| v_out_schema ||'.'|| v_ceglista_scv ||' b
on a.m003 = b.m003) )
'
;


IF v_1701 = TRUE THEN

-- 1701-es tábla import
SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_tasa_1701_t1 ||''|| v_year ||''|| v_tasa_1701_t2 ||''|| v_out ||'' ';
	
	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1701_t1 ||''|| v_year ||''|| v_tasa_1701_t2 ||''|| v_out ||'
		("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"PRJA013" NUMBER(15,0), 
		"PRJA019" NUMBER(15,0), 
		"PRJA050" NUMBER(15,0), 
		"PRJA061" NUMBER(15,0), 
		"PRJA200" NUMBER(15,0), 
		"PRJA213" NUMBER(15,0), 
		"PRJA258" NUMBER, 
		"PRJA259" NUMBER, 
		"PRJA260" NUMBER, 
		"PRJA261" NUMBER)
		'
		;
		
		END IF;
		*/

		
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1701_t1 ||''|| v_year ||''|| v_tasa_1701_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1701_t1 ||''|| v_year ||''|| v_tasa_1701_t2 ||''|| v_out ||'
		(m003, m0581, prja013, prja050, prja213, prja258, prja260, prja261) 
		SELECT 
		cc.m003, cc.m0581, tt.PRJA013, tt.PRJA050, tt.PRJA213, tt.prja258, tt.prja260, tt.prja261
		from '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		left join '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt on tt.M003=cc.M003
		WHERE tt.m003 IS NOT NULL
		AND (m0581 LIKE ''64%'' OR m0581 LIKE ''65%'' OR m0581 LIKE ''66%'')
		'
		;
		
	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1701_t1 ||''|| v_year ||''|| v_tasa_1701_t2 ||''|| v_out ||' tábla nem üres!');
	
	END IF;

END IF;

-- SCV_TÁSA adatok

IF v_scv_tasa = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||'' ';
	
	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||'|| v_out ||'
		 (	"MEV" VARCHAR2(20 BYTE), 
			"M003" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
			"M0581" VARCHAR2(4 BYTE), 
			"M005" VARCHAR2(4 BYTE), 
			"M045" VARCHAR2(4 BYTE), 
			"PRDA102" NUMBER(15,0), 
			"PRCA008" NUMBER(15,0), 
			"PRCA090" NUMBER(15,0), 
			"PRCA022" NUMBER(15,0), 
			"PRCA023" NUMBER(15,0), 
			"PRCA093" NUMBER(15,0), 
			"PRCA016" NUMBER(15,0), 
			"PRCA017" NUMBER(15,0), 
			"PRJA087" NUMBER(15,0), 
			"PRJA088" NUMBER(15,0), 
			"PRCA094" NUMBER(15,0), 
			"PRCA081" NUMBER(15,0), 
			"PRCA150" NUMBER(15,0), 
			"PRCA151" NUMBER(15,0), 
			"PRCA078" NUMBER(15,0), 
			"PRCA149" NUMBER(15,0), 
			"PRCA054" NUMBER(15,0), 
			"PRCA024" NUMBER(15,0), 
			"PRDA066" NUMBER(15,0), 
			"PRDA068" NUMBER(15,0), 
			"PRJA013" NUMBER(15,0), 
			"PRJA019" NUMBER(15,0), 
			"PRJA045" NUMBER(15,0), 
			"PRJA049" NUMBER(15,0), 
			"PRJA050" NUMBER(15,0), 
			"PRJA061" NUMBER(15,0), 
			"PRJA065" NUMBER(15,0), 
			"PRJA196" NUMBER(15,0), 
			"PRJA200" NUMBER(15,0), 
			"PRCA004" NUMBER(15,0), 
			"PRCA007" NUMBER(15,0), 
			"PRCA020" NUMBER(15,0), 
			"PRCA091" NUMBER(15,0), 
			"PRCA092" NUMBER(15,0), 
			"PRCA103" NUMBER(15,0), 
			"PRDA082" NUMBER(15,0), 
			"PRDA084" NUMBER(15,0), 
			"SEMA_TIPUS" VARCHAR2(4 BYTE), 
			"TAB279" NUMBER(15,0), 
			"PRJA213" NUMBER, 
			"PRJA258" NUMBER, 
			"PRJA259" NUMBER, 
			"PRJA260" NUMBER, 
			"PRJA261" NUMBER, 
			"PRCA172" NUMBER(15,0), 
			"PRCA167" NUMBER(15,0)
		   ) 
			'
			;
		
		END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||'
		(mev, M003, M0581)
		SELECT DISTINCT '''|| evszam ||''', m003, m0581
		FROM '|| v_out_schema ||'.'|| v_ceglista_scv ||' 
		WHERE m003 in 
		(SELECT cc.M003
		FROM '|| v_out_schema ||'.'|| v_ceglista_scv ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		ON tt.m003 = cc.m003
		WHERE tt.m003 IS NOT NULL
		-- AND cc.m003 IN (23292637, 23997349)
		
		UNION
		
		SELECT cc.M003
		FROM '|| v_out_schema ||'.'|| v_ceglista_scv ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003 = cc.m003
		WHERE NOT tt.m003 IS NULL )
		-- AND cc.m003 IN (23292637,23997349) 
		'
		;

	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' tábla nem üres!');
	
	END IF;
		
END IF;	


-- SCV_TÁSA UPDATE 1701 adatokkal

IF v_scv_upd_1701 = TRUE THEN

	sql_statement := 'SELECT m003 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_teaor;

	FOR a IN v_teaor.FIRST..v_teaor.LAST LOOP
	
		EXECUTE IMMEDIATE'
		UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||'
		SET prja013 = (SELECT tt.PRJA013 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),
		PRJA050 = (SELECT tt.PRJA050 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),
		prja213 = (SELECT tt.prja213 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),
		prja258 = (SELECT tt.prja258 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),
		-- prja259 = (SELECT tt.prja259 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		-- LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		-- ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),
		prja260 = (SELECT tt.prja260 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1701_t1 ||''|| v_year ||''|| v_in_tasa_1701_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||''')
		
		WHERE m003 = '''|| v_teaor(a) ||'''
		'
		;
	
	END LOOP;
	
END IF;

-- SCV_TÁSA UPDATE 1708 adatokkal
IF v_scv_upd_1708 = TRUE THEN

	sql_statement := 'SELECT m003 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_teaor;

	FOR a IN v_teaor.FIRST..v_teaor.LAST LOOP

		EXECUTE IMMEDIATE'
		UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||'
		SET PRJA045 = (SELECT tt.PRJA045 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),
		PRJA061 = (SELECT tt.PRJA061 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),	
		PRJA087 = (SELECT tt.PRJA087 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),	
		PRJA088 = (SELECT tt.PRJA088 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||'''),	
		PRJA196 = (SELECT tt.PRJA196 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003 = T.m003 WHERE t.m003 = '''|| v_teaor(a) ||''')
		WHERE m003 = '''|| v_teaor(a) ||'''
		'
		; 
		
	END LOOP;

END IF;


--1708-as tábla:
IF v_1708 = TRUE THEN
	
SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_scv_1708_t1 ||''|| v_year ||''|| v_scv_1708_t2 ||''|| v_out ||'' ';
	
	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_1708_t1 ||''|| v_year ||''|| v_scv_1708_t2 ||''|| v_out ||'
		("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"PRJA045" NUMBER(15,0), 
		"PRJA061" NUMBER(15,0), 
		"PRJA084" NUMBER(15,0), 
		"PRJA085" NUMBER(15,0), 
		"PRJA087" NUMBER(15,0), 
		"PRJA088" NUMBER(15,0), 
		"PRJA131" NUMBER(15,0), 
		"PRJA196" NUMBER(15,0), 
		"PRJA224" NUMBER(15,0), 
		"PRJA225" NUMBER(15,0), 
		"PRJA312" NUMBER(15,0), 
		"PRJA262" NUMBER(15,0), 
		"PRJA263" NUMBER(15,0), 
		"PRJA264" NUMBER(15,0), 
		"PRJA229" NUMBER(15,0), 
		"PRJA230" NUMBER(15,0), 
		"PRJA231" NUMBER(15,0), 
		"PRJA232" NUMBER(15,0), 
		"PRJA265" NUMBER(15,0), 
		"PRJA266" NUMBER(15,0), 
		"PRJA267" NUMBER(15,0), 
		"PRJA235" NUMBER(15,0), 
		"PRJA268" NUMBER(15,0), 
		"PRJA269" NUMBER(15,0), 
		"PRJA236" NUMBER(15,0), 
		"PRJA237" NUMBER(15,0), 
		"PRJA238" NUMBER(15,0), 
		"PRJA239" NUMBER(15,0), 
		"PRJA240" NUMBER(15,0), 
		"PRJA241" NUMBER(15,0), 
		"PRJA242" NUMBER(15,0), 
		"PRJA244" NUMBER(15,0), 
		"PRJA245" NUMBER(15,0), 
		"PRJA246" NUMBER(15,0), 
		"PRJA247" NUMBER(15,0), 
		"PRJA248" NUMBER(15,0), 
		"PRJA249" NUMBER(15,0), 
		"PRJA250" NUMBER(15,0), 
		"PRJA254" NUMBER(15,0), 
		"PRJA251" NUMBER(15,0), 
		"PRJA252" NUMBER(15,0), 
		"PRJA253" NUMBER(15,0), 
		"PRJA270" NUMBER(15,0), 
		"PRJA273" NUMBER(15,0), 
		"PRJA255" NUMBER(15,0), 
		"PRJA271" NUMBER(15,0), 
		"PRJA256" NUMBER(15,0), 
		"PRJA178" NUMBER(15,0), 
		"PRJA179" NUMBER(15,0), 
		"PRJA180" NUMBER(15,0), 
		"PRJA184" NUMBER(15,0), 
		"PRJA275" NUMBER(15,0), 
		"PRJA276" NUMBER(15,0), 
		"PRJA277" NUMBER(15,0), 
		"PRJA278" NUMBER(15,0), 
		"PRJA279" NUMBER(15,0), 
		"PRJA280" NUMBER(15,0), 
		"PRJA281" NUMBER(15,0), 
		"PRJA282" NUMBER(15,0), 
		"PRJA283" NUMBER(15,0), 
		"PRJA284" NUMBER(15,0), 
		"PRJA285" NUMBER(15,0), 
		"PRJA286" NUMBER(15,0), 
		"PRJA287" NUMBER(15,0), 
		"PRJA288" NUMBER(15,0), 
		"PRJA289" NUMBER(15,0), 
		"PRDA113" NUMBER(15,0), 
		"PRJA291" NUMBER(15,0), 
		"PRJA292" NUMBER(15,0), 
		"PRJA293" NUMBER(15,0), 
		"PRJA294" NUMBER(15,0)
		)
		'
		;
		
	END IF;
		
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_1708_t1 ||''|| v_year ||''|| v_scv_1708_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_1708_t1 ||''|| v_year ||''|| v_scv_1708_t2 ||''|| v_out ||'
		(m003,m0581,prja045,/*PRJA061,*/prja084,prja085,prja087,prja088,prja131,prja196,
		prja224, prja225, prja312, prja262, prja263, prja264, prja229, prja230, prja231, 
		PRJA232, PRJA265, PRJA266, PRJA267, PRJA235, PRJA268, PRJA269, PRJA236, PRJA237, 
		PRJA238, PRJA239, PRJA240, PRJA241, PRJA242, PRJA244, PRJA245, PRJA246, PRJA247, 
		prja248, prja249, prja250, prja254, prja251, prja252, prja253, prja270, prja273, 
		PRJA255, PRJA271, PRJA256, PRJA178, PRJA179, PRJA180, PRJA184, PRJA275, PRJA276, 
		PRJA277, PRJA278, PRJA279, PRJA280, PRJA281, PRJA282, PRJA283, PRJA284, PRJA285, 
		PRJA286, PRJA287, PRJA288, PRJA289, PRDA113, PRJA291, PRJA292, PRJA293, PRJA294)
		SELECT cc.m003,	cc.m0581, tt.prja045,/*tt.PRJA061,*/ tt.prja084, tt.prja085,	
		tt.PRJA087,	tt.PRJA088,	tt.PRJA131,	tt.PRJA196,
		prja224, prja225, prja312, prja262, prja263, prja264, prja229, prja230, prja231, 
		PRJA232, PRJA265, PRJA266, PRJA267, PRJA235, PRJA268, PRJA269, PRJA236, PRJA237, 
		PRJA238, PRJA239, PRJA240, PRJA241, PRJA242, PRJA244, PRJA245, PRJA246, PRJA247, 
		prja248, prja249, prja250, prja254, prja251, prja252, prja253, prja270, prja273, 
		PRJA255, PRJA271, PRJA256, PRJA178, PRJA179, PRJA180, PRJA184, PRJA275, PRJA276, 
		prja277, prja278, prja279, prja280, prja281, prja282, prja283, prja284, prja285, 
		PRJA286, PRJA287, PRJA288, PRJA289, PRDA113, PRJA291, PRJA292, PRJA293, PRJA294
		from '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t1 ||''|| v_year ||''|| v_in_scv_tasa_t2 ||' tt 
		ON tt.m003=cc.M003
		WHERE tt.m003 is not null
		AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
		'
		;
		
	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_1708_t1 ||''|| v_year ||''|| v_scv_1708_t2 ||''|| v_out ||' tábla nem üres!');
		
	END IF;
	
/* -- nincs m0581 mező a PR17.W_V_P1708_V01 táblában, ezért ez a kód nem fut le:
 
	-- TEÁOR kód ellenőrzése
	sql_statement := 'SELECT COUNT(*) FROM (SELECT cc.m003, cc.m0581, pp.m0581 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
	LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t ||' pp 
	ON pp.m003 = cc.m003
	WHERE pp.m0581 <> cc.m0581)';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z > 0 THEN
		DBMS_OUTPUT.PUT_LINE('Eltérés van a TEÁOR kódban: ' || z || ' esetben!');
		
		sql_statement := 'SELECT cc.m003, cc.m0581, pp.m0581 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_scv_tasa_t ||' pp 
		ON pp.m003 = cc.m003
		WHERE pp.m0581 <> cc.m0581';
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_teaor;
	
		FOR b IN v_teaor.FIRST..v_teaor.LAST LOOP
			DBMS_OUTPUT.PUT_LINE('eltérések: ' || v_teaor(b));
		END LOOP;
				
	END IF;
*/
	
END IF;


--1711-es tábla:
IF v_1711 = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_tasa_1711_t1 ||''|| v_year ||''|| v_tasa_1711_t2 ||''|| v_out ||'' ';
/*	
	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1711_t ||''|| v_out ||'
		("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"PRJA033" NUMBER(15,0), 
		"PRJA049" NUMBER(15,0), 
		"PRJA056" NUMBER(15,0), 
		"PRJA062" NUMBER(15,0), 
		"PRJA065" NUMBER(15,0), 
		"PRJA212" NUMBER(15,0), 
		"PRJA195" NUMBER(15,0), 
		"PRJA313" NUMBER(15,0), 
		"PRJA314" NUMBER(15,0)
		)
		'
		;
				
	END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1711_t1 ||''|| v_year ||''|| v_tasa_1711_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1711_t1 ||''|| v_year ||''|| v_tasa_1711_t2 ||''|| v_out ||' 
		(m003, m0581, /*prja033,*/ /*prja049,*/ prja056, /*prja062,*/ /*prja065,*/ /*PRJA195,*/ prja212, prja313, prja314)
		SELECT cc.m003,	cc.m0581, /*tt.prja033,*/	/*tt.prja049,*/	tt.prja056,	/*tt.prja062,*/ /*tt.PRJA065,*/	
		/*tt.prja195,*/ tt.PRJA212, tt.prja313, tt.prja314
		FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1711_t1 ||''|| v_year ||''|| v_in_tasa_1711_t2 ||' tt 
		ON tt.M003=cc.M003
		WHERE NOT tt.m003 is null
		AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
	  --/*and tt.m003 IN (23292637,23997349)
		'
		; 

	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1711_t1 ||''|| v_year ||''|| v_tasa_1711_t2 ||''|| v_out ||' tábla nem üres!');
		
	END IF;
	
END IF;


--1729-es tábla:
IF v_1729 = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_tasa_1729_t1 ||''|| v_year ||''|| v_tasa_1729_t2 ||''|| v_out ||'' ';
/*	
	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_t1 ||''|| v_year ||''|| v_tasa_1729_t2 ||''|| v_out ||'
	    ("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"M005" VARCHAR2(4 BYTE), 
		"M045" VARCHAR2(4 BYTE), 
		"TAB279" NUMBER, 
		"PRAA001" NUMBER(15,0), 
		"PRAA002" NUMBER(15,0), 
		"PRAA008" NUMBER(15,0), 
		"PRAA009" NUMBER(15,0), 
		"PRAA013" NUMBER(15,0), 
		"PRAA014" NUMBER(15,0), 
		"PRAA019" NUMBER(15,0), 
		"PRAA026" NUMBER(15,0), 
		"PRAA035" NUMBER(15,0), 
		"PRAA036" NUMBER(15,0), 
		"PRAA038" NUMBER(15,0), 
		"PRAA041" NUMBER(15,0), 
		"PRAA045" NUMBER(15,0), 
		"PRAA048" NUMBER(15,0), 
		"PRAA049" NUMBER(15,0), 
		"PRAA063" NUMBER(15,0), 
		"PRAA064" NUMBER(15,0), 
		"PRAA066" NUMBER(15,0), 
		"PRAA067" NUMBER(15,0), 
		"PRAA068" NUMBER(15,0), 
		"PRAA069" NUMBER(15,0), 
		"PRBA001" NUMBER(15,0), 
		"PRBA002" NUMBER(15,0), 
		"PRBA006" NUMBER(15,0), 
		"PRBA012" NUMBER(15,0), 
		"PRBA013" NUMBER(15,0), 
		"PRBA015" NUMBER(15,0), 
		"PRBA016" NUMBER(15,0), 
		"PRBA021" NUMBER(15,0), 
		"PRBA022" NUMBER(15,0), 
		"PRBA028" NUMBER(15,0), 
		"PRBA030" NUMBER(15,0), 
		"PRBA035" NUMBER(15,0), 
		"PRBA036" NUMBER(15,0), 
		"PRBA037" NUMBER(15,0), 
		"PRBA038" NUMBER(15,0), 
		"PRBA039" NUMBER(15,0), 
		"PRBA040" NUMBER(15,0), 
		"PRBA044" NUMBER(15,0), 
		"PRBA048" NUMBER(15,0), 
		"PRBA049" NUMBER(15,0), 
		"PRBA050" NUMBER(15,0), 
		"PRBA051" NUMBER(15,0), 
		"PRBA053" NUMBER(15,0), 
		"PRBA054" NUMBER(15,0), 
		"PRBA055" NUMBER(15,0), 
		"PRBA056" NUMBER(15,0), 
		"PRCA001" NUMBER(15,0), 
		"PRCA002" NUMBER(15,0), 
		"PRCA003" NUMBER(15,0), 
		"PRCA004" NUMBER(15,0), 
		"PRCA007" NUMBER(15,0), 
		"PRCA008" NUMBER(15,0), 
		"PRCA015" NUMBER(15,0), 
		"PRCA016" NUMBER(15,0), 
		"PRCA017" NUMBER(15,0), 
		"PRCA019" NUMBER(15,0), 
		"PRCA020" NUMBER(15,0), 
		"PRCA022" NUMBER(15,0), 
		"PRCA023" NUMBER(15,0), 
		"PRCA024" NUMBER(15,0), 
		"PRCA027" NUMBER(15,0), 
		"PRCA029" NUMBER(15,0), 
		"PRCA031" NUMBER(15,0), 
		"PRCA032" NUMBER(15,0), 
		"PRCA035" NUMBER(15,0), 
		"PRCA037" NUMBER(15,0), 
		"PRCA038" NUMBER(15,0), 
		"PRCA044" NUMBER(15,0), 
		"PRCA045" NUMBER(15,0), 
		"PRCA046" NUMBER(15,0), 
		"PRCA053" NUMBER(15,0), 
		"PRCA054" NUMBER(15,0), 
		"PRCA055" NUMBER(15,0), 
		"PRCA057" NUMBER(15,0), 
		"PRCA073" NUMBER(15,0), 
		"PRCA075" NUMBER(15,0), 
		"PRCA077" NUMBER(15,0), 
		"PRCA078" NUMBER(15,0), 
		"PRCA081" NUMBER(15,0), 
		"PRCA090" NUMBER(15,0), 
		"PRCA091" NUMBER(15,0), 
		"PRCA092" NUMBER(15,0), 
		"PRCA093" NUMBER(15,0), 
		"PRCA094" NUMBER(15,0), 
		"PRCA095" NUMBER(15,0), 
		"PRCA096" NUMBER(15,0), 
		"PRCA103" NUMBER(15,0), 
		"PRCA107" NUMBER(15,0), 
		"PRCA126" NUMBER(15,0), 
		"PRCA127" NUMBER(15,0), 
		"PRCA132" NUMBER(15,0), 
		"PRCA133" NUMBER(15,0), 
		"PRCA134" NUMBER(15,0), 
		"PRCA135" NUMBER(15,0), 
		"PRCA136" NUMBER(15,0), 
		"PRCA137" NUMBER(15,0), 
		"PRCA138" NUMBER(15,0), 
		"PRCA140" NUMBER(15,0), 
		"PRCA141" NUMBER(15,0), 
		"PRCA144" NUMBER(15,0), 
		"PRCA149" NUMBER(15,0), 
		"PRCA150" NUMBER(15,0), 
		"PRCA151" NUMBER(15,0), 
		"PRCA156" NUMBER(15,0), 
		"PRCA158" NUMBER(15,0), 
		"PRCA159" NUMBER(15,0), 
		"PRCA160" NUMBER(15,0), 
		"PRCA161" NUMBER(15,0), 
		"PRCA162" NUMBER(15,0), 
		"PRCA163" NUMBER(15,0), 
		"PRCA164" NUMBER(15,0), 
		"PRCA165" NUMBER(15,0), 
		"PRCA166" NUMBER(15,0), 
		"PRDA006" NUMBER(15,0), 
		"PRDA012" NUMBER(15,0), 
		"PRDA024" NUMBER(15,0), 
		"PRDA032" NUMBER(15,0), 
		"PRDA041" NUMBER(15,0), 
		"PRDA049" NUMBER(15,0), 
		"PRDA050" NUMBER(15,0), 
		"PRDA065" NUMBER(15,0), 
		"PRDA066" NUMBER(15,0), 
		"PRDA067" NUMBER(15,0), 
		"PRDA068" NUMBER(15,0), 
		"PRDA072" NUMBER(15,0), 
		"PRDA073" NUMBER(15,0), 
		"PRDA076" NUMBER(15,0), 
		"PRDA079" NUMBER(15,0), 
		"PRDA080" NUMBER(15,0), 
		"PRDA082" NUMBER(15,0), 
		"PRDA084" NUMBER(15,0), 
		"PRDA085" NUMBER(15,0), 
		"PRDA088" NUMBER(15,0), 
		"PRDA090" NUMBER(15,0), 
		"PRDA091" NUMBER(15,0), 
		"PRDA092" NUMBER(15,0), 
		"PRDA093" NUMBER(15,0), 
		"PRDA095" NUMBER(15,0), 
		"PRDA096" NUMBER(15,0), 
		"PRDA097" NUMBER(15,0), 
		"PRDA098" NUMBER(15,0), 
		"PRDA106" NUMBER(15,0), 
		"PRDA107" NUMBER(15,0), 
		"PRDA108" NUMBER(15,0), 
		"PRDA109" NUMBER(15,0), 
		"PRDA110" NUMBER(15,0), 
		"PRDA111" NUMBER(15,0), 
		"PRDA114" NUMBER(15,0), 
		"PRDA115" NUMBER(15,0), 
		"PRDA116" NUMBER(15,0), 
		"PRDA117" NUMBER(15,0), 
		"PRDA118" NUMBER(15,0), 
		"PRDA121" NUMBER(15,0), 
		"PRJA122" NUMBER(15,0), 
		"PRJA222" NUMBER(15,0), 
		"PRJA223" NUMBER(15,0), 
		"PRJA295" NUMBER(15,0), 
		"PRJA296" NUMBER(15,0), 
		"PFC0M038" NUMBER(15,0), 
		"PFD0M050" NUMBER(15,0), 
		"PFD0M106" NUMBER(15,0), 
		"PFA0M013" NUMBER(15,0), 
		"PRJA297" NUMBER(15,0), 
		"PRCA056" NUMBER(15,0), 
		"PRDA102" NUMBER(15,0), 
		"PRJA301" NUMBER(15,0), 
		"PRCA167" NUMBER(15,0), 
		"PRCA168" NUMBER(15,0), 
		"PRJA298" NUMBER(15,0), 
		"PRCA169" NUMBER(15,0), 
		"PRCA170" NUMBER(15,0), 
		"PRCA171" NUMBER(15,0), 
		"PRCA172" NUMBER(15,0), 
		"PRCA173" NUMBER(15,0), 
		"PRJA299" NUMBER(15,0), 
		"PRJA300" NUMBER(15,0), 
		"PRCA175" NUMBER(15,0), 
		"PRCA178" NUMBER(15,0), 
		"PRCA179" NUMBER(15,0), 
		"PRCA180" NUMBER(15,0), 
		"PRCA181" NUMBER(15,0), 
		"PRCA174" NUMBER(15,0), 
		"PRAA070" NUMBER(15,0), 
		"PRAA071" NUMBER(15,0), 
		"PRAA072" NUMBER(15,0), 
		"PRAA073" NUMBER(15,0), 
		"PRAA074" NUMBER(15,0), 
		"PRAA075" NUMBER(15,0), 
		"PRAA076" NUMBER(15,0), 
		"PRAA077" NUMBER(15,0), 
		"PRBA059" NUMBER(15,0), 
		"PRBA060" NUMBER(15,0), 
		"PRBA057" NUMBER(15,0), 
		"PRBA058" NUMBER(15,0), 
		"PRDA122" NUMBER(15,0)
		)
		'
		;
				
	END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_t1 ||''|| v_year ||''|| v_tasa_1729_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN

	EXECUTE IMMEDIATE'
	INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_t1 ||''|| v_year ||''|| v_tasa_1729_t2 ||''|| v_out ||'
	(m003, m005, m045, m0581, mev, pfa0m013, 
	pfc0m038, pfd0m050, pfd0m106, praa002, praa008, praa009, praa014, praa019, 
	praa026, praa035, praa036, praa038, praa041, praa045, praa048, praa049, 
	praa063, praa066, praa067, praa068, praa069, prba002, prba006, prba012, 
	prba013, prba015, /*prba017,*/ prba021, prba022, prba028, prba030, prba035, 
	prba037, prba038, prba039, prba040, prba044, prba048, prba049, prba050, 
	prba051, prba053, prba054, prba055, prba056, prca002, prca004, prca007, 
	prca008, prca015, prca017, prca019, prca020, prca022, prca023, 
	prca024, prca027, prca029, prca031, prca035, prca037, prca044, prca045, 
	prca046, prca053, prca054, prca057, prca075, prca077, prca078, prca081, 
	prca090, prca091, prca092, prca093, prca094, prca095, prca096, prca103, 
	prca107, prca126, prca127, prca132, prca133, prca134, prca135, prca136, 
	prca137, prca138, prca140, prca141, prca144, prca149, prca150, prca151, 
	prda006, prda012, prda024, prda032, prda041, prda049, prda065, prda066, 
	prda068, prda072, prda073, prda076, prda079, prda080, prda082, prda084, 
	prda085, prda088, prda092, prda093, prda095, prda098, /*prda102,*/ /*prda103,*/
	prda107, prda108, prda109, prda110,
	praa001,praa013,praa064,prba001,prba016,prba036,prca001,prca003,prca016,
	prca032,prca038,prca055,prca073,prca156,prca158,prca159,prca160,prca161,
	PRCA162,PRCA163,PRCA164,PRCA165,PRCA166,PRDA050,PRDA067,PRDA090,PRDA091,
	prda096,prda097,prda106,prda111,prda114,prda115,prda116,prda117,prda118,
	PRDA121,PRJA122,PRJA222,PRJA223,PRJA295,PRJA296,PRJA297)
	SELECT 
	cc.m003, tt.m005, tt.m045, cc.m0581, '''|| evszam ||''', nvl(praa068,0)+nvl(praa069,0), 
	nvl(prca149,0)+nvl(prca078,0), nvl(prda109,0)+nvl(prda110,0), 
	nvl(prda024,0)-nvl(prda079,0), praa002, praa008, praa009, praa014, praa019, 
	praa026, praa035, praa036, praa038, praa041, praa045, praa048, praa049, 
	praa063, praa066, praa067, praa068, praa069, prba002, prba006, prba012, 
	prba013, prba015, /*prba017,*/ prba021, prba022, prba028, prba030, prba035, 
	prba037, prba038, prba039, prba040, prba044, prba048, prba049, prba050, 
	prba051, prba053, prba054, prba055, prba056, prca002, prca004, prca007, 
	prca008, prca015, prca017, prca019, prca020, prca022, prca023, 
	prca024, prca027, prca029, prca031, prca035, prca037, prca044, prca045, 
	prca046, prca053, prca054, prca057, prca075, prca077, prca078, prca081, 
	prca090, prca091, prca092, prca093, prca094, prca095, prca096, prca103, 
	prca107, prca126, prca127, prca132, prca133, prca134, prca135, prca136, 
	prca137, prca138, prca140, prca141, prca144, prca149, prca150, prca151, 
	prda006, prda012, prda024, prda032, prda041, prda049, prda065, prda066, 
	prda068, prda072, prda073, prda076, prda079, prda080, prda082, 
	nvl(prda107,0)+nvl(prda108,0), prda085, prda088, prda092, prda093, prda095, 
	prda098, /*PRDA102,*/ /*PRDA103,*/ prda107, prda108, prda109, prda110,
	praa001,praa013,praa064,prba001,prba016,prba036,prca001,prca003,prca016,
	prca032,prca038,prca055,prca073,prca156,prca158,prca159,prca160,prca161,
	PRCA162,PRCA163,PRCA164,PRCA165,PRCA166,PRDA050,PRDA067,PRDA090,PRDA091,
	prda096,prda097,prda106,prda111,prda114,prda115,prda116,prda117,prda118,
	PRDA121,PRJA122,PRJA222,PRJA223,PRJA295,PRJA296,PRJA297
	FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
	LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1729_t1 ||''|| v_year ||''|| v_in_tasa_1729_t2 ||' tt 
	ON tt.M003=cc.M003
	WHERE NOT tt.m003 IS NULL
	AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
	-- and tt.m003 IN (23292637,23997349);
	'
	;

	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_t1 ||''|| v_year ||''|| v_tasa_1729_t2 ||''|| v_out ||' tábla nem üres!');
		
	END IF;	

END IF;


IF v_1729_upd_ifrs = TRUE THEN

	sql_statement := 'SELECT M003 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc 
	LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
	ON tt.tor=cc.m003
	WHERE NOT tt.tor IS NULL
	AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
	';

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_teaor;

	FOR a IN v_teaor.FIRST..v_teaor.LAST LOOP
	
		EXECUTE IMMEDIATE'
		UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_t1 ||''|| v_year ||''|| v_tasa_1729_t2 ||''|| v_out ||'
		SET PRCA167 = (SELECT tt.TAX001 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA002 = (SELECT tt.TAX002 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA168 = (SELECT tt.TAX003 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRJA298 = (SELECT tt.TAX004 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRCA169 = (SELECT tt.TAX005 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRCA170 = (SELECT tt.TAX006 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRCA171 = (SELECT tt.TAX007 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA008 = (SELECT tt.TAX008 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRCA092 = (SELECT tt.TAX009 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA172 = (SELECT tt.TAX010 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA022 = (SELECT tt.TAX011 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRCA023 = (SELECT tt.TAX012 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRCA024 = (SELECT tt.TAX013 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA173 = (SELECT tt.TAX014 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA019 = (SELECT tt.TAX016 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA016 = (SELECT tt.TAX017 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA017 = (SELECT tt.TAX018 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA094 = (SELECT tt.TAX019 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA020 = (SELECT tt.TAX020 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA095 = (SELECT tt.TAX021 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRJA299 = (SELECT tt.TAX022 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA091 = (SELECT tt.TAX023 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRJA300 = (SELECT tt.TAX024 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRCA035 = (SELECT tt.TAX025 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA175 = (SELECT tt.TAX026 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRCA178 = (SELECT tt.TAX027 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRCA179 = (SELECT tt.TAX028 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRCA180 = (SELECT tt.TAX029 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRCA181 = (SELECT tt.TAX030 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRCA174 = (SELECT tt.TAX031 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRAA002 = (SELECT tt.TAY001 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA070 = (SELECT tt.TAY002 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRAA071 = (SELECT tt.TAY003 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRAA072 = (SELECT tt.TAY004 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA073 = (SELECT tt.TAY005 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA026 = (SELECT tt.TAY006 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRAA036 = (SELECT tt.TAY007 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRAA074 = (SELECT tt.TAY008 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA075 = (SELECT tt.TAY009 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA045 = (SELECT tt.TAY010 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRAA076 = (SELECT tt.TAY011 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA077 = (SELECT tt.TAY012 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA002 = (SELECT tt.TAY013 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA037 = (SELECT tt.TAY014 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA038 = (SELECT tt.TAY015 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRBA039 = (SELECT tt.TAY016 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA040 = (SELECT tt.TAY017 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA054 = (SELECT tt.TAY018 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA006 = (SELECT tt.TAY019 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA055 = (SELECT tt.TAY020 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRBA056 = (SELECT tt.TAY021 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA013 = (SELECT tt.TAY022 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRBA015 = (SELECT tt.TAY023 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRBA059 = (SELECT tt.TAY024 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA060 = (SELECT tt.TAY025 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA021 = (SELECT tt.TAY026 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA022 = (SELECT tt.TAY027 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA051 = (SELECT tt.TAY028 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA057 = (SELECT tt.TAY029 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA028 = (SELECT tt.TAY030 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA030 = (SELECT tt.TAY031 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRDA076 = (SELECT tt.TAY032 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA050 = (SELECT tt.TAY033 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRBA058 = (SELECT tt.TAY034 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRAA049 = (SELECT tt.TAY035 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),
		PRDA024 = (SELECT tt.TAY036 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRDA079 = (SELECT tt.TAY037 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),			
		PRCA057 = (SELECT tt.TAY038 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRDA122 = (SELECT tt.TAY039 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),	
		PRAA067 = (SELECT tt.TAY040 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||'''),		
		PRJA301 = (SELECT tt.TAY041 FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in_tasa_1729_ifrs_t1 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t2 ||''|| v_year ||''|| v_in_tasa_1729_ifrs_t3 ||' tt 
		ON tt.tor=cc.m003 WHERE 
		cc.m003 = '''|| v_teaor(a) ||''')
		WHERE m003 = '''|| v_teaor(a) ||'''
		'
		;
				
	END LOOP;

END IF;


IF v_1729_scv = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||'' ';
/*	
	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||'
	    ("M003" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
		"M0581" VARCHAR2(4 BYTE), 
		"M005" VARCHAR2(4 BYTE), 
		"M045" VARCHAR2(4 BYTE), 
		"PRAA001" NUMBER(15,0), 
		"PRAA002" NUMBER(15,0), 
		"PRAA008" NUMBER(15,0), 
		"PRAA009" NUMBER(15,0), 
		"PRAA013" NUMBER(15,0), 
		"PRAA014" NUMBER(15,0), 
		"PRAA019" NUMBER(15,0), 
		"PRAA026" NUMBER(15,0), 
		"PRAA035" NUMBER(15,0), 
		"PRAA036" NUMBER(15,0), 
		"PRAA038" NUMBER(15,0), 
		"PRAA041" NUMBER(15,0), 
		"PRAA045" NUMBER(15,0), 
		"PRAA048" NUMBER(15,0), 
		"PRAA049" NUMBER(15,0), 
		"PRAA063" NUMBER(15,0), 
		"PRAA064" NUMBER(15,0), 
		"PRAA066" NUMBER(15,0), 
		"PRAA067" NUMBER(15,0), 
		"PRAA068" NUMBER(15,0), 
		"PRAA069" NUMBER(15,0), 
		"PRBA001" NUMBER(15,0), 
		"PRBA002" NUMBER(15,0), 
		"PRBA006" NUMBER(15,0), 
		"PRBA012" NUMBER(15,0), 
		"PRBA013" NUMBER(15,0), 
		"PRBA015" NUMBER(15,0), 
		"PRBA016" NUMBER(15,0), 
		"PRBA021" NUMBER(15,0), 
		"PRBA022" NUMBER(15,0), 
		"PRBA028" NUMBER(15,0), 
		"PRBA030" NUMBER(15,0), 
		"PRBA035" NUMBER(15,0), 
		"PRBA036" NUMBER(15,0), 
		"PRBA037" NUMBER(15,0), 
		"PRBA038" NUMBER(15,0), 
		"PRBA039" NUMBER(15,0), 
		"PRBA040" NUMBER(15,0), 
		"PRBA044" NUMBER(15,0), 
		"PRBA048" NUMBER(15,0), 
		"PRBA049" NUMBER(15,0), 
		"PRBA050" NUMBER(15,0), 
		"PRBA051" NUMBER(15,0), 
		"PRBA053" NUMBER(15,0), 
		"PRBA054" NUMBER(15,0), 
		"PRBA055" NUMBER(15,0), 
		"PRBA056" NUMBER(15,0), 
		"PRCA001" NUMBER(15,0), 
		"PRCA002" NUMBER(15,0), 
		"PRCA003" NUMBER(15,0), 
		"PRCA004" NUMBER(15,0), 
		"PRCA007" NUMBER(15,0), 
		"PRCA008" NUMBER(15,0), 
		"PRCA015" NUMBER(15,0), 
		"PRCA016" NUMBER(15,0), 
		"PRCA017" NUMBER(15,0), 
		"PRCA019" NUMBER(15,0), 
		"PRCA020" NUMBER(15,0), 
		"PRCA022" NUMBER(15,0), 
		"PRCA023" NUMBER(15,0), 
		"PRCA024" NUMBER(15,0), 
		"PRCA027" NUMBER(15,0), 
		"PRCA029" NUMBER(15,0), 
		"PRCA031" NUMBER(15,0), 
		"PRCA032" NUMBER(15,0), 
		"PRCA035" NUMBER(15,0), 
		"PRCA037" NUMBER(15,0), 
		"PRCA038" NUMBER(15,0), 
		"PRCA044" NUMBER(15,0), 
		"PRCA045" NUMBER(15,0), 
		"PRCA046" NUMBER(15,0), 
		"PRCA053" NUMBER(15,0), 
		"PRCA054" NUMBER(15,0), 
		"PRCA055" NUMBER(15,0), 
		"PRCA057" NUMBER(15,0), 
		"PRCA073" NUMBER(15,0), 
		"PRCA075" NUMBER(15,0), 
		"PRCA077" NUMBER(15,0), 
		"PRCA078" NUMBER(15,0), 
		"PRCA081" NUMBER(15,0), 
		"PRCA090" NUMBER(15,0), 
		"PRCA091" NUMBER(15,0), 
		"PRCA092" NUMBER(15,0), 
		"PRCA093" NUMBER(15,0), 
		"PRCA094" NUMBER(15,0), 
		"PRCA095" NUMBER(15,0), 
		"PRCA096" NUMBER(15,0), 
		"PRCA103" NUMBER(15,0), 
		"PRCA107" NUMBER(15,0), 
		"PRCA126" NUMBER(15,0), 
		"PRCA127" NUMBER(15,0), 
		"PRCA132" NUMBER(15,0), 
		"PRCA133" NUMBER(15,0), 
		"PRCA134" NUMBER(15,0), 
		"PRCA135" NUMBER(15,0), 
		"PRCA136" NUMBER(15,0), 
		"PRCA137" NUMBER(15,0), 
		"PRCA138" NUMBER(15,0), 
		"PRCA140" NUMBER(15,0), 
		"PRCA141" NUMBER(15,0), 
		"PRCA144" NUMBER(15,0), 
		"PRCA149" NUMBER(15,0), 
		"PRCA150" NUMBER(15,0), 
		"PRCA151" NUMBER(15,0), 
		"PRCA156" NUMBER(15,0), 
		"PRCA158" NUMBER(15,0), 
		"PRCA159" NUMBER(15,0), 
		"PRCA160" NUMBER(15,0), 
		"PRCA161" NUMBER(15,0), 
		"PRCA162" NUMBER(15,0), 
		"PRCA163" NUMBER(15,0), 
		"PRCA164" NUMBER(15,0), 
		"PRCA165" NUMBER(15,0), 
		"PRCA166" NUMBER(15,0), 
		"PRDA006" NUMBER(15,0), 
		"PRDA012" NUMBER(15,0), 
		"PRDA024" NUMBER(15,0), 
		"PRDA032" NUMBER(15,0), 
		"PRDA041" NUMBER(15,0), 
		"PRDA049" NUMBER(15,0), 
		"PRDA050" NUMBER(15,0), 
		"PRDA065" NUMBER(15,0), 
		"PRDA066" NUMBER(15,0), 
		"PRDA067" NUMBER(15,0), 
		"PRDA068" NUMBER(15,0), 
		"PRDA072" NUMBER(15,0), 
		"PRDA073" NUMBER(15,0), 
		"PRDA076" NUMBER(15,0), 
		"PRDA079" NUMBER(15,0), 
		"PRDA080" NUMBER(15,0), 
		"PRDA082" NUMBER(15,0), 
		"PRDA084" NUMBER(15,0), 
		"PRDA085" NUMBER(15,0), 
		"PRDA088" NUMBER(15,0), 
		"PRDA090" NUMBER(15,0), 
		"PRDA091" NUMBER(15,0), 
		"PRDA092" NUMBER(15,0), 
		"PRDA093" NUMBER(15,0), 
		"PRDA095" NUMBER(15,0), 
		"PRDA096" NUMBER(15,0), 
		"PRDA097" NUMBER(15,0), 
		"PRDA098" NUMBER(15,0), 
		"PRDA106" NUMBER(15,0), 
		"PRDA107" NUMBER(15,0), 
		"PRDA108" NUMBER(15,0), 
		"PRDA109" NUMBER(15,0), 
		"PRDA110" NUMBER(15,0), 
		"PRDA111" NUMBER(15,0), 
		"PRDA114" NUMBER(15,0), 
		"PRDA115" NUMBER(15,0), 
		"PRDA116" NUMBER(15,0), 
		"PRDA117" NUMBER(15,0), 
		"PRDA118" NUMBER(15,0), 
		"PRDA121" NUMBER(15,0), 
		"PRJA122" NUMBER(15,0), 
		"PRJA222" NUMBER(15,0), 
		"PRJA223" NUMBER(15,0), 
		"PRJA295" NUMBER(15,0), 
		"PRJA296" NUMBER(15,0), 
		"PRJA297" NUMBER(15,0), 
		"MEV" VARCHAR2(20 BYTE), 
		"PFD0M106" NUMBER(15,0), 
		"PFD0M050" NUMBER(15,0), 
		"PFA0M013" NUMBER(15,0), 
		"PFC0M038" NUMBER(15,0), 
		"PRCA056" NUMBER(15,0)
		)
		'
		;
				
	END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
	
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||'
		(mev, m003, m0581, m005, m045, 
		prca053, prca075, prda088, prca054, /*prda102,*/
		/*prda103,*/ prda093, prda065, prda095, prda066, prda098, prca029, prda085, 
		prda068, prda092, prca077, prca103, prca002, prca007, prca004, prda072, 
		prca015, prca008, prca090, prca091, prca092, prca093, prca022, prca023, 
		prca019, prca017, prca094, prca020, prca027, prda073, prda032, 
		prca095, prca144, prca031, prca037, prca035, prca096, prca150, prca151, 
		prca081, prca044, prca126, prca149, prca078, prca127, prca045, prca046, 
		pfc0m038, praa002, praa008, praa019, praa026, praa035, praa036, praa041, 
		praa045, praa048, prba002, prba037, prba038, prba039, prba040, prba054, 
		prba006, prba055, prba056, praa038, prba012, prba013, prba048, prba044, 
		prba053, prba015, /*prba017,*/ prba049, prba021, prba022, prba051, prba028, 
		prba030, prda076, prba050, prba035, praa049, prda006, prda012, prda107, 
		prda108, praa066, praa009, praa068, praa069, praa014, prda041, prda049, 
		prda109, prda110, prda082, prda080, pfa0m013, prda084, pfd0m050, prda024, 
		prda079, prca024, prca057, praa063, praa067, prca107, prca132, pfd0m106, 
		prca133, prca135, prca137, prca140, prca134, prca136, prca138, prca141,
		PRAA001, PRAA013, PRAA064, PRBA001, PRBA016, PRBA036, PRCA001, PRCA003, PRCA016,
		PRCA032, PRCA038, PRCA055, PRCA073, PRCA156, PRCA158, PRCA159, PRCA160, PRCA161,
		PRCA162, PRCA163, PRCA164, PRCA165, PRCA166, PRDA050, PRDA067, PRDA090, PRDA091,
		PRDA096, PRDA097, PRDA106, PRDA111, PRDA114, PRDA115, PRDA116, PRDA117, PRDA118,
		PRDA121, PRJA122, PRJA222, PRJA223, PRJA295, PRJA296, PRJA297 )
		SELECT 
		'''|| evszam ||''', cc.m003, cc.m0581, tt.m005, tt.m045, prca053, prca075, prda088, 
		prca054, /*prda102,*/ /*prda103,*/ prda093, prda065, prda095, prda066, prda098, 
		prca029, prda085, prda068, prda092, prca077, prca103, prca002, prca007, 
		prca004, prda072, prca015, prca008, prca090, prca091, prca092, prca093, 
		prca022, prca023, prca019, prca017, prca094, prca020, prca027, 
		prda073, prda032, prca095, prca144, prca031, prca037, prca035, prca096, 
		prca150, prca151, prca081, prca044, prca126, prca149, prca078, prca127, 
		prca045, prca046, nvl(prca149,0)+nvl(prca078,0)+nvl(prca078,0), praa002, 
		praa008, praa019, praa026, praa035, praa036, praa041, praa045, praa048, 
		prba002, prba037, prba038, prba039, prba040, prba054, prba006, prba055, 
		prba056, praa038, prba012, prba013, prba048, prba044, prba053, prba015, 
		/*prba017,*/ prba049, prba021, prba022, prba051, prba028, prba030, prda076, 
		prba050, prba035, praa049, prda006, prda012, prda107, prda108, praa066, 
		praa009, praa068, praa069, praa014, prda041, prda049, prda109, prda110, 
		prda082, prda080, nvl(praa068,0)+nvl(praa069,0), nvl(prda107,0)+nvl(prda108,0), 
		nvl(prda109,0)+nvl(prda110,0), prda024, prda079, prca024, prca057, praa063, 
		praa067, prca107, prca132, nvl(prda024,0)-nvl(prda079,0), prca133, prca135, 
		PRCA137, PRCA140, PRCA134, PRCA136, PRCA138, PRCA141,
		PRAA001, PRAA013, PRAA064, PRBA001, PRBA016, PRBA036, PRCA001, PRCA003, PRCA016,
		PRCA032, PRCA038, PRCA055, PRCA073, PRCA156, PRCA158, PRCA159, PRCA160, PRCA161,
		PRCA162, PRCA163, PRCA164, PRCA165, PRCA166, PRDA050, PRDA067, PRDA090, PRDA091,
		prda096, prda097, prda106, prda111, prda114, prda115, prda116, prda117, prda118,
		PRDA121, PRJA122, PRJA222, PRJA223, PRJA295, PRJA296, PRJA297
		FROM '|| v_out_schema ||'.'|| v_ceglista_scv ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1729_t1 ||''|| v_year ||''|| v_in_tasa_1729_t2 ||' tt 
		ON tt.M003=cc.M003
		WHERE NOT tt.m003 IS NULL  --AND cc.m003 is not null
		AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
		--and cc.m003 IN (23292637,23997349); 
		'
		;
	
	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tábla nem üres!');		
	
	END IF;

END IF;

IF v_scv_upd_scv = TRUE THEN

	sql_statement := 'SELECT t.m003 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
	LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003	';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_teaor;

	FOR a IN v_teaor.FIRST..v_teaor.LAST LOOP
	
		EXECUTE IMMEDIATE'
		UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||'
		SET PRCA008 = (SELECT tt.PRCA008 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA090 = (SELECT tt.PRCA090 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA022 = (SELECT tt.PRCA022 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA023 = (SELECT tt.PRCA023 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),		
		PRCA093 = (SELECT tt.PRCA093 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA017 = (SELECT tt.PRCA017 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),	
		PRCA094 = (SELECT tt.PRCA094 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),	
		PRCA081 = (SELECT tt.PRCA081 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),	
		PRCA150 = (SELECT tt.PRCA150 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA151 = (SELECT tt.PRCA151 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA078 = (SELECT tt.PRCA078 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA149 = (SELECT tt.PRCA149 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA054 = (SELECT tt.PRCA054 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA024 = (SELECT tt.PRCA024 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRDA066 = (SELECT tt.PRDA066 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRDA068 = (SELECT tt.PRDA068 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA004 = (SELECT tt.PRCA004 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA007 = (SELECT tt.PRCA007 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA020 = (SELECT tt.PRCA020 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA091 = (SELECT tt.PRCA091 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA092 = (SELECT tt.PRCA092 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),	
		PRCA103 = (SELECT tt.PRCA103 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),	
		PRDA082 = (SELECT tt.PRDA082 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),	
		PRCA167 = (SELECT tt.PRDA082 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||'''),
		PRCA172 = (SELECT tt.PRDA082 FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_tasa_t ||''|| v_out ||' T
		LEFT JOIN '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1729_scv_t1 ||''|| v_year ||''|| v_tasa_1729_scv_t2 ||''|| v_out ||' tt ON tt.m003 = T.m003
		WHERE T.m003 = '''|| v_teaor(a) ||''')
		WHERE m003 = '''|| v_teaor(a) ||'''
		'
		;
				
	END LOOP;

END IF;

IF v_1743 = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_tasa_1743_t1 ||''|| v_year ||''|| v_tasa_1743_t2 ||''|| v_out ||'' ';
/*	
	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1743_t1 ||''|| v_year ||''|| v_tasa_1743_t2 ||''|| v_out ||'
	    ("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"EAG001" NUMBER(15,0), 
		"EAG002" NUMBER(15,0), 
		"PRCA122" NUMBER(15,0), 
		"PRDA024" NUMBER(15,0), 
		"EAG017" NUMBER(15,0), 
		"PRJA121" NUMBER(15,0), 
		"PRCA108" NUMBER(15,0), 
		"PRJA106" NUMBER(15,0), 
		"PRCA121" NUMBER(15,0), 
		"PRDA119" NUMBER(15,0), 
		"PRDA120" NUMBER(15,0), 
		"PRJA304" NUMBER(15,0), 
		"PRJA305" NUMBER(15,0), 
		"PRAA078" NUMBER(15,0)
		)
		'
		;

	END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1743_t1 ||''|| v_year ||''|| v_tasa_1743_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
	
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1743_t1 ||''|| v_year ||''|| v_tasa_1743_t2 ||''|| v_out ||'	
		(m003,m0581,eag001,eag002,prca122,prda024,eag017,prja121,prca108, prja106, praa078)
		SELECT cc.M003,	cc.M0581, tt.prca108 eag001,tt.prca121 eag002,tt.PRCA122,
		tt.prda024,tt.prca122 eag017, tt.prja121, tt.prca108, tt.prja106, tt.praa078
		FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1743_t1 ||''|| v_year ||''|| v_in_tasa_1743_t2 ||' tt 
		ON tt.M003=cc.M003
		where not tt.m003 is null
		AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
		--and cc.m003 IN (23292637,23997349);
		'
		;
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1743_t1 ||''|| v_year ||''|| v_tasa_1743_t2 ||''|| v_out ||' tábla nem üres!');		
	
	END IF;
	
END IF;


IF v_1771 = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_tasa_1771_t1 ||''|| v_year ||''|| v_tasa_1771_t2 ||''|| v_out ||'' ';
/*	
	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1771_t1 ||''|| v_year ||''|| v_tasa_1771_t2 ||''|| v_out ||'
	    ("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"M005" VARCHAR2(4 BYTE), 
		"M045" VARCHAR2(4 BYTE), 
		"PRAA002" NUMBER(15,0), 
		"PRAA008" NUMBER(15,0), 
		"PRAA035" NUMBER(15,0), 
		"PRAA036" NUMBER(15,0), 
		"PRAA048" NUMBER(15,0), 
		"PRBA012" NUMBER(15,0), 
		"PRBA013" NUMBER(15,0), 
		"PRBA015" NUMBER(15,0), 
		"PRBA016" NUMBER(15,0), 
		"PRBA021" NUMBER(15,0), 
		"PRBA028" NUMBER(15,0), 
		"PRBA035" NUMBER(15,0), 
		"PRBA044" NUMBER(15,0), 
		"PRBA048" NUMBER(15,0), 
		"PRBA049" NUMBER(15,0), 
		"PRCA004" NUMBER(15,0), 
		"PRCA007" NUMBER(15,0), 
		"PRCA037" NUMBER(15,0), 
		"PRCA047" NUMBER(15,0), 
		"PRCA053" NUMBER(15,0), 
		"PRCA054" NUMBER(15,0), 
		"PRCA056" NUMBER(15,0), 
		"PRCA057" NUMBER(15,0), 
		"PRCA103" NUMBER(15,0), 
		"PRDA024" NUMBER(15,0), 
		"PRDA072" NUMBER(15,0), 
		"PRDA076" NUMBER(15,0), 
		"PRDA088" NUMBER(15,0), 
		"PRJA122" NUMBER(15,0), 
		"PRAA001" NUMBER(15,0), 
		"PRAA019" NUMBER(15,0), 
		"PRAA026" NUMBER(15,0), 
		"PRAA041" NUMBER(15,0), 
		"PRAA045" NUMBER(15,0), 
		"PRAA049" NUMBER(15,0), 
		"PRBA001" NUMBER(15,0), 
		"PRBA002" NUMBER(15,0), 
		"PRBA030" NUMBER(15,0), 
		"PRBA036" NUMBER(15,0), 
		"PRBA050" NUMBER(15,0), 
		"PRBA051" NUMBER(15,0), 
		"PRCA003" NUMBER(15,0), 
		"PRCA015" NUMBER(15,0), 
		"PRCA019" NUMBER(15,0), 
		"PRCA020" NUMBER(15,0), 
		"PRCA027" NUMBER(15,0), 
		"PRCA031" NUMBER(15,0), 
		"PRCA044" NUMBER(15,0), 
		"PRCA045" NUMBER(15,0), 
		"PRCA055" NUMBER(15,0), 
		"PRCA176" NUMBER(15,0), 
		"PRCA177" NUMBER(15,0), 
		"PRJA222" NUMBER(15,0)
		)
		'
		;
		
	END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1771_t1 ||''|| v_year ||''|| v_tasa_1771_t2 ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
	
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1771_t1 ||''|| v_year ||''|| v_tasa_1771_t2 ||''|| v_out ||'	
		(m003,m005,m045,m0581,praa002,praa008,praa035,prba013,prba015,prba021,prba028,
		prca004,prca007,prca037,/*prca047,*/prca053,prca054,prca103,prda024,prda076,prda088,
		prja122, /*praa001,*/ praa019, praa026, praa041, praa045, praa049, prba001, prba002, 
		PRBA030, PRBA036, PRBA050, PRBA051, PRCA003, PRCA015, PRCA019, PRCA020, PRCA027,
		PRCA031, PRCA044, PRCA045, PRCA055, PRCA176, PRCA177, PRJA222) 
		SELECT cc.m003,tt.m005,tt.m045,cc.m0581,tt.praa002,tt.praa008,tt.praa035,
		tt.prba013,tt.prba015,tt.prba021,tt.prba028,tt.prca004,tt.prca007,tt.prca037,
		/*tt.prca047,*/tt.prca053,tt.prca054,tt.prca103,tt.prda024,tt.prda076,tt.prda088,
		tt.PRJA122, /*praa001,*/ praa019, praa026, praa041, praa045, praa049, prba001, prba002, 
		prba030, prba036, prba050, prba051, prca003, prca015, prca019, prca020, prca027,
		PRCA031, PRCA044, PRCA045, PRCA055, PRCA176, PRCA177, PRJA222
		FROM '|| v_out_schema ||'.'|| v_ceglista_t ||' cc
		LEFT JOIN '|| v_in_schema ||'.'|| v_in ||''|| v_in_tasa_1771_t1 ||''|| v_year ||''|| v_in_tasa_1771_t2 ||' tt 
		ON tt.M003=cc.M003
		WHERE NOT tt.m003 IS NULL
		AND (cc.m0581 LIKE ''64%'' OR cc.m0581 LIKE ''65%'' OR cc.m0581 LIKE ''66%'')
		--and cc.m003 IN (23292637,23997349);
		'
		;
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A '|| v_out_schema ||'.'|| v_out_schema ||''|| v_tasa_1771_t1 ||''|| v_year ||''|| v_tasa_1771_t2 ||''|| v_out ||' tábla nem üres!');		
	
	END IF;
	
END IF;
	
END tasa_attoltes;
END;