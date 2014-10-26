
@Js
const class AppSpec {
  const Str name
  const Str qname
  
  new make( Str name, Str qname ) {
    this.name = name
    this.qname = qname
  }
  
  Str:Str toMap() { [ "name" : name, "qname" : qname ] }
}
