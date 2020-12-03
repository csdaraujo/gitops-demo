import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.springframework.boot.gradle.tasks.bundling.BootJar as BootJar

plugins {
	id("org.springframework.boot") version "2.4.0"
	id("io.spring.dependency-management") version "1.0.10.RELEASE"
	id("jacoco")
	kotlin("jvm") version "1.4.10"
	kotlin("plugin.spring") version "1.4.10"
}

group = "io.tblx.demo"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
	mavenCentral()
	maven {
		url = uri("https://repo.spring.io/milestone")
	}

}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
	implementation("org.springframework.experimental:spring-graalvm-native:0.8.3")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.withType<Test> {
	useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
	kotlinOptions {
		freeCompilerArgs = listOf("-Xjsr305=strict")
		jvmTarget = "11"
	}
}

jacoco {
	toolVersion = "0.8.6"
}

tasks.test {
	finalizedBy(tasks.jacocoTestReport)
}

tasks.withType<JacocoReport> {
	classDirectories.setFrom(files(classDirectories.files.map {
		fileTree(it).filter {
			!it.name.endsWith("Kt.class") // exclude Kotlin generated classes from the report
		}
	}))

	reports {
		xml.isEnabled = true
	}

	dependsOn(tasks.test)
}

tasks.getByName<BootJar>("bootJar") {
	mainClassName = "io.tblx.demo.api.ApiApplicationKt"
}

tasks.register<BootJar>("webJar") {
	mainClassName = "io.tblx.demo.api.ApiApplicationKt"
	archiveFileName.set("${rootProject.name}.jar")

	with(tasks.getByName<BootJar>("bootJar"))
}

tasks.assemble {
	dependsOn("webJar")
}
