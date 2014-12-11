/**
 * AudioNowPlayingPeer.
 */
/*
fan.audioExt.AudioNowPlayingPeer = fan.sys.Obj.$extend( fan.fwt.PanePeer );
fan.audioExt.AudioNowPlayingPeer.prototype.$ctor = function( self ) {}

//fan.audioExt.AudioNowPlayingPeer.prototype.clearOnRepaint = function() { return true; }

fan.audioExt.AudioNowPlayingPeer.prototype.sync = function( self ) {
  return
  // short-circuit if not properly layed out
  //var size = this.m_size
  //if (size.m_w == 0 || size.m_h == 0) return;
  
  // TODO FIXIT: just assume audio support?
  if ( this.hasAudio ) {
    var div = this.elem;
    var a = div.firstChild;
    
    // remove old audio if size is different
    if (a != null && (a.width != size.m_w || a.height != size.m_h)) {
      div.removeChild(a);
      a = null;
    }
    
    // create new audio if null
    if ( a == null ) {
      a = document.createElement( "audio" );
      a.setAttributeNode( document.createAttribute( "controls" ) );
      source = document.createElement( "source" );
      attr = document.createAttribute( "src" );
      attr.value = self.resolve().toStr() + ".mp3";
      source.setAttributeNode( attr );
      attr = document.createAttribute( "type" );
      attr.value = "audio/mpeg";
      source.setAttributeNode( attr );
      a.appendChild( source );
      //a.width  = size.m_w;
      //a.height = size.m_h;
      div.appendChild( a );
    }
    *//*
    // repaint canvas using Canvas.onPaint callback
    var g = new fan.fwt.FwtGraphics();
    g.widget = self;
    g.paint(c, self.bounds(), function() { self.onPaint(g) })
    *//*
  }

  fan.fwt.PanePeer.prototype.sync.call( this, self );
}

fan.audioExt.AudioNowPlayingPeer.prototype.getPlayerSize = function( self ) {
  var div = this.elem;
  if ( div == null ) return new fan.gfx.Size();
  var a = div.firstChild;
  if ( a == null ) {
	fan.audioExt.AudioNowPlayingPeer.prototype.sync.call( this, self );
    a = div.firstChild;
  }
  return fan.gfx.Size.make( a.clientWidth, a.clientHeight );
}
*/