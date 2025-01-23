#!/bin/bash

# launch_gradio.sh
cd "$(dirname "$0")" || exit 1

# Activate the virtual environment
if [[ -d .venv ]]; then
    source .venv/bin/activate
else
    echo "Error: Virtual environment not found in .venv"
    exit 1
fi

# Configurable server URL
SERVER_URL="${SERVER_URL:-http://127.0.0.1:8080}"

# Function to terminate server process on exit
cleanup() {
    echo "Stopping the Gradio web server..."
    kill $SERVER_PID 2>/dev/null
}
trap cleanup EXIT

# Start the Gradio application
echo "Starting the Gradio web server..."
python gradio_app.py "$@" &
SERVER_PID=$!

# Wait for the server to become available
echo "Checking if server is available at $SERVER_URL..."
for i in {1..10}; do
    if curl -s "$SERVER_URL" > /dev/null; then
        echo "Server is running at $SERVER_URL"
        break
    fi
    sleep 2
done

if ! curl -s "$SERVER_URL" > /dev/null; then
    echo "Error: Server did not start within the expected time"
    exit 1
fi

# Open the browser
if command -v xdg-open > /dev/null; then
    xdg-open "$SERVER_URL"
elif command -v open > /dev/null; then
    open "$SERVER_URL"
elif command -v start > /dev/null; then
    start "$SERVER_URL"
else
    echo "Unable to detect a browser-opening command"
fi

# Wait for the server process
wait $SERVER_PID
