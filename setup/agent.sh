#!/bin/bash

if [ "$DYNOTYPE" == "run" ]; then
    exit 0
fi

export SFX_AGENT_CONFIG_DIR="$HOME/.signalfx/etc/signalfx-agent"
export SFX_AGENT_COLLECTD_CONFIG_DIR="$HOME/.signalfx/signalfx-agent/var/run/collectd"

export FALLBACK_AGENT_CONFIG="$SFX_AGENT_CONFIG_DIR/config.yaml"
export DEFAULT_APP_CONFIG="/app/signalfx/agent.yaml"

if [[ -f "$DEFAULT_APP_CONFIG" ]]; then
    export SFX_AGENT_CONFIG="${SFX_AGENT_CONFIG-$DEFAULT_APP_CONFIG}"
else
    # Can be overridden by an envvar
    export SFX_AGENT_CONFIG="${SFX_AGENT_CONFIG-$FALLBACK_AGENT_CONFIG}"
fi

export SIGNALFX_BUNDLE_DIR="$HOME/.signalfx/signalfx-agent"

mkdir -p "$SFX_AGENT_COLLECTD_CONFIG_DIR"

if [[ -z "$SFX_AGENT_LOG_FILE" ]]; then
    export SFX_AGENT_LOG_FILE=/dev/stdout
else
    mkdir -p $(dirname $SFX_AGENT_LOG_FILE)
fi


(cd $HOME/.signalfx/signalfx-agent/ && bin/patch-interpreter $HOME/.signalfx/signalfx-agent/)

$HOME/.signalfx/signalfx-agent/bin/signalfx-agent -config $SFX_AGENT_CONFIG > $SFX_AGENT_LOG_FILE 2>&1&
