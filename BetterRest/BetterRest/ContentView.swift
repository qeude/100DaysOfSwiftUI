//
//  ContentView.swift
//  BetterRest
//
//  Created by Quentin Eude on 01/07/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .frame(height: 150)
                        .datePickerStyle(WheelDatePickerStyle())
                        .clipped()
                        .labelsHidden()
                }

                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }

                Section(header: Text("Daily coffee intake")) {
                    Picker("Number of people", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            if $0 == 1 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }
                    .frame(height: 100)
                    .pickerStyle(WheelPickerStyle())
                    .clipped()
                    .labelsHidden()
                }
                Section(header: Text("Your ideal bedtime is")) {
                    Text(calculateBedtime)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
            }
            .navigationTitle("BetterRest")
        }
    }

    var calculateBedtime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        let message: String
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            message = formatter.string(from: sleepTime)
        } catch {
            message = "Error calculating bedtime."
        }

        return message
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
