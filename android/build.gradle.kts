allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
plugins {
    `kotlin-dsl` // do NOT specify version
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.named<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

