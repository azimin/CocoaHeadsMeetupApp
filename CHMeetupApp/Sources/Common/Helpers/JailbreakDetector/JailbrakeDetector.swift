//
//  JailbrakeDetector.swift
//  CHMeetupApp
//
//  Created by Mikhail Zaslavskiy on 10/27/17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

class JailbreakDetector {
  // Функция проверки на джейлбрейк
  // Можно проверять телефон на предмет установки джейла и отказывать в доступе
    func hasJailbreak() -> Bool {
    #if arch(i386) || arch(x86_64)
      println("Simulator")
      return false
    #else
      var fileManager = NSFileManager.defaultManager()
      if(fileManager.fileExistsAtPath("/private/var/lib/apt")) {
        println("Jailbroken Device")
        return true
      } else {
        println("Clean Device")
        return false
      }
    #endif
  }
}
