# Use

1. Build the Docker image: `docker build -t nomad-cache:v3 .` (the `cache.hcl` assumes this is the container name—**do not** use a `latest` tag, because Consul will always want to pull from a container registry)
1. Start Redis: `nomad run config/redis.hcl`
1. Start cache: `nomad run config/cache.hcl`
1. Start Nginx: `nomad run config/ngins.hcl`

Now you can GET `http://localhost:8080/${key}` and PUT `http://localhost:8080/${key}` with a `{"value":$value}` JSON body. Notice responses have `X-Nomad-Alloc-ID`, showing you that requests are load balanced by Nginx across different Cache instances.
