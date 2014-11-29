/**
 * ThemedBorderPane.
 */
fan.fui.ThemedBorderPanePeer = fan.sys.Obj.$extend(fan.fwt.BorderPanePeer);
fan.fui.ThemedBorderPanePeer.prototype.$ctor = function(self) {
  fan.fwt.BorderPanePeer.prototype.$ctor.call(this, self);
}

fan.fui.ThemedBorderPanePeer.prototype.relayout = function(self) {
  self.checkStyles();
  fan.fwt.BorderPanePeer.prototype.relayout.call(this, self);
}