CREATE OR REPLACE TRIGGER T_B_I_insere_seq_clientes
  BEFORE INSERT ON clientes
  FOR EACH ROW
--insere sequence na tabela antes do insert
BEGIN
  :new.cliente_id := seq_clientes.nextval;
END;
/
