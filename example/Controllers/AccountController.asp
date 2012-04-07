<%
'required #include file="libs/MVC.asp"

class cLoginViewModel
    public Username
    public Password
end class

class cAccountController
    
    public baseController
    private membershipProvider
    private formsAuthenticationService
    
    private Property Get ModelState
        set ModelState = baseController.ModelState
    end Property

    private Property Get ControllerContext
        set ControllerContext = baseController.ControllerContext
    end Property

    Public Sub Class_Initialize()
		set baseController = (new cController).Init("Account")     
        
        set membershipProvider = (new cTravelMembershipProvider).Init(Application("TravelConnectionString"))
        set formsAuthenticationService = new cFormsAuthenticationService
	End Sub 

    public function LogOn()
        set model = new cLoginViewModel
        set LogOn = View("Logon", model)
    end function

    public function LogOn_POST(model)        
        dim user        
        if membershipProvider.ValidateUser(model.Username, model.Password) then
            formsAuthenticationService.SignIn model.Username, true

            set user = membershipProvider.GetUser(model.Username)            
            
            if (UCase(user.Status) <> "ACTIVE") then            
                ModelState.AddError("Access denied.")
                set LogOn_POST = View("Logon", model)
                exit function
            end if

            dim adminRights, fullAdmin
            if user.IsHasAdminRights then
                adminRights = "yes"
            else
                adminRights = "no"
            end if
            if user.IsFullAdmin then
                fullAdmin = "yes"
            else
                fullAdmin = "no"
            end if
            
            dim urlToRedirect
            urlToRedirect = "/ssl/upg.asp?ID=" & user.PartnerId & "&partnerName=" & user.PartnerName & "&adminRights=" & adminRights & "&fullAdmin=" & fullAdmin
		
            if user.IsHasCreditVSD = true then                  
                if (not user.IsHasAdminRights) and (not user.IsFullAdmin) then                
                    urlToRedirect = "/ssl/requestTouristVSD.asp"
                end if                                        
            end if                        
            
            set LogOn_POST = Redirect(urlToRedirect)
        else            
            baseController.ModelState.AddError("Access denied.")            
            set LogOn_POST = View("Logon", model)
        end if
    end function

    private function View(viewName, model)               
        set View = baseController.View(viewname, model)
    end function

    private function Redirect(url)
        set Redirect = baseController.Redirect(url)
    end function

    public function ModelBindForAction(actionName)                
        if LCase(actionName) = "logon_post" then
            set ModelBindForAction = new cLoginViewModel
            ModelBindForAction.Username = Request.Form("user")
            ModelBindForAction.Password = Request.Form("password")
        else
            ModelBindForAction = baseController.ModelBindForAction(actionName)        
        end if        
    end function

    public function GetFiltersForAction(actionName)
        GetFiltersForAction = baseController.GetFiltersForAction(actionName)
    end function
end class


class cFormsAuthenticationService
    
    public sub SignIn(username, isCreatePersistentCookie)
        FormsAuthentication_SetAuthCookie username, isCreatePersistentCookie
    end sub

    public sub SignOut()
    end sub

end class
%>