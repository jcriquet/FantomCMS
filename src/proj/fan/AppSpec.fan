
@Js
const class AppSpec {
  const Str name
  const Str qname
  const Str label
  const Str icon
  
  new make( Str name, Str qname, Str label, Str icon) {
    this.name = name
    this.qname = qname
    this.label = label
    this.icon = icon
  }
  
  static new makeFromMap( Str:Str map ) {
    AppSpec( map["name"], map["qname"], map["label"], map["icon"] )
  }
  
  Str:Str toMap() { [ "name" : name, "qname" : qname, "label" : label, "icon" : icon ] }
}
