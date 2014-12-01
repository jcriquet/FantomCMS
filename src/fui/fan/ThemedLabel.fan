using fwt
using gfx

@Js
@Serializable
class ThemedLabel : Label {
  const Str? bgStyle
  const Str? fgStyle
  const Str? fontStyle
  
  new make( |This|? f := null ) {
    f?.call( this )
    checkStyles
  }
  
  Void checkStyles() {
    bg = bgStyle != null ? ( FuiThemes.getBg( bgStyle ) as Color ?: null ) : null
    fg = fgStyle != null ? FuiThemes.getFg( fgStyle ) : null
    font = fontStyle != null ? FuiThemes.getFont( fontStyle ) : null
  }
  
  // force peer
  private native Void dummy()
}
