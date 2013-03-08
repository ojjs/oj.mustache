path = require 'path'
fs = require 'fs'

oj = require 'oj'

plugin = require '../src/oj.mustache'

# Include mustache as plugin
oj.use plugin

describe 'oj-mustache', ->

  it 'should be an function ', ->
    plugin.should.be.an 'function'

  it 'use should create oj.mustache', ->
    oj.mustache.should.be.an 'function'

  it 'oj works', ->
    result = oj.toHTML ->
      oj.div 'test'
    expect(result).to.equal '<div>test</div>'

  it 'mustache works', ->
    result = oj.toHTML ->
      oj.mustache name:'Evan', '<html><body>My name is {{name}}</body></html>'

    expect(result).to.equal '<html><body>My name is Evan</body></html>'



