extends Node

#https://docs.google.com/spreadsheets/d/1uGReGSIEg6rlhsUVrICd9MKuTRuMXobt_eQC-ADY5WM/edit#gid=1065129135

const SPREADSHEETS: Array = [
	["res://src/resources/localization/auto_download_localization/test_folder/test.json",                        # File to write and read.
	"1uGReGSIEg6rlhsUVrICd9MKuTRuMXobt_eQC-ADY5WM",  # SpreadSheetID.
	"Base"],                                      # Sheet name.
]
const API_KEY: String = "YOUR GOOGLE API KEY"

const GSheet = preload("res://src/resources/localization/auto_download_localization/gsheet.gd")
const GVersion = preload("res://src/resources/localization/auto_download_localization/gversion.gd")
const GConfig = preload("res://src/resources/localization/auto_download_localization/config.gd")

var host = GConfig.Host.new(API_KEY)
var gsheet : GSheet = GSheet.new(SPREADSHEETS, host)
var datas: Dictionary = {}

func _ready():
  gsheet.allset.connect(_on_allset)
  gsheet.complete.connect(_on_complete)
  gsheet.start([GSheet.JOB.DOWNLOAD])
  
func _on_complete(path_name: String, data: Dictionary):
  datas[path_name] = data
  
func _on_allset():
  print(datas)
