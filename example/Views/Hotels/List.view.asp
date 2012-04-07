<!-- #include virtual="/ssl/Views/Hotels/LettersList.asp" -->
<!-- #include virtual="/libs/SerializationJSON.asp" -->
<%
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CharSet = "UTF-8"
dim model: set model = Session("model")
dim hotel 
dim letterListControl
set letterListControl = new cLetterListControl
%>
<!-- #include virtual="/inc/header_1.inc" -->
<!-- #include virtual="/inc/header_2.inc" -->
<link rel="stylesheet" type="text/css" href="/ssl/Content/hotels.css" />

<!--![CDATA]-->
<script type="text/javascript">
    var hotels = <%= (new JSON).toJSONSimple(model.Hotels) %>;
</script>
<!--[CDATA]-->

<script type="text/javascript" src="/inc/scripts/rr-lib-0001.js"></script>
<script type="text/javascript" src="/ssl/scripts/hotels.js"></script>


<div id="hotelListHolder">
    <div style="text-align:right; margin-bottom:20px; font-size:12px">To add a new city/hotel pair click this button <a onclick="return addrecord();" id="addHotelLink" href="#add"><img src="/ssl/images/Button_AddToCart.png"/></a>
    </div>

    <% letterListControl.Render(model.FirstLetters) %>

    <table id="hotelTable">
        <thead>        
            <tr>
                <th>City name</th>
                <th>Cyrillic City name</th>
                <th>Hotel name</th>
                <th>Cyrillic Hotel name</th>
                <th>Type</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for i = 0 to UBound(model.Hotels) : set hotel = model.Hotels(i) %>
            <tr>
                <td><%= hotel.cityName %></td>
                <td><%= hotel.cityNameRus %></td>
                <td><%= hotel.hotelName %></td>
                <td><%= hotel.hotelNameRus %></td>
                <td><%= hotel.hotelType %></td>
                <td class="centered">
                    <input type="hidden" value="<%= hotel.id %>" /><a href="edit" onclick="return editrecord(this)" /><img alt="edit record" src="/ssl/images/penBnd.png"></a><a onclick="return deleterecord(this)" href="delete" /><img alt="delete record" src="/ssl/images/deleteBnd.png" /></a>
                </td>
            </tr>
            <% next %>
        </tbody>
    </table>

    <% letterListControl.Render(model.FirstLetters) %>

    <div id="editRecordDiv" class="popup">
        <p><label for="cityname">City name:</label><input name="cityname" id="cityname"></p>
        <p><label for="citynameCyr">Cyrillic city name:</label><input name="citynameCyr" id="citynameCyr"></p>
        <p><label for="hoteltype">Hotel type:</label><select name="hoteltype" id="hoteltype"><option>Hotel</option><option>Hostel</option></select></p>
        <p><label for="hotelname">Hotel name:</label><input name="hotelname" id="hotelname"></p>
        <p><label for="hotelnameCyr">Cyrillic hotel name:</label><input name="hotelnameCyr" id="hotelnameCyr"></p>
        <p><label for="address">Cyrillic address:</label><input name="address" id="address"></p>
        <p><label for="phone">Phone number:</label><input name="phone" id="phone"></p>
        <p class="buttonHolder">
            <input type="button" id="editSubmit" value="Update record" onclick="updateAjax()">
            <input type="button" id="editCalcelSubmit" value="Close" onclick="closePopup('editRecordDiv')">
        </p>
    </div>
    
    <div id="deleteRecordDiv" class="popup">
        <p><label class="autowidth">You won't be able to cancel this action.<br><br>Are you sure you want to delete this hotel from the list?</label></p>
        <p class="buttonHolder">
            <input type="button" id="deleteYesSubmit" value="Yes" onclick="deleteAjax()">
            <input type="button" id="deleteCalcelSubmit" value="No" onclick="closePopup('deleteRecordDiv')">
        </p>
    </div>
    
    <div id="addRecordDiv" class="popup">
        <p><label for="citynameAdd">City name:</label><input name="citynameAdd" id="citynameAdd"></p>
        <p><label for="citynameCyrAdd">Cyrillic city name:</label><input name="citynameCyrAdd" id="citynameCyrAdd"></p>
        <p><label for="hoteltypeAdd">Hotel type:</label><select name="hoteltypeAdd" id="hoteltypeAdd"><option>Hotel</option><option>Hostel</option></select></p>
        <p><label for="hotelnameAdd">Hotel name:</label><input name="hotelnameAdd" id="hotelnameAdd"></p>
        <p><label for="hotelnameCyrAdd">Cyrillic hotel name:</label><input name="hotelnameCyrAdd" id="hotelnameCyrAdd"></p>
        <p><label for="address">Cyrillic address:</label><input name="addressAdd" id="addressAdd"></p>
        <p><label for="phone">Phone number:</label><input name="phoneAdd" id="phoneAdd"></p>
        <p class="buttonHolder">
            <input type="button" id="addSubmit" value="Add" onclick="addAjax()">
            <input type="button" id="addCalcelSubmit" value="Close" onclick="closePopup('addRecordDiv')">
        </p>
    </div>
</div>
<!-- #include virtual="/inc/footer_1.inc" -->