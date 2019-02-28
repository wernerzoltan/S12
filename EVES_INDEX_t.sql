create or replace PROCEDURE "EVES_INDEX_T" (v_semak VARCHAR2, v_evszam VARCHAR2, v_out_schema VARCHAR2, v_betoltes VARCHAR2, 
                                       v_verzio VARCHAR2, v_teszt VARCHAR2, b_teszt boolean default false) AS 
 v_year VARCHAR2(2) := SUBSTR(v_evszam, 3);
 c_agrr NUMBER;
 c_teaor NUMBER;
 v_tabla_pszaf VARCHAR2(50);
 v_count NUMBER;
 pair_sema_lepes pair;
 p_sema NUMBER;
 p_lepes NUMBER := 0;
 v_sema_lepes VARCHAR2(20);
 got split_tbl;
 sql_statement VARCHAR2(200);
 procName VARCHAR2(20);
 is_data exception;
  
BEGIN

procName := 'EVES_INDEX';

 -- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Running Séma: '|| v_semak ||' + betöltés: '|| v_betoltes ||',  verzió: '|| v_verzio ||'', '' );


--dbms_output.put_line('START EVES_INDEX_T');

got := J_SZEKT_EVES_T.SPLIT2(v_semak);
for i in got.first .. got.last loop

	v_sema_lepes := got(i);
	--dbms_output.put_line(v_sema_lepes || ' futtatása... ');
	pair_sema_lepes := J_SELECT_T.SEMA_LEPES_SZETVALASZT(v_sema_lepes);
	p_sema := pair_sema_lepes.V;
	p_lepes := pair_sema_lepes.f;

  -- Ha 11-es de nincs megadva lépés!
  IF p_sema = '11' and to_number(p_lepes) is null THEN
    dbms_output.put_line('Kérlek válassz lépést! (1-7)');
    dbms_output.put_line('Így add meg pl. "11.1" (pont után a lépés száma)');
    return;
  end if;


  --DBMS_OUTPUT.PUT_LINE(p_sema || '. séma futtatása...');

  IF p_lepes > 0 THEN
    DBMS_OUTPUT.PUT_LINE(p_lepes || '. lépés futtatása...');
  end if;

   ----------------FORDITASI HIBA--------------
  -- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'J_SELECT_T.PSZAF_SELECT START', '' );
    
  v_tabla_pszaf := J_SELECT_T.PSZAF_SELECT(P_SEMA, p_lepes, v_year, v_verzio, v_teszt);
 -- DBMS_OUTPUT.PUT_LINE(v_tabla_pszaf);

  -- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'J_CURSOR_T.OPENCURSOR START', '' );

 
  -- PSZAF TÁBLÁK VÁLASZTÁSA
  J_CURSOR_T.OPENCURSOR(p_sema, p_lepes, v_tabla_pszaf, b_teszt, v_year, v_verzio, v_teszt, v_betoltes);

  -- kurzor nyitás séma szerint + feldolgozás, tábla feltöltés
  IF b_teszt THEN
    DBMS_OUTPUT.PUT_LINE(v_sema_lepes || ' sikeresen futtatva! (adatok nélkül)');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_sema_lepes || ' sikeresen futtatva!');
  end if;  

/*  
  IF P_SEMA = 11 and p_lepes = 7 THEN
    FOR rec IN (SELECT m003, d_29c1, d_29c2 FROM PP17_W_W_ELOZETES_V01 
    WHERE sema_tipus = 11) LOOP
      UPDATE PP17_W_W_ELOZETES_V02 SET d_29c=rec.d_29c1+rec.d_29c2 
      WHERE m003=rec.m003;
    END LOOP;
    COMMIT;
  END IF;
  
  */
end loop;  

dbms_output.put_line('END EVES_INDEX_T');

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