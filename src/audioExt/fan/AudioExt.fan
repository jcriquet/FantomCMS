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
    file := fetch( filename )
    if ( file == null ) {
      res.sendErr( 404 )
      return
    }
    buf := file.readAllBuf
    try {
      res.headers[ "Content-Type" ] = "audio/" + typemap[ filename.ext ]
      res.headers[ "Content-Length" ] = buf.size.toStr
      res.out.writeBuf( buf ).close
      res.done
    } catch ( Err e ) {}
  }
  
  File? fetch( Uri relUri ) {
    if ( relUri.isAbs ) throw Err( "relUri ($relUri) is not relative!" )
    cached := "cached/$typeof.pod/$relUri.pathStr".toUri.toFile
    basename := relUri[ 0..-2 ].toStr + relUri.basename
    dbDate := DBConnector.cur.db[ typeof.pod.toStr ].group( ["modified"], [:], Code.makeCode( "function(){}" ), ["cond":["filename":basename]] )
                         .getSafe( 0 )?.get( "modified" )?->seconds as Duration
    if ( dbDate == null ) return null
    cachedMod := cached.modified
    if ( cachedMod == null || cachedMod.minusDateTime( Utilities.unixEpoch ) < dbDate ) {
      echo( "Refreshing Cache: $relUri" )
      dbtag := dbmap[ relUri.ext ]
      buf := DBConnector.cur.db[ typeof.pod.toStr ].group( [dbtag], [:], Code.makeCode( "function(){}" ), ["cond":["filename":basename]] )
                        .getSafe( 0 )?.get( dbtag ) as Buf
      if ( buf == null ) {
        cached.delete
        return null
      }
      cached.out.writeBuf( buf ).close
    }
    return cached.exists ? cached : null
  }
}
