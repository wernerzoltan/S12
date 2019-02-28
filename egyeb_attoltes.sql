-- Egyéb adatok áttöltése PR sémából

/*
create or replace PACKAGE a02_egyeb_ATTOLTES AUTHID CURRENT_USER AS 
procedure egyeb_attoltes;

END a02_egyeb_ATTOLTES;
-------
*/


create or replace PACKAGE BODY a02_egyeb_ATTOLTES AS 

is_data exception;
v_count NUMBER;
z NUMERIC;
v_e VARCHAR2(1);
v_betoltes VARCHAR2(10) := 'elozetes'; -- előzetes / végleges

sql_statement VARCHAR2(300);
TYPE t_teaor IS TABLE OF VARCHAR2(20);
v_teaor t_teaor;

TYPE t_sorkod IS TABLE OF VARCHAR2(10);
v_sorkod t_sorkod;

TYPE t_oszlopkod IS TABLE OF NUMBER;
v_oszlopkod t_oszlopkod;

-- futtatandó táblák
v_kata BOOLEAN := FALSE; -- KATA tábla import
v_kiva BOOLEAN := FALSE; -- KIVA tábla import
v_yf BOOLEAN := FALSE; -- KIVA tábla import
v_scv BOOLEAN := FALSE; -- SCV_ÁFA tábla import
v_mnb_mny BOOLEAN := FALSE; -- MNB_MNYP tábla import
v_mnb_eges BOOLEAN := FALSE; -- MNB_PENZT_EGESZ tábla import
v_mnb_fog BOOLEAN := FALSE; -- MNB_PENZT_FOGL tábla import
v_mnb_on BOOLEAN := FALSE; -- MNB_PENZT_ONK tábla import
v_mnb_pi BOOLEAN := FALSE; -- MNB_HIT_PIC tábla import
v_mnb_psza BOOLEAN := FALSE; -- PSZAF_1AN és PSZAF_1B tábla import
v_mnb_pen BOOLEAN := FALSE; -- PENZ_VALL tábla import
v_mnb_biz BOOLEAN := FALSE; -- W_BIZT tábla import
v_mnb_biz41a BOOLEAN := FALSE; -- W_BIZT_41A tábla import
v_mnb_be BOOLEAN := FALSE; -- w_bef_alap tábla import

-- input-output beállítások
v_ceglista_scv VARCHAR2(20) := 'CEGLISTA_SCV';
evszam VARCHAR2(10) := '2017'; -- futtatandó évszám
v_year VARCHAR2(2) := SUBSTR(evszam, 3);
v_out_schema VARCHAR2(10) := 'PP17'; -- output séma
v_in_schema VARCHAR2(10) := 'PR17'; -- egyéb input séma ÉLES
v_in_schema_yf VARCHAR2(10) := 'YF17'; -- YF input séma
v_in_schema_pc VARCHAR2(10) := 'PC17'; -- PC input séma
v_codes VARCHAR2(20) := 'CODES_LIST'; -- kódlista tábla

v_out VARCHAR2(5) := 'v01_T'; -- out tábla elnevezése TESZT
--v_out VARCHAR2(5) := 'v01'; -- out tábla elnevezése ÉLES
--v_in VARCHAR2(3) := 'W_E'; -- input tábla elnevezése (tesztelés során V táblákat is futtatunk)
v_in VARCHAR2(3) := 'W_V'; -- input tábla elnevezése

--KATA tábla:
v_in_kata_t1 VARCHAR2(20) := '_P'; -- KATA input tábla: W_V_P17KATA_V01
v_in_kata_t2 VARCHAR2(20) := 'KATA_V01'; -- KATA input tábla: W_V_P17KATA_V01
v_kata_t VARCHAR2(20) := '_KATA_'; -- KATA végtábla: pp17_kata_v01

--KIVA tábla:
v_in_kiva_t1 VARCHAR2(20) := '_P'; -- KATA input tábla: W_V_P17KATA_V01
v_in_kiva_t2 VARCHAR2(20) := 'KIVA_V01'; -- KATA input tábla: W_V_P17KATA_V01
v_kiva_t VARCHAR2(20) := '_KIVA_'; -- KATA végtábla: pp17_kiva_v01

--YF tábla:
v_in_yf_t1 VARCHAR2(20) := 'YFA_'; -- YF input tábla: YFA_17E_NSZ_V00
v_in_yf_t2 VARCHAR2(20) := '_NSZ_V00'; -- YF input tábla: YFA_17E_NSZ_V00
v_yf_t1 VARCHAR2(20) := 'YF'; -- YF végtábla: YF17_YFA_17E_HIT
v_yf_t2 VARCHAR2(20) := '_YFA_'; -- YF végtábla: YF17_YFA_17E_HIT
--v_yf_t3 VARCHAR2(20) := '_HIT'; -- YF végtábla: YF17_YFA_17E_HIT - ÉLES 
v_yf_t3 VARCHAR2(20) := '_HIT_t'; -- YF végtábla: YF17_YFA_17E_HIT_t - TESZT

--SCV ÁFA:
v_in_scv_t1 VARCHAR2(20) := 'pcf_afa_yf_'; -- SCV_ÁFA input tábla: pcf_afa_yf_17_v00
v_in_scv_t2 VARCHAR2(20) := '_v00'; -- SCV_ÁFA input tábla: pcf_afa_yf_17_v00
v_scv_t VARCHAR2(20) := '_scv_afa_'; -- SCV_ÁFA output tábla: pp17_scv_afa_v01


-- MNB
v_in_mnb VARCHAR2(20) := 'temp_pszafupdate'; -- MNB input tábla: temp_pszafupdate
v_mnb_temp VARCHAR2(20) := 'temp_sorkod'; -- MNB temp tábla

-- MNB / mnyp - OK
--v_mnb_mnyp VARCHAR2(20) := '_w_penzt_mnyp'; -- MNB_MNYP output tábla: pp17_w_penzt_mnyp ÉLES
v_mnb_mnyp VARCHAR2(20) := '_w_penzt_mnyp_t'; -- MNB_MNYP output tábla: pp17_w_penzt_mnyp TESZT

-- MNB / egesz
--v_mnb_egesz VARCHAR2(20) := '_W_PENZT_EGESZ'; -- MNB_EGESZ output tábla: pp17_w_penzt_egesz ÉLES
v_mnb_egesz VARCHAR2(20) := '_W_PENZT_EGESZ_T'; -- MNB_EGESZ output tábla: pp17_w_penzt_egesz TESZT

-- MNB / fogl
--v_mnb_fogl VARCHAR2(20) := '_W_PENZT_FOGL'; -- MNB_FOGL output tábla: PP17_W_PENZT_FOGL ÉLES
v_mnb_fogl VARCHAR2(20) := '_W_PENZT_FOGL_T'; -- MNB_FOGL output tábla: PP17_W_PENZT_FOGL TESZT

-- MNB / onk
--v_mnb_fogl VARCHAR2(20) := '_W_PENZT_ONK'; -- MNB_ONK output tábla: PP17_W_PENZT_ONK ÉLES
v_mnb_onk VARCHAR2(20) := '_W_PENZT_ONK_T'; -- MNB_ONK output tábla: PP17_W_PENZT_ONK TESZT

-- MNB / pic
--v_mnb_pic VARCHAR2(20) := '_W_HIT_pic'; -- MNB_ONK output tábla: PP17_W_HIT_pic ÉLES
v_mnb_pic VARCHAR2(20) := '_W_HIT_PIC_T'; -- MNB_ONK output tábla: PP17_W_HIT_pic TESZT

-- MNB / PSZAF_1AN
--v_pszaf_1an VARCHAR2(20) := 'HIT_PSZAF_1AN'; -- PSZAF_1AN output tábla: HIT_PSZAF_1AN ÉLES
v_pszaf_1an VARCHAR2(20) := '_HIT_PSZAF_1AN_T'; -- PSZAF_1AN output tábla: HIT_PSZAF_1AN TESZT

-- MNB / PSZAF_1B
--v_pszaf_1b VARCHAR2(20) := 'HIT_PSZAF_1B'; -- PSZAF_1AN output tábla: HIT_PSZAF_1B ÉLES
v_pszaf_1b VARCHAR2(20) := '_HIT_PSZAF_1B_T'; -- PSZAF_1AN output tábla: HIT_PSZAF_1B TESZT

-- MNB / PENZ_VALL
--v_penz_vall VARCHAR2(20) := '_W_PENZ_VALL'; -- PSZAF_1AN output tábla: PP17_W_PENZ_VALL ÉLES
v_penz_vall VARCHAR2(20) := '_W_PENZ_VALL_T'; -- PSZAF_1AN output tábla: PP17_W_PENZ_VALL TESZT

-- MNB / BIZT
--v_bizt VARCHAR2(20) := '_W_BIZT'; -- PSZAF_1AN output tábla: PP17_W_BIZT ÉLES
v_bizt VARCHAR2(20) := '_W_BIZT_T'; -- PSZAF_1AN output tábla: PP17_W_BIZT TESZT

-- MNB / BIZT41A
--v_bizt41a VARCHAR2(20) := '_W_BIZT_41A'; -- PSZAF_1AN output tábla: PP17_W_BIZT_41A ÉLES
v_bizt41a VARCHAR2(20) := '_W_BIZT_41A_T'; -- PSZAF_1AN output tábla: PP17_W_BIZT_41A TESZT

-- MNB / BEF_ALAP
--v_befalap VARCHAR2(20) := '_w_bef_alap'; -- PSZAF_1AN output tábla: PP17_W_BEF_ALAP ÉLES
v_befalap VARCHAR2(20) := '_w_bef_alap_T'; -- PSZAF_1AN output tábla: PP17_W_BEF_ALAP TESZT

procedure egyeb_attoltes AS

BEGIN

IF v_betoltes = 'elozetes' THEN
	v_e := 'E';
	ELSE 
	v_e := 'V';
END IF;

IF v_kata = TRUE THEN

-- KATA tábla import
SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_kata_t ||''|| v_out ||'' ';
	
	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_kata_t ||''|| v_out ||'
		("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"M0491" NUMBER, 
		"M005" VARCHAR2(2 BYTE), 
		"M045" VARCHAR2(2 BYTE), 
		"M065" VARCHAR2(2 BYTE), 
		"PRCA054" NUMBER, 
		"PRCA103" NUMBER, 
		"PRCA152" NUMBER, 
		"PRJA215" NUMBER
		)
		'
		;
		
		END IF;
		*/

		
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_kata_t ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_kata_t ||''|| v_out ||'
		(m003, m0581, m0491, m005, m045, m065, prca054, prca103, prca152, prja215) 
		SELECT m003, m0581, m0491, m005, m045, m065, prca054, prca103, prca152, prja215
		from '|| v_in_schema ||'.'|| v_in ||''|| v_in_kata_t1 ||''|| v_year ||''|| v_in_kata_t2 ||'
		WHERE m0581 > 6400 AND m0581 < 6699
		'
		;
		
		
	ELSE 
	
		raise is_data;
	
	END IF;

END IF;


IF v_kiva = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_kiva_t ||''|| v_out ||'' ';
	
	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_kiva_t ||''|| v_out ||'
		("M003" VARCHAR2(8 BYTE), 
		"M0581" VARCHAR2(4 BYTE), 
		"M0491" NUMBER, 
		"M005" VARCHAR2(2 BYTE), 
		"M045" VARCHAR2(2 BYTE), 
		"PRCA016" NUMBER, 
		"PRJA216" NUMBER, 
		"PRJA217" NUMBER, 
		"PRCA035" NUMBER, 
		"PRCA057" NUMBER, 
		"PRCA054" NUMBER, 
		"PRDA112" NUMBER, 
		"PRJA122" NUMBER, 
		"PRCA155" NUMBER, 
		"PRJA257" NUMBER
		)
		'
		;
	*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_kiva_t ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_kiva_t ||''|| v_out ||'
		(m003, m0581, m0491, m005, m045, prca016, prja216, prja217, prca035, prca057, prca054, prda112,
        prja122, prca155, PRJA257)
		SELECT m003, m0581, m0491, m005, m045, prca016, prja216, prja217, prca035, prca057, prca054, prda112,
        prja122, prca155, PRJA257
		FROM '|| v_in_schema ||'.'|| v_in ||''|| v_in_kiva_t1 ||''|| v_year ||''|| v_in_kiva_t2 ||'
		WHERE m0581 > 6400 AND m0581 < 6699
		'
		;
	
	ELSE 
	
		raise is_data;	
			
	END IF;
	
END IF;

IF v_yf = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_yf_t1 ||''|| v_year ||''|| v_yf_t2 ||''|| v_year ||''|| v_e ||''|| v_yf_t3 ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_yf_t1 ||''|| v_year ||''|| v_yf_t2 ||''|| v_year ||''|| v_e ||''|| v_yf_t3 ||'
		("M003" VARCHAR2(10 BYTE), 
		"M0581" VARCHAR2(20 BYTE), 
		"SBS" VARCHAR2(20 BYTE), 
		"YFAB172" NUMBER, 
		"YFAL010" NUMBER, 
		"YFAL011" NUMBER, 
		"YFAL019" NUMBER, 
		"YFAL012" NUMBER
		) 
		'
		;
	
		END IF;
	*/ 

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_yf_t1 ||''|| v_year ||''|| v_yf_t2 ||''|| v_year ||''|| v_e ||''|| v_yf_t3 ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_yf_t1 ||''|| v_year ||''|| v_yf_t2 ||''|| v_year ||''|| v_e ||''|| v_yf_t3 ||'
		(m003, m0581, sbs, YFAB172, YFAL010, YFAL011, YFAL019, YFAL012)
		SELECT m003, m0581, sbs, YFAB172, YFAL010, YFAL011, YFAL019, YFAL012
		FROM '|| v_in_schema_yf ||'.'|| v_in_yf_t1 ||''|| v_year ||''|| v_e ||''|| v_in_yf_t2 ||'
		WHERE m0581 IN (''6419'', ''6491'') AND sbs=''1''
		'
		;
	
	ELSE 
	
		raise is_data;	
	
	END IF;
	
END IF;
		

IF v_scv = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_scv_t ||''|| v_out ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_scv_t ||''|| v_out ||'
		("MEV" VARCHAR2(20 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PCFB031" NUMBER(15,0), 
		"PCFB040" NUMBER(15,0), 
		"PCFB066" NUMBER(15,0), 
		"PCFB070" NUMBER(15,0), 
		"PCFB036" NUMBER(15,0), 
		"OSSZEG" NUMBER(20,0)
		)
		END IF;
		*/

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_t ||''|| v_out ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_scv_t ||''|| v_out ||'
		(mev,m003,pcfb031,pcfb040,pcfb066,pcfb070,pcfb036,osszeg)
		SELECT
		'''|| evszam ||''', m003, pcfb031, pcfb040, pcfb066, pcfb070, pcfb036,
		(pcfb031+pcfb040+pcfb066+pcfb070+pcfb036) as osszeg 
		FROM
		(select 
		max(m003) as m003,
		sum(nvl(pcfb031,0)) as pcfb031,
		sum(nvl(pcfb040,0)) as pcfb040,
		sum(nvl(pcfb066,0)) as pcfb066,
		sum(nvl(pcfb070,0)) as pcfb070,
		SUM(nvl(pcfb036,0)) AS pcfb036
		FROM '|| v_in_schema_pc ||'.'|| v_in_scv_t1 ||''|| v_year ||''|| v_in_scv_t2 ||'
		GROUP BY m003) 
		WHERE m003 IN (select m003 from '|| v_out_schema ||'.'||v_ceglista_scv ||')
		'
		;	
	
	ELSE 

		raise is_data;	
	
	END IF;	

END IF;


IF v_mnb_mny = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_mnyp ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_mnyp ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PMA001" NUMBER(15,0), 
		"PMA010" NUMBER(15,0), 
		"PMA011" NUMBER(15,0), 
		"PMA014" NUMBER(15,0), 
		"PMA015" NUMBER(15,0), 
		"PMA016" NUMBER(15,0), 
		"PMA022" NUMBER(15,0), 
		"PMA025" NUMBER(15,0), 
		"PMA026" NUMBER(15,0), 
		"PMA027" NUMBER(15,0), 
		"PMA028" NUMBER(15,0), 
		"PMA034" NUMBER(15,0), 
		"PMA037" NUMBER(15,0), 
		"PMA040" NUMBER(15,0), 
		"PMA041" NUMBER(15,0), 
		"PMA046" NUMBER(15,0), 
		"PMA1000" NUMBER(15,0), 
		"PMA1007" NUMBER(15,0), 
		"PMA1008" NUMBER(15,0), 
		"PMA1009" NUMBER(15,0), 
		"PMA1012" NUMBER(15,0), 
		"PMA1013" NUMBER(15,0), 
		"PMA1014" NUMBER(15,0), 
		"PMA1015" NUMBER(15,0), 
		"PMA1017" NUMBER(15,0), 
		"PMA1041" NUMBER(15,0), 
		"PMA1042" NUMBER(15,0), 
		"PMA1043" NUMBER(15,0), 
		"PMA1044" NUMBER(15,0), 
		"PMA1045" NUMBER(15,0), 
		"PMA1046" NUMBER(15,0), 
		"PMA1048" NUMBER(15,0), 
		"PMA1058" NUMBER(15,0), 
		"PMA1059" NUMBER(15,0), 
		"PMA1060" NUMBER(15,0), 
		"PMA1061" NUMBER(15,0), 
		"PMA1062" NUMBER(15,0), 
		"PMA1063" NUMBER(15,0), 
		"PMA1064" NUMBER(15,0), 
		"PMA1065" NUMBER(15,0), 
		"PMA1066" NUMBER(15,0), 
		"PMA1067" NUMBER(15,0), 
		"PMA1068" NUMBER(15,0), 
		"PMA1069" NUMBER(15,0), 
		"PMA1070" NUMBER(15,0), 
		"PMA1071" NUMBER(15,0), 
		"PMA1072" NUMBER(15,0), 
		"PMA1073" NUMBER(15,0), 
		"PMA1074" NUMBER(15,0), 
		"PMA1076" NUMBER(15,0), 
		"PMA1077" NUMBER(15,0), 
		"PMA149" NUMBER(15,0), 
		"PMA157" NUMBER(15,0), 
		"PMA160" NUMBER(15,0), 
		"PMA171" NUMBER(15,0), 
		"PMA172" NUMBER(15,0), 
		"PMA173" NUMBER(15,0), 
		"PMA177" NUMBER(15,0), 
		"PMA200" NUMBER(15,0), 
		"PMA210" NUMBER(15,0), 
		"PMA211" NUMBER(15,0), 
		"PMA213" NUMBER(15,0), 
		"PMA214" NUMBER(15,0), 
		"PMA215" NUMBER(15,0), 
		"PMAOM000" NUMBER(15,0), 
		"PMAOM001" NUMBER(15,0), 
		"PMAOM002" NUMBER(15,0), 
		"PMAOM008" NUMBER(15,0), 
		"PMAOM009" NUMBER(15,0), 
		"PMAOM013" NUMBER(15,0), 
		"PMAOM014" NUMBER(15,0), 
		"PMAOM018" NUMBER(15,0), 
		"PMAOM019" NUMBER(15,0), 
		"PMAOM025" NUMBER(15,0), 
		"PMAOM026" NUMBER(15,0), 
		"PMAOM035" NUMBER(15,0), 
		"PMAOM041" NUMBER(15,0), 
		"PMAOM045" NUMBER(15,0), 
		"PMAOM048" NUMBER(15,0), 
		"PMAOM058" NUMBER(15,0), 
		"PMAOM801" NUMBER(15,0), 
		"PMAOM802" NUMBER(15,0), 
		"PMAOM803" NUMBER(15,0), 
		"PMAOM900" NUMBER(15,0), 
		"PMAOM902" NUMBER(15,0), 
		"PMAOM903" NUMBER(15,0), 
		"PMAOM904" NUMBER(15,0), 
		"PMAOM907" NUMBER(15,0), 
		"PMAOM908" NUMBER(15,0), 
		"PMAOM909" NUMBER(15,0), 
		"PMAOM912" NUMBER(15,0), 
		"PMAOM913" NUMBER(15,0), 
		"PMAOM914" NUMBER(15,0), 
		"PMAOM915" NUMBER(15,0), 
		"PMAOM918" NUMBER(15,0), 
		"PMAOM919" NUMBER(15,0), 
		"PMAOM920" NUMBER(15,0), 
		"PMAOM921" NUMBER(15,0), 
		"PMAOM922" NUMBER(15,0), 
		"PMAOM923" NUMBER(15,0), 
		"PMAOM924" NUMBER(15,0), 
		"PMAOM925" NUMBER(15,0), 
		"PMAOM926" NUMBER(15,0), 
		"PMAOM927" NUMBER(15,0), 
		"PMAOM928" NUMBER(15,0), 
		"PMB001" NUMBER(15,0), 
		"PMB010" NUMBER(15,0), 
		"PMB011" NUMBER(15,0), 
		"PMB014" NUMBER(15,0), 
		"PMB015" NUMBER(15,0), 
		"PMB016" NUMBER(15,0), 
		"PMB034" NUMBER(15,0), 
		"PMB037" NUMBER(15,0), 
		"PMB041" NUMBER(15,0), 
		"PMB1007" NUMBER(15,0), 
		"PMB1008" NUMBER(15,0), 
		"PMB1009" NUMBER(15,0), 
		"PMB1012" NUMBER(15,0), 
		"PMB1013" NUMBER(15,0), 
		"PMB1014" NUMBER(15,0), 
		"PMB1017" NUMBER(15,0), 
		"PMB1041" NUMBER(15,0), 
		"PMB1043" NUMBER(15,0), 
		"PMB1044" NUMBER(15,0), 
		"PMB1047" NUMBER(15,0), 
		"PMB1049" NUMBER(15,0), 
		"PMB1050" NUMBER(15,0), 
		"PMB1051" NUMBER(15,0), 
		"PMB1052" NUMBER(15,0), 
		"PMB1053" NUMBER(15,0), 
		"PMB1054" NUMBER(15,0), 
		"PMB1055" NUMBER(15,0), 
		"PMB1056" NUMBER(15,0), 
		"PMB1057" NUMBER(15,0), 
		"PMB1064" NUMBER(15,0), 
		"PMB1065" NUMBER(15,0), 
		"PMB1066" NUMBER(15,0), 
		"PMB1067" NUMBER(15,0), 
		"PMB1068" NUMBER(15,0), 
		"PMB1070" NUMBER(15,0), 
		"PMB1071" NUMBER(15,0), 
		"PMB1074" NUMBER(15,0), 
		"PMB200" NUMBER(15,0), 
		"PMB210" NUMBER(15,0), 
		"PMB211" NUMBER(15,0), 
		"PMB213" NUMBER(15,0), 
		"PMB214" NUMBER(15,0), 
		"PMBOM000" NUMBER(15,0), 
		"PMBOM001" NUMBER(15,0), 
		"PMBOM012" NUMBER(15,0), 
		"PMBOM016" NUMBER(15,0), 
		"PMBOM020" NUMBER(15,0), 
		"PMBOM021" NUMBER(15,0), 
		"PMBOM028" NUMBER(15,0), 
		"PMBOM034" NUMBER(15,0), 
		"PMBOM044" NUMBER(15,0), 
		"PMBOM801" NUMBER(15,0), 
		"PMBOM805" NUMBER(15,0), 
		"PMBOM806" NUMBER(15,0), 
		"PMBOM811" NUMBER(15,0), 
		"PMBOM812" NUMBER(15,0), 
		"PMBOM815" NUMBER(15,0), 
		"PMBOM816" NUMBER(15,0), 
		"PMBOM818" NUMBER(15,0), 
		"PMBOM822" NUMBER(15,0), 
		"PMBOM823" NUMBER(15,0), 
		"PMBOM824" NUMBER(15,0), 
		"PMBOM829" NUMBER(15,0), 
		"PMBOM830" NUMBER(15,0), 
		"PMBOM831" NUMBER(15,0), 
		"PMBOM832" NUMBER(15,0), 
		"PMBOM833" NUMBER(15,0), 
		"PMBOM834" NUMBER(15,0), 
		"PMBOM835" NUMBER(15,0), 
		"PMBOM836" NUMBER(15,0), 
		"PMBOM840" NUMBER(15,0), 
		"PMC001" NUMBER(15,0), 
		"PMC010" NUMBER(15,0), 
		"PMC011" NUMBER(15,0), 
		"PMC014" NUMBER(15,0), 
		"PMC015" NUMBER(15,0), 
		"PMC016" NUMBER(15,0), 
		"PMC034" NUMBER(15,0), 
		"PMC037" NUMBER(15,0), 
		"PMC041" NUMBER(15,0), 
		"PMC1007" NUMBER(15,0), 
		"PMC1008" NUMBER(15,0), 
		"PMC1009" NUMBER(15,0), 
		"PMC1012" NUMBER(15,0), 
		"PMC1013" NUMBER(15,0), 
		"PMC1014" NUMBER(15,0), 
		"PMC1017" NUMBER(15,0), 
		"PMC1041" NUMBER(15,0), 
		"PMC1043" NUMBER(15,0), 
		"PMC1044" NUMBER(15,0), 
		"PMC1064" NUMBER(15,0), 
		"PMC1065" NUMBER(15,0), 
		"PMC1066" NUMBER(15,0), 
		"PMC1067" NUMBER(15,0), 
		"PMC1068" NUMBER(15,0), 
		"PMC1069" NUMBER(15,0), 
		"PMC1070" NUMBER(15,0), 
		"PMC1074" NUMBER(15,0), 
		"PMC200" NUMBER(15,0), 
		"PMC210" NUMBER(15,0), 
		"PMC211" NUMBER(15,0), 
		"PMC213" NUMBER(15,0), 
		"PMC214" NUMBER(15,0), 
		"PMD001" NUMBER(15,0), 
		"PMD002" NUMBER(15,0), 
		"PMD003" NUMBER(15,0), 
		"PMD004" NUMBER(15,0), 
		"PMD005" NUMBER(15,0), 
		"PMD006" NUMBER(15,0), 
		"PMD007" NUMBER(15,0), 
		"PMD008" NUMBER(15,0), 
		"PMD009" NUMBER(15,0), 
		"PMD010" NUMBER(15,0), 
		"PMD011" NUMBER(15,0), 
		"PMD012" NUMBER(15,0), 
		"PMD013" NUMBER(15,0), 
		"PMD014" NUMBER(15,0), 
		"PMD015" NUMBER(15,0), 
		"PMD016" NUMBER(15,0), 
		"PMD017" NUMBER(15,0), 
		"PMD018" NUMBER(15,0), 
		"PMD019" NUMBER(15,0), 
		"PMD020" NUMBER(15,0), 
		"PMD021" NUMBER(15,0), 
		"PMD022" NUMBER(15,0), 
		"PMD027" NUMBER(15,0), 
		"PMD041" NUMBER(15,0), 
		"PMD044" NUMBER(15,0), 
		"PMD049" NUMBER(15,0), 
		"PMD052" NUMBER(15,0), 
		"PMD055" NUMBER(15,0), 
		"PMD065" NUMBER(15,0), 
		"PMD077" NUMBER(15,0), 
		"PMD078" NUMBER(15,0), 
		"PMD079" NUMBER(15,0), 
		"PMD080" NUMBER(15,0), 
		"PMD081" NUMBER(15,0), 
		"PMD082" NUMBER(15,0), 
		"PMD083" NUMBER(15,0), 
		"PMD084" NUMBER(15,0), 
		"PMD085" NUMBER(15,0), 
		"PMD086" NUMBER(15,0), 
		"PMD087" NUMBER(15,0), 
		"PMD088" NUMBER(15,0), 
		"PMD089" NUMBER(15,0), 
		"PMD090" NUMBER(15,0), 
		"PMEA001" NUMBER(15,0), 
		"PMEA002" NUMBER(15,0), 
		"PMEA003" NUMBER(15,0), 
		"PMEA004" NUMBER(15,0), 
		"PMEA005" NUMBER(15,0), 
		"PMEA006" NUMBER(15,0), 
		"PMEA007" NUMBER(15,0), 
		"PMEA008" NUMBER(15,0), 
		"PMEA009" NUMBER(15,0), 
		"PMEA010" NUMBER(15,0), 
		"PMEA011" NUMBER(15,0), 
		"PMEA012" NUMBER(15,0), 
		"PMEA013" NUMBER(15,0), 
		"PMEA014" NUMBER(15,0), 
		"PMEA015" NUMBER(15,0), 
		"PMEA016" NUMBER(15,0), 
		"PMEA017" NUMBER(15,0), 
		"PMEA018" NUMBER(15,0), 
		"PMF001" NUMBER(15,0), 
		"PMF004" NUMBER(15,0)
		)
		'
		;
		
		END IF;
	*/
		

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''mnyp'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''mnyp'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;	

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_mnb_mnyp ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;

	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_mnb_mnyp, ''|| evszam ||'');
	
		
	ELSE 

		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_mnb_mnyp ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;

