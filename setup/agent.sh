#!/bin/bash

if [ "$DYNOTYPE" == "run" ]; then
    exit 0
fi

export SFX_AGENT_CONFIG_DIR="$HOME/.signalfx/etc/signalfx-agent"
export SFX_AGENT_COLLECTD_CONFIG_DIR="$HOME/.signalfx/signalfx-agent/var/run/collectd"
export SFX_AGENT_LOG_DIR="$HOME/.signalfx/signalfx-agent/var/log"
export SFX_AGENT_LOG="$SFX_AGENT_LOG_DIR/agent"

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
mkdir -p "$SFX_AGENT_LOG_DIR"

(cd $HOME/.signalfx/signalfx-agent/ && bin/patch-interpreter $HOME/.signalfx/signalfx-agent/)

$HOME/.signalfx/signalfx-agent/bin/signalfx-agent -config $SFX_AGENT_CONFIG &
