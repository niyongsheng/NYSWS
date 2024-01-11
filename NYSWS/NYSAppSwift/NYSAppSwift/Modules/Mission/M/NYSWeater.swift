//
//	NYSWeater.swift


import Foundation

struct NYSWeater : Codable {

	let aqi : NYSWeaterAqi?
	let city : String?
	let cityEn : String?
	let cityid : String?
	let country : String?
	let countryEn : String?
	let data : [NYSWeaterData]?
	let updateTime : String?


}