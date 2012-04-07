<% 
'Required #include file="/libs/Collections.asp"

function ToHtmlAttributes(attributes)
    N = attributes.Items.Count
    dim htmlAttrs: htmlAttrs = ""
    dim key, keys
    keys = attributes.Items.Keys()
    for i=0 to N-1 
        key = keys(i)
        htmlAttrs = htmlAttrs & key & "='" & attributes(key) & "' "
    next
    ToHtmlAttributes = htmlAttrs
end function

sub HtmlSelect_arg4(data, keyValue, keyText, attributes)
    HtmlSelect data, keyValue, keyText, attributes, null, null
end sub

sub HtmlSelect(data, keyValue, keyText, attributes, selectedValue, selectedText)
    dim N, i    
    dim htmlAttrs: htmlAttrs = ToHtmlAttributes(attributes)
    
    dim curValue, curText
    dim selected: selected = ""
    dim isExistSelected: isExistSelected = false
    N = UBound(data)
    %>
    <select <%=htmlAttrs%>>
    <% 
        for i=0 to N 
            selected = ""
            curValue = Eval("data(i)." & keyValue)
            curText =  Eval("data(i)." & keyText)
            if (not isExistSelected) and (((not IsNull(selectedValue))and(curValue = selectedValue)) or ((not IsNull(selectedText))and(curText = selectedText))) then
                selected = "selected='true'"
                isExistSelected = true            
            end if
    %>
       <option <%=selected%> value="<%= Eval("data(i)." & keyValue) %>"><%= Eval("data(i)." & keyText) %></option> 
    <% next %>
    </select>
    <%
end sub
%>