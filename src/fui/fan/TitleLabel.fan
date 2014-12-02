using fwt

@Js
@Serializable
class TitleLabel : Label {
  new make( |This|? f := null ) : super() {
    f?.call( this )
    text = Fui.cur.title
  }
}
