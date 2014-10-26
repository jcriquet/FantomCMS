using concurrent
using dom
using fwt
using proj

@Js
abstract class App : StatePane {
  private Bool inModify
  private Bool inLoad
  internal AppSpec? spec
  
  new make() {}
  
  virtual Str? onBeforeLeave() { null }
  
  Str name() { spec.name }
  
  Void onReady() {
    Win.cur.onEvent( "hashchange", false ) { _reload }
    Win.cur.onEvent( "beforeunload", false ) |e| {
      msg := onBeforeLeave
      if ( msg != null ) e.meta[ "beforeunloadMsg" ] = msg
    }
    Actor.locals[ "appLoaded" ] = true
    //Win.cur.onEvent( "error", false ) { _reload }
    json := Env.cur.vars[ "fui.appState" ]
    if ( Win.cur.uri.frag == null && json != null ) {
      key := _genKey
      Win.cur.sessionStorage[ key ] = json
      Win.cur.hyperlink( "#$key".toUri )
    }
    else _reload
  }
  
  HttpReq apiCall( Uri relPath, Str? app := null ) {
    if ( app == null ) app = name
    fui := Fui.cur
    req := HttpReq { uri = fui.baseUri + "api/$app/".toUri + relPath }
    return req
  }
  
  State loadState( Str key ) {
    json := Win.cur.sessionStorage[ key ]
    return json == null ? State() : State.fromStr( json )
  }
  
  Void modifyState() {
    if ( inLoad ) throw Err( "Cannot call modifyState during onLoadState" )
    state := State()
    onSaveState( state )
    inModify = true
    key := _genKey
    Win.cur.sessionStorage[ key ] = state.toStr
    Win.cur.hyperlink( "#$key".toUri )
  }
  
  private Str _genKey() { StrBuf().add( ( DateTime.nowTicks/1000000000 ).and( 4294967295 ).toHex( 8 ) ).addChar( 45 ).add( Int.random( 0..4294967295 ).and( 4294967295 ).toHex( 8 ) ).toStr }
  private Void _reload() {
    frag := Win.cur.uri.frag ?: ""
    inModify = false
    inLoad = true
    onLoadState( loadState( frag ).ro )
    inLoad = false
  }
}
