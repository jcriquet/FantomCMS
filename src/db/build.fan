using build
class Build : build::BuildPod {
  new make() {
    podName   = "db"
    version   = Version( [ 1, 0, 0 ] )
    summary   = ""
    srcDirs   = [`fan/`]
    outPodDir = `../../lib/fan/`
    depends   = ["sys 1.0",
                 "afBson 1.0",
                 "afMongo 0+",
                 "concurrent 1.0",
                 "inet 1.0"]
  }
}
