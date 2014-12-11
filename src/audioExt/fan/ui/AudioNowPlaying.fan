using fui
using fwt
using gfx
using webfwt

@Js
@Serializable { simple = true }
class AudioNowPlaying : AudioAbstractPlayer {
  new make( |This| f ) : super( f ) {
    enabled = elem.uri != null
  }
  static new fromStr( Str name ) { AudioNowPlaying { it.name = name } }
  override Str toStr() { name }
  
  override Void playAction() { if ( enabled = elem.uri != null ) super.playAction }
  override Void pauseAction() { if ( enabled = elem.uri != null ) super.pauseAction }
  override Void onPlay() { if ( enabled = elem.uri != null ) super.onPlay }
  override Void onPause() { if ( enabled = elem.uri != null ) super.onPause }
}
