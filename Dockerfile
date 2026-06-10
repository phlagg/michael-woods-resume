FROM kjarosh/latex:2025.1-full

# Use Alpine's package manager to inject pdftotext natively
RUN apk add --no-cache poppler-utils

# Set the working directory to match your volume mount
WORKDIR /src
