mongoose = require 'mongoose'

tagSchema = mongoose.Schema
	fileName : String
	tags : Array

module.exports = mongoose.model 'Tag', tagSchema