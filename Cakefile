
# Include
# ------------------------------------------------------------------------------

fs = require 'fs'
cp = require 'child_process'
util = require 'util'
_ = require 'underscore'
{spawn, exec} = require 'child_process'
path = require 'path'
fs = require 'fs'

# Paths
# ------------------------------------------------------------------------------

# Tasks
# ------------------------------------------------------------------------------

task "test", "Run unit tests", ->
  exec "NODE_ENV=testing mocha", (err, output) ->
    throw err if err
    console.log output

task "test:watch", "Watch unit tests", ->
  launch 'mocha', ['--reporter', 'min', '--watch']

# Utilities
# ------------------------------------------------------------------------------

optionsMode = (options, modes = ['production', 'staging', 'testing', 'development']) ->
  optionsCombine options, modes

optionsCombine = (options, choices) ->
  for choice in choices
    if options[choice]
      break
  choice

captialize = (str) ->
  "#{str.charAt(0).toUpperCase()}#{str.slice(1)}"

# envFromObject({FOO:'bar', FOO2:'bar2'}) => 'FOO=bar FOO2=bar2 '
envFromObject = (obj) ->
  out = ""
  for k,v of obj
    out += "#{k}=#{v} "
  out

# download: download the url to string
download = (url, cb) ->
  httpx = if startsWith(url, 'https:') then https else http
  options = require('url').parse url
  data = ""
  req = httpx.request options, (res) ->
    res.setEncoding "utf8"
    res.on "data", (chunk) ->
      data += chunk
    res.on "end", ->
      cb null, data, url
  req.end()

# Determine if string starts with other string
startsWith = (strInput, strStart) ->
  throw 'startsWith: argument error' unless (_.isString strInput) and (_.isString strStart)
  strInput.length >= strStart.length and strInput.lastIndexOf(strStart, 0) == 0

# Determine if string starts with other string
endsWith = (strInput, strEnd) ->
  throw 'endsWith: argument error' unless (_.isString strInput) and (_.isString strEnd)
  strInput.length >= strEnd.length and strInput.lastIndexOf(strEnd, strInput.length - strEnd.length) == strInput.length - strEnd.length

# Prepend string if necessary
prepend = (strInput, strStart) ->
  if (_.isString strInput) and (_.isString strStart) and not (startsWith strInput, strStart)
    return strStart + strInput
  strInput

# Prepend string if necessary
unprepend = (strInput, strStart) ->
  if _.isString(strInput) && _.isString(strStart) && startsWith(strInput, strStart)
    return strInput.slice strStart.length
  strInput

# mkdir: make a directory if it doesn't exist (mkdir -p)
mkdir = (dir, cb) ->
  fs.stat dir, (err, stats) ->
    if err?.code == 'ENOENT'
      fs.mkdir dir, cb
    else if stats.isDirectory
      cb(null)
    else
      throw "mkdir: #{dir} is not a directory"
      cb({code:"NotDir"})

# mkdirSync: make a directory syncronized if it doesn't exist (mkdir -p)
# Returns true if a new directory has been created but didn't exist before
mkdirSync = (dir) ->
  try
    stats = fs.statSync dir
    if not stats.isDirectory
      throw "mkdirSync: non-directory exists in location specified (#{dir})"
  catch err
    if err?.code == 'ENOENT'
      fs.mkdirSync dir
      return true
  false

# save: save file to path
save = (filepath, data, cb) ->
  cb ?= ->
  dir = path.dirname filepath
  # Ensure directory exists
  mkdir dir, (err) ->
    # Write file into directory
    fs.writeFile filepath, data, cb

# load: load a file into a string
load = (filepath, cb) ->
  fs.readFile filepath, "utf8", cb

# Logging
# ------------------------------------------------------------------------------

code =
  reset: '\u001b[0m'
  black: '\u001b[30m'
  red: '\u001b[31m'
  green: '\u001b[32m'
  yellow: '\u001b[33m'
  blue: '\u001b[34m'
  magenta: '\u001b[35m'
  cyan: '\u001b[36m'
  gray: '\u001b[37m'

log = (message, color, explanation) -> console.log code[color] + message + code.reset + ' ' + (explanation or '')
error = (message, explanation) -> log message, 'red', explanation
info = (message, explanation) -> log message, 'cyan', explanation
warn = (message, explanation) -> log message, 'yellow', explanation

launch = (cmd, args=[], options, callback = ->) ->
  # Options is optional (may be cb instead)
  if _.isFunction options
    callback = options
    options = {}

  # Info output command being run
  info "[#{envFromObject options?.env}#{cmd} #{args.join ' '}]"

  # cmd = which(cmd) if which
  app = spawn cmd, args, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> callback() if status is 0
