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

/** Represents all settings for the program.
* Setting values may be received from command line options and/or defaulted.
* This class should not have side effects.
* @author Albert Tumanov
* @version $Header: /cvsroot/pldoc/sources/src/java/net/sourceforge/pldoc/Settings.java,v 1.7 2005/11/29 08:25:00 gpaulissen Exp $
*/
public class Settings
{
  // settings and their defaults
  private String applicationName = "MyApplication";
  private File outputDirectory = new File("." + File.separator);
  private Collection inputFiles = new ArrayList();
  private String stylesheetfile = null;
  private File overviewfile = null;
  private Properties defines = null;
  private boolean ignoreInformalComments = false;
  private boolean namesUppercase = false;
  private boolean namesLowercase = false;
  // by default, assume system default encoding for all input files
  private String inputEncoding = System.getProperty("file.encoding");
  // we cannot yet set output encoding dynamically, because of XSLs
  private String outputEncoding = "UTF-8";
  private boolean exitOnError = false;
  private String dbUrl = null;
  private String dbUser = null;
  private String dbPassword = null;
  private Collection inputObjects = new ArrayList();

  private static final String usage =
    "Arguments: [options] inputfile(s)\n" +
    "-d <directory>            Destination directory for output files [default: current]\n" +
    "-doctitle <text>          Application name [default: MyApplication]\n" +
    "-overview <file>          Read overview documentation from HTML file [default: none]\n" +
    "-namesuppercase           To convert all names to uppercase\n" +
    "-nameslowercase           To convert all names to lowercase\n" +
    "-stylesheetfile <path>    File to change style of the generated document [default: defaultstylesheet.css]\n" +
    "-definesfile <path>       File containing SQL*Plus-style variable substitutions [default: none], for example:\n" +
    "                          &myvar1=123456\n" +
    "                          &myvar2=abcdef\n" +
    "-inputencoding <enc>      Encoding used in the input files [default: operation system default encoding]\n" +
    "-exitonerror              Forces program exit when some input file cannot be processed\n" +
    "                          [by default, the file is skipped and processing continues]\n" +
    "-url <database url>       Database url, for example jdbc:oracle:thin:@HOST:PORT:SID.\n" + 
    "                          Required when generating from the Oracle dictionary.\n" +
    "-user <db schema>         Schema name.\n" +
    "                          Required when generating from the Oracle dictionary. The schema name is\n" +
    "                          case sensitive since Oracle stores schema names like \"My schema\" (name with\n" +
    "                          double quotes) as 'My schema' in the dictionary. Ordinary schema names\n" +
    "                          like scott are stored as 'SCOTT' (upper case).\n" +
    "-password <db password>   Password of the schema.\n" +
    "                          Required when generating from the Oracle dictionary.\n" +
    "-sql <object name(s)>     Comma separated list of object name(s) to generate documentation for.\n" +
    "                          Required when generating from the Oracle dictionary.\n" +
    "                          An object name is case sensitive (the same rules as described for schema\n" +
    "                          names apply).\n" +
    "                          An object name may be prepended by a schema name and may have SQL\n" +
    "                          wildcards.\n" +
    "                          When the object belongs to a different schema than the logon user (as specified by\n" +
      "                          the -user parameter), the logon user must have been granted the role SELECT_CATALOG_ROLE.\n";
//    "                          &myvar2=abcdef\n" +
//    "-ignoreinformalcomments   To ignore informal comments";

