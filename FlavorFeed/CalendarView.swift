//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct CalendarView: View {
    var user: User
    var body: some View {
        VStack {
            HStack {
                Text("My Feed")
                    .font(.title2)
                    .padding()
                Spacer()
                Image(systemName: "person.2.fill")
                    .padding()
            }

        }
    }
}
