FROM ruby:3.3.3-alpine AS builder

WORKDIR /app
ENV RAILS_ENV="production" \
    BUNDLE_PATH="vendor/bundle" \
    GEM_HOME="vendor/bundle"

ENV PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"

COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN apk -U upgrade && \
    apk add --no-cache build-base git nodejs yarn

RUN bundle config set --local without 'development test' && \
    bundle config set no-cache 'true' && \
    bundle install && \
    rm -rf /app/vendor/bundle/cache/*.gem && \
    mkdir -p tmp/pids

RUN node -v && \
    yarn version

RUN yarn install --production && \
    yarn cache clean

COPY . ./

RUN bundle exec rails webpacker:compile && \
    bundle exec rake assets:precompile




FROM ruby:3.3.3-alpine AS runner

WORKDIR /app

ENV RAILS_ENV="production" \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_MAX_THREADS="1" \
    WEB_CONCURRENCY="12" \
    PORT="3000" \
    ANALYTICS=true \
    SECRET_KEY_BASE="" \
    EXPLORER_API_KEY="" \
    BUNDLE_PATH="vendor/bundle" \
    GEM_HOME="vendor/bundle"

ENV PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"

RUN apk add --no-cache bash net-tools bind-tools tzdata && \
    adduser -h /app -H -s /bin/bash -D appuser && \
    rm -rf /var/cache/apk/*

COPY --from=builder --chown=appuser /app /app
COPY --from=builder --chown=appuser /usr/local/bundle /usr/local/bundle

RUN chown appuser:appuser -R /app \
   && chmod +x /app/entrypoint.sh

USER appuser

EXPOSE "${PORT}"

ENTRYPOINT ["./entrypoint.sh"]

CMD ["bundle", "exec", "pumactl", "-F", "config/puma.production.rb", "-P", "tmp/pids/app.pid", "start"]