  /** Consumes command line strings received by the main() method */
  public void processCommandString(String args[]) throws Exception
  {
    if (args.length < 1) {
      System.out.println(usage);
      System.exit(0);
    }

    // Re-parse the argument string, to recognize strings with spaces inside.
    // list of arguments:
    ArrayList argumentList = new ArrayList();

    // concatenate all the arguments
    StringBuffer arguments = new StringBuffer();
    for(int i = 0; i < args.length; i++) {
      if(i > 0) {
        arguments.append(' ');
      }
      arguments.append(args[i]);
    }

    // parse into the argument list
    StreamTokenizer st = new StreamTokenizer(new StringReader(arguments.toString()));
    // reset syntax, because we do not want to parse numbers
    st.resetSyntax();
    // whitespace is space, tabs, and all symbols in between
    st.whitespaceChars('\t', ' ');
    // words consists of all possible characters above the space character
    st.wordChars(' ' + 1, '\u00FF');
    // two types of quote
    st.quoteChar('"');
    st.quoteChar('\'');
    while(st.nextToken() != StreamTokenizer.TT_EOF) {
      switch(st.ttype) {
        case StreamTokenizer.TT_WORD:
        case '"':
        case '\'':
          argumentList.add(st.sval);
        default:
          ; // ignore
      }
    }

    // process the argument list "semantically"
    Iterator it = argumentList.iterator();
    while(it.hasNext()) {
      String arg = (String) it.next();

      if (arg.equalsIgnoreCase("-doctitle")) {
        // consume  "-doctitle"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        applicationName = (String) it.next();
      }
      else if (arg.equalsIgnoreCase("-d")) {
        // consume  "-d"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        outputDirectory = new File((String) it.next() + File.separator);
        if (outputDirectory.isFile()) {
          processInvalidUsage("File name given instead of the output directory !");
        }
      }
      else if (arg.equalsIgnoreCase("-overview")) {
        // consume  "-overview"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        overviewfile = new File((String) it.next());
        if (!overviewfile.exists()) {
          processInvalidUsage("The specified overview file " + overviewfile + " does not exist !");
        }
      }
      else if (arg.equalsIgnoreCase("-stylesheetfile")) {
        // consume  "-stylesheetfile"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        stylesheetfile = (String) it.next();
        // check the file
        if (!(new File(stylesheetfile).exists())) {
          processInvalidUsage("The specified stylesheet file " + stylesheetfile + " does not exist !");
        }
      }
      else if (arg.equalsIgnoreCase("-definesfile")) {
        // consume  "-definesfile"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        File definesfile = new File((String) it.next());
        if (!definesfile.exists()) {
          processInvalidUsage("The specified defines file " + definesfile + " does not exist !");
        }
        defines = new Properties();
        defines.load(new FileInputStream(definesfile));
      }
      else if (arg.equalsIgnoreCase("-ignoreinformalcomments")) {
        // consume  "-ignoreinformalcomments"
        this.ignoreInformalComments = true;
      }
      else if (arg.equalsIgnoreCase("-namesuppercase")) {
        // consume  "-namesuppercase"
        this.namesUppercase = true;
      }
      else if (arg.equalsIgnoreCase("-nameslowercase")) {
        // consume  "-nameslowercase"
        this.namesLowercase = true;
      }
      else if (arg.equalsIgnoreCase("-inputencoding")) {
        // consume  "-inputencoding"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        this.inputEncoding = (String) it.next();
      }
      else if (arg.equalsIgnoreCase("-exitonerror")) {
        // consume  "-exitonerror"
        this.exitOnError = true;
      }
      else if (arg.equalsIgnoreCase("-url")) {
        // consume  "-url"
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        this.dbUrl = (String) it.next();
      }
      else if (arg.equalsIgnoreCase("-user")) {
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        this.dbUser = (String) it.next();
      }
      else if (arg.equalsIgnoreCase("-password")) {
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
        this.dbPassword = (String) it.next();
      }
      else if (arg.equalsIgnoreCase("-sql")) {
        if(!it.hasNext()) {
          processInvalidUsage("Option " + arg + " requires a value !");
        }
	String inputObjectsList = (String)it.next();
        inputObjects = Arrays.asList(inputObjectsList.split(","));
      }
      else if (arg.startsWith("-")) {
        processInvalidUsage("Unknown option " + arg);
      } else {
        // no option code recognized - assume it's a file name
        inputFiles.add(arg);
      }

    }

    // the input file(s) OR object name(s) MUST be given
    if ((inputFiles.isEmpty() && inputObjects.isEmpty()) ||
        (!inputFiles.isEmpty() && !inputObjects.isEmpty())) {
      processInvalidUsage("Either input file name(s) or object name(s) must be given!");
    }

    // When object name(s) are supplied, the connect info must be supplied.
    if (!inputObjects.isEmpty() && 
	(this.dbUrl == null || this.dbUser == null || this.dbPassword == null)) {
      processInvalidUsage("Database url, db schema and db password are mandatory when object name(s) are supplied!");
    }
  }

  public void setApplicationName(String applicationName) {
          this.applicationName = applicationName;
  }
  public void setOutputDirectory(File outputDirectory) {
          this.outputDirectory = outputDirectory;
  }
  public void setInputFiles(Collection inputFiles) {
          this.inputFiles = inputFiles;
  }
  public void setStylesheetfile(String stylesheetfile) {
          this.stylesheetfile = stylesheetfile;
  }
  public void setOverviewfile(File overviewfile) {
          this.overviewfile = overviewfile;
  }
  public void setDefines(Properties defines) {
          this.defines = defines;
  }
  public void setIgnoreInformalComments(boolean ignoreInformalComments) {
          this.ignoreInformalComments = ignoreInformalComments;
  }
  public void setNamesUppercase(boolean namesUppercase) {
          this.namesUppercase = namesUppercase;
  }
  public void setNamesLowercase(boolean namesLowercase) {
          this.namesLowercase = namesLowercase;
  }
  public void setInputEncoding(String inputEncoding) {
          this.inputEncoding = inputEncoding;
  }
  public void setExitOnError(boolean exitOnError) {
          this.exitOnError = exitOnError;
  }
  public void setDbUrl(String dbUrl) {
          this.dbUrl = dbUrl;
  }
  public void setDbUser(String dbUser) {
          this.dbUser = dbUser;
  }
  public void setDbPassword(String dbPassword) {
          this.dbPassword = dbPassword;
  }
  public void setInputObjects(Collection inputObjects) {
          this.inputObjects = inputObjects;
  }


  public String getApplicationName() {
    return applicationName;
  }

  public File getOutputDirectory() {
    return outputDirectory;
  }

  public Collection getInputFiles() {
    return inputFiles;
  }

  public InputStream getStylesheetFile() throws IOException {
    // if some custom stylesheet was given, use it
    if (stylesheetfile != null && stylesheetfile.length() > 0) {
      return new FileInputStream(stylesheetfile);
    }
    // return default
    return ((new ResourceLoader()).getResourceStream("resources/defaultstylesheet.css"));
  }

  public File getOverviewFile() {
    return overviewfile;
  }

  public Properties getDefines() {
    return defines;
  }

  public boolean isIgnoreInformalComments() {
    return ignoreInformalComments;
  }

  public boolean isNamesUppercase() {
    return namesUppercase;
  }

  public boolean isNamesLowercase() {
    return namesLowercase;
  }

  public String getInputEncoding() {
    return inputEncoding;
  }

  public String getOutputEncoding() {
    return outputEncoding;
  }

  public boolean isExitOnError() {
    return exitOnError;
  }

  public String getDbUrl() {
    return dbUrl;
  }

  public String getDbUser() {
    return dbUser;
  }

  public String getDbPassword() {
    return dbPassword;
  }

  public Collection getInputObjects() {
    return inputObjects;
  }

  /** Processes invalid usage: prints the error message and the usage instruction
  * and halts.
  */
  private void processInvalidUsage(String message) {
    System.out.println("Error: " + message);
    System.out.println(usage);
    System.exit(0);
  }

}

