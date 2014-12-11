using fui
using fwt
using gfx
using webfwt

@Js
@Serializable { simple = true }
class AudioPlayer : AudioAbstractPlayer {
  const Uri uri
  
  new make( |This| f ) : super( f ) {}
  static new fromStr( Str str ) { AudioPlayer {
    i := str.index( "|" )
    name = i == null ? "default" : str[ 0..<i ]
    if ( i == null ) i = -1
    uri = str[ (i+1)..-1 ].toUri
  } }
  override Str toStr() { name + "|" + uri.toStr }
  
  override Bool isExpired() {
    if ( super.isExpired ) return true
    result := elem.uri != uri
    if ( result ) onPause
    return result
  }
  override Void playAction() {
    if ( elem.uri != uri ) {
      elem.uri = uri
      elem.register( this )
    }
    super.playAction
  }
  override Void pauseAction() {
    if ( elem.uri != uri ) playAction
    else super.pauseAction
  }
}
