using fwt

@Js
@Serializable
class TitleLabel : ThemedLabel {
  new make( |This|? f := null ) : super( f ) {
    text = Fui.cur.title
  }
}
