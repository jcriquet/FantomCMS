using fui
using dom
using proj
using fwt
using gfx
using util
using webfwt

@Js
class HomeApp : App {

  new make() : super() {
    content = BorderPane{
      it.content = HomeAppPane( Fui.cur.appMap.size - 2 ){
        it.halignCells = Halign.center
        it.valignCells = Valign.center
        it.halignPane = Halign.center
        it.valignPane = Valign.center
        it.hgap = 10
        it.vgap = 10
        gridPane := it
        Fui.cur.appMap.vals.sort.each |app| {
          if ( app.name == "home" || app.name == "login" ) return
          gridPane.add( HomeAppIcon( app.label, Fui.cur.baseUri + `pod/fui/res/img/` + app.icon.toUri ) {
            it.onMouseDown.add { Fui.cur.main.goto( "fui://app/$app.name".toUri ) }
          } )
        }
      }
    }
  }
}

@Js
class HomeAppPane : GridPane{
  Int numberOfApps
  new make(Int numberOfApps) : super(){
    this.numberOfApps = numberOfApps
  }
    
  override Void onLayout(){
    if(parent.size.w < 800){
      this.numCols = 4
    }
    else{
      this.numCols = this.numberOfApps
    }
    super.onLayout
  }
}