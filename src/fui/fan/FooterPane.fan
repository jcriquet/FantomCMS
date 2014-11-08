using fwt
using webfwt
using gfx
using proj
using dom

@Js
class FooterPane : BorderPane{
  Int maxItems := 7
  GridPane footerItemPane

  new make() : super(){
    this.bg = Color.white
    this.content = EdgePane{
      center = GridPane{
        it.halignCells = Halign.center
        it.valignCells = Valign.center
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        this.footerItemPane = it
        it.numCols = this.maxItems
      }
    }
  }
  
  Void addFooterItem(FooterPaneDockItem o){
    this.footerItemPane.add(o)
    this.relayout
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(0,75)
  }
}