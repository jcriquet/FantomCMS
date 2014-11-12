using fwt
using webfwt
using gfx
using proj
using dom

@Js
class FooterPane : StatePane{

  GridPane footerItemPane := GridPane{
    it.halignCells = Halign.center
    it.valignCells = Valign.center
    it.halignPane = Halign.center
    it.valignPane = Valign.center
    it.numCols = 0
  }
  
  EdgePane? edgePane

  BorderPane themedMain := BorderPane{ EdgePane{ center = footerItemPane ; this.edgePane = it}, }

  new make() : super(){
    this.content = themedMain
  }
  
  Void addFooterItem(FooterPaneDockItem item){
    this.footerItemPane.numCols++
    this.footerItemPane.add(item)
    this.relayout
    Fui.cur.main.curApp.modifyState
  }
  
  Void removeFooterItem(FooterPaneDockItem item){
    this.footerItemPane.numCols--
    this.footerItemPane.remove(item)
    this.relayout
    Fui.cur.main.curApp.modifyState
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(0,75)
  }

  override Void onSaveState(State state){
    Buf a := Buf()
    a.writeObj(this.footerItemPane)
    a.flip
    state.set("footerPane.itemPane", a.readAllStr)
  }
  
  override Void onLoadState(State state){
    if(state.has("footerPane.itemPane")){
      Str a := state["footerPane.itemPane"]
      GridPane footerPane := a.toBuf.readObj
      this.footerItemPane = footerPane
      this.edgePane.center = footerPane
      this.relayout
    }
    themedMain.bg = FuiThemes.getBg( "footer" )
  }
}