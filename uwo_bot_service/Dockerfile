FROM ruby:2.7.2-slim AS gem-builder
WORKDIR /workspace
COPY --chown=root VERSION ./VERSION
COPY --chown=root uwo_bot_core ./uwo_bot_core/
COPY --chown=root uwo_bot_service ./uwo_bot_service/
RUN mkdir gems \
    && for g in uwo_bot_core uwo_bot_service; do \
        gem build ${g}/${g}.gemspec -C ${g} -o ../gems/${g}.gem; \
    done

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

RUN mkdir /app && chown ${USER_NAME}:${GROUP_NAME} /app
WORKDIR /app

USER ${USER_NAME}:${GROUP_NAME}

COPY --from=gem-builder --chown=${USER_NAME} /workspace/gems/*.gem ./

RUN for g in uwo_bot_core uwo_bot_service; do \
        bundle config --global local.${g} $(pwd)/${g}.gem; \
    done \
    && gem install uwo_bot_service

CMD ["uwo_bot_service"]
