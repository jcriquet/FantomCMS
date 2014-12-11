using concurrent
using dom

@Js
class AudioObject {
  private Str:AudioElem audioMap := [:]
  
  private new make() {}
  
  @Operator
  AudioElem? get( Str name ) { audioMap[ name ] }
  AudioElem getOrAdd( Str name ) { audioMap.getOrAdd( name ) { AudioElem() } }
  
  static AudioObject cur() { 
    r := Actor.locals[ "audioExt.audioObject.cur" ] as AudioObject
    if ( r == null ) {
      r = AudioObject()
      Actor.locals[ "audioExt.audioObject.cur" ] = r
    }
    return r
  }
}

@Js
class AudioElem {
  Elem elem { private set }
  private AudioAbstractPlayer[] players := [,]
  native Uri? uri
  internal new make() {
    elem = Win.cur.doc.createElem( "audio" )
    elem.onEvent( "play",  true ) |e| { players.ro.each |player| { if ( player.isExpired ) players.remove( player ); else player.onPlay } }
    elem.onEvent( "pause", true ) |e| { players.ro.each |player| { if ( player.isExpired ) players.remove( player ); else player.onPause } }
  }
  Void register( AudioAbstractPlayer player ) { if ( !players.contains( player ) ) players.add( player ) }
  native Void play()
  native Void pause()
  native Bool paused()
}