<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Test Report</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          h2 { color: #003366; }
          table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
          th, td { border: 1px solid #ccc; padding: 6px 10px; text-align: left; }
          th { background-color: #f2f2f2; }
        </style>
      </head>
      <body>
        <h1>Test Report Summary</h1>
        <xsl:for-each select="tests/test">
          <h2><xsl:value-of select="@case"/></h2>
          <table>
            <tr>
              <xsl:for-each select="step[1]/*">
                <th><xsl:value-of select="name()"/></th>
              </xsl:for-each>
            </tr>
            <xsl:for-each select="step">
              <tr>
                <xsl:for-each select="*">
                  <td><xsl:value-of select="."/></td>
                </xsl:for-each>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
