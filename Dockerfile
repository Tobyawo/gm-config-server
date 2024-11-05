FROM openjdk:17
#EXPOSE 8086
ADD target/gm-config-server.jar gm-config-server.jar
ENTRYPOINT [\
"java",\
 "-jar", \
 "/gm-config-server.jar"\
 ]
