/* Copyright (C) 2002 Albert Tumanov

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

*/

package net.sourceforge.pldoc;

import java.io.*;
import java.util.*;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMResult;
import net.sourceforge.pldoc.parser.PLSQLParser;
import net.sourceforge.pldoc.parser.ParseException;

// JDBC

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 * PL/SQL documentation generator.
 * <p>
 * @author Albert Tumanov
 * @version $Header: /cvsroot/pldoc/sources/src/java/net/sourceforge/pldoc/PLDoc.java,v 1.15 2009/01/30 22:37:58 zolyfarkas Exp $
 * </p>
 */
public class PLDoc
{
  // The exception is used when system exit is desired but "finally" clause need also to be run.
  private static class SystemExitException extends RuntimeException {
  }

  private static final String lineSeparator = System.getProperty("line.separator");
  private static String programName = "PLDoc version: " + Version.id();

  // Helper object for retrieving resources relative to the installation.
  public static final ResourceLoader resLoader = new ResourceLoader();

  // Runtime settings
  public Settings settings;

  /**
  * Constructor.
  */
  public PLDoc(Settings settings)
  {
    this.settings = settings;
  }

  /** All processing is via the main method */
  public static void main(String[] args) throws Exception
  {
    long startTime = System.currentTimeMillis();
    System.out.println("");
    System.out.println(programName);

    // process arguments
    Settings settings = new Settings();
    settings.processCommandString(args);
    PLDoc pldoc = new PLDoc(settings);

    // start running
    try {
      pldoc.run();
    } catch (SystemExitException e) {
      System.exit(-1);
    }

    long finishTime = System.currentTimeMillis();
    System.out.println("Done (" + (finishTime-startTime)/1000.00 + " seconds).");
  }

