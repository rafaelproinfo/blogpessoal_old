#FROM openjdk:17-slim-buster as build

#COPY .mvn .mvn
#COPY mvnw .
#COPY pom.xml .

#RUN chmod -R 777 ./mvnw

#RUN ./mvnw -B dependency:go-offline                          

#COPY src src

#RUN ./mvnw -B package -DskipTests                                       

#FROM openjdk:17-jdk-slim-buster

#COPY --from=build target/blogpessoal*.jar .

#EXPOSE 8080/tcp
#EXPOSE 8080/udp
#EXPOSE 80/tcp
#EXPOSE 80/udp
#EXPOSE 443/tcp
#EXPOSE 443/udp

#ENTRYPOINT ["java", "-jar", "blogpessoal-0.0.1-SNAPSHOT.jar"]

#CMD ["./mvnw", "spring-boot:run"]


#FROM eclipse-temurin:17-jdk-focal
 
#WORKDIR /app
 
#COPY .mvn/ .mvn
#COPY mvnw pom.xml ./

#RUN chmod -R 777 ./mvnw

#RUN ./mvnw dependency:go-offline
 
#COPY src ./src

#EXPOSE 80:8080
#EXPOSE 443:8080
 
#CMD ["./mvnw", "spring-boot:run", "--debug"]

FROM openjdk:17-slim-buster as build
WORKDIR /workspace/app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN chmod -R 777 ./mvnw
RUN ./mvnw install -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.generation.blogpessoal.BlogpessoalApplication"]
