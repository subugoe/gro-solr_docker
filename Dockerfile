FROM solr:5.5.3
MAINTAINER  Christian Mahnke (mahnke@sub.uni-goettingen.de)
#Partly taken from the pub_dev Dockerfile

USER root

ENV REQ_BUILD sudo tidy xmlstarlet jq xsltproc

# Prepare to install
# OS
RUN apt update \
    && apt upgrade -y \
    && apt dist-upgrade -y \
    && apt install --assume-yes --no-install-recommends ${REQ_BUILD}

USER $SOLR_USER

RUN wget -O - http:$(wget -O - https://grid.ac/downloads | tidy -asxml -q --clean true \
    --add-xml-decl yes --force-output yes --show-errors 0 --show-warnings no \
    --numeric-entities yes --doctype omit | xmlstarlet --no-doc-namespace \
    sel -N x=http://www.w3.org/1999/xhtml -t -v \ 
    "//x:a[contains(., 'latest')]/@href") | tidy -asxml -q --clean true \
    --add-xml-decl yes --force-output yes --show-errors 0 --show-warnings no \
    --numeric-entities yes --doctype omit |  xmlstarlet --no-doc-namespace \
    sel -N x=http://www.w3.org/1999/xhtml -t -v \ 
    "//x:script[@type = 'application/ld+json']" | jq ".distribution[0].contentUrl" | \
    xargs wget -O grid.zip && unzip grid.zip

#Clear the input file. Fixes a literal \t 
RUN sed -i -e 's/\\t//g' grid.json


# Setup Solr
COPY schema.json .
COPY schema-patch.xsl .
COPY config-patch.xsl .
RUN bin/solr start &&  bin/solr create -c grid && curl 'http://0.0.0.0:8983/solr/grid/schema' -H 'Content-type:application/json' \
    --data-binary @schema.json && \
    xsltproc schema-patch.xsl server/solr/grid/conf/managed-schema > server/solr/grid/conf/schema.xml && \
    xsltproc config-patch.xsl server/solr/grid/conf/solrconfig.xml > server/solr/grid/conf/solrconfig.xml.patched && \
    mv server/solr/grid/conf/solrconfig.xml.patched server/solr/grid/conf/solrconfig.xml

## Populate index "grid" 
RUN bin/solr start && \
    curl 'http://0.0.0.0:8983/solr/grid/update/json/docs\
?split=/institutes\
&f=id:/institutes/id\
&f=name:/institutes/name\
&f=wikipedia_url:/institutes/wikipedia_url\
&f=links:/institutes/links\
&f=types:/institutes/types\
&f=aliases:/institutes/aliases\
&f=acronyms:/institutes/acronyms\
&f=types:/institutes/type\
&f=ip_addresses:/institutes/ip_addresses\
&f=established:/institutes/established\
&f=ISNI:/institutes/external_ids/ISNI/all\
&f=FundRef:/institutes/external_ids/FundRef/all\
&f=OrgRef:/institutes/external_ids/OrgRef/all\
&f=Wikidata:/institutes/external_ids/Wikidata/all\
&f=city:/institutes/addresses/city\
&f=state:/institutes/addresses/state\
&f=state_code:/institutes/addresses/state_code\
&f=country:/institutes/addresses/country\
&f=country_code:/institutes/addresses/country_code\
&f=relationship:/institutes/relationships/label\
&f=relationship_id:/institutes/relationships/id\
&commit=true'\
    -H 'Content-type:application/json' \
    --data-binary @grid.json -X POST





EXPOSE 8983
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["solr-foreground"]