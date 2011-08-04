/*
 Select for getting user responsibilities
*/

accept Eneter_username prompt "Please enter username: "

select res_tl.responsibility_name
from fnd_responsibility res,
     fnd_responsibility_tl res_tl,
     fnd_user usr,
     fnd_user_resp_groups_all res_g
where 1 = 1
and res.responsibility_id = res_tl.responsibility_id
and res.responsibility_id = res_g.responsibility_id
and res_g.user_id = usr.user_id
and res_tl.language = 'US'
and user_name = upper('&Eneter_username');
/

