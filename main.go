package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"reflect"
	"strings"

	"gopkg.in/yaml.v2"
)

const (
	values     = "VALUES"
	valuesFile = "VALUES_FILE"
)

func assert(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func replace(key string, value string, v interface{}) {
	keys := strings.Split(key, ".")
	for i, k := range keys {
		m, ok := v.(*map[interface{}]interface{})
		if !ok {
			assert(fmt.Errorf("%s: %v is not map", k, reflect.TypeOf(v)))
		}

		field, ok := (*m)[k]
		if !ok {
			assert(fmt.Errorf("%s not found", k))
		}

		if i+1 != len(keys) {
			m, ok := field.(map[interface{}]interface{})
			if !ok {
				assert(fmt.Errorf("value of %s: %v is not map", k, reflect.TypeOf(field)))
			}
			v = &m
			continue
		}

		log.Printf("replace %v with %s", field, value)

		(*m)[k] = value
	}
}

func main() {
	xs := os.Getenv(values)
	file := os.Getenv(valuesFile)
	log.Println("values = ", xs, "file = ", file)

	bytes, err := ioutil.ReadFile(file)
	assert(err)

	root := make(map[interface{}]interface{})
	assert(yaml.Unmarshal(bytes, &root))

	for _, x := range strings.Split(xs, ",") {
		kv := strings.Split(x, "=")
		if len(kv) != 2 {
			assert(fmt.Errorf("%s is not key value", x))
		}
		replace(kv[0], kv[1], &root)
	}

	bytes, err = yaml.Marshal(&root)
	assert(err)

	assert(ioutil.WriteFile(file, bytes, 0644))
}
