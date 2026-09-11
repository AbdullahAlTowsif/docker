FROM ubuntu:24.04

RUN apt update
RUN apt install -y golang

WORKDIR /app
# first server.go is from your local machine
# second server.go will be in the container
COPY ./server.go ./server.go

CMD ["go", "run", "server.go"]
