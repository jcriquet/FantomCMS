using wisp
using web
using webmod

const class WebService : WispService {
  new make() : super( |WispService me| {
    port := Env.cur.config( typeof.pod, "server.port" )?.toInt
    if ( port == null ) {
      port = 8080
      file := Env.cur.homeDir + `etc/proj/config.props`
      echo( file.normalize.pathStr )
      props := file.exists ? file.readProps : Str:Str[:]
      file.create.writeProps( props[ "server.port" ] = port.toStr )
    }
    me.port = port
    
    podMap := Str:PodMod[:]
    Env.cur.findAllPodNames.each |pod| { podMap[ pod ] = PodMod( pod ) }
    
    exts := Str:Type[:]
    Env.cur.index( "proj.ext" ).each |qname| {
      type := Type.find( qname )
      name := ( type.facets.find |f| { f is ExtMeta } as ExtMeta )?.name
      if ( type.fits( Ext# ) && name != null ) exts[ name ] = type
    }
    
    DBConnector.cur.startup( exts.keys )
    
    root = RouteMod { it.routes = [
        "pod" : RouteMod { it.routes = podMap },
        "api" : ApiMod( exts ),
        "app" : AppMod( exts )
      ] }
  } ) {
  }
}
