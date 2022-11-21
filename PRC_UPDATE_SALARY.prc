CREATE OR REPLACE PROCEDURE PRC_UPDATE_SALARY
  (ppercentual IN NUMBER)
AS
  TYPE employee_id_table_type IS TABLE OF employees.employee_id%TYPE
  INDEX BY BINARY_INTEGER;  -- Type Associative Array
  employee_id_table  employee_id_table_type;
BEGIN
--update na salario dos empregados na porcentagem que for passada como parametro
  SELECT DISTINCT employee_id
    BULK COLLECT INTO employee_id_table
  FROM employees;

  DBMS_OUTPUT.PUT_LINE('Linhas recuperadas: ' || employee_id_table.COUNT);

  FORALL indice IN 1..employee_id_table.COUNT  -- FOR ALL empacota todos os UPDATES e envia o pacote em 1 ?nica troca de contexto (Context Switch)

  --DBMS_OUTPUT.PUT_LINE(employee_id_table(indice));

    UPDATE employees e
    SET    e.salary = e.salary * (1 + ppercentual / 100)
    WHERE  e.employee_id = employee_id_table(indice);
    
    --trace dos objetos utilizados
    insert into log_msg values (DBMS_UTILITY.format_call_stack);

END;
/
