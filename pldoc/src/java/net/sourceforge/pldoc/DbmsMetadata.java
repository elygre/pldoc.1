package net.sourceforge.pldoc;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.Clob;

public class DbmsMetadata
{

  /* connection management */
  protected Connection conn = null;
  public Connection getConnection() throws SQLException
  { return conn; }

  /* constructors */
  public DbmsMetadata(Connection c) throws SQLException
  { conn = c; }

  public Clob getDdl (
    String objectType,
    String name,
    String schema,
    String version,
    String model,
    String transform)
  throws SQLException
  {
    Clob result;

//  ************************************************************
//  #sql [getConnectionContext()] result = { VALUES(DBMS_METADATA.GET_DDL(
//        :objectType,
//        :name,
//        :schema,
//        :version,
//        :model,
//        :transform))  };
//  ************************************************************

    // declare temps
    CallableStatement st = null;
    String theSqlTS = "BEGIN" +
	              "  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);" +
	              "  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'CONSTRAINTS', FALSE);" +
                      "  :1 := DBMS_METADATA.GET_DDL(\n       :2 ,\n       :3 ,\n       :4 ,\n       :5 ,\n       :6 ,\n       :7 )  \n;" +
                      "END;";
    st = getConnection().prepareCall(theSqlTS);
    st.registerOutParameter(1, java.sql.Types.CLOB);
    // set IN parameters
    st.setString(2, objectType);
    st.setString(3, name);
    st.setString(4, schema);
    st.setString(5, version);
    st.setString(6, model);
    st.setString(7, transform);
    // execute statement
    st.executeUpdate();
    // retrieve OUT parameters
    result = st.getClob(1);

    return result;
  }
}
