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
<!--$Header: /cvsroot/pldoc/sources/src/resources/unit.xsl,v 1.7 2009/04/15 00:48:08 zolyfarkas Exp $-->

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
    <xsl:param name="targetFolder"></xsl:param>

  <!-- ********************** NAVIGATION BAR TEMPLATE ********************** -->
    <xsl:template name="NavigationBar">
        <TABLE BORDER="0" WIDTH="100%" CELLPADDING="1" CELLSPACING="0">
            <TR>
                <TD COLSPAN="2" CLASS="NavBarRow1">
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
                        <TR ALIGN="center" VALIGN="top">
                            <TD CLASS="NavBarRow1">
                                <A HREF="summary.html">
                                    <FONT CLASS="NavBarFont1">
                                        <B>Overview</B>
                                    </FONT>
                                </A> &nbsp;
                            </TD>
                            <TD CLASS="NavBarRow1">
                                <A HREF="deprecated-list.html">
                                    <FONT CLASS="NavBarFont1">
                                        <B>Deprecated</B>
                                    </FONT>
                                </A> &nbsp;
                            </TD>
                            <TD CLASS="NavBarRow1">
                                <A HREF="index-files/index-1.html">
                                    <FONT CLASS="NavBarFont1">
                                        <B>Index</B>
                                    </FONT>
                                </A> &nbsp;
                            </TD>
                            <TD CLASS="NavBarRow1">
                                <A HREF="help-doc.html">
                                    <FONT CLASS="NavBarFont1">
                                        <B>Help</B>
                                    </FONT>
                                </A> &nbsp;
                            </TD>
                        </TR>
                    </TABLE>
                </TD>
                <TD ALIGN="right" VALIGN="top" rowspan="3">
                    <EM>
                        <b>
                            <xsl:value-of select="../@NAME"/>
                        </b>
                    </EM>
                </TD>
            </TR>

            <TR>
                <TD CLASS="NavBarRow2">
     &nbsp;&nbsp;
                </TD>
                <TD CLASS="NavBarRow2">
                    <FONT SIZE="-2">
                        <A HREF="index.html" TARGET="_top">
                            <B>FRAMES</B>
                        </A> &nbsp;&nbsp;
                        <A HREF="index-noframes.html" TARGET="_top">
                            <B>NO FRAMES</B>
                        </A>
                    </FONT>
                </TD>
            </TR>
            <TR>
                <TD VALIGN="top" CLASS="NavBarRow3">
                    <FONT SIZE="-2">
      SUMMARY:
                        <A HREF="#field_summary">FIELD</A> |
                        <A HREF="#type_summary">TYPE</A> |
                        <A HREF="#method_summary">METHOD</A>
                    </FONT>
                </TD>
                <TD VALIGN="top" CLASS="NavBarRow3">
                    <FONT SIZE="-2">
    DETAIL:
                        <A HREF="#field_detail">FIELD</A> |
                        <A HREF="#type_detail">TYPE</A> |
                        <A HREF="#method_detail">METHOD</A>
                    </FONT>
                </TD>
            </TR>
        </TABLE>
        <HR/>
    </xsl:template>

  <!-- ***************** METHOD/TYPE SUMMARY TEMPLATE ****************** -->
    <xsl:template name="MethodOrTypeSummary">
        <xsl:param name="fragmentName" />
        <xsl:param name="title" />
        <xsl:param name="mainTags" />
        <xsl:param name="childTags" />
        <A NAME="{$fragmentName}"></A>
        <xsl:if test="$mainTags">

            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                <TR CLASS="TableHeadingColor">
                    <TD COLSPAN="2">
                        <FONT SIZE="+2">
                            <B>
                                <xsl:value-of select="$title"/>
                            </B>
                        </FONT>
                    </TD>
                </TR>

                <xsl:for-each select="$mainTags">
