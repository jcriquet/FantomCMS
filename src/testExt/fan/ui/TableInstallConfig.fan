using fwt
using webfwt

@Js
class TableInstallConfig : TableConfig {
  new make( TestApp app ) : super( app, "Meter Installs", `installs` ) {}
  
  override once Str:Obj items() { [
    "meter_id" : "",
    "install_date" : "",
    "physical_id" : "",
    "register_id" : "",
    "mxu_id" : "",
  ] }
}
