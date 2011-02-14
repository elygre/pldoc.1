package net.sourceforge.pldoc.ant;

import org.apache.tools.ant.*;
import org.apache.tools.ant.types.*;

import java.io.*;
import java.util.ArrayList;
import java.util.Properties;

import net.sourceforge.pldoc.*;
import net.sourceforge.pldoc.parser.*;

import org.w3c.dom.Document;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMResult;

/**
 * PLDoc Ant Task
 * <p>To define task in project:</p>
 * <pre>
 *   &lt;taskdef
 *     name="pldoc"
 *     classname="net.sourceforge.pldoc.ant.PLDocTask"
 *     classpath="pldoc.jar" /&gt;
 * </pre>
 *
 * <p>To use:</p>
 * <pre>
 *   &lt;pldoc
 *     verbose = "yes" | "no" (default: "no")
 *     doctitle = text
 *     destdir = dir-path
 *     overview = file-path
 *     stylesheet = file-path (default: stylesheet from library)
 *     namesCase = "upper" | "lower"
 *     inputEncoding = encoding (default: OS dependant) &gt;
 *     &lt;!-- fileset+ --&gt;
 *   &lt;/pldoc&gt;
 * </pre>
 * <p>Where:</p>
 * <dl>
 *  <dt>doctitle</dt><dd>Documentation title</dd>
 *  <dt>destdir</dt><dd>Directory to store documentation files (created if doesn't exist)</dd>
 *  <dt>overview</dt><dd>File with overview in HTML format</dd>
 *  <dt>stylesheet</dt><dd>File with CSS-stylesheet for the result documentation. If omitted, default CSS will be used.</dd>
 *  <dt>namesCase</dt><dd>Upper/lower case to format PL/SQL names. If omitted, no case conversion is done.</dd>
 *  <dt>inputEncoding</dt><dd>Input files encoding</dd>
 *  <dt>fileset</dt><dd>Specifies files to be parsed. See <a href="http://ant.apache.org/manual/CoreTypes/fileset.html">Ant FileSet</a> for more details.</dd>
 * </dl>
 */
public class PLDocTask extends Task {
  private Settings settings;
  private boolean m_verbose;
  private File m_destdir;
  private String m_doctitle;
  private File m_overviewFile;
  private ArrayList m_filesets;
  private File m_stylesheet;
  private char m_namesCase;
  private String m_inEnc;
  private boolean m_exitOnError;

  public PLDocTask() {
    m_verbose = false;
    m_destdir = null;
    m_doctitle = null;
    m_overviewFile = null;
    m_filesets = new ArrayList();
    m_stylesheet = null;
    m_namesCase = '0';
    m_inEnc = null;
    m_exitOnError = false;
  }

  public void setVerbose(boolean verbose) {
    m_verbose = verbose;
  }
  public void setDestdir(File dir) {
    m_destdir = dir;
  }
  public void setDoctitle(String doctitle) {
    m_doctitle = doctitle;
  }
  public void setOverview(File file) {
    m_overviewFile = file;
  }
  public void addFileset(FileSet fset) {
    m_filesets.add(fset);
  }
  public void setStylesheet(File file) {
    m_stylesheet = file;
  }
  public void setInputEncoding(String enc) {
    m_inEnc = enc;
  }
  public void setExitOnError(boolean exitOnError) {
    m_exitOnError = exitOnError;
  }

  public static class NamesCase extends EnumeratedAttribute {
    public String[] getValues() {
      return new String[] {"upper", "lower"};
    }
  }
  public void setNamesCase(NamesCase namesCase) {
    m_namesCase = Character.toUpperCase(namesCase.getValue().charAt(0));
  }

