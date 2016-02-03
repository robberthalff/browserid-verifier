FROM node:4.2.4

# install libgmp-dev for fast crypto and 
RUN apt update && \
    apt install -y libgmp-dev

# add a non-privileged user for installing and running
# the application
RUN groupadd --gid 1001 app && \
    useradd --uid 1001 --gid 1001 --home /app --create-home app

WORKDIR /app

ENV IP_ADDRESS=127.0.0.1"
ENV PORT=3000
ENV FALLBACK_DOMAIN=
ENV HTTP_TIMEOUT=8.0
ENV INSECURE_SSL=false
ENV TOOBUSY_MAX_LAG=70
# ENV COMPUTECLUSTER_MAX_PROCESSES=
# ENV COMPUTECLUSTER_MAX_BACKLOG=
# ENV LOG_FORMATTERS=
# ENV TEST_SERVICE_FAILURE=

expose 3000

# Install node requirements and clean up unneeded cache data
COPY package.json package.json
RUN su app -c "npm install" && \
    npm cache clear && \
    rm -rf ~app/.node-gyp && \
    apt remove -y libgmp-dev && \
    apt-get autoremove -y && \
    apt-get clean

# Finally copy in the app's source file
# More cache friendly?
COPY . /app

USER app
ENTRYPOINT ["npm"]
CMD ["start"]
