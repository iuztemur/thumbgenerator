// ==================
// = CORE FUNCTIONS =
// ==================
$(document).ready(function() {
	var client = new ZeroClipboard(document.getElementById("copy-button"));

	client.on("ready", function(readyEvent) {
	// alert( "ZeroClipboard SWF is ready!" );

		client.on("aftercopy", function(event) {
		// `this` === `client`
		// `event.target` === the element that was clicked
		// event.target.style.display = "none";
		// alert("Copied text to clipboard: " + event.data["text/plain"]);
		alert("Copied text to clipboard ;)");
		});
	});

	var	tags = $(".tags li a"),
	  filters = $(".filters li a");
	var ctag, cfilter = false;
	var status = false;
	var _gstatus = false;

	tags.on('click', function(){
		if(ctag == $(this).context.innerText){
			$(this).removeClass("active");
			ctag = false;
		}
		else{
			$(".tags li a").removeClass("active");
			$(this).addClass("active");
			ctag = $(this).context.innerText;
		}
	});

	filters.on('click', function(){
		if(cfilter == $(this).context.innerText){
			$(this).removeClass("active");
			cfilter = false;
		}
		else{
			$(".filters li a").removeClass("active");
			$(this).addClass("active");
			cfilter = $(this).context.innerText;
		}
	});
	
	$("#check-btn").click(function(){
		if(status == false){
			$('#check-btn').addClass('checked');
			status = true;
		}
		else if(status !== false){
			$('#check-btn').removeClass('checked');
			status = false;
		}

		if(_gstatus == true){
			setTimeout(function(){
				$('#welcome').addClass('hide');
				if(status == true){
					if(_gstatus == true)
						$("#design").addClass("hide");
					
					$("#development").removeClass("hide");
					$("#development").addClass("animated fadeIn");
				}
				else if(status == false){
					if(_gstatus == true)
						$("#development").addClass("hide");

					$("#design").removeClass("hide");
					$("#design").addClass("animated fadeIn");
				}
			}, 800);
		}
	});

	$("#generate-btn").click(function(){
	var ltags = $(".tags li"),
	lfilters = $(".filters li");
	var	width = $("#width").val(),
	height = $("#height").val();
	var stags = [];
	var sfilters = [];

	ltags.each(function(){
		if($(this).context.innerHTML.match('\"active\"') !== null)
			if($(this).context.innerText !== null)
				stags.push($(this).context.innerText);
	});
	lfilters.each(function(){
		if($(this).context.innerHTML.match('\"active\"') !== null)
			if($(this).context.innerText !== null)
				sfilters.push($(this).context.innerText);
	});

	if(_gstatus == false){
		$('#welcome').addClass('animated fadeOut');
		setTimeout(function(){
			$('#welcome').addClass('hide');
			if(status == true){

				$("#development").removeClass("hide");
				$("#development").addClass("animated fadeIn");
			}
			else if(status == false){

				$("#design").removeClass("hide");
				$("#design").addClass("animated fadeIn");
			}
		}, 500);
		$("#design").append("<img src='' class='preview' alt=''>");
	}
	
	stags[0] = stags[0] !== undefined ? stags[0] : "any";
	
	console.log(sfilters[0]);

	$.get("/ajquery/"+width+"/"+height+"/"+stags[0], { data:'ajquery', filter:sfilters[0] })
		 .done(function( data ) {
	 		$("#design img").attr('src', '/uploaded/tmp/'+data);
		 });


	$("#development-text").val(window.location.hostname+"/"+$("#width").val()+"/"+$("#height").val()+"/"+stags[0]);


	_gstatus = true;
	});
});
