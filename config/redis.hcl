job "redis" {
  datacenters = ["dc1"]

  group "redis" {
    task "redis" {
      service {
        name         = "redis"
        address_mode = "driver"
        port         = "redis"

        check {
          name     = "alive"
          type     = "script"
          command  = "redis-cli"
          args     = ["ping"]
          interval = "10s"
          timeout  = "2s"
        }
      }

      driver = "docker"

      config {
        image = "redis:buster"

        port_map {
          redis = 6379
        }
      }

      resources {
        network {
          port "redis" {}
        }
      }
    }
  }
}
