<%
class cAssocArray
    Private dicContainer
  
    Private Sub Class_Initialize()
        Set dicContainer=Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Class_Terminate()
        Set dicContainer=Nothing   
    End Sub

    Public Default Property Get Item(sName)
        If Not dicContainer.Exists(sName) Then
        dicContainer.Add sName,New AssocArray
        End If
        If IsObject(dicContainer.Item(sName)) Then
        Set Item=dicContainer.Item(sName)
        Else
        Item=dicContainer.Item(sName)
        End If   
    End Property

    Public  Property Let Item(sName,vValue)
        If dicContainer.Exists(sName) Then
        If IsObject(vValue) Then
            Set dicContainer.Item(sName)=vValue
        Else
            dicContainer.Item(sName)=vValue
        End If
        Else
        dicContainer.Add sName,vValue    
        End If
    End Property

    public Property Get Items
        set Items = dicContainer
    End Property

end class

class cPair
    public Key
    public Value
end class

class cDictionary
    private arr()
    private count

    Public Sub Class_Initialize()
		redim preserve arr(0)
        count = -1
	End Sub 

    public sub Add(key, value)
        dim n: n = count + 1
        redim preserve arr(n)
        
        dim pair: set pair = new cPair
        pair.Key = key
        pair.Value = value

        set arr(n) = pair
    end sub

    public function GetValueByKey(key)
        dim i
        for i=0 to UBound(arr)
            if arr(i).Key = key then
                GetValueByKey = arr(i).Value
                exit function
            end if
        next
    end function

    public function GetByKey(key)
        dim i
        for i=0 to UBound(arr)
            if arr(i).Key = key then
                set GetByKey = arr(i)
                exit function
            end if
        next
    end function

end class

Function InArray(element, arr)
    dim i
    For i=0 To Ubound(arr) 
        If Trim(arr(i)) = Trim(element) Then 
            in_array = True
            Exit Function
        Else 
            in_array = False
        End If  
    Next 
End Function
%>