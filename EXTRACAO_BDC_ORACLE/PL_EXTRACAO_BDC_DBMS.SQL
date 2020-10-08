SET SERVEROUTPUT ON SIZE UNLIMITED;
set autoprint on;

DECLARE
   TYPE tmp_table IS TABLE OF CLOB;
   lReturnValue tmp_table;
   vStmt VARCHAR(4000);
   vColunas VARCHAR(4000); 
   vColunas2 VARCHAR(4000);
   vStrLen number;
   vCount varchar(4000);
BEGIN 

    FOR rDados IN (SELECT TABLE_NAME FROM all_tables WHERE owner = 'COR_BKP' and TABLE_NAME NOT IN ('XX_M_HIST_LOCALIDADES_FERIADOS', 'X_AREAS_GEOGRAFICAS', 'X_BILHETADORES', 'X_CALENDARIO_CORP', 'X_EMPRESAS_OPERADORAS_CORP' ,
		'X_ESTACOES_CORP' , 'X_FORNECEDORES' , 'X_HIST_LOCALIDADES_CORP' , 'X_LOCALIDADES_FERIADOS_CORP' , 'X_LOCALIZACOES_CORP' , 'X_LOGRADOUROS' , 'X_LOGRADOUROS_BAIRROS' , 
        'X_LOGRADOUROS_CEP' , 'X_M_AREAS_INTERNACIONAIS' , 'X_M_EMPRESAS' , 'X_M_FAIXAS_INTERNACIONAIS' , 'X_M_HIST_LOCALIDADES_EMPRESAS' , 'X_M_HIST_LOCALIDADES_FERIADOS' , 'X_M_H_INTERNACIONAL' , 'X_M_LOCALIDADES' , 'X_M_LOCALIDADES_EMPRESAS' , 'X_M_LOCALIDADES_IMPOSTOS' , 
        'X_M_PLANO_NUMER_INTERNACIONAL' , 'X_PREFIXOS_MCDU' , 'X_PREFIXOS_MCDU_HISTORICO'))
    LOOP
		
		vStmt :='SELECT COUNT(*) FROM COR_BKP.' || rDados.TABLE_NAME || ' WHERE ROWNUM <=1';
        EXECUTE IMMEDIATE vStmt into vCount;
		
		IF vCount = 1 THEN
	
			DBMS_OUTPUT.PUT_LINE('TABELA - ' || rDados.TABLE_NAME);
		
			-- RECUPERA COLUNAS DA TABELA
			FOR cols in (select COLUMN_NAME as colunas from all_tab_columns  where table_name = rDados.TABLE_NAME and owner = 'COR_BKP' order by column_id) 
			LOOP 
				vStrLen := length(vColunas || cols.colunas);
				
				IF vStrLen > 4000 THEN
					vColunas2 := vColunas2 || ' , ' || cols.colunas;
				ELSE
					vColunas := vColunas || ' , ' || cols.colunas;            
				END IF;     
				
			END LOOP;   
			
			DBMS_OUTPUT.PUT_LINE('sysdate' || vColunas || vColunas2);
			
			-- RECUPERA LINHAS 
			vStmt :='SELECT sysdate ' || REPLACE(vColunas, ',', '|| '','' ||') ||'' || REPLACE(vColunas2, ',', '|| '','' ||') || ' FROM COR_BKP.' || rDados.TABLE_NAME || ' WHERE ROWNUM <= 5';
			
			EXECUTE IMMEDIATE vStmt BULK COLLECT INTO lReturnValue;
				
			FOR i in 1..lReturnValue.COUNT
			LOOP
				DBMS_OUTPUT.PUT_LINE(lReturnValue(i));
			END LOOP;        
			
			DBMS_OUTPUT.PUT_LINE(' ');
			
			vColunas := '';
			vColunas2 := '';
		
		END IF;
    
    END LOOP;
   
END;