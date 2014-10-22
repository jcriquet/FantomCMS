using concurrent
using proj

@Js
class Fui {
  [Str:AppSpec]? appMap
  Uri? baseUri
  
  Uri appUri( Str appName ) { baseUri + "proj/$appName".toUri }
  
  static Fui cur() { Actor.locals[ "fui.cur" ] }
}
