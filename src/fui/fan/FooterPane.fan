using fwt
using webfwt
using gfx
using proj
using dom

@Js
class FooterPane : BorderPane{
  Int dockItems := 0
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
        it.numCols = this.dockItems
      }
    }
  }
  
  Void addFooterItem(FooterPaneDockItem item){
    this.footerItemPane.numCols++
    this.footerItemPane.add(item)
    this.relayout
  }
  
  Void removeFooterItem(FooterPaneDockItem item){
    this.footerItemPane.numCols--
    this.footerItemPane.remove(item)
    this.relayout
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(0,75)
  }
}