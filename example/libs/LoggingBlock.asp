<%
'required #include file="FSOConstants.asp"
'required #include file="Collections.asp"

class cLogWritter
    public LogPath
    public LogFilePrefix

    private rules
    private targets

    Public Sub Class_Initialize()
	    set rules = new cDictionary
        set targets  = new cDictionary

        call targets.Add("default", "")
	End Sub 
    
    public sub UpdateTarget(name, value)		        
        dim target 
        set target = targets.GetByKey(name)
        target.Value = value
	end sub

    public sub AddTarget(name, filepath)
        call targets.Add(name, filepath)
    end sub

    public Sub AddRule(name, target)
        call rules.Add(name, target)
    end sub

    private function RequestFormToString()
        Dim postedData : postedData = "" 
        Dim i   

        for i=1 to Request.Form.Count
            postedData = postedData & Request.Form.Key(i) & "=" & Request.Form.Item(i) & "&"
        next
        RequestFormToString = postedData
    end function

    public sub WriteError(message)
        call WriteLog(message, "error", "default")
    end sub

    public sub WriteErrorToTarget(message, target)
        call WriteLog(message, "error", target)
    end sub

    public sub WriteInfo(message)
        call WriteLog(message, "info", "default")
    end sub
    
    public sub WriteInfoToTarget(message, target)
        call WriteLog(message, "info", target)
    end sub

    private sub WriteLog(message, logtype, targetname)
        dim fileStream,ff
        Dim ssPath    
        dim fileName, filePath, logTypePrefix
                
        fileName = targets.GetValueByKey(targetname)        

        dim postedData: postedData =  RequestFormToString()

        logTypePrefix = "_" & logtype & "_"        
        
        if (fileName = "") then
            fileName = LogFilePrefix & logTypePrefix & Year(Now) & "-" & Month(Now) & "-" & Day(Now) & ".log"
        end if        
        
        filePath = LogPath & fileName
        
        set fileStream=Server.CreateObject("Scripting.FileSystemObject") 

        If Not fileStream.FolderExists(LogPath) Then 
            call CreateFolder(LogPath, fileStream)            
        End If

        if not (fileStream.FileExists(filePath)) then
            set ff = fileStream.CreateTextFile(filePath, true, true)
        else
            set ff = fileStream.OpenTextFile(filePath, ForAppending, true, -1)    
        end if
        
        ff.write(vbCrLf & "-----------------------------------------" & vbCrLf)
        ff.write(FormatDateTime(Now) & " " & logtype & vbCrLf)
        ff.write(message & vbCrLf)
        ff.write("SCRIPT_NAME: " & Request.ServerVariables("SCRIPT_NAME")  & vbCrLf)
        ff.write("URL: " & Request.ServerVariables("URL")  & vbCrLf)        
        ff.write("QUERY_STRING: " & Request.QueryString  & vbCrLf)
        ff.write("Form:" & vbCrLf & vbCrLf & postedData)
        ff.write(vbCrLf & "-----------------------------------------" & vbCrLf)
        ff.close
        set ff=nothing
        set fileStream=nothing
    end sub    
    
    private sub CreateFolder(folderpath, fileStream)
        dim segments: segments = Split(folderpath, "\")
        dim i: i = 0
        
        dim curFolder: curFolder = segments(0)
        for i = 1 to UBound(segments)            
            if not IsNull(segments(i)) and not IsEmpty(segments(i)) and segments(i) <> "" then
                curFolder = curFolder & "\" & segments(i)
            
                If not fileStream.FolderExists(curFolder) Then 
                    fileStream.CreateFolder(curFolder)     
                end if           
                
            end if
        next

    end sub   

end class
%>