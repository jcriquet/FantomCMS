/**
 * OverlayContainer.
 */
fan.fui.OverlayContainerPeer = fan.sys.Obj.$extend(fan.webfwt.OverlayPanePeer);
fan.fui.OverlayContainerPeer.prototype.$ctor = function(self) {
  fan.webfwt.OverlayPanePeer.prototype.$ctor.call(this, self);
}

fan.fui.OverlayContainerPeer.prototype.open = function(self, parent, point) {
  fan.webfwt.OverlayPanePeer.prototype.open.call(this, self, parent, point);
  with ( this.$overlay.style ) {
    borderRadius    = null;
    MozBoxShadow    = null;
    webkitBoxShadow = null;
    boxShadow       = null;
    zIndex   = 1001;
  }
}