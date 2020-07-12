//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Quentin Eude on 30/06/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var currentScore = 0

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var showRedCross = [false, false, false]
    @State private var redCrossAnimationAmount: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color(red: 22/255, green: 22/255, blue: 22/255, opacity: 1.0)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }

                ForEach(0 ..< 3) { number in
                    Group {
                        if showRedCross[number] {
                            flag(for: number)
                                .overlay(
                                    Image(systemName: "xmark.square")
                                        .foregroundColor(.red)
                                        .font(.system(size: 60, weight: .bold, design: .default))
                                        .scaleEffect(redCrossAnimationAmount)
                                        .animation(
                                            Animation.easeOut(duration: 1)
                                                .repeatForever(autoreverses: true)
                                        )
                                )
                                .onAppear {
                                    self.redCrossAnimationAmount = 1.5
                                }
                        } else {
                            flag(for: number)
                        }
                    }
                }

                Text("Current score : \(currentScore)")
                    .foregroundColor(.white)

                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }

    func flag(for number: Int) -> some View {
        return Button(action: {
            self.flagTapped(number)
        }) {
            Image(self.countries[number])
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .shadow(color: Color(red: 60/255, green: 60/255, blue: 60/255, opacity: 1.0), radius: 3)
        }
        .rotation3DEffect(.degrees(number == self.correctAnswer ? self.rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
        .opacity(number != self.correctAnswer ? self.opacityAmount : 1.0)
    }

    func flagTapped(_ number: Int) {
        withAnimation {
            opacityAmount = 0.25
        }
        if number == correctAnswer {
            currentScore += 1
            scoreTitle = "Correct"
            scoreMessage = "Well done ! Your score is \(currentScore)"

            withAnimation {
                rotationAmount = 360
            }
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Wrong, That's the flag of \(countries[number])"

            withAnimation {
                showRedCross[number] = true
            }
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation {
            self.opacityAmount = 1.0
        }
        self.rotationAmount = 0
        showRedCross = [false, false, false]
        redCrossAnimationAmount = 1.0
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
