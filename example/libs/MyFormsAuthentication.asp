<%
class cMyGeneralPrincipal
    public Identity
    
    Private Sub Class_Initialize()		
		set Identity = new cMyUser
	End Sub

    public function IsInRole(role)
        '....
    end function
end class

'interface IPrincipalBuilder
'  IPrincipal Create()
class cMyPrincipalFactory    
    
    public function Create()        
        set Create = new cMyGeneralPrincipal
    end function
end class

%>