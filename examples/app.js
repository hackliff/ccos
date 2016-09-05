#!/usr/bin/env node

const yaml = require('js-yaml')

function config() {
  return new Promise((resolve) => {
    const stdin = process.stdin,
        inputChunks = []

    process.stdin.resume()
    process.stdin.setEncoding('utf8')

    process.stdin.on('data', (chunk) => inputChunks.push(chunk))

    process.stdin.on('end', () => {
      const data = yaml.safeLoad(inputChunks.join(""))
      resolve(data)
    })
  })
}

function main(conf) {
  console.log('like listening on %s:%d (%s))', conf.server.host,
                                               conf.server.port,
                                               conf.api_key)
}

config().then(main).catch(console.error)
