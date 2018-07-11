package test

import "fmt"
import "testing"

func TestHello(t *testing.T) {
	for i := 0; i < 3; i++ {
		fmt.Println("Hello, World!")
	}
}
