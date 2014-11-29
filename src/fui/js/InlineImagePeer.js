/**
 * InlineImage.
 */
fan.fui.InlineImagePeer = fan.sys.Obj.$extend( fan.fui.InlineNodePeer );
fan.fui.InlineImagePeer.prototype.$ctor = function( self ) {
  fan.fui.InlineNodePeer.prototype.$ctor.call( this, self );
}

fan.fui.InlineImagePeer.prototype.create = function( parentElem, self ) {
  var result = document.createElement( "img" );
  parentElem.appendChild( result );
  return result;
}

fan.fui.InlineImagePeer.prototype.sync = function( self, w, h ) {
  fan.fui.InlineNodePeer.prototype.sync.call( this, self, w, h );
  if ( this.elem != null ) this.elem.setAttribute( "src", self.m_uri.toStr() );
}