<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0"
    >
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:call-template name="headerRow"/>
        <xsl:apply-templates select="modsCollection/mods"/>
    </xsl:template>
    
    <!-- Begin header row -->
    <!-- 
        Uses the Field Name in Drupal values from the CLAW MIG Spring Prep Mapping spreadsheet, at 
        https://docs.google.com/spreadsheets/d/18u2qFJ014IIxlVpM3JXfDEFccwBZcoFsjbBGpvL0jJI/edit#gid=0 to create column headers.
        
        Note: mods/physicalDescription/extent and mods/typeOfResource had no value in this column, so their RDF mapping value was used instead. 
    -->
    <xsl:template name="headerRow">
        <xsl:text>Title,Title (in a different language),Alternative Title,Agent (with fields &quot;Linked Agent&quot; and &quot;Role&quot;),Agent (with Role of &quot;Author&quot;),Agent (with Role of &quot;Contributor&quot;),Agent (with various Role values),Identifier,Rights [multi-valued field],Date,Date Issued,Date Created,dc:format,dcterms:type,Mime Type&#xa;</xsl:text>
    </xsl:template>
    <!-- End header row -->
    
    <!-- Begin building record rows, one row per "mods" element in source document -->
    <xsl:template match="mods">
        
        <!-- Cell value for Title -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="titleInfo[not(@type)]">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Title (in a different language) -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="titleInfo[@type='translated']">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="@xml:lang">
                <xsl:text> [</xsl:text>
                <xsl:value-of select="@xml:lang"/>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Alternative Title -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="titleInfo[@type='alternative' or @type='abbreviated' or @type='uniform']">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Agent (with fields "Linked Agent" and "Role") -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="name[not(role/roleTerm)]">
            <xsl:call-template name="agent"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Agent (with Role of "Author") -->
        <xsl:text>&quot;</xsl:text>
<!--        <xsl:for-each select="name[role/roleTerm eq lower-case('author') or 'aut']">
            <xsl:call-template name="agent"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>-->
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Agent (with Role of "Contributor") -->
        <xsl:text>&quot;</xsl:text>

        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Agent (with various Role values) -->
        <xsl:text>&quot;</xsl:text>
        
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Identifier -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="identifier">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Rights [multi-valued field] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="accessCondition">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Date] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="originInfo/dateOther">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Date Issued] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="originInfo/dateIssued">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Date Created] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="originInfo/dateCreated">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for dc:format] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="physicalDescription/extent">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for dc:typeOfResource] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="typeOfResource">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;,</xsl:text>
        
        <!-- Cell value for Mime Type] -->
        <xsl:text>&quot;</xsl:text>
        <xsl:for-each select="physicalDescription/internetMediaType">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&quot;</xsl:text>
        
        <!-- New line for next record -->
        <xsl:text>&#xa;</xsl:text>

    </xsl:template>
    
    <xsl:template name="agent">
        <xsl:choose>
            <xsl:when test="namePart[@type='family']">
                <xsl:value-of select="namePart[@type='family']"/>
                <xsl:if test="namePart[@type='given']">
                    <xsl:text>,</xsl:text>
                    <xsl:for-each select="namePart[@type='given']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="."/>    
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>