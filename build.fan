using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "FantomCMS"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0"]
  }
}
