<!-- #include file="SerializationJSON.asp" -->
<%
class cHotel
    public id
    public cityName
    public cityNameRus
    public hotelName
    public hotelNameRus
    public hotelType
    public Address
    public Phone

    public function reflect()

        set reflect = server.createObject("scripting.dictionary")
        with reflect
            .add "id", id
            .add "cityName", cityName
            .add "cityNameRus", cityNameRus
        end with

    end function
end class

dim hotels(1)

dim hotel
set hotel = new cHotel
hotel.id = 1
hotel.cityName = "asdasd"
set hotels(0) = hotel

set hotel = new cHotel
hotel.id = 2
hotel.cityName = "sss"
set hotels(1) = hotel


%>
<%= (new JSON).toJSONSimple(hotels) %>