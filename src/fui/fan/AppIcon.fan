using fwt
using gfx

@Js
class AppIcon : ContentPane {
  Str appName
  Image? icon

  new make(Str appName, Uri? iconUri := null) : super(){
    this.appName = appName
    if(iconUri != null) this.icon = Image(iconUri)
    
    content = GridPane {
      it.halignCells = Halign.center
      it.halignPane = Halign.center
      it.numCols = 1
      if(this.icon != null) {
        it.add(Label { it.image = this.icon })
      }
      it.add(Label { it.text = this.appName })
    }
  }
}
