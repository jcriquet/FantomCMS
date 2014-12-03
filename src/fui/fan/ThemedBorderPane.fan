using fwt
using gfx

@Js
@Serializable
class ThemedBorderPane : BorderPane {
  const Str? bgStyle
  
  new make( |This|? f := null ) {
    f?.call( this )
    checkStyles
  }
  
  Void checkStyles() {
    if ( bgStyle != null ) bg = FuiThemes.getBg( bgStyle )
  }
  
  // force peer
  private native Void dummy()
}
