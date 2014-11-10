using gfx

@Js
class FuiThemes {
  static const Color defColorNone := Color( 0, true )
  
  static Brush getBg( Str style ) {
    var := Env.cur.vars[ "themes.styles.${style}.bg" ]
    if ( var == null || var == "" ) return defColorNone
    try return ( var.in.readObj as Brush ) ?: defColorNone
    catch ( Err e ) return defColorNone
  }
}
