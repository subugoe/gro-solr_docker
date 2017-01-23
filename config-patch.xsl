<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="schemaFactory[@class='ManagedIndexSchemaFactory']">
        <xsl:comment>Template patch as proposed by Peter</xsl:comment>
        <schemaFactory class="ClassicIndexSchemaFactory"/>      
    </xsl:template>
    <xsl:template match="processor[@class='solr.AddSchemaFieldsUpdateProcessorFactory']"/>
</xsl:stylesheet>