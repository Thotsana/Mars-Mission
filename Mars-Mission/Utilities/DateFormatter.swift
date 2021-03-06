//
//  DateFormatter.swift
//  Mars-Mission
//
//  Created by Thotsana Mabotsa on 2020/11/23.
//

import Foundation

func convertUTCDateToLocalDate(date:String) -> String {

	let format = DateFormatter()

	format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

	let convertedDate = format.date(from: date)

	format.timeZone =  TimeZone(abbreviation: "GMT+2:00")

	format.dateFormat = "E, d MMM yyyy"

	return format.string(from: convertedDate ?? Date())

}
