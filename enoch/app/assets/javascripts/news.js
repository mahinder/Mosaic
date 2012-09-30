$(document).on('click','.news_search', function(event){
	event.preventDefault();
	var query = $('#query_search').val()
	var target = '/news/search_news_ajax' + '?query=' + query
	 
	$.get(target,function(data){
		$('#search_news_ajaxx').empty()
		$('#search_news_ajaxx').html(data)
	});
	
});

$(document).on('click','#delete_comments', function(event){
	event.preventDefault();
	var newsId = $('#newsId').val()
	var commentId = $('#commentId').val()
	var target = '/news/delete_comment'
	
	
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a comment...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				 $("#loading_comment").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
					$.get(target,{id: commentId, news_id:  newsId},function(data){
						$('#commentslist').empty()
						$('#commentslist').html(data)
						window.location.reload()
					});
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	
});

$(document).on('click','#comment_added', function(event){
	event.preventDefault();
	var newsId = $('#newsId').val()
	var commentId = $('#comment_content').val()
	var target = '/news/add_comment'
   $("#loading_comment").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get(target,{newsId: newsId, comment:  commentId},function(data){
		$('#commentslist').empty()
		$('#commentslist').html(data)
		$('#comment_content').val("")
		window.location.reload()
	});
});