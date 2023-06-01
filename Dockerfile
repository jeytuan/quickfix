FROM golang:1.17 AS builder

WORKDIR /app

# Copy the source code
COPY . .

# Build the application
RUN go build -o quickfix_server

# Build the fuzzing target
RUN go get github.com/dvyukov/go-fuzz/go-fuzz@latest && \
    go get github.com/dvyukov/go-fuzz/go-fuzz-build@latest && \
    go-fuzz-build -libfuzzer -o quickfix_fuzz

# Final image
FROM fuzzers/go-fuzz:1.2.0

# Copy the built application and fuzzing target
COPY --from=builder /app/quickfix_server /app/
COPY --from=builder /app/quickfix_fuzz /app/

# Set the working directory
WORKDIR /app

# Set the entry point
ENTRYPOINT ["/app/quickfix_server"]

# Fuzzing command (optional)
CMD ["/app/quickfix_fuzz"]

