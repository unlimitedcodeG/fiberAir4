package config

import (
	"log"
	"os"

	"gopkg.in/yaml.v2"
)


type Config struct {
	Server struct {
		Port init `yaml:port`
	} `yaml:"server"`

	Database struct {
		Host  string `yaml:"host"`
		Port  int `yaml:"port"`
		User  string `yaml:"user"`
		Passoword string `yaml:"passoword"`
		Name string `yaml:"name"`
	} `yaml:"database"`
}


var Cfg Config

func init(){
	data ,err =os.ReadFile("internal/config/config.yaml")
	if err !=nil{
		log.Fatalf("failed to read config:%v",err)
	}

	if err:=yaml.Unmarshal(data,&Cfg);err!=nil{
		log.Fatalf("failed to parse config: %v",err)
	}
}