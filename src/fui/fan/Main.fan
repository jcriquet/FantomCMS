using concurrent
using dom
using fwt
using gfx
using proj
using util

@Js
class Main : StatePane {
  private BorderPane appContainer := BorderPane()
  EdgePane windowEdgePane := EdgePane { center = appContainer } { private set }
  //HeaderPane headerPane { private set }
  //FooterPane footerPane { private set }
  App? curApp { private set }

  new make() : super() {
    vars := Env.cur.vars
    fui := Fui( this ) {
      title = vars[ "fui.title" ] ?: ""
      appMap = ( (Str:Obj?) JsonInStream( vars[ "fui.apps" ].in ).readJson ).map |Str:Str map->AppSpec| { AppSpec.makeFromMap( map ) }
      exts = ( (Obj?[]) JsonInStream( vars[ "fui.exts" ].in ).readJson ).map |str->Str| { str }
      permissions = Env.cur.vars["fui.perms"].split(',')
      baseUri = vars[ "fui.baseUri" ].toUri
    }

    Actor.locals[ "fui.cur" ] = fui
    content = ThemedBorderPane {
      bgStyle = "window"
      windowEdgePane,
    }
  }
  
  Void refreshLayout() {
    try { windowEdgePane.top = ( Actor.locals[ "layouts.paneTop" ] as Str ?: "null" ).in.readObj as Widget }
    catch ( Err e ) { windowEdgePane.top = Label { text = "Error: $e" } }
    try { windowEdgePane.bottom = ( Actor.locals[ "layouts.paneBottom" ] as Str ?: "null" ).in.readObj as Widget }
    catch ( Err e ) { windowEdgePane.bottom = Label { text = "Error: $e" } }
    try { windowEdgePane.left = ( Actor.locals[ "layouts.paneLeft" ] as Str ?: "null" ).in.readObj as Widget }
    catch ( Err e ) { windowEdgePane.left = Label { text = "Error: $e" } }
    try { windowEdgePane.right = ( Actor.locals[ "layouts.paneRight" ] as Str ?: "null" ).in.readObj as Widget }
    catch ( Err e ) { windowEdgePane.right = Label { text = "Error: $e" } }
    try { content.relayout }
    catch ( Err e ) { windowEdgePane.each |widget| { try { widget.relayout } catch {} } }
  }
  
  static Uri resolve( Uri uri, Bool keepApp := false ) {
    token := uri.scheme
    if ( token == "fui" ) {
      token = uri.host
      if ( !keepApp || token != "app" ) {
        if ( uri == `fui://app/home/` ) return Fui.cur.baseUri + ( ( uri.auth ?: "" ) + uri.relToAuth.toStr ).toUri[ 0..-3 ]
        return Fui.cur.baseUri + ( ( uri.auth ?: "" ) + uri.relToAuth.toStr ).toUri
      }
    }
    return uri
  }
  
  // Sample input: `fui://app/home`
  Void goto( Uri uri ) {
    uri = resolve( uri, true )
    if ( uri.scheme == "fui" ) {
      token := uri.path[ 0 ]
      if ( token != "login" && Fui.cur.permissions.index( token ) == null ) {
        goto( `fui://app/login/` )
        return
      }
      newUri := token != "home" ? Fui.cur.appUri( token ) + uri[ 1..-1 ] : Fui.cur.baseUri
      if ( newUri.relTo( Win.cur.uri.pathOnly ).toStr != "" || Win.cur.uri.frag != newUri.frag ) Win.cur.hisPushState( token, newUri, [:] )
      _reload
      curApp.onGoto
    } else Win.cur.hyperlink( uri )
  }
  
  private Void _reload() {
    app := Fui.cur.curApp
    if ( app == null ) goto( `fui://app/home/` )
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
    refreshLayout
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