END IF;
		
	
IF v_mnb_eges = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_egesz ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_egesz ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PEAOM000" NUMBER(15,0), 
		"PEAOM001" NUMBER(15,0), 
		"PEAOM002" NUMBER(15,0), 
		"PEAOM008" NUMBER(15,0), 
		"PEAOM009" NUMBER(15,0), 
		"PEAOM013" NUMBER(15,0), 
		"PEAOM014" NUMBER(15,0), 
		"PEAOM018" NUMBER(15,0), 
		"PEAOM019" NUMBER(15,0), 
		"PEAOM024" NUMBER(15,0), 
		"PEAOM025" NUMBER(15,0), 
		"PEAOM026" NUMBER(15,0), 
		"PEAOM035" NUMBER(15,0), 
		"PEAOM041" NUMBER(15,0), 
		"PEAOM045" NUMBER(15,0), 
		"PEAOM801" NUMBER(15,0), 
		"PEAOM819" NUMBER(15,0), 
		"PEAOM820" NUMBER(15,0), 
		"PEAOM821" NUMBER(15,0), 
		"PEAOM822" NUMBER(15,0), 
		"PEBOM000" NUMBER(15,0), 
		"PEBOM001" NUMBER(15,0), 
		"PEBOM020" NUMBER(15,0), 
		"PEBOM028" NUMBER(15,0), 
		"PEBOM035" NUMBER(15,0), 
		"PEBOM801" NUMBER(15,0), 
		"PEBOM805" NUMBER(15,0), 
		"PEBOM809" NUMBER(15,0), 
		"PEBOM810" NUMBER(15,0), 
		"PEBOM816" NUMBER(15,0), 
		"PEBOM819" NUMBER(15,0), 
		"PEBOM826" NUMBER(15,0), 
		"PEC001" NUMBER(15,0), 
		"PEC002" NUMBER(15,0), 
		"PEC005" NUMBER(15,0), 
		"PEC006" NUMBER(15,0), 
		"PEC008" NUMBER(15,0), 
		"PEC012" NUMBER(15,0), 
		"PEC013" NUMBER(15,0), 
		"PEC018" NUMBER(15,0), 
		"PEC019" NUMBER(15,0), 
		"PEC022" NUMBER(15,0), 
		"PEC023" NUMBER(15,0), 
		"PEC025" NUMBER(15,0), 
		"PEC036" NUMBER(15,0), 
		"PEC038" NUMBER(15,0), 
		"PEC039" NUMBER(15,0), 
		"PEC040" NUMBER(15,0), 
		"PEC041" NUMBER(15,0), 
		"PEC042" NUMBER(15,0), 
		"PEC045" NUMBER(15,0), 
		"PEC046" NUMBER(15,0), 
		"PEC047" NUMBER(15,0), 
		"PEC061" NUMBER(15,0), 
		"PEC062" NUMBER(15,0), 
		"PEC063" NUMBER(15,0), 
		"PEC064" NUMBER(15,0), 
		"PEC065" NUMBER(15,0), 
		"PEC066" NUMBER(15,0), 
		"PEC067" NUMBER(15,0), 
		"PEC068" NUMBER(15,0), 
		"PEC069" NUMBER(15,0), 
		"PEC070" NUMBER(15,0), 
		"PEC071" NUMBER(15,0), 
		"PEC072" NUMBER(15,0), 
		"PEC073" NUMBER(15,0), 
		"PEC074" NUMBER(15,0), 
		"PEC075" NUMBER(15,0), 
		"PEC076" NUMBER(15,0), 
		"PEC077" NUMBER(15,0), 
		"PEC078" NUMBER(15,0), 
		"PEC079" NUMBER(15,0), 
		"PEE001" NUMBER(15,0), 
		"PEE002" NUMBER(15,0), 
		"PEE003" NUMBER(15,0), 
		"PEE004" NUMBER(15,0)
		) 
		'
		;
		
		END IF;
	*/

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''egesz'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''egesz'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;	

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_mnb_egesz ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_mnb_egesz, ''|| evszam ||'');
		
	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_mnb_egesz ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;
	
END IF;


IF v_mnb_fog = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_fogl ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_fogl ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"FOA001" NUMBER(15,0), 
		"FOA002" NUMBER(15,0), 
		"FOA003" NUMBER(15,0), 
		"FOA004" NUMBER(15,0), 
		"FOA005" NUMBER(15,0), 
		"FOA010" NUMBER(15,0), 
		"FOA011" NUMBER(15,0), 
		"FOA012" NUMBER(15,0), 
		"FOA013" NUMBER(15,0), 
		"FOA014" NUMBER(15,0), 
		"FOA015" NUMBER(15,0), 
		"FOA016" NUMBER(15,0), 
		"FOA017" NUMBER(15,0), 
		"FOA018" NUMBER(15,0), 
		"FOA019" NUMBER(15,0), 
		"FOA020" NUMBER(15,0), 
		"FOA021" NUMBER(15,0), 
		"FOA023" NUMBER(15,0), 
		"FOA024" NUMBER(15,0), 
		"FOA025" NUMBER(15,0), 
		"FOA026" NUMBER(15,0), 
		"FOA027" NUMBER(15,0), 
		"FOA028" NUMBER(15,0), 
		"FOA029" NUMBER(15,0), 
		"FOA031" NUMBER(15,0), 
		"FOA032" NUMBER(15,0), 
		"FOA033" NUMBER(15,0), 
		"FOA034" NUMBER(15,0), 
		"FOA035" NUMBER(15,0), 
		"FOA036" NUMBER(15,0), 
		"FOA037" NUMBER(15,0), 
		"FOA038" NUMBER(15,0), 
		"FOA039" NUMBER(15,0), 
		"FOA041" NUMBER(15,0), 
		"FOA042" NUMBER(15,0), 
		"FOA043" NUMBER(15,0), 
		"FOA044" NUMBER(15,0), 
		"FOA050" NUMBER(15,0), 
		"FOA051" NUMBER(15,0), 
		"FOA1014" NUMBER(15,0), 
		"FOA1060" NUMBER(15,0), 
		"FOA213" NUMBER(15,0), 
		"FOA214" NUMBER(15,0), 
		"FOB001" NUMBER(15,0), 
		"FOB002" NUMBER(15,0), 
		"FOB004" NUMBER(15,0), 
		"FOB005" NUMBER(15,0), 
		"FOB010" NUMBER(15,0), 
		"FOB011" NUMBER(15,0), 
		"FOB014" NUMBER(15,0), 
		"FOB015" NUMBER(15,0), 
		"FOB016" NUMBER(15,0), 
		"FOB018" NUMBER(15,0), 
		"FOB019" NUMBER(15,0), 
		"FOB020" NUMBER(15,0), 
		"FOB021" NUMBER(15,0), 
		"FOB023" NUMBER(15,0), 
		"FOB024" NUMBER(15,0), 
		"FOB025" NUMBER(15,0), 
		"FOB026" NUMBER(15,0), 
		"FOB027" NUMBER(15,0), 
		"FOB028" NUMBER(15,0), 
		"FOB029" NUMBER(15,0), 
		"FOB030" NUMBER(15,0), 
		"FOB034" NUMBER(15,0), 
		"FOB037" NUMBER(15,0), 
		"FOB052" NUMBER(15,0), 
		"FOB053" NUMBER(15,0), 
		"FOB054" NUMBER(15,0), 
		"FOB055" NUMBER(15,0), 
		"FOB1014" NUMBER(15,0), 
		"FOB1060" NUMBER(15,0), 
		"FOB213" NUMBER(15,0), 
		"FOB214" NUMBER(15,0), 
		"FOC001" NUMBER(15,0), 
		"FOC002" NUMBER(15,0), 
		"FOC003" NUMBER(15,0), 
		"FOC004" NUMBER(15,0), 
		"FOC005" NUMBER(15,0), 
		"FOC010" NUMBER(15,0), 
		"FOC011" NUMBER(15,0), 
		"FOC014" NUMBER(15,0), 
		"FOC015" NUMBER(15,0), 
		"FOC016" NUMBER(15,0), 
		"FOC017" NUMBER(15,0), 
		"FOC018" NUMBER(15,0), 
		"FOC019" NUMBER(15,0), 
		"FOC020" NUMBER(15,0), 
		"FOC021" NUMBER(15,0), 
		"FOC023" NUMBER(15,0), 
		"FOC024" NUMBER(15,0), 
		"FOC025" NUMBER(15,0), 
		"FOC026" NUMBER(15,0), 
		"FOC027" NUMBER(15,0), 
		"FOC028" NUMBER(15,0), 
		"FOC029" NUMBER(15,0), 
		"FOC034" NUMBER(15,0), 
		"FOC037" NUMBER(15,0), 
		"FOC056" NUMBER(15,0), 
		"FOC057" NUMBER(15,0), 
		"FOC058" NUMBER(15,0), 
		"FOC059" NUMBER(15,0), 
		"FOC060" NUMBER(15,0), 
		"FOC061" NUMBER(15,0), 
		"FOC062" NUMBER(15,0), 
		"FOC063" NUMBER(15,0), 
		"FOC064" NUMBER(15,0), 
		"FOC065" NUMBER(15,0), 
		"FOC1014" NUMBER(15,0), 
		"FOC1060" NUMBER(15,0), 
		"FOC213" NUMBER(15,0), 
		"FOC214" NUMBER(15,0), 
		"FOD001" NUMBER(15,0), 
		"FOD002" NUMBER(15,0), 
		"FOD003" NUMBER(15,0), 
		"FOD004" NUMBER(15,0), 
		"FOD005" NUMBER(15,0), 
		"FOD010" NUMBER(15,0), 
		"FOD011" NUMBER(15,0), 
		"FOD014" NUMBER(15,0), 
		"FOD015" NUMBER(15,0), 
		"FOD016" NUMBER(15,0), 
		"FOD017" NUMBER(15,0), 
		"FOD018" NUMBER(15,0), 
		"FOD019" NUMBER(15,0), 
		"FOD020" NUMBER(15,0), 
		"FOD021" NUMBER(15,0), 
		"FOD023" NUMBER(15,0), 
		"FOD024" NUMBER(15,0), 
		"FOD025" NUMBER(15,0), 
		"FOD026" NUMBER(15,0), 
		"FOD027" NUMBER(15,0), 
		"FOD028" NUMBER(15,0), 
		"FOD029" NUMBER(15,0), 
		"FOD030" NUMBER(15,0), 
		"FOD034" NUMBER(15,0), 
		"FOD037" NUMBER(15,0), 
		"FOD066" NUMBER(15,0), 
		"FOD067" NUMBER(15,0), 
		"FOD068" NUMBER(15,0), 
		"FOD069" NUMBER(15,0), 
		"FOD070" NUMBER(15,0), 
		"FOD071" NUMBER(15,0), 
		"FOD072" NUMBER(15,0), 
		"FOD073" NUMBER(15,0), 
		"FOD074" NUMBER(15,0), 
		"FOD075" NUMBER(15,0), 
		"FOD076" NUMBER(15,0), 
		"FOD077" NUMBER(15,0), 
		"FOD078" NUMBER(15,0), 
		"FOD079" NUMBER(15,0), 
		"FOD1014" NUMBER(15,0), 
		"FOD1060" NUMBER(15,0), 
		"FOD213" NUMBER(15,0), 
		"FOD214" NUMBER(15,0), 
		"FOE001" NUMBER(15,0), 
		"FOE002" NUMBER(15,0), 
		"FOE004" NUMBER(15,0), 
		"FOE005" NUMBER(15,0), 
		"FOE006" NUMBER(15,0), 
		"FOE007" NUMBER(15,0), 
		"FOE008" NUMBER(15,0), 
		"FOE009" NUMBER(15,0), 
		"FOE010" NUMBER(15,0), 
		"FOE011" NUMBER(15,0), 
		"FOE014" NUMBER(15,0), 
		"FOE015" NUMBER(15,0), 
		"FOE016" NUMBER(15,0), 
		"FOE018" NUMBER(15,0), 
		"FOE019" NUMBER(15,0), 
		"FOE020" NUMBER(15,0), 
		"FOE021" NUMBER(15,0), 
		"FOE022" NUMBER(15,0), 
		"FOE023" NUMBER(15,0), 
		"FOE024" NUMBER(15,0), 
		"FOE025" NUMBER(15,0), 
		"FOE026" NUMBER(15,0), 
		"FOE027" NUMBER(15,0), 
		"FOE028" NUMBER(15,0), 
		"FOE029" NUMBER(15,0), 
		"FOE030" NUMBER(15,0), 
		"FOE034" NUMBER(15,0), 
		"FOE037" NUMBER(15,0), 
		"FOE040" NUMBER(15,0), 
		"FOE080" NUMBER(15,0), 
		"FOE081" NUMBER(15,0), 
		"FOE082" NUMBER(15,0), 
		"FOE083" NUMBER(15,0), 
		"FOE084" NUMBER(15,0), 
		"FOE085" NUMBER(15,0), 
		"FOE086" NUMBER(15,0), 
		"FOE087" NUMBER(15,0), 
		"FOE088" NUMBER(15,0), 
		"FOE089" NUMBER(15,0), 
		"FOE090" NUMBER(15,0), 
		"FOE091" NUMBER(15,0), 
		"FOE092" NUMBER(15,0), 
		"FOE093" NUMBER(15,0), 
		"FOE094" NUMBER(15,0), 
		"FOE095" NUMBER(15,0), 
		"FOE096" NUMBER(15,0), 
		"FOE097" NUMBER(15,0), 
		"FOE098" NUMBER(15,0), 
		"FOE099" NUMBER(15,0), 
		"FOE100" NUMBER(15,0), 
		"FOE101" NUMBER(15,0), 
		"FOE1014" NUMBER(15,0), 
		"FOE1060" NUMBER(15,0), 
		"FOE213" NUMBER(15,0), 
		"FOE214" NUMBER(15,0), 
		"FOE215" NUMBER(15,0)
		)
		'
		;
		
		END IF;
	*/

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''fogl'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''fogl'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		
	
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_mnb_fogl ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_mnb_fogl, ''|| evszam ||'');
		
	ELSE 
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_mnb_fogl ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;

	
END IF;



