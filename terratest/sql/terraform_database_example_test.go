package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHttpExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../database",

		// Variables to pass to our Terraform code using -var options
		// Vars: map[string]interface{}{},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Setting database configuration, including server name, user name, password and database name
	var dbConfig DBConfig
	dbConfig.server = terraform.Output(t, terraformOptions, "sql_server_fqdn")
	dbConfig.user = terraform.Output(t, terraformOptions, "sql_admin_username")
	dbConfig.password = terraform.Output(t, terraformOptions, "sql_password")
	dbConfig.database = terraform.Output(t, terraformOptions, "database_name")

	// It can take a minute or so for the database to boot up, so retry a few times
	maxRetries := 15
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Executing commands on database %s", dbConfig.server)

	// Verify that we can connect to the database and run SQL commands
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		// Connect to specific database, i.e. Microsoft SQL Database
		db, err := dbConnectionE(t, "mssql", dbConfig)
		if err != nil {
			return "", err
		}

		// Create a table
		creation := "create table person (id integer, name varchar(30), primary key (id))"
		dbExecution(t, db, creation)

		// Insert a row
		expectedID := 12345
		expectedName := "azure"
		insertion := fmt.Sprintf("insert into person values (%d, '%s')", expectedID, expectedName)
		dbExecution(t, db, insertion)

		// Query the table and check the output
		query := "select name from person"
		dbQueryWithValidation(t, db, query, "azure")

		// Drop the table
		drop := "drop table person"
		dbExecution(t, db, drop)
		fmt.Println("Executed SQL commands correctly")

		defer db.Close()

		return "", nil
	})
}
