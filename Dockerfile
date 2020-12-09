FROM openjdk:11 as build

COPY gradle /srv/demo-api/gradle/
COPY gradlew *.gradle.kts /srv/demo-api/
COPY src /srv/demo-api/src/

WORKDIR /srv/demo-api

RUN ./gradlew clean build -x test


FROM azul/zulu-openjdk-alpine:11.0.7-jre as demo-api-jvm

COPY --from=build /srv/demo-api/build/libs/demo-api.jar /

CMD java -jar /demo-api.jar


FROM oracle/graalvm-ce:20.3.0-java11 as native-image

COPY --from=build /srv/demo-api/build/libs/demo-api.jar /tmp/

RUN gu install native-image
RUN mkdir /tmp/compile && \
	cd /tmp/compile && \
	jar -xf ../demo-api.jar && \
	cp -R META-INF BOOT-INF/classes && \
	CP=BOOT-INF/classes:$(find BOOT-INF/lib | tr '\n' ':') && \
	MAINCLASS=io.tblx.demo.api.ApiApplicationKt && \
	native-image \
		-J-Xmx4G \
		-H:Name=demo-api \
		-H:+ReportExceptionStackTraces \
		-Dspring.native.remove-unused-autoconfig=true \
		-cp $CP $MAINCLASS

FROM ubuntu:20.04 as demo-api-native

COPY --from=native-image /tmp/compile/demo-api /demo-api

CMD /demo-api

