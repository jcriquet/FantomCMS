using db
using concurrent
using wisp
using web
using webmod

const class WebService : WispService {
  new make() : super( |WispService me| {
    port := Env.cur.config( typeof.pod, "server.port" )?.toInt
    if ( port == null ) {
      port = 8080
      file := Env.cur.homeDir + `etc/proj/config.props`
      props := file.exists ? file.readProps : Str:Str[:]
      file.create.writeProps( props[ "server.port" ] = port.toStr )
    }
    me.port = port
    
    podMap := Str:PodMod[:]
    Env.cur.findAllPodNames.each |pod| { podMap[ pod ] = PodMod( pod ) }
    
    exts := Str:Type[:]
    Env.cur.index( "proj.ext" ).each |qname| {
      type := Type.find( qname )
      if ( !type.fits( Ext# ) ) return
      meta := ( type.facets.find |f| { f is ExtMeta } as ExtMeta )
      if ( meta != null ) exts[ meta.name ] = type
    }
    
    DBConnector.cur.startup( exts.vals )
    try { DBConnector.cur.db } catch ( Err e ) { exts = exts.findAll |t, name| { name == "settings" || name == "login" || name == "home" } }
    
    appMod := AppMod( exts )
    root = RouteMod { it.routes = [
        "index" : IndexMod( appMod ),
        "pod" : RouteMod { it.routes = podMap },
        "api" : ApiMod( exts ),
        "app" : appMod
      ] }
  } ) {
  }
}
