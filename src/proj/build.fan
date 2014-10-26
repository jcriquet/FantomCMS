using build
class Build : BuildPod {
  new make() {
    podName   = "proj"
    summary   = ""
    srcDirs   = [`fan/`]
    outPodDir = `../../lib/fan/`
    depends   = ["sys 1.0",
                 "sql 1.0",
                 "util 1.0",
                 "web 1.0",
                 "webmod 1.0",
                 "wisp 1.0"]
  }
}
