<?xml version="1.0" encoding="UTF-8"?>

<!-- Copyright (C) 2002 Albert Tumanov

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

-->
<!--$Header: /cvsroot/pldoc/sources/src/resources/allpackages.xsl,v 1.3 2005/01/14 10:16:27 t_schaedler Exp $-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" indent="yes"/>
  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>

  <xsl:template match="/">
  <xsl:for-each select="APPLICATION">
    <HTML>
    <HEAD>
    <TITLE><xsl:value-of select="@NAME" /></TITLE>
    <LINK REL ="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
    </HEAD>
    <BODY BGCOLOR="white">

    <!--
    <TABLE BORDER="0" WIDTH="100%">
    <TR>
    <TD><FONT size="+1" CLASS="FrameTitleFont">
    <B><xsl:value-of select="@NAME" /></B></FONT></TD>
    </TR>
    </TABLE>
    -->

    <xsl:if test="PACKAGE">
    <TABLE BORDER="0" WIDTH="100%">
    <TR>
    <TD><FONT size="+1" CLASS="FrameHeadingFont">
    All Packages</FONT>
    <BR />
    <BR />

    <xsl:for-each select="PACKAGE">
      <xsl:sort select="@NAME"/>
      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
      </A></FONT><BR></BR>
    </xsl:for-each>

    </TD>
    </TR>
    </TABLE>
    </xsl:if>

    <xsl:if test="TABLE">
    <TABLE BORDER="0" WIDTH="100%">
    <TR>
    <TD><FONT size="+1" CLASS="FrameHeadingFont">
    All Tables</FONT>
    <BR></BR>

    <xsl:for-each select="TABLE">
      <xsl:sort select="@NAME"/>
      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
      </A></FONT><BR></BR>
    </xsl:for-each>

    </TD>
    </TR>
    </TABLE>
    </xsl:if>

    <xsl:if test="VIEW">
    <TABLE BORDER="0" WIDTH="100%">
    <TR>
    <TD><FONT size="+1" CLASS="FrameHeadingFont">
    All Views</FONT>
    <BR></BR>

    <xsl:for-each select="VIEW">
      <xsl:sort select="@NAME"/>
      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
      </A></FONT><BR></BR>
    </xsl:for-each>

    </TD>
    </TR>
    </TABLE>
    </xsl:if>

    <xsl:if test="TYPE">
    <TABLE BORDER="0" WIDTH="100%">
    <TR>
    <TD><FONT size="+1" CLASS="FrameHeadingFont">
    All types</FONT>
    <BR />
    <BR />

    <xsl:for-each select="TYPE">
      <xsl:sort select="@NAME"/>
      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
      </A></FONT><BR></BR>
    </xsl:for-each>

    </TD>
    </TR>
    </TABLE>
    </xsl:if>

    <P></P>
    </BODY>
    </HTML>
  </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
