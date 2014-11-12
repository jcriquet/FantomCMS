// Author:Joshua Leihe

@Js
native class Bcrypt {
  new make()
  Str genSalt( Int rounds )
  Void hashPw( Str password, Str salt, |Str| callback, |->|? progress := null )
}


// JavaScript peer

/*
// Functions: 

bcrypt
bcrypt.gensalt(rounds)
bcrypt.hashpw($(password, salt, result, function() {});

// JavaScript peer
fan.mypod.FooPeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.mypod.FooPeer.prototype.$ctor = function(self) {}
fan.mypod.FooPeer.prototype.add = function(self, a, b) { return a + b; }

*/