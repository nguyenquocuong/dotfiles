#!/bin/bash

SESSION_NAME="HiredSpeed"

tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? = 0 ]; then
  tmux kill-session -t $SESSION_NAME
fi

tcp_test() {
    local host="$1"
    local port="$2"
    local timeout="${3:-30}"  # Default timeout of 30 seconds
    local interval=1
    local elapsed=0

    echo "Testing TCP connection to $host:$port with a timeout of $timeout seconds..."

    while true; do
        # Attempt to open the socket
        if exec 3<>"/dev/tcp/$host/$port" 2>/dev/null; then
            echo "Connection to $host:$port successful!"
            exec 3<&-
            exec 3>&-
            return 0
        fi

        # Increment elapsed time
        ((elapsed += interval))
        
        # Check if the timeout has been reached
        if ((elapsed >= timeout)); then
            echo "Timeout reached! Could not connect to $host:$port."
            return 1
        fi

        # Wait before retrying
        echo "Retrying in $interval second(s)..."
        sleep "$interval"
    done
}

# if [ $? != 0 ]; then
  # Create a new tmux session
  tmux new-session -d -s $SESSION_NAME

  tmux switch-client -t $SESSION_NAME

  # Pane 1 - Backend API
  tmux send-keys -t $SESSION_NAME:1.0 "cd ~/projects/HireSpeed/backend-api" C-m C-l
  tmux send-keys -t $SESSION_NAME:1.0 "docker-compose up -d" C-m
  tmux send-keys -t $SESSION_NAME:1.0 "nvm use && yarn migration:run && yarn seed:run:relational && yarn start:dev" C-m
  tcp_test "127.0.0.1" 3000 || exit $?

  # Pane 2 - Backend Notification
  tmux split-window -h -t $SESSION_NAME:1.0
  tmux send-keys -t $SESSION_NAME:1.1 "cd ~/projects/HireSpeed/backend-notification" C-m C-l
  tmux send-keys -t $SESSION_NAME:1.1 "nvm use && yarn migration:run && yarn start:dev" C-m
  tcp_test "127.0.0.1" 3001 || exit $?

  # Pane 3 - Stripe webhook listener
  tmux split-window -v -t $SESSION_NAME:1.0
  tmux send-keys -t $SESSION_NAME:1.1 "stripe listen --forward-to http://127.0.0.1:3000/api/v1/stripe/webhook" C-m

  # Pane 4 - Stripe payment client
  tmux split-window -v -t $SESSION_NAME:1.2
  tmux send-keys -t $SESSION_NAME:1.3 "cd ~/projects/HireSpeed/stripe" C-m C-l
  tmux send-keys -t $SESSION_NAME:1.3 "nvm use lts && yes | yarn start-client"
# fi


# Switch to the session
# tmux switch-client -t $SESSION_NAME

