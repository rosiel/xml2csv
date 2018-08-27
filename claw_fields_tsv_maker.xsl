<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:mods="http://www.loc.gov/mods/v3"
    version="2.0"
    >
    
    <xsl:output method="text"/>
    
    <xsl:variable name="partition" select="'&#9;'"/>
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
        <xsl:text>Title&#9;Title (in a different language)&#9;Alternative Title&#9;Agent (with fields &quot;Linked Agent&quot; and &quot;Role&quot;)&#9;Agent (with Role of &quot;Author&quot;)&#9;Agent (with Role of &quot;Contributor&quot;)&#9;Agent (with various Role values)&#9;Identifier&#9;Rights [multi-valued field]&#9;Date&#9;Date Issued&#9;Date Created&#9;dc:format&#9;dcterms:type&#9;Mime Type&#xa;</xsl:text>
    </xsl:template>
    <!-- End header row -->
    
    <!-- Begin building record rows, one row per "mods" element in source document -->
    <xsl:template match="mods">
        
        <!-- Cell value for Title -->
        <xsl:for-each select="titleInfo[not(@type)]">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Title (in a different language) -->
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
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Alternative Title -->
        <xsl:for-each select="titleInfo[@type='alternative' or @type='abbreviated' or @type='uniform']">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Agent (with fields "Linked Agent" and "Role") -->
        <xsl:for-each select="name[not(role/roleTerm)]">
            <xsl:call-template name="agent"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Agent (with Role of "Author") -->
        <xsl:for-each select="name[role/roleTerm='aut']|name[role/roleTerm=lower-case('author')]">
            <xsl:call-template name="agent"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Agent (with Role of "Contributor") -->
        <xsl:for-each select="name[role/roleTerm='ctb']|name[role/roleTerm=lower-case('contributor')]">
            <xsl:call-template name="agent"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Agent (with various Role values) -->
       
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Identifier -->
        <xsl:for-each select="identifier">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Rights [multi-valued field] -->
        <xsl:for-each select="accessCondition">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Date] -->
        <xsl:for-each select="originInfo/dateOther">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Date Issued] -->
        <xsl:for-each select="originInfo/dateIssued">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Date Created] -->
        <xsl:for-each select="originInfo/dateCreated">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for dc:format] -->
        <xsl:for-each select="physicalDescription/extent">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for dc:typeOfResource] -->
        <xsl:for-each select="typeOfResource">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$partition"/>
        
        <!-- Cell value for Mime Type] -->
        <xsl:for-each select="physicalDescription/internetMediaType">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        
        <!-- New line for next record -->
        <xsl:text>&#xa;</xsl:text>
        
    </xsl:template>
    
    <xsl:template name="cell">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position()!=last()">
            <xsl:text>||</xsl:text>
        </xsl:if>
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
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position()!=last()">
            <xsl:text>||</xsl:text>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>