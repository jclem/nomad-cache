job "nginx" {
  datacenters = ["dc1"]

  group "nginx" {
    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"

        port_map {
          http = 80
        }

        volumes = [
          "local:/etc/nginx/conf.d"
        ]
      }

      template {
        data = <<EOF
        upstream backend {
        {{ range service "cache" }}
          server {{ .Address }}:{{ .Port }};
        {{ else }}server 127.0.0.1:65535; # force a 502
        {{ end }}
        }

        server {
          listen 80;

          location / {
            proxy_pass http://backend;
          }
        }
        EOF

        destination   = "local/load-balancer.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      resources {
        network {
          port "http" {
            static = 8080
          }
        }
      }

      service {
        name = "nginx"
        port = "http"
      }
    }
  }
}
