#!/bin/bash

export SFX_AGENT_CONFIG_DIR="$HOME/.signalfx/etc/signalfx-agent"
export SFX_AGENT_CONFIG="$SFX_AGENT_CONFIG_DIR/config.yaml"
export SFX_AGENT_COLLECTD_CONFIG_DIR="$HOME/.signalfx/signalfx-agent/var/run/collectd"
export SFX_AGENT_LOG_DIR="$HOME/.signalfx/signalfx-agent/var/log"
export SFX_AGENT_LOG="$SFX_AGENT_LOG_DIR/agent"

mkdir -p "$SFX_AGENT_COLLECTD_CONFIG_DIR"
mkdir -p "$SFX_AGENT_LOG_DIR"

(cd $HOME/.signalfx/signalfx-agent/ && bin/patch-interpreter $HOME/.signalfx/signalfx-agent/)

if [[ -z "${SFX_REALM}" ]]; then
  echo "SFX_REALM environment variable is not set. Defaulting to US0."
else
  echo "SFX_REALM environment variable set to ${SFX_REALM}"
  export SFX_AGENT_INGEST_URL="https://ingest.$SFX_REALM.signalfx.com"
  export SFX_AGENT_API_URL="https://api.$SFX_REALM.signalfx.com"
fi

$HOME/.signalfx/signalfx-agent/bin/signalfx-agent -config $SFX_AGENT_CONFIG &
