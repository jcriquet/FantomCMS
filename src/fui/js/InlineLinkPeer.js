/**
 * InlineLink.
 */
fan.fui.InlineLinkPeer = fan.sys.Obj.$extend( fan.fui.InlineNodePeer );
fan.fui.InlineLinkPeer.prototype.$ctor = function( self ) {
  fan.fui.InlineNodePeer.prototype.$ctor.call( this, self );
}

fan.fui.InlineLinkPeer.prototype.create = function( parentElem, self ) {
  var result = document.createElement( "a" );
  parentElem.appendChild( result );
  return result;
}