IF v_mnb_on = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_onk ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_onk ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PNAOM000" NUMBER(15,0), 
		"PNAOM001" NUMBER(15,0), 
		"PNAOM002" NUMBER(15,0), 
		"PNAOM008" NUMBER(15,0), 
		"PNAOM009" NUMBER(15,0), 
		"PNAOM013" NUMBER(15,0), 
		"PNAOM014" NUMBER(15,0), 
		"PNAOM018" NUMBER(15,0), 
		"PNAOM019" NUMBER(15,0), 
		"PNAOM025" NUMBER(15,0), 
		"PNAOM026" NUMBER(15,0), 
		"PNAOM035" NUMBER(15,0), 
		"PNAOM041" NUMBER(15,0), 
		"PNAOM045" NUMBER(15,0), 
		"PNAOM048" NUMBER(15,0), 
		"PNAOM058" NUMBER(15,0), 
		"PNAOM1000" NUMBER(15,0), 
		"PNAOM1002" NUMBER(15,0), 
		"PNAOM1003" NUMBER(15,0), 
		"PNAOM1004" NUMBER(15,0), 
		"PNAOM1007" NUMBER(15,0), 
		"PNAOM1008" NUMBER(15,0), 
		"PNAOM1009" NUMBER(15,0), 
		"PNAOM1012" NUMBER(15,0), 
		"PNAOM1013" NUMBER(15,0), 
		"PNAOM1014" NUMBER(15,0), 
		"PNAOM1015" NUMBER(15,0), 
		"PNAOM1018" NUMBER(15,0), 
		"PNAOM1019" NUMBER(15,0), 
		"PNAOM1020" NUMBER(15,0), 
		"PNAOM1021" NUMBER(15,0), 
		"PNAOM1022" NUMBER(15,0), 
		"PNAOM1023" NUMBER(15,0), 
		"PNAOM1024" NUMBER(15,0), 
		"PNAOM1025" NUMBER(15,0), 
		"PNAOM1026" NUMBER(15,0), 
		"PNAOM1027" NUMBER(15,0), 
		"PNAOM801" NUMBER(15,0), 
		"PNAOM802" NUMBER(15,0), 
		"PNAOM803" NUMBER(15,0), 
		"PNBOM000" NUMBER(15,0), 
		"PNBOM001" NUMBER(15,0), 
		"PNBOM012" NUMBER(15,0), 
		"PNBOM016" NUMBER(15,0), 
		"PNBOM020" NUMBER(15,0), 
		"PNBOM021" NUMBER(15,0), 
		"PNBOM028" NUMBER(15,0), 
		"PNBOM034" NUMBER(15,0), 
		"PNBOM044" NUMBER(15,0), 
		"PNBOM205" NUMBER(15,0), 
		"PNBOM801" NUMBER(15,0), 
		"PNBOM805" NUMBER(15,0), 
		"PNBOM806" NUMBER(15,0), 
		"PNBOM811" NUMBER(15,0), 
		"PNBOM812" NUMBER(15,0), 
		"PNBOM815" NUMBER(15,0), 
		"PNBOM816" NUMBER(15,0), 
		"PNBOM818" NUMBER(15,0), 
		"PNCA001" NUMBER(15,0), 
		"PNCA004" NUMBER(15,0), 
		"PNCA006" NUMBER(15,0), 
		"PNCA007" NUMBER(15,0), 
		"PNCA008" NUMBER(15,0), 
		"PNCA010" NUMBER(15,0), 
		"PNCA011" NUMBER(15,0), 
		"PNCA014" NUMBER(15,0), 
		"PNCA015" NUMBER(15,0), 
		"PNCA016" NUMBER(15,0), 
		"PNCA019" NUMBER(15,0), 
		"PNCA022" NUMBER(15,0), 
		"PNCA025" NUMBER(15,0), 
		"PNCA026" NUMBER(15,0), 
		"PNCA027" NUMBER(15,0), 
		"PNCA028" NUMBER(15,0), 
		"PNCA034" NUMBER(15,0), 
		"PNCA037" NUMBER(15,0), 
		"PNCA038" NUMBER(15,0), 
		"PNCA039" NUMBER(15,0), 
		"PNCA040" NUMBER(15,0), 
		"PNCA041" NUMBER(15,0), 
		"PNCA046" NUMBER(15,0), 
		"PNCA1000" NUMBER(15,0), 
		"PNCA1007" NUMBER(15,0), 
		"PNCA1008" NUMBER(15,0), 
		"PNCA1009" NUMBER(15,0), 
		"PNCA1012" NUMBER(15,0), 
		"PNCA1013" NUMBER(15,0), 
		"PNCA1014" NUMBER(15,0), 
		"PNCA1017" NUMBER(15,0), 
		"PNCA1041" NUMBER(15,0), 
		"PNCA1042" NUMBER(15,0), 
		"PNCA1043" NUMBER(15,0), 
		"PNCA1044" NUMBER(15,0), 
		"PNCA1045" NUMBER(15,0), 
		"PNCA1046" NUMBER(15,0), 
		"PNCA1047" NUMBER(15,0), 
		"PNCA1048" NUMBER(15,0), 
		"PNCA1049" NUMBER(15,0), 
		"PNCA1050" NUMBER(15,0), 
		"PNCA1051" NUMBER(15,0), 
		"PNCA1052" NUMBER(15,0), 
		"PNCA1053" NUMBER(15,0), 
		"PNCA1054" NUMBER(15,0), 
		"PNCA1055" NUMBER(15,0), 
		"PNCA1056" NUMBER(15,0), 
		"PNCA1057" NUMBER(15,0), 
		"PNCA1058" NUMBER(15,0), 
		"PNCA1059" NUMBER(15,0), 
		"PNCA1060" NUMBER(15,0), 
		"PNCA1061" NUMBER(15,0), 
		"PNCA1062" NUMBER(15,0), 
		"PNCA1063" NUMBER(15,0), 
		"PNCA1064" NUMBER(15,0), 
		"PNCA149" NUMBER(15,0), 
		"PNCA157" NUMBER(15,0), 
		"PNCA160" NUMBER(15,0), 
		"PNCA171" NUMBER(15,0), 
		"PNCA172" NUMBER(15,0), 
		"PNCA177" NUMBER(15,0), 
		"PNCA200" NUMBER(15,0), 
		"PNCA210" NUMBER(15,0), 
		"PNCA211" NUMBER(15,0), 
		"PNCA213" NUMBER(15,0), 
		"PNCA214" NUMBER(15,0), 
		"PNCA215" NUMBER(15,0), 
		"PNCA822" NUMBER(15,0), 
		"PNCB001" NUMBER(15,0), 
		"PNCB004" NUMBER(15,0), 
		"PNCB006" NUMBER(15,0), 
		"PNCB007" NUMBER(15,0), 
		"PNCB008" NUMBER(15,0), 
		"PNCB010" NUMBER(15,0), 
		"PNCB011" NUMBER(15,0), 
		"PNCB014" NUMBER(15,0), 
		"PNCB015" NUMBER(15,0), 
		"PNCB016" NUMBER(15,0), 
		"PNCB034" NUMBER(15,0), 
		"PNCB037" NUMBER(15,0), 
		"PNCB041" NUMBER(15,0), 
		"PNCB1007" NUMBER(15,0), 
		"PNCB1008" NUMBER(15,0), 
		"PNCB1009" NUMBER(15,0), 
		"PNCB1012" NUMBER(15,0), 
		"PNCB1013" NUMBER(15,0), 
		"PNCB1014" NUMBER(15,0), 
		"PNCB1017" NUMBER(15,0), 
		"PNCB1041" NUMBER(15,0), 
		"PNCB1043" NUMBER(15,0), 
		"PNCB1044" NUMBER(15,0), 
		"PNCB1053" NUMBER(15,0), 
		"PNCB1054" NUMBER(15,0), 
		"PNCB1055" NUMBER(15,0), 
		"PNCB1056" NUMBER(15,0), 
		"PNCB1057" NUMBER(15,0), 
		"PNCB1058" NUMBER(15,0), 
		"PNCB1059" NUMBER(15,0), 
		"PNCB1063" NUMBER(15,0), 
		"PNCB1065" NUMBER(15,0), 
		"PNCB200" NUMBER(15,0), 
		"PNCB210" NUMBER(15,0), 
		"PNCB211" NUMBER(15,0), 
		"PNCB213" NUMBER(15,0), 
		"PNCB214" NUMBER(15,0), 
		"PNCC001" NUMBER(15,0), 
		"PNCC004" NUMBER(15,0), 
		"PNCC006" NUMBER(15,0), 
		"PNCC007" NUMBER(15,0), 
		"PNCC008" NUMBER(15,0), 
		"PNCC010" NUMBER(15,0), 
		"PNCC011" NUMBER(15,0), 
		"PNCC014" NUMBER(15,0), 
		"PNCC015" NUMBER(15,0), 
		"PNCC016" NUMBER(15,0), 
		"PNCC034" NUMBER(15,0), 
		"PNCC037" NUMBER(15,0), 
		"PNCC041" NUMBER(15,0), 
		"PNCC1007" NUMBER(15,0), 
		"PNCC1008" NUMBER(15,0), 
		"PNCC1009" NUMBER(15,0), 
		"PNCC1012" NUMBER(15,0), 
		"PNCC1013" NUMBER(15,0), 
		"PNCC1014" NUMBER(15,0), 
		"PNCC1017" NUMBER(15,0), 
		"PNCC1041" NUMBER(15,0), 
		"PNCC1043" NUMBER(15,0), 
		"PNCC1044" NUMBER(15,0), 
		"PNCC1053" NUMBER(15,0), 
		"PNCC1054" NUMBER(15,0), 
		"PNCC1055" NUMBER(15,0), 
		"PNCC1056" NUMBER(15,0), 
		"PNCC1057" NUMBER(15,0), 
		"PNCC1058" NUMBER(15,0), 
		"PNCC1059" NUMBER(15,0), 
		"PNCC1063" NUMBER(15,0), 
		"PNCC200" NUMBER(15,0), 
		"PNCC210" NUMBER(15,0), 
		"PNCC211" NUMBER(15,0), 
		"PNCC213" NUMBER(15,0), 
		"PNCC214" NUMBER(15,0), 
		"PNCD001" NUMBER(15,0), 
		"PNCD002" NUMBER(15,0), 
		"PNCD003" NUMBER(15,0), 
		"PNCD004" NUMBER(15,0), 
		"PNCD005" NUMBER(15,0), 
		"PNCD006" NUMBER(15,0), 
		"PNCD007" NUMBER(15,0), 
		"PNCD008" NUMBER(15,0), 
		"PNCD009" NUMBER(15,0), 
		"PNCD010" NUMBER(15,0), 
		"PNCD011" NUMBER(15,0), 
		"PNCD012" NUMBER(15,0), 
		"PNCD013" NUMBER(15,0), 
		"PNCD014" NUMBER(15,0), 
		"PNCD015" NUMBER(15,0), 
		"PNCD016" NUMBER(15,0), 
		"PNCD017" NUMBER(15,0), 
		"PNCD018" NUMBER(15,0), 
		"PNCD019" NUMBER(15,0), 
		"PNCD020" NUMBER(15,0), 
		"PNCD021" NUMBER(15,0), 
		"PNCD022" NUMBER(15,0), 
		"PNCD027" NUMBER(15,0), 
		"PNCD041" NUMBER(15,0), 
		"PNCD044" NUMBER(15,0), 
		"PNCD049" NUMBER(15,0), 
		"PNCD052" NUMBER(15,0), 
		"PNCD055" NUMBER(15,0), 
		"PNCD065" NUMBER(15,0), 
		"PNCD077" NUMBER(15,0), 
		"PNCD078" NUMBER(15,0), 
		"PNCD079" NUMBER(15,0), 
		"PNCD080" NUMBER(15,0), 
		"PNCD081" NUMBER(15,0), 
		"PNCD082" NUMBER(15,0), 
		"PNCD083" NUMBER(15,0), 
		"PNCD084" NUMBER(15,0), 
		"PNCD086" NUMBER(15,0), 
		"PNCD087" NUMBER(15,0), 
		"PNCD088" NUMBER(15,0), 
		"PNCD089" NUMBER(15,0), 
		"PNCD090" NUMBER(15,0), 
		"PNEA001" NUMBER(15,0), 
		"PNEA002" NUMBER(15,0), 
		"PNEA003" NUMBER(15,0), 
		"PNEA005" NUMBER(15,0), 
		"PNEA006" NUMBER(15,0), 
		"PNEA007" NUMBER(15,0), 
		"PNEA008" NUMBER(15,0), 
		"PNEA010" NUMBER(15,0), 
		"PNEA011" NUMBER(15,0), 
		"PNEA012" NUMBER(15,0), 
		"PNEA013" NUMBER(15,0), 
		"PNEA014" NUMBER(15,0), 
		"PNEA015" NUMBER(15,0), 
		"PNEA016" NUMBER(15,0), 
		"PNEA017" NUMBER(15,0), 
		"PNEA018" NUMBER(15,0), 
		"PNF001" NUMBER(15,0), 
		"PNF003" NUMBER(15,0)
		)
		'
		;
		
		END IF;
	*/

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''onk'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''onk'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		
	
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_mnb_onk ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_mnb_onk, ''|| evszam ||'');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_mnb_onk ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;
	
END IF;


