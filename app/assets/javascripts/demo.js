$(document).ready(function() {
	$('a.zoom').each(function(){
	$(this).on('click',function(event) {
		event.preventDefault()
		var img = new Image();
		img.src = $(this).attr('href')
		type = $(this).attr('data-type');
		
		$('.overlay-container').fadeIn(function() {
			
			window.setTimeout(function(){
				$('.window-container.'+type).addClass('window-container-visible');
				$('.window-container.'+type).html(img);
				$('.window-container.'+type).css({width:img.width});
				$('.window-container.'+type).append( "<span class='close' > Close </span> ")
			}, 100);
			
		});
	});
	
	$(document).on('click','.close',function() {
		$('.overlay-container').fadeOut().end().find('.window-container').removeClass('window-container-visible');
	});
	});
});