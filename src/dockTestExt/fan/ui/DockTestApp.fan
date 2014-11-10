using fui
using fwt
using gfx
using util
using webfwt

@Js
class DockTestApp : App {
  new make() : super() {
    this.content = GridPane{
      it.halignCells = Halign.center
      it.valignCells = Valign.center
      it.halignPane = Halign.center
      it.valignPane = Valign.center
      Button{
        it.text = "Click me to add an item"
        it.onAction.add { Fui.cur.main.addFooterItem(TestDockItem()) }
      },
    }
  }
}
