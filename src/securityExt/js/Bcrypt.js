fan.securityExt.Bcrypt = fan.sys.Obj.$extend(fan.sys.Obj);
fan.securityExt.Bcrypt.prototype.$ctor = function(self) { this.m_bcrypt = new bCrypt(); }
fan.securityExt.Bcrypt.make = function() { return new fan.securityExt.Bcrypt(); }
fan.securityExt.Bcrypt.prototype.genSalt = function(rounds) { return this.m_bcrypt.gensalt(rounds); }
fan.securityExt.Bcrypt.prototype.hashPw = function(password, salt, callback, progress) { this.m_bcrypt.hashpw(password, salt, callback, progress); }
fan.securityExt.Bcrypt.prototype.m_bcrypt = null

