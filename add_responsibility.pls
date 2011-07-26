/*
  Script for adding responsibility to existing user.
  Should be executed from APPS.
*/

SET SERVEROUTPUT ON SIZE 100000

accept username prompt 'Please enter username : ';
accept responsibility promt 'Please enter name of responsibility: ';

DECLARE
  v_user_name varchar2(100) := upper('&username');
  v_responsibility varchar2(100) := upper('&responsibility');
  v_description varchar2(100);

  l_resp_app varchar2(20);
  l_resp_key varchar2(60);

BEGIN
  SELECT resp.responsibility_key, app.application_short_name
  INTO l_resp_key, l_resp_app
  FROM FND_RESPONSIBILITY_VL resp, FND_APPLICATION app
  WHERE app.application_id = resp.application_id
  AND upper(resp.responsibility_name) LIKE '%'||v_responsibility||'%';

  fnd_user_pkg.addresp(username       => v_user_name
                      ,resp_app       => l_resp_app
                      ,resp_key       => l_resp_key
                      ,security_group => 'STANDARD'
                      ,description    => v_description
                      ,start_date     => SYSDATE - 1
                      ,end_date       => SYSDATE + 10000);
EXCEPTION
  when others then
    dbms_output.put_line('ERROR: '||sqlerrm);

END;
/
EXIT
