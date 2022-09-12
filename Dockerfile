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


FROM eclipse-temurin:17-jdk-focal
 
WORKDIR /app
 
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

RUN chmod -R 777 ./mvnw

RUN ./mvnw dependency:go-offline
 
COPY src ./src

EXPOSE 80
EXPOSE 443
 
CMD ["./mvnw", "spring-boot:run", "--debug"]