using fwt
using webfwt
using gfx
using proj
using dom

@Js
class FooterPane : StatePane{
  Int dockItems := 0
  GridPane footerItemPane := GridPane{
    it.halignCells = Halign.center
    it.valignCells = Valign.center
    it.halignPane = Halign.center
    it.valignPane = Valign.center
    this.footerItemPane = it
    it.numCols = this.dockItems
  }
  BorderPane themedMain := BorderPane{ EdgePane{ center = footerItemPane }, }

  new make() : super(){
    this.content = themedMain
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
  
  override Void onLoadState(State state){
    themedMain.bg = FuiThemes.getBg( "footer" )
  }
}