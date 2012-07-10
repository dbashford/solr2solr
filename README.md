solr2solr - a simple solr migration and test data frabrication tool
============

This tool will query a given Solr index and copy it to another.  Along the way it will give you the opportunity to change field names, drop fields altogether, and fabricate new fields.

The goal of this tool isn't to be a suitable means to move large production indices around, though if your index is smallish, it will serve that purpose.  It is instead meant to facilitate the development lifecycle during which schemas are constantly changing and real data isn't yet available, or isn't available in a quantity to stress Solr.

## Install

solr2solr is a command line tool and should ideally be installed with `-g`

    $ npm install -g solr2solr

## Configuration

  Copy the [example config file](https://github.com/dbashford/solr2solr/blob/master/config.coffee) from the root of the github repo into a directory on your machine.

`from` and `to` are pass through configurations to the [node-solr](https://github.com/gsf/node-solr) library.  These are the defaults:
```
var DEFAULTS = {
  host: '127.0.0.1',
  port: '8983',
  core: '', // if defined, should begin with a slash
  path: '/solr' // should also begin with a slash
}
```


`query` is used to hit the `from` Solr for documents.  Leave this at `*:*` if you want to copy everything, or change it to something else if you want to copy a smaller set of documents.

`rows` indicates how many rows to copy at a time.  solr2solr will go through your index from start to finish by this increment.  This increment is important because based on the size of a document in your index, and how many times you might want that document duplicated (see `duplicate` below), you'll want to play with this number to keep your node process from running out of memory.

`duplicate` is a configuration will allow you to multiply your index during the copy.  When duplicate has `enabled` set to `true`, solr2solr will manipulate the `idField` of your document to make it unique and it will create an extra document per `numberOfTimes`.  So, if `numberOfTimes` is set to 2, you'll get 2 copies of every document.  The original, and 2 dupes.

`copy` is a list of fields to copy from index to index verbatim.

`transform` is a list of fields to copy from index to index while changing the field name from `source` to `destination`.

`fabricate` is a list of new fields to create per document in the new index.  The name of the new field is given in the field `name`, and the data for that field is created by the `fabricate` function, which is passed the document and the row number being processed.
```
fabricate:(fields, index) ->
  switch index % 5
    when 0 then 'Swahili'
    when 1 then 'Klingon'
    when 2 then 'Skrull'
    when 3 then 'Pig Latin'
    when 4 then 'English'
}
```

## Execution

From the same directory you placed the config file, simply execute

    $ solr2solr

and the tool will begin copying data.