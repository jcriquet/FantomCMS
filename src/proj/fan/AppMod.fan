using db
using concurrent
using util
using web

const class AppMod : WebMod {
  const Str:AppSpec appMap
  const Str:ExtMeta extMap
  const Pod[] podList
  static const Method? getThemeSettings := Type.find( "themesExt::ThemesExt" ).method( "getSettings" )
  static const Method? getTheme := Type.find( "themesExt::ThemesExt" ).method( "getTheme" )
  static const Method? getLayoutSettings := Type.find( "layoutsExt::LayoutsExt" ).method( "getSettings" )
  static const Method? getLayout := Type.find( "layoutsExt::LayoutsExt" ).method( "getLayout" )
  static const Method? checkUserPerm := Type.find( "userExt::UserExt" ).method( "checkPerm" )
  static const Method? getUserPerms := Type.find( "userExt::UserExt" ).method( "getPerms" )
  
  new make( Str:Type exts ) {
    podList := Pod[,]
    extMap = exts.map |ext->ExtMeta?| {
      podList.remove( ext.pod )
      podList.add( ext.pod )
      return ext.facets.find |f| { f is ExtMeta } as ExtMeta
    }.exclude |meta| { meta == null }
    appMap = extMap.map |meta, name| {
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
    
    clientData := [
      "fui.baseUri" : "/",
      "fui.title" : title,
      "fui.app" : appStr,
    ]
    
    // Permissions
    curUser := Actor.locals["proj.curUser"] as Str
    if ( curUser != null && curUser != "guest" ) clientData[ "fui.curUser" ] = curUser
    Str[]? userPerms
    try if ( getUserPerms != null ) userPerms = getUserPerms.call( curUser )
    catch ( Err e ) {
      userPerms = ["settings"]
      if ( appStr != "settings" ) {
        res.redirect( ( clientData[ "fui.baseUri" ] + "app/settings" ).toUri )
        return
      }
    }
    if ( userPerms == null ) userPerms = extMap.keys
    if ( !userPerms.contains( appStr ) && appStr != "login" ) {
      res.redirect( ( clientData[ "fui.baseUri" ] + "app/login" ).toUri )
      return
    } else clientData[ "fui.perms" ] = userPerms.join(",")
    
    // Apps
    apps := appMap.findAll |spec, name| { userPerms.contains( name ) }.map |spec| { spec.toMap }
    clientData[ "fui.apps" ] = JsonOutStream.writeJsonToStr( apps )
    clientData[ "fui.exts" ] = JsonOutStream.writeJsonToStr( extMap.keys.findAll |name| { !apps.containsKey( name ) && userPerms.contains( name ) } )
    
    // Layouts and Themes
    Str? layoutId
    try if ( getThemeSettings != null && getTheme != null ) {
      Str:Str themeData := getTheme.call( getThemeSettings.call->get( "default" )->toStr )
      clientData.addAll( themeData )
      if ( themeData[ "themes.layout" ] != null ) layoutId = themeData[ "themes.layout" ]
    } catch ( Err e ) {}
    try if ( getLayout != null ) {
      if ( layoutId == null && getLayoutSettings != null ) layoutId = getLayoutSettings.call->get( "default" )->toStr
      if ( layoutId != null ) clientData.addAll( getLayout.call( layoutId ) )
    } catch ( Err e ) {}
    
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
  new make( AppMod appMod ) : super() { this.appMod = appMod }
  override Void onGet() {
    req.mod = appMod
    appMod.onGet
  }
}

const class LoginMod : WebMod {
  const AppMod appMod
  new make( AppMod appMod ) : super() { this.appMod = appMod }
  override Void onGet() {
    req.modBase = req.modBase[ 0..-2 ]
    req.mod = appMod
    appMod.onGet
  }
}

const class LogoutMod : WebMod {
  override Void onGet() {
    curUser := Actor.locals["proj.curUser"] as Str
    if ( curUser != null ) SessionStorage.cur.remove( curUser )
    res.redirect( req.headers[ "Referer" ]?.toUri ?: `/` )
  }
}
