FROM ruby:2.6.3-alpine AS builder

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN apk -U upgrade && \
    apk add --no-cache build-base git nodejs yarn

ENV RAILS_ENV="production"

RUN if [[ "$RAILS_ENV" == "production" ]]; then bundle install --no-cache --without 'development test'; else bundle install --no-cache; fi

RUN gem install --no-document tzinfo-data && \
    yarn --check-files --silent --production && \
    yarn cache clean

COPY . ./

RUN bundle exec rails webpacker:compile assets:clean



FROM ruby:2.6.3-alpine AS runner

ENV RAILS_SERVE_STATIC_FILES="true" \
    ANALYTICS="true" \
    SECRET_KEY_BASE="" \
    EXPLORER_API_KEY="" \
    BITQUERY_PROJECT_URL="https://bitquery.io" \
    BITQUERY_IMAGES="https://bitquery.io/wp-content/uploads/2020/09" \
    BITQUERY_GRAPHQL="http://graphql-internal.api-cluster.local" \
    BITQUERY_IDE_API="https://graphql.bitquery.io/ide/api" \
    RAILS_MAX_THREADS="1" \
    WEB_CONCURRENCY="12" \
    PORT="3000" \
    RAILS_ENV="production"

# Add a script to be executed every time the container starts.
RUN apk add --no-cache bash net-tools tzdata

RUN adduser -h /app -H -s /bin/bash -D appuser

COPY --from=builder --chown=appuser /app /app

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

RUN chmod +x /app/entrypoint.sh

USER appuser

EXPOSE "${PORT}"

WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]

# Configure the main process to run when running the image
CMD ["bundle", "exec", "pumactl", "-F", "config/puma.production.rb", "-P", "/run/app.pid", "start"]

