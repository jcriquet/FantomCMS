using fui

@Js
abstract class SettingsPane : StatePane {
  private SettingsApp app
  new make( SettingsApp app ) {
    this.app = app
  }
  
  [Str:Str]? contentData() { app.contentData }
  abstract Void getData()
}
