using fui
using fwt
using gfx

@Js
@Serializable { simple = true }
class AudioPlayer : Pane {
  const Uri uri
  
  new make( Uri uri ) : super() {
    this.uri = uri
  }
  
  static new fromStr( Str uri ) { AudioPlayer( uri.toUri ) }
  override Str toStr() { uri.toStr }
  Uri resolve() { Main.resolve( uri ) }
  
  final override Void onLayout() {}
  final override Size prefSize( Hints hints := Hints.defVal ) { getPlayerSize }
  
  private native Size getPlayerSize()
}
