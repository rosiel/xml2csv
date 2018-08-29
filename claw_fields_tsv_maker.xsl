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
        Uses the mappings from the CLAW MIG Spring Prep Mapping spreadsheet, at 
        https://docs.google.com/spreadsheets/d/18u2qFJ014IIxlVpM3JXfDEFccwBZcoFsjbBGpvL0jJI/edit#gid=0.
        The mapped XPaths are used to create column headers.
    -->
    <xsl:template name="headerRow">
        <xsl:text>titleInfo[not(@type)]&#9;</xsl:text>
        <xsl:text>titleInfo[@type='translated']</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>titleInfo[@type='alternative' or @type='abbreviated' or @type='uniform']</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>name</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>identifier</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>accessCondition</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>originInfo/dateOther</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>originInfo/dateIssued</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>originInfo/dateCreated</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>physicalDescription/extent</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>typeOfResource</xsl:text>
        <xsl:value-of select="$partition"/>
        <xsl:text>physicalDescription/internetMediaType</xsl:text>
        <!-- New line for next record -->
        <xsl:text>&#xa;</xsl:text>
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
        
        <!-- START AGENT WORK -->
        
        <!-- Cell value for Agent (with fields "Linked Agent" and "Role") -->
        <xsl:for-each select="name[not(role/roleTerm)]">
            <xsl:call-template name="agent"/>
        </xsl:for-each>
        <!-- Cell value for Agent (with Role of "Author") -->
        <xsl:for-each select="name[role/roleTerm='aut']|name[role/roleTerm=lower-case('author')]">
            <xsl:call-template name="agent"/>
        </xsl:for-each>
        <!-- Cell value for Agent (with Role of "Contributor") -->
        <xsl:for-each select="name[role/roleTerm='ctb']|name[role/roleTerm=lower-case('contributor')]">
            <xsl:call-template name="agent"/>
        </xsl:for-each>
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