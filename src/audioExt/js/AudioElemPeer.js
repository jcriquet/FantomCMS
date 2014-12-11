/**
 * AudioElemPeer.
 */
fan.audioExt.AudioElemPeer = fan.sys.Obj.$extend( fan.sys.Obj );
fan.audioExt.AudioElemPeer.prototype.$ctor = function( self ) {}

fan.audioExt.AudioElemPeer.prototype.m_uri = null
fan.audioExt.AudioElemPeer.prototype.uri   = function( self ) { return this.m_uri; }
fan.audioExt.AudioElemPeer.prototype.uri$  = function( self, val ) {
  this.m_uri = val;
  if ( val == null ) self.elem.peer.elem.src = null
  else {
    val = fan.fui.Main.resolve( val )
    self.elem().peer.elem.src = val.toStr()
  }
}

fan.audioExt.AudioElemPeer.prototype.play = function( self ) { self.elem().peer.elem.play(); }
fan.audioExt.AudioElemPeer.prototype.pause = function( self ) { self.elem().peer.elem.pause(); }
fan.audioExt.AudioElemPeer.prototype.paused = function( self ) { return self.elem().peer.elem.paused; }
