using fwt

@Serializable
class GotoButton : Button {
  Uri uri
  
  new make( Uri uri, |This|? f := null ) : super( f ) {
    this.uri = uri
    onAction.add { Fui.cur.main.goto( uri ) }
  }
}
