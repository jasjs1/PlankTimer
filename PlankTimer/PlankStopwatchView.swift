import SwiftUI

struct LoggedSession: Codable {
    let duration: TimeInterval
    let date: Date
}

class LoggedSessionsStore {
    private let fileName = "loggedSessions.json"
    
    func save(loggedSessions: [LoggedSession]) {
        do {
            let data = try JSONEncoder().encode(loggedSessions)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try data.write(to: url)
        } catch {
            print("Error saving logged sessions: \(error)")
        }
    }
    
    func load() -> [LoggedSession] {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: url)
            let loggedSessions = try JSONDecoder().decode([LoggedSession].self, from: data)
            return loggedSessions
        } catch {
            print("Error loading logged sessions: \(error)")
            return []
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct PlankStopwatchView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var elapsedMinutes: Int = 0
    @State private var isRunning = false
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State private var loggedSessions: [LoggedSession] = []
    private let loggedSessionsStore = LoggedSessionsStore()

    var body: some View {
        VStack {
            Text("Plank Stopwatch")
                .font(.title)
                .bold()
                .padding()
                .alignmentGuide(.leading) { _ in 0 }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            VStack(alignment: .leading) {
                Text(String(format: "%02d:%05.2f", elapsedMinutes, elapsedTime))
                    .font(.system(size: 60))
                    .padding(.leading, 22)
                    .bold()

                Spacer()

                VStack {
                    VStack {
                        Button(action: {
                            isRunning.toggle()
                        }) {
                            Text(isRunning ? "Stop" : "Start")
                                .font(.title)
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                                .background(isRunning ? Color.red : Color.green)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            logPlankSession()
                        }) {
                            Text("Log Session")
                                .font(.title)
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                        Text("Logged Sessions:")
                            .font(.title)
                            .bold()
                            .padding(.top, 20)

                        ForEach(loggedSessions, id: \.date) { session in
                            VStack(alignment: .leading) {
                                Text("Duration: \(String(format: "%.2f", session.duration))")
                                    .font(.title)
                                Text("Date: \(formattedDate(session.date))")
                                    .font(.title)
                            }
                            .padding(.top, 5)
                        }
                    }
                }
                .frame(width: 280, alignment: .center)
                .padding(.horizontal)
            }
        }
        .onAppear {
            loggedSessions = loggedSessionsStore.load()
        }
        .onDisappear {
            loggedSessionsStore.save(loggedSessions: loggedSessions)
        }
        .onReceive(timer) { _ in
            if isRunning {
                elapsedTime += 0.01
                if elapsedTime >= 60 {
                    elapsedTime = 0
                    elapsedMinutes += 1
                }
            }
        }
    }

    private func logPlankSession() {
        let sessionDuration = elapsedTime
        let currentDate = Date()
        let session = LoggedSession(duration: sessionDuration, date: currentDate)
        loggedSessions.append(session)
        saveLoggedSessions()

        elapsedTime = 0
        elapsedMinutes = 0
        isRunning = false
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    private func saveLoggedSessions() {
        loggedSessionsStore.save(loggedSessions: loggedSessions)
    }
}

struct PlankStopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        PlankStopwatchView()
    }
}
