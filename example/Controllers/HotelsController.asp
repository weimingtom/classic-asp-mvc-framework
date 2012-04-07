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
    
    Public Sub Class_Initialize()
		set baseController = (new cController).Init("Hotels")
        set repository = new cHotelsRepository
	End Sub 

    public function ListByLetter(letter)
        dim model: set model = new cListByLetterViewModel
        model.FirstLetters = repository.GetAllFirstLettersOfHotels
        model.Hotels = repository.GetByCityFirstLetter(letter)        

        set ListByLetter = View("List", model)        
    end function 

    public function Edit_POST(hotel)
        repository.Update(hotel)
        set Edit_POST = EmptyContent()
    end function

    public function Add_POST(hotel)
        repository.Add(hotel)
        set Add_POST = JSON(hotel)
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

    public baseController

    private Property Get ModelState
        set ModelState = baseController.ModelState
    end Property

    private Property Get ControllerContext
        set ControllerContext = baseController.ControllerContext
    end Property
    
    public function GetFiltersForAction(actionName)
        GetFiltersForAction = array((new cAuthFilter).Init("fulladmin"))
    end function

    private function View(viewName, model)               
        set View = baseController.View(viewname, model)
    end function

    private function Redirect(url)
        set Redirect = baseController.Redirect(url)
    end function

    private function JSON(model)               
        set JSON = baseController.JSON(model)
    end function

    private function EmptyContent()
        set EmptyContent = baseController.EmptyContent(model)
    end function
end class

'..............

%>
