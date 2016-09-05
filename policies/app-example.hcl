path "secret/apps/global/*" {
  policy = "read"
}

path "secret/apps/example/*" {
  policy = "write"
}
