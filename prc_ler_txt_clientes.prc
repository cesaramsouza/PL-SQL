create or replace procedure hr.prc_ler_txt_clientes (en_diretorio in varchar2
                                                 ,en_arquivo in varchar2) is
--Procedure criada por Cesar Souza
--Essa procedure lê o TXT do diretório informado(criado na tabela all_directories) e inserere na tabela clientes
  v_text         varchar2(4000);
  v_text2        varchar2(4000);
  v_inicia       number;
  v_termina      number;
  v_countador    number;
  ins_campo      number := 1;
  vfile          UTL_FILE.FILE_TYPE;
  clientes_table clientes%rowtype;

begin
  vfile := UTL_FILE.FOPEN(en_diretorio, en_arquivo, 'r', 32767);
  LOOP
    UTL_FILE.GET_LINE(vfile, v_text);
    v_countador := length(v_text);

    while nvl(v_countador, 0) > 0 loop

      select INSTR(v_text, '|') into v_inicia from dual;

      select INSTR(v_text, '|', 2) into v_termina from dual;

      v_text2 := substr(v_text, v_inicia, v_termina);
      v_text  := substr(v_text, v_termina);

      if v_inicia = 1 and v_termina = 2 then
        v_text2 := null;
      end if;

      if ins_campo = 1 then
        clientes_table.nome := substr(v_text2,
                                      (v_inicia + 1),
                                      (v_termina - 2));
      end if;

      if ins_campo = 2 then
        clientes_table.limite := substr(v_text2,
                                        (v_inicia + 1),
                                        (v_termina - 2));
      end if;

      if ins_campo = 3 then
        clientes_table.endereco := substr(v_text2,
                                          (v_inicia + 1),
                                          (v_termina - 2));
      end if;

      if ins_campo = 4 then
        clientes_table.ano_nasc := substr(v_text2,
                                          (v_inicia + 1),
                                          (v_termina - 2));
      end if;

      --dbms_output.put_line(clientes_table.nome||' - '||clientes_table.limite||' - '||clientes_table.endereco||' - '||clientes_table.ano_nasc);

      v_countador := length(v_text);

      if v_countador = 1 then
        v_countador := 0;
      end if;

      ins_campo := ins_campo + 1;

    end loop;

    dbms_output.put_line(clientes_table.nome || ' - ' ||
                         clientes_table.limite || ' - ' ||
                         clientes_table.endereco || ' - ' ||
                         clientes_table.ano_nasc);
    begin
      ins_campo := 1;
    insert into clientes
    values
      (null,
       clientes_table.nome,
       clientes_table.limite,
       clientes_table.endereco,
       clientes_table.ano_nasc);
    exception
      when others then
        dbms_output.put_line('Erro ao inserir: '||sqlerrm);
    end;
--    commit;

  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    UTL_FILE.FCLOSE(vfile);
    DBMS_OUTPUT.PUT_LINE('Arquivo Texto lido com sucesso');
  WHEN UTL_FILE.INVALID_PATH THEN
    UTL_FILE.FCLOSE(vfile);
    DBMS_OUTPUT.PUT_LINE('Diret?rio Inv?lido');
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(vfile);
    DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);
end;
/