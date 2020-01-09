# SignalFx Smart Agent Heroku Buildpack

A Heroku buildpack to install and run the SignalFx Smart Agent on a Dyno.

## Installation

Adding and configuring the buildpack

```
# cd into the Heroku project directory

# Add Golang buildpack
heroku buildpacks:add heroku/go

# Add buildpack for SignalFx Agent
heroku buildpacks:add https://github.com/signalfx/heroku-signalfx-buildpack.git

# Setup SignalFx Access Token
heroku config:set SFX_TOKEN=<YOUR_SFX_ACCESS_TOKEN>

# If these buildpacks are being added to an existing project,
# create an empty commit prior to deploying the app
git commit --allow-empty -m "empty commit"

# Deploy your app
git push heroku master
```

## Configuration

Use the following environment variables to configure this buildpack

| Environment Variable | Description                                                                                      |
|----------------------|--------------------------------------------------------------------------------------------------|
| `SFX_TOKEN`          | (**required**) Your SignalFx access token                                                        |
| `SFX_AGENT_VERSION`  | (**required versions >= 4.18.0**) Version of the SignalFx Agent to be configured                 |
| `SFX_AGENT_LOG_DIR`  | Specify location of agent logs. If specified, logs will be written to `${SFX_AGENT_LOG_DIR}/log` |

**Note**: The [Heroku Metadata monitor](https://docs.signalfx.com/en/latest/integrations/agent/monitors/heroku-metadata.html)
is available starting SignalFx Agent v4.18.0.

**Configure Heroku App to expose Dyno metadata**

```
heroku labs:enable runtime-dyno-metadata
```

This metadata is required by the SignalFx Agent to set global dimensions such as `app_name`, `app_id` and `dyno_id`.

See [here](https://devcenter.heroku.com/articles/dyno-metadata) for more information.

**Overriding the default Agent config**

The default [SignalFx Agent config](./setup/config.yaml) will be overridden
if a config is provided in `/app/signalfx/agent.yaml`. In such cases, it is
recommended that the following defaults are retained.

```
# dimensionalizes metadata exposed in dynos
globalDimensions:
  dyno_id: {"#from": "env:HEROKU_DYNO_ID"}
  app_id: {"#from": "env:HEROKU_APP_ID"}
  app_name: {"#from": "env:HEROKU_APP_NAME"}

collectd:
  configDir: tmp/collectd

# syncs heroku metadata as properties to dyno_id dimension
monitors:
  - type: heroku-metadata
```
