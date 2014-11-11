using fui

@Js
class UserPane : StatePane {
  protected UserApp app
  new make( UserApp app ) {
    this.app = app
  }
}
