using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "FantomCMS"
    summary = ""
    srcDirs = [`fan/`]
    depends = [
	"sys 1.0",
      	"afMongo 0+",
      	"afBson 0+",
      	"inet 0+",
      	"concurrent 0+"
	]
  }
}
