process.env.NODE_ENV = 'production'
process.env.CONFIG = 'config/example.ini'

gulp = require 'gulp'
pump = require 'gulp-pump'
{execSync} = require 'child_process'
config = require './config'

gulp.task 'html', ['clean'], pump ->
  files = ['index', '404']
    .concat config.routers
    .map (x) -> "views/#{x}.pug"

  require './server/pug'
  pug = require 'gulp-pug'
  data = require 'gulp-data'
  [
    gulp.src files, base: 'views'
    data (file) ->
      filename: file.history[0]
      basedir: process.cwd() + '/views/'
    pug
      locals:
        production: true
        pages: config.pages
    gulp.dest 'dist'
  ]

gulp.task 'css', ['clean'], pump ->
  stylus = require 'gulp-stylus'
  [
    gulp.src ['index', 'common', 'concact', 'version'].map (x) -> "public/css/#{x}.styl"
    stylus
      'include css': true
      compress: true
      include: process.cwd() + '/node_modules'
    gulp.dest 'dist/rev/css'
  ]

gulp.task 'js', ['clean'], pump ->
  uglify = require 'gulp-uglify'
  [
    gulp.src ['public/js/*.coffee']
    browserify()
    uglify()
    gulp.dest 'dist/rev/js'
  ]

gulp.task 'img', ['clean'], pump ->
  [
    gulp.src ['public/img/**/*', '!public/img/embed/*']
    gulp.dest 'dist/rev/img'
  ]

gulp.task 'copy', ['clean'], pump ->
  [
    gulp.src ['node_modules/jquery/dist/jquery.js']
    gulp.dest 'dist/rev/js'
  ]

gulp.task 'rev', ['css', 'js', 'img', 'copy'], pump ->
  rev = require 'gulp-rev'
  [
    gulp.src 'dist/rev/**/*', base: 'dist/rev'
    rev()
    gulp.dest 'dist'
    rev.manifest
      path: 'manifest.json'
    gulp.dest 'dist'
    ->
      rimraf = require 'rimraf'
      rimraf.sync 'dist/rev'
  ]

gulp.task 'rev-replace', ['html', 'rev'], pump ->
  replace = require 'gulp-rev-replace'
  [
    gulp.src ['dist/**/*.html', 'dist/css/*.css', 'dist/js/*.js'], base: 'dist'
    replace manifest: gulp.src 'dist/manifest.json'
    gulp.dest 'dist'
    ->
      execSync 'rm dist/manifest.json'
  ]

gulp.task 'build', ['rev-replace']

gulp.task 'pack', pump ->
  rename = require 'gulp-rename'
  [
    gulp.src 'dist/*.html'
    rename
      extname: ''
    gulp.dest 'dist'
    ->
      execSync 'rm dist/*.html'
      execSync 'tar zcf ../yunq.tgz *',
        cwd: 'dist'
        stdio: 'inherit'
  ]

gulp.task 'clean', pump ->
  clean = require 'gulp-clean'
  [
    gulp.src 'dist/*'
    clean()
  ]

through = (callback) ->
  require('through2').obj callback

browserify = ->
  {replaceExtension} = require 'gulp-util'
  through (file, encoding, callback) ->
    b = require('browserify') file.path,
      extensions: ['.coffee']
      transform: ['coffeeify']
      bundleExternal: false
    b.bundle (err, buf) ->
      file.path = replaceExtension file.path, '.js'
      file.contents = buf
      callback err, file

throwPluginError = (name, err) ->
  {PluginError} = require 'gulp-util'
  message = if typeof err == 'string' then err else err.annotated or err.message
  new PluginError name, message, err
