create or replace package pkg_integra_cliente is

  -- Criador  : CESAR
  -- Criado   : 24/11/2022 22:38:07
  --teste github 06/09/2023
  --type
  type integra_clinte_type is record(nome VARCHAR2(255), 
                                      idade NUMBER(3), 
                                      corOlho VARCHAR2(255), 
                                      email VARCHAR2(255), 
                                      celular VARCHAR2(15), 
                                      rua VARCHAR2(60), 
                                      numero  VARCHAR2(20),
                                      bairro VARCHAR2(255),
                                      cidade VARCHAR2(255),
                                      id number);
  
  --procedures
  procedure prc_integra_cliente;
  
  procedure prc_integra_arq (nome_arq varchar2);
  
  --function
  function fkg_retorna_blob(ev_nome_arquivo IN VARCHAR2)
    RETURN BLOB;

end pkg_integra_cliente;
/
create or replace package body pkg_integra_cliente is

  FUNCTION fkg_retorna_blob(ev_nome_arquivo IN VARCHAR2) RETURN BLOB AS
    v_bfile BFILE;
    v_blob  BLOB;
  BEGIN
  
    dbms_lob.createtemporary(v_blob, true);
  
    --Pega o arquivo no diretorio
    v_bfile := bfilename('ARQUIVOS', ev_nome_arquivo);
  
    -- Abre o arquivo using DBMS_LOB
    dbms_lob.fileopen(v_bfile, dbms_lob.file_readonly);
  
    -- Carrega o arquivo no blob
    dbms_lob.loadfromfile(v_blob, v_bfile, dbms_lob.getlength(v_bfile));
  
    -- Fecha arquivo
    dbms_lob.fileclose(v_bfile);
    return v_blob;
  
  END fkg_retorna_blob;
  -----------------------------------------------------------------------------------------------------------------
  procedure prc_integra_cliente is
  
    vLimit CONSTANT INTEGER(2) := 50;
    --cursor para recuperar os dados do JSON
    cursor c_cliente is
      SELECT jt.*, ic.id
        FROM integra_cliente ic,
             json_table(json_doc,
                        '$'
                        COLUMNS(nome VARCHAR2(255) PATH '$.nome',
                                idade NUMBER(3) PATH '$.idade',
                                corOlho VARCHAR2(255) PATH '$.corOlho',
                                email VARCHAR2(255) PATH '$.email',
                                celular VARCHAR2(15) PATH '$.celular',
                                NESTED PATH '$.endereco[*]'
                                COLUMNS(rua VARCHAR2(60) PATH '$.rua',
                                        numero VARCHAR2(20) PATH '$.numero',
                                        bairro VARCHAR2(255) PATH '$.bairro',
                                        cidade VARCHAR2(255)PATH '$.cidade'))) AS "JT"
       where ic.fl_integra = 0;
  
    TYPE int_cliente_type IS TABLE OF pkg_integra_cliente.integra_clinte_type INDEX BY BINARY_INTEGER;
    int_cliente int_cliente_type;
  
  begin
  
    int_cliente.delete;
  
    OPEN c_cliente;
  
    FETCH c_cliente BULK COLLECT
      INTO int_cliente LIMIT vlimit;
    CLOSE c_cliente;
  
    FOR i IN int_cliente.first .. int_cliente.last loop
    
      begin
        insert into cad_cliente
          (id, data_insert, nome, idade, cor_olhos)
        values
          (cad_cliente_seq.nextval,
           sysdate,
           int_cliente(i).nome,
           int_cliente(i).idade,
           int_cliente(i).corOlho);
      exception
        when others then
          dbms_output.put_line('insert cad_cliente: ' || sqlerrm);
      end;
      
      begin
        insert into cel_cliente
          (id, data_insert, cliente_id, celular)
        values
          (cel_cliente_seq.nextval,
           sysdate,
           cad_cliente_seq.currval,
           int_cliente(i).celular);
      exception
        when others then
          dbms_output.put_line('insert cel_cliente: ' || sqlerrm);
      end;
      
      begin
        insert into email_cliente
          (id, data_insert, cliente_id, email)
        values
          (email_cliente_seq.nextval,
           sysdate,
           cad_cliente_seq.currval,
           int_cliente(i).email);
      exception
        when others then
          dbms_output.put_line('insert email_cliente: ' || sqlerrm);
      end;
      
      begin
        insert into endereco_cliente
          (id, data_insert, cliente_id, rua, cidade, bairro, numero)
        values
          (cel_cliente_seq.nextval,
           sysdate,
           cad_cliente_seq.currval,
           int_cliente(i).rua,
           int_cliente(i).cidade,
           int_cliente(i).bairro,
           int_cliente(i).numero);
      exception
        when others then
          dbms_output.put_line('insert endereco_cliente: ' || sqlerrm);
      end;
      
      update integra_cliente
      set fl_integra = 1
      where id = int_cliente(i).id;
      
    end loop;
    
    commit;
    
  exception
    when others then
      dbms_output.put_line('prc_integra_cliente: ' || sqlerrm);
    
  end prc_integra_cliente;
-----------------------------------------------------------------------------------------------------------------
procedure prc_integra_arq (nome_arq varchar2)is
  vv_blob blob;
begin

  vv_blob := fkg_retorna_blob(nome_arq);
  
  begin
  insert into integra_cliente
    (id, data_insert, json_doc)
  values
    (integra_cliente_seq.nextval, sysdate, vv_blob);
  exception
    when others then
      dbms_output.put_line('insert prc_integra_arq: '||sqlerrm);
  end;

  commit;
  
  --Remove arquivo lido do diret�rio
  --UTL_FILE.FREMOVE ('ARQUIVOS', nome_arq);
  
end prc_integra_arq;
-----------------------------------------------------------------------------------------------------------------
end pkg_integra_cliente;
/
