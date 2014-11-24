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
    filename := req.headers[ "FileUpload-filename" ].replace( "#", "%23" ).toUri
    echo( filename )
    Str? database
    modified := Timestamp.makeTimestamp( DateTime.now.minusDateTime( Utilities.unixEpoch ), 0 )
    switch ( filename.ext ) {
      case "mp3":
        DBConnector.cur.db[ "audioExt" ].update( ["filename":filename.basename], ["filename":filename.basename, "modified":modified, "binMp3":req.in.readAllBuf], false, true )
      case "gif":
      case "png":
      case "jpg":
      case "jpeg":
        DBConnector.cur.db[ "imageExt" ].update( ["filename":filename.name], ["filename":filename.name, "modified":modified, "bin":req.in.readAllBuf], false, true )
      default:
        echo( "Upload Failed" )
        res.sendErr( 415 )
        return
    }
    myStr := "Uploaded $filename!"
    echo( myStr )
    res.headers["Content-Type"] = "text/plain"
    res.headers["Content-Length"] = myStr.size.toStr
    out := res.out
    out.writeChars( myStr )
    out.close
    res.done
  }
}
