using dom
using db
using afBson
using webfwt
using fui
using fwt
using gfx
using util

@Js
class HtmlEditorApp : App {
  OverlayPane? editPane
  ItemList list := ItemList()
  
  new make() : super() {
    content = GridPane{
      it.halignCells = Halign.center
      it.valignCells = Valign.center
      it.halignPane = Halign.center
      it.valignPane = Valign.center
      it.numCols = 1
      list,
      GridPane{
        it.numCols = 4
        Button{
          it.text = "New"
          it.onAction.add { doNew() }
        },
        Button{
          it.text = "Edit"
          it.onAction.add { doEdit() }
        },
        Button{
          it.text = "Delete"
          it.onAction.add { doDelete() }
        },
        Button{
          it.text = "Refresh"
          it.onAction.add { doRefresh() }
        },
      },
    }
  }
  
  private Void doNew(){
    this.editPane = HtmlEditor()
    editPane.open(this, Point(this.pos.x + 100, this.pos.y + 100))
  }

  private Void doEdit(){
    this.editPane = HtmlEditor(list.getItem.title, list.getItem.uri, list.getItem.itemData)
    editPane.open(this, Point(this.pos.x + 100, this.pos.y + 100))
  }

  private Void doDelete(){
    Win.cur.alert("You wanted to delete [${list.getItem.text}]\nThe delete feature is not yet implemented.")
  }

  private Void doRefresh(){
    this.list.updateList
  }

}

@Js
class ItemList : WebList {
  ItemLabel[] itemList := [,]

  new make() : super(){
    this.onSelect.add { doSelected() }
    updateList
  }

  Void updateList(){
    HttpReq { uri = Fui.cur.baseUri + `/api/htmleditor/pagelist` }.get |res| { 
      if(res.status != 200){
        Win.cur.alert("Error loading data.")
      }
      this.itemList = [,]
      mapList := JsonInStream(res.content.in).readJson as [Str:Obj?][]
      mapList.each |map| {
        if(map.containsKey("title") && map.containsKey("data") && map.containsKey("uri")){
          this.itemList.add(ItemLabel(map["title"], map["uri"], map["data"]))
        }
      }
      this.items = this.itemList
      this.parent.relayout
    } 
  }
  
  ItemLabel getItem(){
    return this.itemList[this.selectedIndex]
  }
  
  Void doSelected(){
    selected := this.selectedIndex
    this.itemList.each |e| {
      e.clearHighlight
    }
    this.itemList[this.selectedIndex].setHighlight
    this.items = this.itemList
    this.selectedIndex = selected
    this.parent.relayout
  }
  
  override Size prefSize(Hints hints := Hints.defVal){
    return Size(500, 500)
  }
}

@Js
class ItemLabel : Label {
  Str itemData
  Str uri
  Str title
  Str display
  
  new make(Str title, Str uri, Str data) : super(){ 
    this.title = this.display = title
    this.uri = uri
    this.itemData = data
  }
  
  Void clearHighlight(){
    this.display = this.title
  }
  
  Void setHighlight(){
    this.display = "> " + this.title
  }
  
  override Str toStr(){
    return this.display
  }
}