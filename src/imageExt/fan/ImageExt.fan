using util
using fui
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
  static const Str:Str typemap := ["gif":"gif","png":"png","jpg":"jpeg","jpeg":"jpeg"]
  
  override Void onGet() {
    switch(req.modRel.path[0]){
      // Api Calls
    case "getAll":
      Buf b := Buf()
      b.writeObj(getAllFilenames)
      b.flip
      res.headers[ "Content-Type" ] = "application/fantom"
      res.headers[ "Content-Length" ] = b.size.toStr
      res.out.writeBuf( b ).close
      res.done
      
      // Regular image request
    default:
      filename := req.modRel.pathOnly
      isTb := req.uri.query["tb"] != null
      if ( !typemap.containsKey( filename.ext ?: "" ) ) {
        res.sendErr( 404 )
        return
      }
      file := fetch( filename , isTb)
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
  }
  
  File? fetch( Uri relUri , Bool isTb) {
    Str param := "binFull"
    if(isTb) param = "binTb"

    if ( relUri.isAbs ) throw Err( "relUri ($relUri) is not relative!" )
    File? cached
    if (isTb) cached = "cached/$typeof.pod/thumbs/$relUri.pathStr".toUri.toFile 
    else cached = "cached/$typeof.pod/$relUri.pathStr".toUri.toFile
    basename := relUri.pathStr
    dbDate := DBConnector.cur.db[ typeof.pod.toStr ].group( ["modified"], [:], Code.makeCode( "function(){}" ), ["cond":["filename":basename]] )
                         .getSafe( 0 )?.get( "modified" )?->seconds as Duration
    if ( dbDate == null ) return null
    cachedMod := cached.modified
    if ( cachedMod == null || cachedMod.minusDateTime( Utilities.unixEpoch ) < dbDate ) {
      echo( "Refreshing Cache: $relUri" )
      buf := DBConnector.cur.db[ typeof.pod.toStr ].group( [param], [:], Code.makeCode( "function(){}" ), ["cond":["filename":basename]] )
                        .getSafe( 0 )?.get( param ) as Buf
      if ( buf == null ) {
        cached.delete
        return null
      }
      cached.out.writeBuf( buf ).close
    }
    return cached.exists ? cached : null
  }
  
  static Str:Uri getAllFilenames(){
    filenameList := DBConnector.cur.db["imageExt"].group( ["filename"], [:], Code.makeCode( "function(){}" )) as [Str:Obj?][]
    [Str:Uri] toReturn := [:]
    if(filenameList != null){
      filenameList.each |entry| {   
        toReturn[entry["filename"]] = `api/image/` + Uri.fromStr(entry["filename"])
      }
    }
    return toReturn
  }
}
