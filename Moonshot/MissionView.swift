//
//  MissionView.swift
//  Moonshot
//
//  Created by Ross Parsons on 8/16/23.
//

import SwiftUI

struct MissionView: View {

    let mission: Mission
    let crew: [CrewMember]
    let astronauts: [String: Astronaut]
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.astronauts = astronauts
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role,
                                  astronaut: astronaut,
                                  commander: member.role == "Command Pilot" || member.role == "Commander")
            } else {
                fatalError("Missing \(member.name)")
            }
        }
        
        //1. look in [CrewRole] aka mission.crew for who has role == Commander
        //2. that step will give me name
        //3. I use that name to make a crew member who is the commander
        
    }
    
    var commander: CrewMember {
        var commanderName = String()
        var commanderRole = String()
        self.mission.crew.forEach { crewRole in
            if crewRole.role == "Command Pilot" || crewRole.role == "Commander" {
                commanderName = crewRole.name
                commanderRole = crewRole.role
            }
        }
        let commander = self.astronauts[commanderName]!
        return CrewMember(role: commanderRole , astronaut: commander, commander: true)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(crew, id: \.role) { crewMember in
                                NavigationLink {
                                    AstronautView(astronaut: crewMember.astronaut)
                                } label: {
                                    HStack {
                                        Image(crewMember.astronaut.id)
                                            .resizable()
                                            .frame(width: 104, height: 72)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(.white, lineWidth: 1)
                                            )
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(crewMember.astronaut.name)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                Image(systemName: "star.circle")
                                                    .foregroundColor(.yellow)
                                                    .hidden(!crewMember.commander)
                                            }
                                            Text(crewMember.role)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
        let commander: Bool
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
    
    func commanderNameStyle() -> some View {
        modifier(CommanderTitle())
    }
}

struct CommanderTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline.bold())
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}
