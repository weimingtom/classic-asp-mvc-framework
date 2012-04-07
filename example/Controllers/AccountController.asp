<%
'required #include file="libs/MVC.asp"

class cLoginViewModel
    public Username
    public Password
end class

class cAccountController
        
    private membershipProvider
    private formsAuthenticationService

    Public Sub Class_Initialize()
		set baseController = (new cController).Init("Account")     
        
        set membershipProvider = (new cMyMembershipProvider).Init(Application("TravelConnectionString"))
        set formsAuthenticationService = new cFormsAuthenticationService
	End Sub 

    public function LogOn()
        dim model: set model = new cLoginViewModel
        set LogOn = View("Logon", model)
    end function

    public function LogOn_POST(model)                
        if membershipProvider.ValidateUser(model.Username, model.Password) then
            formsAuthenticationService.SignIn model.Username, true               
            
            set LogOn_POST = Redirect("/hotels/")
        else            
            baseController.ModelState.AddError("Access denied.")            
            set LogOn_POST = View("Logon", model)
        end if
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

    public baseController

    private Property Get ModelState
        set ModelState = baseController.ModelState
    end Property

    private Property Get ControllerContext
        set ControllerContext = baseController.ControllerContext
    end Property

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


class cFormsAuthenticationService
    
    public sub SignIn(username, isCreatePersistentCookie)
        FormsAuthentication_SetAuthCookie username, isCreatePersistentCookie
    end sub

    public sub SignOut()
    end sub

end class
%>