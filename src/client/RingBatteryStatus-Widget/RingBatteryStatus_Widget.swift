//
//  RingBatteryStatus_Widget.swift
//  RingBatteryStatus-Widget
//
//  Created by Justin Middler on 24/11/20.
//

import WidgetKit
import SwiftUI
import Foundation

struct RingBatteryStatus: Decodable {
    let batteryStatus: Int
    let batteryLow:Bool
    let error:String?
}

struct RingBatteryStatusLoader {
    static func fetch(completion: @escaping (Result<RingBatteryStatus, Error>) -> Void) {
        let ringDoorbellApiEndpoint = URL(string: "http://localhost:5005/get-battery")!
        let task = URLSession.shared.dataTask(with: ringDoorbellApiEndpoint) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            let commit = getDoorbellHealth(fromData: data!)
            completion(.success(commit))
        }
        task.resume()
    }

    static func getDoorbellHealth(fromData data: Foundation.Data) -> RingBatteryStatus {
        let ringData: RingBatteryStatus = try! JSONDecoder().decode(RingBatteryStatus.self, from: data)
        return RingBatteryStatus(batteryStatus: ringData.batteryStatus, batteryLow: ringData.batteryLow, error: ringData.error)
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), ringStatus: RingBatteryStatus(batteryStatus: 99, batteryLow: false, error: "dummy error"))
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        
        let batteryStatus = RingBatteryStatus(batteryStatus: 99, batteryLow: false, error: "dummy error")
        
        let entry = WidgetEntry(date: Date(), ringStatus: batteryStatus)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        
        RingBatteryStatusLoader.fetch { result in
                let doorbellInfo: RingBatteryStatus
                if case .success(let batteryStatus) = result {
                    doorbellInfo = batteryStatus
                } else {
                    doorbellInfo = RingBatteryStatus(batteryStatus: 99, batteryLow: false, error: "Error fetching doorbell health info.")
                }
                let entry = WidgetEntry(date: Date(), ringStatus: doorbellInfo)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let ringStatus: RingBatteryStatus
}

struct RingBatteryStatus_WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text(String("Battery \(entry.ringStatus.batteryStatus)%"))
                .bold()
                .foregroundColor(.white)
            Spacer()
            Text(String("Low Charge \(entry.ringStatus.batteryLow)"))
                .bold()
                .foregroundColor(.white)
            Spacer()
            Text("Last Updated")
                .foregroundColor(.white)
            Text(Date(), style: .time)
                .foregroundColor(.white)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom))
    }
}

@main
struct RingBatteryStatus_Widget: Widget {
    let kind: String = "RingBatteryStatus_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RingBatteryStatus_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ring Battery Status")
        .description("Widget to fetch Ring Battery Status.")
    }
}
