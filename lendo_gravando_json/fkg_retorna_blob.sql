CREATE OR REPLACE FUNCTION fkg_retorna_blob (
  ev_nome_arquivo   IN VARCHAR2
)
RETURN BLOB
AS
  v_bfile   BFILE;
  v_blob  BLOB;
BEGIN

dbms_lob.createtemporary(v_blob, true);

--Pega o arquivo no diretorio
v_bfile := bfilename(
      'ARQUIVOS',
      ev_nome_arquivo
  );

-- Abre o arquivo using DBMS_LOB
  dbms_lob.fileopen(
      v_bfile,
      dbms_lob.file_readonly
  );

-- Carrega o arquivo no blob
  dbms_lob.loadfromfile(
      v_blob,
      v_bfile,
      dbms_lob.getlength(v_bfile)
  );

-- Fecha arquivo
  dbms_lob.fileclose(v_bfile);
  return v_blob;
    
END;
