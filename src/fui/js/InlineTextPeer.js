/**
 * InlineText.
 */
fan.fui.InlineTextPeer = fan.sys.Obj.$extend( fan.fui.InlineNodePeer );
fan.fui.InlineTextPeer.prototype.$ctor = function( self ) {
  fan.fui.InlineNodePeer.prototype.$ctor.call( this, self );
}

fan.fui.InlineTextPeer.prototype.cursor$ = function( self, val ) {
  if ( self.m_text == null ) fan.fwt.WidgetPeer.prototype.cursor$.call( this, self, val );
}

fan.fui.InlineTextPeer.prototype.create = function( parentElem, self ) {
  var result = document.createTextNode( self.m_text );
  parentElem.appendChild( result );
  return result;
}

fan.fui.InlineTextPeer.prototype.sync = function( self, w, h ) {
  this.syncEvents( self )
}