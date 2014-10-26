using web

const class PodMod : WebMod {
  const Str podName
  
  new make( Str podName ) { this.podName = podName }
  
  override Void onGet() {
    file := Pod.find( podName ).file( `/` + req.modRel, false )
    if ( file == null ) { res.sendErr( 404 ); return }
    if ( file.isDir ) { res.sendErr( 403 ); return }
    FileWeblet( file ).onService
  }
}
