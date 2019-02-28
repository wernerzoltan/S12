create or replace PROCEDURE "MNB_INSERT_TABLE" (v_out_schema VARCHAR2, v_table VARCHAR2, evszam VARCHAR2) AS

v_mnb_temp VARCHAR2(20) := 'temp_sorkod'; -- MNB temp tábla


BEGIN

	TRUNCATE_TABLE(''|| v_out_schema ||''|| v_table ||'');

	EXECUTE IMMEDIATE'
	INSERT INTO '|| v_out_schema ||'.'|| v_out_schema ||''|| v_table ||'
	(mev, m003)
	SELECT DISTINCT '''|| evszam ||''', m003 
	FROM '|| v_out_schema ||'.'|| v_mnb_temp ||'
	'
	;

END;