  /**
  * Runs pldoc using the specified settings.
  */
  public void run() throws Exception
  {
    // if the output directory do not exist, create it
    if (!settings.getOutputDirectory().exists()) {
      System.out.println("Directory \"" + settings.getOutputDirectory() + "\" does not exist, creating ...");
      settings.getOutputDirectory().mkdir();
    }

    // open the output file (named application.xml)
    File applicationFile = new File(
      settings.getOutputDirectory().getPath() + File.separator + "application.xml");
    OutputStream output = null;
    try {
      output = new FileOutputStream(applicationFile);
      XMLWriter xmlOut = new XMLWriter(output);
      xmlOut.setMethod("xml");
      if (settings.getOutputEncoding() != null)
        xmlOut.setEncoding(settings.getOutputEncoding());
      xmlOut.setIndent(true);
      xmlOut.setDocType(null, "application.dtd");
      xmlOut.startDocument();
      xmlOut.pushAttribute("NAME", settings.getApplicationName());
      xmlOut.startElement("APPLICATION");

      // read overview file content
      if (settings.getOverviewFile() != null) {
        // overview of the application
        xmlOut.startElement("OVERVIEW");
        xmlOut.cdata(getOverviewFileContent(settings.getOverviewFile()));
        xmlOut.endElement("OVERVIEW");
      }

      // for all the input files
      Iterator it = settings.getInputFiles().iterator();
      while (it.hasNext()) {
        String inputFileName = (String) it.next();

        // open the input file
        System.out.println("Parsing file " + inputFileName + " ...");

	try {
          processPackage(
            new BufferedReader(
              new InputStreamReader(
                new FileInputStream(inputFileName), settings.getInputEncoding())
	      ),
              xmlOut
          );
        } catch(FileNotFoundException e) {
          System.err.println("File not found: " + inputFileName);
          throw new SystemExitException();
        } catch(ParseException e) {
          System.err.println("File " + inputFileName + " skipped.");
        }
      } // for all the input files.



      // for all the specified packages from the dictionary
      if ( settings.getDbUrl() != null && settings.getDbUser() != null && settings.getDbPassword() != null ) {
        // Load the Oracle JDBC driver class.
        // DriverManager.registerDriver(new OracleDriver());
	Class.forName("oracle.jdbc.driver.OracleDriver");

        Connection conn = null;
	PreparedStatement pstmt = null;

        try {
          conn = DriverManager.getConnection( settings.getDbUrl(), settings.getDbUser(), settings.getDbPassword() );
	  pstmt = conn.prepareStatement("SELECT  object_name "+
                                        ",       object_type "+
                                        "FROM    all_objects "+
                                        "WHERE   owner = ? "+
                                        "AND     object_name LIKE ?"+
                                        "AND     object_type in ('PACKAGE', 'TABLE', 'VIEW')"+
                                        "ORDER BY "+
                                        "        object_name");

          DbmsMetadata dbmsMetadata = new DbmsMetadata(conn);

          it = settings.getInputObjects().iterator();
          while (it.hasNext()) {
            String input[] = ((String) it.next()).split("\\."); /* [ SCHEMA . ] PACKAGE */

	    if ( input.length == 0 || input.length > 2 ) {
		continue;
	    }

            String inputSchemaName = ( input.length == 2 ? input[0] : settings.getDbUser() );
            String inputObjectName = ( input.length == 2 ? input[1] : input[0] );

            // get the package name(s)
	    ResultSet rset = null;

	    try {
		pstmt.setString(1, inputSchemaName);
		pstmt.setString(2, inputObjectName);

		rset = pstmt.executeQuery();
		
		// If the object is not present return false
		if (!rset.next()) {
		    // package does not exist

		    System.err.println("Object(s) like " + inputSchemaName + "." + inputObjectName + " do not exist or " + settings.getDbUser() + " does not have enough permissions (SELECT_CATALOG_ROLE role).");
		} else {
		    do {
			System.out.println("Parsing package specification name " + inputSchemaName + "." + rset.getString(1) + " ...");

			try {
			    processPackage(
                              new BufferedReader(
                                dbmsMetadata.getDdl((rset.getString(2).equals("PACKAGE") ? "PACKAGE_SPEC" : rset.getString(2)), 
						    rset.getString(1), 
						    inputSchemaName, 
						    "COMPATIBLE", 
						    "ORACLE", 
						    "DDL").getCharacterStream()), 
			      xmlOut
			    );
			} catch(ParseException e) {
			    System.err.println("Object " + inputSchemaName + "." + rset.getString(1) + " skipped.");
			}
		    } while (rset.next());
		}
	    } finally  {
		if( rset != null ) rset.close();
	    }
	  }
	} finally {
	    if( pstmt != null ) pstmt.close();
	    if ( conn != null ) conn.close();
	}
      } // for all the specified packages from the dictionary


      xmlOut.endElement("APPLICATION");
      xmlOut.endDocument();
    } catch(FileNotFoundException e) {
      System.err.println("File cannot be created: " + applicationFile);
      e.printStackTrace();
      throw new SystemExitException();
    } finally {
      if(output != null) {
        output.close();
      }
    }


    // copy required static files into the output directory
    copyStaticFiles(settings.getOutputDirectory());

    // generate HTML files from the applicationFile
    generateHtml(applicationFile);
  }

  /**
  * Processes a package.
  *
  * @param packageSpec  Package specification to parse
  * @param xmlOut       XML writer
  */

  private void processPackage(BufferedReader packageSpec, XMLWriter xmlOut) 
      throws net.sourceforge.pldoc.parser.ParseException, java.io.IOException, org.xml.sax.SAXException, java.lang.Exception
  {
    SubstitutionReader input = null;
    try {
      input = new SubstitutionReader(packageSpec, settings.getDefines());

      // parse the input file
      PLSQLParser parser = new PLSQLParser(input);

      // start writing new XML for the input file
      XMLWriter outXML = new XMLWriter();
      outXML.startDocument();
      outXML.startElement("FILE");

      // set parser params
      parser.setXMLWriter(outXML);
      parser.setIgnoreInformalComments(settings.isIgnoreInformalComments());
      parser.setNamesUppercase(settings.isNamesUppercase());
      parser.setNamesLowercase(settings.isNamesLowercase());

      // run parser
      parser.input();

      outXML.endElement("FILE");
      outXML.endDocument();

      // file parsed successfully
      // append all nodes below FILE to the main XML
      xmlOut.appendNodeChildren(outXML.getDocument().getDocumentElement());

    } catch(ParseException e) {
      System.err.println("Error parsing line " + e.currentToken.next.beginLine +
        ", column " + e.currentToken.next.beginColumn);
      System.err.println("Last consumed token: \"" + e.currentToken + "\"");
      e.printStackTrace();
      // exit with error only if specifically required by user
      if (settings.isExitOnError()) {
        throw new SystemExitException();
      } else {
	throw e;
      }
    } finally {
      if(input != null) {
        input.close();
      }
    }
  }

