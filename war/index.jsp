<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Card Test</title>

<link rel="stylesheet" type="text/css" href="./style.css">
<%@ page 
import="com.google.appengine.api.users.*" 
pageEncoding="utf-8"
contentType="text/html;charset=utf-8"
%>
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
String msg;

if( user == null ){
  msg = "<a href='" + userService.createLoginURL("/auth/") + "'>ログイン</a> しろ、カス!";
  } else {
  msg = "ようこそ! あなたは <b>" + user.getNickname() + "</b> という名前でログインしています。"
    + " <a href='" + userService.createLogoutURL("/") + "'>サインアウト</a>";
}

// System.out.println( msg );
%>
</head>
<body>

	<p class="round"><%= msg %></p>

<%
	if( user != null ) {
%>
	<div class="post">
		<form id="form" action="/dummy" method="post">
			<p>
				<input type="text" name="title" id="title" />
				<textarea name="article" id="article">
Please input details.
			</textarea>
				<input type="submit" />
			</p>
		</form>
		<p>
			<a href="#">[X] Close</a>
		</p>
	</div>

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
					$('#content ul').remove();
					var ul = $('<ul/>');
					var guestbook, li;
					$.each(data, function(_, scass) {
						var li = $('<li/>').text(
								scass['title'] + '(' + scass['article'] + ')');
						li.appendTo(ul);
					});
					ul.appendTo('#content');
				};
				$.ajax({
					url : '/scass',
					type : 'get'
				}).success(onSuccess).error(onError);
			}
			//起動直後に一度実行する
			refresh();

			// submit
			var submit = function(event) {
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

				};
				$.ajax({
					url : '/scaas',
					type : 'post',
					title : title,
					article : article
				}).success(onSuccess).error(onError);
				return false;
			};
			//formのサブミットハンドラに指定する
			$('#form').submit(submit);
		});
	</script>
	
	<%
	}
	%>

</body>
</html>
