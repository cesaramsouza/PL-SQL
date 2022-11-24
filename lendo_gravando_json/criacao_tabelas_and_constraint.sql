--tabela integração
create table INTEGRA_CLIENTE
(
  id          NUMBER not null,
  data_insert TIMESTAMP(6) WITH TIME ZONE,
  json_doc    BLOB not null
)

--tabela cadastro 
create table CAD_CLIENTE
(
  id          NUMBER not null,
  data_insert TIMESTAMP(6) WITH TIME ZONE,
  nome        VARCHAR2(255) not null,
  idade       NUMBER(3) not null,
  cor_olhos   VARCHAR2(255)
)

--celular cliente
create table CEL_CLIENTE
(
  id          NUMBER not null,
  data_insert TIMESTAMP(6) WITH TIME ZONE,
  cliente_id  NUMBER not null,
  celular     VARCHAR2(14)
)

--email cliente
create table EMAIL_CLIENTE
(
  id          NUMBER not null,
  data_insert TIMESTAMP(6) WITH TIME ZONE,
  cliente_id  NUMBER not null,
  email       VARCHAR2(255)
)

create table ENDERECO_CLIENTE
(
  id          NUMBER not null primary key,
  data_insert TIMESTAMP(6) WITH TIME ZONE,
  cliente_id  NUMBER not null,
  Rua       VARCHAR2(255),
  Cidade    VARCHAR2(60),
  Estado    VARCHAR2(35),
  CEP       VARCHAR2(10),
  Pais      VARCHAR2(80)
)

alter table CEL_CLIENTE 
add constraint CEL_CLIENTE_PK 
primary key(id);

ALTER TABLE CEL_CLIENTE
ADD CONSTRAINT CELCLIENTE_FK
   FOREIGN KEY (cliente_id)
   REFERENCES CAD_CLIENTE (id);
   
ALTER TABLE EMAIL_CLIENTE
ADD CONSTRAINT EMAILCLIENTE_FK
   FOREIGN KEY (cliente_id)
   REFERENCES CAD_CLIENTE (id);
   
ALTER TABLE ENDERECO_CLIENTE
ADD CONSTRAINT ENDERECOCLIENTE_FK
   FOREIGN KEY (cliente_id)
   REFERENCES CAD_CLIENTE (id);
   
CREATE SEQUENCE EMAIL_CLIENTE_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
CREATE SEQUENCE CEL_CLIENTE_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
CREATE SEQUENCE CAD_CLIENTE_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
  
CREATE SEQUENCE INTEGRA_CLIENTE_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE ENDERECO_CLIENTE_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;