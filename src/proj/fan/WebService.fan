using wisp
using web
using webmod

const class WebService : WispService {
  new make() : super( |WispService me| {
    podMap := Str:PodMod[:]
    Env.cur.findAllPodNames.each |pod| { podMap[ pod ] = PodMod( pod ) }
    
    exts := Str:Type[:]
    Env.cur.index( "proj.ext" ).each |qname| {
      type := Type.find( qname )
      name := ( type.facets.find |f| { f is ExtMeta } as ExtMeta )?.name
      if ( type.fits( Ext# ) && name != null ) exts[ name ] = type
    }
    
    root = RouteMod { it.routes = [
        "pod" : RouteMod { it.routes = podMap },
        "api" : ApiMod( exts ),
        "app" : AppMod( exts )
      ] }
  } ) {
  }
}
