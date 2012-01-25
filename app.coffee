fs = require('fs')
path = require('path')
express = require('express')
stylus = require('stylus')
coffee = require('coffee-script')
app = module.exports = express.createServer()

# ------------------------------------------------------------
#  Configuration
# ------------------------------------------------------------

app.configure ->
  app.set 'views', __dirname + '/app/views'
  app.set 'view engine', 'jade'
  app.use stylus.middleware src: __dirname + '/app'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + '/app')
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use(express.errorHandler())


# ------------------------------------------------------------
#  Routes
# ------------------------------------------------------------

app.get '/', (req, res) ->
  res.render 'application', layout: false

app.get "/application.js", (req, res) ->
  fs.readFile __dirname + '/app/application.coffee', 'utf8', (err, file) ->
    js = coffee.compile(file)
    res.writeHead 200,
      "Content-Type": "text/javascript"
    res.end js

app.get "/application.css", (req, res) ->
  fs.readFile __dirname + "/app/stylesheets/application.styl", "utf8", (err, file) ->
    stylus.render file,
      filename: __dirname + "/app/stylesheets/application"
    , (err, css) ->
      throw err  if err
      res.writeHead 200,
        "Content-Type": "text/css"
      res.end css

app.listen(process.env.PORT or 3000)
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
