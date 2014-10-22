using fwt

@Js
class StatePane : ContentPane {
  virtual Void onLoadState( State state ) {}
  virtual Void onSaveState( State state ) {}
}
