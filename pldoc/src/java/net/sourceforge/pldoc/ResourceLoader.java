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
import java.net.URL.*;

/**
 * Helper class for retrieving resources relative to the installation.
 * @author Albert Tumanov
 * @version $Header: /cvsroot/pldoc/sources/src/java/net/sourceforge/pldoc/ResourceLoader.java,v 1.5 2009/01/30 22:37:58 zolyfarkas Exp $
 */
public class ResourceLoader {

  public InputStream getResourceStream(String path) throws java.io.IOException {
    ClassLoader cl = this.getClass().getClassLoader();
    if (cl == null) {
      cl = ClassLoader.getSystemClassLoader();
    }
    InputStream stream = cl.getResourceAsStream(path);
    if (stream == null) {
      throw new java.io.IOException("Resource not found: " + path);
    }
    return stream;
  }
  
  public void saveResourceToFile(String resPath, File toFile) 
      throws java.io.IOException {
    InputStream in = getResourceStream(resPath);
    try {
      OutputStream out = new FileOutputStream(toFile);
      try {
        byte buf[] = new byte[4096];
        int r = 0;
        while (r != -1) {
          if (r > 0)
            out.write(buf, 0, r);
          r = in.read(buf);
        }
      } finally {
        out.close();
      }
    } finally {
      in.close();
    }
  }
}
