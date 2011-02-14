/** 
* Package without any functions: holds session state in variables.
* @deprecated Not recommended to create state.
*/
CREATE OR REPLACE
PACKAGE "session_state"
IS

current_user	VARCHAR2(100) := USER;
last_user		VARCHAR2(100) := USER;
last_id 		NUMBER;

END;
/

