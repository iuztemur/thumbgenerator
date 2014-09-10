express = require("express")
router = express.Router()
func = require './../functions'

router.get '/:limit', func.listImg
router.get '/', func.listImg
router.post '/tag/:id', func.addTag

module.exports = router