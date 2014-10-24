using build
class Build : build::BuildPod
{
  new make()
  {
    podName   = "fui"
    summary   = ""
    srcDirs   = [`fan/`]
    outPodDir = `../../lib/fan/`
    depends   = ["sys 1.0",
                 "concurrent 1.0",
                 "dom 1.0",
                 "fwt 1.0",
                 "proj 1.0",
                 "sql 1.0",
                 "util 1.0",
                 "web 1.0",
                 "webmod 1.0"]
  }
}
