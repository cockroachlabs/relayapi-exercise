This is the source code for the "Splonk" server for the exercise. This is not part of the candidate exercise, the source code is here as a reference.

# local testing (development)

`bundle exec functions-framework-ruby --source=splonk.rb --target=event`
`curl -i -X POST -H "Content-Type: application/json" -d @splonk-event.json http://localhost:8080`