FROM eclipse-temurin:21-jre-jammy

ENV FUSEKI_VERSION=6.0.0
ENV FUSEKI_HOME=/opt/fuseki
ENV FUSEKI_BASE=/fuseki

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz" \
    | tar xz -C /opt && \
    mv /opt/apache-jena-fuseki-${FUSEKI_VERSION} ${FUSEKI_HOME}

RUN mkdir -p ${FUSEKI_BASE}/databases/ds

EXPOSE 3030

WORKDIR ${FUSEKI_HOME}

CMD ["java", "-jar", "fuseki-server.jar", "--loc=/fuseki/databases/ds", "--update", "/ds"]
