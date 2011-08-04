/*
  Remove user password end date
*/

accept Eneter_username prompt "Please enter username: "

BEGIN
fnd_user_pkg.updateuser(x_user_name                  => '&Eneter_username'
                           ,x_owner                      => 'CUST'
                           ,x_end_date                   => fnd_user_pkg.null_date
                           ,x_password_date              => SYSDATE - 10
                           ,x_password_accesses_left     => fnd_user_pkg.null_number
                           ,x_password_lifespan_accesses => fnd_user_pkg.null_number
                           ,x_password_lifespan_days     => fnd_user_pkg.null_number);
END;
/
COMMIT;
