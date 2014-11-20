###
This is an EXAMPLE config, you'll need to make edits
###

exports.config =

  # location of source documents
  from:
    host: '127.0.0.1'
    port: '8080'
    core: '/core4'
    path: '/solr'

  # copy destination
  to:
    host: '127.0.0.1',
    port: '8080',
    core: '/core5',
    path: '/solr'

  # this query will be executed against the "from" documents to select to documents to move
  query:'*:*'

  # number of rows per fetch.  Have to do some trial and error here to throttle this just right
  # to get both a decent speed and keep safe from memory issues.  If duplicate is used, have to
  # factor that in as well
  rows:250

  # the number (0 based) of the first row to fetch.  Useful if a large copy operation fails midway
  # and you need to start up again as some place other than the first record.
  start:0

  # This'll allow you to multiply your data by simply taking each record, modifying the id field to be
  # unique, and adding it an extra number of times to the index.  numberOfTimes = 2, means that each document
  # will be added to the index 3 times total.
  duplicate:
    enabled: false
    idField:'docid'
    numberOfTimes: 2

  # When true copy is ignored and documents are copied verbatim
  clone: false

  # fields to straight copy over
  copy:['docid','title']

  # fields that get copied over, but get their names changed to something else
  transform:[{
    source:'title'
    destination:'summary'
  },{
    source:'country'
    destination:'countryName'
  }]

  # brand new fields, great for filling in test data
  # {name} is the name of the field and fabricate is the method called to create the test data
  # it is passed the fields already created for the document, as well as number row the document is
  # in processing
  fabricate:[{
    name: 'language'
    fabricate:(fields, index) ->
      switch index % 5
        when 0 then 'Swahili'
        when 1 then 'Klingon'
        when 2 then 'Skrull'
        when 3 then 'Pig Latin'
        when 4 then 'English'
  }, {
    name: 'agency'
    fabricate:(fields, index) ->
      switch index % 5
        when 0 then 'DIA'
        when 1 then 'OMGWTFBBQ'
        when 2 then 'MI6'
        when 3 then 'KGB'
        when 4 then 'FBI'
  }]