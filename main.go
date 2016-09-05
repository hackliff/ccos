package main

import (
	"os"
	"fmt"
	"path"
	"flag"
	"strings"
	"text/template"

	vault "github.com/hashicorp/vault/api"
)

var (
	templateMap = template.FuncMap{
		"Upper": func(s string) string {
			return strings.ToUpper(s)
		},

		"Secret": func(secretPath string, secretKey string) interface{} {
			// make sure VAULT_ADDR and VAULT_TOKEN is set
			config := vault.DefaultConfig()

			client, err := vault.NewClient(config)
			if err != nil {
				return err.Error()
			}

			secret, err := client.Logical().Read(secretPath)
			if err != nil {
				return err.Error()
			}

			return secret.Data[secretKey]
		},
	}
)

func main() {
	confFile := flag.String("template", "", "configuration template to parse")
	flag.Parse()

	t, err := template.New(path.Base(*confFile)).Funcs(templateMap).ParseFiles(*confFile)
	if err != nil {
		fmt.Printf("error loading configuration: %v\n", err)
		os.Exit(1)
	}

	// NOTE replace nil by a set of useful values ?
	if err = t.Execute(os.Stdout, nil); err != nil {
		fmt.Printf("error executing template: %v\n", err)
		os.Exit(1)
	}

}
