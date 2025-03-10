//
//  PubNubSpace.swift
//
//  PubNub Real-time Cloud-Hosted Push API and Push Notification Client Frameworks
//  Copyright © 2022 PubNub Inc.
//  https://www.pubnub.com/
//  https://www.pubnub.com/terms
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

import PubNub

/// A concrete representation of  a Space entity in PubNub
public struct PubNubSpace {
  /// The unique identifier of the Space
  public var id: String
  /// The name of the Space
  public var name: String?
  /// The classification of Space
  public var type: String?
  /// The current state of the Space
  public var status: String?
  /// Text describing the purpose of the Space
  public var spaceDescription: String?

  /// All custom fields set on the Space
  public var custom: FlatJSONCodable?

  /// The last updated timestamp for the Space
  public var updated: Date?
  /// The caching identifier for the Space
  public var eTag: String?

  public init(
    id: String,
    name: String? = nil,
    type: String? = nil,
    status: String? = nil,
    spaceDescription: String? = nil,
    custom: FlatJSONCodable? = nil,
    updated: Date? = nil,
    eTag: String? = nil
  ) {
    self.id = id
    self.name = name
    self.type = type
    self.status = status
    self.spaceDescription = spaceDescription
    self.custom = custom
    self.updated = updated
    self.eTag = eTag
  }
}

// MARK: Hashable

extension PubNubSpace: Hashable {
  public static func == (lhs: PubNubSpace, rhs: PubNubSpace) -> Bool {
    return lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.type == rhs.type &&
      lhs.status == rhs.status &&
      lhs.spaceDescription == rhs.spaceDescription &&
      lhs.custom?.codableValue == rhs.custom?.codableValue &&
      lhs.updated == rhs.updated &&
      lhs.eTag == rhs.eTag
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(type)
    hasher.combine(status)
    hasher.combine(spaceDescription)
    hasher.combine(custom?.codableValue)
    hasher.combine(updated)
    hasher.combine(eTag)
  }
}

// MARK: Codable

extension PubNubSpace: Codable {
  /// Coding Keys used to serialize a PubNubSpace from JSON
  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case type
    case status
    case spaceDescription = "description"
    case custom
    case updated
    case eTag
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)

    name = try container.decodeIfPresent(String.self, forKey: .name)
    type = try container.decodeIfPresent(String.self, forKey: .type)
    status = try container.decodeIfPresent(String.self, forKey: .status)
    spaceDescription = try container.decodeIfPresent(String.self, forKey: .spaceDescription)

    custom = try container.decodeIfPresent(FlatJSON.self, forKey: .custom)

    updated = try container.decodeIfPresent(Date.self, forKey: .updated)
    eTag = try container.decodeIfPresent(String.self, forKey: .eTag)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(type, forKey: .type)
    try container.encodeIfPresent(status, forKey: .status)
    try container.encodeIfPresent(spaceDescription, forKey: .spaceDescription)
    try container.encodeIfPresent(custom?.codableValue, forKey: .custom)
    try container.encodeIfPresent(updated, forKey: .updated)
    try container.encodeIfPresent(eTag, forKey: .eTag)
  }
}

// MARK: Object v2 Migration

public extension PubNubChannelMetadata {
  /// Converts Object V2 Channel Metadata to a Space entity
  ///
  /// - returns: The `PubNubSpace` built from the Object V2 data
  func convert() -> PubNubSpace {
    return PubNubSpace(
      id: metadataId,
      name: name,
      type: type,
      status: status,
      spaceDescription: channelDescription,
      custom: custom == nil ? nil : FlatJSON(flatJSON: custom),
      updated: updated,
      eTag: eTag
    )
  }
}
