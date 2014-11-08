using fwt
using gfx

@Js
class FooterPaneDockItem : ContentPane
{
  new make() : super(){
    
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(200, this.parent.size.h)
  }
  
  Void close(){
    Fui.cur.main.removeFooterItem(this)
  }
}
