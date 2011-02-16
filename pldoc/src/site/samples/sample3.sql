PACKAGE logg
IS
/**
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     Logging of PL/SQL code events and data that caused the events<br/>
* DB impact:       YES<br/>
* Commit inside:   YES<br/>
* Rollback inside: NO<br/>
* @headcom
*/

SUBTYPE Log_Record IS logs%ROWTYPE;
TYPE Log_Table IS TABLE OF Log_Record INDEX BY BINARY_INTEGER;

/**  Records an ERROR in the error logging table.
* NB: the level filter may prevent the record to be actually written. (values of variables, parameters etc)
* @param txt             text containing the context of the situation (values of variables, parameters etc)
* @param loc             location in code (denoted by some ID which is unique in the procedure/function)
* @param proc            procedure or function name
* @param pck             package name
* @param sch             database schema name
* @param usr             application user name (if NULL, USER will be written)
* @param err             Error text
* @param dtime           datetime (if NULL, sysdate is used)
*/
PROCEDURE add_error (
  txt             VARCHAR2 DEFAULT '',
  loc             VARCHAR2 DEFAULT '',
  proc            VARCHAR2 DEFAULT '',
  pck             VARCHAR2 DEFAULT '',
  sch             VARCHAR2 DEFAULT '',
  usr             VARCHAR2 DEFAULT USER,
  err             VARCHAR2 DEFAULT '',
  dtime           DATE     DEFAULT SYSDATE);

/**  Records an WARNING in the error logging table.
* NB: the level filter may prevent the record to be actually written. (values of variables, parameters etc)
* @param txt             text containing the context of the situation (values of variables, parameters etc)
* @param loc             location in code (denoted by some ID which is unique in the procedure/function)
* @param proc            procedure or function name
* @param pck             package name
* @param sch             database schema name
* @param usr             application user name (if NULL, USER will be written)
* @param err             Error text
* @param dtime           datetime (if NULL, sysdate is used)
*/
PROCEDURE add_warning (
  txt             VARCHAR2 DEFAULT '',
  loc             VARCHAR2 DEFAULT '',
  proc            VARCHAR2 DEFAULT '',
  pck             VARCHAR2 DEFAULT '',
  sch             VARCHAR2 DEFAULT '',
  usr             VARCHAR2 DEFAULT USER,
  err             VARCHAR2 DEFAULT '',
  dtime           DATE     DEFAULT SYSDATE);

/**  Records an WARNING in the error logging table.
* NB: the level filter may prevent the record to be actually written. (values of variables, parameters etc)
* @param txt             text containing the context of the situation (values of variables, parameters etc)
* @param loc             location in code (denoted by some ID which is unique in the procedure/function)
* @param proc            procedure or function name
* @param pck             package name
* @param sch             database schema name
* @param usr             application user name (if NULL, USER will be written)
* @param err             Error text
* @param dtime           datetime (if NULL, sysdate is used)
*/
PROCEDURE add_trace (
  txt             VARCHAR2 DEFAULT '',
  loc             VARCHAR2 DEFAULT '',
  proc            VARCHAR2 DEFAULT '',
  pck             VARCHAR2 DEFAULT '',
  sch             VARCHAR2 DEFAULT '',
  usr             VARCHAR2 DEFAULT USER,
  err             VARCHAR2 DEFAULT '',
  dtime           DATE     DEFAULT SYSDATE);

/**  Records an event in the error logging table.
* NB: the level filter may prevent the record to be actually written. (values of variables, parameters etc)
* @param p_type          log type (E=error, W=warning, T=trace)
* @param txt             text containing the context of the situation (values of variables, parameters etc)
* @param loc             location in code (denoted by some ID which is unique in the procedure/function)
* @param proc            procedure or function name
* @param pck             package name
* @param sch             database schema name
* @param usr             application user name (if NULL, USER will be written)
* @param err             Error text
* @param dtime           datetime (if NULL, sysdate is used)
*/
PROCEDURE add_record (
  p_type          VARCHAR2,
  txt             VARCHAR2 DEFAULT '',
  loc             VARCHAR2 DEFAULT '',
  proc            VARCHAR2 DEFAULT '',
  pck             VARCHAR2 DEFAULT '',
  sch             VARCHAR2 DEFAULT '',
  usr             VARCHAR2 DEFAULT USER,
  err             VARCHAR2 DEFAULT '',
  dtime           DATE     DEFAULT SYSDATE);

-- Saves pending logs into the log table
PROCEDURE Flush;

-- Shows pending logs on DBMS_OUTPUT, without erasing them
PROCEDURE Show_Output;

-- Clear pending logs
PROCEDURE Clean;

END;
/

