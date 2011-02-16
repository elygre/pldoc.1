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
/**
* This class defines the current version of PLDoc.<P>
* @author Albert Tumanov
* @version $Header: /cvsroot/pldoc/sources/src/java/net/sourceforge/pldoc/Version.java,v 1.2 2009/01/30 22:37:58 zolyfarkas Exp $
*/
public class Version {

  // the Name will be substituted with release tag by CVS 
  private static final String tagName = "$Name:  $";
  private static final char dollar = '$';

  private Version() {
    // don't instantiate
  }

  /** Version ID in the form 0.0.0
  */
  public static String id() {

    String id = "";

    // if was not expanded, say it's experimental
    if (tagName.equals(dollar + "Name:  " + dollar)) {

      id = "(experimental)";

    } else {

      // extract numbers from the tag name (which is in the form "releaseXYZ")
      for(int i = 0; i < tagName.length(); i++) {
        char c = tagName.charAt(i);
        if (c >= '0' && c <= '9') {
          if (id.length() == 0) {
            id += c;
          } else {
            id += "." + c;
          }
        }
      }

    }

    return id;
  }

}
