# SignalFx Smart Agent Heroku Buildpack

A Heroku buildpack to install and run the SignalFx Smart Agent on a Dyno.

**Note**: The [Heroku Metadata monitor](https://docs.signalfx.com/en/latest/integrations/agent/monitors/heroku-metadata.html)
is available starting SignalFx Agent v4.18.0.

## Installation

Adding and configuring the buildpack

```
# cd into the Heroku project directory

# Add buildpack for SignalFx Agent
heroku buildpacks:add https://github.com/signalfx/heroku-signalfx-buildpack.git#<BUILDPACK_VERSION>

# Setup required environment variables
# Note: More variables, such as SFX_REALM, may be required
heroku config:set SFX_AGENT_VERSION=<DESIRED_AGENT_VERSION>
heroku config:set SFX_REALM=<YOUR_REALM>
heroku config:set SFX_TOKEN=<YOUR_SFX_ACCESS_TOKEN>

# If these buildpacks are being added to an existing project,
# create an empty commit prior to deploying the app
git commit --allow-empty -m "empty commit"

# Deploy your app
git push heroku master
```

**Note**: Specify the version tag of the buildpack when adding it to the project.

## Configuration

Use the following environment variables to configure this buildpack

| Environment Variable   | Required | Default                                          | Description                                                                                        |
| ---------------------- | -------- | -------                                          | -------------------------------------------------------------------------------------------------- |
| `SFX_AGENT_API_URL`    | No       | `https://api.SFX_REALM.signalfx.com`             | The SignalFx API base URL.                                                                         |
| `SFX_AGENT_INGEST_URL` | No       | `https://ingest.SFX_REALM.signalfx.com`          | The SignalFx Infrastructure Monitoring base URL.                                                   |
| `SFX_AGENT_TRACE_URL`  | No       | `https://ingest.SFX_REALM.signalfx.com/v2/trace` | The SignalFx APM base URL.                                                                         |
| `SFX_AGENT_LOG_FILE`   | No       |                                                  | Specify location of agent logs. If not specified, logs will go to stdout                           |
| `SFX_AGENT_VERSION`    | Yes      |                                                  | Version of the SignalFx Agent to be configured                                                     |
| `SFX_REALM`            | No       | `us0`                                            | Your SignalFx realm                                                                                |
| `SFX_TOKEN`            | Yes      |                                                  | Your SignalFx access token                                                                         |

For more information about configuring the SignalFx Agent see the [config schema documentation](https://docs.signalfx.com/en/latest/integrations/agent/config-schema.html).
### Configure Heroku App to expose Dyno metadata

```
heroku labs:enable runtime-dyno-metadata
```

This metadata is required by the SignalFx Agent to set global dimensions such as `app_name`, `app_id` and `dyno_id`.

See [here](https://devcenter.heroku.com/articles/dyno-metadata) for more information.

### Overriding the default Agent config

The default [SignalFx Agent config](./setup/config.yaml) will be overridden if a config is provided in `signalfx/agent.yaml`
in the root of the Heroku project directory. In such cases, it is recommended
that the [default configuration options](setup/config.yaml) are retained.
