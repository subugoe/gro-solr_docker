solr Image for GRO Project in docker
====================================

Purpose
-------

This Docker image can be used to have a local Instance of the
[Grid.ac](https://grid.ac/) (Global Research Identifier Database) data. This way
you can even query the data offline.

Usage
-----

You need to build the image first.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ docker build --no-cache --tag grid-solr --force-rm  .
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Then you can start the image.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ docker run -p 8983:8983 grid-solr
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Point your browser to [localhost:8983](http://localhost:8983/solr/).
