using afBson
using db
using proj
using web

@ExtMeta {
  name = "uploader"
  app = uploaderExt::UploaderApp#
}
const class UploaderExt : Ext, Weblet {
  override Void onPost() {
    req.headers.each |v, k| { echo( "$k : $v" ) }
    filename := req.headers[ "FileUpload-filename" ].toUri
    Str? database
    switch ( filename.ext ) {
      case "mp3":
        DBConnector.cur.db[ "audioExt" ].update( ["filename":filename.name], ["filename":filename.basename, "binMp3":req.in.readAllBuf], false, true )
      default:
        echo( "Upload Failed" )
        res.sendErr( 415 )
        return
    }
    myStr := "Uploaded!"
    echo( myStr )
    res.headers["Content-Type"] = "text/plain"
    res.headers["Content-Length"] = myStr.size.toStr
    out := res.out
    out.writeChars( myStr )
    out.close
    res.done
  }
}
