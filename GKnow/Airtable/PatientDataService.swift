//
//  PatientDataService.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import Foundation
import Combine

class PatientDataService: ObservableObject {
    @Published var patients: [PatientInformation] = []

    let apiKey = "pat21tabkcDu3jCzi.1a3edc80390b51ae038a1aa3963a2eef472fcd208591d615c8d4e69b6b3c8e4d"
    let baseId = "appUqouJ9CVWLO228"
    let tableName = "Patient"

    func fetchPatients() {
        print("Fetching data in patientdataservice...")
        guard let url = URL(string: "https://api.airtable.com/v0/\(baseId)/\(tableName)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching patients: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Print the raw JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }

            // Create a DateFormatter to handle the dob field
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"  // Define your date format here

            // Configure the JSONDecoder to use the custom DateFormatter
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let result = try decoder.decode(AirtableResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.patients = result.records
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}

// Wrapper struct for decoding the Airtable response
struct AirtableResponse: Codable {
    var records: [PatientInformation]
}
