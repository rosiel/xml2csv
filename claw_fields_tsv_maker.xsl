<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:mods="http://www.loc.gov/mods/v3"
    version="2.0"
    >
    
    <xsl:output method="text"/>
    
    <!-- Sets the field separator with a variable; 
        if necessary, it can be reset throughout -->
    <xsl:variable name="separator" select="'&#9;'"/>
    
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
        <xsl:text>7.X PID</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>titleInfo[not(@type)]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>titleInfo[@type='translated'] [[@xml:lang]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>titleInfo[@type='alternative' or @type='abbreviated' or @type='uniform']</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>personal name/namePart[not(@type)] or name/displayForm [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>personal name/namePart[@type] [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>corporate name/namePart[not(@type)] or name/displayForm [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>corporate name/namePart[@type] [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>conference name/namePart[not(@type)] or name/displayForm [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>conference name/namePart[@type] [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>family name/namePart[not(@type)] or name/displayForm [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>family name/namePart[@type] [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>untyped name/namePart[not(@type)] or name/displayForm [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>untyped name/namePart[@type] [[role]]</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>identifier</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>accessCondition</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>originInfo/dateOther</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>originInfo/dateIssued</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>originInfo/dateCreated</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>physicalDescription/extent</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>typeOfResource</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:text>physicalDescription/internetMediaType</xsl:text>
        <!-- New line for next record -->
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <!-- End header row -->
    
    <!-- Begin building record rows, one row per <mods> element in source document -->
    <xsl:template match="mods">
        
        <!-- Cell value for 7.X PID -->
        <xsl:for-each select="identifier[@displayLabel='7.X PID']">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Main Title -->
        <xsl:for-each select="titleInfo[not(@type)]">
            <xsl:call-template name="titleInfo"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Translated Title;
            Value of @xml:lang in double square brackets. -->
        <xsl:for-each select="titleInfo[@type='translated']">
            <xsl:call-template name="titleInfo"/>
            <xsl:if test="@xml:lang">
                <xsl:text> [[xml:lang=</xsl:text>
                <xsl:value-of select="@xml:lang"/>
                <xsl:text>]]</xsl:text>
            </xsl:if>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Alternative Title -->
        <xsl:for-each select="titleInfo[@type='alternative' or @type='abbreviated' or @type='uniform']">
            <xsl:call-template name="titleInfo"/>
            <xsl:if test="position()!=last()">
                <xsl:text>||</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Simple Personal Name -->
        <xsl:for-each select="name[@type='personal'][displayForm or namePart[not(@type)]]">
            <xsl:call-template name="simpleName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Compound Personal Name -->
        <xsl:for-each select="name[@type='personal'][namePart[@type]]">
            <xsl:call-template name="compoundName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Simple Corporate Name -->
        <xsl:for-each select="name[@type='corporate'][displayForm or namePart[not(@type)]]">
            <xsl:call-template name="simpleName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Compound Corporate Name -->
        <xsl:for-each select="name[@type='corporate'][namePart[@type]]">
            <xsl:call-template name="compoundName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Simple Conference Name -->
        <xsl:for-each select="name[@type='conference'][displayForm or namePart[not(@type)]]">
            <xsl:call-template name="simpleName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Compound Conference Name -->
        <xsl:for-each select="name[@type='conference'][namePart[@type]]">
            <xsl:call-template name="compoundName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Simple Family Name -->
        <xsl:for-each select="name[@type='family'][displayForm or namePart[not(@type)]]">
            <xsl:call-template name="simpleName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Compound Family Name -->
        <xsl:for-each select="name[@type='family'][namePart[@type]]">
            <xsl:call-template name="compoundName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Simple Un-Typed Name -->
        <xsl:for-each select="name[not(@type)][displayForm or namePart[not(@type)]]">
            <xsl:call-template name="simpleName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Compound Un-Typed Name -->
        <xsl:for-each select="name[not(@type)][namePart[@type]]">
            <xsl:call-template name="compoundName"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Identifier;
        Omits the 7.x PID identifier created by mods_xml_merge.xsl -->
        <xsl:for-each select="identifier[not(@displayLabel='7.X PID')]">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Rights -->
        <xsl:for-each select="accessCondition">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Date Other -->
        <xsl:for-each select="originInfo/dateOther">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Date Issued] -->
        <xsl:for-each select="originInfo/dateIssued">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Date Created] -->
        <xsl:for-each select="originInfo/dateCreated">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Extent] -->
        <xsl:for-each select="physicalDescription/extent">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
        <!-- Cell value for Type Of Resource] -->
        <xsl:for-each select="typeOfResource">
            <xsl:call-template name="cell"/>
        </xsl:for-each>
        <xsl:value-of select="$separator"/>
        
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
    
    <xsl:template name="simpleName">
        <xsl:choose>
            <xsl:when test="displayForm">
                <xsl:for-each select="displayForm">
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="namePart[not(@type)]">
                <xsl:for-each select="namePart[not(@type)]">
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
        <xsl:call-template name="role"/>
        <xsl:if test="position() != last()">
            <xsl:text>||</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="compoundName">
        <xsl:for-each select="namePart[@type]">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text> [[type=</xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:text>]]</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:text>. </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:call-template name="role"/>
        <xsl:if test="position() != last()">
            <xsl:text>||</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="role">
        <xsl:choose>
            <xsl:when test="role">
                <xsl:choose>
                    <xsl:when test="role/roleTerm[@authority='marcrelator']">
                        <xsl:text> [[marcrelators=</xsl:text>
                        <xsl:choose>
                            <xsl:when test="role/roleTerm[@authority='marcrelator'][@type='code']">
                                <xsl:value-of select="role/roleTerm[@authority='marcrelator'][@type='code']"/>    
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>NULL</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>/</xsl:text>
                        <xsl:choose>
                            <xsl:when test="role/roleTerm[@authority='marcrelator'][@type='text']">
                                <xsl:value-of select="role/roleTerm[@authority='marcrelator'][@type='text']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>NULL</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>]]</xsl:text>
                    </xsl:when>
                    <!-- If the role does not have marcrelators as its authority, 
                        then supply role of Contributor -->
                    <xsl:otherwise>
                        <xsl:text> [[marcrelators=ctb/Contributor]]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- If there is no role, then supply role of Contributor -->
            <xsl:otherwise>
                <xsl:text> [[marcrelators=ctb/Contributor]]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="titleInfo">
        <xsl:if test="nonSort">
            <xsl:value-of select="normalize-space(nonSort)"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space(title)"/>
        <xsl:if test="subTitle">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="normalize-space(subTitle)"/>
        </xsl:if>
        <xsl:if test="partName|partNumber">
            <xsl:for-each select="partName|partNumber">
                <xsl:text>. </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position()=last()">
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>