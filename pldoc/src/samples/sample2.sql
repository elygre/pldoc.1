CREATE OR REPLACE
PACKAGE LOGG
IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     Logging<br/>
* DB impact:       YES<br/>
* Commit inside:   YES<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

SUBTYPE Log_Record IS logs%ROWTYPE;

TYPE Log_Table IS TABLE OF Log_Record INDEX BY BINARY_INTEGER;

-- Records an ERROR in the error logging table.
PROCEDURE add_error (
  txt             VARCHAR2 DEFAULT 'NONE',      -- text
  loc             VARCHAR2 DEFAULT 'UNKNOWN',   -- location in code
  proc            VARCHAR2 DEFAULT 'UNKNOWN',   -- procedure of function name
  pck             VARCHAR2 DEFAULT 'UNKNOWN',   -- package name
  usr             VARCHAR2 DEFAULT USER,        -- (application) user name
  err             VARCHAR2 DEFAULT 'UNKNOWN',   -- Oracle error text
  dtime           DATE     DEFAULT SYSDATE);    -- datetime

-- Records a WARNING in the error logging table.
PROCEDURE add_warning (
  txt             VARCHAR2 DEFAULT 'NONE',      -- text
  loc             VARCHAR2 DEFAULT 'UNKNOWN',   -- location in code
  proc            VARCHAR2 DEFAULT 'UNKNOWN',   -- procedure of function name
  pck             VARCHAR2 DEFAULT 'UNKNOWN',   -- package name
  usr             VARCHAR2 DEFAULT USER,        -- (application) user name
  err             VARCHAR2 DEFAULT 'UNKNOWN',   -- Oracle error text
  dtime           DATE     DEFAULT SYSDATE);    -- datetime

-- Records a TRACE in the error logging table.
PROCEDURE add_trace (
  txt             VARCHAR2 DEFAULT 'NONE',      -- text
  loc             VARCHAR2 DEFAULT 'UNKNOWN',   -- location in code
  proc            VARCHAR2 DEFAULT 'UNKNOWN',   -- procedure of function name
  pck             VARCHAR2 DEFAULT 'UNKNOWN',   -- package name
  usr             VARCHAR2 DEFAULT USER,        -- (application) user name
  err             VARCHAR2 DEFAULT 'UNKNOWN',   -- Oracle error text
  dtime           DATE     DEFAULT SYSDATE);    -- datetime

-- Records an event in the error logging table.
PROCEDURE add_record (
  p_type          VARCHAR2,                     -- log type
  txt             VARCHAR2 DEFAULT 'NONE',      -- text
  loc             VARCHAR2 DEFAULT 'UNKNOWN',   -- location in code
  proc            VARCHAR2 DEFAULT 'UNKNOWN',   -- procedure of function name
  pck             VARCHAR2 DEFAULT 'UNKNOWN',   -- package name
  usr             VARCHAR2 DEFAULT USER,        -- (application) user name
  err             VARCHAR2 DEFAULT 'UNKNOWN',   -- Oracle error text
  dtime           DATE     DEFAULT SYSDATE);    -- datetime

-- Saves pending logs into the log table
PROCEDURE Flush;

-- Shows pending logs on DBMS_OUTPUT, without erasing them
PROCEDURE Show_Output;

-- Clear pending logs
PROCEDURE Clean;


FUNCTION Get_Call_Stack
RETURN VARCHAR2;

END;
/
show errors

GRANT EXECUTE ON pkg_branches TO PUBLIC
/

CREATE OR REPLACE
PACKAGE MESSAGE
IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     Messages<br/>
* DB impact:       NO<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

SUBTYPE messages_type IS messages%ROWTYPE;

-- Get all data for a message
FUNCTION Get_Data (
  mes_id            IN NUMBER,
  mes_rec           IN OUT messages_type)
RETURN NUMBER;

-- Get the text for a message
FUNCTION Get_Text (
  mes_id            IN NUMBER,
  mes_text          IN OUT VARCHAR2)
RETURN NUMBER;

