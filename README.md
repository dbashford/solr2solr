solr2solr - a simple solr migration and test data frabrication tool
============

This tool will query a given Solr index and copy it to another.  Along the way it will give you the opportunity to change field names, drop fields altogether, and fabricate new fields.

The goal of this tool isn't to be a suitable means to move large production indices around, though if your index is smallish, it will serve that purpose.  It is instead meant to facilitate the development lifecycle during which schemas are constantly changing and real data isn't yet available, or isn't available in a quantity to stress Solr.

## Install

solr2solr is a command line tool and should ideally be installed with `-g`

    $ npm install -g solr2solr

## Configuration

  Copy the [example config file](https://github.com/dbashford/solr2solr/blob/master/config-template.coffee) from the root of the github repo into a directory on your machine.

  * `from` and `to` are pass through configurations to the [node-solr](https://github.com/gsf/node-solr) library.  These are the defaults:
  ```js
  var DEFAULTS = {
    host: '127.0.0.1',
    port: '8983',
    core: '', // if defined, should begin with a slash
    path: '/solr' // should also begin with a slash
  }
  ```
  * `query` is used to hit the `from` solr for documents.  Leave this at `*:*` if you want to copy everything, or change it to something else if you want to copy a smaller set of documents


## Execution

From the same directory you placed the config file, simply execute

    $ solr2solr

and the tool will begin copying data.