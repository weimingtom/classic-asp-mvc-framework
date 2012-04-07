<p>
    <% for i = 0 to UBound(model) %>        
    <a href="?letter=<%= model(i) %>"><%= model(i) %></a>
    <%next%>    
</p>