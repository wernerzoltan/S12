create or replace PROCEDURE "MNB_TEMP_TABLE" (v_out_schema VARCHAR2, v_sorkod VARCHAR2) AS

v_mnb_temp VARCHAR2(20) := 'temp_sorkod'; -- MNB temp tábla
v_in_mnb VARCHAR2(20) := 'temp_pszafupdate'; -- MNB input tábla: temp_pszafupdate


BEGIN

	TRUNCATE_TABLE(''|| v_mnb_temp ||'');

	EXECUTE IMMEDIATE'
	INSERT INTO '|| v_out_schema ||'.'|| v_mnb_temp ||'
	(m003)
	SELECT DISTINCT m003 
	FROM '|| v_out_schema ||'.'|| v_in_mnb ||'
	WHERE 
	sor_kod LIKE '''|| v_sorkod ||'''
	'
	;

END;