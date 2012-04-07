<%
'required #include file="libs/SerializationJSON.asp"
'required #include file="libs/Collections.asp"

dim Global_FormsAuthenticationModule

Function GetRootVirtual()
    Dim applicationMetaPath : applicationMetaPath = Request.ServerVariables("APPL_MD_PATH")
    Dim instanceMetaPath : instanceMetaPath = Request.ServerVariables("INSTANCE_META_PATH")
    Dim rootPath : rootPath = Mid(applicationMetaPath, Len(instanceMetaPath) + Len("/ROOT/"))
    GetRootVirtual = rootPath
End Function

class cControllerContext        
    public RouteData
    public User    
end class

class cMVCApplication
    private m_controllerNameInit        
    private m_actionNameInit
    public AuthenticationModule

    Public Sub Class_Initialize()        
        set AuthenticationModule = new cEmptyMVCAuthenticationModule
        if Application("EnableFormsAuthentication") = true then
            set AuthenticationModule = (new cFormsAuthenticationModule)
        end if

        set Global_FormsAuthenticationModule = AuthenticationModule
	End Sub 

    public function Init(controllerName, actionName)
        m_controllerNameInit = controllerName
        m_actionNameInit = actionName 
        set Init = me       
    end function

    public sub Run()
        dim controllerContext: set controllerContext = new cControllerContext

        OnAuthenticate controllerContext

        RequestExecute controllerContext        
    end sub

    private sub OnAuthenticate(byref controllerContext)
        set controllerContext.User = AuthenticationModule.AuthenticateRequest()
    end sub

    private sub RequestExecute(byref controllerContext)
        dim controller
        dim aspCode
        dim controllerName   

        if IsNull(m_controllerNameInit) or IsEmpty(m_controllerNameInit) then
            controllerName = GetControllerNameFromRequest()
        else
            controllerName = m_controllerNameInit            
        end if

        on error resume next
        aspCode = "new c" & controllerName & "Controller"
        set controller = Eval(aspCode)
        if Err.number <> 0 then
            EndResponseWith404NotFound
        end if
        on error goto 0
        
        set controller.baseController.ControllerContext = controllerContext

        dim actionName

        if IsNull(m_actionNameInit) or IsEmpty(m_actionNameInit) then            
            actionName = GetActionNameFromRequest()
        else
            actionName = m_actionNameInit
        end if

        dim filters: filters = controller.GetFiltersForAction(actionName)
        dim i
        for i=0 to UBound(filters)
            filters(i).Execute(controllerContext)
        next

        dim params        
        if IsObject(controller.ModelBindForAction(actionName)) then
            set params = controller.ModelBindForAction(actionName)
        else 
            params = controller.ModelBindForAction(actionName)
        end if

        dim result
        aspCode = "controller." & actionName & "("
        if IsNull(params) or IsEmpty(params) then
            aspCode = aspCode
        elseif IsArray(params) then
            for i=0 to UBound(params)
                aspCode = aspCode & " " & "param(" & i & "),"
            next
            aspCode = Mid(aspCode, 1 ,Len(aspCode) - 1)
        else
            aspCode = aspCode & "params"
        end if
        aspCode = aspCode & ")"

        on error resume next
        set result = Eval(aspCode)
        if Err.number <> 0 then
            if Err.number = 438 then
                EndResponseWith404NotFound
            else                
                dim bufErrNumber: bufErrNumber = Err.number
                dim bufErrSource: bufErrSource = Err.Source
                dim bufErrDescription: bufErrDescription = Err.Description
                dim bufErrhelpfile: bufErrhelpfile = Err.helpfile
                dim bufErrHelpContext: bufErrHelpContext = Err.HelpContext
                on error goto 0
                call Err.Raise(bufErrNumber, bufErrSource, bufErrDescription, bufErrhelpfile, bufErrHelpContext)                
            end if            
        end if
        on error goto 0

        result.Execute        
    end sub

    private function GetControllerNameFromRequest()
        if not IsNull(Request.QueryString("controller")) and not IsEmpty(Request.QueryString("controller")) then
            GetControllerNameFromRequest = Request.QueryString("controller")
        else
            GetControllerNameFromRequest = ""
        end if
    end function

    private function GetActionNameFromRequest()
        if not IsNull(Request.QueryString("action")) and not IsEmpty(Request.QueryString("action")) then
            GetActionNameFromRequest = Request.QueryString("action")
            if Request.ServerVariables("REQUEST_METHOD") = "POST" then
                GetActionNameFromRequest = GetActionNameFromRequest & "_POST"
            end if
        else
            GetActionNameFromRequest = ""
        end if
    end function

    private sub EndResponseWith404NotFound()
        Response.Clear
        Response.Status = "404 Not Found"
        Response.End
    end sub
