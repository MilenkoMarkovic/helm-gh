package main
 
import (
	"log"
	"net/http"
	"os"
)
 
var ver string
 
func main() {
	rtr := http.DefaultServeMux
	rtr.HandleFunc("/", home{}.handle)
 
	addr := os.Getenv("HTTP_ADDR")
 
	log.Printf("%s: info: http listen and serve: %s", ver, addr)
	if err := http.ListenAndServe(addr, rtr); err != nil && err != http.ErrServerClosed {
		log.Printf("%s: error: http listen and serve: %s", ver, err)
	}
}
 
type home struct{}
 
func (h home) handle(w http.ResponseWriter, r *http.Request) {
	log.Printf("%s: info: X-Request-ID: %s\n", ver, r.Header.Get("X-Request-ID"))
	_, _ = w.Write([]byte(ver))
}
