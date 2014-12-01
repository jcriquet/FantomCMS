/**
 * ThemedLabel.
 */
fan.fui.ThemedLabelPeer = fan.sys.Obj.$extend(fan.fwt.LabelPeer);
fan.fui.ThemedLabelPeer.prototype.$ctor = function(self) {
  fan.fwt.LabelPeer.prototype.$ctor.call(this, self);
}

fan.fui.ThemedLabelPeer.prototype.relayout = function(self) {
  self.checkStyles();
  fan.fwt.LabelPeer.prototype.relayout.call(this, self);
}