<?xml version="1.0" encoding="UTF-8"?>
<!--
# Copyright © 2024 UJX Ltd. All rights reserved.
# See LICENSE.txt for details.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

    <xsl:param name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:param name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>

	<xsl:template match="/">
        <html>
            <head>
                <style>
                    body, pre, h2, h3, h4, th, td, span {font-family: Aptos, Calibri, Verdana, Arial;}
                    div.quote {border-left: 1px solid silver; padding-left: 5px; margin: 5em; margin-left: 15px; margin-top: 5px; margin-bottom: 5px}
                    div.outer {margin: 0 auto}
                    table.main {border-spacing: 0; border-collapse: collapse; border: 1px solid silver; width: 960px; table-layout: fixed;}
                    table.sub {border-spacing: 0; border-collapse: collapse; border: 1px solid silver; width: 400px; table-layout: fixed;}
                    td {border-spacing: 0; border-collapse: collapse; border: 1px solid silver; padding: 5px; vertical-align: top; word-wrap: break-word; white-space: normal;}
                    span.emphasis {font-weight: normal; font-style: italic; font-size: 9pt}
                    img {border: 1px solid #ddd; border-radius: 4px; padding: 5px;}
                    img:hover {box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);}
                    span.manual {color: red; font-weight: bold; vertical-align: super; font-size: 90%;}
                    ul {display: inline-block; text-align: center; list-style-type: none;}
                    td.start-column {width: 150px;}
                    td.end-column {width: 70px;}
                    span.test-leader {font-weight: bold; font-size: 115%; color: grey;}
                    span.test-descriptor {font-weight: bold; font-size: 115%; color: black;}
                    span.annotation-anchor {vertical-align: super; font-size: 8pt;}
                    span.annotation-text {font-size: 9pt;}
                    td.workflow-step {background-color: #cafbce; color: black;}
                    li {color: black; text-decoration: none; font-weight: normal;}
                    li.workflow-step-item {color: black; font-weight: bold;}
                    pre {white-space: pre-wrap;}
                    .action-data-entry {color: #0070C0; font-weight: bold;}
                    .action-key-action {color: #C00000; font-weight: bold;}
                    .action-navigation {color: #00B050; font-weight: bold;}
                    .action-validation {color: #7030B1; font-weight: bold;}
                    .action-uncategorized {color: black; font-weight: bold;}
                    .fixed-inline-box {
                        display: inline-block;
                        width: 0.75em;             
                        text-align: center;       
                        border: 1px solid #ccc;   
                        border-radius: 0.4em;     
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
                        padding: 0.1em;           
                        line-height: 0.75em;       
                        vertical-align: middle;   
                        background-color: #fff;   
                        margin-left: 0.4em; 
                        font-weight: bold;
                        font-size: 8pt;
                    }
                    .watermark {
                        position: fixed;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%) rotate(-45deg);
                        font-size: 5rem;
                        color: rgba(200, 200, 200, 0.5);
                        z-index: 9999;
                        pointer-events: none;
                    }
                </style>
            </head>
            <body>
                <div class="watermark">DRAFT</div>
                <h2><xsl:value-of select="concat('Topic: ', tests/metadata/descendant::prop[@attrib='Script Name']/@setting)" /> <span class="emphasis"><i><xsl:value-of select="concat(' (v ', tests/metadata/descendant::prop[@attrib='Version']/@setting, ')')" /></i></span></h2>

                <strong>Description:</strong><br />
                <xsl:value-of select="tests/metadata/descendant::prop[@attrib='Purpose']/@setting" /><br /><br />

                <strong>Prerequisites (and constraints):</strong>
                <xsl:for-each select="tests/metadata/prereqs/item/text()">
                    <pre>
                        <xsl:value-of select="." />
                    </pre>
                </xsl:for-each>
                <br />

                <strong>Step Group(s):</strong>
                <ol> 
                    <xsl:for-each select="tests/test[not(contains(@case, 'Evaluation Warning'))  and count(./step[@publicised='Y' or @publicised='T' or @publicised='I' or @publicised='O']) > 0]">
                        <xsl:variable name="current_test"><xsl:value-of select="translate(translate(@case, '()', ''), ' ', '_')" /></xsl:variable>
                        <xsl:variable name="descriptor">
                            <xsl:choose>
                                <xsl:when test="normalize-space(description) != ''"><xsl:value-of select="concat(': ', description)" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="''" /></xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <li>
                            <xsl:if test="contains(@case, 'Workflow')">
                                <xsl:attribute name="class">workflow-step-item</xsl:attribute>
                            </xsl:if>
                            <a><xsl:attribute name="href"><xsl:value-of select="concat('#', @case)" /></xsl:attribute><xsl:value-of select="@case" /></a>
                            <xsl:value-of select="$descriptor" />
                        </li>
                    </xsl:for-each>
                </ol>
                <span>----</span>
                <xsl:apply-templates select="tests/test[not(contains(@case, 'Evaluation Warning')) and count(./step[@publicised='Y' or @publicised='T' or @publicised='I' or @publicised='O']) > 0]" />
           </body>
        </html>
	</xsl:template>

    <xsl:template match="tests/test[not(contains(@case, 'Evaluation Warning')) and count(./step[@publicised='Y' or @publicised='T' or @publicised='I' or @publicised='O']) > 0]">
        <xsl:variable name="current_test"><xsl:value-of select="translate(translate(@case, '()', ''), ' ', '_')" /></xsl:variable>
        <xsl:variable name="descriptor">
            <xsl:choose>
                <xsl:when test="normalize-space(description) != ''"><xsl:value-of select="concat(' ', description)" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="''" /></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <h3>
            <xsl:attribute name="id"><xsl:value-of select="@case" /></xsl:attribute>
            <xsl:attribute name="name"><xsl:value-of select="@case" /></xsl:attribute>
            <xsl:value-of select="concat('(', position(), ') ', @case)" />
        </h3>
        <span><i><xsl:value-of select="$descriptor" /></i></span>
        <h4><xsl:value-of select="'Composite Step(s):'" /></h4>
        <ol>
            <xsl:for-each select="step[(@publicised='Y' or @publicised='T' or @publicised='I' or @publicised='O') and @action != 'Pause']">
                <li>
                    <span>
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="@action='Add' or @action='Cancel' or @action='Enter' or @action='Tick' or @action='Select'">action-data-entry</xsl:when>
                                <xsl:when test="@action='Find' or @action='Generate Data' or @action='Include' or @action='Load' or @action='Perform' or @action='Run' or @action='Deliver'">action-key-action</xsl:when>
                                <xsl:when test="@action='Accept' or @action='DoubleClick' or @action='Move To' or @action='Pause' or @action='Continue After' or @action='Click' or @action='Tap' or @action='Terminate'">action-navigation</xsl:when>
                                <xsl:when test="@action='Capture' or @action='Check' or @action='Export' or @action='Analyse'">action-validation</xsl:when>
                                <xsl:otherwise>action-uncategorized</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="@action" />
                    </span>
                    <xsl:if test="@input != '-'">
                        <xsl:choose>
                            <xsl:when test="contains(@input, '{') or contains(@input, '[')"><xsl:value-of select="concat(' ', @input)" /></xsl:when>
                            <xsl:when test="contains(@input, ' AND ')"><xsl:value-of select="concat(' [', @input, ']')" /></xsl:when>
                            <xsl:otherwise><xsl:text> '</xsl:text><xsl:value-of select="@input" /><xsl:text>'</xsl:text></xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="@verb != '-'"><xsl:value-of select="concat(' ', @verb)" /></xsl:if>
                    <xsl:if test="@element != '-' and @outcome != '[CASE EDIT]'">
                        <xsl:choose>
                            <xsl:when test="@outcome='[SCREENSHOT]'"></xsl:when>
                            <xsl:when test="contains(@element, '[')"><xsl:value-of select="concat(' ', @element)" /></xsl:when>
                            <xsl:otherwise><xsl:text> '</xsl:text><xsl:value-of select="@element" /><xsl:text>'</xsl:text></xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="@outcome != '-'"><xsl:value-of select="concat(' ', @outcome)" /></xsl:if>
                    <xsl:if test="hints != '-'">
                        <span class="annotation-anchor"><strong><xsl:value-of select="' A'" /></strong></span>
                    </xsl:if>
                    <xsl:if test="@publicised='T' or @publicised='I' or @publicised='O'">
                        <div class="fixed-inline-box">
                            <xsl:value-of select="@publicised" />
                        </div>
                    </xsl:if>
                </li>
            </xsl:for-each>
        </ol>
        <xsl:choose>
            <xsl:when test="count(assertions[not(contains(@seq, 'checks') or contains(@seq, 'csv'))]/assertion) &gt; 0">
                <h4>Input(s):</h4>
                <table class="main">
                    <tr>
                        <td>
                            <xsl:for-each select="assertions[not(contains(@seq, 'checks') or contains(@seq, 'csv'))]/assertion">
                                <xsl:if test="(position() mod 2) = 1">
                                    <xsl:call-template name="render-inner-table">
                                        <xsl:with-param name="pos" select="position()" />
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                        <td>
                            <xsl:for-each select="assertions[not(contains(@seq, 'checks') or contains(@seq, 'csv'))]/assertion">
                                <xsl:if test="(position() mod 2) = 0">
                                    <xsl:call-template name="render-inner-table">
                                        <xsl:with-param name="pos" select="position()" />
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                        </td>
                    </tr>
                </table>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <xsl:if test="count(assertions[contains(@seq, 'checks')]/assertion) > 0">
            <h4>Expected Result(s) and Outcome(s): <span class="emphasis"><i><xsl:value-of select="' (P= PASS; F = FAIL; S=SKIP)'" /></i></span></h4>
            <xsl:for-each select="assertions[contains(@seq, 'checks')]/assertion">
                <xsl:if test="(position() mod 2) = 1">
                    <xsl:call-template name="render-wide-table">
                        <xsl:with-param name="pos" select="position()" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <span>----</span><br />
        <span class="annotation-text"><strong>Annotation for Step # ...</strong></span><br />
        <!-- switch next block on to attempt implementing real anchors -->
        <!--
        <xsl:for-each select="step[(@publicised='Y' or @publicised='T' or @publicised='I' or @publicised='O') and @action != 'Pause']/hints[text() != '-']">
            <span class="annotation-anchor">
                <xsl:attribute name="id"><xsl:value-of select="concat(ancestor::test[1]/@case, '-', position())" /></xsl:attribute>
                <xsl:value-of select="concat(position(), ' ')" />
            </span>
            <span class="annotation-text"><xsl:value-of select="." /></span><br />
        </xsl:for-each>
        -->
        <xsl:for-each select="step[(@publicised='Y' or @publicised='T' or @publicised='I' or @publicised='O') and @action != 'Pause']/hints">
            <xsl:if test="text() != '-'">
                <span class="annotation-anchor"><xsl:value-of select="concat(position(), ' ')" /></span>
                <span class="annotation-text"><xsl:value-of select="." /></span><br />
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="position() != last()"><hr /></xsl:if>
    </xsl:template>
    <xsl:template name="render-wide-table">
        <xsl:param name="pos" />
        <!-- reintroduce only if necessary to show the record number-->
        <!--
        <br /><strong><xsl:value-of select="concat('Record ', $pos)" /></strong><br />
        -->
        <div class="outer">
            <div class="quote">
                <table class="main">
                    <xsl:for-each select="tr">
                        <tr>
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:for-each select="th">
                                        <td>
                                            <xsl:if test="position()=1"><xsl:attribute name="class">start-column</xsl:attribute></xsl:if>
                                            <xsl:if test="position()=last()"><xsl:attribute name="class">end-column</xsl:attribute></xsl:if>
                                            <strong><xsl:value-of select="." /></strong>
                                        </td>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="td">
                                        <td><pre><xsl:value-of select="." disable-output-escaping="yes" /></pre></td>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="render-inner-table">
        <xsl:param name="pos" />
        <!-- reintroduce only if necessary to show the record number-->
        <!--
        <br /><strong><xsl:value-of select="concat('Record ', $pos)" /></strong><br />
        -->
        <div class="outer">
            <div class="quote">
                <table class="sub">
                    <xsl:for-each select="tr">
                        <tr>
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:for-each select="th">
                                        <td><strong><xsl:value-of select="." /></strong></td>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="td">
                                        <td><xsl:value-of select="." /></td>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
