<!-- #include file="FSOConstants.asp" -->
<!-- #include file="Collections.asp" -->
<!-- #include file="LoggingBlock.asp" -->
<% 

sub WriteErrorMessage()
    dim logger
    set logger = new cLogWritter
    logger.LogPath = "C:\sites\realrussia.co.uk\realrussia\wwwroot\logs\russian\"
    logger.LogFilePrefix = "tourist"

    logger.WriteError("test")
end sub

sub WriteInfoMessage()
    dim logger
    set logger = new cLogWritter
    logger.LogPath = "C:\sites\realrussia.co.uk\realrussia\wwwroot\logs\russian\"
    logger.LogFilePrefix = "tourist"

    logger.WriteInfo("test")
end sub

sub WriteErrorToTarget()
    dim logger
    set logger = new cLogWritter
    logger.LogPath = "C:\sites\realrussia.co.uk\realrussia\wwwroot\logs\russian\"
    logger.LogFilePrefix = "tourist"
    logger.AddTarget "target", "targettest.log"

    logger.WriteInfoToTarget "test", "target"
end sub

WriteErrorMessage
WriteInfoMessage
WriteErrorToTarget
 %>