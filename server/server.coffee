http = require 'http'
express = require 'express'
bodyParser = require 'body-parser'

class Server
    constructor: (config = {}) ->
        @config = config
        @config.port ||= 4000

    start: ->
        @app = express()
        @app.use bodyParser.urlencoded({extended:true})
        @app.use bodyParser.json()

        @app.use (req, res, next) ->
            console.log "%s %s", req.method, req.url
            next()

        @app.use '/', express.static "#{__dirname}/../build"

        @app.all '*', (req, res) ->
            res.status(404).send "not found"

        @app.use (err, req, res, next) ->
            res.status(500).send 'internal server error'
            console.error err

        console.log "Starting server on port #{@config.port}."
        http.createServer(@app).listen @config.port

module.exports = Server
