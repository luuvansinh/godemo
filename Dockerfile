FROM golang:latest as builder

# Add Maintainer Info
LABEL maintainer="Cashbag <dev@cashbag.vn>"

# Set the Current Working Directory inside the container
RUN mkdir -p /app
WORKDIR /app

# Copy data to working dir
COPY . .

# Install dependencies
RUN go mod download

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./main.go

######## Start a new stage from scratch #######
FROM alpine:latest

RUN apk --no-cache add tzdata zip ca-certificates

WORKDIR /app

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app .

# Command to run the executable
CMD ["./main"]