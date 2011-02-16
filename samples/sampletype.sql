CREATE OR REPLACE TYPE object_type AS OBJECT (
	/** The ID of the object */
    value_id           	NUMBER
	
	/** The name of the object */
	value_name			VARCHAR2 (2),
	
	/** A guid, for whatever purpose */
	value_guid			RAW(32),
	
	/**
	 * The date the object was last imagined.
	 *
	 * This is a strange property, but still 
	 * very useful. It contains the date of
	 * the last time anyone imagined having
	 * the date of the last time anyone
	 * imagined having the date of the last
	 * time... etc ad infinitum
	*/
	value_date			date,

	/** A string representation */
	member function to_string return varchar2 cascade,
	
	/** a map member */
	map member function get_ident return varchar2
)
/

/**
 * This is a table of the real stuff
 */
CREATE OR REPLACE TYPE table_type AS TABLE OF PORTLET_PREFS_PARAM_TYPE
/

/**
 * This is a table of the real stuff
 */
CREATE OR REPLACE TYPE varray_type AS VARRAY(100) OF PORTLET_PREFS_PARAM_TYPE
/

create type finaltype as object (
	id number
) final
/

create type supertype as object (
	id number
) not final
/

create type subtype under supertype (
    extra clob
) final
/