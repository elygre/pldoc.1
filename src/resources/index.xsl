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
<!--$Header: /cvsroot/pldoc/sources/src/resources/index.xsl,v 1.2 2005/01/14 10:16:26 t_schaedler Exp $-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="APPLICATION">
    <HTML>
    <HEAD><TITLE><xsl:value-of select="@NAME" /></TITLE></HEAD>

	<FRAMESET cols="20%,80%">
		<FRAMESET rows="30%,70%">
			<FRAME src="allschemas.html" name="schemaFrame" />
			<FRAME src="allpackages.html" name="listFrame" />
		</FRAMESET>
		<FRAME src="summary.html" name="packageFrame" />
	</FRAMESET>

    <NOFRAMES>
	    <H2>Frames Not Supported</H2>
	    <P></P>This document needs a frame-capable web browser.
    </NOFRAMES>

    </HTML>
  </xsl:template>

</xsl:stylesheet>