IF v_mnb_pi = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_pic ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_mnb_pic ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PIC003" NUMBER(15,0), 
		"PIC001" NUMBER(15,0), 
		"PIC234" NUMBER(15,0), 
		"PIC235" NUMBER(15,0), 
		"PIC236" NUMBER(15,0), 
		"PIC237" NUMBER(15,0), 
		"PIC238" NUMBER(15,0), 
		"PIC239" NUMBER(15,0), 
		"PIC240" NUMBER(15,0), 
		"PIC241" NUMBER(15,0), 
		"PIC242" NUMBER(15,0), 
		"PIC243" NUMBER(15,0), 
		"PIC244" NUMBER(15,0), 
		"PIC245" NUMBER(15,0), 
		"PIC246" NUMBER(15,0), 
		"PIC247" NUMBER(15,0), 
		"PIC248" NUMBER(15,0), 
		"PIC249" NUMBER(15,0), 
		"PIC250" NUMBER(15,0), 
		"PIC251" NUMBER(15,0), 
		"PIC252" NUMBER(15,0), 
		"PIC253" NUMBER(15,0), 
		"PIC254" NUMBER(15,0), 
		"PIC255" NUMBER(15,0), 
		"PIC256" NUMBER(15,0), 
		"PIC257" NUMBER(15,0), 
		"PIC258" NUMBER(15,0), 
		"PIC259" NUMBER(15,0), 
		"PIC260" NUMBER(15,0), 
		"PIC261" NUMBER(15,0), 
		"PIC002" NUMBER(15,0), 
		"PIC262" NUMBER(15,0), 
		"PIC263" NUMBER(15,0), 
		"PIC264" NUMBER(15,0), 
		"PIC265" NUMBER(15,0), 
		"PIC266" NUMBER(15,0), 
		"PIC267" NUMBER(15,0), 
		"PIC268" NUMBER(15,0), 
		"PIC269" NUMBER(15,0), 
		"PIC270" NUMBER(15,0), 
		"PIC271" NUMBER(15,0), 
		"PIC272" NUMBER(15,0), 
		"PIC273" NUMBER(15,0), 
		"PIC274" NUMBER(15,0), 
		"PIC275" NUMBER(15,0), 
		"PIC276" NUMBER(15,0), 
		"PIC277" NUMBER(15,0), 
		"PIC278" NUMBER(15,0), 
		"PIC279" NUMBER(15,0), 
		"PIC280" NUMBER(15,0), 
		"PIC281" NUMBER(15,0), 
		"PIC282" NUMBER(15,0), 
		"PIC283" NUMBER(15,0), 
		"PIC284" NUMBER(15,0), 
		"PIC285" NUMBER(15,0), 
		"PIC286" NUMBER(15,0), 
		"PIC287" NUMBER(15,0), 
		"PIC004" NUMBER(15,0), 
		"PIC120" NUMBER(15,0), 
		"PIC118" NUMBER(15,0), 
		"PIC119" NUMBER(15,0), 
		"PIC288" NUMBER(15,0), 
		"PIC289" NUMBER(15,0), 
		"PIC290" NUMBER(15,0), 
		"PIC291" NUMBER(15,0), 
		"PIC292" NUMBER(15,0), 
		"PIC293" NUMBER(15,0), 
		"PIC123" NUMBER(15,0), 
		"PIC294" NUMBER(15,0), 
		"PIC295" NUMBER(15,0), 
		"PIC296" NUMBER(15,0), 
		"PIC297" NUMBER(15,0), 
		"PIC298" NUMBER(15,0), 
		"PIC299" NUMBER(15,0), 
		"PIC300" NUMBER(15,0), 
		"PIC301" NUMBER(15,0), 
		"PIC302" NUMBER(15,0), 
		"PIC303" NUMBER(15,0), 
		"PIC304" NUMBER(15,0), 
		"PIC305" NUMBER(15,0), 
		"PIC306" NUMBER(15,0), 
		"PIC307" NUMBER(15,0), 
		"PIC308" NUMBER(15,0), 
		"PIC309" NUMBER(15,0), 
		"PIC310" NUMBER(15,0), 
		"PIC311" NUMBER(15,0), 
		"PIC312" NUMBER(15,0), 
		"PIC313" NUMBER(15,0), 
		"PIC314" NUMBER(15,0), 
		"PIC315" NUMBER(15,0), 
		"PIC316" NUMBER(15,0), 
		"PIC317" NUMBER(15,0), 
		"PIC318" NUMBER(15,0), 
		"PIC319" NUMBER(15,0), 
		"PIC141" NUMBER(15,0), 
		"PIC320" NUMBER(15,0), 
		"PIC321" NUMBER(15,0), 
		"PIC322" NUMBER(15,0), 
		"PIC323" NUMBER(15,0), 
		"PIC324" NUMBER(15,0), 
		"PIC325" NUMBER(15,0), 
		"PIC326" NUMBER(15,0), 
		"PIC327" NUMBER(15,0), 
		"PIC328" NUMBER(15,0), 
		"PIC329" NUMBER(15,0), 
		"PIC330" NUMBER(15,0), 
		"PIC331" NUMBER(15,0), 
		"PIC332" NUMBER(15,0), 
		"PIC333" NUMBER(15,0), 
		"PIC334" NUMBER(15,0), 
		"PIC335" NUMBER(15,0), 
		"PIC336" NUMBER(15,0), 
		"PIC337" NUMBER(15,0), 
		"PIC338" NUMBER(15,0), 
		"PIC339" NUMBER(15,0), 
		"PIC340" NUMBER(15,0), 
		"PIC341" NUMBER(15,0), 
		"PIC342" NUMBER(15,0), 
		"PIC343" NUMBER(15,0), 
		"PIC344" NUMBER(15,0), 
		"PIC345" NUMBER(15,0), 
		"PIC346" NUMBER(15,0), 
		"PIC347" NUMBER(15,0), 
		"PIC348" NUMBER(15,0), 
		"PIC349" NUMBER(15,0), 
		"PIC350" NUMBER(15,0), 
		"PIC351" NUMBER(15,0), 
		"PIC352" NUMBER(15,0), 
		"PIC353" NUMBER(15,0), 
		"PIC354" NUMBER(15,0), 
		"PIC153" NUMBER(15,0), 
		"PIC355" NUMBER(15,0), 
		"PIC356" NUMBER(15,0), 
		"PIC357" NUMBER(15,0), 
		"PIC358" NUMBER(15,0), 
		"PIC359" NUMBER(15,0), 
		"PIC360" NUMBER(15,0), 
		"PIC361" NUMBER(15,0), 
		"PIC362" NUMBER(15,0), 
		"PIC363" NUMBER(15,0), 
		"PIC364" NUMBER(15,0), 
		"PIC365" NUMBER(15,0), 
		"PIC366" NUMBER(15,0), 
		"PIC367" NUMBER(15,0), 
		"PIC233" NUMBER(15,0), 
		"PIC368" NUMBER(15,0), 
		"PIC369" NUMBER(15,0), 
		"PIC370" NUMBER(15,0), 
		"PIC371" NUMBER(15,0), 
		"PIC372" NUMBER(15,0), 
		"PIC373" NUMBER(15,0), 
		"PIC374" NUMBER(15,0), 
		"PIC375" NUMBER(15,0), 
		"PIC376" NUMBER(15,0), 
		"PIC377" NUMBER(15,0), 
		"PIC378" NUMBER(15,0), 
		"PIC379" NUMBER(15,0), 
		"PIC166" NUMBER(15,0), 
		"PIC168" NUMBER(15,0), 
		"PIC380" NUMBER(15,0), 
		"PIC171" NUMBER(15,0), 
		"PIC381" NUMBER(15,0), 
		"PIC181" NUMBER(15,0), 
		"PIC174" NUMBER(15,0), 
		"PIC176" NUMBER(15,0), 
		"PIC382" NUMBER(15,0), 
		"PIC383" NUMBER(15,0), 
		"PIC384" NUMBER(15,0), 
		"PIC385" NUMBER(15,0), 
		"PIC386" NUMBER(15,0), 
		"PIC167" NUMBER(15,0), 
		"PIC169" NUMBER(15,0), 
		"PIC387" NUMBER(15,0), 
		"PIC388" NUMBER(15,0), 
		"PIC389" NUMBER(15,0), 
		"PIC390" NUMBER(15,0), 
		"PIC180" NUMBER(15,0), 
		"PIC391" NUMBER(15,0), 
		"PIC177" NUMBER(15,0), 
		"PIC392" NUMBER(15,0), 
		"PIC393" NUMBER(15,0), 
		"PIC394" NUMBER(15,0), 
		"PIC395" NUMBER(15,0), 
		"PIC422" NUMBER(15,0), 
		"PIC396" NUMBER(15,0), 
		"PIC397" NUMBER(15,0), 
		"PIC025" NUMBER(15,0), 
		"PIC398" NUMBER(15,0), 
		"PIC399" NUMBER(15,0), 
		"PIC400" NUMBER(15,0), 
		"PIC028" NUMBER(15,0), 
		"PIC187" NUMBER(15,0), 
		"PIC188" NUMBER(15,0), 
		"PIC189" NUMBER(15,0), 
		"PIC030" NUMBER(15,0), 
		"PIC029" NUMBER(15,0), 
		"PIC401" NUMBER(15,0), 
		"PIC402" NUMBER(15,0), 
		"PIC403" NUMBER(15,0), 
		"PIC404" NUMBER(15,0), 
		"PIC405" NUMBER(15,0), 
		"PIC406" NUMBER(15,0), 
		"PIC407" NUMBER(15,0), 
		"PIC408" NUMBER(15,0), 
		"PIC409" NUMBER(15,0), 
		"PIC410" NUMBER(15,0), 
		"PIC411" NUMBER(15,0), 
		"PIC412" NUMBER(15,0), 
		"PIC102" NUMBER(15,0), 
		"PIC413" NUMBER(15,0), 
		"PIC414" NUMBER(15,0), 
		"PIC415" NUMBER(15,0), 
		"PIC033" NUMBER(15,0), 
		"PIC416" NUMBER(15,0), 
		"PIC417" NUMBER(15,0), 
		"PIC418" NUMBER(15,0), 
		"PIC034" NUMBER(15,0), 
		"PIC219" NUMBER(15,0), 
		"PIC220" NUMBER(15,0), 
		"PIC221" NUMBER(15,0), 
		"PIC222" NUMBER(15,0), 
		"PIC035" NUMBER(15,0), 
		"PIC419" NUMBER(15,0), 
		"PIC223" NUMBER(15,0), 
		"PIC224" NUMBER(15,0), 
		"PIC225" NUMBER(15,0), 
		"PIC420" NUMBER(15,0), 
		"PIC036" NUMBER(15,0), 
		"PIC037" NUMBER(15,0), 
		"PIC423" NUMBER(15,0), 
		"PIC038" NUMBER(15,0), 
		"PIC421" NUMBER(15,0), 
		"PIC039" NUMBER(15,0), 
		"PIC040" NUMBER(15,0), 
		"PIA0M000" NUMBER(15,0), 
		"PIA0M001" NUMBER(15,0), 
		"PIA0M038" NUMBER(15,0), 
		"PIA0M522" NUMBER(15,0), 
		"PIA0M523" NUMBER(15,0), 
		"PIA0M042" NUMBER(15,0), 
		"PIA0M335" NUMBER(15,0), 
		"PIA0M336" NUMBER(15,0), 
		"PIA0M524" NUMBER(15,0), 
		"PIA0M525" NUMBER(15,0), 
		"PIA0M526" NUMBER(15,0), 
		"PIA0M527" NUMBER(15,0), 
		"PIA0M528" NUMBER(15,0), 
		"PIA0M529" NUMBER(15,0), 
		"PIA0M530" NUMBER(15,0), 
		"PIA0M531" NUMBER(15,0), 
		"PIA0M532" NUMBER(15,0), 
		"PIA0M533" NUMBER(15,0), 
		"PIA0M534" NUMBER(15,0), 
		"PIA0M535" NUMBER(15,0), 
		"PIA0M536" NUMBER(15,0), 
		"PIA0M537" NUMBER(15,0), 
		"PIA0M538" NUMBER(15,0), 
		"PIA0M539" NUMBER(15,0), 
		"PIA0M540" NUMBER(15,0), 
		"PIA0M541" NUMBER(15,0), 
		"PIA0M542" NUMBER(15,0), 
		"PIA0M543" NUMBER(15,0), 
		"PIA0M544" NUMBER(15,0), 
		"PIA0M545" NUMBER(15,0), 
		"PIA0M546" NUMBER(15,0), 
		"PIA0M547" NUMBER(15,0), 
		"PIA0M548" NUMBER(15,0), 
		"PIA0M549" NUMBER(15,0), 
		"PIA0M550" NUMBER(15,0), 
		"PIA0M551" NUMBER(15,0), 
		"PIA0M552" NUMBER(15,0), 
		"PIA0M553" NUMBER(15,0), 
		"PIA0M554" NUMBER(15,0), 
		"PIA0M555" NUMBER(15,0), 
		"PIA0M556" NUMBER(15,0), 
		"PIA0M557" NUMBER(15,0), 
		"PIA0M558" NUMBER(15,0), 
		"PIA0M559" NUMBER(15,0), 
		"PIA0M560" NUMBER(15,0), 
		"PIA0M561" NUMBER(15,0), 
		"PIA0M562" NUMBER(15,0), 
		"PIA0M563" NUMBER(15,0), 
		"PIA0M564" NUMBER(15,0), 
		"PIA0M565" NUMBER(15,0), 
		"PIA0M566" NUMBER(15,0), 
		"PIA0M567" NUMBER(15,0), 
		"PIA0M568" NUMBER(15,0), 
		"PIA0M569" NUMBER(15,0), 
		"PIA0M570" NUMBER(15,0), 
		"PIA0M571" NUMBER(15,0), 
		"PIA0M572" NUMBER(15,0), 
		"PIA0M573" NUMBER(15,0), 
		"PIA0M574" NUMBER(15,0), 
		"PIA0M575" NUMBER(15,0), 
		"PIA0M576" NUMBER(15,0), 
		"PIA0M577" NUMBER(15,0), 
		"PIA0M578" NUMBER(15,0), 
		"PIA0M521" NUMBER(15,0), 
		"PIA0M356" NUMBER(15,0), 
		"PIA0M357" NUMBER(15,0), 
		"PIA0M358" NUMBER(15,0), 
		"PIA0M359" NUMBER(15,0), 
		"PIA0M090" NUMBER(15,0), 
		"PIA0M360" NUMBER(15,0), 
		"PIA0M579" NUMBER(15,0), 
		"PIA0M580" NUMBER(15,0), 
		"PIA0M581" NUMBER(15,0), 
		"PIA0M582" NUMBER(15,0), 
		"PIA0M101" NUMBER(15,0), 
		"PIA0M102" NUMBER(15,0), 
		"PIA0M361" NUMBER(15,0), 
		"PIA0M362" NUMBER(15,0), 
		"PIA0M363" NUMBER(15,0), 
		"PIA0M583" NUMBER(15,0), 
		"PIA0M584" NUMBER(15,0), 
		"PIA0M365" NUMBER(15,0), 
		"PIA0M366" NUMBER(15,0), 
		"PIA0M004" NUMBER(15,0), 
		"PIA0M163" NUMBER(15,0), 
		"PIA0M164" NUMBER(15,0), 
		"PIA0M166" NUMBER(15,0), 
		"PIA0M167" NUMBER(15,0), 
		"PIA0M168" NUMBER(15,0), 
		"PIA0M392" NUMBER(15,0), 
		"PIA0M393" NUMBER(15,0), 
		"PIA0M394" NUMBER(15,0), 
		"PIA0M395" NUMBER(15,0), 
		"PIA0M005" NUMBER(15,0), 
		"PIA0M585" NUMBER(15,0), 
		"PIA0M586" NUMBER(15,0), 
		"PIA0M587" NUMBER(15,0), 
		"PIA0M588" NUMBER(15,0), 
		"PIA0M589" NUMBER(15,0), 
		"PIA0M590" NUMBER(15,0), 
		"PIA0M591" NUMBER(15,0), 
		"PIA0M592" NUMBER(15,0), 
		"PIA0M177" NUMBER(15,0), 
		"PIA0M593" NUMBER(15,0), 
		"PIA0M594" NUMBER(15,0), 
		"PIA0M595" NUMBER(15,0), 
		"PIA0M180" NUMBER(15,0), 
		"PIA0M596" NUMBER(15,0), 
		"PIA0M597" NUMBER(15,0), 
		"PIA0M402" NUMBER(15,0), 
		"PIA0M403" NUMBER(15,0), 
		"PIA0M404" NUMBER(15,0), 
		"PIA0M186" NUMBER(15,0), 
		"PIA0M598" NUMBER(15,0), 
		"PIA0M599" NUMBER(15,0), 
		"PIA0M600" NUMBER(15,0), 
		"PIA0M601" NUMBER(15,0), 
		"PIA0M602" NUMBER(15,0), 
		"PIA0M603" NUMBER(15,0), 
		"PIA0M604" NUMBER(15,0), 
		"PIA0M605" NUMBER(15,0), 
		"PIA0M606" NUMBER(15,0), 
		"PIA0M607" NUMBER(15,0), 
		"PIA0M608" NUMBER(15,0), 
		"PIA0M609" NUMBER(15,0), 
		"PIA0M610" NUMBER(15,0), 
		"PIA0M611" NUMBER(15,0), 
		"PIA0M612" NUMBER(15,0), 
		"PIA0M613" NUMBER(15,0), 
		"PIA0M614" NUMBER(15,0), 
		"PIA0M615" NUMBER(15,0), 
		"PIA0M427" NUMBER(15,0), 
		"PIA0M428" NUMBER(15,0), 
		"PIA0M429" NUMBER(15,0), 
		"PIA0M211" NUMBER(15,0), 
		"PIA0M212" NUMBER(15,0), 
		"PIA0M616" NUMBER(15,0), 
		"PIA0M617" NUMBER(15,0), 
		"PIA0M618" NUMBER(15,0), 
		"PIA0M434" NUMBER(15,0), 
		"PIA0M435" NUMBER(15,0), 
		"PIA0M436" NUMBER(15,0), 
		"PIA0M222" NUMBER(15,0), 
		"PIA0M437" NUMBER(15,0), 
		"PIA0M438" NUMBER(15,0), 
		"PIA0M439" NUMBER(15,0), 
		"PIA0M224" NUMBER(15,0), 
		"PIA0M440" NUMBER(15,0), 
		"PIA0M441" NUMBER(15,0), 
		"PIA0M228" NUMBER(15,0), 
		"PIA0M444" NUMBER(15,0), 
		"PIA0M445" NUMBER(15,0), 
		"PIA0M619" NUMBER(15,0), 
		"PIA0M620" NUMBER(15,0), 
		"PIA0M621" NUMBER(15,0), 
		"PIA0M448" NUMBER(15,0), 
		"PIA0M449" NUMBER(15,0), 
		"PIA0M450" NUMBER(15,0), 
		"PIA0M451" NUMBER(15,0), 
		"PIA0M452" NUMBER(15,0), 
		"PIA0M234" NUMBER(15,0), 
		"PIA0M235" NUMBER(15,0), 
		"PIA0M622" NUMBER(15,0), 
		"PIA0M623" NUMBER(15,0), 
		"PIA0M624" NUMBER(15,0), 
		"PIA0M625" NUMBER(15,0), 
		"PIA0M626" NUMBER(15,0), 
		"PIA0M627" NUMBER(15,0), 
		"PIA0M628" NUMBER(15,0), 
		"PIA0M629" NUMBER(15,0), 
		"PIA0M630" NUMBER(15,0), 
		"PIA0M631" NUMBER(15,0), 
		"PIA0M632" NUMBER(15,0), 
		"PIA0M633" NUMBER(15,0), 
		"PIA0M240" NUMBER(15,0), 
		"PIA0M457" NUMBER(15,0), 
		"PIA0M458" NUMBER(15,0), 
		"PIA0M242" NUMBER(15,0), 
		"PIA0M459" NUMBER(15,0), 
		"PIA0M460" NUMBER(15,0), 
		"PIA0M461" NUMBER(15,0), 
		"PIA0M462" NUMBER(15,0), 
		"PIA0M463" NUMBER(15,0), 
		"PIA0M245" NUMBER(15,0), 
		"PIA0M246" NUMBER(15,0), 
		"PIA0M634" NUMBER(15,0), 
		"PIA0M635" NUMBER(15,0), 
		"PIA0M636" NUMBER(15,0), 
		"PIA0M249" NUMBER(15,0), 
		"PIA0M466" NUMBER(15,0), 
		"PIA0M467" NUMBER(15,0), 
		"PIA0M637" NUMBER(15,0), 
		"PIA0M638" NUMBER(15,0), 
		"PIA0M639" NUMBER(15,0), 
		"PIA0M470" NUMBER(15,0), 
		"PIA0M471" NUMBER(15,0), 
		"PIA0M472" NUMBER(15,0), 
		"PIA0M254" NUMBER(15,0), 
		"PIA0M473" NUMBER(15,0), 
		"PIA0M474" NUMBER(15,0), 
		"PIA0M475" NUMBER(15,0), 
		"PIA0M476" NUMBER(15,0), 
		"PIA0M477" NUMBER(15,0), 
		"PIA0M478" NUMBER(15,0), 
		"PIA0M479" NUMBER(15,0), 
		"PIA0M480" NUMBER(15,0), 
		"PIA0M481" NUMBER(15,0), 
		"PIA0M482" NUMBER(15,0), 
		"PIA0M483" NUMBER(15,0), 
		"PIA0M484" NUMBER(15,0), 
		"PIA0M485" NUMBER(15,0), 
		"PIA0M486" NUMBER(15,0), 
		"PIA0M640" NUMBER(15,0), 
		"PIA0M641" NUMBER(15,0), 
		"PIA0M642" NUMBER(15,0), 
		"PIA0M643" NUMBER(15,0), 
		"PIA0M644" NUMBER(15,0), 
		"PIA0M645" NUMBER(15,0), 
		"PIA0M646" NUMBER(15,0), 
		"PIA0M647" NUMBER(15,0), 
		"PIA0M648" NUMBER(15,0), 
		"PIA0M649" NUMBER(15,0), 
		"PIA0M650" NUMBER(15,0), 
		"PIA0M651" NUMBER(15,0), 
		"PIA0M652" NUMBER(15,0), 
		"PIA0M653" NUMBER(15,0), 
		"PIA0M654" NUMBER(15,0), 
		"PIA0M655" NUMBER(15,0), 
		"PIA0M656" NUMBER(15,0), 
		"PIA0M657" NUMBER(15,0), 
		"PIA0M658" NUMBER(15,0), 
		"PIA0M659" NUMBER(15,0), 
		"PIA0M660" NUMBER(15,0), 
		"PIA0M661" NUMBER(15,0), 
		"PIA0M662" NUMBER(15,0), 
		"PIA0M663" NUMBER(15,0), 
		"PIA0M664" NUMBER(15,0), 
		"PIA0M505" NUMBER(15,0), 
		"PIA0M506" NUMBER(15,0), 
		"PIA0M507" NUMBER(15,0), 
		"PIA0M508" NUMBER(15,0), 
		"PIA0M006" NUMBER(15,0), 
		"PIA0M509" NUMBER(15,0), 
		"PIA0M263" NUMBER(15,0), 
		"PIA0M665" NUMBER(15,0), 
		"PIA0M666" NUMBER(15,0), 
		"PIA0M667" NUMBER(15,0), 
		"PIA0M668" NUMBER(15,0), 
		"PIA0M669" NUMBER(15,0), 
		"PIA0M276" NUMBER(15,0), 
		"PIA0M277" NUMBER(15,0), 
		"PIA0M278" NUMBER(15,0), 
		"PIA0M279" NUMBER(15,0), 
		"PIA0M280" NUMBER(15,0), 
		"PIA0M281" NUMBER(15,0), 
		"PIA0M282" NUMBER(15,0), 
		"PIA0M283" NUMBER(15,0), 
		"PIA0M510" NUMBER(15,0), 
		"PIA0M511" NUMBER(15,0), 
		"PIA0M512" NUMBER(15,0), 
		"PIA0M513" NUMBER(15,0), 
		"PIA0M514" NUMBER(15,0), 
		"PIA0M515" NUMBER(15,0), 
		"PIA0M317" NUMBER(15,0), 
		"PIA0M318" NUMBER(15,0), 
		"PIA0M320" NUMBER(15,0), 
		"PIA0M319" NUMBER(15,0), 
		"PIA0M321" NUMBER(15,0), 
		"PIA0M322" NUMBER(15,0), 
		"PIA0M519" NUMBER(15,0), 
		"PIA0M670" NUMBER(15,0), 
		"PIA0M671" NUMBER(15,0), 
		"PIA0M327" NUMBER(15,0), 
		"PIA0M328" NUMBER(15,0), 
		"PIA0M672" NUMBER(15,0), 
		"PIA0M331" NUMBER(15,0), 
		"PIA0M332" NUMBER(15,0), 
		"PIA0M007" NUMBER(15,0), 
		"PIA0M673" NUMBER(15,0), 
		"PIA0M674" NUMBER(15,0), 
		"PIA0M675" NUMBER(15,0), 
		"PIA0M676" NUMBER(15,0), 
		"PIA0M677" NUMBER(15,0), 
		"PIA0M678" NUMBER(15,0), 
		"PIA0M679" NUMBER(15,0), 
		"PIA0M680" NUMBER(15,0), 
		"PIA0M681" NUMBER(15,0), 
		"PIA0M682" NUMBER(15,0), 
		"PIA0M683" NUMBER(15,0), 
		"PIA0M684" NUMBER(15,0), 
		"PIA0M685" NUMBER(15,0), 
		"PIA0M686" NUMBER(15,0), 
		"PIA0M687" NUMBER(15,0), 
		"PIA0M688" NUMBER(15,0), 
		"PIA0M689" NUMBER(15,0), 
		"PIA0M301" NUMBER(15,0), 
		"PIA0M302" NUMBER(15,0), 
		"PIA0M304" NUMBER(15,0), 
		"PIA0M303" NUMBER(15,0), 
		"PIA0M305" NUMBER(15,0), 
		"PIA0M306" NUMBER(15,0), 
		"PIA0M517" NUMBER(15,0), 
		"PIA0M690" NUMBER(15,0), 
		"PIA0M691" NUMBER(15,0), 
		"PIA0M311" NUMBER(15,0), 
		"PIA0M312" NUMBER(15,0), 
		"PIA0M313" NUMBER(15,0), 
		"PIA0M314" NUMBER(15,0), 
		"PIA0M315" NUMBER(15,0), 
		"PIA0M316" NUMBER(15,0), 
		"PIA0M518" NUMBER(15,0), 
		"PIA0M692" NUMBER(15,0), 
		"PIA0M333" NUMBER(15,0), 
		"PIA0M693" NUMBER(15,0), 
		"PIA0M694" NUMBER(15,0), 
		"PIA0M695" NUMBER(15,0), 
		"PIA0M009" NUMBER(15,0), 
		"PIA0M023" NUMBER(15,0), 
		"PIA0M024" NUMBER(15,0), 
		"PIA0M011" NUMBER(15,0), 
		"PIA0M012" NUMBER(15,0), 
		"PIA0M013" NUMBER(15,0), 
		"PIA0M025" NUMBER(15,0), 
		"PIA0M017" NUMBER(15,0), 
		"PIA0M018" NUMBER(15,0), 
		"PIA0M026" NUMBER(15,0), 
		"PIA0M027" NUMBER(15,0), 
		"PIA0M028" NUMBER(15,0), 
		"PIA0M029" NUMBER(15,0), 
		"PIA0M030" NUMBER(15,0), 
		"PIA0M031" NUMBER(15,0), 
		"PIA0M032" NUMBER(15,0), 
		"PIA0M033" NUMBER(15,0), 
		"PIA0M034" NUMBER(15,0), 
		"PIA0M035" NUMBER(15,0), 
		"PIA0M036" NUMBER(15,0), 
		"PIA0M037" NUMBER(15,0), 
		"PIB0M000" NUMBER(15,0), 
		"PIB0M001" NUMBER(15,0), 
		"PIB0M374" NUMBER(15,0), 
		"PIB0M375" NUMBER(15,0), 
		"PIB0M376" NUMBER(15,0), 
		"PIB0M377" NUMBER(15,0), 
		"PIB0M378" NUMBER(15,0), 
		"PIB0M379" NUMBER(15,0), 
		"PIB0M380" NUMBER(15,0), 
		"PIB0M381" NUMBER(15,0), 
		"PIB0M382" NUMBER(15,0), 
		"PIB0M383" NUMBER(15,0), 
		"PIB0M384" NUMBER(15,0), 
		"PIB0M385" NUMBER(15,0), 
		"PIB0M036" NUMBER(15,0), 
		"PIB0M038" NUMBER(15,0), 
		"PIB0M039" NUMBER(15,0), 
		"PIB0M040" NUMBER(15,0), 
		"PIB0M251" NUMBER(15,0), 
		"PIB0M041" NUMBER(15,0), 
		"PIB0M386" NUMBER(15,0), 
		"PIB0M387" NUMBER(15,0), 
		"PIB0M388" NUMBER(15,0), 
		"PIB0M389" NUMBER(15,0), 
		"PIB0M390" NUMBER(15,0), 
		"PIB0M391" NUMBER(15,0), 
		"PIB0M392" NUMBER(15,0), 
		"PIB0M393" NUMBER(15,0), 
		"PIB0M394" NUMBER(15,0), 
		"PIB0M395" NUMBER(15,0), 
		"PIB0M396" NUMBER(15,0), 
		"PIB0M397" NUMBER(15,0), 
		"PIB0M066" NUMBER(15,0), 
		"PIB0M068" NUMBER(15,0), 
		"PIB0M069" NUMBER(15,0), 
		"PIB0M070" NUMBER(15,0), 
		"PIB0M256" NUMBER(15,0), 
		"PIB0M071" NUMBER(15,0), 
		"PIB0M072" NUMBER(15,0), 
		"PIB0M074" NUMBER(15,0), 
		"PIB0M075" NUMBER(15,0), 
		"PIB0M076" NUMBER(15,0), 
		"PIB0M257" NUMBER(15,0), 
		"PIB0M077" NUMBER(15,0), 
		"PIB0M078" NUMBER(15,0), 
		"PIB0M080" NUMBER(15,0), 
		"PIB0M081" NUMBER(15,0), 
		"PIB0M082" NUMBER(15,0), 
		"PIB0M258" NUMBER(15,0), 
		"PIB0M083" NUMBER(15,0), 
		"PIB0M084" NUMBER(15,0), 
		"PIB0M398" NUMBER(15,0), 
		"PIB0M399" NUMBER(15,0), 
		"PIB0M400" NUMBER(15,0), 
		"PIB0M261" NUMBER(15,0), 
		"PIB0M096" NUMBER(15,0), 
		"PIB0M097" NUMBER(15,0), 
		"PIB0M099" NUMBER(15,0), 
		"PIB0M100" NUMBER(15,0), 
		"PIB0M101" NUMBER(15,0), 
		"PIB0M262" NUMBER(15,0), 
		"PIB0M102" NUMBER(15,0), 
		"PIB0M103" NUMBER(15,0), 
		"PIB0M105" NUMBER(15,0), 
		"PIB0M106" NUMBER(15,0), 
		"PIB0M107" NUMBER(15,0), 
		"PIB0M263" NUMBER(15,0), 
		"PIB0M108" NUMBER(15,0), 
		"PIB0M401" NUMBER(15,0), 
		"PIB0M402" NUMBER(15,0), 
		"PIB0M403" NUMBER(15,0), 
		"PIB0M404" NUMBER(15,0), 
		"PIB0M267" NUMBER(15,0), 
		"PIB0M268" NUMBER(15,0), 
		"PIB0M269" NUMBER(15,0), 
		"PIB0M270" NUMBER(15,0), 
		"PIB0M271" NUMBER(15,0), 
		"PIB0M272" NUMBER(15,0), 
		"PIB0M273" NUMBER(15,0), 
		"PIB0M274" NUMBER(15,0), 
		"PIB0M275" NUMBER(15,0), 
		"PIB0M276" NUMBER(15,0), 
		"PIB0M277" NUMBER(15,0), 
		"PIB0M278" NUMBER(15,0), 
		"PIB0M279" NUMBER(15,0), 
		"PIB0M280" NUMBER(15,0), 
		"PIB0M281" NUMBER(15,0), 
		"PIB0M282" NUMBER(15,0), 
		"PIB0M283" NUMBER(15,0), 
		"PIB0M284" NUMBER(15,0), 
		"PIB0M285" NUMBER(15,0), 
		"PIB0M286" NUMBER(15,0), 
		"PIB0M287" NUMBER(15,0), 
		"PIB0M288" NUMBER(15,0), 
		"PIB0M289" NUMBER(15,0), 
		"PIB0M290" NUMBER(15,0), 
		"PIB0M291" NUMBER(15,0), 
		"PIB0M292" NUMBER(15,0), 
		"PIB0M293" NUMBER(15,0), 
		"PIB0M405" NUMBER(15,0), 
		"PIB0M406" NUMBER(15,0), 
		"PIB0M407" NUMBER(15,0), 
		"PIB0M408" NUMBER(15,0), 
		"PIB0M297" NUMBER(15,0), 
		"PIB0M298" NUMBER(15,0), 
		"PIB0M299" NUMBER(15,0), 
		"PIB0M409" NUMBER(15,0), 
		"PIB0M410" NUMBER(15,0), 
		"PIB0M411" NUMBER(15,0), 
		"PIB0M412" NUMBER(15,0), 
		"PIB0M413" NUMBER(15,0), 
		"PIB0M414" NUMBER(15,0), 
		"PIB0M415" NUMBER(15,0), 
		"PIB0M416" NUMBER(15,0), 
		"PIB0M417" NUMBER(15,0), 
		"PIB0M418" NUMBER(15,0), 
		"PIB0M419" NUMBER(15,0), 
		"PIB0M420" NUMBER(15,0), 
		"PIB0M421" NUMBER(15,0), 
		"PIB0M422" NUMBER(15,0), 
		"PIB0M423" NUMBER(15,0), 
		"PIB0M424" NUMBER(15,0), 
		"PIB0M425" NUMBER(15,0), 
		"PIB0M426" NUMBER(15,0), 
		"PIB0M427" NUMBER(15,0), 
		"PIB0M428" NUMBER(15,0), 
		"PIB0M429" NUMBER(15,0), 
		"PIB0M430" NUMBER(15,0), 
		"PIB0M431" NUMBER(15,0), 
		"PIB0M432" NUMBER(15,0), 
		"PIB0M433" NUMBER(15,0), 
		"PIB0M434" NUMBER(15,0), 
		"PIB0M435" NUMBER(15,0), 
		"PIB0M436" NUMBER(15,0), 
		"PIB0M437" NUMBER(15,0), 
		"PIB0M438" NUMBER(15,0), 
		"PIB0M439" NUMBER(15,0), 
		"PIB0M440" NUMBER(15,0), 
		"PIB0M441" NUMBER(15,0), 
		"PIB0M442" NUMBER(15,0), 
		"PIB0M443" NUMBER(15,0), 
		"PIB0M444" NUMBER(15,0), 
		"PIB0M445" NUMBER(15,0), 
		"PIB0M446" NUMBER(15,0), 
		"PIB0M447" NUMBER(15,0), 
		"PIB0M448" NUMBER(15,0), 
		"PIB0M449" NUMBER(15,0), 
		"PIB0M450" NUMBER(15,0), 
		"PIB0M451" NUMBER(15,0), 
		"PIB0M452" NUMBER(15,0), 
		"PIB0M453" NUMBER(15,0), 
		"PIB0M454" NUMBER(15,0), 
		"PIB0M455" NUMBER(15,0), 
		"PIB0M456" NUMBER(15,0), 
		"PIB0M457" NUMBER(15,0), 
		"PIB0M458" NUMBER(15,0), 
		"PIB0M459" NUMBER(15,0), 
		"PIB0M460" NUMBER(15,0), 
		"PIB0M461" NUMBER(15,0), 
		"PIB0M462" NUMBER(15,0), 
		"PIB0M463" NUMBER(15,0), 
		"PIB0M464" NUMBER(15,0), 
		"PIB0M465" NUMBER(15,0), 
		"PIB0M466" NUMBER(15,0), 
		"PIB0M467" NUMBER(15,0), 
		"PIB0M468" NUMBER(15,0), 
		"PIB0M469" NUMBER(15,0), 
		"PIB0M470" NUMBER(15,0), 
		"PIB0M471" NUMBER(15,0), 
		"PIB0M472" NUMBER(15,0), 
		"PIB0M473" NUMBER(15,0), 
		"PIB0M474" NUMBER(15,0), 
		"PIB0M475" NUMBER(15,0), 
		"PIB0M476" NUMBER(15,0), 
		"PIB0M477" NUMBER(15,0), 
		"PIB0M478" NUMBER(15,0), 
		"PIB0M479" NUMBER(15,0), 
		"PIB0M480" NUMBER(15,0), 
		"PIB0M481" NUMBER(15,0), 
		"PIB0M482" NUMBER(15,0), 
		"PIB0M483" NUMBER(15,0), 
		"PIB0M484" NUMBER(15,0), 
		"PIB0M485" NUMBER(15,0), 
		"PIB0M486" NUMBER(15,0), 
		"PIB0M487" NUMBER(15,0), 
		"PIB0M488" NUMBER(15,0), 
		"PIB0M489" NUMBER(15,0), 
		"PIB0M490" NUMBER(15,0), 
		"PIB0M491" NUMBER(15,0), 
		"PIB0M492" NUMBER(15,0), 
		"PIB0M493" NUMBER(15,0), 
		"PIB0M494" NUMBER(15,0), 
		"PIB0M495" NUMBER(15,0), 
		"PIB0M496" NUMBER(15,0), 
		"PIB0M497" NUMBER(15,0), 
		"PIB0M498" NUMBER(15,0), 
		"PIB0M499" NUMBER(15,0), 
		"PIB0M500" NUMBER(15,0), 
		"PIB0M501" NUMBER(15,0), 
		"PIB0M502" NUMBER(15,0), 
		"PIB0M503" NUMBER(15,0), 
		"PIB0M504" NUMBER(15,0), 
		"PIB0M505" NUMBER(15,0), 
		"PIB0M506" NUMBER(15,0), 
		"PIB0M507" NUMBER(15,0), 
		"PIB0M508" NUMBER(15,0), 
		"PIB0M509" NUMBER(15,0), 
		"PIB0M510" NUMBER(15,0), 
		"PIB0M511" NUMBER(15,0), 
		"PIB0M512" NUMBER(15,0), 
		"PIB0M513" NUMBER(15,0), 
		"PIB0M514" NUMBER(15,0), 
		"PIB0M515" NUMBER(15,0), 
		"PIB0M516" NUMBER(15,0), 
		"PIB0M517" NUMBER(15,0), 
		"PIB0M518" NUMBER(15,0), 
		"PIB0M519" NUMBER(15,0), 
		"PIB0M520" NUMBER(15,0), 
		"PIB0M521" NUMBER(15,0), 
		"PIB0M522" NUMBER(15,0), 
		"PIB0M523" NUMBER(15,0), 
		"PIB0M524" NUMBER(15,0), 
		"PIB0M525" NUMBER(15,0), 
		"PIB0M526" NUMBER(15,0), 
		"PIB0M527" NUMBER(15,0), 
		"PIB0M528" NUMBER(15,0), 
		"PIB0M529" NUMBER(15,0), 
		"PIB0M530" NUMBER(15,0), 
		"PIB0M531" NUMBER(15,0), 
		"PIB0M196" NUMBER(15,0), 
		"PIB0M197" NUMBER(15,0), 
		"PIB0M199" NUMBER(15,0), 
		"PIB0M198" NUMBER(15,0), 
		"PIB0M346" NUMBER(15,0), 
		"PIB0M200" NUMBER(15,0), 
		"PIB0M347" NUMBER(15,0), 
		"PIB0M532" NUMBER(15,0), 
		"PIB0M533" NUMBER(15,0), 
		"PIB0M205" NUMBER(15,0), 
		"PIB0M206" NUMBER(15,0), 
		"PIB0M534" NUMBER(15,0), 
		"PIB0M209" NUMBER(15,0), 
		"PIB0M210" NUMBER(15,0), 
		"PIB0M535" NUMBER(15,0), 
		"PIB0M536" NUMBER(15,0), 
		"PIB0M537" NUMBER(15,0), 
		"PIB0M538" NUMBER(15,0), 
		"PIB0M539" NUMBER(15,0), 
		"PIB0M540" NUMBER(15,0), 
		"PIB0M541" NUMBER(15,0), 
		"PIB0M542" NUMBER(15,0), 
		"PIB0M543" NUMBER(15,0), 
		"PIB0M544" NUMBER(15,0), 
		"PIB0M545" NUMBER(15,0), 
		"PIB0M546" NUMBER(15,0), 
		"PIB0M547" NUMBER(15,0), 
		"PIB0M548" NUMBER(15,0), 
		"PIB0M549" NUMBER(15,0), 
		"PIB0M550" NUMBER(15,0), 
		"PIB0M551" NUMBER(15,0), 
		"PIB0M194" NUMBER(15,0), 
		"PIB0M195" NUMBER(15,0), 
		"PIB0M212" NUMBER(15,0), 
		"PIB0M213" NUMBER(15,0), 
		"PIB0M215" NUMBER(15,0), 
		"PIB0M214" NUMBER(15,0), 
		"PIB0M216" NUMBER(15,0), 
		"PIB0M217" NUMBER(15,0), 
		"PIB0M348" NUMBER(15,0), 
		"PIB0M552" NUMBER(15,0), 
		"PIB0M553" NUMBER(15,0), 
		"PIB0M222" NUMBER(15,0), 
		"PIB0M223" NUMBER(15,0), 
		"PIB0M224" NUMBER(15,0), 
		"PIB0M225" NUMBER(15,0), 
		"PIB0M226" NUMBER(15,0), 
		"PIB0M227" NUMBER(15,0), 
		"PIB0M349" NUMBER(15,0), 
		"PIB0M228" NUMBER(15,0), 
		"PIB0M554" NUMBER(15,0), 
		"PIB0M555" NUMBER(15,0), 
		"PIB0M556" NUMBER(15,0), 
		"PIB0M557" NUMBER(15,0), 
		"PIB0M008" NUMBER(15,0), 
		"PIB0M242" NUMBER(15,0), 
		"PIB0M243" NUMBER(15,0), 
		"PIB0M244" NUMBER(15,0), 
		"PIB0M245" NUMBER(15,0), 
		"PIB0M009" NUMBER(15,0), 
		"PIB0M558" NUMBER(15,0), 
		"PIB0M559" NUMBER(15,0), 
		"PIB0M011" NUMBER(15,0), 
		"PIB0M015" NUMBER(15,0), 
		"PIB0M016" NUMBER(15,0), 
		"PIB0M017" NUMBER(15,0), 
		"PIB0M018" NUMBER(15,0), 
		"PIB0M019" NUMBER(15,0), 
		"PIB0M560" NUMBER(15,0), 
		"PIB0M561" NUMBER(15,0), 
		"PIB0M562" NUMBER(15,0), 
		"PIB0M563" NUMBER(15,0), 
		"PIB0M564" NUMBER(15,0), 
		"PIB0M565" NUMBER(15,0), 
		"PIB0M021" NUMBER(15,0), 
		"PIBOM566" NUMBER(15,0), 
		"PIT001" NUMBER(15,0)
		)
		'
		;
		
		END IF;
	*/		

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pic'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pic'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		
	
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_mnb_pic ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_mnb_pic, ''|| evszam ||'');

	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;		

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_mnb_pic ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;	
	
