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
    Fui.cur.main.headerPane.onSaveState( state )
    Fui.cur.main.footerPane.onSaveState( state )
    onSaveState( state )
    inModify = true
    key := _genKey
    Win.cur.sessionStorage[ key ] = state.toStr
    Win.cur.hyperlink( "#$key".toUri )
  }
  
  Void reload() {
    inModify = false
    inLoad = true
    state := loadState( Win.cur.uri.frag ?: "" ).ro
    Fui.cur.main.headerPane.onLoadState( state )
    Fui.cur.main.footerPane.onLoadState( state )
    onLoadState( state )
    inLoad = false
    Fui.cur.updateTitle
  }
  
  private Str _genKey() { StrBuf().add( ( DateTime.nowTicks/1000000000 ).and( 4294967295 ).toHex( 8 ) ).addChar( 45 ).add( Int.random( 0..4294967295 ).and( 4294967295 ).toHex( 8 ) ).toStr }
}
