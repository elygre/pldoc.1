CREATE OR REPLACE
PACKAGE CUSTOMER_DATA
IS
/** 
* Project:         Test Project (<a href="http://pldoc.sourceforge.net">PLDoc</a>)<br/>
* Description:     Customer Data Management<br/>
* DB impact:       YES<br/>
* Commit inside:   NO<br/>
* Rollback inside: NO<br/>
* @headcom
*/

/**
* Record of customer data.
*
* @param id		customer ID
* @param name		customer name
* @param regno		registration number or SSN
* @param language	preferred language
*/
TYPE customer_type IS RECORD (
  id                        VARCHAR2(20),
  name                      VARCHAR2(100),
  regno                     VARCHAR2(50),
  language                  VARCHAR2(10)
);

/** Table of customer records. */
TYPE customer_table IS TABLE OF customer_type INDEX BY BINARY_INTEGER;

/**
* Gets customer by ID.
*
* @param p_id       customer ID
* @param r          record of customer data
* @throws no_data_found if no such customer exists
*/
PROCEDURE get_customer (
  p_id              VARCHAR2,
  customer_rec      OUT customer_type);

/**
* Searches customer by criteria.
*
* @param p_criteria record with assigned search criteria
* @param r_records  table of found customers <b>(may be empty!)</b>
*/
PROCEDURE get_by_criteria (
  p_criteria        customer_type,
  r_records         OUT customer_table);

/**
* Creates a customer record.
*
* @param customer_rec record of customer data
*/
PROCEDURE create_customer (
  customer_rec      customer_type);

/**
* Changes customer data.
*
* @param customer_rec record of updated customer data
*/
PROCEDURE update_customer (
  customer_rec      customer_type);

END;
/

