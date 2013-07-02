express = require "express"
app = express()

fs = require "fs"
path = require "path"

server = require("http").createServer app

app.set "port", process.env.port || 80
app.use express.logger "dev"
app.use express.compress()
app.use express.errorHandler()
app.use (req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  return next();
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.static path.join __dirname, "public"

if process.env.NODE_ENV == "development"
  app.set "port", 1337
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.use app.router

app.use express.favicon()


app.get "/", (req, res) ->
  res.render "pages/",
  title: "some title"

app.get "/demo", (req, res) ->
  res.render "pages/demo",
  title: "some title"

server.listen app.get("port"), () ->
  console.log ":: starting engine :: jade-views :: on #{app.get("port")}"

process.on "SIGINT", () ->
  # db.close()
  server.close()
  process.exit()