END IF;


IF v_mnb_psza = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_pszaf_1an ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_pszaf_1an ||'
		("M003" VARCHAR2(8 BYTE), 
		"PIA0M000" NUMBER(20,0), 
		"PIA0M001" NUMBER(20,0), 
		"PIA0M038" NUMBER(20,0), 
		"PIA0M522" NUMBER(20,0), 
		"PIA0M523" NUMBER(20,0), 
		"PIA0M042" NUMBER(20,0), 
		"PIA0M335" NUMBER(20,0), 
		"PIA0M336" NUMBER(20,0), 
		"PIA0M524" NUMBER(20,0), 
		"PIA0M525" NUMBER(20,0), 
		"PIA0M526" NUMBER(20,0), 
		"PIA0M527" NUMBER(20,0), 
		"PIA0M528" NUMBER(20,0), 
		"PIA0M529" NUMBER(20,0), 
		"PIA0M530" NUMBER(20,0), 
		"PIA0M531" NUMBER(20,0), 
		"PIA0M532" NUMBER(20,0), 
		"PIA0M533" NUMBER(20,0), 
		"PIA0M534" NUMBER(20,0), 
		"PIA0M535" NUMBER(20,0), 
		"PIA0M536" NUMBER(20,0), 
		"PIA0M537" NUMBER(20,0), 
		"PIA0M538" NUMBER(20,0), 
		"PIA0M539" NUMBER(20,0), 
		"PIA0M540" NUMBER(20,0), 
		"PIA0M541" NUMBER(20,0), 
		"PIA0M542" NUMBER(20,0), 
		"PIA0M543" NUMBER(20,0), 
		"PIA0M544" NUMBER(20,0), 
		"PIA0M545" NUMBER(20,0), 
		"PIA0M546" NUMBER(20,0), 
		"PIA0M547" NUMBER(20,0), 
		"PIA0M548" NUMBER(20,0), 
		"PIA0M549" NUMBER(20,0), 
		"PIA0M550" NUMBER(20,0), 
		"PIA0M551" NUMBER(20,0), 
		"PIA0M552" NUMBER(20,0), 
		"PIA0M553" NUMBER(20,0), 
		"PIA0M554" NUMBER(20,0), 
		"PIA0M555" NUMBER(20,0), 
		"PIA0M556" NUMBER(20,0), 
		"PIA0M557" NUMBER(20,0), 
		"PIA0M558" NUMBER(20,0), 
		"PIA0M559" NUMBER(20,0), 
		"PIA0M560" NUMBER(20,0), 
		"PIA0M561" NUMBER(20,0), 
		"PIA0M562" NUMBER(20,0), 
		"PIA0M563" NUMBER(20,0), 
		"PIA0M564" NUMBER(20,0), 
		"PIA0M565" NUMBER(20,0), 
		"PIA0M566" NUMBER(20,0), 
		"PIA0M567" NUMBER(20,0), 
		"PIA0M568" NUMBER(20,0), 
		"PIA0M569" NUMBER(20,0), 
		"PIA0M570" NUMBER(20,0), 
		"PIA0M571" NUMBER(20,0), 
		"PIA0M572" NUMBER(20,0), 
		"PIA0M573" NUMBER(20,0), 
		"PIA0M574" NUMBER(20,0), 
		"PIA0M575" NUMBER(20,0), 
		"PIA0M576" NUMBER(20,0), 
		"PIA0M577" NUMBER(20,0), 
		"PIA0M578" NUMBER(20,0), 
		"PIA0M521" NUMBER(20,0), 
		"PIA0M356" NUMBER(20,0), 
		"PIA0M357" NUMBER(20,0), 
		"PIA0M358" NUMBER(20,0), 
		"PIA0M359" NUMBER(20,0), 
		"PIA0M090" NUMBER(20,0), 
		"PIA0M360" NUMBER(20,0), 
		"PIA0M579" NUMBER(20,0), 
		"PIA0M580" NUMBER(20,0), 
		"PIA0M581" NUMBER(20,0), 
		"PIA0M582" NUMBER(20,0), 
		"PIA0M101" NUMBER(20,0), 
		"PIA0M102" NUMBER(20,0), 
		"PIA0M361" NUMBER(20,0), 
		"PIA0M362" NUMBER(20,0), 
		"PIA0M363" NUMBER(20,0), 
		"PIA0M583" NUMBER(20,0), 
		"PIA0M584" NUMBER(20,0), 
		"PIA0M365" NUMBER(20,0), 
		"PIA0M366" NUMBER(20,0), 
		"PIA0M004" NUMBER(20,0), 
		"PIA0M163" NUMBER(20,0), 
		"PIA0M164" NUMBER(20,0), 
		"PIA0M166" NUMBER(20,0), 
		"PIA0M167" NUMBER(20,0), 
		"PIA0M168" NUMBER(20,0), 
		"PIA0M392" NUMBER(20,0), 
		"PIA0M393" NUMBER(20,0), 
		"PIA0M394" NUMBER(20,0), 
		"PIA0M395" NUMBER(20,0), 
		"PIA0M005" NUMBER(20,0), 
		"PIA0M585" NUMBER(20,0), 
		"PIA0M586" NUMBER(20,0), 
		"PIA0M587" NUMBER(20,0), 
		"PIA0M588" NUMBER(20,0), 
		"PIA0M589" NUMBER(20,0), 
		"PIA0M590" NUMBER(20,0), 
		"PIA0M591" NUMBER(20,0), 
		"PIA0M592" NUMBER(20,0), 
		"PIA0M177" NUMBER(20,0), 
		"PIA0M593" NUMBER(20,0), 
		"PIA0M594" NUMBER(20,0), 
		"PIA0M595" NUMBER(20,0), 
		"PIA0M180" NUMBER(20,0), 
		"PIA0M596" NUMBER(20,0), 
		"PIA0M597" NUMBER(20,0), 
		"PIA0M402" NUMBER(20,0), 
		"PIA0M403" NUMBER(20,0), 
		"PIA0M404" NUMBER(20,0), 
		"PIA0M186" NUMBER(20,0), 
		"PIA0M598" NUMBER(20,0), 
		"PIA0M599" NUMBER(20,0), 
		"PIA0M600" NUMBER(20,0), 
		"PIA0M601" NUMBER(20,0), 
		"PIA0M602" NUMBER(20,0), 
		"PIA0M603" NUMBER(20,0), 
		"PIA0M604" NUMBER(20,0), 
		"PIA0M605" NUMBER(20,0), 
		"PIA0M606" NUMBER(20,0), 
		"PIA0M607" NUMBER(20,0), 
		"PIA0M608" NUMBER(20,0), 
		"PIA0M609" NUMBER(20,0), 
		"PIA0M610" NUMBER(20,0), 
		"PIA0M611" NUMBER(20,0), 
		"PIA0M612" NUMBER(20,0), 
		"PIA0M613" NUMBER(20,0), 
		"PIA0M614" NUMBER(20,0), 
		"PIA0M615" NUMBER(20,0), 
		"PIA0M427" NUMBER(20,0), 
		"PIA0M428" NUMBER(20,0), 
		"PIA0M429" NUMBER(20,0), 
		"PIA0M211" NUMBER(20,0), 
		"PIA0M212" NUMBER(20,0), 
		"PIA0M616" NUMBER(20,0), 
		"PIA0M617" NUMBER(20,0), 
		"PIA0M618" NUMBER(20,0), 
		"PIA0M434" NUMBER(20,0), 
		"PIA0M435" NUMBER(20,0), 
		"PIA0M436" NUMBER(20,0), 
		"PIA0M222" NUMBER(20,0), 
		"PIA0M437" NUMBER(20,0), 
		"PIA0M438" NUMBER(20,0), 
		"PIA0M439" NUMBER(20,0), 
		"PIA0M224" NUMBER(20,0), 
		"PIA0M440" NUMBER(20,0), 
		"PIA0M441" NUMBER(20,0), 
		"PIA0M228" NUMBER(20,0), 
		"PIA0M444" NUMBER(20,0), 
		"PIA0M445" NUMBER(20,0), 
		"PIA0M619" NUMBER(20,0), 
		"PIA0M620" NUMBER(20,0), 
		"PIA0M621" NUMBER(20,0), 
		"PIA0M448" NUMBER(20,0), 
		"PIA0M449" NUMBER(20,0), 
		"PIA0M450" NUMBER(20,0), 
		"PIA0M451" NUMBER(20,0), 
		"PIA0M452" NUMBER(20,0), 
		"PIA0M234" NUMBER(20,0), 
		"PIA0M235" NUMBER(20,0), 
		"PIA0M622" NUMBER(20,0), 
		"PIA0M623" NUMBER(20,0), 
		"PIA0M624" NUMBER(20,0), 
		"PIA0M625" NUMBER(20,0), 
		"PIA0M626" NUMBER(20,0), 
		"PIA0M627" NUMBER(20,0), 
		"PIA0M628" NUMBER(20,0), 
		"PIA0M629" NUMBER(20,0), 
		"PIA0M630" NUMBER(20,0), 
		"PIA0M631" NUMBER(20,0), 
		"PIA0M632" NUMBER(20,0), 
		"PIA0M633" NUMBER(20,0), 
		"PIA0M240" NUMBER(20,0), 
		"PIA0M457" NUMBER(20,0), 
		"PIA0M458" NUMBER(20,0), 
		"PIA0M242" NUMBER(20,0), 
		"PIA0M459" NUMBER(20,0), 
		"PIA0M460" NUMBER(20,0), 
		"PIA0M461" NUMBER(20,0), 
		"PIA0M462" NUMBER(20,0), 
		"PIA0M463" NUMBER(20,0), 
		"PIA0M245" NUMBER(20,0), 
		"PIA0M246" NUMBER(20,0), 
		"PIA0M634" NUMBER(20,0), 
		"PIA0M635" NUMBER(20,0), 
		"PIA0M636" NUMBER(20,0), 
		"PIA0M249" NUMBER(20,0), 
		"PIA0M466" NUMBER(20,0), 
		"PIA0M467" NUMBER(20,0), 
		"PIA0M637" NUMBER(20,0), 
		"PIA0M638" NUMBER(20,0), 
		"PIA0M639" NUMBER(20,0), 
		"PIA0M470" NUMBER(20,0), 
		"PIA0M471" NUMBER(20,0), 
		"PIA0M472" NUMBER(20,0), 
		"PIA0M254" NUMBER(20,0), 
		"PIA0M473" NUMBER(20,0), 
		"PIA0M474" NUMBER(20,0), 
		"PIA0M475" NUMBER(20,0), 
		"PIA0M476" NUMBER(20,0), 
		"PIA0M477" NUMBER(20,0), 
		"PIA0M478" NUMBER(20,0), 
		"PIA0M479" NUMBER(20,0), 
		"PIA0M480" NUMBER(20,0), 
		"PIA0M481" NUMBER(20,0), 
		"PIA0M482" NUMBER(20,0), 
		"PIA0M483" NUMBER(20,0), 
		"PIA0M484" NUMBER(20,0), 
		"PIA0M485" NUMBER(20,0), 
		"PIA0M486" NUMBER(20,0), 
		"PIA0M640" NUMBER(20,0), 
		"PIA0M641" NUMBER(20,0), 
		"PIA0M642" NUMBER(20,0), 
		"PIA0M643" NUMBER(20,0), 
		"PIA0M644" NUMBER(20,0), 
		"PIA0M645" NUMBER(20,0), 
		"PIA0M646" NUMBER(20,0), 
		"PIA0M647" NUMBER(20,0), 
		"PIA0M648" NUMBER(20,0), 
		"PIA0M649" NUMBER(20,0), 
		"PIA0M650" NUMBER(20,0), 
		"PIA0M651" NUMBER(20,0), 
		"PIA0M652" NUMBER(20,0), 
		"PIA0M653" NUMBER(20,0), 
		"PIA0M654" NUMBER(20,0), 
		"PIA0M655" NUMBER(20,0), 
		"PIA0M656" NUMBER(20,0), 
		"PIA0M657" NUMBER(20,0), 
		"PIA0M658" NUMBER(20,0), 
		"PIA0M659" NUMBER(20,0), 
		"PIA0M660" NUMBER(20,0), 
		"PIA0M661" NUMBER(20,0), 
		"PIA0M662" NUMBER(20,0), 
		"PIA0M663" NUMBER(20,0), 
		"PIA0M664" NUMBER(20,0), 
		"PIA0M505" NUMBER(20,0), 
		"PIA0M506" NUMBER(20,0), 
		"PIA0M507" NUMBER(20,0), 
		"PIA0M508" NUMBER(20,0), 
		"PIA0M006" NUMBER(20,0), 
		"PIA0M509" NUMBER(20,0), 
		"PIA0M263" NUMBER(20,0), 
		"PIA0M665" NUMBER(20,0), 
		"PIA0M666" NUMBER(20,0), 
		"PIA0M667" NUMBER(20,0), 
		"PIA0M668" NUMBER(20,0), 
		"PIA0M669" NUMBER(20,0), 
		"PIA0M276" NUMBER(20,0), 
		"PIA0M277" NUMBER(20,0), 
		"PIA0M278" NUMBER(20,0), 
		"PIA0M279" NUMBER(20,0), 
		"PIA0M280" NUMBER(20,0), 
		"PIA0M281" NUMBER(20,0), 
		"PIA0M282" NUMBER(20,0), 
		"PIA0M283" NUMBER(20,0), 
		"PIA0M510" NUMBER(20,0), 
		"PIA0M511" NUMBER(20,0), 
		"PIA0M512" NUMBER(20,0), 
		"PIA0M513" NUMBER(20,0), 
		"PIA0M514" NUMBER(20,0), 
		"PIA0M515" NUMBER(20,0), 
		"PIA0M317" NUMBER(20,0), 
		"PIA0M318" NUMBER(20,0), 
		"PIA0M320" NUMBER(20,0), 
		"PIA0M319" NUMBER(20,0), 
		"PIA0M321" NUMBER(20,0), 
		"PIA0M322" NUMBER(20,0), 
		"PIA0M519" NUMBER(20,0), 
		"PIA0M670" NUMBER(20,0), 
		"PIA0M671" NUMBER(20,0), 
		"PIA0M327" NUMBER(20,0), 
		"PIA0M328" NUMBER(20,0), 
		"PIA0M672" NUMBER(20,0), 
		"PIA0M331" NUMBER(20,0), 
		"PIA0M332" NUMBER(20,0), 
		"PIA0M007" NUMBER(20,0), 
		"PIA0M673" NUMBER(20,0), 
		"PIA0M674" NUMBER(20,0), 
		"PIA0M675" NUMBER(20,0), 
		"PIA0M676" NUMBER(20,0), 
		"PIA0M677" NUMBER(20,0), 
		"PIA0M678" NUMBER(20,0), 
		"PIA0M679" NUMBER(20,0), 
		"PIA0M680" NUMBER(20,0), 
		"PIA0M681" NUMBER(20,0), 
		"PIA0M682" NUMBER(20,0), 
		"PIA0M683" NUMBER(20,0), 
		"PIA0M684" NUMBER(20,0), 
		"PIA0M685" NUMBER(20,0), 
		"PIA0M686" NUMBER(20,0), 
		"PIA0M687" NUMBER(20,0), 
		"PIA0M688" NUMBER(20,0), 
		"PIA0M689" NUMBER(20,0), 
		"PIA0M301" NUMBER(20,0), 
		"PIA0M302" NUMBER(20,0), 
		"PIA0M304" NUMBER(20,0), 
		"PIA0M303" NUMBER(20,0), 
		"PIA0M305" NUMBER(20,0), 
		"PIA0M306" NUMBER(20,0), 
		"PIA0M517" NUMBER(20,0), 
		"PIA0M690" NUMBER(20,0), 
		"PIA0M691" NUMBER(20,0), 
		"PIA0M311" NUMBER(20,0), 
		"PIA0M312" NUMBER(20,0), 
		"PIA0M313" NUMBER(20,0), 
		"PIA0M314" NUMBER(20,0), 
		"PIA0M315" NUMBER(20,0), 
		"PIA0M316" NUMBER(20,0), 
		"PIA0M518" NUMBER(20,0), 
		"PIA0M692" NUMBER(20,0), 
		"PIA0M333" NUMBER(20,0), 
		"PIA0M693" NUMBER(20,0), 
		"PIA0M694" NUMBER(20,0), 
		"PIA0M695" NUMBER(20,0), 
		"PIA0M009" NUMBER(20,0), 
		"PIA0M023" NUMBER(20,0), 
		"PIA0M024" NUMBER(20,0), 
		"PIA0M011" NUMBER(20,0), 
		"PIA0M012" NUMBER(20,0), 
		"PIA0M013" NUMBER(20,0), 
		"PIA0M025" NUMBER(20,0), 
		"PIA0M017" NUMBER(20,0), 
		"PIA0M018" NUMBER(20,0), 
		"PIA0M026" NUMBER(20,0), 
		"PIA0M027" NUMBER(20,0), 
		"PIA0M028" NUMBER(20,0), 
		"PIA0M029" NUMBER(20,0), 
		"PIA0M030" NUMBER(20,0), 
		"PIA0M031" NUMBER(20,0), 
		"PIA0M032" NUMBER(20,0), 
		"PIA0M033" NUMBER(20,0), 
		"PIA0M034" NUMBER(20,0), 
		"PIA0M035" NUMBER(20,0), 
		"PIA0M036" NUMBER(20,0), 
		"PIA0M037" NUMBER(20,0), 
		"SEMA_TIPUS" VARCHAR2(20 BYTE)
		)
		'
		;
		END IF;
	*/

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_pszaf_1b ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_pszaf_1b ||'
		("M003" VARCHAR2(8 BYTE), 
		"PIB0M000" NUMBER(20,0), 
		"PIB0M001" NUMBER(20,0), 
		"PIB0M374" NUMBER(20,0), 
		"PIB0M375" NUMBER(20,0), 
		"PIB0M376" NUMBER(20,0), 
		"PIB0M377" NUMBER(20,0), 
		"PIB0M378" NUMBER(20,0), 
		"PIB0M379" NUMBER(20,0), 
		"PIB0M380" NUMBER(20,0), 
		"PIB0M381" NUMBER(20,0), 
		"PIB0M382" NUMBER(20,0), 
		"PIB0M383" NUMBER(20,0), 
		"PIB0M384" NUMBER(20,0), 
		"PIB0M385" NUMBER(20,0), 
		"PIB0M036" NUMBER(20,0), 
		"PIB0M038" NUMBER(20,0), 
		"PIB0M039" NUMBER(20,0), 
		"PIB0M040" NUMBER(20,0), 
		"PIB0M251" NUMBER(20,0), 
		"PIB0M041" NUMBER(20,0), 
		"PIB0M386" NUMBER(20,0), 
		"PIB0M387" NUMBER(20,0), 
		"PIB0M388" NUMBER(20,0), 
		"PIB0M389" NUMBER(20,0), 
		"PIB0M390" NUMBER(20,0), 
		"PIB0M391" NUMBER(20,0), 
		"PIB0M392" NUMBER(20,0), 
		"PIB0M393" NUMBER(20,0), 
		"PIB0M394" NUMBER(20,0), 
		"PIB0M395" NUMBER(20,0), 
		"PIB0M396" NUMBER(20,0), 
		"PIB0M397" NUMBER(20,0), 
		"PIB0M066" NUMBER(20,0), 
		"PIB0M068" NUMBER(20,0), 
		"PIB0M069" NUMBER(20,0), 
		"PIB0M070" NUMBER(20,0), 
		"PIB0M256" NUMBER(20,0), 
		"PIB0M071" NUMBER(20,0), 
		"PIB0M072" NUMBER(20,0), 
		"PIB0M074" NUMBER(20,0), 
		"PIB0M075" NUMBER(20,0), 
		"PIB0M076" NUMBER(20,0), 
		"PIB0M257" NUMBER(20,0), 
		"PIB0M077" NUMBER(20,0), 
		"PIB0M078" NUMBER(20,0), 
		"PIB0M080" NUMBER(20,0), 
		"PIB0M081" NUMBER(20,0), 
		"PIB0M082" NUMBER(20,0), 
		"PIB0M258" NUMBER(20,0), 
		"PIB0M083" NUMBER(20,0), 
		"PIB0M084" NUMBER(20,0), 
		"PIB0M398" NUMBER(20,0), 
		"PIB0M399" NUMBER(20,0), 
		"PIB0M400" NUMBER(20,0), 
		"PIB0M261" NUMBER(20,0), 
		"PIB0M096" NUMBER(20,0), 
		"PIB0M097" NUMBER(20,0), 
		"PIB0M099" NUMBER(20,0), 
		"PIB0M100" NUMBER(20,0), 
		"PIB0M101" NUMBER(20,0), 
		"PIB0M262" NUMBER(20,0), 
		"PIB0M102" NUMBER(20,0), 
		"PIB0M103" NUMBER(20,0), 
		"PIB0M105" NUMBER(20,0), 
		"PIB0M106" NUMBER(20,0), 
		"PIB0M107" NUMBER(20,0), 
		"PIB0M263" NUMBER(20,0), 
		"PIB0M108" NUMBER(20,0), 
		"PIB0M401" NUMBER(20,0), 
		"PIB0M402" NUMBER(20,0), 
		"PIB0M403" NUMBER(20,0), 
		"PIB0M404" NUMBER(20,0), 
		"PIB0M267" NUMBER(20,0), 
		"PIB0M268" NUMBER(20,0), 
		"PIB0M269" NUMBER(20,0), 
		"PIB0M270" NUMBER(20,0), 
		"PIB0M271" NUMBER(20,0), 
		"PIB0M272" NUMBER(20,0), 
		"PIB0M273" NUMBER(20,0), 
		"PIB0M274" NUMBER(20,0), 
		"PIB0M275" NUMBER(20,0), 
		"PIB0M276" NUMBER(20,0), 
		"PIB0M277" NUMBER(20,0), 
		"PIB0M278" NUMBER(20,0), 
		"PIB0M279" NUMBER(20,0), 
		"PIB0M280" NUMBER(20,0), 
		"PIB0M281" NUMBER(20,0), 
		"PIB0M282" NUMBER(20,0), 
		"PIB0M283" NUMBER(20,0), 
		"PIB0M284" NUMBER(20,0), 
		"PIB0M285" NUMBER(20,0), 
		"PIB0M286" NUMBER(20,0), 
		"PIB0M287" NUMBER(20,0), 
		"PIB0M288" NUMBER(20,0), 
		"PIB0M289" NUMBER(20,0), 
		"PIB0M290" NUMBER(20,0), 
		"PIB0M291" NUMBER(20,0), 
		"PIB0M292" NUMBER(20,0), 
		"PIB0M293" NUMBER(20,0), 
		"PIB0M405" NUMBER(20,0), 
		"PIB0M406" NUMBER(20,0), 
		"PIB0M407" NUMBER(20,0), 
		"PIB0M408" NUMBER(20,0), 
		"PIB0M297" NUMBER(20,0), 
		"PIB0M298" NUMBER(20,0), 
		"PIB0M299" NUMBER(20,0), 
		"PIB0M409" NUMBER(20,0), 
		"PIB0M410" NUMBER(20,0), 
		"PIB0M411" NUMBER(20,0), 
		"PIB0M412" NUMBER(20,0), 
		"PIB0M413" NUMBER(20,0), 
		"PIB0M414" NUMBER(20,0), 
		"PIB0M415" NUMBER(20,0), 
		"PIB0M416" NUMBER(20,0), 
		"PIB0M417" NUMBER(20,0), 
		"PIB0M418" NUMBER(20,0), 
		"PIB0M419" NUMBER(20,0), 
		"PIB0M420" NUMBER(20,0), 
		"PIB0M421" NUMBER(20,0), 
		"PIB0M422" NUMBER(20,0), 
		"PIB0M423" NUMBER(20,0), 
		"PIB0M424" NUMBER(20,0), 
		"PIB0M425" NUMBER(20,0), 
		"PIB0M426" NUMBER(20,0), 
		"PIB0M427" NUMBER(20,0), 
		"PIB0M428" NUMBER(20,0), 
		"PIB0M429" NUMBER(20,0), 
		"PIB0M430" NUMBER(20,0), 
		"PIB0M431" NUMBER(20,0), 
		"PIB0M432" NUMBER(20,0), 
		"PIB0M433" NUMBER(20,0), 
		"PIB0M434" NUMBER(20,0), 
		"PIB0M435" NUMBER(20,0), 
		"PIB0M436" NUMBER(20,0), 
		"PIB0M437" NUMBER(20,0), 
		"PIB0M438" NUMBER(20,0), 
		"PIB0M439" NUMBER(20,0), 
		"PIB0M440" NUMBER(20,0), 
		"PIB0M441" NUMBER(20,0), 
		"PIB0M442" NUMBER(20,0), 
		"PIB0M443" NUMBER(20,0), 
		"PIB0M444" NUMBER(20,0), 
		"PIB0M445" NUMBER(20,0), 
		"PIB0M446" NUMBER(20,0), 
		"PIB0M447" NUMBER(20,0), 
		"PIB0M448" NUMBER(20,0), 
		"PIB0M449" NUMBER(20,0), 
		"PIB0M450" NUMBER(20,0), 
		"PIB0M451" NUMBER(20,0), 
		"PIB0M452" NUMBER(20,0), 
		"PIB0M453" NUMBER(20,0), 
		"PIB0M454" NUMBER(20,0), 
		"PIB0M455" NUMBER(20,0), 
		"PIB0M456" NUMBER(20,0), 
		"PIB0M457" NUMBER(20,0), 
		"PIB0M458" NUMBER(20,0), 
		"PIB0M459" NUMBER(20,0), 
		"PIB0M460" NUMBER(20,0), 
		"PIB0M461" NUMBER(20,0), 
		"PIB0M462" NUMBER(20,0), 
		"PIB0M463" NUMBER(20,0), 
		"PIB0M464" NUMBER(20,0), 
		"PIB0M465" NUMBER(20,0), 
		"PIB0M466" NUMBER(20,0), 
		"PIB0M467" NUMBER(20,0), 
		"PIB0M468" NUMBER(20,0), 
		"PIB0M469" NUMBER(20,0), 
		"PIB0M470" NUMBER(20,0), 
		"PIB0M471" NUMBER(20,0), 
		"PIB0M472" NUMBER(20,0), 
		"PIB0M473" NUMBER(20,0), 
		"PIB0M474" NUMBER(20,0), 
		"PIB0M475" NUMBER(20,0), 
		"PIB0M476" NUMBER(20,0), 
		"PIB0M477" NUMBER(20,0), 
		"PIB0M478" NUMBER(20,0), 
		"PIB0M479" NUMBER(20,0), 
		"PIB0M480" NUMBER(20,0), 
		"PIB0M481" NUMBER(20,0), 
		"PIB0M482" NUMBER(20,0), 
		"PIB0M483" NUMBER(20,0), 
		"PIB0M484" NUMBER(20,0), 
		"PIB0M485" NUMBER(20,0), 
		"PIB0M486" NUMBER(20,0), 
		"PIB0M487" NUMBER(20,0), 
		"PIB0M488" NUMBER(20,0), 
		"PIB0M489" NUMBER(20,0), 
		"PIB0M490" NUMBER(20,0), 
		"PIB0M491" NUMBER(20,0), 
		"PIB0M492" NUMBER(20,0), 
		"PIB0M493" NUMBER(20,0), 
		"PIB0M494" NUMBER(20,0), 
		"PIB0M495" NUMBER(20,0), 
		"PIB0M496" NUMBER(20,0), 
		"PIB0M497" NUMBER(20,0), 
		"PIB0M498" NUMBER(20,0), 
		"PIB0M499" NUMBER(20,0), 
		"PIB0M500" NUMBER(20,0), 
		"PIB0M501" NUMBER(20,0), 
		"PIB0M502" NUMBER(20,0), 
		"PIB0M503" NUMBER(20,0), 
		"PIB0M504" NUMBER(20,0), 
		"PIB0M505" NUMBER(20,0), 
		"PIB0M506" NUMBER(20,0), 
		"PIB0M507" NUMBER(20,0), 
		"PIB0M508" NUMBER(20,0), 
		"PIB0M509" NUMBER(20,0), 
		"PIB0M510" NUMBER(20,0), 
		"PIB0M511" NUMBER(20,0), 
		"PIB0M512" NUMBER(20,0), 
		"PIB0M513" NUMBER(20,0), 
		"PIB0M514" NUMBER(20,0), 
		"PIB0M515" NUMBER(20,0), 
		"PIB0M516" NUMBER(20,0), 
		"PIB0M517" NUMBER(20,0), 
		"PIB0M518" NUMBER(20,0), 
		"PIB0M519" NUMBER(20,0), 
		"PIB0M520" NUMBER(20,0), 
		"PIB0M521" NUMBER(20,0), 
		"PIB0M522" NUMBER(20,0), 
		"PIB0M523" NUMBER(20,0), 
		"PIB0M524" NUMBER(20,0), 
		"PIB0M525" NUMBER(20,0), 
		"PIB0M526" NUMBER(20,0), 
		"PIB0M527" NUMBER(20,0), 
		"PIB0M528" NUMBER(20,0), 
		"PIB0M529" NUMBER(20,0), 
		"PIB0M530" NUMBER(20,0), 
		"PIB0M531" NUMBER(20,0), 
		"PIB0M196" NUMBER(20,0), 
		"PIB0M197" NUMBER(20,0), 
		"PIB0M199" NUMBER(20,0), 
		"PIB0M198" NUMBER(20,0), 
		"PIB0M346" NUMBER(20,0), 
		"PIB0M200" NUMBER(20,0), 
		"PIB0M347" NUMBER(20,0), 
		"PIB0M532" NUMBER(20,0), 
		"PIB0M533" NUMBER(20,0), 
		"PIB0M205" NUMBER(20,0), 
		"PIB0M206" NUMBER(20,0), 
		"PIB0M534" NUMBER(20,0), 
		"PIB0M209" NUMBER(20,0), 
		"PIB0M210" NUMBER(20,0), 
		"PIB0M535" NUMBER(20,0), 
		"PIB0M536" NUMBER(20,0), 
		"PIB0M537" NUMBER(20,0), 
		"PIB0M538" NUMBER(20,0), 
		"PIB0M539" NUMBER(20,0), 
		"PIB0M540" NUMBER(20,0), 
		"PIB0M541" NUMBER(20,0), 
		"PIB0M542" NUMBER(20,0), 
		"PIB0M543" NUMBER(20,0), 
		"PIB0M544" NUMBER(20,0), 
		"PIB0M545" NUMBER(20,0), 
		"PIB0M546" NUMBER(20,0), 
		"PIB0M547" NUMBER(20,0), 
		"PIB0M548" NUMBER(20,0), 
		"PIB0M549" NUMBER(20,0), 
		"PIB0M550" NUMBER(20,0), 
		"PIB0M551" NUMBER(20,0), 
		"PIB0M194" NUMBER(20,0), 
		"PIB0M195" NUMBER(20,0), 
		"PIB0M212" NUMBER(20,0), 
		"PIB0M213" NUMBER(20,0), 
		"PIB0M215" NUMBER(20,0), 
		"PIB0M214" NUMBER(20,0), 
		"PIB0M216" NUMBER(20,0), 
		"PIB0M217" NUMBER(20,0), 
		"PIB0M348" NUMBER(20,0), 
		"PIB0M552" NUMBER(20,0), 
		"PIB0M553" NUMBER(20,0), 
		"PIB0M222" NUMBER(20,0), 
		"PIB0M223" NUMBER(20,0), 
		"PIB0M224" NUMBER(20,0), 
		"PIB0M225" NUMBER(20,0), 
		"PIB0M226" NUMBER(20,0), 
		"PIB0M227" NUMBER(20,0), 
		"PIB0M349" NUMBER(20,0), 
		"PIB0M228" NUMBER(20,0), 
		"PIB0M554" NUMBER(20,0), 
		"PIB0M555" NUMBER(20,0), 
		"PIB0M556" NUMBER(20,0), 
		"PIB0M557" NUMBER(20,0), 
		"PIB0M008" NUMBER(20,0), 
		"PIB0M242" NUMBER(20,0), 
		"PIB0M243" NUMBER(20,0), 
		"PIB0M244" NUMBER(20,0), 
		"PIB0M245" NUMBER(20,0), 
		"PIB0M009" NUMBER(20,0), 
		"PIB0M558" NUMBER(20,0), 
		"PIB0M559" NUMBER(20,0), 
		"PIB0M011" NUMBER(20,0), 
		"PIB0M015" NUMBER(20,0), 
		"PIB0M016" NUMBER(20,0), 
		"PIB0M017" NUMBER(20,0), 
		"PIB0M018" NUMBER(20,0), 
		"PIB0M019" NUMBER(20,0), 
		"PIB0M560" NUMBER(20,0), 
		"PIB0M561" NUMBER(20,0), 
		"PIB0M562" NUMBER(20,0), 
		"PIB0M563" NUMBER(20,0), 
		"PIB0M564" NUMBER(20,0), 
		"PIB0M565" NUMBER(20,0), 
		"PIB0M021" NUMBER(20,0), 
		"PIBOM566" NUMBER(20,0)
		) 	
		'
		;
		
		END IF;
	*/
	
	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pszaf1an'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pszaf1an'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_pszaf_1an ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_pszaf_1an, ''|| evszam ||'');

	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;			

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_pszaf_1an ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;		

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pszaf1b'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pszaf1b'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		
	
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_pszaf_1b ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_pszaf_1b, ''|| evszam ||'');
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;		

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_pszaf_1b ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;	
	
