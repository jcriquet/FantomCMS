/**
 * AudioPlayerPeer.
 */
fan.audioExt.AudioPlayerPeer = fan.sys.Obj.$extend( fan.fwt.PanePeer );
fan.audioExt.AudioPlayerPeer.prototype.$ctor = function( self ) {}

fan.audioExt.AudioPlayerPeer.prototype.create = function( parentElem ) {
  // test for native audio support
  a = document.createElement( "audio" )
  this.hasAudio = !!(a.canPlayType && a.canPlayType('audio/mpeg;').replace(/no/, ''));
  return fan.fwt.PanePeer.prototype.create.call( this, parentElem );
}

/*
fan.audioExt.AudioPlayerPeer.prototype.toPng = function(self)
{
  if (!this.hasAudio) return null;
  return this.elem.firstChild.toDataURL("image/png");
}
*/

//fan.audioExt.AudioPlayerPeer.prototype.clearOnRepaint = function() { return true; }

fan.audioExt.AudioPlayerPeer.prototype.sync = function( self ) {
  // short-circuit if not properly layed out
  //var size = this.m_size
  //if (size.m_w == 0 || size.m_h == 0) return;
  
  // TODO FIXIT: just assume audio support?
  if ( this.hasAudio ) {
    var div = this.elem;
    var a = div.firstChild;
    
    // remove old audio if size is different
    /*
    if (c != null && (c.width != size.m_w || c.height != size.m_h))
    {
      div.removeChild(c);
      c = null;
    }
    */
    
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
    /*
    // repaint canvas using Canvas.onPaint callback
    var g = new fan.fwt.FwtGraphics();
    g.widget = self;
    g.paint(c, self.bounds(), function() { self.onPaint(g) })
    */
  }

  fan.fwt.PanePeer.prototype.sync.call( this, self );
}

fan.audioExt.AudioPlayerPeer.prototype.getPlayerSize = function( self ) {
  var div = this.elem;
  //if ( div == null ) return new fan.gfx.Size();
  var a = div.firstChild;
  if ( a == null ) {
	fan.audioExt.AudioPlayerPeer.prototype.sync.call( this, self );
    a = div.firstChild;
  }
  return fan.gfx.Size.make( a.clientWidth, a.clientHeight );
}