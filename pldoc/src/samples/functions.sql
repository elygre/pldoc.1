/**
 * Sample package to test various function
 * definition clauses
 */ 
create or replace package functions
as 

	/** 
	 * Sample function with RESULT_CACHE option,
	 * ref http://sourceforge.net/tracker/index.php?func=detail&aid=3048528&group_id=38875&atid=423476
	 */
	function all1 ( p_naam in varchar2)
	return varchar2
	DETERMINISTIC
	PARALLEL_ENABLE
	PIPELINED
	RESULT_CACHE
	;

	/**
	 * Function with same clauses, but different order
	 */
	function all2 ( p_naam in varchar2)
	return varchar2
	RESULT_CACHE
	PIPELINED
	PARALLEL_ENABLE
	DETERMINISTIC
	;

	/** No-frills function */
	function none return number;
	
end;
/