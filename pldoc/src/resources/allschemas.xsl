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
<!--$Header: /cvsroot/pldoc/sources/src/resources/allschemas.xsl,v 1.1 2005/01/14 10:16:27 t_schaedler Exp $-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:java="java"
  xmlns:str="http://exslt.org/strings"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:redirect="http://xml.apache.org/xalan/redirect"
  extension-element-prefixes="redirect str java">

  <xsl:output method="html" indent="yes"/>
  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>

  <xsl:key name="schemaInit" match="*[@SCHEMA]" use="@SCHEMA"/>

  <xsl:template match="/">
	  <xsl:for-each select="APPLICATION">
	    <HTML>
	    <HEAD>
	    <TITLE><xsl:value-of select="@NAME" /></TITLE>
	    <LINK REL ="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
	    </HEAD>
	    <BODY BGCOLOR="white">
	
	    <!-- generate a link to the all-packages list -->
	    <TABLE BORDER="0" WIDTH="100%">
	    <TR>
		    <TD><FONT size="+1" CLASS="FrameItemFont">
		    <A HREF="allpackages.html" target="listFrame">All Packages</A></FONT></TD>
	    </TR>
	    </TABLE>
	    
		<BR />
		
		<!-- add the title -->
	    <TABLE BORDER="0" WIDTH="100%">
	    <TR>
		    <TD><FONT size="+1" CLASS="FrameTitleFont">
		    <B>Schemas</B></FONT></TD>
	    </TR>
	    </TABLE>
	
	    <!-- List all distinct schemas using muenchian method -->
		<xsl:for-each select="//*[count(. | key('schemaInit', @SCHEMA)[1]) = 1 and @SCHEMA != '']">
     
		  <!-- generate the linked pages with only-schema-packages -->
		  <xsl:call-template name="schemaonly">
		    <xsl:with-param name="theschema" select="@SCHEMA"/>
		  </xsl:call-template>
	     
		</xsl:for-each>
	
	    <P></P>
	    </BODY>
	    </HTML>
	  </xsl:for-each>
  </xsl:template>

  <!-- this template processes all packages of the specified schema -->
  <xsl:template name="schemaonly">
     <xsl:param name="theschema"/>
     
	  <!-- generate a link to the only-schema-packages list -->
      <FONT CLASS="FrameItemFont"><A HREF="{translate($theschema, $uppercase, $lowercase)}.html" TARGET="listFrame">
        <xsl:value-of select="translate($theschema, $lowercase, $uppercase)"/>
      </A></FONT><BR></BR>
     
     <!-- generate the file: package list of this schema -->
     <redirect:write file="{translate($theschema, $uppercase, $lowercase)}.html">
	    <TABLE BORDER="0" WIDTH="100%">
	    <TR>
		    <TD><FONT size="+1" CLASS="FrameTitleFont">
		    <B><A HREF="{translate($theschema, $uppercase, $lowercase)}-summary.html" TARGET="packageFrame">
		    	<xsl:value-of select="translate($theschema, $lowercase, $uppercase)" />
		    </A></B>
		    </FONT></TD>
	    </TR>
	    </TABLE>
	
	    <xsl:if test="//PACKAGE[@SCHEMA=$theschema]">
	    <TABLE BORDER="0" WIDTH="100%">
	    <TR>
	    <TD><FONT size="+1" CLASS="FrameHeadingFont">
	    Packages</FONT>
	    <BR />
	    <BR />
	
	    <xsl:for-each select="//PACKAGE[@SCHEMA=$theschema]">
	      <xsl:sort select="@NAME"/>
	      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
	        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
	      </A></FONT><BR></BR>
	    </xsl:for-each>
	
	    </TD>
	    </TR>
	    </TABLE>
	    </xsl:if>
	
	    <xsl:if test="//TABLE[@SCHEMA=$theschema]">
	    <TABLE BORDER="0" WIDTH="100%">
	    <TR>
	    <TD><FONT size="+1" CLASS="FrameHeadingFont">
	    Tables</FONT>
	    <BR></BR>
	
	    <xsl:for-each select="//TABLE[@SCHEMA=$theschema]">
	      <xsl:sort select="@NAME"/>
	      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
	        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
	      </A></FONT><BR></BR>
	    </xsl:for-each>
	
	    </TD>
	    </TR>
	    </TABLE>
	    </xsl:if>
	
	    <xsl:if test="//VIEW[@SCHEMA=$theschema]">
	    <TABLE BORDER="0" WIDTH="100%">
	    <TR>
	    <TD><FONT size="+1" CLASS="FrameHeadingFont">
	    Views</FONT>
	    <BR></BR>
	
	    <xsl:for-each select="//VIEW[@SCHEMA=$theschema]">
	      <xsl:sort select="@NAME"/>
	      <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
	        <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
	      </A></FONT><BR></BR>
	    </xsl:for-each>
	
	    </TD>
	    </TR>
	    </TABLE>
	    </xsl:if>
	
    </redirect:write>
    
 	<!-- generate the file: package summary of this schema -->
    <redirect:write file="{translate($theschema, $uppercase, $lowercase)}-summary.html">
	    
		<HTML>
	    <HEAD>
	    <TITLE><xsl:value-of select="@NAME" />: Overview</TITLE>
	    <LINK REL ="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style" />
	    </HEAD>
	
	    <BODY BGCOLOR="white">
	    <!-- **************************** HEADER ******************************* -->
	    <xsl:call-template name="NavigationBar"/>
	
	    <CENTER><H2>Schema <xsl:value-of select="$theschema" /></H2></CENTER>
	    <xsl:value-of select="OVERVIEW" disable-output-escaping="yes" />
	    <P/><P/>
	
	    <!-- **************************** Packages ******************************* -->
		<xsl:if test="//PACKAGE[@SCHEMA=$theschema]">
			<TABLE BORDER="1" WIDTH="100%">
			<TR><TD COLSPAN="2"><FONT size="+1" CLASS="FrameHeadingFont">Packages</FONT></TD></TR>
		
		    <xsl:for-each select="//PACKAGE[@SCHEMA=$theschema]">
		      <xsl:sort select="@NAME"/>
			  <TR>
		   	  <TD>
		        <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
		           <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
		        </A></FONT>
			    </TD>
			    <TD>&nbsp;</TD>
			  </TR>
		    </xsl:for-each>
		
			</TABLE>
			<P/><P/>
	    </xsl:if>
	
		<!-- **************************** Tables ******************************* -->
	    <xsl:if test="//TABLE[@SCHEMA=$theschema]">
			<TABLE BORDER="1" WIDTH="100%">
			<TR><TD COLSPAN="2"><FONT size="+1" CLASS="FrameHeadingFont">Tables</FONT></TD></TR>
		
		    <xsl:for-each select="//TABLE[@SCHEMA=$theschema]">
		      <xsl:sort select="@NAME"/>
			  <TR>
		   	  <TD>
		        <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
		           <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
		        </A></FONT>
			    </TD>
			    <TD>&nbsp;</TD>
			  </TR>
		    </xsl:for-each>
		
			</TABLE>
			<P/><P/>
	    </xsl:if>
	
		<!-- **************************** Views ******************************* -->
	    <xsl:if test="//VIEW[@SCHEMA=$theschema]">
			<TABLE BORDER="1" WIDTH="100%">
			<TR><TD COLSPAN="2"><FONT size="+1" CLASS="FrameHeadingFont">Views</FONT></TD></TR>
		
		    <xsl:for-each select="//VIEW[@SCHEMA=$theschema]">
		      <xsl:sort select="@NAME"/>
			  <TR>
		   	  <TD>
		        <FONT CLASS="FrameItemFont"><A HREF="{translate(@NAME, $uppercase, $lowercase)}.html" TARGET="packageFrame">
		           <xsl:value-of select="translate(@NAME, $lowercase, $uppercase)"/>
		        </A></FONT>
			    </TD>
			    <TD>&nbsp;</TD>
			  </TR>
		    </xsl:for-each>
		
			</TABLE>
			<P/><P/>
	    </xsl:if>
		
	    <!-- ***************************** FOOTER ****************************** -->
	    <xsl:call-template name="NavigationBar"/>
	
	    <FONT size="-1">
	    Generated by <A HREF="http://pldoc.sourceforge.net" TARGET="_blank">PLDoc</A>
	    </FONT>
	    </BODY>
	    </HTML>
	
    </redirect:write>
  </xsl:template>

  <!-- ********************** NAVIGATION BAR TEMPLATE ********************** -->
  <xsl:template name="NavigationBar">
    <TABLE BORDER="0" WIDTH="100%" CELLPADDING="1" CELLSPACING="0">
    <TR>
    <TD COLSPAN="2" CLASS="NavBarRow1">
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
      <TR ALIGN="center" VALIGN="top">
      <TD CLASS="NavBarRow1Chosen"><FONT CLASS="NavBarFont1Chosen"><B>Overview</B></FONT> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="deprecated-list.html"><FONT CLASS="NavBarFont1"><B>Deprecated</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="index-files/index-1.html"><FONT CLASS="NavBarFont1"><B>Index</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="help-doc.html"><FONT CLASS="NavBarFont1"><B>Help</B></FONT></A> &nbsp;</TD>
      </TR>
    </TABLE>
    </TD>
    <TD ALIGN="right" VALIGN="top" rowspan="3"><EM>
      <b><xsl:value-of select="@NAME"/></b></EM>
    </TD>
    </TR>

    <TR>
    <TD CLASS="NavBarRow2">
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
     &nbsp;&nbsp;&nbsp;&nbsp;
    </TD>
    <TD CLASS="NavBarRow2"><FONT SIZE="-2">
      <A HREF="index.html" TARGET="_top"><B>FRAMES</B></A> &nbsp;&nbsp;
      <A HREF="index-noframes.html" TARGET="_top"><B>NO FRAMES</B></A></FONT></TD>
    </TR>
    <TR>
    <TD VALIGN="top" CLASS="NavBarRow3"><FONT SIZE="-2">
      SUMMARY:  FIELD | METHOD</FONT></TD>
    <TD VALIGN="top" CLASS="NavBarRow3"><FONT SIZE="-2">
    DETAIL:  FIELD | METHOD</FONT></TD>
    </TR>
    </TABLE>
    <HR/>
  </xsl:template>

</xsl:stylesheet>
