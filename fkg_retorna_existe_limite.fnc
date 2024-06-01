create or replace function fkg_retorna_existe_limite (en_cliente_id clientes.cliente_id%type
                                                     , en_valor clientes.limite%type)
return boolean
is
--retorna se o cliente tem limite ou não
  vn_limite clientes.limite%type := null;
  tem_limite boolean;
begin
--teste maverick
dbms_output.put_line('Teste');
select limite
  into vn_limite
  from clientes
 where cliente_id = en_cliente_id;

if nvl(vn_limite, 0) >= nvl(en_valor, 0)
  then
   tem_limite := TRUE;
  ELSE
    tem_limite := FALSE;
end if;

return(tem_limite);
end;
/
