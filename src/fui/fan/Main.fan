using concurrent
using dom
using fwt
using gfx
using proj
using util

@Js
class Main : ContentPane {
  private ContentPane appContainer := ContentPane()
  private FooterPane footPane
  App? curApp { private set }

  new make() : super() {
    vars := Env.cur.vars
    fui := Fui( this ) {
      title = vars[ "fui.title" ] ?: ""
      appMap = ( (Str:Obj?) JsonInStream( vars[ "fui.apps" ].in ).readJson ).map |Str:Str map->AppSpec| { AppSpec.makeFromMap( map ) }
      baseUri = vars[ "fui.baseUri" ].toUri
    }

    Actor.locals[ "fui.cur" ] = fui
    content = EdgePane {
      top = HeaderPane()
      center = appContainer
      bottom = FooterPane() { this.footPane = it }
    }
  }
  
  Void addFooterItem(FooterPaneDockItem item){
    this.footPane.addFooterItem(item)
  }
  
  // Sample input: `fui://app/home`
  Void goto( Uri uri ) {
    token := uri.scheme
    if ( token == "fui" ) {
      token = uri.host
      if ( token == "app" ) {
        token = uri.path[ 0 ]
        newUri := token != "home" ? Fui.cur.appUri( token ) : Fui.cur.baseUri
        if ( Win.cur.uri.pathOnly.relTo( newUri ).toStr != "" || Win.cur.uri.frag != newUri.frag ) Win.cur.hisPushState( token, newUri, [:] )
        _reload
      } else Win.cur.hyperlink( Fui.cur.baseUri + uri.pathOnly )
    }
  }
  
  private Void _reload() {
    app := Fui.cur.curApp
    if ( app == null ) return
    _setContent( app )
    curApp.reload
  }
  
  // Be sure to call curApp.onReady after this
  private Void _setContent( AppSpec appSpec ) {
    curApp = (App) Type.find( appSpec.qname ).make
    curApp.spec = appSpec
    appContainer.content = curApp
    Fui.cur.updateTitle
    appContainer.relayout
  }
  
  // getOption checks the database for config options
  // TODO: interface with db
  Obj getOption( Str opt ) {
    switch ( opt ) {
      case "bgcolor": return Gradient("0% 50%, 100% 50%, #f00 0.1, #00f 0.9")
      default:        throw Err("Option not found")
    }
  }
  
  Void main() {
    fui := Fui.cur
    _setContent( fui.appMap[ Env.cur.vars[ "fui.app" ] ] )
    window := Window { it.content = this }.open
    Win.cur.onEvent( "hashchange", false ) { curApp.reload }
    Win.cur.onEvent( "popstate", false ) { _reload }
    Win.cur.onEvent( "error", false ) { echo( "JS Event: Error" ) }
    Win.cur.onEvent( "beforeunload", false ) |e| {
      echo( "JS Event: Before unload" )
      msg := curApp.onBeforeLeave
      if ( msg != null ) e.meta[ "beforeunloadMsg" ] = msg
    }
    Actor.locals[ "appLoaded" ] = true // Do we need this?
    curApp.reload
  }
}
