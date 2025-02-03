Class janihur.BusinessService Extends Ens.BusinessService
{

Method OnProcessInput(request As Ens.Request, Output response As Ens.Response) As %Status
{
	return ..SendRequestSync("BusinessOperation",request,.response)
}

}
