name := """SpendSpentSpent"""

version := "1.0.1"

lazy val root = (project in file(".")).enablePlugins(PlayJava, PlayEbean, SbtWeb)

scalaVersion := "2.11.6"

libraryDependencies ++= Seq(
  javaJdbc,
  cache,
  javaWs,
  evolutions,
  filters,
  "mysql" % "mysql-connector-java" % "5.1.18",
  "com.google.code.gson" % "gson" % "2.2.4",
  "com.github.julman99" % "gson-fire" % "0.11.0"
)

// Play provides two styles of routers, one expects its actions to be injected, the
// other, legacy style, accesses its actions statically.
routesGenerator := InjectedRoutesGenerator

LessKeys.compress in Assets := true


//pipelineStages := Seq(uglify)







excludeFilter in (Assets, JshintKeys.jshint) := new FileFilter{ def accept(f: File) = ".*/vendor/.*".r.pattern.matcher(f.getAbsolutePath).matches }

//excludeFilter in uglify := new FileFilter{ def accept(f: File) = ".*min.*".r.pattern.matcher(f.getAbsolutePath).matches }
