using fwt

@Js
@Serializable
class TitleLabel : ThemedLabel {
  new make( |This|? f := null ) : super() {
    f?.call( this )
    text = Fui.cur.title
  }
}
