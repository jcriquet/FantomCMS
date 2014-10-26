using fwt
using webfwt

@Js
class TableMeterConfig : TableConfig {
  new make( TestApp app ) : super( app, "Meters", `meters` ) {}
  
  override once Str:Obj items() { [
    "meter_id" : "",
    "utility" : [ "Chilled Water", "Cond Water", "Diesel Fuel", "Electric", "Hot Water", "Hours", "Irrigation", "Marine", "Nat Gas", "Sewer", "Water" ],
    "unit" : [ "CCF", "CF", "Gal", "Hrs", "MCF", "Therms", "Tons", "kGal", "kWh" ],
    "is_virtual" : true,
    "caan_id" : "",
    "vendor_id" : "",
    "ratecode_id" : "",
  ] }
  
  override Void onPopup( Event e, Str:Obj? row ) {
    echo( e.pos )
    Menu {
      MenuItem { it.text = "View Installs" },
      MenuItem {
        if ( row[ "is_virtual" ] == true || app.options[ "is_virtual" ] == true ) {
          it.text = "View Mappings"
        } else {
          it.text = "View Reads"
        }
      },
    }.open( app.table, e.pos )
  }
}
