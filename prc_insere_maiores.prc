create or replace procedure prc_insere_maiores(vn_numero1 in maiores.numero1%type,
                                               vn_numero2 in maiores.numero2%type,
                                               vn_numero3 in maiores.numero3%type)
is
--insere maior valor entre tres colunas
vn_maior maiores.maior%type;
begin
  
  select
     GREATEST(vn_numero1,vn_numero2,vn_numero3) maior
     into vn_maior
  from dual;
  

  insert into maiores (numero1, numero2, numero3, maior) values (vn_numero1, vn_numero2, vn_numero3,vn_maior);
  commit;
end prc_insere_maiores;
/
