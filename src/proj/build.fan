using build
class Build : BuildPod {
  new make() {
    podName   = "proj"
    version   = Version( [ 1, 0, 0 ] )
    summary   = ""
    srcDirs   = [`fan/`]
    outPodDir = `../../lib/fan/`
    depends   = ["sys 1.0",
                 "afBson 1.0",
                 "afMongo 0+",
                 "concurrent 1.0",
                 "db 1.0",
                 "inet 1.0",
                 "util 1.0",
                 "web 1.0",
                 "webmod 1.0",
                 "wisp 1.0"]
  }
}