end class

class cController
    private m_name
    public ModelState
    public ViewBag
    public ControllerContext    

    Public Sub Class_Initialize()
		set ModelState = new cModelState
        set ViewBag = new cAssocArray
	End Sub 

    public function Init(name)
        m_name = name
        set Init = me
    end function

    public function View(viewName, model)       
        dim viewfile        
        viewfile = GetRootVirtual() & "/Views/" & m_name & "/" & viewname & ".view.asp"                    
        set View = (new cViewResult).Init(viewfile, model, ModelState, ViewBag)
    end function

    public function Redirect(url)
        set Redirect = (new cRedirectResult).Init(url)
    end function

    public function ModelBindForAction(actionName)        
    end function

    public function GetFiltersForAction(actionName)
        GetFiltersForAction = array()
    end function
end class

class cModelState
    public Errors()

    Public Sub AddError(error)			            
        dim n: n = UBound(Errors)
        if not IsEmpty(Errors(n)) then
            n = n + 1
        end if
        ReDim Preserve Errors(n)
        Errors(n) = error
	End Sub

    Public Property Get IsValid()	
		dim n: n = UBound(Errors)
        if (n = 0) and IsEmpty(Errors(0)) then
            IsValid = true
        else
            IsValid = false
        end if
	End Property

    Private Sub Class_Initialize()		
		ReDim Preserve Errors(0)
	End Sub
end Class

'-----------------------------------
'       Action Results
'-----------------------------------
class cViewResult    
    private m_model
    private m_viewfile
    private m_modelState
    private m_viewBag
    
    public function Init(viewfile, model, modelState, viewBag)
        if IsObject(model) then
            set m_model = model
        else
            m_model = model
        end if

        m_viewfile = viewfile        
        set m_modelState = modelState
        set m_viewBag = viewBag

        set Init = me
    end function
        
    public sub Execute()
        if IsObject(m_model) then
            set Session("model") = m_model
        else
            Session("model") = m_model
        end if
        set Session("ModelState") = m_modelState
        set Session("ViewBag") = m_viewBag
        
        Server.Execute(m_viewfile)
        
        Session.Contents.Remove("model")
        Session.Contents.Remove("ModelState")        
        Session.Contents.Remove("ViewBag")                
    end sub
end class

class cEmptyResult  
    public sub Execute()    
    end sub
end class

class cJSONResult
    private m_data

    public function Init(data)
        set m_data = data
        set Init = me
    end function

    public sub Execute()
        dim json
        json = (new JSON).toJSONSimple(m_data)
        
        Response.AddHeader "Content-Type", "application/json; charset=utf-8"
        Response.Write(json)        
    end sub
end class

class cRedirectResult
    private m_url

    function Init(url)
        m_url = url

        set Init = me
    end function

    public sub Execute()
        Response.Redirect(m_url)
        Response.End
    end sub
end class

'-----------------------------------
'       Action Filters
'-----------------------------------
class cAuthFilter
    private m_roles
    
    public function Init(roles)        
        m_roles = roles        
        set Init = me
    end function
    
    public sub Execute(controllerContext)                 
        if IsNull(controllerContext) or controllerContext.User.Identity.IsAuthenticated <> true then
            ResponseForbidden
        end if

        dim user: set user = controllerContext.User
        dim i
        dim isAuth: isAuth = false
        if not IsNull(m_roles) then
            if IsArray(m_roles) then                
                for i=0 to UBound(m_roles)
                    if user.IsInRole(m_roles(i)) then
                        isAuth = true
                        exit for
                    end if
                next            
            else
                if user.IsInRole(m_roles) then
                    isAuth = true
                end if
            end if
        end if

        if not isAuth then
            ResponseForbidden
        end if

    end sub

    private sub ResponseForbidden()
        Response.Clear        
        Response.Status = "403 Forbidden"
        Response.End    
    end sub
end class
%>