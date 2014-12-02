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
  
  static Color getFg( Str style ) {
    var := Actor.locals[ "themes.styles.${style}.fg" ] as Str
    if ( var == null || var == "" ) return Color.black
    try return ( var.in.readObj as Color ) ?: Color.black
    catch ( Err e ) return Color.black
  }
  
  static Font? getFont( Str style ) {
    var := Actor.locals[ "themes.styles.${style}.font" ] as Str
    if ( var == null || var == "" ) return null
    try return var.in.readObj as Font
    catch ( Err e ) return null
  }
}
