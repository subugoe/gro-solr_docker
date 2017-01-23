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
    <xsl:template match="fieldType[@name='text_general']">
        <xsl:comment>Template patch as proposed by Peter</xsl:comment>
        <fieldType name="text_general" class="solr.TextField" positionIncrementGap="100" multiValued="true">
            <analyzer type="index">
                <tokenizer class="solr.StandardTokenizerFactory"/>
                <filter class="solr.StopFilterFactory" words="stopwords.txt" ignoreCase="true"/>
                <filter class="solr.LowerCaseFilterFactory"/>
                <filter class="solr.ASCIIFoldingFilterFactory"/>
            </analyzer>
            <analyzer type="query">
                <tokenizer class="solr.StandardTokenizerFactory"/>
                <filter class="solr.StopFilterFactory" words="stopwords.txt" ignoreCase="true"/>
                <filter class="solr.SynonymFilterFactory" expand="true" ignoreCase="true" synonyms="synonyms.txt"/>
                <filter class="solr.LowerCaseFilterFactory"/>
                <filter class="solr.ASCIIFoldingFilterFactory"/>
            </analyzer>
        </fieldType>
    </xsl:template>
    
</xsl:stylesheet>