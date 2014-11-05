using fui
using dom
using fwt
using gfx
using util
using webfwt

@Js
class MainApp : App {
  
  ContentPane mainPane

  new make() : super() {
    content = EdgePane{

      top = ConstrainedBorderPane(Win.cur.viewport.w, (Win.cur.viewport.h * 0.1F).toInt){
        it.bg = getOption("bgcolor")
        Button{ it.text = "test" ; it.onAction.add { setContent("login") } },
      }

      center = ContentPane{
        this.mainPane = it
      }

      bottom = ConstrainedBorderPane(Win.cur.viewport.w, (Win.cur.viewport.h * 0.1F).toInt){
        it.bg = getOption("bgcolor")
      }
    }
  }
  
  Void setContent(Str appName){
    App toOpen := (App)Type.find(Fui.cur.appMap.get(appName).qname).make
    Win.cur.hisPushState(appName, Fui.cur.appUri(appName), [:])
    this.mainPane.content = toOpen
    this.relayout
    this.loadState("")
    toOpen.onLoadState(State())
  }
  
  // getOption checks the database for config options
  // TODO: interface with db
  Obj getOption(Str opt) {
    switch(opt) {
      case "bgcolor":
      // sweet gradient
      return Gradient("0% 50%, 100% 50%, #f00 0.1, #00f 0.9")
    }
    throw Err("Option not found")
  }
}