<%@ Page Language="VB"%>
<script runat="server"> 
	Public Function getSecureKey() As String

		 ' define parts of the SecureKey request URL
		 Dim strGetKeyURL As String = "http://localhost/NTrustPOC/rdTemplate/rdGetSecureKey.aspx?Username=Admin&Roles=" & Session("UserRoles") & "&Rights=" & Session("UserRights")
		 Dim strClientAddr As String = "&ClientBrowserAddress=0.0.0.0"

		 ' define web request and response receiver
		 Dim webRequest As Net.HttpWebRequest
		 Dim webResponse As Net.WebResponse
		 
		 'Response.Write(strGetKeyURL & strClientAddr)
		 'Response.End()
		 webRequest = Net.HttpWebRequest.Create(strGetKeyURL & strClientAddr)

		 ' send the SecureKey request to the Logi app
		 Try
			 webResponse = webRequest.GetResponse()
		 Catch ex As Exception
			 ' if server has Basic or NTLM authentication, try to set creds from the current process
			 If ex.Message.IndexOf("401") <> -1 Then
				 webRequest.Credentials = Net.CredentialCache.DefaultCredentials
				 webResponse = webRequest.GetResponse()
			 Else
				 Throw ex
			 End If
		 End Try

		 ' receive the response and return it as function result
		 Dim sr As New IO.StreamReader(webResponse.GetResponseStream())
		 getSecureKey = sr.ReadToEnd()

	End Function

	Protected Sub lbtnReports_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbtnReports.Click

		' identify the Logi report definition to be displayed by this menu item or link
		Dim strLogiDefName As String = "InfoGo.goHome"

		' get a SecureKey for this request
		Dim strSecureKey As String = getSecureKey()

		'redirect to Logi app
		Response.Redirect("~/rdPage.aspx?rdReport=" & strLogiDefName _
		   & "&rdSecureKey=" & strSecureKey)

	End Sub
</script>

<html>
	<head>
		<META name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Logon</title>
		<link type="text/css" rel="stylesheet" href="_SupportFiles/css.AppStyles.css" />
		<link type="text/css" rel="stylesheet" href="_SupportFiles/css.login.css" />
	</head>
	<body>	
		<form id="frmLogon" runat="server">	
			<div class="card logonWell">
				<div class="card-body">
					<div class="row">
						<div class="col">
							<div class="media">
								<div class="media-left">
									<img class="img-rounded" src="_SupportFiles/favicon/apple-touch-icon-57x57.png" width="57" height="57" alt="Login">
								</div>
								<div class="media-body">
									<i class="fa fa-key fa-2x pull-right"></i>
									<h1 class="media-heading">Login</h1>
									<span id="signInHelp" class="help-block">Enter your username and password to log on:</span>
								</div>
							</div>
							<span id="lblLogon"></span>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="input-group">
								<div class="input-group-addon" id="basic-addon1"><i class="glyphicon glyphicon-user"></i></div>
								<input class="form-control" id="rdUsername" type="text" name="rdUsername" placeholder="Username" value="Admin" disabled="true" />
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="input-group">
								<div class="input-group-addon" id="basic-addon1"><i class="glyphicon glyphicon-lock"></i></div>
								<input class="form-control" id="rdPassword" type="password" name="rdPassword" placeholder="Password" value="password" disabled="true" />
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<asp:Button id="lbtnReports" runat="server" CssClass="btn btn-primary btn-block" onclick="lbtnReports_Click" Text="Sign in" />
							<div class="remember">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="checkbox" style="display:none">
								<label>
								  <input type="checkbox"/> Remember me
								</label>
							</div>
							<% If Not String.IsNullOrEmpty(Session("rdLogonFailMessage")) Then %>
								<div class="alert alert-danger" role="alert">
									<%=Session("rdLogonFailMessage") %>
								</div>
							<% End If %>
						</div>
					</div>
				</div>
			</div>
			<input id="rdFormLogon" type="hidden" name="rdFormLogon" value="True"/>
		</form>
	</body>
</html>