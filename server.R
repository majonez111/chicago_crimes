#server
function(input, output, session) {
  
  chicago_crimes <- callModule(chicago_crimes_server, "chicago_crimes1")

}

