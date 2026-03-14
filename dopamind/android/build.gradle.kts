// Redeclared in settings.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    configurations.all {
        resolutionStrategy {
            eachDependency {
                if (requested.group == "androidx.core" && (requested.name == "core" || requested.name == "core-ktx")) {
                    useVersion("1.13.1")
                }
            }
        }
    }
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            android.compileSdkVersion(36)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
