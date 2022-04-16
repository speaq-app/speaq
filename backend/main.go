package main

import (
	"log"

	"github.com/speak-app/speak/cmd"
)

func main() {
	if err := cmd.Execute(); err != nil {
		log.Println(err)
	}
}
