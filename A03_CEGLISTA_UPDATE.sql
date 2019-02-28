/*
create or replace PACKAGE a03_CEGLISTA_UPDATE AUTHID CURRENT_USER AS 
procedure ceglista_update;

END a03_CEGLISTA_UPDATE;
*/

create or replace PACKAGE BODY a03_CEGLISTA_UPDATE AS 

v_ceglista_VAL BOOLEAN := FALSE;  -- CEGLISTA VALIDATION 
v_ceglista_UPD BOOLEAN := TRUE;  -- CEGLISTA UPDATE
v_betoltes VARCHAR2(10) := 'vegleges'; -- előzetes / végleges
v_evszam VARCHAR2(10) := '2017'; -- évszám
V_EV VARCHAR2(2) := SUBSTR(v_evszam, 3); 
sql_statement VARCHAR2(200);

a boolean;

procedure ceglista_update AS
BEGIN

IF v_ceglista_VAL = TRUE THEN

	sql_statement := 'BEGIN PP'|| V_EV ||'.ATSOROLAS_T(1, '''|| v_betoltes ||''', '''|| v_evszam ||'''); END;';
	EXECUTE IMMEDIATE(sql_statement);

END IF;

IF v_ceglista_UPD = TRUE THEN

	sql_statement := 'BEGIN PP'|| V_EV ||'.ATSOROLAS_T(0, '''|| v_betoltes ||''', '''|| v_evszam ||'''); END;';
	EXECUTE IMMEDIATE(sql_statement);	

END IF;

END;
END;