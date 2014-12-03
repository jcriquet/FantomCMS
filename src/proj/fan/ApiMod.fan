using util
using concurrent
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
    
    allowed := false
    try if(AppMod.checkUserPerm != null){
      Str? user := Actor.locals["proj.curUser"]
      allowed = (Bool)AppMod.checkUserPerm.call(user, appStr)
    }catch(Err e){echo(e)}

    if(!allowed){
      res.sendErr(403)
      return
    }

    route := exts[ appStr ].make as Weblet
    if ( route == null ) { res.sendErr( 404 ); return }
    req.modBase += "$appStr/".toUri
    route.onService
  }
  
  override Void onStart() {}
}
