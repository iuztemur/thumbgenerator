express = require("express")
router = express.Router()
func = require './functions'

router.get '/', (req,res) ->
	res.render 'home.html'

router.get '/:width/:height', func.tempEngine
router.get '/:width/:height/:category', func.tempEngine
router.get '/:width/:height/:category/:filter', func.tempEngine
router.get '/ajquery/:width/:height/:category', func.tempEngine

module.exports = router