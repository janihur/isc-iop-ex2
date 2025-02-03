Class janihur.BusinessOperation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Parameter APPLICATIONNAME = "isciopex2-client";

Parameter SESSIONID = "oauth-session-id";

Method Call(request As Ens.Request, Output response As Ens.Response) As %Status
{
	#dim status as %Status = $$$OK
	set httpRequest = ##class(%Net.HttpRequest).%New()

	// authentication ---------------------------------------------------------

	#dim error As %OAuth2.Error = $$$NULLOREF
	#dim accessToken As %String = ""
	#dim isAuthorized as %Boolean = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#APPLICATIONNAME,..#SESSIONID,,.accessToken,,,.error)
	
	if ($isobject(error)) {
		$$$TRACE("IsAuthorized() returned an error: "_error.AsString())
		$$$TRACE("Ignoring the error and trying to re-authenticate")
		set error = $$$NULLOREF
	}

	$$$TRACE("isAuthorized: "_isAuthorized)

	if ('isAuthorized) {
		$$$TRACE("Re-authenticating")
		set status = ##class(%SYS.OAuth2.Authorization).GetAccessTokenClient(..#APPLICATIONNAME,,,.error,..#SESSIONID)

		// status: connectivity issues
		if ($$$ISERR(status)) {
			set msg = "GetAccessTokenClient() returned an error."
			set msg = msg _ " Error codes: "_##class(%SYSTEM.Status).GetErrorCodes(status)
			set msg = msg _ " Error text: "_##class(%SYSTEM.Status).GetErrorText(status)
			$$$TRACE(msg)
			return status
		}

		// error: oauth error
		if ($isobject(error)) {
			return $$$ERROR(5001,"GetAccessTokenClient() returned an error: "_error.AsString())
		}
	}

	set status = ##class(%SYS.OAuth2.AccessToken).AddAccessToken(httpRequest,"header",,..#APPLICATIONNAME,..#SESSIONID)

	if $$$ISERR(status) {
		set msg = "AddAccessTokenClient() returned an error."
		set msg = msg _ " Error codes: "_##class(%SYSTEM.Status).GetErrorCodes(status)
		set msg = msg _ " Error text: "_##class(%SYSTEM.Status).GetErrorText(status)
		$$$TRACE(msg)
		return status
	}

	// actual http request ---------------------------------------------------

	$$$TRACE("Making the actual HTTP request")
	#dim httpResponse as %Net.HttpResponse = $$$NULLOREF
	set status = httpRequest.SetHeader("Accept","application/json;charset=utf-8")

	if $$$ISERR(status) {
		$$$TRACE("SetHeader() returned an error: "_status)
		return status
	}

	set status = ..Adapter.SendFormDataArray(.httpResponse,"GET",httpRequest)

	if $$$ISERR(status) {
		$$$TRACE("SendFormDataArray() returned an error: "_status)
		return status
	}

	do httpResponse.Data.Rewind()
	$$$TRACE("HTTP response: "_httpResponse.Data.Read())
	do httpResponse.Data.Rewind()

	return status
}

ClassMethod RevokeAuth()
{
	if (##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#APPLICATIONNAME, ..#SESSIONID)) {
		do ##class(%SYS.OAuth2.AccessToken).RemoveAccessToken(..#APPLICATIONNAME, ..#SESSIONID)
	}
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Ens.Request">
    <Method>Call</Method>
  </MapItem>
</MapItems>
}

}
