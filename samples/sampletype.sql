-- Prompt Type PORTLET_PREFS_PARAM_TYPE;
CREATE OR REPLACE TYPE PORTLET_PREFS_PARAM_TYPE AS OBJECT (
      value_id           VARCHAR2 (50),
      value_type         VARCHAR2 (2),
      VALUE              VARCHAR2 (1000),
      value_cond         VARCHAR2 (20),
      dyn_pref_id        NUMBER,
      value_guid         VARCHAR2 (50),
      attribute_guid     VARCHAR2 (50),
      param_type         VARCHAR2 (1),
      dynamic_param_id   NUMBER,
      sql_condition      VARCHAR2(30000),
      
      /**
       * The dynamic attribute id, very strange stuff.
       * Remember that this can be used time and time again.
       */
      dyn_attribute_id   varchar2(40),
      dyn_param_condition varchar2(10),
      datatype           varchar2(10),
      alias_name         varchar2(100),
      attribute_type     varchar2(100),
      where_clause       varchar2(200),
      guid_values        varchar2(10000)
)
/

/**
 * This is a table of the real stuff
 */
CREATE OR REPLACE TYPE PORTLET_PREFS_PARAM_TYPES AS TABLE OF PORTLET_PREFS_PARAM_TYPE
/