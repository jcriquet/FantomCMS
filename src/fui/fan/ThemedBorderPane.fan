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
  
  override Void onLayout() {
    checkStyles
    super.onLayout
    repaint
  }
  
  Void checkStyles() {
    bg = bgStyle != null ? FuiThemes.getBg( bgStyle ) : null
  }
}
