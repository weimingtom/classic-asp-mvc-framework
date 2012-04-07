<%
'required #include file="libs/MVC.asp"
'required #include file="Entities.asp"
'required #include file="HotelsRepository.asp"

class cListByLetterViewModel
    public FirstLetters
    public Hotels    
end class

class cHotelsController
    
    private repository
    public baseController

    Public Sub Class_Initialize()
		set baseController = (new cController).Init("Hotels")
        set repository = new cHotelsRepository
	End Sub 

    public function ListByLetter(letter)
        dim model
        set model = new cListByLetterViewModel
        model.FirstLetters = repository.GetAllFirstLettersOfCitites
        model.Hotels = repository.GetByCityFirstLetter(letter)        

        set ListByLetter = View("List", model)        
    end function 

    public function Edit_POST(hotel)
        repository.Update(hotel)
        set Edit_POST = new cEmptyResult
    end function

    public function Add_POST(hotel)
        repository.Add(hotel)
        set Add_POST = (new cJSONResult).Init(hotel)
    end function

    private function View(viewName, model)               
        set View = baseController.View(viewname, model)
    end function
    
    public function ModelBindForAction(actionName)        
        dim hotel
        if LCase(actionName) = "listbyletter" then
            dim letter :letter = ClearString(Request.QueryString("letter"))
            if (letter="") then letter = "A"
            ModelBindForAction = letter
        elseif LCase(actionName) = "add_post" then
        
            set hotel = new cHotel    
            hotel.cityName = ClearString(Request.Form("cityName"))
            hotel.cityNameRus = ClearString(Request.Form("cityNameCyr"))
            hotel.hotelName = ClearString(Request.Form("hotelName"))
            hotel.hotelNameRus = ClearString(Request.Form("hotelNameCyr"))
            hotel.hotelType = ClearString(Request.Form("hotelType"))
            hotel.Address = ClearString(Request.Form("address"))
            hotel.Phone = ClearString(Request.Form("phone"))
        
            set ModelBindForAction = hotel
        elseif LCase(actionName) = "edit_post" then
        
            set hotel = new cHotel
            hotel.id = CInt(ClearString(Request.Form("recordId")))
            hotel.cityName = ClearString(Request.Form("cityName"))
            hotel.cityNameRus = ClearString(Request.Form("cityNameCyr"))
            hotel.hotelName = ClearString(Request.Form("hotelName"))
            hotel.hotelNameRus = ClearString(Request.Form("hotelNameCyr"))
            hotel.hotelType = ClearString(Request.Form("hotelType"))
            hotel.Address = ClearString(Request.Form("address"))
            hotel.Phone = ClearString(Request.Form("phone"))

            set ModelBindForAction = hotel
        else
            ModelBindForAction = baseController.ModelBindForAction(actionName)
        end if
    end function    

    public function GetFiltersForAction(actionName)
        GetFiltersForAction = array((new cAuthFilter).Init("fulladmin"))
    end function
end class



%>
