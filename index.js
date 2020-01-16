const http = require('http')
const redis = require('redis')
console.log('Connecting to redis', process.env.REDIS_URL)
const cache = redis.createClient(process.env.REDIS_URL)

http
  .createServer((req, res) => {
    console.log(`${new Date().toISOString()} [${req.method} ${req.url}]`)

    res.setHeader('X-Nomad-Alloc-ID', process.env.NOMAD_ALLOC_ID)
    res.setHeader('content-type', 'application/json')

    if (req.method === 'PUT') {
      let body = ''
      req.on('data', chunk => (body += chunk))
      req.on('end', () => {
        const reqBody = JSON.parse(body)
        const key = getKey(req.url)
        cache.set(key, reqBody.value)
        res.end(json({ok: true}))
      })
    }

    if (req.method === 'GET') {
      const key = getKey(req.url)
      cache.get(key, (err, reply) => {
        if (err) {
          console.error(err)
          res.end(json({error: `Error: ${err}`}))
          return
        }

        res.end(json({value: reply}))
      })
    }
  })
  .listen(process.env.PORT, () =>
    console.log(`Listening on port ${process.env.PORT}`)
  )

function getKey(path) {
  const parts = path.split('/')
  const key = parts[parts.length - 1]
  return key
}

function json(obj) {
  return JSON.stringify(obj, null, 4)
}
