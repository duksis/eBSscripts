/*
  Initialize user from pl/sql
  --TODO add R12 initialization stuff
*/

DECLARE

   v_user_id   NUMBER(12);
   v_resp_id   NUMBER(12);
   v_app_id    NUMBER(12);

BEGIN

  SELECT user_id
    INTO v_user_id
  FROM apps.fnd_user
  WHERE user_name = 'DUKSIHUG';

  SELECT responsibility_id, APPLICATION_ID
    INTO v_resp_id, v_app_id
  FROM apps.fnd_responsibility_tl
  WHERE responsibility_name LIKE 'Global Super %Manager'
  AND LANGUAGE = 'US';

  apps.fnd_global.apps_initialize(v_user_id, v_resp_id, v_app_id);

COMMIT;

EXCEPTION
  when others then
    ROLLBACK;
    dbms_output.put_line('ERROR: '||sqlerrm);
END;
/
EXIT
