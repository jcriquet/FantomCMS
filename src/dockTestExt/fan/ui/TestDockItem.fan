using fui
using fwt
using gfx

@Js
class TestDockItem : FooterPaneDockItem
{
  new make() : super(){
    this.content = BorderPane{
      it.bg = Color.white
      it.border = Border.fromStr( "0,0,3 outset #444444" )
      GridPane{
        it.halignCells = Halign.center
        it.valignCells = Valign.center
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        Label{ text = "This is a test pane!" },
        Button{ text = "go away" ; it.onAction.add { this.close } }
      },
    }
  }
}
