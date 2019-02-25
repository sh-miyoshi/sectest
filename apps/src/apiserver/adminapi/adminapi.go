package adminapi

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func handlerInfoAPI(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte("ok"))
}

// AdminServer runs for admin API
func AdminServer() {
	r := mux.NewRouter()

	r.HandleFunc("/admin/info", handlerInfoAPI).Methods("GET")

	log.Print("start admin API server")
	http.ListenAndServe(":9000", r)
}
