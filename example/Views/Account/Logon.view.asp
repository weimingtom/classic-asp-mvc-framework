<%
    dim model: set model = Session("model")
    dim ModelState: set ModelState = Session("ModelState")
%>
<html>
<head>
    <title>Log on</title>
</head>

<body>
    <% if not ModelState.IsValid then %>
        <ul>
       <%For Each error in ModelState.Errors   %>
        <li><%=error %></li>
       <%Next%>
        </ul>
    <%  end if %>

    <p>Please enter your username and password into the boxes below and click continue.</p>
    <form method="post" action="/account/logon.asp">
		<label>Username</label><input type="text" name="user" size="20" value="<%=model.Username %>"/>
		<label>Password</label><input type="password" name="password" size="20" value="<%=model.Password %>"/>
			
		<input type="submit" value="Log In"/>
	</form>	

</body>
</html>