using db
using util
using web

const class AppMod : WebMod {
  const Str:AppSpec appMap
  const Pod[] podList
  static const Method? getTheme := Type.find( "themesExt::ThemesExt" ).method( "getTheme" )
  
  new make( Str:Type exts ) {
    podList := Pod[,]
    metas := (Str:ExtMeta) exts.map |ext->ExtMeta?| {
      podList.remove( ext.pod )
      podList.add( ext.pod )
      return ext.facets.find |f| { f is ExtMeta } as ExtMeta
    }.exclude |meta| { meta == null }
    appMap = metas.map |meta, name| {
      app := meta.app
      return app == null ? null : AppSpec( name, app.qname, meta.label ?: name.capitalize, meta.icon ?: "default-50.png" )
    }.exclude |app| { app == null }
    this.podList = podList
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
    
    buf := StrBuf()
    JsonOutStream( buf.out ).writeJson( appMap.map |spec| { spec.toMap } )
    clientData := [
      "fui.baseUri" : "/",
      "fui.title" : title,
      "fui.app" : appStr,
      "fui.apps" : buf.toStr
    ]
    curTheme := DBConnector.cur.db[ "settingsExt" ].findOne( ["ext":"themesExt"], false )?.get( "default" )?.toStr
    if ( getTheme != null ) clientData.addAll( getTheme.call( curTheme ) )
    
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
      podList.each |pod| { out.includeJs( "/pod/$pod/${pod}.js".toUri ) }
      WebUtil.jsMain( out, "fui::Main", clientData )
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