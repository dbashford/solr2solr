path    = require 'path'
convert = require './solr2solr'

try
  configPath = path.resolve 'config.coffee'
  {config} = require configPath
catch err
  console.log "Cannot find config file, do you have one in this directory?"
  console.log err
  process.exit(1)

convert.go config