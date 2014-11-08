using util
using web

const class AppMod : WebMod {
  const Str:AppSpec appMap
  
  new make( Str:Type exts ) {
    appMap = exts.map |ext, name| {
      meta := ( ext.facets.find |f| { f is ExtMeta } as ExtMeta )
      app := meta?.app
      return app == null ? null : AppSpec( name, app.qname, meta.label ?: name.capitalize )
    }.exclude |app| { app == null }
  }
  
  override Void onGet() {
    appStr := req.modRel.path.getSafe( 0 ) ?: "home"
//    queryRow := Database.query( "SELECT TRUE FROM webserv.project_ext WHERE project_id = '$projStr' AND ext_name = '$appStr'" ).getSafe( 0 )
    
    notFound := !appMap.containsKey( appStr )// || queryRow == null
    if ( notFound ) { res.sendErr( 404 ); return }
    
    title := Env.cur.config( typeof.pod, "server.title" )
    if ( title == null ) {
      title = "FantomCMS"
      file := Env.cur.homeDir + `etc/proj/config.props`
      props := file.exists ? file.readProps : Str:Str[:]
      file.create.writeProps( props[ "server.title" ] = title )
    }
    
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    out.docType5
    out.html
    out.head
      out.title.w( title ).titleEnd
      out.includeJs( `/pod/sys/sys.js` )
      out.includeJs( `/pod/util/util.js` )
      out.includeJs( `/pod/concurrent/concurrent.js` )
      out.includeJs( `/pod/web/web.js` )
      out.includeJs( `/pod/gfx/gfx.js` )
      out.includeJs( `/pod/dom/dom.js` )
      out.includeJs( `/pod/fwt/fwt.js` )
      out.includeJs( `/pod/webfwt/webfwt.js` )
      out.includeJs( `/pod/proj/proj.js` )
      out.includeJs( `/pod/fui/fui.js` )
      appMap.vals.each |spec| { podStr := spec.qname[ 0..<spec.qname.index( "::" ) ]; out.includeJs( "/pod/$podStr/${podStr}.js".toUri ) }
      buf := StrBuf()
      JsonOutStream( buf.out ).writeJson( appMap.map |spec| { spec.toMap } )
      WebUtil.jsMain( out, "fui::Main", [
          "fui.baseUri" : "/",
//          "fui.projName" : projStr,
          "fui.title" : title,
          "fui.app" : appStr,
          "fui.apps" : buf.toStr
        ] )
    out.headEnd
    out.body
    out.bodyEnd
    out.htmlEnd
  }
}

const class IndexMod : WebMod {
  const AppMod appMod
  
  new make( AppMod appMod ) : super() {
    this.appMod = appMod
  }
  
  override Void onGet() {
    req.mod = appMod
    appMod.onGet
  }
}