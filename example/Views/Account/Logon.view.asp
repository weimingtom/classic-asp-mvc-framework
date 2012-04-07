<%
    dim model: set model = Session("model")
    dim ModelState: set ModelState = Session("ModelState")
%>
<!-- #include virtual="inc/header_1.inc" -->
<!-- #include virtual="inc/header_2.inc" -->
<head>
<meta http-equiv="Content-Language" content="en-gb">
</head>

<table border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="table1">
  <tr>
    <td width="74" valign="top">
    <img border="0" src="/images/SO02816_.gif" width="208" height="135"/></td>
    <td valign="top"><font size="2"><b>Real Russia Administration</b></font><p>&nbsp;</p>
    <% if not ModelState.IsValid then %>
        <ul>
       <%For Each error in ModelState.Errors   %>
        <li><%=error %></li>
       <%Next%>
        </ul>
    <%  end if %>
    <p><font size="2">Please enter your username and password into the boxes 
	below and click continue.</font></p>
    <form method="post" action="/ssl/account/logon.asp">
		<table border="0" width="100%" cellpadding="2" id="table2">
			<tr>
				<td width="75"><font size="2">Username </font></td>
				<td> <input type="text" name="user" size="20" value="<%=model.Username %>"/></td>
			</tr>
			<tr>
				<td width="75"><font size="2">Password </font></td>
				<td> <input type="password" name="password" size="20" value="<%=model.Password %>"/></td>
			</tr>
		</table>
		<p>&nbsp;</p>
		<p><input type="submit" value="Continue" name="B1"/></p>
	</form>
	<p>&nbsp;</td>
  </tr>
</table>

<!-- #include virtual="inc/footer_1.inc" -->