<?xml version="1.0" encoding="UTF-8"?>
<!--
# Copyright © 2024 UJX Ltd. All rights reserved.
# See LICENSE.txt for details.
-->
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:y="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40"
  exclude-result-prefixes="y o x ss html"
 >
    <xsl:output method="xml" indent="yes" cdata-section-elements="hints description td" />
    <xsl:template match="/y:Workbook">
        <tests>
            <metadata>
                <document_properties>
                    <xsl:for-each select="//y:Worksheet[contains(@ss:Name, 'About')]/descendant::y:Row">
                        <prop>
                            <xsl:attribute name="attrib"><xsl:value-of select="y:Cell[1]/y:Data" /></xsl:attribute>
                            <xsl:attribute name="setting"><xsl:value-of select="y:Cell[2]/y:Data" /></xsl:attribute>
                        </prop>
                    </xsl:for-each>
                </document_properties>
                <prereqs>
                    <xsl:for-each select="//y:Worksheet[contains(@ss:Name, 'Prerequisites')]/descendant::y:Row[position() > 1]">
                        <item>
                            <xsl:value-of select="y:Cell[1]/y:Data" />
                        </item>
                    </xsl:for-each>
                </prereqs>
            </metadata>
            <xsl:apply-templates select="//y:Worksheet[not(contains(@ss:Name, '+')) and not(contains(@ss:Name, '->')) and not(contains(@ss:Name, '(ALT)'))]"/>
        </tests>
    </xsl:template>

    <xsl:template match="//y:Worksheet[not(contains(@ss:Name, '+')) and not(contains(@ss:Name, '->')) and not(contains(@ss:Name, '(ALT)'))]">
        <test>
            <xsl:variable name="current_test"><xsl:value-of select="@ss:Name" /></xsl:variable>
            <xsl:attribute name="case"><xsl:value-of select="$current_test" /></xsl:attribute>
            <description>
                <xsl:choose>
                    <xsl:when test="//y:Worksheet[@ss:Name='->Playbook']/descendant::y:Row[y:Cell/y:Data/text()=$current_test]/y:Cell[2]/y:Data != '-'">
                        <xsl:value-of select="//y:Worksheet[@ss:Name='->Playbook']/descendant::y:Row[y:Cell/y:Data/text()=$current_test]/y:Cell[2]/y:Data" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''" />
                    </xsl:otherwise>
                </xsl:choose>
            </description>
            <xsl:for-each select="y:Table/y:Row[position() &gt; 2]">
                <step>
                    <xsl:attribute name="action"><xsl:value-of select="y:Cell[2]/y:Data" /></xsl:attribute>
                    <xsl:attribute name="input"><xsl:value-of select="y:Cell[3]/y:Data" /></xsl:attribute>
                    <xsl:attribute name="verb"><xsl:value-of select="y:Cell[4]/y:Data" /></xsl:attribute>
                    <xsl:attribute name="element"><xsl:value-of select="y:Cell[5]/y:Data" /></xsl:attribute>
                    <xsl:attribute name="outcome"><xsl:value-of select="y:Cell[6]/y:Data" /></xsl:attribute>
                    <xsl:attribute name="automated">
                        <xsl:choose>
                            <xsl:when test="y:Cell[7]/y:Data='y' or y:Cell[7]/y:Data='Y'">Y</xsl:when>
                            <xsl:otherwise>N</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="publicised">
                        <xsl:choose>
                            <xsl:when test="y:Cell[9]/y:Data='y' or y:Cell[9]/y:Data='Y'">Y</xsl:when>
                            <xsl:when test="y:Cell[9]/y:Data='t' or y:Cell[9]/y:Data='T'">T</xsl:when>
                            <xsl:when test="y:Cell[9]/y:Data='i' or y:Cell[9]/y:Data='I'">I</xsl:when>
                            <xsl:when test="y:Cell[9]/y:Data='o' or y:Cell[9]/y:Data='O'">O</xsl:when>
                            <xsl:otherwise>N</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <hints><xsl:value-of select="y:Cell[8]/y:Data" /></hints>
                </step>
            </xsl:for-each>
            <xsl:for-each select="//y:Worksheet[contains(@ss:Name, concat($current_test, ' +'))]">
                <assertions>
                    <xsl:attribute name="seq"><xsl:value-of select="concat('Assertions - ', @ss:Name)" /></xsl:attribute>
                    <assertion title="Assertions - Pick List Entries">
                        <xsl:for-each select="y:Table/y:Row[position() &gt; 1 and string-length(normalize-space(.))]">
                            <tr>
                                <xsl:choose>
                                    <xsl:when test="position() = 1">
                                        <xsl:for-each select="y:Cell/y:Data">
                                            <th><xsl:value-of select="."/></th>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="y:Cell/y:Data">
                                            <td><xsl:value-of select="."/></td>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </tr>
                        </xsl:for-each>
                    </assertion>
                </assertions>
            </xsl:for-each>
         </test>
    </xsl:template> 

</xsl:stylesheet>