END IF;	


IF v_mnb_pen = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_penz_vall ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_penz_vall ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PVB0M000" NUMBER(15,0), 
		"PVB0M009" NUMBER(15,0), 
		"PVC001" NUMBER(15,0), 
		"PVC002" NUMBER(15,0), 
		"PVC007" NUMBER(15,0), 
		"PVC008" NUMBER(15,0), 
		"PVC009" NUMBER(15,0), 
		"PVC010" NUMBER(15,0), 
		"PVC011" NUMBER(15,0), 
		"PVC012" NUMBER(15,0), 
		"PVC013" NUMBER(15,0), 
		"PVC014" NUMBER(15,0), 
		"PVC015" NUMBER(15,0), 
		"PVC016" NUMBER(15,0), 
		"PVC017" NUMBER(15,0), 
		"PVC018" NUMBER(15,0), 
		"PVC019" NUMBER(15,0), 
		"PVC020" NUMBER(15,0), 
		"PVC021" NUMBER(15,0), 
		"PVC022" NUMBER(15,0), 
		"PVC023" NUMBER(15,0), 
		"PVC024" NUMBER(15,0), 
		"PVC025" NUMBER(15,0), 
		"PVC026" NUMBER(15,0), 
		"PVC027" NUMBER(15,0), 
		"PVC028" NUMBER(15,0), 
		"PVC029" NUMBER(15,0), 
		"PVC030" NUMBER(15,0), 
		"PVC031" NUMBER(15,0), 
		"PVC032" NUMBER(15,0), 
		"PVC033" NUMBER(15,0), 
		"PVC034" NUMBER(15,0), 
		"PVC035" NUMBER(15,0), 
		"PVC036" NUMBER(15,0), 
		"PVC037" NUMBER(15,0), 
		"PVC038" NUMBER(15,0), 
		"PVC039" NUMBER(15,0), 
		"PVC040" NUMBER(15,0), 
		"PVC041" NUMBER(15,0), 
		"PVC042" NUMBER(15,0)
		)
		'
		;
	
		END IF;
	*/

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pvall'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''pvall'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_penz_vall ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_penz_vall, ''|| evszam ||'');	

	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_penz_vall ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;		
	
