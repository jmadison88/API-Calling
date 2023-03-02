//
//  ContentView.swift
//  API Calling
//
//  Created by Josh Madison on 2/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var entries = [Entry]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(entries) { entry in
                VStack(alignment: .leading) {
                    Link(destination: URL(string: entry.image)!) {
                        Text(entry.name).font(.title3)
                    }
                    Text(entry.description).fontWeight(.light)
                    Text(entry.cooking_effect).fontWeight(.heavy)
                }
            }
            .navigationTitle("Hyrule Creatures (No Drops)")
        }
        .task {
            await getData()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"),
            message: Text("There was a problem loading the Hyrule Creatures"),
                  dismissButton: .default(Text("OK")))
        }
    }
    func getData() async {
        let query = "https://botw-compendium.herokuapp.com/api/v2/category/creatures"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Data.self, from: data) {
                    entries = decodedResponse.data.food
                    return
                }
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Entry: Identifiable, Codable {
    var id = UUID()
    var cooking_effect: String
    var description: String
    var image: String
    var name: String
    
    private enum CodingKeys : String, CodingKey {
        case cooking_effect
        case description
        case image
        case name
    }
}

struct Data: Codable {
    var data: Food
}

struct Food: Codable {
    var food: [Entry]
}
