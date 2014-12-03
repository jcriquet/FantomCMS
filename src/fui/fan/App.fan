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
  virtual Str? curTitle() { null }
  
  /*
  Void onReady() {
    json := Env.cur.vars[ "fui.appState" ] // Don't think we need this
    if ( Win.cur.uri.frag == null && json != null ) {
      key := _genKey
      Win.cur.sessionStorage[ key ] = json
      Win.cur.hyperlink( "#$key".toUri )
    }
    else reload
  }
  */
  
  HttpReq apiCall( Uri relPath ) { apiCallApp( relPath, name ) }
  static HttpReq apiCallApp( Uri relPath, Str app ) {
    fui := Fui.cur
    req := HttpReq { uri = fui.baseUri + "api/$app/".toUri + relPath }
    return req
  }
  
  State loadState( Str key ) {
    json := Win.cur.sessionStorage[ key ]
    return json == null ? State( key ) : State.fromStr( key, json )
  }
  
  Void updateState() {
    if ( inLoad ) throw Err( "Cannot call updateState during onLoadState" )
    if ( Win.cur.uri.relToAuth.relTo( Fui.cur.appUri( name ) ).path.getSafe( 0 ) == ".." ) return
    key := Win.cur.uri.relToAuth.relTo( Fui.cur.baseUri ).pathOnly.toStr + "#" + Win.cur.uri.frag
    state := loadState( key ).rw
    onSaveState( state )
    Fui.cur.main.onSaveState( state )
    Win.cur.sessionStorage[ key ] = state.toStr
  }
  
  Void modifyState() {
    if ( inLoad ) throw Err( "Cannot call modifyState during onLoadState" )
    if ( Win.cur.uri.relToAuth.relTo( Fui.cur.appUri( name ) ).path.getSafe( 0 ) == ".." ) return
    Str? frag
    Str? key
    while ( true ) {
      frag = _genKey
      key = Win.cur.uri.relToAuth.relTo( Fui.cur.baseUri ).pathOnly.toStr + "#" + frag
      echo( key )
      if ( Win.cur.sessionStorage[ key ] == null ) break
    }
    state := State( key )
    onSaveState( state )
    Fui.cur.main.onSaveState( state )
    inModify = true
    Win.cur.sessionStorage[ key ] = state.toStr
    Win.cur.hyperlink( "#$frag".toUri )
  }
  
  Void reload() {
    if ( Win.cur.uri.relToAuth.relTo( Fui.cur.appUri( name ) ).path.getSafe( 0 ) == ".." ) return
    inModify = false
    inLoad = true
    state := loadState( Win.cur.uri.relToAuth.relTo( Fui.cur.baseUri ).pathOnly.toStr + "#" + Win.cur.uri.frag ).ro
    echo( state )
    onLoadState( state )
    Fui.cur.main.onLoadState( state )
    inLoad = false
    Fui.cur.updateTitle
  }
  
  private Str _genKey() { StrBuf().add( ( DateTime.nowTicks/1000000000 ).and( 4294967295 ).toHex( 8 ) ).addChar( 45 ).add( Int.random( 0..4294967295 ).and( 4294967295 ).toHex( 8 ) ).toStr }
}
