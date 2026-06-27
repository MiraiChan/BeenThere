//
//  Experience.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//
import Foundation

enum ShowStatus { //ExperienceStatus
  case attended
  case upcoming
}

struct Show: Identifiable {
  var artistName: String
  var venueName: String
  var city: String
  var date: Date
  var status: ShowStatus
  
  let id = UUID()
}

