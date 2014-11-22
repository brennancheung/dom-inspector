gulp = require 'gulp'
jade = require 'gulp-jade'
watch = require 'gulp-watch'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
rimraf = require 'rimraf'
plumber = require 'gulp-plumber'
gulpFilter = require 'gulp-filter'
livereload = require 'gulp-livereload'
runSequence = require 'run-sequence'

Server = require './server/server'

paths =
    build: "./build"
    jade:  [
        "src/**/*.jade"
        "!src/layouts/**/*"
    ]
    css: [
        "src/**/*.css"
        "src/**/*.styl"
        "!src/vendor/**/*"
    ]
    js: [
        "src/**/*.js"
        "src/**/*.coffee"
        "!src/vendor/**/*"
    ]
    static: [
        "src/assets/**/*"
        "src/**/*.jpg"
        "src/**/*.jpeg"
        "src/**/*.png"
        "src/**/*.gif"
        "src/**/*.html"
        "src/**/*.json"
    ]
outputPath = paths.build

env = process.env.NODE_ENV || 'development'
development = env is 'development'
production = env is 'production'

jadeOptions =
    pretty: development
    data:
        env: env

console.log jadeOptions

gulp.task 'default', ->
    runSequence 'clearscreen', 'build', 'server', 'watch'


gulp.task 'clearscreen', ->
    console.log '\u001B[2J\u001B[0;0f'


# Make the various assets from 'src' and store them in 'build'
gulp.task 'build', (cb) ->
    runSequence 'clean', 'static-assets', 'jade', 'css', 'js', cb


gulp.task 'clean', (cb) ->
    rimraf.sync paths.build
    cb()


gulp.task 'static-assets', ->
    gulp.src paths.static, {base: "./src/"}
        .pipe gulp.dest outputPath


gulp.task 'jade', ->
    gulp.src paths.jade
        .pipe jade jadeOptions
        .pipe gulp.dest outputPath


gulp.task 'css', ->
    stylusFilter = gulpFilter "**/*.styl"
    sources = gulp.src paths.css
        .pipe stylusFilter
        .pipe stylus()
        .pipe stylusFilter.restore()
        .pipe gulp.dest outputPath


gulp.task 'js', ->
    coffeeFilter = gulpFilter "**/*.coffee"
    sources = gulp.src paths.js
        .pipe coffeeFilter
        .pipe coffee()
        .pipe coffeeFilter.restore()
        .pipe gulp.dest outputPath


gulp.task 'watch', ->
    watch paths.jade
        .pipe plumber()
        .pipe jade jadeOptions
        .pipe gulp.dest outputPath

    stylusFilter = gulpFilter "**/*.styl"
    watch paths.css
        .pipe plumber()
        .pipe stylusFilter
        .pipe stylus()
        .pipe stylusFilter.restore()
        .pipe gulp.dest outputPath

    coffeeFilter = gulpFilter "**/*.coffee"
    watch paths.js
        .pipe plumber()
        .pipe coffeeFilter
        .pipe coffee()
        .pipe coffeeFilter.restore()
        .pipe gulp.dest outputPath

    livereload.listen()
    watch("#{outputPath}/**/*")
        .pipe livereload()


gulp.task 'server', ->
    config = {}
    server = new Server(config)
    server.start()
