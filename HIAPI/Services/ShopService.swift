//
//  ShopService.swift
//  HIAPI
//
//  Created by HackIllinois on 12/19/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

public final class ShopService: BaseService {
    public override static var baseURL: String {
        return super.baseURL
    }

    public static func getAllItems() -> APIRequest<ItemContainer> {
        return APIRequest<ItemContainer>(service: self, endpoint: "shop/", headers: headers, method: .GET)
    }
}
