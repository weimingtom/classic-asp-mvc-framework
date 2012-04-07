<%
function ClearString(str)
  str = Replace(str, "'", "")
  str = Replace(str, """", "")
  str = Replace(str, "--", "")
  str = Replace(str, "!", "")
  str = Replace(str, "#", "")
  str = Replace(str, "\\", "")
  str = Replace(str, "<", "")
  str = Replace(str, ">", "")
  ClearString = str
end function
%>