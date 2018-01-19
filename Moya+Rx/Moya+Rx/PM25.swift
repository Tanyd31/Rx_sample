//
//  PM25.swift
//
//  Created by tanyadong on 18/01/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class PM25: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let aqi = "aqi"
    static let stationCode = "station_code"
    static let primaryPollutant = "primary_pollutant"
    static let positionName = "position_name"
    static let quality = "quality"
    static let pm25 = "pm2_5"
    static let timePoint = "time_point"
    static let area = "area"
    static let pm2524h = "pm2_5_24h"
  }

  // MARK: Properties
  public var aqi: Int?
  public var stationCode: String?
  public var primaryPollutant: String?
  public var positionName: String?
  public var quality: String?
  public var pm25: Int?
  public var timePoint: String?
  public var area: String?
  public var pm2524h: Int?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map){

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    aqi <- map[SerializationKeys.aqi]
    stationCode <- map[SerializationKeys.stationCode]
    primaryPollutant <- map[SerializationKeys.primaryPollutant]
    positionName <- map[SerializationKeys.positionName]
    quality <- map[SerializationKeys.quality]
    pm25 <- map[SerializationKeys.pm25]
    timePoint <- map[SerializationKeys.timePoint]
    area <- map[SerializationKeys.area]
    pm2524h <- map[SerializationKeys.pm2524h]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = aqi { dictionary[SerializationKeys.aqi] = value }
    if let value = stationCode { dictionary[SerializationKeys.stationCode] = value }
    if let value = primaryPollutant { dictionary[SerializationKeys.primaryPollutant] = value }
    if let value = positionName { dictionary[SerializationKeys.positionName] = value }
    if let value = quality { dictionary[SerializationKeys.quality] = value }
    if let value = pm25 { dictionary[SerializationKeys.pm25] = value }
    if let value = timePoint { dictionary[SerializationKeys.timePoint] = value }
    if let value = area { dictionary[SerializationKeys.area] = value }
    if let value = pm2524h { dictionary[SerializationKeys.pm2524h] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.aqi = aDecoder.decodeObject(forKey: SerializationKeys.aqi) as? Int
    self.stationCode = aDecoder.decodeObject(forKey: SerializationKeys.stationCode) as? String
    self.primaryPollutant = aDecoder.decodeObject(forKey: SerializationKeys.primaryPollutant) as? String
    self.positionName = aDecoder.decodeObject(forKey: SerializationKeys.positionName) as? String
    self.quality = aDecoder.decodeObject(forKey: SerializationKeys.quality) as? String
    self.pm25 = aDecoder.decodeObject(forKey: SerializationKeys.pm25) as? Int
    self.timePoint = aDecoder.decodeObject(forKey: SerializationKeys.timePoint) as? String
    self.area = aDecoder.decodeObject(forKey: SerializationKeys.area) as? String
    self.pm2524h = aDecoder.decodeObject(forKey: SerializationKeys.pm2524h) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(aqi, forKey: SerializationKeys.aqi)
    aCoder.encode(stationCode, forKey: SerializationKeys.stationCode)
    aCoder.encode(primaryPollutant, forKey: SerializationKeys.primaryPollutant)
    aCoder.encode(positionName, forKey: SerializationKeys.positionName)
    aCoder.encode(quality, forKey: SerializationKeys.quality)
    aCoder.encode(pm25, forKey: SerializationKeys.pm25)
    aCoder.encode(timePoint, forKey: SerializationKeys.timePoint)
    aCoder.encode(area, forKey: SerializationKeys.area)
    aCoder.encode(pm2524h, forKey: SerializationKeys.pm2524h)
  }

}
