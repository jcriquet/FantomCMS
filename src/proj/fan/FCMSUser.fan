class FCMSUser
{
  Str name
  Str pw
  FCMSUserGroup group
  
  new make(Str name, Str pw, FCMSUserGroup group := FCMSUserGroup()) : super(){
    this.name = name
    this.pw = pw
    this.group = group
  }
  
  static new fromMap(Str:Str map){
    Str? user
    Str? pw
    Str? group
    map.each |v, k| {
      if(k == "name"){
        user = v
        return
      }else if(k == "pw"){
        pw = v
        return
      }else if(k == "group"){
        group = v
        return
      }
    }
    if(user == null || pw == null || group == null){
      throw Err("Bad user read from map.")
    }
    
    toReturn := FCMSUser(user, pw, FCMSUserGroup.fromStr(group))
    return toReturn
  }
  
  Str:Str toMap(){
    toReturn := [:]
    toReturn["name"] = this.name
    toReturn["pw"] = this.pw
    toReturn["group"] = this.group.toStr
    return toReturn
  }
}