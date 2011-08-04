/*
  Script for changing user password without the need to change it at first login
  Should be executed from APPS.
*/

SET SERVEROUTPUT ON SIZE 100000

accept username prompt 'Please enter username : ';
accept password prompt 'Please enter the new password : ';

DECLARE
v_username varchar2(30) := '&username';
v_newpassword varchar2(30) := '&password';

BEGIN

  IF fnd_user_pkg.changepassword(upper(v_username), v_newpassword) THEN
      COMMIT;
      dbms_output.put_line('SUCCESS || Users: '||upper(v_username)||' password set to: '||v_newpassword);
  ELSE
      dbms_output.put_line('ERROR || Users: '||upper(v_username)||' password was not set to: '||v_newpassword);
  END IF;

EXCEPTION
    When others then
        dbms_output.put_line('ERROR: "'||sqlerrm||'" when updating user '||v_username);
END;
/
EXIT
