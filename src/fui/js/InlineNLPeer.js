/**
 * InlineNL.
 */
fan.fui.InlineNLPeer = fan.sys.Obj.$extend( fan.fui.InlineNodePeer );
fan.fui.InlineNLPeer.prototype.$ctor = function( self ) {
  fan.fui.InlineNodePeer.prototype.$ctor.call( this, self );
}

fan.fui.InlineNLPeer.prototype.create = function( parentElem, self ) {
  var result = document.createElement( "br" );
  parentElem.appendChild( result );
  return result;
}