END IF;	


IF v_mnb_biz = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_bizt ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_bizt ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"KOMPOZIT" VARCHAR2(2 BYTE), 
		"INT_EGY" VARCHAR2(2 BYTE), 
		"PBC001" NUMBER(15,0), 
		"PBC002" NUMBER(15,0), 
		"PBC003" NUMBER(15,0), 
		"PBC004" NUMBER(15,0), 
		"PBC005" NUMBER(15,0), 
		"PBC007" NUMBER(15,0), 
		"PBC008" NUMBER(15,0), 
		"PBC009" NUMBER(15,0), 
		"PBC010" NUMBER(15,0), 
		"PBC012" NUMBER(15,0), 
		"PBC013" NUMBER(15,0), 
		"PBC014" NUMBER(15,0), 
		"PBC016" NUMBER(15,0), 
		"PBC017" NUMBER(15,0), 
		"PBC018" NUMBER(15,0), 
		"PBC019" NUMBER(15,0), 
		"PBC020" NUMBER(15,0), 
		"PBC021" NUMBER(15,0), 
		"PBC028" NUMBER(15,0), 
		"PBC030" NUMBER(15,0), 
		"PBC031" NUMBER(15,0), 
		"PBC032" NUMBER(15,0), 
		"PBC033" NUMBER(15,0), 
		"PBC034" NUMBER(15,0), 
		"PBC035" NUMBER(15,0), 
		"PBC036" NUMBER(15,0), 
		"PBC037" NUMBER(15,0), 
		"PBC038" NUMBER(15,0), 
		"PBC039" NUMBER(15,0), 
		"PBC040" NUMBER(15,0), 
		"PBC048" NUMBER(15,0), 
		"PBC051" NUMBER(15,0), 
		"PBC052" NUMBER(15,0), 
		"PBC053" NUMBER(15,0), 
		"PBC054" NUMBER(15,0), 
		"PBC055" NUMBER(15,0), 
		"PBC057" NUMBER(15,0), 
		"PBC063" NUMBER(15,0), 
		"PBC065" NUMBER(15,0), 
		"PBC066" NUMBER(15,0), 
		"PBC067" NUMBER(15,0), 
		"PBC069" NUMBER(15,0), 
		"PBC070" NUMBER(15,0), 
		"PBC071" NUMBER(15,0), 
		"PBC074" NUMBER(15,0), 
		"PBC075" NUMBER(15,0), 
		"PBC087" NUMBER(15,0), 
		"PBC089" NUMBER(15,0), 
		"PBC090" NUMBER(15,0), 
		"PBC091" NUMBER(15,0), 
		"PBC094" NUMBER(15,0), 
		"PBC095" NUMBER(15,0), 
		"PBC096" NUMBER(15,0), 
		"PBC097" NUMBER(15,0), 
		"PBC098" NUMBER(15,0), 
		"PBC099" NUMBER(15,0), 
		"PBC100" NUMBER(15,0), 
		"PBC101" NUMBER(15,0), 
		"PBC104" NUMBER(15,0), 
		"PBC107" NUMBER(15,0), 
		"PBC108" NUMBER(15,0), 
		"PBC109" NUMBER(15,0), 
		"PBC110" NUMBER(15,0), 
		"PBC111" NUMBER(15,0), 
		"PBC112" NUMBER(15,0), 
		"PBC113" NUMBER(15,0), 
		"PBC117" NUMBER(15,0), 
		"PBC118" NUMBER(15,0), 
		"PBC119" NUMBER(15,0), 
		"PBC120" NUMBER(15,0), 
		"PBC121" NUMBER(15,0), 
		"PBC122" NUMBER(15,0), 
		"PBC123" NUMBER(15,0), 
		"PBC124" NUMBER(15,0), 
		"PBC125" NUMBER(15,0), 
		"PBC126" NUMBER(15,0), 
		"PBC127" NUMBER(15,0), 
		"PBC128" NUMBER(15,0), 
		"PBC129" NUMBER(15,0), 
		"PBC130" NUMBER(15,0), 
		"PBC131" NUMBER(15,0), 
		"PBC132" NUMBER(15,0), 
		"PBC133" NUMBER(15,0), 
		"PBC134" NUMBER(15,0), 
		"PBC135" NUMBER(15,0), 
		"PBC136" NUMBER(15,0), 
		"PBC137" NUMBER(15,0), 
		"PBC138" NUMBER(15,0), 
		"PBC139" NUMBER(15,0), 
		"PBC140" NUMBER(15,0), 
		"PBC141" NUMBER(15,0), 
		"PBC142" NUMBER(15,0), 
		"PBC143" NUMBER(15,0), 
		"PBC144" NUMBER(15,0), 
		"PBC145" NUMBER(15,0), 
		"PBC146" NUMBER(15,0), 
		"PBC147" NUMBER(15,0), 
		"PBC148" NUMBER(15,0), 
		"PBC149" NUMBER(15,0), 
		"PBC150" NUMBER(15,0), 
		"PBC151" NUMBER(15,0), 
		"PBC152" NUMBER(15,0), 
		"PBC153" NUMBER(15,0), 
		"PMC001" NUMBER(15,0), 
		"PMC002" NUMBER(15,0), 
		"PMC003" NUMBER(15,0), 
		"PMC004" NUMBER(15,0), 
		"PMC005" NUMBER(15,0), 
		"PMC006" NUMBER(15,0), 
		"PMC007" NUMBER(15,0), 
		"PMC008" NUMBER(15,0), 
		"PMC009" NUMBER(15,0), 
		"PMC010" NUMBER(15,0), 
		"PMC011" NUMBER(15,0), 
		"PMC012" NUMBER(15,0), 
		"PMC013" NUMBER(15,0), 
		"PMC014" NUMBER(15,0), 
		"PMC015" NUMBER(15,0), 
		"PMC016" NUMBER(15,0), 
		"PMC017" NUMBER(15,0), 
		"PMC018" NUMBER(15,0), 
		"PMC019" NUMBER(15,0), 
		"PMC020" NUMBER(15,0), 
		"PMC021" NUMBER(15,0), 
		"PMC022" NUMBER(15,0), 
		"PMC023" NUMBER(15,0), 
		"PMC024" NUMBER(15,0), 
		"PMC025" NUMBER(15,0), 
		"PMC026" NUMBER(15,0), 
		"PMC027" NUMBER(15,0), 
		"PMC028" NUMBER(15,0), 
		"PMC029" NUMBER(15,0), 
		"PMC030" NUMBER(15,0), 
		"PMC031" NUMBER(15,0), 
		"PMC032" NUMBER(15,0), 
		"PMC033" NUMBER(15,0), 
		"PMC034" NUMBER(15,0), 
		"PMC035" NUMBER(15,0), 
		"PMC036" NUMBER(15,0), 
		"PMC037" NUMBER(15,0), 
		"PMC038" NUMBER(15,0), 
		"PMC039" NUMBER(15,0), 
		"PMC040" NUMBER(15,0), 
		"PMC041" NUMBER(15,0), 
		"PMC042" NUMBER(15,0), 
		"PMC043" NUMBER(15,0), 
		"PMC044" NUMBER(15,0), 
		"PMC045" NUMBER(15,0), 
		"PMC046" NUMBER(15,0), 
		"PMC047" NUMBER(15,0), 
		"PMC048" NUMBER(15,0), 
		"PMC050" NUMBER(15,0), 
		"PMC052" NUMBER(15,0), 
		"PMC053" NUMBER(15,0), 
		"PMC055" NUMBER(15,0), 
		"PMC056" NUMBER(15,0), 
		"PMC057" NUMBER(15,0), 
		"PMC058" NUMBER(15,0), 
		"PMC059" NUMBER(15,0), 
		"PMC060" NUMBER(15,0), 
		"PMC061" NUMBER(15,0), 
		"PMC065" NUMBER(15,0), 
		"PMC066" NUMBER(15,0), 
		"PMC067" NUMBER(15,0), 
		"PMC068" NUMBER(15,0), 
		"PMC069" NUMBER(15,0), 
		"PMC070" NUMBER(15,0), 
		"PMC071" NUMBER(15,0), 
		"PMC072" NUMBER(15,0), 
		"PMC073" NUMBER(15,0), 
		"PMC074" NUMBER(15,0), 
		"PMC075" NUMBER(15,0), 
		"PMC076" NUMBER(15,0), 
		"PMC077" NUMBER(15,0), 
		"PMC078" NUMBER(15,0), 
		"PMC079" NUMBER(15,0), 
		"PMC080" NUMBER(15,0), 
		"PMC081" NUMBER(15,0), 
		"PMC082" NUMBER(15,0), 
		"PMC083" NUMBER(15,0), 
		"PMC084" NUMBER(15,0), 
		"PMC085" NUMBER(15,0), 
		"PMC086" NUMBER(15,0), 
		"PMC087" NUMBER(15,0), 
		"PMC088" NUMBER(15,0), 
		"PMC089" NUMBER(15,0), 
		"PMC090" NUMBER(15,0), 
		"PMC091" NUMBER(15,0), 
		"POC001" NUMBER(15,0), 
		"POC002" NUMBER(15,0), 
		"POC003" NUMBER(15,0), 
		"POC004" NUMBER(15,0), 
		"POC005" NUMBER(15,0), 
		"POC009" NUMBER(15,0), 
		"POC010" NUMBER(15,0), 
		"POC011" NUMBER(15,0), 
		"POC012" NUMBER(15,0), 
		"POC013" NUMBER(15,0), 
		"POC014" NUMBER(15,0), 
		"POC015" NUMBER(15,0), 
		"POC016" NUMBER(15,0), 
		"POC017" NUMBER(15,0), 
		"POC018" NUMBER(15,0), 
		"POC019" NUMBER(15,0), 
		"POC020" NUMBER(15,0), 
		"POC021" NUMBER(15,0), 
		"POC022" NUMBER(15,0), 
		"POC023" NUMBER(15,0), 
		"POC024" NUMBER(15,0), 
		"POC025" NUMBER(15,0), 
		"POC028" NUMBER(15,0), 
		"POC029" NUMBER(15,0), 
		"POC031" NUMBER(15,0), 
		"POC032" NUMBER(15,0), 
		"POC037" NUMBER(15,0), 
		"POC039" NUMBER(15,0), 
		"POC040" NUMBER(15,0), 
		"POC041" NUMBER(15,0), 
		"POC044" NUMBER(15,0), 
		"POC045" NUMBER(15,0), 
		"POC046" NUMBER(15,0), 
		"POC047" NUMBER(15,0), 
		"POC048" NUMBER(15,0), 
		"POC049" NUMBER(15,0), 
		"POC050" NUMBER(15,0), 
		"POC051" NUMBER(15,0), 
		"POC052" NUMBER(15,0), 
		"POC053" NUMBER(15,0), 
		"PXC001" NUMBER(15,0), 
		"PXC002" NUMBER(15,0), 
		"PXC003" NUMBER(15,0), 
		"PXC004" NUMBER(15,0), 
		"PXC005" NUMBER(15,0), 
		"PXC014" NUMBER(15,0), 
		"PXC016" NUMBER(15,0), 
		"PXC017" NUMBER(15,0), 
		"PXC018" NUMBER(15,0), 
		"PXC019" NUMBER(15,0), 
		"PXC020" NUMBER(15,0), 
		"PXC021" NUMBER(15,0), 
		"PXC028" NUMBER(15,0), 
		"PXC030" NUMBER(15,0), 
		"PXC032" NUMBER(15,0), 
		"PXC033" NUMBER(15,0), 
		"PXC034" NUMBER(15,0), 
		"PXC035" NUMBER(15,0), 
		"PXC036" NUMBER(15,0), 
		"PXC037" NUMBER(15,0), 
		"PXC048" NUMBER(15,0), 
		"PXC051" NUMBER(15,0), 
		"PXC052" NUMBER(15,0), 
		"PXC053" NUMBER(15,0), 
		"PXC054" NUMBER(15,0), 
		"PXC055" NUMBER(15,0), 
		"PXC063" NUMBER(15,0), 
		"PXC065" NUMBER(15,0), 
		"PXC101" NUMBER(15,0), 
		"PXC104" NUMBER(15,0), 
		"PXC125" NUMBER(15,0), 
		"PXC135" NUMBER(15,0), 
		"PXC136" NUMBER(15,0), 
		"PXC137" NUMBER(15,0), 
		"PXC138" NUMBER(15,0), 
		"PXC139" NUMBER(15,0), 
		"PXC140" NUMBER(15,0), 
		"PXC141" NUMBER(15,0), 
		"PXC142" NUMBER(15,0), 
		"PXC143" NUMBER(15,0), 
		"PXC144" NUMBER(15,0), 
		"PXC145" NUMBER(15,0), 
		"PXC146" NUMBER(15,0), 
		"PXC147" NUMBER(15,0), 
		"PXC148" NUMBER(15,0), 
		"PXC149" NUMBER(15,0), 
		"PXC150" NUMBER(15,0), 
		"PXC151" NUMBER(15,0), 
		"PXC152" NUMBER(15,0), 
		"PXC153" NUMBER(20,0), 
		"PBBOM001" NUMBER(15,0), 
		"PBBOM807" NUMBER(15,0), 
		"PBBOM844" NUMBER(15,0), 
		"PBAOM854" NUMBER(15,0), 
		"PBAOM855" NUMBER(15,0), 
		"PBAOM856" NUMBER(15,0), 
		"PBAOM000" NUMBER(15,0), 
		"PBAOM002" NUMBER(15,0), 
		"PBAOM803" NUMBER(15,0), 
		"PBAOM009" NUMBER(15,0), 
		"PBAOM834" NUMBER(15,0), 
		"PBAOM835" NUMBER(15,0), 
		"PBAOM836" NUMBER(15,0), 
		"PBAOM837" NUMBER(15,0), 
		"PBAOM838" NUMBER(15,0), 
		"PBAOM839" NUMBER(15,0), 
		"PBAOM806" NUMBER(15,0), 
		"PBAOM840" NUMBER(15,0), 
		"PBAOM841" NUMBER(15,0), 
		"PBAOM842" NUMBER(15,0), 
		"PBAOM813" NUMBER(15,0), 
		"PBAOM814" NUMBER(15,0), 
		"PBAOM815" NUMBER(15,0), 
		"PBAOM816" NUMBER(15,0), 
		"PBAOM817" NUMBER(15,0), 
		"PBAOM818" NUMBER(15,0), 
		"PBAOM851" NUMBER(15,0), 
		"PBAOM819" NUMBER(15,0), 
		"PBAOM820" NUMBER(15,0), 
		"PBAOM035" NUMBER(15,0), 
		"PBAOM821" NUMBER(15,0), 
		"PBAOM843" NUMBER(15,0), 
		"PBAOM844" NUMBER(15,0), 
		"PBAOM822" NUMBER(15,0), 
		"PBAOM845" NUMBER(15,0), 
		"PBAOM846" NUMBER(15,0), 
		"PBAOM823" NUMBER(15,0), 
		"PBAOM847" NUMBER(15,0), 
		"PBAOM848" NUMBER(15,0), 
		"PBAOM824" NUMBER(15,0), 
		"PBAOM825" NUMBER(15,0), 
		"PBAOM849" NUMBER(15,0), 
		"PBAOM850" NUMBER(15,0), 
		"PBAOM852" NUMBER(15,0), 
		"PBAOM853" NUMBER(15,0), 
		"PBAOM826" NUMBER(15,0), 
		"PBAOM827" NUMBER(15,0), 
		"PBAOM828" NUMBER(15,0), 
		"PBAOM829" NUMBER(15,0), 
		"PBAOM830" NUMBER(15,0), 
		"PBAOM048" NUMBER(15,0), 
		"PBAOM831" NUMBER(15,0), 
		"PBAOM832" NUMBER(15,0), 
		"PBAOM833" NUMBER(15,0), 
		"PBBOM000" NUMBER(15,0), 
		"PBBOM002" NUMBER(15,0), 
		"PBBOM037" NUMBER(15,0), 
		"PBBOM038" NUMBER(15,0), 
		"PBBOM012" NUMBER(15,0), 
		"PBBOM013" NUMBER(15,0), 
		"PBBOM850" NUMBER(15,0), 
		"PBBOM044" NUMBER(15,0), 
		"PBBOM879" NUMBER(15,0), 
		"PBBOM880" NUMBER(15,0), 
		"PBBOM881" NUMBER(15,0), 
		"PBBOM015" NUMBER(15,0), 
		"PBBOM806" NUMBER(15,0), 
		"PBBOM808" NUMBER(15,0), 
		"PBBOM809" NUMBER(15,0), 
		"PBBOM810" NUMBER(15,0), 
		"PBBOM859" NUMBER(15,0), 
		"PBBOM811" NUMBER(15,0), 
		"PBBOM851" NUMBER(15,0), 
		"PBBOM813" NUMBER(15,0), 
		"PBBOM860" NUMBER(15,0), 
		"PBBOM861" NUMBER(15,0), 
		"PBBOM815" NUMBER(15,0), 
		"PBBOM816" NUMBER(15,0), 
		"PBBOM817" NUMBER(15,0), 
		"PBBOM818" NUMBER(15,0), 
		"PBBOM819" NUMBER(15,0), 
		"PBBOM820" NUMBER(15,0), 
		"PBBOM821" NUMBER(15,0), 
		"PBBOM822" NUMBER(15,0), 
		"PBBOM823" NUMBER(15,0), 
		"PBBOM884" NUMBER(15,0), 
		"PBBOM885" NUMBER(15,0), 
		"PBBOM886" NUMBER(15,0), 
		"PBBOM887" NUMBER(15,0), 
		"PBBOM888" NUMBER(15,0), 
		"PBBOM889" NUMBER(15,0), 
		"PBBOM854" NUMBER(15,0), 
		"PBBOM890" NUMBER(15,0), 
		"PBBOM891" NUMBER(15,0), 
		"PBBOM892" NUMBER(15,0), 
		"PBBOM893" NUMBER(15,0), 
		"PBBOM894" NUMBER(15,0), 
		"PBBOM895" NUMBER(15,0), 
		"PBBOM836" NUMBER(15,0), 
		"PBBOM841" NUMBER(15,0), 
		"PBBOM897" NUMBER(15,0), 
		"PBBOM898" NUMBER(15,0), 
		"PBBOM899" NUMBER(15,0), 
		"PBBOM900" NUMBER(15,0), 
		"PBBOM901" NUMBER(15,0), 
		"PBBOM902" NUMBER(15,0), 
		"PBBOM857" NUMBER(15,0), 
		"PBBOM858" NUMBER(15,0), 
		"PBBOM878" NUMBER(15,0), 
		"PBBOM862" NUMBER(15,0), 
		"PBBOM863" NUMBER(15,0), 
		"PBBOM864" NUMBER(15,0), 
		"PBBOM845" NUMBER(15,0), 
		"PBBOM020" NUMBER(15,0), 
		"PBBOM846" NUMBER(15,0), 
		"PBBOM865" NUMBER(15,0), 
		"PBBOM866" NUMBER(15,0), 
		"PBBOM847" NUMBER(15,0), 
		"PBBOM867" NUMBER(15,0), 
		"PBBOM868" NUMBER(15,0), 
		"PBBOM025" NUMBER(15,0), 
		"PBBOM869" NUMBER(15,0), 
		"PBBOM870" NUMBER(15,0), 
		"PBBOM848" NUMBER(15,0), 
		"PBBOM871" NUMBER(15,0), 
		"PBBOM872" NUMBER(15,0), 
		"PBBOM849" NUMBER(15,0), 
		"PBBOM873" NUMBER(15,0), 
		"PBBOM874" NUMBER(15,0), 
		"PBBOM882" NUMBER(15,0), 
		"PBBOM883" NUMBER(15,0), 
		"PBBOM035" NUMBER(15,0), 
		"PBBOM875" NUMBER(15,0), 
		"PBBOM876" NUMBER(15,0), 
		"PBBOM877" NUMBER(15,0), 
		"PBD001" NUMBER(15,0), 
		"PBD002" NUMBER(15,0), 
		"PBD003" NUMBER(15,0), 
		"PBD004" NUMBER(15,0), 
		"PBD005" NUMBER(15,0), 
		"PBD006" NUMBER(15,0), 
		"PBD007" NUMBER(15,0), 
		"PBK001" NUMBER(15,0), 
		"PBK002" NUMBER(15,0), 
		"PBK003" NUMBER(15,0), 
		"PBK004" NUMBER(15,0), 
		"PBK005" NUMBER(15,0), 
		"PBK006" NUMBER(15,0), 
		"PBK007" NUMBER(15,0), 
		"PBK008" NUMBER(15,0), 
		"PBK009" NUMBER(15,0), 
		"PBK010" NUMBER(15,0), 
		"PBK011" NUMBER(15,0), 
		"PBK012" NUMBER(15,0), 
		"PBK013" NUMBER(15,0), 
		"PBK014" NUMBER(15,0), 
		"PBK015" NUMBER(15,0), 
		"PBK016" NUMBER(15,0), 
		"PBK017" NUMBER(15,0), 
		"PBK018" NUMBER(15,0), 
		"PBK019" NUMBER(15,0), 
		"PBK020" NUMBER(15,0), 
		"PBK021" NUMBER(15,0), 
		"PBK022" NUMBER(15,0), 
		"PBK023" NUMBER(15,0), 
		"PBK024" NUMBER(15,0), 
		"PBB001" NUMBER(15,0), 
		"PBB002" NUMBER(15,0), 
		"PBB003" NUMBER(15,0), 
		"PBB004" NUMBER(15,0), 
		"PBB005" NUMBER(15,0), 
		"PBB006" NUMBER(15,0), 
		"PBB007" NUMBER(15,0), 
		"PBB008" NUMBER(15,0), 
		"PBB009" NUMBER(15,0), 
		"PBB010" NUMBER(15,0), 
		"PBB011" NUMBER(15,0), 
		"PBB012" NUMBER(15,0), 
		"PBH001" NUMBER(15,0), 
		"PBH002" NUMBER(15,0), 
		"PBH003" NUMBER(15,0), 
		"PBH004" NUMBER(15,0), 
		"PBH005" NUMBER(15,0), 
		"PBH006" NUMBER(15,0), 
		"PBH007" NUMBER(15,0), 
		"PBH008" NUMBER(15,0), 
		"PBH009" NUMBER(15,0), 
		"PBH010" NUMBER(15,0), 
		"PBH011" NUMBER(15,0), 
		"PBH012" NUMBER(15,0), 
		"PBL001" NUMBER(15,0), 
		"PBL002" NUMBER(15,0), 
		"PBL003" NUMBER(15,0), 
		"PBL004" NUMBER(15,0), 
		"PBL005" NUMBER(15,0), 
		"PBL006" NUMBER(15,0), 
		"PBL007" NUMBER(15,0), 
		"PBL008" NUMBER(15,0), 
		"PBL009" NUMBER(15,0), 
		"PBL010" NUMBER(15,0), 
		"PBL011" NUMBER(15,0), 
		"PBL012" NUMBER(15,0), 
		"PBL013" NUMBER(15,0), 
		"PBL014" NUMBER(15,0), 
		"PBL015" NUMBER(15,0), 
		"PBL036" NUMBER(15,0), 
		"PBL037" NUMBER(15,0), 
		"PBL038" NUMBER(15,0), 
		"PBL039" NUMBER(15,0), 
		"PBL040" NUMBER(15,0), 
		"PBL041" NUMBER(15,0), 
		"PBL042" NUMBER(15,0), 
		"PBL043" NUMBER(15,0), 
		"PBL044" NUMBER(15,0), 
		"PBL045" NUMBER(15,0), 
		"PBL046" NUMBER(15,0), 
		"PBL047" NUMBER(15,0), 
		"PBL048" NUMBER(15,0), 
		"PBL049" NUMBER(15,0), 
		"PBL050" NUMBER(15,0), 
		"PBL051" NUMBER(15,0), 
		"PBL052" NUMBER(15,0), 
		"PBL053" NUMBER(15,0), 
		"PBL054" NUMBER(15,0), 
		"PBL055" NUMBER(15,0), 
		"PBL056" NUMBER(15,0), 
		"PBL057" NUMBER(15,0), 
		"PBL058" NUMBER(15,0), 
		"PBL059" NUMBER(15,0), 
		"PBL060" NUMBER(15,0), 
		"PBL061" NUMBER(15,0), 
		"PBL062" NUMBER(15,0), 
		"PBL063" NUMBER(15,0), 
		"PBL064" NUMBER(15,0), 
		"PBL065" NUMBER(15,0), 
		"PBL066" NUMBER(15,0), 
		"PBL067" NUMBER(15,0), 
		"PBL068" NUMBER(15,0), 
		"PBL069" NUMBER(15,0), 
		"PBL070" NUMBER(15,0), 
		"PBL071" NUMBER(15,0), 
		"PBL072" NUMBER(15,0), 
		"PBL073" NUMBER(15,0), 
		"PBL074" NUMBER(15,0), 
		"PBL075" NUMBER(15,0), 
		"PBL076" NUMBER(15,0), 
		"PBKD001" NUMBER(15,0), 
		"PBKD002" NUMBER(15,0), 
		"PBKD003" NUMBER(15,0), 
		"PBKD004" NUMBER(15,0), 
		"PBKD005" NUMBER(15,0), 
		"PBKD006" NUMBER(15,0), 
		"PBKD007" NUMBER(15,0), 
		"PBKD008" NUMBER(15,0), 
		"PBKK001" NUMBER(15,0), 
		"PBKK002" NUMBER(15,0), 
		"PBKK003" NUMBER(15,0), 
		"PBKK004" NUMBER(15,0), 
		"PBKK005" NUMBER(15,0), 
		"PBKK006" NUMBER(15,0), 
		"PBKK007" NUMBER(15,0), 
		"PBKK008" NUMBER(15,0)
		)
		'
		;
		
		END IF;
	*/

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''bizt'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''bizt'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;		

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_bizt, ''|| evszam ||'');	

	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_bizt ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;
	
	-- pp17_w_bizt tábla esetén a KOMPOZIT és INT_EGY értékeket manuálisan kell feltölteni
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt ||'
	set kompozit = ''K'',
	int_egy = ''I'' 
	WHERE m003 IN (10207349, 10308024, 10337587, 10389395, 10456017, 10491984,
	10492033, 10765920, 10828704, 11367109, 12141843)';
	
	
	EXECUTE IMMEDIATE'	
	UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt ||'
	set kompozit = ''NE'',
	int_egy = ''I'' 
	WHERE m003 IN (12185960, 12761018, 12774395, 12833632, 13941031, 14011838,
	14440306, 14489765)';
		
	EXECUTE IMMEDIATE'	
	UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt ||'
	set kompozit = ''E'',
	int_egy = ''I'' 
	WHERE m003 IN (12467611, 12582161, 12774412, 12833625, 13941079, 14153730)';	

	EXECUTE IMMEDIATE'	
	UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt ||'
	set kompozit = ''K'',
	int_egy = ''E'' 
	WHERE m003 IN (18083017, 19666660, 19670656)';
	
	EXECUTE IMMEDIATE'	
	UPDATE '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt ||'
	set kompozit = ''NE'',
	int_egy = ''E'' 
	WHERE m003 IN (18088122, 18300941, 18343971, 18346345, 18373916, 18378234,
	18425501, 18426997, 18427228, 18453685, 18460069, 18485110, 18547443, 18830228, 18857522, 18981719)';
	
