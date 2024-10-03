//  AirtableService.swift
//  GKnow
//
//  Created by Catherine Chu on 10/2/24.
//

import Foundation

struct AirTableService {
    let apiKey = "pat21tabkcDu3jCzi.1a3edc80390b51ae038a1aa3963a2eef472fcd208591d615c8d4e69b6b3c8e4d"
    let baseId = "appUqouJ9CVWLO228"
    let tableName = "Patient"

    func addPatient(firstName: String, middleName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://api.airtable.com/v0/\(baseId)/\(tableName)"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let patientData: [String: Any] = [
            "fields": [
                "First Name": firstName,
                "Middle Name": middleName,
                "Last Name": lastName
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: patientData, options: [])
        } catch {
            print("Error serializing patient data: \(error)")
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error making network request: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                print("Failed to save patient. Status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                completion(false)
            }
        }
        
        task.resume()
    }
}
