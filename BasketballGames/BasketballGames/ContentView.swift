//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable, Identifiable {
    var id: Int
    var team: String
    var score: GameScore
    var isHomeGame: Bool
    var opponent: String
    var date: String
}

struct GameScore: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()

    var body: some View {
        List(results) { result in
            HStack {
                VStack(alignment: .leading) {
                    Text("\(result.team) vs. \(result.opponent)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("\(result.score.unc) - \(result.score.opponent)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text(result.date)
                        .font(.callout)
                        .foregroundStyle(.primary)
                    Text(result.isHomeGame ? "Home" : "Away")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let decodedResponse = try JSONDecoder().decode([Result].self, from: data)
            await MainActor.run {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
