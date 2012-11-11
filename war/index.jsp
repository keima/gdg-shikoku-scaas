<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Card Test</title>

<link rel="stylesheet" type="text/css" href="./style.css">
<%@ page import="com.google.appengine.api.users.*" pageEncoding="utf-8"
	contentType="text/html;charset=utf-8"%>
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	String msg;

	if (user == null) {
		msg = "<a href='" + userService.createLoginURL("/")
				+ "'>ログイン</a> しろ、カス!";
	} else {
		msg = "<b>" + user.getNickname() + "</b> " + " <a href='"
				+ userService.createLogoutURL("/") + "'>LogOut</a>";
	}

	// System.out.println( msg );
%>
</head>
<body>

	<%
		if(user == null) {
	%>
	
	<p class="round"><%=msg%></p>

	<%
		} else {
	%>
	<div class="post">
		<form id="form" action="/scaas" method="post">
			<p>
				<input type="text" name="title" id="title" />
				<textarea name="article" id="article">Please input details.</textarea>
				<input type="submit" />
				<%=msg%>
			</p>
		</form>
	</div>
	
	<div id="content"></div>

	<script type="text/javascript"
		src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script type="text/javascript">
		$(function() {
			// display
			function refresh() {
				var onError = function(jqXHR, textStatus, errorThrown) {
					alert('error');
				};

				var onSuccess = function(data, textStatus, jqXHR) {
					// flush content
					$('#content div').remove();
					
					// create content
					for(var i in data){
						var div = $('<div class="card"/>').attr('id','c'+data[i].key);
						var aDel = $('<a/>').attr('id', data[i].key).attr('href','#').text('[X]');
						var pDel = $('<p class="delbtn"/>').append(aDel);
						var pTitle = $('<p class="title"/>').text(data[i].title);
						var pArti = $('<p class="article"/>').text(data[i].article);
						div.append(pDel);
						div.append(pTitle);
						div.append(pArti);
						div.appendTo('#content');
					}
					
					div.appendTo('#content');
				};
				$.ajax({
					url : '/scaas',
					type : 'get'
				}).success(onSuccess).error(onError);
			}
			
			//起動直後に一度実行する
			refresh();

			// submit
			var submit = function() {
				var title = $('#title');
				var article = $('#article');

				if (!title.val()) {
					title.focus();
					return false;
				}

				var onError = function(jqXHR, textStatus, errorThrown) {
					alert('error');
				};
				var onSuccess = function(data, textStatus, jqXHR) {
					alert('success');
					title.val('');
					article.val('');
					setTimeout(refresh, 1000);
				};
				
				var data = {status:'create', title: title, article: article};
				
				$.ajax({
					url: '/scaas',
					type: 'post',
					data: data
				}).complete(onSuccess).error(onError);
				return false;
			};
			
			//var deleteRequest = function(){
			function deleteRequest(){
				var key = $(this).attr(id);
				
				var data = { status:'delete', key: key };
				
				new $.ajax({
					url: '/scaas',
					type: 'post',
					data: data,
					error:function(){ alert('delete:error') },
		            complete:function(data){
		            	alert(data);
		            	setTimeout(refresh(), 1000);
		            	},
		            dataType:'json'
				});
				
				$('#c' + key).hide('slow');
				$('#c' + key).remove();
				
				alert('boo!');
				
				return false;
			};
			
			//formのサブミットハンドラに指定する
			$('form').submit(submit);
			$('input[type="submit"]').click(submit);
			
			//[x]にajax送信を付与
			$('p.delbtn a').click(deleteRequest);
			
			//textareaをクリックで全消し
			$('#article').click(function(){
				if($(this).val() == 'Please input details.'){
					$(this).val('');
				}
			});

		});
	</script>

	<%
		}
	%>

</body>
</html>
