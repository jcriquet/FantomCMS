using afBson
using db
using proj
using util
using web

@ExtMeta {
  name = "layouts"
  app = layoutsExt::LayoutsApp#
  icon = "themes-50.png"
}
const class LayoutsExt : Ext, Weblet {
  static const Type stype := LayoutsExt#
  override Void onGet() { _get( req.modRel.pathOnly.toStr ) }
  
  override Void onPost() {
    in := JsonInStream( req.in )
    data := in.readJson
    in.close
    reqLayout := ObjectId( req.modRel.pathOnly.toStr, false )
    db := DBConnector.cur.db[ typeof.pod.toStr ]
    if ( reqLayout == null || db.findAndUpdate( ["_id":reqLayout], data, false ) == null ) {
      document := db.findAndUpdate( ["_false":true], data, true, ["upsert":true] )
      reqLayout = document[ "_id" ]
    }
    _get( reqLayout.toStr )
  }
  
  private Void _get( Str _id ) {
    Str:Obj? json := [:]
    settingsDoc := getSettings
    defaultId := settingsDoc[ "default" ].toStr
    reqLayout := ObjectId( _id, false )
    db := DBConnector.cur.db[ typeof.pod.toStr ]
    if ( reqLayout != null && _id != defaultId ) {
      if ( req.uri.query[ "default" ] == "true" ) {
        settingsDoc[ "default" ] = reqLayout
        if ( DBConnector.cur.db[ "settingsExt" ].update( ["ext":"layoutsExt"], settingsDoc ) > 0 ) defaultId = settingsDoc[ "default" ].toStr
      }
      if ( req.uri.query[ "delete" ] == "true" && db.delete( ["_id":reqLayout] ) > 0 ) reqLayout = ObjectId( defaultId )
    }
    json[ "myLayout" ] = defaultId
    json[ "list" ] = db.group( ["_id", "title"], [:], Code.makeCode( "function(){}" ) )
    if ( reqLayout != null && ( ([Str:Obj?][]) json[ "list" ] ).any |map| { map[ "_id" ] == reqLayout } ) {
      document := db.findOne( ["_id":reqLayout], false )
      json[ "selected" ] = document
    }
    ( ([Str:Obj?][]) json[ "list" ] ).find |layout| { layout[ "_id" ].toStr == defaultId }?.set( "default", true )
    content := JsonOutStream.writeJsonToStr( json )
    res.headers[ "Content-Type" ] = "text/plain"
    res.headers[ "Content-Length" ] = content.size.toStr
    out := res.out
    out.writeChars( content )
    out.close
    res.done
  }
  
  static Str:Obj? getSettings() {
    settingsDoc := DBConnector.cur.db[ "settingsExt" ].findOne( ["ext":stype.pod.toStr], false )
    if ( settingsDoc == null ) settingsDoc = DBConnector.cur.db[ "settingsExt" ].findAndUpdate( ["ext":stype.pod.toStr], ["ext":stype.pod.toStr], true, ["upsert":true] )
    defaultId := settingsDoc[ "default" ] as ObjectId
    if ( defaultId == null || DBConnector.cur.db[ stype.pod.toStr ].findCount( ["_id":defaultId] ) == 0 ) {
      defaultId = DBConnector.cur.db[ stype.pod.toStr ].findOne( [:], false )?.get( "_id" ) as ObjectId
      if ( defaultId == null ) {
        sampleLayout := [
          "title":     "Sample Layout",
          "paneTop":   "fui::ThemedBorderPane {
                          bgStyle=\"header\"
                          border=gfx::Border(\"0,0,3 outset #444444\")
                          insets=gfx::Insets(\"10\")
                          webfwt::FlowPane {
                            fui::AppDrawerButton {
                            },
                          },
                        }".splitLines.map |line->Str| { line.trimStart }.join( "\n" ),
          "paneBottom":"fui::ThemedBorderPane {
                          bgStyle=\"footer\"
                          border=gfx::Border(\"3,0,0 outset #444444\")
                          insets=gfx::Insets(\"10\")
                          fwt::GridPane {
                            numCols=1
                            halignPane=gfx::Halign(\"right\")
                            audioExt::AudioPlayer(\"fui://api/audio/02%2023%20Flavors\"),
                          },
                        }".splitLines.map |line->Str| { line.trimStart }.join( "\n" ),
          ]
        defaultId = DBConnector.cur.db[ stype.pod.toStr ].findAndUpdate( ["_false":true], sampleLayout, true, ["upsert":true] )[ "_id" ]
      }
      settingsDoc[ "default" ] = defaultId
      DBConnector.cur.db[ "settingsExt" ].findAndUpdate( ["ext":stype.pod.toStr], settingsDoc, true )
    }
    return settingsDoc
  }
  
  static Str:Str getLayout( Str id ) {
    [Str:Obj?]? document
    try document = DBConnector.cur.db[ stype.pod.toStr ].findOne( ["_id":ObjectId( id )], false )
    catch ( Err e ) {}
    map := [:]
    if ( document == null ) return map
    |Str, Obj?, Str|? eachFunc
    eachFunc = |Str leading, Obj? v, Str k| {
      if ( v is Str:Obj? ) {
        ( (Str:Obj?) v ).each( eachFunc.bind( [leading + "." + k] ) )
      } else if ( v != null ) map[ leading + "." + k ] = v.toStr
    }
    document.each( eachFunc.bind( ["layouts"] ) )
    return map
  }
}
