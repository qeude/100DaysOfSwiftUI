//
//  ContentView.swift
//  TemperatureConverter
//
//  Created by Quentin Eude on 29/06/2020.
//

import SwiftUI

struct ContentView: View {
    @State var inputTemperature = ""
    @State var inputUnit = UnitTemperature.fahrenheit
    @State var outputUnit = UnitTemperature.celsius

    let possibleUnitTemperature: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]
    let measurementFormatter: MeasurementFormatter

    var result: Measurement<UnitTemperature>? {
        guard let inputTemperatureDouble = Double(inputTemperature) else {
            return nil
        }

        return Measurement(value: inputTemperatureDouble, unit: inputUnit).converted(to: outputUnit)
    }

    init() {
        measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Temperature to convert", text: $inputTemperature)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Input temperature unit")) {
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(possibleUnitTemperature, id: \.self) { unitTemp in
                            Text("\(measurementFormatter.string(from: unitTemp))")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Output temperature unit")) {
                    Picker("Output unit", selection: $outputUnit) {
                        ForEach(possibleUnitTemperature, id: \.self) { unitTemp in
                            Text("\(measurementFormatter.string(from: unitTemp))")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Result")) {
                    if let result = result?.value {
                        Text("\(result, specifier: "%.2f")")
                    }
                }
            }
        }.navigationTitle("TempConverter")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
