//
//  ContentView.swift
//  tagtime
//
//  Created by Alexander Schell on 3/12/23.
//
    
import SwiftUI

struct ContentView: View {
    var ts: String?
    @State var visiblePings = [Ping]()
    @ObservedObject var observer = Observer()

    
    var body: some View {
        NavigationView {
            List(visiblePings, id: \.title) { ping in
                NavigationLink(destination: DetailView(ping: self.$visiblePings[getIndex(for: ping, in: visiblePings)])) {
                    HStack {
                        VStack {
                            Text(parseTS(ping.title).components(separatedBy: " ")[0])
                                .font(.footnote)
                            Text(parseTS(ping.title).components(separatedBy: " ")[1])
                                .font(.footnote)
                        }
                        Spacer()
                        Text(ping.text)
                    }
                }
            }
            .navigationTitle("TagTime Log")
        }
        .onReceive(self.observer.$enteredForeground) { _ in
            createPendingPings(ts: getMissingTimestamps(prev: 1678650351, seed: 405512340))
            loadVisiblePings()
        }
    }
    
    func loadVisiblePings() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)
            visiblePings = try fileURLs.map { url in
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(Ping.self, from: data)
            }
            .filter {
                $0.title <= Int(Date().timeIntervalSince1970)
            }
            .sorted(by: >)
        } catch {
            print("Unable to load pings: \(error.localizedDescription)")
        }
    }
    
}

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

struct DetailView: View {
    @State private var isEditing = true
    @State private var editedText: String
    @Binding var ping: Ping
    
    init(ping: Binding<Ping>) {
        self._ping = ping
        self._editedText = State(initialValue: ping.wrappedValue.text)
    }
    
    var body: some View {
        VStack {
            if isEditing {
                Text(parseTS(ping.title))
                    .font(.largeTitle)
                TextEditor(text: $editedText)
                    .padding()
            } else {
                Text(parseTS(ping.title))
                    .font(.largeTitle)
                Text(ping.text)
                    .padding()
            }
            Spacer()
            Button(isEditing ? "Done" : "Edit") {
                if isEditing {
                    ping.text = editedText
                    savePing()
                }
                isEditing.toggle()
            }
        }
        .padding()
        .navigationBarItems(trailing: Button(action: {
            isEditing = true
        }) {
            Text("Edit")
        })
    }
    
    func savePing() {
        do {
            let data = try JSONEncoder().encode(ping)
            let url = getDocumentsDirectory().appendingPathComponent(String(ping.title))
            try data.write(to: url, options: .atomicWrite)
        } catch {
            print("Unable to save ping: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
