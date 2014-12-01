using db
using afBson

class FCMSUserGroup
{
  Str:Int perm
  
  new make(){
    this.perm = [:]
  }
  
  static new fromMap(Str:Str map){
    toReturn := FCMSUserGroup()
    map.each |v, k| {
      toReturn.perm[k] = v.toInt
    }
    return toReturn
  }

  static new fromStr(Str group){
    groupList := DBConnector.cur.db["userExt"].group( ["group"], [:], Code.makeCode( "function(){}" )) as [Str:Str?][]
    groupList.each |v, k| { echo("$k $v") }
    return FCMSUserGroup()
  }
  
  Str:Str toMap(){
    toReturn := [:]
    this.perm.each |v, k| { 
      toReturn[k] = v
    }
    return toReturn
  }

  Void addPerm(Str app, Int val){
    this.perm[app] = val
  }
  
  Void setPerm(Str app, Int val){
    this.perm[app] = val
  }
  
  Void removePerm(Str app){
    try{
      this.perm.remove(app)
    }catch{
    }
  }
}