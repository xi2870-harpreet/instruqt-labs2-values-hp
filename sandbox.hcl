variable "app_name" {
  default     = "bench-app"
  description = "Name the generated config is built around"
}

variable "listen_port" {
  default     = "8080"
  description = "Port written into the generated config"
}

resource "network" "main" {
  subnet = "10.0.230.0/24"
}

# --- Random generators: all five types --------------------------------------

resource "random_password" "db" {
  length      = 24
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

resource "random_id" "build" {
  byte_length = 8
}

resource "random_uuid" "session" {}

resource "random_number" "replicas" {
  minimum = 2
  maximum = 9
}

resource "random_creature" "codename" {}

# --- The container the values land in ---------------------------------------

resource "container" "app" {
  image {
    name = "alpine:3.20"
  }

  # Startup-ordering guard: containers run ~1.6s before the network attaches.
  entrypoint = ["/bin/sh", "-c"]
  command    = ["until hostname -i >/dev/null 2>&1; do sleep 0.2; done; exec sleep infinity"]

  environment = {
    APP_NAME    = variable.app_name
    DB_PASSWORD = resource.random_password.db.value
    BUILD_ID    = resource.random_id.build.hex
    SESSION_ID  = resource.random_uuid.session.value
    REPLICAS    = resource.random_number.replicas.value
    CODENAME    = resource.random_creature.codename.value
  }

  resources {
    cpu    = 1000
    memory = 512
  }

  network {
    id      = resource.network.main.meta.id
    aliases = ["app"]
  }
}

# --- Template: generate a config from the values above -----------------------
# Open question this lab answers: `template` takes no target, so where does the
# file land, and is it visible inside a container?

resource "template" "app_config" {
  source = <<-EOF
    # generated for {{app_name}} ({{codename}})
    listen        = {{port}}
    replicas      = {{replicas}}
    build_id      = {{build_id}}
    session_id    = {{session_id}}
    db_password   = {{db_password}}
  EOF

  destination = "/tmp/generated/app.conf"

  variables = {
    app_name    = variable.app_name
    port        = variable.listen_port
    codename    = resource.random_creature.codename.value
    replicas    = resource.random_number.replicas.value
    build_id    = resource.random_id.build.hex
    session_id  = resource.random_uuid.session.value
    db_password = resource.random_password.db.value
  }
}

output "codename" {
  value = resource.random_creature.codename.value
}

output "build_id" {
  value = resource.random_id.build.hex
}
