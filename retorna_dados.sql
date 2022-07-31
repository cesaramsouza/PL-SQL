create or replace procedure pb_imprime_dados(en_loc in scott.dept.loc%type)
is

vn_existe number;

cursor c_func is
select emp.empno
      ,emp.job
      ,emp.sal
  from scott.dept
  join scott.emp on (dept.deptno = scott.emp.deptno)
where upper(dept.loc) = upper(en_loc);

begin

vn_existe := 0;

for rec in c_func loop
    exit when c_func%notfound or (c_func%notfound) is null;
    
    if nvl(rec.empno,0) > 0 then
      
      vn_existe := 1;
      
      DBMS_OUTPUT.PUT_LINE(rec.empno ||' - '|| rec.job ||' - '|| rec.sal);
      
    end if;
    
  end loop;
  
  if vn_existe = 0 then
  
    DBMS_OUTPUT.PUT_LINE('Nenhum funcionário encontrado');
  
  end if;
  
exception
  when others then
  
  raise_application_error(-20101, 'Erro na  pb_imprime_dados - '||sqlerrm);
  
end pb_imprime_dados;