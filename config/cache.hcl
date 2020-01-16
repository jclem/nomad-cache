job "cache" {
  datacenters = ["dc1"]

  group "cache" {
    count = 8

    task "cache" {
      driver = "docker"

      service {
        name         = "cache"
        port         = "cache"
        address_mode = "driver"

        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      template {
        data = <<EOH
        REDIS_URL="{{range service "redis"}}redis://{{.Address}}:{{.Port}}{{end}}"
        EOH

        destination = "local/redis.conf"

        env = true
      }

      env {
        PORT = "8080"
      }

      config {
        image = "nomad-cache:v3"

        port_map {
          cache = 8080
        }
      }

      resources {
        network {
          port "cache" {}
        }
      }
    }
  }
}
