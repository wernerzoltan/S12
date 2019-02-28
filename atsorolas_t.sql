create or replace PROCEDURE "ATSOROLAS_T" (P_TYPE PLS_INTEGER, FUTAS VARCHAR2, EVSZAM VARCHAR2) AS
/***************************************************************
 Átsorolást végző eljárás
 Ez az eljárás csak akkor használható, ha pénzügyi átsorolás volt.
 Különben a betöltéseket kell megismételni Tásá-nál, Lalá-nál, stb.
 A bejövő paraméter értéke 0 vagy 1 lehet
 Ha 1, akkor VALIDATION
 Ha 0, akkor UPDATE
****************************************************************/
  T_CEGLISTA VARCHAR2(50) := 'CEGLISTA';
  T_CEGLISTA_SCV VARCHAR2(50) := 'CEGLISTA_SCV'; 
      
  V_TABLE VARCHAR2(100);
  V_STR VARCHAR2(1000);
  V_NUM VARCHAR2(10);
  CC NUMBER;
  sql_statement VARCHAR2(300);
  TYPE t_list IS TABLE OF CEGLISTA%ROWTYPE;
  v_list t_list;
  TYPE t_err_list IS TABLE OF CEGLISTA%ROWTYPE;
  v_err_list t_err_list;
  
  V_EV VARCHAR2(2);
  
BEGIN  
  V_EV := SUBSTR(EVSZAM, 3);
  
  dbms_output.ENABLE(NULL);

  IF P_TYPE = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Átsorolás indul validálással');
  ELSIF P_TYPE = 0 THEN  
    DBMS_OUTPUT.PUT_LINE('Átsorolás indul update-tel');
  ELSE
   DBMS_OUTPUT.PUT_LINE('A PARAMÉTER ÉRTÉKE CSAK 0 VAGY 1 LEHET!');
   RETURN;
  END IF;
 
  
  IF FUTAS = 'elozetes' THEN
    DBMS_OUTPUT.PUT_LINE('Előzetes futás!');
  ELSIF FUTAS = 'vegleges' THEN  
    DBMS_OUTPUT.PUT_LINE('Végleges futás!');
  ELSE
   DBMS_OUTPUT.PUT_LINE('A PARAMÉTER ÉRTÉKE CSAK elozetes VAGY vegleges LEHET!');
   RETURN;
  END IF;
 
  FOR I IN 1..9 LOOP -- 1..10 volt
  
	IF FUTAS = 'elozetes' THEN 
    
      CASE I
        WHEN 1 THEN v_table := 'PP'|| V_EV ||'_W_TASA_1701_V01_T'; 
        WHEN 2 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1708_V01_T';
        WHEN 3 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1711_V01_T'; 
        WHEN 4 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1729_V01_T';
        WHEN 5 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1743_V01_T'; 
        WHEN 6 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1771_V01_T'; 
        WHEN 7 THEN v_table := 'PP'|| V_EV ||'_SCV_TASA_V01_T';     
        WHEN 8 THEN V_TABLE := 'PP'|| V_EV ||'_W_MESG_LALA_V01_T'; 
        WHEN 9 THEN v_table := 'PP'|| V_EV ||'_W_TASA_1729_SCV_V01_T';
      --  WHEN 12 THEN v_table :='PP17_KATA_V01_T';
      --  WHEN 13 THEN v_table :='PP17_KIVA_V01_T';
        ELSE
          V_TABLE:= 'NO';
      END CASE;
	  
	ELSE  

	CASE I
        WHEN 1 THEN v_table := 'PP'|| V_EV ||'_W_TASA_1701_V02_T';
        WHEN 2 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1708_V02_T';
        WHEN 3 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1711_V02_T';
        WHEN 4 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1729_V02_T';
        WHEN 5 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1743_V02_T';
        WHEN 6 THEN V_TABLE := 'PP'|| V_EV ||'_W_TASA_1771_V02_T';
        WHEN 7 THEN v_table := 'PP'|| V_EV ||'_SCV_TASA_V02_T';        
        WHEN 8 THEN V_TABLE := 'PP'|| V_EV ||'_W_MESG_LALA_V02_T';
        WHEN 9 THEN v_table := 'PP'|| V_EV ||'_W_TASA_1729_SCV_V02_T';
      --  WHEN 12 THEN v_table :='PP17_KATA_V01_T';
      --  WHEN 13 THEN v_table :='PP17_KIVA_V01_T';
        ELSE
          V_TABLE:= 'NO';
      END CASE;

	END IF;
      
      dbms_output.put_line(v_table);

	  sql_statement := 'SELECT * FROM '|| T_CEGLISTA ||' UNION ALL SELECT M003, M0581 FROM '|| T_CEGLISTA_SCV ||' ';
	  EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_list;
	  
      IF v_table <> 'NO' THEN
          FOR REC IN v_list.FIRST..v_list.LAST LOOP
            IF P_TYPE = 0 THEN --update
                V_STR:='UPDATE ' || V_TABLE || ' SET M0581= ' 
                       || '''' || v_list(REC).M0581 || '''' 
                       || ' WHERE M003=' || '''' || v_list(REC).M003 || '''';
                dbms_output.put_line(v_str);
                EXECUTE IMMEDIATE V_STR;
                COMMIT;
            ELSE --sima validálás
                V_STR:='SELECT COUNT(M0581) FROM ' || V_TABLE 
                       || ' WHERE M003 = ' || '''' || v_list(REC).M003 || '''';
                EXECUTE IMMEDIATE V_STR INTO CC;
                IF CC <> 0 THEN
                  V_STR:='SELECT DISTINCT M0581 FROM ' || V_TABLE 
                         || ' WHERE M003 = ' || '''' || v_list(REC).m003 || '''';
                  --dbms_output.put_line(v_str);
                  EXECUTE IMMEDIATE V_STR INTO V_NUM;
                  IF V_NUM = v_list(REC).M0581 THEN
                    DBMS_OUTPUT.PUT_LINE('OK');
                  ELSE
                    DBMS_OUTPUT.PUT_LINE('Hiba --------> ' 
                                         || v_list(REC).M003 || ', v_num: ' || V_NUM 
                                         || 'ezen a teáor-on (m0581) kell lennie: ' || v_list(REC).M0581 
                                         || '. tábla: ' || V_TABLE);
                  END IF;
                END IF;
            END IF;
          END LOOP;
      END IF;
      DBMS_OUTPUT.PUT_LINE(V_TABLE 
                           || ' Kész: (' || CURRENT_TIMESTAMP || ')');
  END LOOP;
  dbms_output.put_line('Átsorolás vége.');
end atsorolas_t;