-----------------------Unified Auditing--------------------------------

Desc V$OPTION

select count(*)
from V$OPTION ; ---87 Rows Data

select *
from V$OPTION
order by parameter ;

select *
from V$OPTION
WHERE upper(parameter) like upper('%aud%') ;

select *
from V$OPTION
WHERE parameter = 'Unified Auditing' ;

SELECT VALUE
FROM V$OPTION
WHERE PARAMETER = 'Unified Auditing';


desc UNIFIED_AUDIT_TRAIL

select count(*)
from UNIFIED_AUDIT_TRAIL ;

select *
from UNIFIED_AUDIT_TRAIL ;


select *
from UNIFIED_AUDIT_TRAIL
where dbusername = 'HR' ;

select audit_type,SQL_text, action_name, current_user, scn,
object_name, object_schema, client_program_name, dbusername,
terminal, os_username, sessionid,
to_char(event_timestamp ,'DD-Mon-RRRR hh:mi:ssam')event_timestamp,
authentication_type
from UNIFIED_AUDIT_TRAIL
where dbusername = 'HR'
order by event_timestamp desc ;

---------------------------------------------Procedure-----------------------------------------

1. shutdown db

shutdown immediate;

2. off listener from service

3. rename orauniaud19.dll.dbl file from
D:\app\oracle\product\19.0.0\dbhome_1\bin\orauniaud19.dll.dbl
to orauniaud19.dll
D:\app\oracle\product\19.0.0\dbhome_1\bin\orauniaud19.dll

4. on listener

5. start db
    startup force;
    or maunally from service
    
6. privilege/permission/grant for db user which monitor for audit

    grant AUDIT_ADMIN, AUDIT_VIEWER to hr ;
    
7. execute procedure under DBMS_AUDIT_MGMT Package
    EXEC SYS.DBMS_AUDIT_MGMT.FLUSH_UNIFIED_AUDIT_TRAIL ;
8. Creating audit policy

    CREATE AUDIT POLICY select_dept_dba180_p
    ACTIONS select on hr.departments ;
    
    CREATE AUDIT POLICY all_dept_hr_p
    ACTIONS all on hr.departments ;
		
    CREATE AUDIT POLICY all_dept_hr_p
    ACTIONS all ; /* it will create a audit policy which applicable on all object */
    
    CREATE AUDIT POLICY dba180_Policy_2
    ACTIONS CREATE USER, DROP USER, ALTER USER, ALTER TABLE, CREATE TABLE, DROP TABLE ;
    audit policy dba180_Policy_2 ;
    
9. enable the created audit policy

    AUDIT POLICY select_dept_dba180_p ;
    AUDIT POLICY all_dept_hr_p ;
10. tag audit policy
    AUDIT POLICY all_dept_hr_p by hr ;
    
11. check audit for hr user
    select audit_type,SQL_text, action_name, current_user, scn,
    object_name, object_schema, client_program_name, dbusername,
    terminal, os_username, sessionid,
    to_char(event_timestamp ,'DD-Mon-RRRR hh:mi:ssam')event_timestamp,
    authentication_type
    from UNIFIED_AUDIT_TRAIL
    where dbusername = 'HR'
    order by event_timestamp desc ;
    
12. disable audit policy
    NOAUDIT POLICY SELECT_DEPT_DBA180_P ;
13. drop audit policy
    DROP AUDIT POLICY SELECT_DEPT_DBA180_P ;

14. Delete from Unified Audit Trail

    		BEGIN
		DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL
 		(
			 AUDIT_TRAIL_TYPE => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
 			 USE_LAST_ARCH_TIMESTAMP => FALSE,
 			 CONTAINER => dbms_audit_mgmt.container_current
		) ;
		END ;
		/
--------------------------Query on Unified Audit-------------------------------------

desc audit_unified_policies ;

select distinct audit_option
from audit_unified_policies
order by audit_option ;

desc audit_unified_enabled_policies ;

SELECT *
FROM audit_unified_enabled_policies ;

select *
from audit_unified_policies
where policy_name in (select policy_name
from audit_unified_enabled_policies)
order by policy_name, audit_option ;

select count(audit_option)
from audit_unified_policies
where policy_name in (select policy_name
from audit_unified_enabled_policies)
order by policy_name, audit_option ;

select audit_type,SQL_text, action_name, current_user, scn,
object_name, object_schema, client_program_name, dbusername,
terminal, os_username, sessionid,
to_char(event_timestamp ,'DD-Mon-RRRR hh:mi:ssam')event_timestamp,
authentication_type
from UNIFIED_AUDIT_TRAIL
where dbusername = 'HR'
order by event_timestamp desc ;

