package main

import (
	"encoding/json"
	"log"
	"net/http"

	"database/sql"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
)

type mysqlData struct {
	ID     string `json:"id"`
	Secret string `json:"secret"`
}

// type userInfo struct {
// 	user     string
// 	password string
// }

func handlerMySQLAPI(w http.ResponseWriter, req *http.Request) {
	user := "root"               // params[user]
	password := "ossj_sectest"   // params[password]
	url := "tcp(127.0.0.1:3306)" // ENV['MYSQL_ADDR']
	dbname := "secret"

	db, err := sql.Open("mysql", user+":"+password+"@"+url+"/"+dbname)
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

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/api", handlerMySQLAPI).Methods("POST")

	http.Handle("/", r)
	log.Print("start server")
	http.ListenAndServe(":8080", nil)
}
