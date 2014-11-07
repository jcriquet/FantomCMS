using concurrent
using dom
using proj

@Js
class Fui {
  fui::Main main { private set }
  [Str:AppSpec]? appMap
  Uri? baseUri
  
  new make( fui::Main main ) {
    this.main = main
  }
  
  Uri appUri( Str appName ) { baseUri + "app/$appName".toUri }
  AppSpec? curApp() { appMap[ Win.cur.uri.pathOnly.relTo( baseUri ).path[ 1 ] ] }
  
  static Fui cur() { Actor.locals[ "fui.cur" ] }
}
