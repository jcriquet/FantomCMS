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
      
      // New Page
      case "newpage":
        map := req.form
        if(map.containsKey("title") && map.containsKey("data") && map.containsKey("uri")){
          if(DBConnector.cur.db["pages"].findAll(["uri":map["uri"]]).isEmpty){
            map.each |v, k| {
              k.replace("\\", "\\\\")
              k.replace("\"", "\\\"")
              k.replace("\n", "\\n")
            }
            echo(map)
            DBConnector.cur.db["pages"].insert(map)
            res.statusCode = 201
          }else{
            res.statusCode = 304
          }
          res.headers[ "Content-Type" ] = "text/plain"
          res.headers[ "Content-Length" ] = "1"
          out := res.out
          out.writeChar( 'a' )
          out.close
          res.done
        } else {
          res.sendErr(500)
        }
      
      // Overwrite
      case "overwrite":
        map := req.form
        map.each |v, k| {
          k.replace("\\", "\\\\")
          k.replace("\"", "\\\"")
          k.replace("\n", "\\n")
        }
        if(map.containsKey("title") && map.containsKey("data") && map.containsKey("uri")){
          DBConnector.cur.db["pages"].delete(["uri":map["uri"]])
          DBConnector.cur.db["pages"].insert(map)
          res.statusCode = 201
        }else{
          res.statusCode = 500
        }
        res.headers[ "Content-Type" ] = "text/plain"
        res.headers[ "Content-Length" ] = "1"
        out := res.out
        out.writeChar( 'a' )
        out.close
        res.done

      // delete
      case "delete":
        Int i := DBConnector.cur.db["pages"].delete(["uri":req.in.readAllStr])
        if(i > 0){
          res.statusCode = 200
        }else{
          res.statusCode = 500
        }
        res.headers[ "Content-Type" ] = "text/plain"
        res.headers[ "Content-Length" ] = "1"
        out := res.out
        out.writeChar( 'a' )
        out.close
        res.done
      default:
        res.statusCode = 500
        res.headers[ "Content-Type" ] = "text/plain"
        res.headers[ "Content-Length" ] = "1"
        out := res.out
        out.writeChar( 'a' )
        out.close
        res.done
    }
  }
}
