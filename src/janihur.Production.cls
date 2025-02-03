Class janihur.Production Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="janihur.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="BusinessService" Category="" ClassName="janihur.BusinessService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="BusinessOperation" Category="" ClassName="janihur.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">host.docker.internal</Setting>
    <Setting Target="Adapter" Name="HTTPPort">8080</Setting>
    <Setting Target="Adapter" Name="URL">/request</Setting>
    <Setting Target="Host" Name="FailureTimeout">6</Setting>
    <Setting Target="Adapter" Name="ResponseTimeout">2</Setting>
  </Item>
</Production>
}

}
