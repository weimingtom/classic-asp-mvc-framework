<%

class cMyUser 'IPrincipal
    'My properies...
    
    'Identity
    public IsAuthenticated
    public property Get Name
        Name = PartnerId
    end property    

end class

'implement interface 
'           ValidateUser
'           GetUser
class cMyMembershipProvider
    public connectionString
    
    public function Init(connString)
        connectionString = connString
        set Init = me
    end function

    public function ValidateUser(userid, password)        
        '.....          
    end function

    public function GetUser(userid)        
        '....
    end function
    
end class
%>