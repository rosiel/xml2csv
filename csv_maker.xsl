<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0"
    >
    
    <xsl:output method="text"/>
    
    <xsl:param name="headerFile">
        <xsl:text>sample_data/sample_fields.xml</xsl:text>
    </xsl:param>
    <xsl:variable name="fieldList" select="document($headerFile)"/>
        
    <xsl:template match="/">
        <xsl:call-template name="headerRow"/>
        <xsl:apply-templates select="modsCollection/mods"/>
    </xsl:template>
    
    <!-- to do: 
        * add comments
        * not getting dmGetItemInfo (deliberately, for now, but need to address)
        * subject strings - delimit sibling topics with dashes and separate subjects with semicolons
        * nameParts & roleTerms
        * further testing of titles, qualified dates
    -->
    
    <!-- Begin header row -->
    <xsl:template name="headerRow">
        <xsl:for-each select="$fieldList//field">
            <xsl:value-of select="fieldName"/>
            <xsl:choose>
                <xsl:when test="position()!=last()">
                    <xsl:text>,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <!-- End header row -->
  
    <xsl:template match="mods">
        <xsl:variable name="record" select="."/>
        <xsl:for-each select="$fieldList//field">
            <xsl:variable name="header" select="fieldName"/>
            
            <xsl:variable name="labelMatch">
                <xsl:choose>
                    <xsl:when test="contains($header, '::')">
                        <xsl:choose>
                            <xsl:when test="contains($header, '@')">
                                <xsl:value-of
                                    select="$record//*[@displayLabel = substring-before($header, ' ::')]//*[name() = substring-before(replace($header, '^.*:: ', ''), ' @')]"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="$record//*[@displayLabel = substring-before($header, ' ::')]//*[name() = replace($header, '^.*:: ', '')]"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$record//*[@displayLabel = $header]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="elementMatch">
                <xsl:choose>
                    <xsl:when test="contains($header, '@')">
                        <xsl:variable name="elementName" select="substring-before($header, ' @')"/>
                        <xsl:variable name="attName" select="substring-before(substring-after($header, ' @'),'=')"/>
                        <xsl:variable name="attValue" select="substring-before(substring-after(substring-after($header, $attName), '=&quot;'), '&quot;')"/>
                        <xsl:value-of select="$record//*[name() = $elementName][@*[name() = $attName] = $attValue]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$record//*[name() = $header]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable> 

            <xsl:variable name="value">
                <xsl:choose>
                    <xsl:when test="not(contains(xpath, 'displayLabel'))">
                        <xsl:for-each select="$elementMatch">
                            <xsl:call-template name="cell"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$labelMatch">
                        <xsl:for-each select="$labelMatch">
                            <xsl:call-template name="cell"/>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="contains($value, ',')">
                    <xsl:value-of select="concat('&quot;', $value, '&quot;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="cell">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position()!=last()">
            <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>