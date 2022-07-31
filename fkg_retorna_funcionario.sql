create or replace
function fkg_retorna_funcionario (en_job in scott.emp.job%type)

  return scott.emp.empno%type
  
is

  vn_id_funcionario scott.emp.empno%type;
  
begin

  begin
    select emp.empno
      into vn_id_funcionario
      from scott.emp
     where emp.job = en_job
       and emp.sal in (select max(emp.sal) from scott.emp group by emp.job);
  exception
    when too_many_rows then
    
      select emp.empno
        into vn_id_funcionario
        from scott.emp
       where emp.job = en_job
         and emp.sal in (select max(emp.sal) from scott.emp group by emp.job)
         and emp.hiredate in (select max(emp.hiredate) from scott.emp group by emp.job);
       
  end;
  
  return vn_id_funcionario;
  
exception
  when others then
  
    raise_application_error(-20101, 'Erro na  fkg_retorna_funcionario- '||sqlerrm);
    
end fkg_retorna_funcionario;