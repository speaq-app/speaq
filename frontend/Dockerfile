FROM debian:bookworm AS builder
RUN apt update && \
    apt install -y git curl unzip zip file xz-utils which
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"
WORKDIR /frontend
COPY . .
RUN flutter build web

FROM nginx:1.21.1-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html