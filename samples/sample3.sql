CREATE OR REPLACE
PACKAGE depr
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     A little bit naïve but want to use national character here.<br/>
* DB impact:       YES<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample3.sql,v 1.4 2003/02/01 12:34:56 altumano Exp $<br/>
* ========================================================================<br/>
* @deprecated Try to get around without this stuff.
*/
IS

/** Gets something.
* Hopefully...
*
* @deprecated Use Get_By_Criteria instead.
* @param   p_sector2	business sector2
* @param   p_sector	business sector
* @param p_sector3	business sector3 
*/
PROCEDURE depr_Get (
  p_sector2             VARCHAR2,
  p_sector    VARCHAR2,
  p_sector3         NUMBER,
  p_sector4         NUMBER);

/*
XXX
YYY
@param p_sector business sector999
@return Standard Fehler345
*/ 
FUNCTION do_something (
  p_sector    VARCHAR2)
RETURN NUMBER;

END;
/

