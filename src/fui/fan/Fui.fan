using concurrent
using dom
using proj

@Js
class Fui {
  fui::Main main { private set }
  Str? title
  [Str:AppSpec]? appMap
  Uri? baseUri
  
  new make( fui::Main main ) {
    this.main = main
  }
  
  Uri appUri( Str appName ) { baseUri + "app/$appName/".toUri }
  AppSpec? curApp() { appMap[ Win.cur.uri.pathOnly.relTo( baseUri ).path.getSafe( 1 ) ?: "home" ] }
  Void updateTitle() { Win.cur.doc.title = title + " - " + ( main.curApp.curTitle ?: curApp.label ) }
  
  static Fui cur() { Actor.locals[ "fui.cur" ] }
}
