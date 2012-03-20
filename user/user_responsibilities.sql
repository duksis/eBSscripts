/*
 Select for getting user responsibilities
*/

accept Eneter_username prompt "Please enter username: "

select res_vl.responsibility_name, res.start_date, res.end_date
from fnd_responsibility res,
     fnd_responsibility_vl res_vl,
     fnd_user usr,
     fnd_user_resp_groups_all res_g
where 1 = 1
and res.responsibility_id = res_vl.responsibility_id
and res.responsibility_id = res_g.responsibility_id
and res_g.user_id = usr.user_id
and sysdate between res.start_date and nvl(res.end_date,sysdate)
and user_name = upper('&Eneter_username')
order by 1;
/
EXIT
