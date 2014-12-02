using proj
using util
using web
using db
using afBson

@ExtMeta {
  name = "user"
  app = userExt::UserApp#
  icon = "users-50.png"
}
const class UserExt : Ext, Weblet {
  override Void onGet() {
    Obj? data
    switch ( req.modRel ) {
      case `list`:
        data = DBConnector.cur.db[typeof.pod.toStr].group(["_id", "name"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]]) as [Str:Obj?][]
        if ( data == null ) data = [,]
      case `groups`:
        data = DBConnector.cur.db[typeof.pod.toStr].group(["_id", "name"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"group"]]) as [Str:Obj?][]
        if ( data == null ) data = [,]
    }
    out := JsonOutStream.writeJsonToStr(data)
    res.headers[ "Content-Type" ] = "application/json"
    res.headers[ "Content-Length" ] = out.size.toStr
    res.out.writeChars( out ).close
    res.done
  }
  
  override Void onPost() {
    uri := req.modRel
    switch(uri.pathOnly.toStr){
      
      // New Page
      case "adduser":
        map := req.form
        if(map.containsKey("name") && map.containsKey("password") && map.containsKey("group") && map.containsKey("type")){
          if(DBConnector.cur.db[typeof.pod.toStr].findAll(["name":map["name"]]).isEmpty){
            DBConnector.cur.db[typeof.pod.toStr].insert(map)
            res.statusCode = 201
          }else{
            res.statusCode = 304
          }
          res.headers[ "Content-Type" ] = "text/plain"
          res.headers[ "Content-Length" ] = "2"
          out := res.out
          out.writeChar( '4' )
          out.writeChar( '2' )
          out.close
          res.done
        } else {
          res.sendErr(500)
        }
      
      // edit
      case "edituser":
        map := req.form
        if(map.containsKey("name") && map.containsKey("password") && map.containsKey("group") && map.containsKey("type")){
          try{
            DBConnector.cur.db[typeof.pod.toStr].delete(["name":map["name"]])
          }catch{
            // user didnt exist. oh well. we'll just add it
          }
          DBConnector.cur.db[typeof.pod.toStr].insert(map)
          res.statusCode = 201
        }else{
          res.statusCode = 500
        }
        res.headers[ "Content-Type" ] = "text/plain"
        res.headers[ "Content-Length" ] = "2"
        out := res.out
        out.writeChar( '4' )
        out.writeChar( '2' )
        out.close
        res.done

      // delete
      case "deleteuser":
        Int i := DBConnector.cur.db[typeof.pod.toStr].delete(["name":req.in.readAllStr])
        if(i > 0){
          res.statusCode = 200
        }else{
          res.statusCode = 500
        }
        res.headers[ "Content-Type" ] = "text/plain"
        res.headers[ "Content-Length" ] = "2"
        out := res.out
        out.writeChar( '4' )
        out.writeChar( '2' )
        out.close
        res.done
      
      
      
      // default error
      default:
        res.statusCode = 500
        res.headers[ "Content-Type" ] = "text/plain"
        res.headers[ "Content-Length" ] = "2"
        out := res.out
        out.writeChar( '4' )
        out.writeChar( '2' )
        out.close
        res.done
    }
  }

  static [Str:Obj?][]? getGroups(){
    return DBConnector.cur.db["userExt"].group(["_id", "name"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"group"]]) as [Str:Obj?][]
  }
  
  static [Str:Obj?][]? getUsers(){
    return DBConnector.cur.db["userExt"].group(["_id", "name", "password"], [:], Code.makeCode( "function(){}" ), ["cond":["type":"user"]]) as [Str:Obj?][]
  }
}