<!-- TODO: see why this sort does not work   <xsl:sort select="@NAME"/> -->
                    <TR CLASS="TableRowColor">
                        <TD ALIGN="right" VALIGN="top" WIDTH="1%">
                            <FONT SIZE="-1">
                                <CODE>
                                    <xsl:text>&nbsp;</xsl:text>
                                    <xsl:value-of select="RETURN/@TYPE"/>
                                </CODE>
                            </FONT>
                        </TD>
                        <TD>
                            <CODE>
                                <B>
                                    <xsl:element name="A">
                                        <xsl:attribute name="HREF">#
                                            <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)" />
                                            <xsl:if test="*[name()=$childTags]">
                                                <xsl:text>(</xsl:text>
                                                <xsl:for-each select="*[name()=$childTags]">
                                                    <xsl:value-of select="translate(@TYPE, $uppercase, $lowercase)"/>
                                                    <xsl:if test="not(position()=last())">
                                                        <xsl:text>,</xsl:text>
                                                    </xsl:if>
                                                </xsl:for-each>
                                                <xsl:text>)</xsl:text>
                                            </xsl:if>
                                        </xsl:attribute>
                                        <xsl:value-of select="@NAME"/>
                                    </xsl:element>
                                </B>
                                <xsl:text>(</xsl:text>
                                <xsl:for-each select="*[name()=$childTags]">
                                    <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)"/>
                                    <xsl:if test="string-length(@MODE) &gt; 0">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="@MODE"/>
                                    </xsl:if>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="@TYPE"/>
                                    <xsl:if test="string-length(@DEFAULT) &gt; 0">
                                        <xsl:text> DEFAULT </xsl:text>
                                        <xsl:value-of select="@DEFAULT"/>
                                    </xsl:if>
                                    <xsl:if test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:text>)</xsl:text>
                            </CODE>
                            <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
                                <xsl:for-each select="COMMENT_FIRST_LINE">
                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:for-each select="TAG[@TYPE='@deprecated']">
                                <B>Deprecated.</B>&nbsp;
                                <I>
                                    <xsl:for-each select="COMMENT">
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </xsl:for-each>
                                </I>
                            </xsl:for-each>
                        </TD>
                    </TR>
                </xsl:for-each>

            </TABLE>
            <P/>

        </xsl:if>
    </xsl:template>

  <!-- ************************* METHOD/TYPE DETAIL TEMPLATE *************************** -->
    <xsl:template name="MethodOrTypeDetail">
        <xsl:param name="fragmentName" />
        <xsl:param name="title" />
        <xsl:param name="mainTags" />
        <xsl:param name="childTags" />
        <A NAME="{$fragmentName}"></A>
        <xsl:if test="$mainTags">

            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                <TR CLASS="TableHeadingColor">
                    <TD COLSPAN="1">
                        <FONT SIZE="+2">
                            <B>
                                <xsl:value-of select="$title"/>
                            </B>
                        </FONT>
                    </TD>
                </TR>
            </TABLE>

            <xsl:for-each select="$mainTags">
                <xsl:element name="A">
                    <xsl:attribute name="NAME">
                        <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)" />
                        <xsl:if test="*[name()=$childTags]">
                            <xsl:text>(</xsl:text>
                            <xsl:for-each select="*[name()=$childTags]">
                                <xsl:value-of select="translate(@TYPE, $uppercase, $lowercase)"/>
                                <xsl:if test="not(position()=last())">
                                    <xsl:text>,</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:element>
                <H3>
                    <xsl:value-of select="@NAME"/>
                </H3>
                <PRE>
                    <xsl:variable name="methodText">
  public
                        <xsl:value-of select="RETURN/@TYPE"/>
                        <xsl:text> </xsl:text>
                        <B>
                            <xsl:value-of select="@NAME"/>
                        </B>
                    </xsl:variable>
                    <xsl:variable name="methodTextString" select="java:lang.String.new($methodText)"/>
  public
                    <xsl:value-of select="RETURN/@TYPE"/>
                    <xsl:text> </xsl:text>
                    <B>
                        <xsl:value-of select="@NAME"/>
                    </B>
                    <xsl:text>(</xsl:text>
                    <xsl:for-each select="*[name()=$childTags]">
          <!-- pad arguments with appropriate number of spaces -->
                        <xsl:if test="not(position()=1)">
                            <BR/>
                            <xsl:value-of select="str:padding(java:length($methodTextString))"/>
                        </xsl:if>
                        <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)"/>
                        <xsl:if test="string-length(@MODE) &gt; 0">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@MODE"/>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@TYPE"/>
                        <xsl:if test="string-length(@DEFAULT) &gt; 0">
                            <xsl:text> DEFAULT </xsl:text>
                            <xsl:value-of select="@DEFAULT"/>
                        </xsl:if>
                        <xsl:if test="not(position()=last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>)</xsl:text>
                </PRE>
                <DL>
                    <xsl:for-each select="TAG[@TYPE='@deprecated']">
                        <DD>
                            <B>Deprecated.</B>&nbsp;
                            <I>
                                <xsl:for-each select="COMMENT">
                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                </xsl:for-each>
                            </I>
                        </DD>
                        <P/>
                    </xsl:for-each>
                    <DD>
                        <xsl:for-each select="COMMENT">
                            <xsl:value-of select="." disable-output-escaping="yes" />
                        </xsl:for-each>
                    </DD>

                    <DD>
                        <DL>
                            <xsl:if test="*[name()=$childTags][COMMENT]">
                                <DT>
                                    <B>Parameters:</B>
                                    <xsl:for-each select="*[name()=$childTags]">
                                        <xsl:if test="COMMENT">
                                            <DD>
                                                <CODE>
                                                    <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)"/>
                                                </CODE> -
                                                <xsl:for-each select="COMMENT">
                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                </xsl:for-each>
                                            </DD>
                                        </xsl:if>
                                    </xsl:for-each>
                                </DT>
                            </xsl:if>
                            <xsl:for-each select="RETURN/COMMENT">
                                <DT>
                                    <B>Returns:</B>
                                    <DD>
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </DD>
                                </DT>
                            </xsl:for-each>
                            <xsl:if test="TAG[@TYPE='@throws']">
                                <DT>
                                    <B>Throws:</B>
                                    <xsl:for-each select="TAG[@TYPE='@throws']">
                                        <DD>
                                            <CODE>
                                                <xsl:value-of select="@NAME"/>
                                            </CODE> -
                                            <xsl:for-each select="COMMENT">
                                                <xsl:value-of select="." disable-output-escaping="yes" />
                                            </xsl:for-each>
                                        </DD>
                                    </xsl:for-each>
                                </DT>
                            </xsl:if>
                        </DL>
                    </DD>
                </DL>

                <HR/>
            </xsl:for-each>

        </xsl:if>
    </xsl:template>

  <!-- ************************* START OF PAGE ***************************** -->
    <xsl:template match="/APPLICATION">
  <!-- ********************* START OF PACKAGE PAGE ************************* -->
        <xsl:for-each select="PACKAGE | PACKAGE_BODY">

            <redirect:write file="{concat($targetFolder, translate(@NAME, $uppercase, $lowercase))}.html">

                <HTML>
                    <HEAD>
                        <TITLE>
                            <xsl:value-of select="../@NAME"/>
                        </TITLE>
                        <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
                    </HEAD>
                    <BODY BGCOLOR="white">

    <!-- **************************** HEADER ******************************* -->
                        <xsl:call-template name="NavigationBar"/>

    <!-- ********************** PACKAGE DECRIPTION ************************* -->
                        <H2>
                            <FONT SIZE="-1">
                                <xsl:value-of select="@SCHEMA"/>
                            </FONT>
                            <BR/>
    Package
                            <xsl:value-of select="@NAME"/>
                        </H2>
                        <xsl:for-each select="TAG[@TYPE='@deprecated']">
                            <P>
                                <B>Deprecated.</B>&nbsp;
                                <I>
                                    <xsl:for-each select="COMMENT">
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </xsl:for-each>
                                </I>
                            </P>
                        </xsl:for-each>
                        <P>
                            <xsl:for-each select="COMMENT">
                                <xsl:value-of select="." disable-output-escaping="yes" />
                            </xsl:for-each>
                        </P>
                        <HR/>
                        <P/>

    <!-- ************************** FIELD SUMMARY ************************** -->
                        <A NAME="field_summary"></A>
                        <xsl:if test="CONSTANT | VARIABLE">

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="2">
                                        <FONT SIZE="+2">
                                            <B>Field Summary</B>
                                        </FONT>
                                    </TD>
                                </TR>

                                <xsl:for-each select="CONSTANT | VARIABLE">
                                    <xsl:sort select="@NAME"/>
                                    <TR CLASS="TableRowColor">
                                        <TD ALIGN="right" VALIGN="top" WIDTH="1%">
                                            <FONT SIZE="-1">
                                                <CODE>
                                                    <xsl:text>&nbsp;</xsl:text>
                                                    <xsl:value-of select="RETURN/@TYPE"/>
                                                </CODE>
                                            </FONT>
                                        </TD>
                                        <TD>
                                            <CODE>
                                                <B>
                                                    <A HREF="#{@NAME}">
                                                        <xsl:value-of select="@NAME"/>
                                                    </A>
                                                </B>
                                            </CODE>
                                            <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
                                                <xsl:for-each select="COMMENT_FIRST_LINE">
                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:for-each select="TAG[@TYPE='@deprecated']">
                                                <B>Deprecated.</B>&nbsp;
                                                <I>
                                                    <xsl:for-each select="COMMENT">
                                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                                    </xsl:for-each>
                                                </I>
                                            </xsl:for-each>
                                        </TD>
                                    </TR>
                                </xsl:for-each>

                            </TABLE>
                            <P/>

                        </xsl:if>

    <!-- ************************* TYPE SUMMARY ************************** -->
                        <xsl:call-template name="MethodOrTypeSummary">
                            <xsl:with-param name="fragmentName">type_summary</xsl:with-param>
                            <xsl:with-param name="title">Type Summary</xsl:with-param>
                            <xsl:with-param name="mainTags" select="TYPE" />
                            <xsl:with-param name="childTags" select="'FIELD'" />
                        </xsl:call-template>

    <!-- ************************* METHOD SUMMARY ************************** -->
                        <xsl:call-template name="MethodOrTypeSummary">
                            <xsl:with-param name="fragmentName">method_summary</xsl:with-param>
                            <xsl:with-param name="title">Method Summary</xsl:with-param>
                            <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE | MEMBER-FUNCTION" />
                            <xsl:with-param name="childTags" select="'ARGUMENT'" />
                        </xsl:call-template>

    <!-- ************************** FIELD DETAIL *************************** -->
                        <A NAME="field_detail"></A>
                        <xsl:if test="CONSTANT | VARIABLE">

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="1">
                                        <FONT SIZE="+2">
                                            <B>Field Detail</B>
                                        </FONT>
                                    </TD>
                                </TR>
                            </TABLE>

                            <xsl:for-each select="CONSTANT | VARIABLE">
                                <A NAME="{@NAME}"></A>
                                <H3>
                                    <xsl:value-of select="@NAME"/>
                                </H3>
                                <PRE>
  public
                                    <xsl:value-of select="RETURN/@TYPE"/>
                                    <xsl:text> </xsl:text>
                                    <B>
                                        <xsl:value-of select="@NAME"/>
                                    </B>
                                </PRE>
                                <DL>
                                    <xsl:for-each select="TAG[@TYPE='@deprecated']">
                                        <DD>
                                            <B>Deprecated.</B>&nbsp;
                                            <I>
                                                <xsl:for-each select="COMMENT">
                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                </xsl:for-each>
                                            </I>
                                        </DD>
                                        <P/>
                                    </xsl:for-each>
                                    <DD>
                                        <xsl:for-each select="COMMENT">
                                            <xsl:value-of select="." disable-output-escaping="yes" />
                                        </xsl:for-each>
                                    </DD>

                                    <DD>
                                        <DL>
                                        </DL>
                                    </DD>
                                </DL>

                                <HR/>
                            </xsl:for-each>

                        </xsl:if>

    <!-- ************************* TYPE DETAIL *************************** -->
                        <xsl:call-template name="MethodOrTypeDetail">
                            <xsl:with-param name="fragmentName">type_detail</xsl:with-param>
                            <xsl:with-param name="title">Type Detail</xsl:with-param>
                            <xsl:with-param name="mainTags" select="TYPE" />
                            <xsl:with-param name="childTags" select="'FIELD'" />
                        </xsl:call-template>

    <!-- ************************* METHOD DETAIL *************************** -->
                        <xsl:call-template name="MethodOrTypeDetail">
                            <xsl:with-param name="fragmentName">method_detail</xsl:with-param>
                            <xsl:with-param name="title">Method Detail</xsl:with-param>
                            <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE | MEMBER-FUNCTION" />
                            <xsl:with-param name="childTags" select="'ARGUMENT'" />
                        </xsl:call-template>

    <!-- ***************************** FOOTER ****************************** -->
                        <xsl:call-template name="NavigationBar"/>

                    </BODY>
                </HTML>

            </redirect:write>
        </xsl:for-each> <!-- select="PACKAGE | PACKAGE_BODY" -->

  <!-- ********************** START OF TABLE PAGE ************************** -->
        <xsl:for-each select="TABLE | VIEW">

            <redirect:write file="{translate(@NAME, $uppercase, $lowercase)}.html">

                <HTML>
                    <HEAD>
                        <TITLE>
                            <xsl:value-of select="../@NAME"/>
                        </TITLE>
                        <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
                    </HEAD>
                    <BODY BGCOLOR="white">

    <!-- **************************** HEADER ******************************* -->
                        <xsl:call-template name="NavigationBar"/>

    <!-- ********************** TABLE DECRIPTION ************************* -->
                        <H2>
                            <FONT SIZE="-1">
                                <xsl:value-of select="@SCHEMA"/>
                            </FONT>
                            <BR/>
                            <xsl:value-of select="local-name(.)"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@NAME"/>
                        </H2>
                        <xsl:for-each select="TAG[@TYPE='@deprecated']">
                            <P>
                                <B>Deprecated.</B>&nbsp;
                                <I>
                                    <xsl:for-each select="COMMENT">
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </xsl:for-each>
                                </I>
                            </P>
                        </xsl:for-each>
                        <P>
                            <xsl:for-each select="COMMENT">
                                <xsl:value-of select="." disable-output-escaping="yes" />
                            </xsl:for-each>
                        </P>
                        <HR/>
                        <P/>

    <!-- ***************************** COLUMNS ***************************** -->
                        <A NAME="field_summary"></A>
                        <xsl:if test="COLUMN">

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="2">
                                        <FONT SIZE="+2">
                                            <B>Columns</B>
                                        </FONT>
                                    </TD>
                                </TR>

                                <xsl:for-each select="COLUMN">
                                    <TR CLASS="TableRowColor">
                                        <TD ALIGN="right" VALIGN="top" WIDTH="1%">
                                            <FONT SIZE="-1">
                                                <CODE>
                                                    <xsl:text>&nbsp;</xsl:text>
                                                    <xsl:value-of select="@TYPE"/>
                                                </CODE>
                                            </FONT>
                                        </TD>
                                        <TD>
                                            <CODE>
                                                <B>
                                                    <A HREF="#{@NAME}">
                                                        <xsl:value-of select="@NAME"/>
                                                    </A>
                                                </B>
                                            </CODE>
                                            <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
                                                <xsl:for-each select="COMMENT">
                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:for-each select="TAG[@TYPE='@deprecated']">
                                                <B>Deprecated.</B>&nbsp;
                                                <I>
                                                    <xsl:for-each select="COMMENT">
                                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                                    </xsl:for-each>
                                                </I>
                                            </xsl:for-each>
                                        </TD>
                                    </TR>
                                </xsl:for-each>

                            </TABLE>
                            <P/>

                        </xsl:if>

    <!-- ***************************** FOOTER ****************************** -->
                        <xsl:call-template name="NavigationBar"/>

                    </BODY>
                </HTML>

            </redirect:write>
        </xsl:for-each> <!-- select="TABLE" -->

	<!-- ********************* START OF PACKAGE PAGE ************************* -->
        <xsl:for-each select="TYPE[@TYPE='OBJECT']">

            <redirect:write file="{concat($targetFolder, translate(@NAME, $uppercase, $lowercase))}.html">

                <HTML>
                    <HEAD>
                        <TITLE>
                            <xsl:value-of select="../@NAME"/>
                        </TITLE>
                        <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
                    </HEAD>
                    <BODY BGCOLOR="white">

    <!-- **************************** HEADER ******************************* -->
                        <xsl:call-template name="NavigationBar"/>

    <!-- ********************** PACKAGE DECRIPTION ************************* -->
                        <H2>
                            <FONT SIZE="-1">
                                <xsl:value-of select="@SCHEMA"/>
                            </FONT>
                            <BR/>
    Type
                            <xsl:value-of select="@NAME"/>
                        </H2>
                        <xsl:for-each select="TAG[@TYPE='@deprecated']">
                            <P>
                                <B>Deprecated.</B>&nbsp;
                                <I>
                                    <xsl:for-each select="COMMENT">
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </xsl:for-each>
                                </I>
                            </P>
                        </xsl:for-each>
                        <P>
                            <xsl:for-each select="COMMENT">
                                <xsl:value-of select="." disable-output-escaping="yes" />
                            </xsl:for-each>
                        </P>
                        <HR/>
                        <P/>

    <!-- ************************** FIELD SUMMARY ************************** -->
                        <A NAME="field_summary"></A>
                        <xsl:if test="CONSTANT | VARIABLE">

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="2">
                                        <FONT SIZE="+2">
                                            <B>Field Summary</B>
                                        </FONT>
                                    </TD>
                                </TR>

                                <xsl:for-each select="CONSTANT | VARIABLE">
                                    <xsl:sort select="@NAME"/>
                                    <TR CLASS="TableRowColor">
                                        <TD ALIGN="right" VALIGN="top" WIDTH="1%">
                                            <FONT SIZE="-1">
                                                <CODE>
                                                    <xsl:text>&nbsp;</xsl:text>
                                                    <xsl:value-of select="RETURN/@TYPE"/>
                                                </CODE>
                                            </FONT>
                                        </TD>
                                        <TD>
                                            <CODE>
                                                <B>
                                                    <A HREF="#{@NAME}">
                                                        <xsl:value-of select="@NAME"/>
                                                    </A>
                                                </B>
                                            </CODE>
                                            <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
                                                <xsl:for-each select="COMMENT_FIRST_LINE">
                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:for-each select="TAG[@TYPE='@deprecated']">
                                                <B>Deprecated.</B>&nbsp;
                                                <I>
                                                    <xsl:for-each select="COMMENT">
                                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                                    </xsl:for-each>
                                                </I>
                                            </xsl:for-each>
                                        </TD>
                                    </TR>
                                </xsl:for-each>

                            </TABLE>
                            <P/>

                        </xsl:if>

    <!-- ************************* TYPE SUMMARY ************************** -->
                        <xsl:call-template name="MethodOrTypeSummary">
                            <xsl:with-param name="fragmentName">type_summary</xsl:with-param>
                            <xsl:with-param name="title">Type Summary</xsl:with-param>
                            <xsl:with-param name="mainTags" select="TYPE" />
                            <xsl:with-param name="childTags" select="'FIELD'" />
                        </xsl:call-template>

    <!-- ************************* METHOD SUMMARY ************************** -->
                        <xsl:call-template name="MethodOrTypeSummary">
                            <xsl:with-param name="fragmentName">method_summary</xsl:with-param>
                            <xsl:with-param name="title">Method Summary</xsl:with-param>
                            <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE | MEMBER-FUNCTION" />
                            <xsl:with-param name="childTags" select="'ARGUMENT'" />
                        </xsl:call-template>

    <!-- ************************** FIELD DETAIL *************************** -->
                        <A NAME="field_detail"></A>
                        <xsl:if test="CONSTANT | VARIABLE">

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="1">
                                        <FONT SIZE="+2">
                                            <B>Field Detail</B>
                                        </FONT>
                                    </TD>
                                </TR>
                            </TABLE>

                            <xsl:for-each select="CONSTANT | VARIABLE">
                                <A NAME="{@NAME}"></A>
                                <H3>
                                    <xsl:value-of select="@NAME"/>
                                </H3>
                                <PRE>
  public
                                    <xsl:value-of select="RETURN/@TYPE"/>
                                    <xsl:text> </xsl:text>
                                    <B>
                                        <xsl:value-of select="@NAME"/>
                                    </B>
                                </PRE>
                                <DL>
                                    <xsl:for-each select="TAG[@TYPE='@deprecated']">
                                        <DD>
                                            <B>Deprecated.</B>&nbsp;
                                            <I>
                                                <xsl:for-each select="COMMENT">
                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                </xsl:for-each>
                                            </I>
                                        </DD>
                                        <P/>
                                    </xsl:for-each>
                                    <DD>
                                        <xsl:for-each select="COMMENT">
                                            <xsl:value-of select="." disable-output-escaping="yes" />
                                        </xsl:for-each>
                                    </DD>

                                    <DD>
                                        <DL>
                                        </DL>
                                    </DD>
                                </DL>

                                <HR/>
                            </xsl:for-each>

                        </xsl:if>

    <!-- ************************* TYPE DETAIL *************************** -->
                        <xsl:call-template name="MethodOrTypeDetail">
                            <xsl:with-param name="fragmentName">type_detail</xsl:with-param>
                            <xsl:with-param name="title">Type Detail</xsl:with-param>
                            <xsl:with-param name="mainTags" select="TYPE" />
                            <xsl:with-param name="childTags" select="'FIELD'" />
                        </xsl:call-template>

    <!-- ************************* METHOD DETAIL *************************** -->
                        <xsl:call-template name="MethodOrTypeDetail">
                            <xsl:with-param name="fragmentName">method_detail</xsl:with-param>
                            <xsl:with-param name="title">Method Detail</xsl:with-param>
                            <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE | MEMBER-FUNCTION" />
                            <xsl:with-param name="childTags" select="'ARGUMENT'" />
                        </xsl:call-template>

    <!-- ***************************** FOOTER ****************************** -->
                        <xsl:call-template name="NavigationBar"/>

                    </BODY>
                </HTML>

            </redirect:write>
        </xsl:for-each> <!-- select="TYPE" -->


	<!-- ********************* TYPE IS TABLE OF ... ************************* -->
        <xsl:for-each select="TYPE[@TYPE='NESTED-TABLE']">

            <redirect:write file="{concat($targetFolder, translate(@NAME, $uppercase, $lowercase))}.html">

                <HTML>
                    <HEAD>
                        <TITLE>
                            <xsl:value-of select="../@NAME"/>
                        </TITLE>
                        <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
                    </HEAD>
                    <BODY BGCOLOR="white">

						<!-- HEADER -->
                        <xsl:call-template name="NavigationBar"/>

						<!-- PACKAGE DECRIPTION -->
                        <H2>
                            <FONT SIZE="-1">
                                <xsl:value-of select="@SCHEMA"/>
                            </FONT>
                            <BR/>
    Nested Table
                            <xsl:value-of select="@NAME"/>
                        </H2>
                        <xsl:for-each select="TAG[@TYPE='@deprecated']">
                            <P>
                                <B>Deprecated.</B>&nbsp;
                                <I>
                                    <xsl:for-each select="COMMENT">
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </xsl:for-each>
                                </I>
                            </P>
                        </xsl:for-each>
                        <P>
                            <xsl:for-each select="COMMENT">
                                <xsl:value-of select="." disable-output-escaping="yes" />
                            </xsl:for-each>
                        </P>
                        <HR/>
                        <P/>
						<!-- FIELD SUMMARY -->
                        <A NAME="field_summary"></A>

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="2">
                                        <FONT SIZE="+2">
                                            <B>Nested table type</B>
                                        </FONT>
                                    </TD>
                                </TR>

                                    <TR CLASS="TableRowColor">
                                        <TD ALIGN="right" VALIGN="top" WIDTH="1%">
                                            <FONT SIZE="-1">
                                                <CODE>
                                                    <xsl:text>&nbsp;</xsl:text>
                                                    <xsl:value-of select="@DATATYPE"/>
                                                </CODE>
                                            </FONT>
                                        </TD>
                                        <TD>
                                            <CODE>
                                                <B>
                                                    (Element in nested table)
                                                </B>
                                            </CODE>
                                        </TD>
                                    </TR>

                            </TABLE>
                            <P/>



    <!-- ***************************** FOOTER ****************************** -->
                        <xsl:call-template name="NavigationBar"/>

                    </BODY>
                </HTML>

            </redirect:write>
        </xsl:for-each> <!-- select="TYPE" -->

	<!-- ********************* TYPE IS TABLE OF ... ************************* -->
        <xsl:for-each select="TYPE[@TYPE='VARRAY']">

            <redirect:write file="{concat($targetFolder, translate(@NAME, $uppercase, $lowercase))}.html">

                <HTML>
                    <HEAD>
                        <TITLE>
                            <xsl:value-of select="../@NAME"/>
                        </TITLE>
                        <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
                    </HEAD>
                    <BODY BGCOLOR="white">

						<!-- HEADER -->
                        <xsl:call-template name="NavigationBar"/>

						<!-- PACKAGE DECRIPTION -->
                        <H2>
                            <FONT SIZE="-1">
                                <xsl:value-of select="@SCHEMA"/>
                            </FONT>
                            <BR/>
    VARRAY
                            <xsl:value-of select="@NAME"/>
                        </H2>
                        <xsl:for-each select="TAG[@TYPE='@deprecated']">
                            <P>
                                <B>Deprecated.</B>&nbsp;
                                <I>
                                    <xsl:for-each select="COMMENT">
                                        <xsl:value-of select="." disable-output-escaping="yes" />
                                    </xsl:for-each>
                                </I>
                            </P>
                        </xsl:for-each>
                        <P>
                            <xsl:for-each select="COMMENT">
                                <xsl:value-of select="." disable-output-escaping="yes" />
                            </xsl:for-each>
                        </P>
                        <HR/>
                        <P/>
						<!-- FIELD SUMMARY -->
                        <A NAME="field_summary"></A>

                            <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
                                <TR CLASS="TableHeadingColor">
                                    <TD COLSPAN="2">
                                        <FONT SIZE="+2">
                                            <B>Nested table type</B>
                                        </FONT>
                                    </TD>
                                </TR>

                                    <TR CLASS="TableRowColor">
                                        <TD ALIGN="right" VALIGN="top" WIDTH="1%">
                                            <FONT SIZE="-1">
                                                <CODE>
                                                    <xsl:text>&nbsp;</xsl:text>
                                                    <xsl:value-of select="@DATATYPE"/>
                                                </CODE>
                                            </FONT>
                                        </TD>
                                        <TD>
                                            <CODE>
                                                <B>
                                                    (Element in nested table)
                                                </B>
                                            </CODE>
                                        </TD>
                                    </TR>

                            </TABLE>
                            <P/>



    <!-- ***************************** FOOTER ****************************** -->
                        <xsl:call-template name="NavigationBar"/>

                    </BODY>
                </HTML>

            </redirect:write>
        </xsl:for-each> <!-- select="TYPE[@TYPE=VARRAY]" -->
		
		
		
    </xsl:template>

</xsl:stylesheet>
