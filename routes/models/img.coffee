mongoose = require 'mongoose'

pictureSchema = mongoose.Schema
	fileName : String
	status : 
		type: String
		default: 0
	added : 
		type: Date 
		default: Date.now

module.exports = mongoose.model 'Picture', pictureSchema