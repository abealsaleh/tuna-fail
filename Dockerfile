FROM ruby:3.1.0

ADD . /app
WORKDIR /app
RUN bundle install
EXPOSE 4567
ENV TUNA_FAIL_BIND=0.0.0.0

ENTRYPOINT ["bundle", "exec", "ruby", "tuna-fail.rb"]
