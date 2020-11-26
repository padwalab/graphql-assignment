## GraphQL assignment

Start the graphql server by: go run ./server.go

graphql playground can be accessed at: localhost:8080

sample query:

query {
links {
title
address
user {
name
}
}
}
