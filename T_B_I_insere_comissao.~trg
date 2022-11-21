CREATE OR REPLACE TRIGGER T_B_I_insere_comissao
  BEFORE INSERT ON linhas_notas_fiscais
  FOR EACH ROW
BEGIN
  declare
  
    vn_valor    linhas_notas_fiscais.valor_unitario%type;
    vn_vendedor notas_fiscais.vendedor_id%type;
  
  begin
    select vendedor_id
      into vn_vendedor
      from notas_fiscais
     where numero = :NEW.numero;
  
    vn_valor := (:NEW.quantidade * :NEW.valor_unitario) * (0.1 / 100);
  
    insert into comissoes_pagar
      (numero, vendedor_id, comissao)
    values
      (:NEW.numero, vn_vendedor, vn_valor);
  end;
END;
/
