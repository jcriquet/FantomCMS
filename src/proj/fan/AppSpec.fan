
@Js
const class AppSpec {
  const Str name
  const Str qname
  const Str label
  
  new make( Str name, Str qname, Str label ) {
    this.name = name
    this.qname = qname
    this.label = label
  }
  
  static new makeFromMap( Str:Str map ) {
    AppSpec( map["name"], map["qname"], map["label"] )
  }
  
  Str:Str toMap() { [ "name" : name, "qname" : qname, "label" : label ] }
}
