// Pckage comment
package main

import (
	"fmt"
	"net/http"

	"github.com/google/uuid"
)

func err(err error) {
	if err != nil {
		panic(err)
	}
}

func hello(w http.ResponseWriter, _ *http.Request) {
	_, e := fmt.Fprintf(w, "hello\n%s\n", uuid.New())
	err(e)
}

func headers(w http.ResponseWriter, req *http.Request) {
	for name, headers := range req.Header {
		for _, h := range headers {
			_, e := fmt.Fprintf(w, "%v: %v\n", name, h)
			err(e)
		}
	}
}

func main() {
	http.HandleFunc("/hello", hello)
	http.HandleFunc("/headers", headers)

	err(http.ListenAndServe(":8090", nil)) //nolint:gosec
}
