FROM openjdk:latest
MAINTAINER Michael Rayva <mrayva@gmail.com>

# Add DSE group and user
RUN groupadd -r grakn \
    && useradd -r -g grakn grakn

ARG GRAKN_VERSION
 
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends lsof \
    && rm -rf /var/lib/apt/lists/*
 
RUN wget "https://github.com/graknlabs/grakn/releases/download/v$GRAKN_VERSION/grakn-dist-$GRAKN_VERSION.zip" -P /opt

RUN unzip /opt/grakn-dist-$GRAKN_VERSION.zip -d /opt \
    && rm /opt/grakn-dist-$GRAKN_VERSION.zip
 
RUN ln -s /opt/grakn-dist-$GRAKN_VERSION/ /opt/grakn \
    && chown -R grakn:grakn /opt/grakn \
    && sed -i "s/ai.grakn.engine.GraknEngineServer &/ai.grakn.engine.GraknEngineServer/" /opt/grakn/bin/grakn-engine.sh

EXPOSE 4567
           
ENTRYPOINT [ "/opt/grakn/bin/grakn.sh" ]

CMD ["start"]

