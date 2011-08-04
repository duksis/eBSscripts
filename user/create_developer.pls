/*
Borrowed from Anil
Script for creating a EBS user with all necessary Responsibilities and profile values for a developer
*/

accept Enter_User_Name prompt 'Please enter username : ';
accept Enter_password prompt 'Please enter the new password : ';
accept Enter_e_mail prompt 'Please enter your e-mail: ';

DECLARE
  --By: Anil Passi
  --When Jun-2007
  v_session_id INTEGER := userenv('sessionid');
  v_user_name  VARCHAR2(30) := upper('&Enter_User_Name');
  v_email varchar2(30) :='&Enter_e_mail';
  v_description varchar2(50) := '&Enter_User_Name (user created with script)';
  result    BOOLEAN;
  v_user_id INTEGER;

  FUNCTION check_fu_name(p_user_name IN VARCHAR2) RETURN BOOLEAN IS
    CURSOR c_check IS
      SELECT 'x' FROM fnd_user WHERE user_name = p_user_name;
    p_check c_check%ROWTYPE;
  BEGIN
    OPEN c_check;
    FETCH c_check
      INTO p_check;
    IF c_check%FOUND
    THEN
      /*Yes, it exists*/
      CLOSE c_check;
      RETURN TRUE;
    END IF;
    CLOSE c_check;
    RETURN FALSE;
  END check_fu_name;

BEGIN
  IF NOT (check_fu_name(p_user_name => v_user_name))
  THEN
    fnd_user_pkg.createuser(x_user_name                  => v_user_name
                           ,x_owner                      => ''
                           ,x_unencrypted_password       => '&Enter_password'
                           ,x_session_number             => v_session_id
                           ,x_start_date                 => SYSDATE - 10
                           ,x_end_date                   => SYSDATE + 100
                           ,x_last_logon_date            => SYSDATE - 10
                           ,x_description                => v_description
                           ,x_password_date              => SYSDATE - 10
                           ,x_password_accesses_left     => 10000
                           ,x_password_lifespan_accesses => 10000
                           ,x_password_lifespan_days     => 10000
                           ,x_employee_id                => NULL /*Change this id by running below SQL*/
                            /*
                                                             SELECT person_id
                                                                   ,full_name
                                                             FROM   per_all_people_f
                                                             WHERE  upper(full_name) LIKE '%' || upper('<ampersand>full_name') || '%'
                                                             GROUP  BY person_id
                                                                      ,full_name
                                                             */
                           ,x_email_address => v_email
                           ,x_fax           => ''
                           ,x_customer_id   => ''
                           ,x_supplier_id   => '');
   dbms_output.put_line ( 'FND_USER Created' ) ;
  ELSE
    fnd_user_pkg.updateuser(x_user_name                  => v_user_name
                           ,x_owner                      => 'CUST'
                           ,x_end_date                   => fnd_user_pkg.null_date
                           ,x_password_date              => SYSDATE - 10
                           ,x_password_accesses_left     => 10000
                           ,x_password_lifespan_accesses => 10000
                           ,x_password_lifespan_days     => 10000);
   dbms_output.put_line ( 'End Date removed from FND_USER ' ) ;
  END IF;
  SELECT user_id
    INTO v_user_id
    FROM fnd_user
   WHERE user_name = v_user_name;
  fnd_user_pkg.addresp(username       => v_user_name
                      ,resp_app       => 'FND'
                      ,resp_key       => 'FND_FUNC_ADMIN'
                      ,security_group => 'STANDARD'
                      ,description    => v_description
                      ,start_date     => SYSDATE - 1
                      ,end_date       => SYSDATE + 10000);
  fnd_user_pkg.addresp(username       => v_user_name
                      ,resp_app       => 'SYSADMIN'
                      ,resp_key       => 'SYSTEM_ADMINISTRATOR'
                      ,security_group => 'STANDARD'
                      ,description    => v_description
                      ,start_date     => SYSDATE - 1
                      ,end_date       => SYSDATE + 10000);
  fnd_user_pkg.addresp(username       => v_user_name
                      ,resp_app       => 'FND'
                      ,resp_key       => 'FNDWF_ADMIN_WEB'
                      ,security_group => 'STANDARD'
                      ,description    => v_description
                      ,start_date     => SYSDATE - 1
                      ,end_date       => SYSDATE + 10000);
  fnd_user_pkg.addresp(username       => v_user_name
                      ,resp_app       => 'FND'
                      ,resp_key       => 'APPLICATION_DEVELOPER'
                      ,security_group => 'STANDARD'
                      ,description    => v_description
                      ,start_date     => SYSDATE - 1
                      ,end_date       => SYSDATE + 10000);

    fnd_user_pkg.addresp(username       => v_user_name,
                       resp_app       => 'ICX',
                       resp_key       => 'PREFERENCES',
                       security_group => 'STANDARD',
                       description    => v_description,
                       start_date     => sysdate - 1,
                       end_date       => null);

 result := fnd_profile.save(x_name        => 'APPS_SSO_LOCAL_LOGIN'
                            ,x_value       => 'BOTH'
                            ,x_level_name  => 'USER'
                            ,x_level_value => v_user_id);

 result := fnd_profile.save(x_name        => 'FND_CUSTOM_OA_DEFINTION'
                            ,x_value       => 'Y'
                            ,x_level_name  => 'USER'
                            ,x_level_value => v_user_id);

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


  COMMIT;
EXCEPTION
  when others then
    ROLLBACK;
    dbms_output.put_line('ERROR: '||sqlerrm);
END;
/
EXIT

