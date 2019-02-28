create or replace PROCEDURE update_eves_tables (
    c_table         VARCHAR2, 
    c_sorkod_like   VARCHAR2,
    v_oszlop_kod    NUMBER,
	v_schema 		VARCHAR2
) AS 
-- ÉVES adatok temp táblába való betöltése után a megfelelő tábla névre állítva 
-- az eljárást,a program helyükre másolja a tempből az adatokat,átforgatva 
-- őket fekvő táblába.
--(javítva: 2015-08-12, 2017.08.31)
    	
	v_str   VARCHAR2(2000);
	z number;
	-- rekord:
	TYPE t_rec is record (M003 VARCHAR2(8), HIC_KOD VARCHAR2(10), ERTEK NUMBER);
	
	-- array:
	--TYPE t_arr is VARRAY(1) of t_rec;
	TYPE t_arr is table of VARCHAR2(8);
	v_arr t_arr;
	
	-- cursor:
	CURSOR c1 is SELECT bb.m003, aa.hic_kod, bb.ertek FROM temp_pszafupdate bb, atkod aa
			WHERE (bb.sor_kod LIKE ''|| c_sorkod_like ||'' AND bb.oszlop_kod = ''|| v_oszlop_kod ||'')
			AND bb.sor_kod = aa.pszaf_kod
			AND aa.hic_kod IN 
			(SELECT column_name 
             FROM ALL_TAB_COLUMNS
             WHERE table_name = UPPER(''|| c_table ||'')
			 AND COLUMN_NAME NOT IN ('MEV', 'M003')) 	
	;
	
	TYPE t_final IS TABLE OF c1%ROWTYPE;
	v_final t_final;
		
BEGIN
    
    dbms_output.enable(NULL);
    dbms_output.put_line('Futtatás ' || c_table || ' sorkódra ' || c_sorkod_like
                         || ' oszlopkódra: '|| v_oszlop_kod);
	
	v_str := 'SELECT bb.m003, aa.hic_kod, bb.ertek 
			FROM temp_pszafupdate bb, atkod aa 
			WHERE (bb.sor_kod LIKE '''|| c_sorkod_like ||''' AND bb.oszlop_kod = '''|| v_oszlop_kod ||''')
			AND bb.sor_kod = aa.pszaf_kod
			AND aa.hic_kod IN 
			(SELECT column_name 
             FROM ALL_TAB_COLUMNS
             WHERE table_name = UPPER('''|| c_table ||''')
			 AND COLUMN_NAME NOT IN (''MEV'', ''M003'')) ';
	
	EXECUTE IMMEDIATE v_str BULK COLLECT INTO v_final;
	EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ( '|| v_str ||' )' INTO z;
	dbms_output.put_line(z);
	
	FOR i IN 1..z LOOP
	
		dbms_output.put_line(v_final(i).hic_kod);
		EXECUTE IMMEDIATE'
		UPDATE '|| c_table ||'
		SET '|| v_final(i).hic_kod ||' = '''|| v_final(i).ertek ||'''
		WHERE M003 = '''|| v_final(i).M003 ||'''
		'
		;
		
	END LOOP;
		
    COMMIT;
END update_eves_tables;