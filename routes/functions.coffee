##    Models    ##
IMG = require './models/img'
Tag = require './models/tag'

##    Package   ##
gm = require 'gm'
fs = require 'fs'


## 404 Page ##
exports.errorPage = (req, res) ->
	res.send '404 sayfasi'
	# res.render '404'

## Admin List page for add tag with pictures ##
exports.listImg = (req, res) ->
	if req.params.limit
		query = IMG.find()
		query.limit(12)
		query.where('status').ne(1)
		query.skip(5)
		query.exec (err, imgs) ->
			res.render 'admin', imgs : imgs
	
	else
		query = IMG.find()
		query.limit(12)
		query.where('status').ne(1)
		query.exec (err, imgs) ->
			res.render 'admin', imgs : imgs


## Tag add function ##
exports.addTag = (req, res) ->
	if req.params.id
		newTag = new Tag()
		newTag.fileName = req.params.id
		newTag.tags = req.body

		newTag.save (err, success) ->
			if err
				throw err

			if success
				console.log "tag success"
				IMG.update
					fileName: req.params.id
				,
					$set:
						status: 1
				, (err, success) ->
					if err
						throw err
					if success
						console.log "image update"
						res.json success

## Picture Engine ##
exports.tempEngine = (req, res) ->
	if not req.params.width and req.params.height
		res.redirect '/404'
	else
		if req.params.category and req.params.category != 'any'
			category = req.params.category
		else
			category = random_tag()

		console.log category
		
		_q = Tag.findOne()
		_q.where('tags').in([category])
		_q.exec (err, res) ->
			if err
				throw err
			if res == null
				console.log "opps.. error!!"

		query = Tag.findOne()
		query.where('tags').in([category])
		query.skip(random_number get_tag_count category)
		query.exec (err, imgs) ->
			if err
				throw err			
			dir = __dirname+"/../public/uploaded/"

			if req.query.filter || req.params.filter
				console.log req.params.filter
				if req.query.filter == "blur" or req.params.filter == "blur"
					gm(dir + "files/" + imgs.fileName)
					.resize(req.params.width, req.params.height, '^')
					.gravity('Center')
					.blur(5, 5)
					.extent(req.params.width, req.params.height)
					.write dir + "tmp/" + imgs.fileName, (err, success) ->
						if err
					  		throw err
						if req.query.data == 'ajquery'
							res.json imgs.fileName
						else
							fimg = fs.readFileSync dir + "tmp/" + imgs.fileName
							res.writeHead 200, "Content-Type" : 'image/gif'
							res.end fimg, 'binary'
				else if req.query.filter == "sepia" or req.params.filter == "sepia"
					gm(dir + "files/" + imgs.fileName)
					.resize(req.params.width, req.params.height, '^')
					.gravity('Center')
					.sepia()
					.extent(req.params.width, req.params.height)
					.write dir + "tmp/" + imgs.fileName, (err, success) ->
						if err
					  		throw err
						if req.query.data == 'ajquery'
							res.json imgs.fileName
						else
							fimg = fs.readFileSync dir + "tmp/" + imgs.fileName
							res.writeHead 200, "Content-Type" : 'image/gif'
							res.end fimg, 'binary'

				else if req.query.filter == "negative" or req.params.filter == "negative"
					gm(dir + "files/" + imgs.fileName)
					.resize(req.params.width, req.params.height, '^')
					.gravity('Center')
					.negative()
					.extent(req.params.width, req.params.height)
					.write dir + "tmp/" + imgs.fileName, (err, success) ->
						if err
					  		throw err
						if req.query.data == 'ajquery'
							res.json imgs.fileName
						else
							fimg = fs.readFileSync dir + "tmp/" + imgs.fileName
							res.writeHead 200, "Content-Type" : 'image/gif'
							res.end fimg, 'binary'
				else if req.query.filter == "black & white" or req.params.filter == "black & white"
					gm(dir + "files/" + imgs.fileName)
					.resize(req.params.width, req.params.height, '^')
					.gravity('Center')
					.monochrome()
					.extent(req.params.width, req.params.height)
					.write dir + "tmp/" + imgs.fileName, (err, success) ->
						if err
					  		throw err
						if req.query.data == 'ajquery'
							res.json imgs.fileName
						else
							fimg = fs.readFileSync dir + "tmp/" + imgs.fileName
							res.writeHead 200, "Content-Type" : 'image/gif'
							res.end fimg, 'binary'

			else 
				gm(dir + "files/" + imgs.fileName)
				.resize(req.params.width, req.params.height, '^')
				.gravity('Center')
				.extent(req.params.width, req.params.height)
				.write dir + "tmp/" + imgs.fileName, (err, success) ->
					if err
				  		throw err
					if req.query.data == 'ajquery'
						res.json imgs.fileName
					else
						fimg = fs.readFileSync dir + "tmp/" + imgs.fileName
						res.writeHead 200, "Content-Type" : 'image/gif'
						res.end fimg, 'binary'


## Something Function ##
random_number = (max) ->
	Math.floor Math.random() * max

random_tag = ->
	tags = ['Animal','Sea','Bird','Cat','Tech','Building','People','Horse','City','Arhitecture','Sport','Sky','Bike','Winter','Nature','Bussiness','Night','Education','Summer','Travel','Music','Beach','Car','Hill']
	tags[random_number(24)]

get_tag_count = (tag) ->
	tags = 'Animal':6,'Sea':8,'Bird':1,'Cat':0,'Tech':6,'Building':4,'People':24,'Horse':0,'City':6,'Arhitecture':8,'Sport':8,'Sky':0,'Bike':1,'Winter':0,'Nature':34,'Bussiness':12,'Night':5,'Education':12,'Summer':4,'Travel':5,'Music':3,'Beach':3,'Car':9,'Hill':0
	tags[tag]