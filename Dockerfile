FROM lambci/lambda:build-ruby2.5
WORKDIR /app
COPY Gemfile* ./
RUN bundle --jobs 4 --deployment --without development
COPY lambda_function.rb ./
RUN ["zip", "-r", "lambda_function.zip", "./"]
