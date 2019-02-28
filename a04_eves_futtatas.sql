-- éves futtatás

/*
create or replace PACKAGE a04_eves_futtatas AUTHID CURRENT_USER AS 
procedure eves_futtatas;

END a04_eves_futtatas;
-------
*/

/* --logging táblába

create or replace PROCEDURE record_error(PRC VARCHAR2) AUTHID DEFINER  AS 

   PRAGMA AUTONOMOUS_TRANSACTION;
   l_mesg  VARCHAR2(32767) := SQLERRM;

BEGIN

	EXECUTE IMMEDIATE' INSERT INTO logging (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, ''YYYY.MM.DD HH24:MI:SS.FF''), ''ERROR'', '''|| PRC ||''', '''|| l_mesg ||''', sys.DBMS_UTILITY.format_error_backtrace)';


   COMMIT;
END;

*/


create or replace PACKAGE BODY a04_eves_futtatas AS 

is_data exception;
sql_statement VARCHAR2(200);
v_evszam VARCHAR2(10) := '2017'; -- futtatandó évszám
v_year VARCHAR2(2) := SUBSTR(v_evszam, 3);
v_out_schema VARCHAR2(10) := 'PP17'; -- output séma
v_betoltes VARCHAR2(10) := 'elozetes'; -- előzetes / végleges
v_verzio VARCHAR2(10) := '_V01'; -- W_W_ELOZETES_V0x / W_W_VEGLEGES_V0x, veriószáma a végtáblának
v_teszt VARCHAR2(10) := '_T'; -- _T végű táblanevek
procName VARCHAR2(20);


v_1 BOOLEAN := FALSE; -- HITELINTÉZET táblához adatok feltöltése
v_1_data VARCHAR2(10) := '1'; -- HITELINTÉZET kódja

v_2 BOOLEAN := FALSE; -- JELZÁLOGBANK táblához adatok feltöltése
v_2_data VARCHAR2(10) := '2'; -- JELZÁLOGBANK kódja

v_3 BOOLEAN := FALSE; -- FIÓKTELEP táblához adatok feltöltése
v_3_data VARCHAR2(10) := '3'; -- FIÓKTELEP kódja

v_4 BOOLEAN := FALSE; -- FISIMTERMELŐK táblához adatok feltöltése
v_4_data VARCHAR2(10) := '4'; -- FISIMTERMELŐK kódja

v_5 BOOLEAN := FALSE; -- MAGÁNYUGDÍJPÉNZTÁR táblához adatok feltöltése
v_5_data VARCHAR2(10) := '5'; -- MAGÁNYUGDÍJPÉNZTÁR kódja

v_6 BOOLEAN := FALSE; -- ÖNKÉNTES PÉNZTÁR    táblához adatok feltöltése
v_6_data VARCHAR2(10) := '6'; -- ÖNKÉNTES PÉNZTÁR    kódja

v_7 BOOLEAN := FALSE; -- ÖNSEGÉLYEZŐ PÉNZTÁR    táblához adatok feltöltése
v_7_data VARCHAR2(10) := '7'; -- ÖNSEGÉLYEZŐ PÉNZTÁR    kódja

v_8 BOOLEAN := FALSE; -- EGÉSZSÉG PÉNZTÁR    táblához adatok feltöltése
v_8_data VARCHAR2(10) := '8'; -- EGÉSZSÉG PÉNZTÁR    kódja

v_19 BOOLEAN := FALSE; --  FOGLALKOZTATÓI PÉNZTÁR táblához adatok feltöltése
v_19_data VARCHAR2(10) := '19'; -- FOGLALKOZTATÓI PÉNZTÁR    kódja

v_12 BOOLEAN := FALSE; --  BIZTOSÍTÓ INTÉZET (ÉLET) táblához adatok feltöltése
v_12_data VARCHAR2(10) := '12'; -- BIZTOSÍTÓ INTÉZET (ÉLET) kódja

v_14 BOOLEAN := FALSE; --  BIZTOSÍTÓ INTÉZET (NEM ÉLET)  táblához adatok feltöltése
v_14_data VARCHAR2(10) := '14'; -- BIZTOSÍTÓ INTÉZET (NEM ÉLET)     kódja

v_13 BOOLEAN := FALSE; -- BIZTOSÍTÓ EGYYESÜLET TELJES (ÉLET)  táblához adatok feltöltése
v_13_data VARCHAR2(10) := '13'; -- BIZTOSÍTÓ EGYYESÜLET TELJES (ÉLET)     kódja

