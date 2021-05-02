FROM ruby:2.7.2-slim

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -qq \
        g++ \
        gcc \
        make \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Generate an app user instead of root.
ARG USER_NAME=app
ARG GROUP_NAME=${USER_NAME}
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd -g ${USER_GID} ${GROUP_NAME} \
    && useradd -rm -u ${USER_UID} -g ${GROUP_NAME} ${USER_NAME}

# Throw errors if Gemfile has been modified since Gemfile.lock.
RUN bundle config --global frozen 1

RUN mkdir /app && chown ${USER_NAME}:${GROUP_NAME} /app
WORKDIR /app

USER ${USER_NAME}:${GROUP_NAME}
COPY --chown=${USER_NAME} Gemfile* ./
RUN bundle install

# Copy source codes to the directory.
COPY --chown=${USER_NAME} . ./

CMD ["ruby", "src/main.rb"]
