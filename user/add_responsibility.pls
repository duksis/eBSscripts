/*
  Script for adding responsibility to existing user.
  Should be executed from APPS.
*/

SET SERVEROUTPUT ON SIZE 100000

accept username prompt 'Please enter username : ';
accept responsibility prompt 'Please enter name of responsibility: ';

DECLARE
  v_user_name varchar2(100) := upper('&username');
  v_responsibility varchar2(100) := upper('&responsibility');
  v_description varchar2(100);

  CURSOR resp_cur (resp_param IN varchar2) IS
  SELECT resp.responsibility_name, resp.responsibility_key, app.application_short_name
  FROM FND_RESPONSIBILITY_VL resp, FND_APPLICATION app
  WHERE app.application_id = resp.application_id
  AND upper(resp.responsibility_name) LIKE resp_param;

  type resp_arr_type is table of resp_cur%ROWTYPE;
  resp_arr resp_arr_type;

BEGIN
  open resp_cur(v_responsibility);
  fetch resp_cur BULK COLLECT INTO resp_arr;
  close resp_cur;

  dbms_output.put_line('==========================================================================');
  IF resp_arr.LAST = 1 THEN
    fnd_user_pkg.addresp(username       => v_user_name
                        ,resp_app       => resp_arr(resp_arr.LAST).application_short_name
                        ,resp_key       => resp_arr(resp_arr.LAST).responsibility_key
                        ,security_group => 'STANDARD'
                        ,description    => v_description
                        ,start_date     => SYSDATE - 1
                        ,end_date       => SYSDATE + 10000);
    dbms_output.put_line('= Responsibility: "'||resp_arr(resp_arr.LAST).responsibility_name||'" has been added.');
  ELSIF resp_arr.LAST > 1 THEN
    dbms_output.put_line('= Multiple matching responsibilities have been found for string: '||v_responsibility);
    FOR i in resp_arr.FIRST..resp_arr.LAST LOOP
      dbms_output.put_line('= " '||resp_arr(i).responsibility_name||' "');
    END LOOP;
  ELSE
    dbms_output.put_line('= There are no matching responsibilities for string: '||v_responsibility);
  END IF;
  dbms_output.put_line('==========================================================================');
EXCEPTION
  when others then
    dbms_output.put_line('ERROR: '||sqlerrm);

END;
/
EXIT
