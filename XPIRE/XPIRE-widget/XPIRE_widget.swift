//
//  XPIRE_widget.swift
//  XPIRE-widget
//
//  Created by Nurzhan Kanatzhanov on 4/7/21.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), names: [], dates: [], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), names: [], dates: [], configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 15 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            
            let nameArray = UserDefaults(suiteName: "group.XPIRE-widget")!.stringArray(forKey: "names") ?? ["No expiring foods to display!"]
            let dateArray = UserDefaults(suiteName: "group.XPIRE-widget")!.stringArray(forKey: "dates") ?? []
            
            let entry = SimpleEntry(date: entryDate, names: nameArray, dates: dateArray, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let names: [String]
    let dates: [String]
    let configuration: ConfigurationIntent
}

struct XPIRE_widgetEntryView : View {
    var entry: Provider.Entry
    
    let appCustomColor = Color(red: 51/255.0, green: 142/255.0, blue: 86/255.0)
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            ZStack {
                appCustomColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Expiring as of:")
                            .foregroundColor(Color.white)
                        Text(entry.date, style: .date)
                            .underline(true, color: Color.white)
                            .foregroundColor(Color.white)
                        Text(entry.date, style: .time)
                            .foregroundColor(Color.white)
                    }
                    ForEach(entry.names, id: \.self) { name in
                        Text(name)
                            .foregroundColor(Color.white)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                    }
                }
            }
        default:
            ZStack {
                appCustomColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Expiring as of:")
                            .foregroundColor(Color.white)
                        Text(entry.date, style: .date)
                            .underline(true, color: Color.white)
                            .foregroundColor(Color.white)
                        Text(entry.date, style: .time)
                            .foregroundColor(Color.white)
                    }
                    .padding(.bottom)
                    ForEach(entry.names, id: \.self) { name in
                        Text(name)
                            .foregroundColor(Color.white)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}

@main
struct XPIRE_widget: Widget {
    let kind: String = "XPIRE_widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            XPIRE_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("XPIRE Expiration Widget")
        .description("This widget shows you the foods you have that are closest to expiration!")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
