/*
  Select returns detailed concurent program information from concurrent request id
*/

accept Enter_request_id prompt 'Please enter request_id : ';

SELECT cr.request_id,
   re.responsibility_key AS RESPONSIBILITY,
   us.user_name,
   us.description,
   us.email_address ,
   cp.concurrent_program_name AS Concurrent_program_short_name,
   cp.user_concurrent_program_name AS concurrent_program_name,
   fa.application_short_name,
   fa.application_name
   --,rg.request_group_name,
   -- cr.*
FROM apps.fnd_concurrent_requests cr,
apps.fnd_responsibility re,
apps.fnd_user us ,
apps.fnd_concurrent_programs_vl cp,
apps.fnd_application_vl fa
--,apps.fnd_request_group_units rgu ,
--apps.fnd_request_groups rg
WHERE 1 = 1
AND re.responsibility_id = cr.responsibility_id
AND cr.requested_by = us.user_id
AND cp.concurrent_program_id = cr.concurrent_program_id
AND cr.program_application_id = fa.application_id
--AND rg.request_group_id = rgu.request_group_id
--AND rgu.request_unit_id = cr.concurrent_program_id
AND cr.request_id = '&Enter_request_id';
/
