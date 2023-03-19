--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET serveroutput ON size 1000000;
set define on;
SET echo OFF;
SET verify OFF;
def v_evento='Circo';
def v_fila='1';
def v_columna='1';
variable v_error char(20)
/
declare
  v_existe varchar(20) default null;
begin
  select count(*) into v_existe from butacas where evento='&v_evento' and fila='&v_fila' and columna='&v_columna';
  if v_existe<>'0' then 
    select count(*) into v_existe from reservas where evento='&v_evento' and fila='&v_fila' and columna='&v_columna';
    if v_existe='0' then
      dbms_output.put_line('INFO: Se intenta reservar.');
      :v_error:='false';
    else
      dbms_output.put_line('ERROR: La localidad ya está reservada.');
      :v_error:='true';
    end if;
  else
    dbms_output.put_line('ERROR: No existe esa localidad.');
    :v_error:='true';
  end if;
end;
/
col SCRIPT_COL new_val SCRIPT
select decode(:v_error,'false','"C:\hlocal\Pr7\scripts\preguntar.sql"',
                               '"C:\hlocal\Pr7\scripts\no_preguntar.sql"') as SCRIPT_COL from dual;
print :v_error
--prompt 'Valor script: '&SCRIPT
@ &SCRIPT
prompt &v_confirmar
/
begin
  if '&v_confirmar'='s' and :v_error='false' then
    insert into reservas values (Seq_Reservas.NEXTVAL,'&v_evento','&v_fila','&v_columna');
    dbms_output.put_line('INFO: Localidad reservada.');
  else
    dbms_output.put_line('INFO: No se ha reservado la localidad.');
  end if;
end;
/
COMMIT;
