//
//  ContentView.swift
//  Bullseye
//
//  Created by Maxim on 07/10/2019.
//  Copyright © 2019 Maxim. All rights reserved.
//

import SwiftUI

struct ContentView: View
{
    
    @State var allertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
    
    struct LableSTyle: ViewModifier
    {
        func body(content: Content) -> some View
        {
           return content
            .foregroundColor(Color.white)
            .modifier(Shadow()  )
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ValueStyle: ViewModifier
    {
        func body(content: Content) -> some View
        {
           return content
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }
    
    struct Shadow: ViewModifier
    {
        func body(content: Content) -> some View
        {
           return content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    struct ButtonLargeTextStyle: ViewModifier
    {
        func body(content: Content) -> some View
        {
           return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ButtonSmallTextStyle: ViewModifier
    {
        func body(content: Content) -> some View
        {
           return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
        }
    }

    var body: some View
    {
            VStack //Target row
            {
                Spacer()
                HStack
                {
                    Text("Put the bullseye as close as you can to:").modifier(LableSTyle())
                    Text("\(self.target)").modifier(ValueStyle())
                }
                Spacer()
                //slider row
                HStack
                {
                    Text("1").modifier(LableSTyle())
                    Slider(value: self.$sliderValue, in: 1...100).accentColor(Color.green)
                    Text("100").modifier(LableSTyle())
                }
                Spacer()
                //button row
                    Button(action:
                    {
                        print(self.score)
                        self.allertIsVisible = true
                    })
                    {
                        Text("Hit me!")
                    }
                    .alert(isPresented: $allertIsVisible)
                    {
                        () -> Alert in
                        //let roundedValue = Int(sliderValue.rounded())
                        return Alert(title: Text(allertTitle()), message: Text("The slider value is \(sliderValueRounded()).\n" +
                            "You scored \(pointsForCurrentRound()) points this round"), dismissButton: .default(Text("Awesome!"))
                            {
                                self.score = self.score + self.pointsForCurrentRound()
                                self.target = Int.random(in: 1...100)
                                self.round = self.round + 1
                            })
                    }
                    .background(Image("Button")).modifier(ButtonLargeTextStyle())
                    Spacer()
                    //Bottom row
                    HStack
                    {
                    Button(action:
                    {
                        self.startANewGame()
                    })
                    {
                        HStack
                        {
                            Image("StartOverIcon").accentColor(midnightBlue)
                            Text("Start Over").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    Spacer()
                        Text("Score:").modifier(LableSTyle())
                        Text("\(score)").modifier(ValueStyle())
                    
                    Spacer()
                    
                        Text("Round:").modifier(LableSTyle())
                        Text("\(round)").modifier(ValueStyle())
                    Spacer()
                    NavigationLink(destination: AboutView())
                    {
                        HStack
                        {
                            Image("InfoIcon").accentColor(midnightBlue)
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }.background(Image("Button"))
            }
            .padding(.bottom, 20)
        }
            .background(Image("Background"), alignment: .center)
            .navigationBarTitle("Bullseye")
    }
    func sliderValueRounded() -> Int
    {
        Int(sliderValue.rounded())
    }
    func amountOff() -> Int
    {
        abs(target - sliderValueRounded())
    }
    func pointsForCurrentRound() -> Int
    {
        let maximumScore = 100
        let difference = amountOff()
        let bonus : Int
        if difference == 0
        {
            bonus = 100
        }
        else if difference == 1
        {
            bonus = 50
        }
        else
        {
            bonus = 0
        }
        return maximumScore - difference + bonus
    }
    func allertTitle() -> String
    {
        let difference = amountOff()
        let title: String
        if difference == 0
        {
            title = "Perfect! You got bonus 100 points!"
        }
        else if difference < 5
        {
            title = "You almost had it!"
        }
        else if difference <= 10
        {
            title = "Not bad!"
        }
        else
        {
            title = "Are you even trying?"
        }
        return title
    }
    func startANewGame()
    {
        self.score = 0
        self.round = 1
        self.target = Int.random(in: 1...100)
        self.sliderValue = 50.0
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
 }

