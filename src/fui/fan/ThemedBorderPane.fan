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
    bg = bgStyle != null ? FuiThemes.getBg( bgStyle ) : null
  }
  
  // force peer
  private native Void dummy()
}
