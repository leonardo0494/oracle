DROP TABLE s_escl_req_audit_tbl;

CREATE TABLE s_escl_req_audit_tbl (
    CREATED date, 
    CREATED_BY varchar2(15),
    BT_ROW_ID varchar2(15),
    GROUP_ID varchar2(15),
    RULE_ID varchar2(15),
    TBL_NAME varchar2(30),
    GROUP_NAME varchar2(30),
    RULE_NAME varchar2(100)
);

DROP TRIGGER siebel.s_escl_req_audit;

CREATE OR REPLACE TRIGGER siebel.s_escl_req_audit
AFTER INSERT ON siebel.s_escl_req
FOR EACH ROW
DECLARE
    vGROUP varchar2(30);
    vQtdLinhas number(1);
    vRULE varchar2(100);
BEGIN

    -- SELECT NOME GRUPO
    SELECT COUNT(NAME) INTO vQtdLinhas FROM SIEBEL.S_ESCL_GROUP WHERE row_id = :NEW.group_id;
    
    IF vQtdLinhas > 0 THEN
        SELECT NAME INTO vGROUP FROM SIEBEL.S_ESCL_GROUP WHERE row_id = :NEW.group_id;
    ELSE
        vGROUP := 'GRUPO NAO ENCONTRADO';
    END IF;

    -- SELECT NOME REGRA
    
    SELECT COUNT(NAME) INTO vQtdLinhas FROM SIEBEL.S_ESCL_RULE WHERE row_id = :NEW.rule_id;
    
    IF vQtdLinhas > 0 THEN
        SELECT NAME INTO vRULE FROM SIEBEL.S_ESCL_RULE WHERE row_id = :NEW.rule_id;
    ELSE
        vRULE := 'REGRA NAO ENCONTRADA';
    END IF;


    -- INSERINDO NA TABELA DE AUDITORIA

    IF INSERTING THEN

        INSERT INTO s_escl_req_audit_tbl (CREATED, CREATED_BY, BT_ROW_ID, GROUP_ID, RULE_ID, TBL_NAME, GROUP_NAME, RULE_NAME) 
        VALUES(:NEW.created, :NEW.created_by, :NEW.bt_row_id, :NEW.group_id, :NEW.rule_id, :NEW.tbl_name, vGROUP, vRULE);

    END IF;
END;
/