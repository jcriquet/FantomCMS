using afBson
using db
using proj
using web

@ExtMeta {
  name = "audio"
}
const class AudioExt : Ext, Weblet {
  const Str:Str dbmap := ["mp3":"binMp3"]
  const Str:Str typemap := ["mp3":"mpeg"]
  
  override Void onGet() {
    filename := req.modRel.pathOnly
    if ( !dbmap.containsKey( filename.ext ?: "" ) ) {
      res.sendErr( 404 )
      return
    }
    results := DBConnector.cur.db[ typeof.pod.toStr ].group( [dbmap[ filename.ext ]], [:], Code.makeCode( "function(){}" ), ["cond":["filename":filename.basename]] )
    if ( results.size < 1 ) {
      res.sendErr( 404 )
      return
    }
    bin := results[ 0 ][ dbmap[ filename.ext ] ] as Buf
    if ( bin == null ) {
      res.sendErr( 404 )
      return
    }
    res.headers[ "Content-Type" ] = "audio/" + typemap[ filename.ext ]
    res.headers[ "Content-Length" ] = bin.size.toStr
    res.out.writeBuf( bin ).close
    res.done
  }
}
