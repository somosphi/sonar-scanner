FROM openjdk:8-alpine

LABEL maintainer="henrique.schmidt@somosphi.com"

ARG SONAR_SCANNER_VERSION="sonar-scanner-cli-3.3.0.1492-linux"

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/src

# run
RUN apk update && \
    apk add --no-cache npm bash sed unzip && \
    npm install -g typescript ts-node

# Install sonar-scanner
ADD https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_VERSION}.zip /tmp/sonarscanner.zip
RUN unzip /tmp/sonarscanner.zip -d /usr/lib/ && \
    mv -v /usr/lib/sonar-scanner*/ /usr/lib/sonar-scanner/ && \
    ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/bin/ && \
    ln -s /usr/lib/sonar-scanner/bin/sonar-scanner-debug /usr/bin/ && \
    rm /tmp/sonarscanner.zip && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner

ENTRYPOINT ["/bin/bash"]