-- Get the customized text for a message,
-- replacing '#1' with param1, etc
FUNCTION Text (
  mes_id            IN NUMBER,
  param1            IN VARCHAR2 DEFAULT NULL,
  param2            IN VARCHAR2 DEFAULT NULL,
  param3            IN VARCHAR2 DEFAULT NULL,
  param4            IN VARCHAR2 DEFAULT NULL,
  param5            IN VARCHAR2 DEFAULT NULL,
  param6            IN VARCHAR2 DEFAULT NULL,
  param7            IN VARCHAR2 DEFAULT NULL,
  param8            IN VARCHAR2 DEFAULT NULL,
  param9            IN VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2;

-- Get the text for a message ( return varchar2 )
FUNCTION Get_Char_Text (
  mes_id            IN NUMBER)
RETURN VARCHAR2;

END;
/


CREATE OR REPLACE
PACKAGE SysPar IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     System Parameters<br/>
* DB read:         YES<br/>
* DB write:        NO<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

FUNCTION Get_Char
 (p_name    IN     VARCHAR2)  -- parameter name
RETURN VARCHAR2;              -- parameter value

FUNCTION Get_Date
 (p_name    IN     VARCHAR2)  -- parameter name
RETURN DATE;                  -- parameter value

FUNCTION Get_Number
 (p_name    IN     VARCHAR2)  -- parameter name
RETURN NUMBER;                -- parameter value

/**
* Sets value of system parameter.
* @param p_name     parameter name
* @param p_value    parameter new value
*/
PROCEDURE Set_Date(
  p_name    VARCHAR2,
  p_value   DATE);

END;
/

CREATE OR REPLACE
PACKAGE TEMPLATE
IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     Templates<br/>
* DB impact:       YES<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

TYPE template_type IS RECORD (
  id          VARCHAR2(20),
  object_id   VARCHAR2(20),
  name        VARCHAR2(50),
  seq         NUMBER
);
TYPE template_table IS TABLE OF template_type INDEX BY BINARY_INTEGER;

SUBTYPE tmpl_texts_type IS tmpl_texts%ROWTYPE;
TYPE tmpl_texts_table IS TABLE OF tmpl_texts_type INDEX BY BINARY_INTEGER;

-- Get template rows by id
PROCEDURE Get (
  p_id              VARCHAR2,                   -- template ID
  r_rows            IN OUT tmpl_texts_table,    -- template texts
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Get list of templates
PROCEDURE Get_List (
  p_object_id       VARCHAR2,                   -- object ID
  p_field           VARCHAR2,                   -- field
  r_rows            IN OUT template_table,      -- template rows
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Create template
PROCEDURE Create_Template (
  p_name            VARCHAR2,                   -- name for the new template
  p_object_id       VARCHAR2,                   -- object ID
  r_id              IN OUT VARCHAR2,            -- ID of the template created
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Change template text
PROCEDURE Change_Text (
  p_id              VARCHAR2,                   -- template ID
  p_object_id       VARCHAR2,                   -- object ID
  p_field           VARCHAR2,                   -- field
  p_text            VARCHAR2,                   -- new text for the field
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Update template text
PROCEDURE Update_Text (
  p_texts           tmpl_texts_table,           -- template texts
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Delete template
PROCEDURE Delete_Template (
  p_id              VARCHAR2,                   -- template ID
  r_rows            IN OUT tmpl_texts_table,    -- template texts
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Lock template
PROCEDURE Lock_Template (
  p_id              VARCHAR2,                   -- template ID
  p_texts           tmpl_texts_table,           -- template texts
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Get list of allowed objects
PROCEDURE Get_Objects (
  r_rows            IN OUT u.string_array_small,-- objects
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

-- Get template text
PROCEDURE Get_Text (
  p_id              VARCHAR2,                   -- template ID
  p_object_id       VARCHAR2,                   -- object ID
  p_field           VARCHAR2,                   -- field
  r_text            IN OUT VARCHAR2,            -- template text
  r_result          IN OUT NUMBER,              -- return code, 0=ok
  r_message         IN OUT VARCHAR2);           -- return message

END;
/

CREATE OR REPLACE
PACKAGE TEXT
IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     Multilingual Texts<br/>
* DB impact:       YES<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

-- Get settlement type details text
PROCEDURE Get (
  p_set_id          VARCHAR2,           -- ID of the text
  p_lang            VARCHAR2,           -- language of the text
  r_text            OUT VARCHAR2,       -- text
  r_result          OUT NUMBER,         -- return code, 0=ok
  r_message         OUT VARCHAR2);      -- return message

END;
/

CREATE OR REPLACE
PACKAGE U
IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     General utilities<br/>
* DB impact:       NO<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

-- Global Constants

-- linebreak symbol
function br return varchar2;

-- current user, time
function current_user return varchar2;
function current_date return DATE;

-- date used in conditions using NVL
function dummy_date return DATE;

--date/time formats
function date_format return varchar2;
function time_format return varchar2;

-- useful for eliminating non-numbers or non-alphanumerics
function translate_format return varchar2;

TYPE number_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE string_array IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;
TYPE string_array_small IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;

-- Break a delimited string into array of lines
FUNCTION Break_Into_Lines (
  string        IN VARCHAR2,
  delimiter     IN VARCHAR2,
  line_count    IN OUT NUMBER,
  lines         IN OUT String_Array)
RETURN NUMBER;

-- Get the specified line from a newline-delimited string
FUNCTION Get_Line (
  string        IN VARCHAR2,
  line_no       IN NUMBER)
RETURN VARCHAR2;

-- Get the specified lines from a newline-delimited string
FUNCTION Get_Lines (
  string        IN VARCHAR2,
  from_line_no  IN NUMBER,          -- starting from line (NULL=1)
  to_line_no    IN NUMBER)          -- upto from line (NULL=last)
RETURN VARCHAR2;

-- Concatenate all parameters, delimiting with linebreaks
FUNCTION Glue (
  string00      VARCHAR2 DEFAULT '@@@',
  string01      VARCHAR2 DEFAULT '@@@',
  string02      VARCHAR2 DEFAULT '@@@',
  string03      VARCHAR2 DEFAULT '@@@',
  string04      VARCHAR2 DEFAULT '@@@',
  string05      VARCHAR2 DEFAULT '@@@',
  string06      VARCHAR2 DEFAULT '@@@',
  string07      VARCHAR2 DEFAULT '@@@',
  string08      VARCHAR2 DEFAULT '@@@',
  string09      VARCHAR2 DEFAULT '@@@',
  string10      VARCHAR2 DEFAULT '@@@',
  string11      VARCHAR2 DEFAULT '@@@',
  string12      VARCHAR2 DEFAULT '@@@',
  string13      VARCHAR2 DEFAULT '@@@',
  string14      VARCHAR2 DEFAULT '@@@',
  string15      VARCHAR2 DEFAULT '@@@',
  string16      VARCHAR2 DEFAULT '@@@',
  string17      VARCHAR2 DEFAULT '@@@',
  string18      VARCHAR2 DEFAULT '@@@',
  string19      VARCHAR2 DEFAULT '@@@')
RETURN VARCHAR2;

-- Checks if an array is composed entirely of blank strings.
-- The array's range is (first_linem,last_line).
FUNCTION All_Empty (
  lines         IN String_Array,
  first_line    IN NUMBER,
  last_line     IN NUMBER)
RETURN BOOLEAN;

-- Get the name of the current user (for logging).
FUNCTION Get_User (
  p_user        IN VARCHAR2)    -- application-supplied username of NULL
RETURN VARCHAR2;

-- Get current date (not time).
FUNCTION Get_Date
RETURN DATE;

-- Get current date and time.
FUNCTION Get_Time
RETURN DATE;

-- Convert VARCHAR2 to BOOLEAN.
FUNCTION char2bool(
  str       VARCHAR2,                 -- string containing 'TRUE','FALSE','' or NULL
  def_value BOOLEAN DEFAULT FALSE)    -- value to return in case of str='' or NULL
RETURN BOOLEAN;                       -- boolean value

-- Convert BOOLEAN to VARCHAR2.
FUNCTION bool2char(
  bool      BOOLEAN,                  -- boolean or NULL
  def_value VARCHAR2 DEFAULT 'FALSE') -- value to return in case of bool=NULL
RETURN VARCHAR2;                      -- string value 'TRUE' or 'FALSE'

-- Get day of week
FUNCTION Get_Weekday(
  p_date    DATE)   -- date
RETURN VARCHAR2;    -- day of week ('MON','TUE','WED','THU','FRI','SAT','SUN')

-- NULL-safe comparison of two values
FUNCTION equals(
  val1        VARCHAR2,                 -- first value
  val2        VARCHAR2)                 -- second value
RETURN BOOLEAN;                         -- TRUE if they equal, FALSE otherwise

-- NULL-safe comparison of two values
FUNCTION equals(
  val1        DATE,                     -- first value
  val2        DATE)                     -- second value
RETURN BOOLEAN;                         -- TRUE if they equal, FALSE otherwise

-- NULL-safe length of string
FUNCTION len(
  str         VARCHAR2)                 -- string to measure
RETURN NUMBER;                          -- nvl(length(str),0)

END;
/

CREATE OR REPLACE
PACKAGE UserParam
IS
/** 
* ========================================================================<br/>
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     User Parameters Management<br/>
* DB impact:       YES<br/>
* Commit inside:   YES<br/>
* Rollback inside: YES<br/>
* ------------------------------------------------------------------------<br/>
* $Header: /cvsroot/pldoc/sources/samples/sample2.sql,v 1.5 2002/12/02 20:37:37 altumano Exp $<br/>
* ========================================================================<br/>
* @headcom
*/

TYPE user_param_record IS RECORD (

  username      VARCHAR2(30),
  par_name      VARCHAR2(30),
  par_desc      VARCHAR2(100),
  value         VARCHAR2(500),
  is_default    VARCHAR2(10),
  format        VARCHAR2(20)

);

TYPE user_param_table IS TABLE OF user_param_record INDEX BY BINARY_INTEGER;

-- Get parameter value list for given user
PROCEDURE Get_User_Parameters (
  p_username        VARCHAR2,                   -- username
  r_params          IN OUT user_param_table);   -- results

-- Get default parameter value
FUNCTION Get_Default_Parameter (
  p_par_name        VARCHAR2)       -- parameter name
RETURN VARCHAR2;                    -- value (or NULL)

-- Change a parameter value for given user
FUNCTION Change_User_Parameter (
  p_username        VARCHAR2,       -- username
  p_par_name        VARCHAR2,       -- parameter name
  p_new_value       VARCHAR2)       -- new value
RETURN NUMBER;                      -- 0 ok, otherwise error

-- Get a parameter value for given user
FUNCTION Get_User_Parameter (
  p_username        VARCHAR2,       -- username
  p_par_name        VARCHAR2)       -- parameter name
RETURN VARCHAR2;                    -- parameter value (or NULL)

END;
/

