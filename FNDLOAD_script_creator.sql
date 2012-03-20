/*
  Creates FNDLOAD string for downloading concurrent programms by specifying just the program full name
  fnd load example by Anil Passi:    http://oracle.anilpassi.com/oracle-fndload-script-examples.html
*/

accept Enter_cr_full_name prompt "Please enter concurrent program full name: "

SELECT 'FNDLOAD '
|| (SELECT username
    FROM v$session
    WHERE audsid = USERENV ('sessionid'))
|| '/$apppwd 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct '
|| fc.concurrent_program_name
|| '.ldt '
|| 'PROGRAM APPLICATION_SHORT_NAME="'
|| ap.application_short_name
|| '" CONCURRENT_PROGRAM_NAME="'
|| fc.concurrent_program_name
|| '"'
FROM
  fnd_concurrent_programs_vl fc, fnd_application ap
WHERE
fc.application_id = ap.application_id
AND fc.user_concurrent_program_name = '&Enter_cr_full_name';
/
