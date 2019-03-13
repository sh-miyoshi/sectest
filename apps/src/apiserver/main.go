package main

import (
	"fmt"
	"log"
	"os"

	adminapi "github.com/sh-miyoshi/sectest/apiserver/adminapi"
	mysqlapi "github.com/sh-miyoshi/sectest/apiserver/mysqlapi"
)

func main() {
	if os.Getenv("MYSQL_ADDR") == "" {
		fmt.Println("Please set MYSQL_ADDR in environment")
		return
	}

	log.Print("start server")

	go adminapi.AdminServer()
	mysqlapi.MySQLServer()
}
