/*
  Select active session information from database
  use from APPS
*/

SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program
FROM   gv$session s,
       gv$process p 
WHERE p.addr = s.paddr 
AND p.inst_id = s.inst_id
AND s.type != 'BACKGROUND';

/*
-- ALTER SYSTEM DISCONNECT SESSION 'sid,serial#' POST_TRANSACTION;
-- ALTER SYSTEM DISCONNECT SESSION 'sid,serial#' IMMEDIATE;
--
-- ALTER SYSTEM KILL SESSION 'sid,serial#';
-- ALTER SYSTEM KILL SESSION 'sid,serial#,@inst_id'; # This allows you to kill a session on different RAC node.
-- ALTER SYSTEM KILL SESSION 'sid,serial#' IMMEDIATE;
--
-- C:> orakill ORACLE_SID spid # Windows approach
--
-- % kill -9 spid # UNIX approach, to verify can use % ps -ef | grep ora
*/
