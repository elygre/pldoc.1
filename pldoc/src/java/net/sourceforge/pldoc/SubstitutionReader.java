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

import java.io.Reader;
import java.io.BufferedReader;
import java.io.FilterReader;
import java.io.StringReader;
import java.util.Enumeration;
import java.util.Properties;

/**
 * PL/SQL documentation generator.<P>
 * @author Albert Tumanov
 * @version $Header: /cvsroot/pldoc/sources/src/java/net/sourceforge/pldoc/SubstitutionReader.java,v 1.1 2003/10/19 16:27:33 altumano Exp $
 */
public class SubstitutionReader extends FilterReader
{

  private String lineSeparator = System.getProperty("line.separator");
  
  /** Hides the constructor. */
  private SubstitutionReader(Reader in) {
    super(in);
  }

  /** Constructs a new Reader by substituting all defines in the specified Reader. */
  public SubstitutionReader(BufferedReader inputReader, Properties defines) throws Exception {
    this(inputReader);
    StringBuffer b = new StringBuffer();
    
    // read all the lines of the input, replacing defines with their values
    String s = inputReader.readLine();
    while(s != null) {
      int pos = -1;

      // substitute all defines in the line
      if(defines != null) {
        for(Enumeration e = defines.propertyNames(); e.hasMoreElements();) {
          String name = (String) e.nextElement();
          String value = defines.getProperty(name);
          while((pos = s.indexOf(name)) != -1) {
            s = s.substring(0, pos) + value + s.substring(pos + name.length());
          }
        }
      }

      // concatenate the processed line with the previous
      b.append(s);
      b.append(lineSeparator);
      s = inputReader.readLine();
    }
    
    this.in = new StringReader(b.toString());
  }

}
