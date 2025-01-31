Class janihur.Runner
{

ClassMethod Run() As %Status
{
	#dim service as janihur.BusinessService = $$$NULLOREF
	set status = ##class(Ens.Director).CreateBusinessService("BusinessService",.service)

	set request = ##class(Ens.Request).%New()
	#dim response as Ens.Response = $$$NULLOREF

	return service.OnProcessInput(request,.response)
}

}
