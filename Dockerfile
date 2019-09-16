FROM gradle

### Development Image

ENV CARNIVAL_HOME /usr/carnival_home
ENV APOC_HOME /usr/Neo4j/plugins
ENV APOC_VERSION 3.4.0.7

# Install linux utils
RUN apt-get update --fix-missing && apt-get install -y \
    dos2unix rename sed\
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install APOC
RUN mkdir -p ${APOC_HOME}
ADD "https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/${APOC_VERSION}/apoc-${APOC_VERSION}-all.jar" $APOC_HOME


# set up CARNIVAL_HOME directory
WORKDIR ${CARNIVAL_HOME}/config
COPY app/carnival-core/config/*-template /${CARNIVAL_HOME}/config/
RUN rename -v 's/-template//' *-template
RUN dos2unix **

RUN mkdir ${CARNIVAL_HOME}/target

# update APOC location in application.yml config file
RUN sed -i "s#/path/to/neo4j/plugins#${APOC_HOME}#" application.yml