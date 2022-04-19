package main

import (
	"log"

	"github.com/speaq-app/speaq/cmd"
)

func main() {
	if err := cmd.Execute(); err != nil {
		log.Println(err)
	}
}
