PACKAGE syspar IS
/** 
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     System Parameters Management<br/>
* DB impact:       YES<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* @headcom
*/


/** Gets system parameter value.
* @param p_name    parameter name
* @return          parameter value
* @throws no_data_found if no parameter with such name found
*/
FUNCTION get_char
 (p_name           VARCHAR2)
RETURN VARCHAR2;

/** Gets system parameter value.
* @param p_name    parameter name
* @return          parameter value
* @throws no_data_found if no parameter with such name found
*/
FUNCTION get_date
 (p_name           VARCHAR2)
RETURN DATE;

/** Gets system parameter value.
* @param p_name    parameter name
* @return          parameter value
* @throws no_data_found if no parameter with such name found
*/
FUNCTION get_number
 (p_name           VARCHAR2)
RETURN NUMBER;

END;
/
