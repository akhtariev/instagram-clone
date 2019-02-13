//
//  Constants.swift
//  instagram-clone
//
//  Created by Roman Akhtariev on 2019-02-12.
//  Copyright © 2019 Roman Akhtariev. All rights reserved.
//

import Firebase


// MARK: - Root References
let DB_REF = Database.database().reference()

// MARK: - Database References
let USER_REF = DB_REF.child("users")
