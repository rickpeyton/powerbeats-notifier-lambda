#!/bin/bash
docker build -t $(basename `pwd`) .
docker run --rm -d -it --name $(basename `pwd`) $(basename `pwd`) bash
docker cp $(basename `pwd`):/app/lambda_function.zip .
docker kill $(basename `pwd`)
