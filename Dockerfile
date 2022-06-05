FROM ruby:2.6.3-alpine AS builder

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

ENV BUNDLER_VERSION="1.17.3" \
    RAILS_ENV="production" \
    NODE_ENV="production" \
    BUNDLE_PATH="vendor/bundle" \
    BUNDLE_JOBS=6

RUN apk -U upgrade && \
    apk add --no-cache build-base git nodejs yarn && \
    gem install bundler:${BUNDLER_VERSION} --no-document

RUN if [[ "$RAILS_ENV" == "production" ]]; then bundle config set --local without 'development test'; fi && \
    bundle install --no-cache && \
    rm -rf /app/vendor/bundle/cache/*.gem && \
    find /app/vendor/bundle/gems/ -name "*.c" -delete && \
    find /app/vendor/bundle/gems/ -name "*.o" -delete && \
    mkdir -p tmp/pids

RUN yarn --check-files --silent --production && \
    yarn cache clean

COPY . ./

RUN bundle exec rails webpacker:compile && \
    bundle exec rake assets:precompile


FROM ruby:2.6.3-alpine AS runner

ENV RAILS_ENV="production" \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_MAX_THREADS="1" \
    WEB_CONCURRENCY="12" \
    PORT="3000" \
    ANALYTICS=true \
    SECRET_KEY_BASE="" \
    EXPLORER_API_KEY="" \
    BITQUERY_PROJECT_URL="https://bitquery.io" \
    BITQUERY_IMAGES="https://bitquery.io/wp-content/uploads/2020/09" \
    BITQUERY_GRAPHQL="http://graphql-internal.api-cluster.local" \
    BITQUERY_IDE_API="https://graphql.bitquery.io/ide/api" \
    BUNDLE_PATH="vendor/bundle"

RUN apk add --no-cache bash net-tools bind-tools tzdata && \
    adduser -h /app -H -s /bin/bash -D appuser && \
    rm -rf /var/cache/apk/*

COPY --from=builder --chown=appuser /app /app

RUN rm -rf node_modules tmp/cache  lib/assets

RUN chmod +x /app/entrypoint.sh

USER appuser

EXPOSE "${PORT}"

WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]

CMD ["bundle", "exec", "pumactl", "-F", "config/puma.production.rb", "-P", "tmp/pids/app.pid", "start"]

