/*
  Enable diagnostic options for a user
*/

SET SERVEROUTPUT ON SIZE 100000

accept username prompt 'Please enter username : ';

DECLARE
result    BOOLEAN;
v_user_id INTEGER;
BEGIN
 SELECT user_id INTO v_user_id FROM fnd_user WHERE user_name = upper('&username');

 result := fnd_profile.save(x_name        => 'FND_DIAGNOSTICS'
                            ,x_value       => 'Y'
                            ,x_level_name  => 'USER'
                            ,x_level_value => v_user_id);

 result := fnd_profile.save(x_name        => 'DIAGNOSTICS'
                            ,x_value       => 'Y'
                            ,x_level_name  => 'USER'
                            ,x_level_value => v_user_id);

 result := fnd_profile.save(x_name        => 'FND_HIDE_DIAGNOSTICS'
                            ,x_value       => 'N'
                            ,x_level_name  => 'USER'
                            ,x_level_value => v_user_id);

  if result then
    dbms_output.put_line('Diagnostics profile options added.');
  else
    dbms_output.put_line('Diagnostics profile options where NOT added!');
  end if;
EXCEPTION
  when others then
    dbms_output.put_line('ERROR: '||sqlerrm);

END;
