using concurrent
using fwt
using proj
using util

@Js
class Main {
  Void main() {
    vars := Env.cur.vars
    fui := Fui {
      appMap = ( (Str:Obj?) JsonInStream( vars[ "fui.apps" ].in ).readJson ).map |Str:Str map->AppSpec| { AppSpec( map[ "name" ], map[ "qname" ] ) }
      baseUri = vars[ "fui.baseUri" ].toUri
    }
    Actor.locals[ "fui.cur" ] = fui
    app := (App) Type.find( fui.appMap[ vars[ "fui.app" ] ].qname ).make
    app.spec = fui.appMap[ vars[ "fui.app" ] ]
    Window { content = app }.open
    app.onReady
  }
}