END IF;


IF v_mnb_biz41a = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_bizt41a ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_bizt41a ||'
		("MEV" VARCHAR2(4 BYTE), 
		"M003" VARCHAR2(8 BYTE), 
		"PBAOM000" NUMBER(15,0), 
		"PBAOM002" NUMBER(15,0), 
		"PBAOM009" NUMBER(15,0), 
		"PBAOM035" NUMBER(15,0), 
		"PBAOM048" NUMBER(15,0), 
		"PBAOM803" NUMBER(15,0), 
		"PBAOM806" NUMBER(15,0), 
		"PBAOM813" NUMBER(15,0), 
		"PBAOM814" NUMBER(15,0), 
		"PBAOM815" NUMBER(15,0), 
		"PBAOM816" NUMBER(15,0), 
		"PBAOM817" NUMBER(15,0), 
		"PBAOM818" NUMBER(15,0), 
		"PBAOM819" NUMBER(15,0), 
		"PBAOM820" NUMBER(15,0), 
		"PBAOM821" NUMBER(15,0), 
		"PBAOM822" NUMBER(15,0), 
		"PBAOM823" NUMBER(15,0), 
		"PBAOM824" NUMBER(15,0), 
		"PBAOM825" NUMBER(15,0), 
		"PBAOM826" NUMBER(15,0), 
		"PBAOM827" NUMBER(15,0), 
		"PBAOM828" NUMBER(15,0), 
		"PBAOM829" NUMBER(15,0), 
		"PBAOM830" NUMBER(15,0), 
		"PBAOM831" NUMBER(15,0), 
		"PBAOM832" NUMBER(15,0), 
		"PBAOM833" NUMBER(15,0), 
		"PBAOM834" NUMBER(15,0), 
		"PBAOM835" NUMBER(15,0), 
		"PBAOM836" NUMBER(15,0), 
		"PBAOM837" NUMBER(15,0), 
		"PBAOM838" NUMBER(15,0), 
		"PBAOM839" NUMBER(15,0), 
		"PBAOM840" NUMBER(15,0), 
		"PBAOM841" NUMBER(15,0), 
		"PBAOM842" NUMBER(15,0), 
		"PBAOM843" NUMBER(15,0), 
		"PBAOM844" NUMBER(15,0), 
		"PBAOM845" NUMBER(15,0), 
		"PBAOM846" NUMBER(15,0), 
		"PBAOM847" NUMBER(15,0), 
		"PBAOM848" NUMBER(15,0), 
		"PBAOM849" NUMBER(15,0), 
		"PBAOM850" NUMBER(15,0), 
		"PBAOM851" NUMBER(15,0), 
		"PBAOM852" NUMBER(15,0), 
		"PBAOM853" NUMBER(15,0), 
		"PBBOM000" NUMBER(15,0), 
		"PBBOM001" NUMBER(15,0), 
		"PBBOM002" NUMBER(15,0), 
		"PBBOM012" NUMBER(15,0), 
		"PBBOM013" NUMBER(15,0), 
		"PBBOM015" NUMBER(15,0), 
		"PBBOM020" NUMBER(15,0), 
		"PBBOM025" NUMBER(15,0), 
		"PBBOM035" NUMBER(15,0), 
		"PBBOM037" NUMBER(15,0), 
		"PBBOM038" NUMBER(15,0), 
		"PBBOM044" NUMBER(15,0), 
		"PBBOM806" NUMBER(15,0), 
		"PBBOM807" NUMBER(15,0), 
		"PBBOM808" NUMBER(15,0), 
		"PBBOM809" NUMBER(15,0), 
		"PBBOM810" NUMBER(15,0), 
		"PBBOM811" NUMBER(15,0), 
		"PBBOM813" NUMBER(15,0), 
		"PBBOM815" NUMBER(15,0), 
		"PBBOM816" NUMBER(15,0), 
		"PBBOM817" NUMBER(15,0), 
		"PBBOM818" NUMBER(15,0), 
		"PBBOM819" NUMBER(15,0), 
		"PBBOM820" NUMBER(15,0), 
		"PBBOM821" NUMBER(15,0), 
		"PBBOM822" NUMBER(15,0), 
		"PBBOM823" NUMBER(15,0), 
		"PBBOM836" NUMBER(15,0), 
		"PBBOM841" NUMBER(15,0), 
		"PBBOM844" NUMBER(15,0), 
		"PBBOM845" NUMBER(15,0), 
		"PBBOM846" NUMBER(15,0), 
		"PBBOM847" NUMBER(15,0), 
		"PBBOM848" NUMBER(15,0), 
		"PBBOM849" NUMBER(15,0), 
		"PBBOM850" NUMBER(15,0), 
		"PBBOM851" NUMBER(15,0), 
		"PBBOM854" NUMBER(15,0), 
		"PBBOM857" NUMBER(15,0), 
		"PBBOM858" NUMBER(15,0), 
		"PBBOM859" NUMBER(15,0), 
		"PBBOM860" NUMBER(15,0), 
		"PBBOM861" NUMBER(15,0), 
		"PBBOM862" NUMBER(15,0), 
		"PBBOM863" NUMBER(15,0), 
		"PBBOM864" NUMBER(15,0), 
		"PBBOM865" NUMBER(15,0), 
		"PBBOM866" NUMBER(15,0), 
		"PBBOM867" NUMBER(15,0), 
		"PBBOM868" NUMBER(15,0), 
		"PBBOM869" NUMBER(15,0), 
		"PBBOM870" NUMBER(15,0), 
		"PBBOM871" NUMBER(15,0), 
		"PBBOM872" NUMBER(15,0), 
		"PBBOM873" NUMBER(15,0), 
		"PBBOM874" NUMBER(15,0), 
		"PBBOM875" NUMBER(15,0), 
		"PBBOM876" NUMBER(15,0), 
		"PBBOM877" NUMBER(15,0), 
		"PBBOM878" NUMBER(15,0), 
		"PBBOM879" NUMBER(15,0), 
		"PBBOM880" NUMBER(15,0), 
		"PBBOM881" NUMBER(15,0), 
		"PBBOM882" NUMBER(15,0), 
		"PBBOM883" NUMBER(15,0), 
		"PBBOM884" NUMBER(15,0), 
		"PBBOM885" NUMBER(15,0), 
		"PBBOM886" NUMBER(15,0), 
		"PBBOM887" NUMBER(15,0), 
		"PBBOM888" NUMBER(15,0), 
		"PBBOM889" NUMBER(15,0), 
		"PBBOM890" NUMBER(15,0), 
		"PBBOM891" NUMBER(15,0), 
		"PBBOM892" NUMBER(15,0), 
		"PBBOM893" NUMBER(15,0), 
		"PBBOM894" NUMBER(15,0), 
		"PBBOM895" NUMBER(15,0), 
		"PBBOM896" NUMBER(15,0), 
		"PBBOM897" NUMBER(15,0), 
		"PBBOM898" NUMBER(15,0), 
		"PBBOM899" NUMBER(15,0), 
		"PBBOM900" NUMBER(15,0), 
		"PBBOM901" NUMBER(15,0), 
		"PBBOM902" NUMBER(15,0), 
		"A2311B" NUMBER(15,0), 
		"A2311C" NUMBER(15,0), 
		"A23211B" NUMBER(15,0), 
		"A23211C" NUMBER(15,0), 
		"A23311B" NUMBER(15,0), 
		"A23311C" NUMBER(15,0), 
		"A23321B" NUMBER(15,0), 
		"A23321C" NUMBER(15,0), 
		"A125B" NUMBER(15,0), 
		"A125C" NUMBER(15,0)
		)
		'
		;
		
		END IF;
	*/
	
	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''bizt41a'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''bizt41a'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;			

	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_bizt41a ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_bizt41a, ''|| evszam ||'');	
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_bizt41a ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;
	
END IF;


IF v_mnb_be = TRUE THEN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ' ''|| v_out_schema ||''.''|| v_out_schema ||''|| v_befalap ||'' ';

	/*	IF z=0 THEN

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||''.''|| v_out_schema ||''|| v_befalap ||'
		("MEV" VARCHAR2(20 BYTE), 
		"M003" VARCHAR2(50 BYTE), 
		"PBAA0M001" NUMBER(15,0), 
		"PBAA0M002" NUMBER(15,0), 
		"PBAC001" NUMBER(15,0), 
		"PBAC002" NUMBER(15,0), 
		"PBAC003" NUMBER(15,0), 
		"PBAC004" NUMBER(15,0), 
		"PBAC005" NUMBER(15,0), 
		"PBAC006" NUMBER(15,0), 
		"PBAC007" NUMBER(15,0), 
		"PBAC008" NUMBER(15,0), 
		"PBAC009" NUMBER(15,0), 
		"PBAC010" NUMBER(15,0), 
		"PBAC011" NUMBER(15,0), 
		"PBAC012" NUMBER(15,0), 
		"PBAC013" NUMBER(15,0), 
		"PBAC014" NUMBER(15,0), 
		"PBAC015" NUMBER(15,0), 
		"PBAC016" NUMBER(15,0), 
		"PBAC017" NUMBER(15,0), 
		"PBAC018" NUMBER(15,0), 
		"PBAC019" NUMBER(15,0), 
		"PBAC020" NUMBER(15,0), 
		"PBAC021" NUMBER(15,0), 
		"PBAC022" NUMBER(15,0), 
		"PBAC023" NUMBER(15,0), 
		"PBAC024" NUMBER(15,0), 
		"PBAC025" NUMBER(15,0), 
		"PBAC026" NUMBER(15,0), 
		"PBAC027" NUMBER(15,0), 
		"PBAC028" NUMBER(15,0), 
		"PBAC029" NUMBER(15,0), 
		"PBAC030" NUMBER(15,0)
		)
		'
		;

		END IF;
	*/

	sql_statement := 'SELECT SOR_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''befalap'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_sorkod;

	sql_statement := 'SELECT OSZLOP_KOD FROM '|| v_out_schema ||'.'|| v_codes ||' WHERE TYPE = ''befalap'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_oszlopkod;	
	
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_out_schema ||''|| v_befalap ||' ';
	EXECUTE IMMEDIATE sql_statement INTO z;
	
	IF z = 0 THEN	
	
	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP

		MNB_TEMP_TABLE(''|| v_out_schema ||'', v_sorkod(a));
	
		
	END LOOP;

		MNB_INSERT_TABLE(''|| v_out_schema ||'', v_befalap, ''|| evszam ||'');	
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('A tábla nem üres!');
	
	END IF;	

	FOR a IN v_sorkod.FIRST..v_sorkod.LAST LOOP
	
		BEGIN UPDATE_EVES_TABLES(''|| v_out_schema ||''|| v_befalap ||'', ''|| v_sorkod(a) ||'' , ''|| v_oszlopkod(a) ||'', ''|| v_out_schema ||''); END;
		
	END LOOP;
	
END IF;	
	
EXCEPTION -- log táblába is írjunk!
when is_data then
		dbms_output.put_line('A tábla nem üres!');
when no_data_found then
        dbms_output.put_line('Nincs adat');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
when too_many_rows then
        dbms_output.put_line('Túl sok a sor');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
when others then
        dbms_output.put_line('Előre nem várt hiba');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);


END egyeb_attoltes;

END;