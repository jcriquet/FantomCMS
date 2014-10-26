using util
using web

const class ApiMod : WebMod {
  const Str:Type exts
  
  new make( Str:Type exts ) {
    this.exts = exts
  }
  
  override Void onService() {
    appStr := req.modRel.path[ 0 ]
//    queryRow := Database.query( "SELECT TRUE FROM webserv.project_ext WHERE project_id = '$projStr' AND ext_name = '$appStr'" ).getSafe( 0 )
    
    notFound := !exts.containsKey( appStr )// || queryRow == null
    if ( notFound ) { res.sendErr( 404 ); return }
    
    route := exts[ appStr ].make as Weblet
    if ( route == null ) { res.sendErr( 404 ); return }
    req.modBase += "$appStr/".toUri
    route.onService
  }
  
  override Void onStart() {}
}
