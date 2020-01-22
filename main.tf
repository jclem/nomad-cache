provider "nomad" {
  address = "http://127.0.0.1:4646"
}

resource "nomad_job" "redis" {
  jobspec = file("${path.module}/config/redis.hcl")
}

resource "nomad_job" "cache" {
  depends_on = [nomad_job.redis]
  jobspec = file("${path.module}/config/cache.hcl")
}

resource "nomad_job" "nginx" {
  depends_on = [nomad_job.cache]
  jobspec = file("${path.module}/config/nginx.hcl")
}