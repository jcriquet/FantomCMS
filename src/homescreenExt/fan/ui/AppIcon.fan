using fwt
using dom
using inet
using gfx

@Js
class AppIcon : ContentPane
{
  Func onClick

  new make(Str appName, |->Void| e, Uri? iconUri := null) : super(){
    this.onClick = e

    content = GridPane{
      it.numCols = 1
      if(iconUri != null){
        Label {
          it.image = Image(iconUri)
          it.onMouseDown.add { iconClick() }
        },
      }
      
      Label {
        it.text = appName
        it.onMouseDown.add { iconClick() }
      },
    }
  }
  
  Void iconClick(){
    this.onClick.call
  }
}