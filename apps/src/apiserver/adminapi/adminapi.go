package adminapi

import (
	"json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

type AdminInfoResponse struct {
	Message string `json:"msg"`
}

func handlerInfoAPI(w http.ResponseWriter, req *http.Request) {
	data := AdminInfoResponse{
		Message: "admin value",
	}
	res, err := json.Marshal(data)
	log.Printf("response data: %v\n", data)

	w.Write(res)
}

// AdminServer runs for admin API
func AdminServer() {
	r := mux.NewRouter()

	r.HandleFunc("/admin/info", handlerInfoAPI).Methods("GET")

	log.Print("start admin API server")
	http.ListenAndServe(":9000", r)
}
