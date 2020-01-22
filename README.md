# Install Dependencies

1. Docker `brew cask install docker`
1. Consul `brew install consul`
1. Nomad `brew install nomad`
1. [Optional] Terraform `brew install terraform`

# Use

*Note that by default, these configuration files open a port dynamically on the host for Redis inspection, and `8080` for the service itself. You'll want to ensure no other services have these ports open (or change these configuration files).*

1. Build the Docker image: `docker build -t nomad-cache:v3 .` (the `cache.hcl` assumes this is the container name—**do not** use a `latest` tag, because Consul will always want to pull from a container registry)
1. Start Redis: `nomad run config/redis.hcl`
1. Start cache: `nomad run config/cache.hcl`
1. Start Nginx: `nomad run config/nginx.hcl`

## Terraform

If you want to start the services in a simpler manner, you can use local Terraform.

1. Build the Docker image as described above.
1. Install Terraform plugins: `terraform init`
1. Apply the Terraform config: `terraform apply`

Now you can GET `http://localhost:8080/${key}` and PUT `http://localhost:8080/${key}` with a `{"value":$value}` JSON body. Notice responses have `X-Nomad-Alloc-ID`, showing you that requests are load balanced by Nginx across different Cache instances.
