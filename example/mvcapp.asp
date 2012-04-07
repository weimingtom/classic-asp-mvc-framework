<!-- #include virtual="/libs/SerializationJSON.asp" -->
<!-- #include virtual="/libs/Collections.asp" -->
<!-- #include virtual="/libs/MVC.asp" -->
<!-- #include virtual="/libs/ValidationBlock.asp" -->
<!-- #include virtual="/libs/FormsAuthentication.asp" -->
<!-- #include virtual="/libs/MyMembershipProvider.asp" -->
<!-- #include virtual="/libs/MyFormsAuthentication.asp" -->

<!-- #include virtual="/Controllers/HotelsController.asp" -->
<!-- #include virtual="/Controllers/AccountController.asp" -->
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