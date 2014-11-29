/**
 * InlineNode.
 */
fan.fui.InlineNodePeer = fan.sys.Obj.$extend( fan.fwt.PanePeer );
fan.fui.InlineNodePeer.prototype.$ctor = function( self ) {
  fan.fwt.PanePeer.prototype.$ctor.call( this, self );
}

fan.fui.InlineNodePeer.prototype.m_styles = null;
fan.fui.InlineNodePeer.prototype.styles = function( self ) { return this.m_styles; }
fan.fui.InlineNodePeer.prototype.styles$ = function( self, val ) {
  if ( this.m_styles == val ) return;
  this.m_styles = val;
  if ( this.elem != null ) this.sync( self );
}

fan.fui.InlineNodePeer.prototype.sizeOf = function( self, w, h ) {
  if ( this.elem == null ) return fan.gfx.Size.m_defVal;
  if ( w == null ) return fan.gfx.Size.m_defVal;
  return fan.gfx.Size.make( this.elem.offsetWidth, this.elem.offsetHeight );
}

fan.fui.InlineNodePeer.prototype.create = function( parentElem, self ) {
  var result = document.createElement( "span" );
  parentElem.appendChild( result );
  return result;
}

fan.fui.InlineNodePeer.prototype.syncEvents = function ( self ) {
  this.checkEventListener(self, 0x001, "mouseover",  fan.fwt.EventId.m_mouseEnter, self.onMouseEnter());
  this.checkEventListener(self, 0x002, "mouseout",   fan.fwt.EventId.m_mouseExit,  self.onMouseExit());
  this.checkEventListener(self, 0x004, "mousedown",  fan.fwt.EventId.m_mouseDown,  self.onMouseDown());
  this.checkEventListener(self, 0x008, "mousemove",  fan.fwt.EventId.m_mouseMove,  self.onMouseMove());
  this.checkEventListener(self, 0x010, "mouseup",    fan.fwt.EventId.m_mouseUp,    self.onMouseUp());
//this.checkEventListener(self, 0x020, "mousehover", fan.fwt.EventId.m_mouseHover, self.onMouseHover());
  this.checkEventListener(self, 0x040, "mousewheel", fan.fwt.EventId.m_mouseWheel, self.onMouseWheel());
  this.checkEventListener(self, 0x080, "keydown",    fan.fwt.EventId.m_keyDown,    self.onKeyDown());
  this.checkEventListener(self, 0x100, "keyup",      fan.fwt.EventId.m_keyUp,      self.onKeyUp());
  this.checkEventListener(self, 0x200, "blur",       fan.fwt.EventId.m_blur,       self.onBlur());
  this.checkEventListener(self, 0x400, "focus",      fan.fwt.EventId.m_focus,      self.onFocus());
}

fan.fui.InlineNodePeer.prototype.sync = function( self, w, h ) {
  this.syncEvents( self )
  
  // styles
  this.elem.removeAttribute( "style" );
  fan.fwt.WidgetPeer.applyStyle( this.elem, this.m_styles );
}
