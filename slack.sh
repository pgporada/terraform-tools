#!/bin/bash
# AUTHOR: Phil Porada
# WHAT: Pipe data through this script to send it to Slack. Will display as a code block.

SLACK_MESSAGE="\`\`\`"${1}"\`\`\`"
SLACK_URL="https://hooks.slack.com/services/XXXXXXXXXXXXXXXXXXXXXXXXXX"

function usage() {
    echo "
        ./$(basename $0) < <(echo testdata)
        ./$(basename $0) <<< testdata
        echo testdata | ./$(basename $0)
    "
}

if [ "$1" == "-h" ]; then
    usage
    exit 0
fi

# Test if stdin was opened by a terminal
if [ -t 0 ]; then
	# Test for cli invocation arguments
    if [ $# -gt 0 ]; then
		# Echo all cli arguments to the command
        MESSAGE="$(echo "$*")"
	fi
# Otherwise, if stdin is piped (ie, not terminal input), output stdin to cat which dumps to stdin by default
else
    MESSAGE="$(cat -)"
fi

# Actually send the data to Slack
curl -X POST -d "payload={\"text\": \"${MESSAGE}\"}" ${SLACK_URL}
