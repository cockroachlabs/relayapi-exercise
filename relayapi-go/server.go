package main

import "fmt"
import "net/http"

func hello(w http.ResponseWriter, req *http.Request) {
    fmt.Fprintf(w, "hello\n")
}

func main() {
    http.HandleFunc("/hello", hello)
		port := ":8000"
		fmt.Println("starting server on " + port)

    http.ListenAndServe(":8000", nil)
}