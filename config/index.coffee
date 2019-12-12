fs = require 'fs'
path = require 'path'
ini = require 'ini'
{extend} = require 'lodash'
{object} = require '../lib/utils'

{NODE_ENV, CONFIG, LOG} = process.env
production = NODE_ENV == 'production'
ini_file = CONFIG or unless production then 'config/development.ini' else '/etc/yunq/yunq.ini'
unless fs.existsSync ini_file
  console.error "config file not found: " + ini_file
  process.exit -1
config = ini.parse fs.readFileSync ini_file, 'utf-8'
config.maxage = if production then '1y' else 0

log = LOG or config.logging.path
logger =
  level: config.logging.level
if log == 'stdout'
  logger.stream = process.stdout
else
  logger.path = log

handler = (x, p) ->
  x.prev = p
  if p.require
    (x.next = p.require[x.key]).forEach (y) -> handler y, x
  x.link = x.link or if x.next then x.next[0].link else link x
  if x.link and x.link != '#' and not x.link.startsWith 'http'
    routers.push x.link.substr 1

link = (x, l) ->
  n = x.name
  if l
    n = unless n then l else "#{n}-#{l}"
  if x.prev then link x.prev, n else '/' + n.replace '-', '/'

routers = []

pages = object require('./pages'), (x) ->
  x.next.forEach (y) -> handler y, x
  x.link = x.next[0].link
  x.name or x.key

module.exports = extend config,
  env: if production then 'production' else 'development'
  production: production
  logger: logger
  pages: pages
  routers: routers
