FROM ruby:2.7.2-slim

WORKDIR /app

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -qq \
        g++ \
        gcc \
        make \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Generate an app user instead of root.
ARG USERNAME=app
ARG GROUPNAME=${USERNAME}
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd -g ${USER_GID} ${GROUPNAME} \
    && useradd -rm -u ${USER_UID} -g ${GROUPNAME} ${USERNAME}

# Throw errors if Gemfile has been modified since Gemfile.lock.
RUN bundle config --global frozen 1

USER ${USERNAME}:${GROUPNAME}
COPY --chown=${USERNAME} Gemfile* ./
RUN bundle install

# Copy source codes to the directory.
COPY --chown=${USERNAME} . ./

CMD ["ruby", "main.rb"]
