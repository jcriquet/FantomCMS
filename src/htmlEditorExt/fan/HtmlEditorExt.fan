using db
using proj
using util
using web

@ExtMeta {
  name = "htmleditor"
  app = htmlEditorExt::HtmlEditorApp#
  label = "HTML Editor"
}

const class HtmlEditorExt : Ext, Weblet {
  override Void onGet() {
    uri := req.modRel
    switch(uri.pathOnly.toStr){
      case "pagelist":
      map := DBConnector.cur.db["pages"].findAll([:]) as [Str:Obj?][]
      data := JsonOutStream.writeJsonToStr(map)
      res.headers[ "Content-Type" ] = "text/plain"
      res.headers[ "Content-Length" ] = data.size.toStr
      res.statusCode = 200
      res.out.writeChars( data ).close
      res.done
      default:
      res.sendErr(404)
    }
  }

  override Void onPost() {
    uri := req.modRel
    switch(uri.pathOnly.toStr){
      case "newpage":
      Str content := req.in.readAllStr
      Buf b := Buf()
      b.writeChars(content)
      b.flip
      Map map := b.readObj
      if(map.containsKey("title") && map.containsKey("data") && map.containsKey("uri")){
        DBEntry a := DBEntry("pages")
        a.set("title", map["title"])
        a.set("data", map["data"])
        a.set("uri", map["uri"])
        DBConnector.cur.put(a)
        res.sendErr(200)
      } else {
        res.sendErr(500)
      }
    }
  }
}
