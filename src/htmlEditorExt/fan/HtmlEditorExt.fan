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
    res.headers[ "Content-Type" ] = "text/plain"
    switch(uri.pathOnly.toStr){
      case "newpage":
        map := req.form
        if(map.containsKey("title") && map.containsKey("data") && map.containsKey("uri")){
          map.each |v, k| {
            k.replace("\\", "\\\\")
            k.replace("\"", "\\\"")
            k.replace("\n", "\\n")
          }
          echo(map)
          DBConnector.cur.db["pages"].insert(map)
          res.statusCode = 200
          res.done
          return
        } else {
          res.sendErr(500)
            res.done
            return
        }
      default:
    }
  }
}
