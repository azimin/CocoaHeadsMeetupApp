//
//  InfoAboutEventStructure.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 24/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import CoreLocation

struct EventPO {
  var title = "Cocoa Heads"
  var startTime = Date(timeIntervalSince1970: 1491580800)
  var endTime = Date(timeIntervalSince1970: 1491595200)
  var location = CLLocation(latitude: 55.7784, longitude: 37.587802)
  var locationTitle = "Москва, штаб-квартира \"Авито\""
  var infoAboutEvent = "Очередная встреча CocoaHeads"
  var listOfSpeechs: [Speech] = [ .init(name: "Андрей Юткин",
                                        speechTheme: "Media Picker - to infinity and beyond"),
                                  .init(name: "Вадим Дробинин",
                                        speechTheme: "Защищаем себя и пользователей: руководство по безопасности"),
                                  .init(name: "Никита Кортунов",
                                        speechTheme:  "Как ускорить разработку приложений и есть ли жизнь после Parse")]
}

struct Speech {
  var name: String?
  var speechTheme: String?
}
