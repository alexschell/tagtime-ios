//
//  utils.swift
//  tagtime
//
//  Created by Alexander Schell on 3/12/23.
//

import Foundation

// given a previous timestamp and a seed, generate list of all timestamps up to limit
func getMissingTimestamps(prev: Int, seed: Int) -> [Int] {
    var ts: Int = prev
    var s: Int = seed
    let IA: Int = 16807
    let IM: Int = 2147483647
    let gapMinutes: Float = 45
    var out: [Int] = []
    var dt: Int = 0
    let limit: Int = Int(Date().timeIntervalSince1970) + 60 * 60 * 6
    
    while ts < limit {
        s = (IA * s) % IM
        dt = max(1, Int(round(-1 * 60 * gapMinutes * log(Float(s) / Float(IM)))))
        ts += dt
        if ts < limit {
            out.append(ts)
        }
    }
    
    return out
}

func parseTS(_ ts: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(ts))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}

func getMaxCreatedPingTimestamp() -> Int {
    do {
        let timestamps: [Int] = try FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil).map { Int($0.lastPathComponent)! }
        return timestamps.max() != nil ? (timestamps.max())! : 0
    } catch {
        return 0
    }
}

func createPendingPings(ts: [Int]) {
    for t in ts.sorted(by: <) {
        let ping = Ping(title: t, text: "")
        if t > getMaxCreatedPingTimestamp() {
            scheduleNotification(ts: t)
            savePing(ping: ping)
        }
    }
}

func savePing(ping: Ping) {
    do {
        let data = try JSONEncoder().encode(ping)
        let url = getDocumentsDirectory().appendingPathComponent(String(ping.title))
        try data.write(to: url, options: .atomicWrite)
    } catch {
        print("Unable to save ping: \(error.localizedDescription)")
    }
}

func getIndex(for ping: Ping, in pingArray: [Ping]) -> Int {
    if let index = pingArray.firstIndex(where: { $0.title == ping.title }) {
        return index
    } else {
        fatalError("Ping not found")
    }
}
