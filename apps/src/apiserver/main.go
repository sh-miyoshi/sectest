package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"database/sql"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"

	adminapi "github.com/sh-miyoshi/sectest/apiserver/adminapi"
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

func main() {
	if os.Getenv("MYSQL_ADDR") == "" {
		fmt.Println("Please set MYSQL_ADDR in environment")
		return
	}

	r := mux.NewRouter()
	r.HandleFunc("/api", handlerMySQLAPI).Methods("POST")

	log.Print("start server")

	go adminapi.AdminServer()
	http.ListenAndServe(":4567", r)
}
