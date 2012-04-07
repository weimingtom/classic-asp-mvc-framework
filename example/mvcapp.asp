<!-- #include virtual="/libs/SerializationJSON.asp" -->
<!-- #include virtual="/libs/Collections.asp" -->
<!-- #include virtual="/libs/MVC.asp" -->
<!-- #include virtual="/libs/ValidationBlock.asp" -->
<!-- #include virtual="/libs/ADOConstants.asp" -->
<!-- #include virtual="/libs/FormsAuthentication.asp" -->
<!-- #include virtual="/libs/TravelMembershipProvider.asp" -->
<!-- #include virtual="/libs/TravelFormsAuthentication.asp" -->

<!-- #include virtual="/ssl/Model/Entities.asp" -->
<!-- #include virtual="/ssl/Model/HotelsRepository.asp" -->

<!-- #include virtual="/ssl/Controllers/HotelsController.asp" -->
<!-- #include virtual="/ssl/Controllers/AccountController.asp" -->
<%
class cApp
    private baseApp
    Public Sub Class_Initialize()
		set baseApp = (new cMVCApplication)
        dim membershipProvider: set membershipProvider = (new cTravelMembershipProvider).Init(Application("TravelConnectionString"))
        baseApp.AuthenticationModule.Init membershipProvider, new cTravelPrincipalFactory
	End Sub 

    public sub Run()
        baseApp.Run
    end sub
end class
    
dim app
set app = new cApp
app.Run
%>