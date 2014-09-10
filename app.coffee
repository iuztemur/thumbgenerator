express = require("express")
path = require("path")
favicon = require("static-favicon")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
mongoose = require 'mongoose'

port  = process.env.PORT || 3001
app = express()
if mongoose.connect 'mongodb://localhost:27017/thumbgenerator'
  console.log 'Database connected.. pictures db is created.'
else
  console.log 'Database not connected'


upload = require("./routes/upload/uploadManager")
mainroutes = require("./routes/index")
tag = require("./routes/tag/index")

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "ejs"
app.engine 'html', require('ejs').renderFile
app.use favicon()
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use express.static(path.join(__dirname, "public"))

app.use "/", mainroutes
app.use "/addpic", upload
app.use "/addtag", tag

#/ catch 404 and forwarding to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return


#/ error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return


app.listen port
console.log 'Port: ' + port