  public void execute()
      throws BuildException {
    // check args
    if (m_destdir == null)
      throw new BuildException("Property \"destdir\" (destination directory) MUST be specified");
    if (!m_destdir.exists())
      m_destdir.mkdirs();

    if (m_doctitle == null)
      m_doctitle = "PL/SQL";

    if (m_inEnc == null)
      m_inEnc = System.getProperty("file.encoding");

    // execute

    try {
      settings = new Settings();
      settings.setApplicationName(m_doctitle);
      switch (m_namesCase) {
        case 'U':
          settings.setNamesUppercase(true);
          break;
        case 'L':
          settings.setNamesLowercase(true);
          break;
      }
      settings.setInputEncoding(m_inEnc);
      settings.setExitOnError(m_exitOnError);

      // open the output file (named application.xml)
      File appFile = new File(m_destdir, "application.xml");
      OutputStream appStream = new FileOutputStream(appFile);
      try {
        XMLWriter appXML = new XMLWriter(appStream);
        appXML.setMethod("xml");
        appXML.setIndent(true);
        appXML.setDocType(null, "application.dtd");

        appXML.startDocument();
        appXML.pushAttribute("NAME", m_doctitle);
        appXML.startElement("APPLICATION");

        // read overview file content
        if (m_overviewFile != null) {
          if (m_verbose)
            log("Processing overview file " + m_overviewFile.getAbsolutePath() + " ...");
          StringBuffer overviewBuf = new StringBuffer();
          BufferedReader overviewReader = getInputReader(m_overviewFile);
          try {
            String line = null;
            while ((line = overviewReader.readLine()) != null) {
              overviewBuf.append(line);
              overviewBuf.append("\n");
            }
          } finally {
            overviewReader.close();
          }
          String overviewUpper = overviewBuf.toString().toUpperCase();

          // extract the text between <BODY> and </BODY>
          int end = overviewUpper.indexOf("</BODY>");
          if (end != -1)
            overviewBuf.delete(end, overviewBuf.length());
          int start = overviewUpper.lastIndexOf("<BODY>");
          if (start != -1)
            overviewBuf.delete(0, start + 6);

          // overview of the application
          appXML.startElement("OVERVIEW");
          appXML.cdata(overviewBuf.toString());
          appXML.endElement("OVERVIEW");
        }

        // for all the input files
        for (int fsetI = 0; fsetI < m_filesets.size(); fsetI++) {
          FileSet fset = (FileSet) m_filesets.get(fsetI);
          DirectoryScanner dirScan = fset.getDirectoryScanner(getProject());
          File srcDir = fset.getDir(getProject());
          String[] srcFiles = dirScan.getIncludedFiles();
          Properties subst = new Properties();
          for (int fileI = 0; fileI < srcFiles.length; fileI++) {
            File inputFile = new File(srcDir, srcFiles[fileI]);
            if (m_verbose)
              log("Parsing file " + inputFile.getAbsolutePath() + " ...");

            // create separate Document for each file
            // (if parsing fails, we can throw away the file's Document and continue with the next file)
            XMLWriter outXML = null;
            try {              
              SubstitutionReader input =
                  new SubstitutionReader(getInputReader(inputFile), subst);
              try {
                // parse the input file
                outXML = new XMLWriter();
                outXML.startDocument();
                outXML.startElement("FILE");

                PLSQLParser parser = new PLSQLParser(input);
                parser.setXMLWriter(outXML);
                parser.setIgnoreInformalComments(settings.isIgnoreInformalComments());
                parser.setNamesUppercase(settings.isNamesUppercase());
                parser.setNamesLowercase(settings.isNamesLowercase());
                parser.input();

              } finally {
                outXML.endElementRecursive("FILE");
                outXML.endDocument();
                input.close();
              }

              // file parsed successfully
              // append all nodes below FILE to the main XML
              appXML.appendNodeChildren( outXML.getDocument().getDocumentElement());
            } catch (ParseException e) {
              log("Failed to parse file: " + inputFile.getAbsolutePath() + ": " + e, Project.MSG_ERR);
              // exit with error only if specifically required by user
              if (settings.isExitOnError()) {
                throw new BuildException("Error parsing file " + inputFile);
              } else {
                System.err.println("File " + inputFile + " Partially parsed ");
                System.err.println("Parsing halted due to: " + e.getMessage() );
                if (outXML != null && outXML.getDocument() != null && outXML.getDocument().getDocumentElement() != null)
                    appXML.appendNodeChildren(outXML.getDocument().getDocumentElement());
              }
            }
          }
        }

        appXML.endElement("APPLICATION");
        appXML.endDocument();
      } finally {
        appStream.close();
      }

      // copy necessary files into the output directory
      ResourceLoader resLoader = new ResourceLoader();

      // copy the stylesheet
      File stylesheetFile = new File(m_destdir, "stylesheet.css");
      if (m_stylesheet != null) {
        Utils.CopyFile(m_stylesheet, stylesheetFile);
      } else {
        resLoader.saveResourceToFile("resources/defaultstylesheet.css", stylesheetFile);
      }

      // copy the DTD
      File dtdFile = new File(m_destdir, "application.dtd");
      resLoader.saveResourceToFile("resources/application.dtd", dtdFile);

      // apply xsl to generate the HTML frames
      if (m_verbose)
        log("Generating HTML files ...");
      TransformerFactory tFactory = TransformerFactory.newInstance();

      // summary
      if (m_verbose)
        log("Generating summary.html ...");
      {
        InputStream inStream =
            resLoader.getResourceStream("resources/summary.xsl");
        try {
          Transformer transformer =
              tFactory.newTransformer(new StreamSource(inStream));
          File resFile = new File(m_destdir, "summary.html");
          transformer.transform(
              new StreamSource(appFile),
              new StreamResult(new FileOutputStream(resFile)));
        } finally {
          inStream.close();
        }
      }

      // schemas
      if (m_verbose)
        log("Generating allschemas.html ...");
      {
        InputStream inStream =
            resLoader.getResourceStream("resources/allschemas.xsl");
        try {
          Transformer transformer =
              tFactory.newTransformer(new StreamSource(inStream));
          File resFile = new File(m_destdir, "allschemas.html");
          transformer.transform(
              new StreamSource(appFile),
              new StreamResult(new FileOutputStream(resFile)));
        } finally {
          inStream.close();
        }
      }
      
      // list of packages
      if (m_verbose)
        log("Generating allpackages.html ...");
      {
        InputStream inStream =
            resLoader.getResourceStream("resources/allpackages.xsl");
        try {
          Transformer transformer =
              tFactory.newTransformer(new StreamSource(inStream));
          File resFile = new File(m_destdir, "allpackages.html");
          transformer.transform(
              new StreamSource(appFile),
              new StreamResult(new FileOutputStream(resFile)));
        } finally {
          inStream.close();
        }
      }

      // index
      if (m_verbose)
        log("Generating index.html ...");
      {
        InputStream inStream = resLoader.getResourceStream("resources/index.xsl");
        try {
          Transformer transformer =
              tFactory.newTransformer(new StreamSource(inStream));
          File resFile = new File(m_destdir, "index.html");
          transformer.transform(
              new StreamSource(appFile),
              new StreamResult(new FileOutputStream(resFile)));
        } finally {
          inStream.close();
        }
      }

      // description for each package; the DOMResult is actually ignored
      if (m_verbose)
        log("Generating <unit>.html ...");
      {
        InputStream inStream = resLoader.getResourceStream("resources/unit.xsl");
        try {
          Transformer transformer = tFactory.newTransformer(new StreamSource(inStream));
          transformer.setParameter("targetFolder", m_destdir.toString() + "/");
          transformer.transform(new StreamSource(appFile), new DOMResult());
        } finally {
          inStream.close();
        }
      }
    } catch (java.io.IOException ioEx) {
      throw new BuildException(ioEx);
    } catch (Exception otherEx) {
      throw new BuildException(otherEx);
    }

    m_verbose = false;
    m_destdir = null;
    m_doctitle = null;
    m_overviewFile = null;
    m_stylesheet = null;
    m_namesCase = '0';
    m_inEnc = null;
  }
  private BufferedReader getInputReader(File file)
      throws java.io.IOException {
    return new BufferedReader(
        new InputStreamReader(new FileInputStream(file), m_inEnc));
  }
}
