using build
class Build : BuildGroup {
  new make() {
    childrenScripts = File( `src/` ).listDirs.findAll |file| { ( file + `build.fan`  ).exists }.map |dir->Uri| { return dir.uri + `build.fan` }
  }
}
