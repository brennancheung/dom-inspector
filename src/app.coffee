angular.module 'dom-nav', []

angular.module('dom-nav').config ->

angular.module('dom-nav').run ->
    console.log "App started.  Prepare for awesomeness!"

angular.module('dom-nav').filter 'yaml', ->
    (input) ->
        jsyaml.dump input, {indent: 2}

angular.module('dom-nav').filter 'truncateString', ->
    (input, length=5) ->
        return input unless typeof input is 'string'
        return input if input.length < length
        input.slice(0,length) + "..."

