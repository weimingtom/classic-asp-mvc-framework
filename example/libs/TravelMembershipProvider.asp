<%

class cTravelUser 'IPrincipal
    public Id
    public PartnerId
    public PartnerName
    public IsHasAdminRights
    public IsFullAdmin
    public IsHasCreditVSD
    public Status
    
    'IPrincipal
    public IsAuthenticated
    public property Get Name
        Name = PartnerId
    end property

    Private Sub Class_Initialize()		
		IsHasAdminRights = false
        IsFullAdmin = false
        IsHasCreditVSD = false
        IsAuthenticated = false
	End Sub

end class

'implement interface 
'           ValidateUser
'           GetUser
class cTravelMembershipProvider
    public connectionString
    
    public function Init(connString)
        connectionString = connString
        set Init = me
    end function

    public function ValidateUser(userid, password)        
        dim rs       
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open "SELECT Count(*) as count FROM acl WHERE partnerID='" & userid & "' AND password='" & password & "'", connectionString, 3, 4
        if rs("count") > 0 then
            ValidateUser = true
        else
            ValidateUser = false
        end if

        rs.Close
        Set rs = nothing            
    end function

    public function GetUser(userid)        
        dim rs
        dim user
        set user = nothing
        
        set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open "SELECT * FROM acl WHERE partnerID='" & userid & "'", connectionString, 3, 4
        if not rs.EOF Then
            set user = new cTravelUser
            user.Id = rs("ID") 
            user.PartnerName = rs("partnerName")
            user.PartnerId = rs("partnerID")
            if rs("realrussiaadmin") = "yes" then
                user.IsHasAdminRights = true        
            end if
		    user.Status = rs("status")
            if rs("fullAdmin") = "yes" then
                user.IsFullAdmin = true        
            end if
		    user.IsHasCreditVSD = rs("isInvitationCredit")        
        end if

        rs.Close
        Set rs = nothing    

        set GetUser = user
    end function
    
end class
%>