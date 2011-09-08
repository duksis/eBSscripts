/*
  Script for changing enabling user by removing users end date
  Should be executed from APPS.
*/

SET SERVEROUTPUT ON SIZE 100000

accept username prompt 'Please enter username : ';

DECLARE
v_username varchar2(30) := '&username';
l_start_date date;

BEGIN

  select start_date into l_start_date
  from fnd_user
  where user_name = upper(v_username);

  fnd_user_pkg.EnableUser(upper(v_username), l_start_date);

  dbms_output.put_line('SUCCESS || Users: '||upper(v_username)||' enabled.');

EXCEPTION
    When no_data_found then
        dbms_output.put_line('ERROR || Users: '||upper(v_username)||' not found.');
    When others then
        dbms_output.put_line('ERROR: "'||sqlerrm||'" when updating user '||v_username);
END;
/
EXIT
