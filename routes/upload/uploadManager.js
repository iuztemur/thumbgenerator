IMG = require('../models/img');
var express = require('express');
var router = express.Router();

// config the uploader
var options = {
    tmpDir:  __dirname + '/../../public/uploaded/tmp',
    publicDir: __dirname + '/../../public/uploaded',
    uploadDir: __dirname + '/../../public/uploaded/files',
    uploadUrl:  '/addpic/uploaded/files/',
    maxPostSize: 11000000000, // 11 GB
    minFileSize:  1,
    maxFileSize:  10000000000, // 10 GB
    acceptFileTypes:  /.+/i,
    // Files not matched by this regular expression force a download dialog,
    // to prevent executing any scripts in the context of the service domain:
    inlineFileTypes:  /\.(gif|jpe?g|png)$/i,
    imageTypes:  /\.(gif|jpe?g|png)$/i,
    imageVersions: {
        width:  80,
        height: 80
    },
    accessControl: {
        allowOrigin: '*',
        allowMethods: 'OPTIONS, HEAD, GET, POST, PUT, DELETE',
        allowHeaders: 'Content-Type, Content-Range, Content-Disposition'
    },
    nodeStatic: {
        cache:  3600 // seconds to cache served files
    }
};

var uploader = require('blueimp-file-upload-expressjs')(options);

router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.get('/upload', function(req, res) {
  uploader.get(req, res, function (obj) {
        res.send(JSON.stringify(obj)); 
  });
  
});

router.post('/upload', function(req, res) {
  uploader.post(req, res, function (obj) {
        image = new IMG();
        image.fileName = obj.files[0].name;

        image.save(function(err){
            if(err)
                throw(err);
        });
        console.log(obj.files[0].name);            
        res.send(JSON.stringify(obj)); 
  });
  
});

router.delete('/uploaded/files/:name', function(req, res) {
  uploader.delete(req, res, function (obj) {
        console.log(req.params.name);
        IMG.find({fileName: req.params.name}).remove().exec();
        res.send(JSON.stringify(obj)); 
  });
  
});

module.exports = router;