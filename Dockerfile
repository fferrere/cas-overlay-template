FROM eclipse-temurin:17-jdk AS overlay

RUN mkdir -p cas-overlay
COPY ./src cas-overlay/src/
COPY ./gradle/ cas-overlay/gradle/
COPY ./gradlew ./settings.gradle ./build.gradle ./gradle.properties ./lombok.config /cas-overlay/

RUN mkdir -p ~/.gradle \
    && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties \
    && cd cas-overlay \
    && chmod 750 ./gradlew \
    && ./gradlew --version;

RUN cd cas-overlay \
    && ./gradlew clean build --parallel --no-daemon;

FROM eclipse-temurin:17-jdk AS cas

LABEL "Organization"="Apereo"
LABEL "Description"="Apereo CAS"

RUN cd / \
    && mkdir -p /etc/cas/config \
    && mkdir -p /etc/cas/services \
    && mkdir -p /etc/cas/saml \
    && mkdir -p cas-overlay;

COPY --from=overlay cas-overlay/build/libs/cas.war cas-overlay/
COPY etc/cas/ /etc/cas/
COPY etc/cas/config/ /etc/cas/config/
COPY etc/cas/services/ /etc/cas/services/


RUN keytool -genkeypair \
            -alias cas \
            -keyalg RSA \
            -keypass changeit \
            -storepass changeit \
            -keystore /etc/cas/thekeystore \
            -dname "CN=www.exemple.org, OU=Caveman, O=Common Lisp, L=Lisp, ST=Lisp, C=ORG" \
            -ext SAN=dns:localhost

EXPOSE 8080 8443

ENV PATH $PATH:$JAVA_HOME/bin:.

WORKDIR cas-overlay
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "-jar", "cas.war"]
