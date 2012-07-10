path = require 'path'
solr = require 'solr'
_ =    require 'underscore'

class SolrToSolr

  go: (@config) ->
    @sourceClient = solr.createClient(@config.from)
    @destClient   = solr.createClient(@config.to)
    @nextBatch(0)

  nextBatch: (start) ->
    console.log "Querying starting at #{start}"
    @sourceClient.query @config.query, {rows:@config.rows, start:start}, (err, response) =>
      return console.log "Some kind of solr query error #{err}" if err?
      responseObj = JSON.parse response

      newDocs = @prepareDocuments(responseObj.response.docs, start)
      @writeDocuments newDocs, =>
        start += @config.rows
        if responseObj.response.numFound > start
          @nextBatch(start)
        else
          @destClient.commit()

  prepareDocuments: (docs, start) =>
    for doc in docs
      newDoc = {}
      newDoc[copyField]             = doc[copyField]               for copyField in @config.copy
      newDoc[transform.destination] = doc[transform.source]        for transform in @config.transform
      newDoc[fab.name]              = fab.fabricate(newDoc, start) for fab       in @config.fabricate
      start++
      newDoc

  writeDocuments: (documents, done) ->
    docs = []
    docs.push documents
    if @config.duplicate.enabled
      for doc in documents
        for num in [0..@config.duplicate.numberOfTimes]
          newDoc = _.extend({}, doc)
          newDoc[@config.duplicate.idField] = "#{doc[@config.duplicate.idField]}-#{num}"
          docs.push newDoc

    @destClient.add _.flatten(docs), (err) =>
      console.log err if err
      @destClient.commit()
      done()

exports.go = (config) ->
  (new SolrToSolr()).go(config)
