FROM golang:latest

# Set the working directory
WORKDIR /app

# Copy the source code
COPY . .

# Build the application
RUN go build -o quickfix_server

# Set the entry point
CMD ["./quickfix_server"]

