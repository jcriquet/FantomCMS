using concurrent
using dom
using fwt
using gfx
using proj
using util

@Js
class Main : ContentPane {
  private ContentPane appContainer := ContentPane()
  HeaderPane headerPane { private set }
  FooterPane footerPane { private set }
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
      center = appContainer
      top = headerPane = HeaderPane()
      bottom = footerPane = FooterPane()
    }
  }
  
  Void addFooterItem(FooterPaneDockItem item){
    this.footerPane.addFooterItem(item)
  }

  Void removeFooterItem(FooterPaneDockItem item){
    this.footerPane.removeFooterItem(item)
  }
  
  // Sample input: `fui://app/home`
  Void goto( Uri uri ) {
    token := uri.scheme
    if ( token == "fui" ) {
      token = uri.host
      if ( token == "app" ) {
        token = uri.path[ 0 ]
        newUri := token != "home" ? Fui.cur.appUri( token ) + uri[ 1..-1 ] : Fui.cur.baseUri
        if ( newUri.relTo( Win.cur.uri.pathOnly ).toStr != "" || Win.cur.uri.frag != newUri.frag ) Win.cur.hisPushState( token, newUri, [:] )
        _reload
        curApp.onGoto
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
    if ( appSpec != curApp?.spec ) {
      curApp = (App) Type.find( appSpec.qname ).make
      curApp.spec = appSpec
      appContainer.content = curApp
      appContainer.relayout
    }
    Fui.cur.updateTitle
  }
  
  Void main() {
    Env.cur.vars.each |v, k| { Actor.locals[ k ] = v }
    fui := Fui.cur
    _setContent( fui.appMap[ Env.cur.vars[ "fui.app" ] ] )
    window := Window { it.content = this }.open
    //Win.cur.onEvent( "hashchange", false ) { echo( "hashchange" ); curApp.reload }
    Win.cur.onEvent( "popstate", false ) { _reload }
    Win.cur.onEvent( "error", false ) { echo( "JS Event: Error" ) }
    Win.cur.onEvent( "beforeunload", false ) |e| {
      echo( "JS Event: Before unload" )
      msg := curApp.onBeforeLeave
      if ( msg != null ) e.meta[ "beforeunloadMsg" ] = msg
    }
    Actor.locals[ "appLoaded" ] = true // Do we need this?
    curApp.reload
    curApp.onGoto
  }
}
