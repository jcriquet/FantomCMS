#! /usr/bin/env fansubstitute

using build
class Build : BuildGroup {

//////////////////////////////////////////////////////////////////////////
// BuildScript
//////////////////////////////////////////////////////////////////////////
  new make() {
    srcDir := Env.cur.homeDir + `src/`
    childs := srcDir.listDirs.findAll |file| { ( file + `build.fan`  ).exists }.map |dir->Uri| { dir.uri + `build.fan` }
	ordered := [ `db/`, `proj/`, `fui/`, `settingsExt/`, `layoutsExt/`, `themesExt/`, `homeExt/`, `userExt/`, `loginExt/` ].map |dir->Uri| { srcDir.uri + dir + `build.fan` }
	ordered.eachr |dir| { if ( childs.remove( dir ) != null ) childs.insert( 0, dir ) }
    childrenScripts = childs
  }
  
  override TargetMethod[] targets() {
    acc := TargetMethod[,]
    typeof.methods.each |m| {
      if ( !m.hasFacet( Target# ) ) return
      acc.add( TargetMethod( this, m ) )
    }
    return acc
  }

//////////////////////////////////////////////////////////////////////////
// Compile
//////////////////////////////////////////////////////////////////////////

  @Target { help = "Run 'compile' on all pods" }
  Void compile() {
    spawnOnChildren("compile")
  }

//////////////////////////////////////////////////////////////////////////
// Clean
//////////////////////////////////////////////////////////////////////////

  @Target { help = "Run 'clean' on all pods" }
  Void clean() {
    runOnChildren("clean")
  }

//////////////////////////////////////////////////////////////////////////
// Test
//////////////////////////////////////////////////////////////////////////

  @Target { help = "Run 'test' on all pods" }
  Void test() {
    fantExe := Exec.exePath(devHomeDir + `bin/fant`)
    Exec.make(this, [fantExe, "-all"]).run
  }

//////////////////////////////////////////////////////////////////////////
// Full
//////////////////////////////////////////////////////////////////////////

  @Target { help = "Run clean, compile, test on all pods" }
  Void full() {
    clean
    compile
    test
  }
}
