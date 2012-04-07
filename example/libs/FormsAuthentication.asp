<%
'interface IPrincipal
'   IIdentity Identity
'   bool IsInRole(role)
class cGeneralPrincipal
    public Identity
    
    Private Sub Class_Initialize()		
		set Identity = new cGeneralIdentity
	End Sub

    public function IsInRole(role)

    end function
end class

'interface IIdentity
'   string Name
'   bool IsAuthenticated
class cGeneralIdentity
    public Name
    public IsAuthenticated

     Private Sub Class_Initialize()		
		IsAuthenticated = false
	End Sub
end class

class cASPNETFormsAuthenticationModule
    
    private m_membershipProvider    
    private m_principalFactory

    public function Init(membershipProvider, principalFactory)
        set m_membershipProvider = membershipProvider        
        set m_principalFactory = principalFactory

        set Init = me
    end function
    
    public function AuthenticateRequest()                
        dim username: username = Request.ServerVariables("AUTH_USER")

        dim principal
        if IsNull(m_principalFactory) then
            set principal = m_principalFactory.Create
        else
            set principal = new cGeneralPrincipal
        end if
        
        dim identity
        if username <> "" then            
            set identity = m_membershipProvider.GetUser(username)
            if (not IsNull(identity)) then            
                set principal.Identity = identity
            end if            
            principal.Identity.IsAuthenticated = true
        end if

        set AuthenticateRequest = principal
    end function 
    
end class

class cFormsAuthenticationModule
    
    private m_membershipProvider    
    private m_principalFactory
    public FormsCookieName

    Private Sub Class_Initialize()		
		FormsCookieName = "ASP_AUTH" 
	End Sub

    public sub SetAuthCookie(username, isCreatePersistentCookie)
        if createPersistentCookie = false then
            Response.Cookies("SessionID") = Session.SessionID
            Response.Cookies(FormsCookieName) = username
        else
        end if
    end sub

    public function Init(membershipProvider, principalFactory)
        set m_membershipProvider = membershipProvider        
        set m_principalFactory = principalFactory

        set Init = me
    end function

    public function AuthenticateRequest()        
        dim authSessionId: authSessionId = Request.Cookies("SessionID")
        dim username: username = Request.Cookies(FormsCookieName)
        
        dim principal
        if not IsNull(m_principalFactory) then
            set principal = m_principalFactory.Create
        else
            set principal = new cGeneralPrincipal
        end if
        
        dim identity: set identity = nothing
        if (authSessionId = Session.SessionID) then
            set identity = m_membershipProvider.GetUser(username)            
            if (not IsNull(identity)) then            
                set principal.Identity = identity
            end if            
            principal.Identity.IsAuthenticated = true
        end if        

        set AuthenticateRequest = principal
    end function 

end class

class cEmptyMVCAuthenticationModule
    
    public function AuthenticateRequest()                
        set AuthenticateRequest = new cGeneralPrincipal
    end function    

end class

sub FormsAuthentication_SetAuthCookie(username, isCreatePersistentCookie)
    Global_FormsAuthenticationModule.SetAuthCookie username, isCreatePersistentCookie
end sub

%>