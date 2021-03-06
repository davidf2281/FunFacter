
// FunFacter: The worst-coded thing possible

import SwiftUI

let names = ["Albert", "Bernard", "Claire", "Albert", "Bernard", "Claire", "Albert", "Bernard", "Claire", "Albert", "Bernard", "Claire"]

struct CrewMember: Identifiable { var selected = false; let textView: Text; let id = UUID() }
@main struct FunFacter: App {
    @State var railCrew = names.map { CrewMember(textView: Text($0)) }
    @State var spinClicked = false
    @State var done = false
    @State var randomIndex: Int = 0
    let radius: CGFloat = 250
    var body: some Scene { WindowGroup {
        let increment: Double = 360 / (Double(railCrew.count) + 1)
        ZStack {
            Color(white: 0.4)
            Circle().fill(Color.white)
                .frame(width: radius * 2, height: radius * 2, alignment: .center).shadow(radius: 6, y: 4)
            ZStack {
                Button(action: {
                    randomIndex = Int.random(in: 0 ..< railCrew.count)
                    spinClicked.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        railCrew[(railCrew.count - 1) - randomIndex].selected = true; done = true
                    }}, label: { Text("Spin it!") .font(.system(size:30)).padding(20.0) .foregroundColor(Color.white).contentShape(Rectangle())
                }).background(Color.orange) .cornerRadius(50).buttonStyle(PlainButtonStyle()).animation(.none) .disabled(spinClicked)
                    .frame(width: radius * 5/4, height: radius * 5/4, alignment: .center)
                Text("🚂").font(.system(size:40)).transformEffect(.init(translationX: 0, y: radius * -4/5)).opacity(done ? 0 : 1).animation(.none)

                ForEach(Array(railCrew.enumerated()), id: \.element.id) { index, element in
                    let selected = element.selected
                    element.textView
                        .font(.system(size: 50, weight: .medium, design: Font.Design.default))
                        .scaleEffect(selected ? 1.1 : 0.6)
                        .animation(selected ? .interpolatingSpring(mass: 0.005, stiffness: 3, damping: 0.04, initialVelocity: 0) : .none)
                        .rotationEffect(Angle(degrees: selected ? 0 : 90))
                        .transformEffect(.init(translationX: 0, y: selected ? radius * -4/6 : radius * -4/6))
                        .rotationEffect(Angle(degrees: Double(index + 1) * increment))
                        .foregroundColor(selected ? Color.orange : done ? Color(white:0.98) : Color(white:0.3))
                        .animation(.easeIn(duration:0.25))
                        .shadow(radius: selected ? 1 : 0)
                        .animation(.none)
                        .zIndex(selected ? 1 : 0)
                }
            }
            .rotationEffect(Angle(degrees: spinClicked ? 1800 + (increment * Double(randomIndex + 1)) : 0))
            .animation(spinClicked ? Animation.interpolatingSpring(mass: 3.4, stiffness: 6.0, damping: 8.52, initialVelocity: 0.05) : .none)
            Text("👇").font(.system(size:80)).offset(x: -12, y: -radius*1.05)
        }.frame(width: radius * 2 + 120, height: radius * 2 + 120, alignment: .center)
    }}
}
