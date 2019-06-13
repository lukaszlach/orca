package main

import (
	"fmt"
	"os"
	"strconv"
	"io/ioutil"
	"net/http"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)

const DbPassword = "orc4"
const OutputLog = "/tmp/orca.log"
const ErrorLog = "/tmp/orca-error.log"

var recordsCount = 0

func fileLog(line string, path string) error {
	_, err := os.Readlink(path)
	if err != nil {
		f, err := os.OpenFile(path, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
		if err != nil {
			return err
		}
		defer f.Close()
		if _, err = f.WriteString(line); err != nil {
			return err
		}
		return nil
	}
	fmt.Println(line)
	return nil
}

func main() {
    if os.Args[1] == "version" {
        fmt.Println("Orca 1.0")
        os.Exit(0)
        return
    }
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// log the request
		fileLog(r.Method+" /", OutputLog)
		// cache the response output (mock)
		os.MkdirAll("/tmp/orca", 0777);
		file, err := ioutil.TempFile("/tmp/orca", "orca")
		if err != nil {
			//panic(err)
		} else {
			bigBuff := make([]byte, 1000*1000)
			ioutil.WriteFile(file.Name(), bigBuff, 0666)
		}
		// include server hostname in the Server response header
		host, _ := os.Hostname()
		w.Header().Set("Server", "orca (running on "+host+")")
		if r.Method == "GET" {
			w.Header().Set("Content-Type", "application/json")
			fmt.Fprint(w, "{\"count\":"+strconv.Itoa(recordsCount)+"}")
		} else {
			// exit when no MySQL connection details are available
			if os.Getenv("ORCA_MYSQL") == "" {
				w.WriteHeader(http.StatusInternalServerError)
				os.Exit(7)
				return
			}
			// connect to MySQL server
			db, err := sql.Open("mysql", "root:"+DbPassword+"@tcp("+os.Getenv("ORCA_MYSQL")+")/")
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				os.Exit(7)
				return
			}
			// store the record in MySQL (mock)
			_, err = db.Query("SELECT 1")
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				os.Exit(7)
				return
			}
			recordsCount++
			w.Header().Set("Content-Type", "application/json")
			fmt.Fprint(w, "{\"count\":"+strconv.Itoa(recordsCount)+"}")
		}
	})
	fmt.Println("Orca | HTTP server listening on :8080")
	// create output and error log files
	fileLog("Notice: Orca log created", OutputLog)
	fileLog("Notice: Orca error log created", ErrorLog)
	// trigger a warning when no MySQL connection details are available
	if os.Getenv("ORCA_MYSQL") == "" {
		fileLog("Warning: Failed to connect to MySQL (ORCA_MYSQL empty or not set)", OutputLog)
	} else
	if _, err := os.Stat("/etc/orca.conf"); os.IsNotExist(err) {
		fileLog("Warning: /etc/orca.conf not found, set the \"orca_cache\" setting to enable local caching", OutputLog)
	}
	// run HTTP server loop
	http.ListenAndServe(":8080", nil)
}