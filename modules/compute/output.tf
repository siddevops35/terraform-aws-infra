output "public_server" {
  value = aws_instance.public-server.*.id
}