  /**
  * Reads the text from the overview file.
  *
  * @param overviewFile  The overview file to read from
  */
  private String getOverviewFileContent(File overviewFile) throws IOException {
    StringBuffer overview = new StringBuffer("");

    try {
      BufferedReader overviewReader =
        new BufferedReader(
          new InputStreamReader(
            new FileInputStream(settings.getOverviewFile()),
            settings.getInputEncoding())
        );
      String line = null;
      while ((line = overviewReader.readLine()) != null) {
        overview.append(line);
        overview.append(lineSeparator);
      }
      overviewReader.close();
    } catch(FileNotFoundException e) {
      System.err.println("File not found: " + settings.getOverviewFile());
      throw e;
    } catch(UnsupportedEncodingException e) {
      throw new IOException(e.toString());
    }

    // extract the text between <BODY> and </BODY>
    int start = overview.toString().toUpperCase().lastIndexOf("<BODY>");
    if (start != -1)
      overview.delete(0, start + 6);
    int end = overview.toString().toUpperCase().indexOf("</BODY>");
    if (end != -1)
      overview.delete(end, overview.length());

    return overview.toString();
  }


  /**
  * Generates HTML files from the provided XML file.
  *
  * @param applicationFile  XML application file
  */
  private void generateHtml(File applicationFile) throws Exception {
    // apply xsl to generate the HTML frames
    System.out.println("Generating HTML files ...");
    TransformerFactory tFactory = TransformerFactory.newInstance();
    Transformer transformer;
    // list of schemas
    System.out.println("Generating allschemas.html ...");
    transformer = tFactory.newTransformer(new StreamSource(
      resLoader.getResourceStream("resources/allschemas.xsl")));
    transformer.transform(new StreamSource(applicationFile),
      new StreamResult(new FileOutputStream(
        settings.getOutputDirectory().getPath() + File.separator + "allschemas.html")));
    // summary
    System.out.println("Generating summary.html ...");
    transformer = tFactory.newTransformer(new StreamSource(
      resLoader.getResourceStream("resources/summary.xsl")));
    transformer.transform(new StreamSource(applicationFile),
      new StreamResult(new FileOutputStream(
        settings.getOutputDirectory().getPath() + File.separator + "summary.html")));
    // list of packages
    System.out.println("Generating allpackages.html ...");
    transformer = tFactory.newTransformer(new StreamSource(
      resLoader.getResourceStream("resources/allpackages.xsl")));
    transformer.transform(new StreamSource(applicationFile),
      new StreamResult(new FileOutputStream(
        settings.getOutputDirectory().getPath() + File.separator + "allpackages.html")));
    // index
    System.out.println("Generating index.html ...");
    transformer = tFactory.newTransformer(new StreamSource(
      resLoader.getResourceStream("resources/index.xsl")));
    transformer.transform(new StreamSource(applicationFile),
      new StreamResult(new FileOutputStream(
        settings.getOutputDirectory().getPath() + File.separator + "index.html")));
    // description for each package; the DOMResult is actually ignored
    System.out.println("Generating <unit>.html ...");
    transformer = tFactory.newTransformer(new StreamSource(
      resLoader.getResourceStream("resources/unit.xsl")));
    transformer.transform(new StreamSource(applicationFile), new DOMResult());
  }


  /**
  * Copies required static files into the output directory.
  *
  * @param outputDirectory  
  */
  private void copyStaticFiles(File outputDirectory) throws Exception {
    try {
      // copy the stylesheet
      Utils.CopyStreamToFile(
        settings.getStylesheetFile(),
        new File(outputDirectory.getPath() + File.separator + "stylesheet.css"));
      // copy the DTD
      Utils.CopyStreamToFile(
        resLoader.getResourceStream("resources/application.dtd"),
        new File(outputDirectory.getPath() + File.separator + "application.dtd"));
    } catch(FileNotFoundException e) {
      System.err.println("File not found. ");
      e.printStackTrace();
      throw e;
    }
  }
}
