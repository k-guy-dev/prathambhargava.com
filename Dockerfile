FROM alpine:3.19

# Install necessary base dependencies
RUN apk add --no-cache \
    ca-certificates \
    curl \
    tar \
    xz \
    gcc \
    musl-dev \
    git

# Install Go
ENV GO_VERSION=1.22.1
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Install Dart SDK
ENV DART_VERSION=3.3.0
RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip && \
    unzip dartsdk-linux-x64-release.zip -d /usr/local && \
    rm dartsdk-linux-x64-release.zip

# Install Dart Sass
RUN apk add --no-cache nodejs npm && \
    npm install -g sass

# Install Hugo
ENV HUGO_VERSION=0.124.1
RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar -xzf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz hugo && \
    mv hugo /usr/local/bin/ && \
    rm hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

# Set up PATH
ENV PATH="/usr/local/go/bin:/usr/local/dart-sdk/bin:$PATH"

# Set working directory
WORKDIR /workspace

RUN echo "Executing testing commands"
RUN hugo version
RUN go version


COPY . .

# Default command
CMD ["hugo server -D"]
