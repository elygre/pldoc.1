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

/**
* Utilities supporting the main functionality
* @author Albert Tumanov
* @version $Header: /cvsroot/pldoc/sources/src/java/net/sourceforge/pldoc/Utils.java,v 1.3 2004/04/18 18:27:23 altumano Exp $
*/
public class Utils
{

  /** Copies a file.
  * I wish there was a standard Java way to do it.
  */
  public static void CopyFile(File inputFile, File outputFile)
  throws FileNotFoundException, IOException
  {
    FileReader in = new FileReader(inputFile);
    FileWriter out = new FileWriter(outputFile);
    int c;

    while ((c = in.read()) != -1) {
       out.write(c);
    }

    in.close();
    out.close();
  }

  /** Copies a InputStream into a file.
  * I wish there was a standard Java way to do it.
  */
  public static void CopyStreamToFile(InputStream inputStream, File outputFile)
  throws FileNotFoundException, IOException
  {
    InputStreamReader in = new InputStreamReader(inputStream);
    FileWriter out = new FileWriter(outputFile);
    int c;

    while ((c = in.read()) != -1) {
       out.write(c);
    }

    in.close();
    out.close();
  }

}