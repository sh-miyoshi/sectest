package mysqlapi

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"

	// use for mysql driver
	_ "github.com/go-sql-driver/mysql"
)

type mysqlData struct {
	ID     string `json:"id"`
	Secret string `json:"secret"`
}

type userInfo struct {
	User     string `json:"user"`
	Password string `json:"password"`
}

func handlerMySQLAPI(w http.ResponseWriter, req *http.Request) {
	var params userInfo
	if err := json.NewDecoder(req.Body).Decode(&params); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	user := params.User
	password := params.Password
	url := os.Getenv("MYSQL_ADDR")
	dbname := "secret"

	db, err := sql.Open("mysql", user+":"+password+"@tcp("+url+":3306)/"+dbname)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	rows, err := db.Query(`select id, secret from info`)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var data []mysqlData

	// get data per each line
	for rows.Next() {
		var d mysqlData
		err := rows.Scan(&(d.ID), &(d.Secret))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		data = append(data, d)
	}

	if err := rows.Err(); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	res, err := json.Marshal(data)
	log.Printf("response data: %v\n", data)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(res)
}

// MySQLServer runs for database API
func MySQLServer() {
	r := mux.NewRouter()

	r.HandleFunc("/api", handlerMySQLAPI).Methods("POST")

	log.Print("start MySQL API server")
	http.ListenAndServe(":4567", r)
}
