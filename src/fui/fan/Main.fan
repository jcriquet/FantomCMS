using concurrent
using dom
using fwt
using gfx
using proj
using util

@Js
class Main : ContentPane {
  private ContentPane appContainer := ContentPane()
  App? curApp { private set }

  new make() : super() {
    vars := Env.cur.vars
    fui := Fui( this ) {
      appMap = ( (Str:Obj?) JsonInStream( vars[ "fui.apps" ].in ).readJson ).map |Str:Str map->AppSpec| { AppSpec( map[ "name" ], map[ "qname" ] ) }
      baseUri = vars[ "fui.baseUri" ].toUri
    }

    Actor.locals[ "fui.cur" ] = fui
    content = EdgePane {

      // Header
      top = HeaderPane()
      //BorderPane {
        //bg = getOption("bgcolor")
        //border = Border.fromStr( "0,0,3 outset #444444" )
        //HeaderPane(),
        //Button { text = "test" ; it.onAction.add { goto( `fui://app/login` ) } },
      //}
      
      // App Container
      center = appContainer
      
      // Footer
      bottom = BorderPane {
        bg = getOption("bgcolor")
        border = Border.fromStr( "3,0,0 outset #444444")
        ConstraintPane {
          minh = maxh = 50
          Label { text = "I'm a footer!" },
        },
      }
    }
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
