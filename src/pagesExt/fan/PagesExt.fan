using afBson
using db
using proj
using util
using web

@ExtMeta {
  name = "pages"
  app = pagesExt::PagesApp#
}
const class PagesExt : Ext, Weblet {
  override Void onGet() {
    uri := req.modRel
    _id := uri.query[ "_id" ]
    path := uri.pathOnly.pathStr
    [Str:Obj?]? document
    Str? data
    if ( _id != null ) document = DBConnector.cur.db[ "pages" ].findOne( ["_id":ObjectId( _id )], false )
    else {
      if ( uri.pathOnly == `` ) path = "index"
      if ( path != "" ) document = DBConnector.cur.db[ "pages" ].findOne( ["uri":path], false )
    }
    if ( document == null || ( data = document[ "data" ] ) == null ) {
      res.sendErr( 404 )
      return
    }
    map := ["data":data]
    if ( ( data = document[ "title" ] ) != null ) map[ "title" ] = data
    data = JsonOutStream.writeJsonToStr( map )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = data.size.toStr
    res.out.writeChars( data ).close
    res.done
  }
}
