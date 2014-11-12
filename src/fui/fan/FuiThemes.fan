using concurrent
using gfx

@Js
class FuiThemes {
  static const Color defColorNone := Color( 0, true )
  
  static Brush getBg( Str style ) {
    var := Actor.locals[ "themes.styles.${style}.bg" ] as Str
    if ( var == null || var == "" ) return defColorNone
    try return ( var.in.readObj as Brush ) ?: defColorNone
    catch ( Err e ) return defColorNone
  }
}