v_15 BOOLEAN := FALSE; -- BIZTOSÍTÓ EGYYESÜLET TELJES  (NEM ÉLET)  táblához adatok feltöltése
v_15_data VARCHAR2(10) := '15'; -- BIZTOSÍTÓ EGYYESÜLET TELJES  (NEM ÉLET)     kódja

v_16 BOOLEAN := FALSE; -- BIZTOSÍTÓ EGYYESÜLET EGYSZER (NEM ÉLET)  táblához adatok feltöltése
v_16_data VARCHAR2(10) := '16'; -- BIZTOSÍTÓ EGYYESÜLET EGYSZER (NEM ÉLET)    kódja

v_17 BOOLEAN := FALSE; -- BIZTOSÍTÓ FIÓKTELEPEI        (NEM ÉLET)  táblához adatok feltöltése
v_17_data VARCHAR2(10) := '17'; -- BIZTOSÍTÓ FIÓKTELEPEI        (NEM ÉLET)    kódja

v_11_1 BOOLEAN := FALSE; -- KETTŐS/FISIM táblához adatok feltöltése
v_11_1_data VARCHAR2(10) := '11.1'; -- KETTŐS/FISIM kódja

v_11_2 BOOLEAN := FALSE; -- KETTŐS/FISIM táblához adatok feltöltése
v_11_2_data VARCHAR2(10) := '11.2'; -- KETTŐS/FISIM kódja

v_11_3 BOOLEAN := FALSE; -- KETTŐS/FISIM táblához adatok feltöltése
v_11_3_data VARCHAR2(10) := '11.3'; -- KETTŐS/FISIM kódja

v_11_4 BOOLEAN := FALSE; -- KETTŐS/FISIM táblához adatok feltöltése
v_11_4_data VARCHAR2(10) := '11.4'; -- KETTŐS/FISIM kódja

v_11_5 BOOLEAN := FALSE; -- KETTŐS/FISIM táblához adatok feltöltése
v_11_5_data VARCHAR2(10) := '11.5'; -- KETTŐS/FISIM kódja

v_9 BOOLEAN := FALSE; -- EVA 1043 táblához adatok feltöltése
v_9_data VARCHAR2(10) := '9'; -- EVA 1043    kódja

v_10 BOOLEAN := FALSE; -- EVA 1071  táblához adatok feltöltése
v_10_data VARCHAR2(10) := '10'; -- EVA 1071     kódja

v_50 BOOLEAN := FALSE; -- SCV táblához adatok feltöltése
v_50_data VARCHAR2(10) := '50'; -- SCV kódja

v_51 BOOLEAN := FALSE; -- KATA táblához adatok feltöltése
v_51_data VARCHAR2(10) := '51'; -- Egyéb zártkörű kódja

v_52 BOOLEAN := FALSE; -- KATA táblához adatok feltöltése
v_52_data VARCHAR2(10) := '52'; -- KATA Egyéb zártkörű kódja

v_53 BOOLEAN := FALSE; -- KIVA táblához adatok feltöltése
v_53_data VARCHAR2(10) := '53'; -- KIVA Egyéb zártkörű kódja


procedure eves_futtatas AS

-- 1. lépés: MESG_LALA táblához adatok feltöltése
BEGIN

procName := 'EVES_FUTTATAS';

 -- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'START', '' );


IF v_1 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_1_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_2 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_2_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_3 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_3_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_4 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_4_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_5 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_5_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_6 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_6_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_7 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_7_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_8 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_8_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_19 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_19_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_12 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_12_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_14 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_14_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_13 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_13_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_15 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_15_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_16 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_16_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_17 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_17_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_11_1 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_11_1_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_11_2 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_11_2_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_11_3 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_11_3_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_11_4 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_11_4_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_11_5 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_11_5_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;


IF v_9 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_9_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_10 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_10_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_50 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_50_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_51 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_51_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_52 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_52_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;

IF v_53 = TRUE THEN

	sql_statement := 'BEGIN PP'|| v_year ||'.EVES_INDEX_T('''|| v_53_data ||''', '''|| v_evszam ||''', '''|| v_out_schema ||''', '''|| v_betoltes ||''', '''|| v_verzio ||''', '''|| v_teszt ||''', FALSE); END;';
	EXECUTE IMMEDIATE(sql_statement);	
		
END IF;


 -- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'END', '' );



EXCEPTION -- log táblába is írjunk!
when is_data then
		dbms_output.put_line('A tábla nem üres!');
		record_error(procName);
when no_data_found then
        dbms_output.put_line('Nincs adat');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
		record_error(procName);
when too_many_rows then
        dbms_output.put_line('Túl sok a sor');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
		record_error(procName);
when others then
        dbms_output.put_line('Előre nem várt hiba');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
		record_error(procName);
		RAISE;
		
END;

END;