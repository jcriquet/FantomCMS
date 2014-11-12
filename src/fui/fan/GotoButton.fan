using fwt

@Js
@Serializable
class GotoButton : Button {
  Uri uri
  Str _text { get { text } set { text = &_text } }
  
  new make( Uri uri, |This|? f := null ) : super() {
    f?.call( this )
    this.uri = uri
    onAction.add { Fui.cur.main.goto( this.uri ) }
  }
}
