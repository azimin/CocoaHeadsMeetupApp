//
//  Utils.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 1/28/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//

import Foundation

func rotateLeft(_ vv: UInt16, nn: UInt16) -> UInt16 {
  return ((vv << nn) & 0xFFFF) | (vv >> (16 - nn))
}

func rotateLeft(_ vv: UInt32, nn: UInt32) -> UInt32 {
  return ((vv << nn) & 0xFFFFFFFF) | (vv >> (32 - nn))
}

func rotateLeft(_ xx: UInt64, nn: UInt64) -> UInt64 {
  return (xx << nn) | (xx >> (64 - nn))
}

func rotateRight(_ xx: UInt16, nn: UInt16) -> UInt16 {
  return (xx >> nn) | (xx << (16 - nn))
}

func rotateRight(_ xx: UInt32, nn: UInt32) -> UInt32 {
  return (xx >> nn) | (xx << (32 - nn))
}

func rotateRight(_ xx: UInt64, nn: UInt64) -> UInt64 {
  return ((xx >> nn) | (xx << (64 - nn)))
}

func reverseBytes(_ value: UInt32) -> UInt32 {
  let tmp1 = ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8)
  let tmp2 = ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24)
  return tmp1 | tmp2
}
