using fwt
using gfx

@Js
class FooterPaneDockItem : ContentPane
{
  new make() : super(){
    
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(100, this.parent.size.h)
  }
  
  Void close(){
    pane := (FooterPane)this.parent.parent.parent
    pane.removeFooterItem(this)
  }
}
