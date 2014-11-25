using fwt

@Js
@Serializable
class ThemedBorderPane : BorderPane {
  const Str? bgStyle
  
  new make( |This|? f := null ) {
    f?.call( this )
    if ( bgStyle != null ) bg = FuiThemes.getBg( bgStyle )
  }
}
