using util
using [java]com.colegrim.fcms
using gfx
using fwt
using afBson
using db
using proj
using web

@ExtMeta {
  name = "image"
}
const class ImageExt : Ext, Weblet {
  const Str:Str typemap := ["gif":"mpeg","png":"png","jpg":"jpeg","jpeg":"jpeg"]
  
  override Void onGet() {
    filename := req.modRel.pathOnly
    if ( !typemap.containsKey( filename.ext ?: "" ) ) {
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
      res.headers[ "Content-Type" ] = "image/" + typemap[ filename.ext ]
      res.headers[ "Content-Length" ] = buf.size.toStr
      res.out.writeBuf( buf ).close
      res.done
    } catch ( Err e ) {}
  }
  
  /*
    switch (req.modRel.path[0]){
      case "tb":
        FCMSThumbnailMaker.resize(f.uri.toStr, temp.uri.toStr, f.ext, 100, 100)
        FileWeblet(temp).onService
      case "full":
        FileWeblet(f).onService
    }
  */
  
  File? fetch( Uri relUri ) {
    if ( relUri.isAbs ) throw Err( "relUri ($relUri) is not relative!" )
    cached := "cached/$typeof.pod/$relUri.pathStr".toUri.toFile
    basename := relUri.pathStr
    dbDate := DBConnector.cur.db[ typeof.pod.toStr ].group( ["modified"], [:], Code.makeCode( "function(){}" ), ["cond":["filename":basename]] )
                         .getSafe( 0 )?.get( "modified" )?->seconds as Duration
    if ( dbDate == null ) return null
    cachedMod := cached.modified
    if ( cachedMod == null || cachedMod.minusDateTime( Utilities.unixEpoch ) < dbDate ) {
      echo( "Refreshing Cache: $relUri" )
      buf := DBConnector.cur.db[ typeof.pod.toStr ].group( ["bin"], [:], Code.makeCode( "function(){}" ), ["cond":["filename":basename]] )
                        .getSafe( 0 )?.get( "bin" ) as Buf
      if ( buf == null ) {
        cached.delete
        return null
      }
      cached.out.writeBuf( buf ).close
    }
    return cached.exists ? cached : null
  }
  
  static Void makeThumb(File i, File o){
    
  }
}
