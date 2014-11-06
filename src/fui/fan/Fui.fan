using concurrent
using dom
using proj

@Js
class Fui {
  [Str:AppSpec]? appMap
  Uri? baseUri
  
  Uri appUri( Str appName ) { baseUri + "app/$appName".toUri }
  AppSpec? curApp() { appMap[ Win.cur.uri.pathOnly.relTo( baseUri ).path[ 1 ] ] }
  
  static Fui cur() { Actor.locals[ "fui.cur" ] }
}
