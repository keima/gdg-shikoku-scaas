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

<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" language="javascript">
	// display
	function refresh() {
		var onError = function(jqXHR, textStatus, errorThrown) {
			alert('error');
		};

		var onSuccess = function(data, textStatus, jqXHR) {
			// flush content
			$('#content div').remove();

			// create content
			for ( var i in data) {
				var div = $('<div class="card"/>').attr('id', 'c' + data[i].key);
				var aDel = $('<a href="#">[X]</a>').attr('id', data[i].key).attr('onClick','deleteReq(' + data[i].key + ')');
				var pDel = $('<p class="delbtn"/>').append(aDel);
				var pTitle = $('<p class="title"/>').text(data[i].title);
				var pArti = $('<p/>').text(data[i].article);
				div.append(pDel);
				div.append(pTitle);
				div.append(pArti);
				div.appendTo('#content');
			}
		};
		$.ajax({
			url : '/scaas',
			type : 'get'
		}).success(onSuccess).error(onError);
	}
	//起動直後に一度実行する
	refresh();

	// submit
	function submit() {
		var title = $('#title');
		var article = $('#article');

		if (!title.val()) {
			title.focus();
			return false;
		}

		var onError = function(jqXHR, textStatus, errorThrown) {
			alert('error');
		};
		var onSuccess = function(data2, textStatus, jqXHR) {
			title.val('');
			article.val('');
			setTimeout(refresh, 1000);
		};
		var data1 = 'status=create&title=' + title.val() + '&article=' + article.val();

		console.log("JSON: " + data1);
		$.ajax({
			url : '/scaas',
			type : 'post',
			data : data1,
		}).done(onSuccess).fail(onError);

		return false;
	};
	
	// delete
	function deleteReq(key) {

		var onError = function(jqXHR, textStatus, errorThrown) {
			alert('error');
		};
		var onSuccess = function(data2, textStatus, jqXHR) {
			$('#c'+ key).hide('2000', function(){
				$('#c'+ key).remove();
			});
			
			//setTimeout(refresh,3000);
		};
		
		var data1 = 'status=delete&key=' + key;

		console.log("JSON: " + data1);
		$.ajax({
			url : '/scaas',
			type : 'post',
			data : data1,
		}).done(onSuccess).fail(onError);

		return false;
	};

	//		//textareaをクリックで全消し
	$('#article').click(function() {
		if ($(this).val() == 'Please input details.') {
			$(this).val('');
		}
	});
	
	setInterval(refresh, 10 * 1000);
</script>
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
		<form id="form">
			<p>
				<input type="text" name="title" id="title" />
				<textarea name="article" id="article">Please input details.</textarea>
			</p>
		</form>
		<input type="button" value="submit" onClick="submit();" />
		<%=msg%>
	</div>

	<div id="content"></div>

	<%
		}
	%>

</body>
</html>
