/*
  Schedule concurrent request from pl/sql
*/

SET DBMSOUTPUT ON  SIZE 100000

accept username prompt 'Please enter username : ';
accept responsibility prompt 'Please enter name of responsibility: ';
-- TODO Add other parameters (concurrent program and parameter information)

DECLARE
  v_user varchar2(10) := upper('&username');
  v_resp varchar2(20) := upper('&responsibility');
  v_user_id NUMBER;
  v_resp_id NUMBER;
  v_resp_appl_id NUMBER;
  v_request_id NUMBER;

  v_appl_shortname varchar2(10);
  v_conc_prog_shortname varchar2(30);
  v_description varchar2(100);
  v_argument1 VARCHAR2(50);
  v_argument2 VARCHAR2(50);
  v_argument3 VARCHAR2(50);
  v_argument4 VARCHAR2(50);

BEGIN

SELECT user_id INTO v_user_id
FROM fnd_user
WHERE user_name = v_user;

SELECT res.application_id, res.responsibility_id INTO v_resp_appl_id, v_resp_id
FROM fnd_responsibility res,
     fnd_responsibility_tl rest
WHERE res.responsibility_id = rest.responsibility_id
AND rest.responsibility_name = v_resp;

fnd_global.apps_initialize(user_id => v_user_id,
                           resp_id => v_resp_id,
                           resp_appl_id => v_resp_appl_id );

v_request_id := fnd_request.submit_request(
  application => v_appl_shortname,
  program => v_conc_prog_shortname,
  description => v_description,
  argument1 => v_argument1,
  argument2 => v_argument2,
  argument3 => v_argument3,
  argument4 => v_argument4 --# arguments 1..100
  );

COMMIT;

  IF v_request_id > 0 THEN

   dbms_output.put_line('concurrent request:'||v_request_id||' successfully submitted');

  ELSE

    dbms_output.put_line('Not Submitted');

  END IF;
EXCEPTION
  when others then
    dbms_output.put_line('ERROR: '||sqlerrm);
END;
/
EXIT
