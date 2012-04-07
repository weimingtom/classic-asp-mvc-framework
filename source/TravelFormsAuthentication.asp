<%
class cTravelGeneralPrincipal
    public Identity
    
    Private Sub Class_Initialize()		
		set Identity = new cTravelUser
	End Sub

    public function IsInRole(role)
        IsInRole = false
        if (role = "fulladmin") then
            IsInRole = Identity.IsFullAdmin
        end if
    end function
end class

'interface IPrincipalBuilder
'  IPrincipal Create()
class cTravelPrincipalFactory    
    
    public function Create()        
        set Create = new cTravelGeneralPrincipal
    end function
end class

%>