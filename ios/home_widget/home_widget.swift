import WidgetKit
import SwiftUI
import UIKit

// 'preview_widget' image is freely usable from Pexels.

// MARK: - Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let id: String
    let title: String
    let content: String
    let backgroundImage: UIImage?
    let schoolAbbr: String
    let isError: Bool
}

let retryQueue = DispatchQueue(label: "com.yourApp.retryQueue")
var retryCount = 0 // This is the variable that will hold the retry count.

// MARK: - Widget
struct YourWidget: Widget {
    private let kind: String = "YourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            YourWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Trending confessions")
        .description("See what's trending.")
    }
}

extension UIImage {
    func resized(for family: WidgetFamily) -> UIImage? {
        let maxSize: CGSize

        switch family {
        case .systemSmall:
            maxSize = CGSize(width: 120, height: 120) // Example values
        case .systemMedium:
            maxSize = CGSize(width: 250, height: 120) // Example values
        case .systemLarge:
            maxSize = CGSize(width: 250, height: 250) // Example values
        default:
            maxSize = CGSize(width: 120, height: 120) // Default fallback
        }

        var newWidth: CGFloat
        var newHeight: CGFloat

        if self.size.width > self.size.height {
            newWidth = maxSize.width
            newHeight = (self.size.height / self.size.width) * maxSize.width
        } else {
            newHeight = maxSize.height
            newWidth = (self.size.width / self.size.height) * maxSize.height
        }

        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        // Compress the image
        guard let compressedData = newImage.jpegData(compressionQuality: 0.5),
              let compressedImage = UIImage(data: compressedData) else {
            return newImage
        }

        return compressedImage
    }
}



// MARK: - Widget Entry View
import SwiftUI
import WidgetKit

import SwiftUI
import WidgetKit

struct YourWidgetEntryView: View {
    var entry: SimpleEntry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // Background
                if let image = entry.backgroundImage {
                    let resizedImage = image.resized(for: widgetFamily)
                    Image(uiImage: resizedImage ?? image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color("purple").opacity(1), Color("purple").opacity(0.75)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }

                // Black Overlay
                Color.black.opacity(0.65)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                // Content
                if entry.isError {
                    VStack {
                        Text("Connection error")
                            .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: true), weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        Text("We'll retry soon")
                            .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: false)))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else {
                    VStack(alignment: .leading, spacing: 10) {
                        // Display ABBR when there's no error and there's actual data
                        if !entry.title.isEmpty {
                            Text(entry.schoolAbbr)  // Use the abbreviation from your API
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer().frame(height: 10)  // Adding a spacer between ABBR and title/body
                        
                        Text(entry.title.isEmpty ? entry.content : entry.title)
                            .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: true), weight: .bold))
                            .foregroundColor(.white)
                            .truncationMode(.tail)
                        if widgetFamily == .systemLarge && !entry.title.isEmpty {
                            Text(entry.content)
                                .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: false)))
                                .foregroundColor(.white)
                                .truncationMode(.tail)
                        }
                    }
                    .padding(.horizontal, widgetHorizontalPadding(for: widgetFamily))
                    .padding(.vertical, widgetVerticalPadding(for: widgetFamily))
                }
            }
        }
        .widgetURL(URL(string: "confesi://p/\(entry.id)"))
    }
}

    
    
    func widgetVerticalPadding(for family: WidgetFamily) -> CGFloat {
        switch family {
        case .systemSmall:
            return 15
        case .systemMedium:
            return 15
        case .systemLarge:
            return 15
        default:
            return 15
        }
    }
    
    func widgetHorizontalPadding(for family: WidgetFamily) -> CGFloat {
        switch family {
        case .systemSmall:
            return 10
        case .systemMedium:
            return 10
        case .systemLarge:
            return 15
        default:
            return 10
        }
    }
    
    func widgetSizeFont(for family: WidgetFamily, isTitle: Bool) -> CGFloat {
        switch family {
        case .systemSmall:
            return isTitle ? 18 : 15
        case .systemMedium:
            return isTitle ? 22 : 18
        case .systemLarge:
            return isTitle ? 28 : 24
        default:
            return isTitle ? 18 : 15
        }
    }



extension UIImage {
    static func from(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), id: "-1", title: "Placeholder", content: "", backgroundImage: nil, schoolAbbr: "ABBR", isError: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let defaultBackground = UIImage(named: "widget_preview")  // Load the image from asset catalog

        let entry = SimpleEntry(date: Date(), id: "-1", title: "Sus math profs, dude", content: "I heard there are 3 math profs that every weekend get together as a cult. I believe I even had one as my prof last term — it was wild. They discuss students' marks over a giant round table. Has anyone else seen this before?", backgroundImage: defaultBackground, schoolAbbr: "UBC", isError: false)
        completion(entry)
    }


    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        fetchData { title, content, image, schoolAbbr, maskedId, isError in
            let entry = SimpleEntry(date: Date(), id: maskedId, title: title, content: content, backgroundImage: image, schoolAbbr: schoolAbbr, isError: isError)
            
            let refreshInterval: TimeInterval
            if isError {
                // Increase retryCount for consecutive errors
                retryQueue.sync {
                                retryCount += 1
                            }

                // Calculate backoff interval - start with 10 seconds and double for each retry, up to an hour
                let backoffTime = min(10 * pow(2, Double(retryCount)), 3600)
                refreshInterval = backoffTime
                print("Retrying after \(backoffTime) seconds.")
            } else {
                // Reset retry count when fetch is successful
                retryQueue.sync {
                                retryCount = 0
                            }

                // Refresh every 11 hours if it's loaded successfully
                refreshInterval = 11 * 3600
                print("Refreshing in 12 hours.")
            }

            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(refreshInterval)))
            completion(timeline)
        }
    }


    func fetchData(completion: @escaping (String, String, UIImage?, String, String, Bool) -> Void) {
        print("Attempting to fetch data...")
        let urlString = "http://192.168.1.107:8080/api/v1/posts/widget"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion("Error", "Invalid URL.", nil, "ABBR", "-1", true)
            return
        }

        // Create a URLRequest and set its cache policy
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion("Error", "Failed to fetch data.", nil, "ABBR", "0", true)
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or unexpected response format.")
                completion("Error", "Failed to fetch data.", nil, "ABBR", "-1", true)
                return
            }

            if response.statusCode != 200 {
                print("Unexpected response status code: \(response.statusCode)")
                completion("Error", "Server responded with code: \(response.statusCode).", nil, "ABBR", "0", true)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let value = json["value"] as? [String: Any] {

                    let title = value["title"] as? String ?? "Unknown title"
                    let content = value["content"] as? String ?? "Unknown content"
                    let schoolImgUrl = value["school_img_url"] as? String ?? ""
                    let schoolAbbr = value["school_abbr"] as? String ?? "ABBR"
                    let maskedId = (value["id"] as? [String: Any])?["masked"] as? String ?? "0"

                    if let imgUrl = URL(string: schoolImgUrl) {
                        URLSession.shared.dataTask(with: imgUrl) { imageData, imageResponse, imageError in
                            if let imageData = imageData, let _ = imageResponse as? HTTPURLResponse {
                                let image = UIImage(data: imageData)
                                completion(title, content, image, schoolAbbr, maskedId, false)
                            } else {
                                completion(title, content, nil, schoolAbbr, maskedId, false)
                            }
                        }.resume()
                    } else {
                        completion(title, content, nil, schoolAbbr, maskedId, false)
                    }

                } else {
                    print("Invalid JSON structure.")
                    completion("Error", "Failed to parse data.", nil, "ABBR", "0", true)
                }
            } catch let parseError {
                print("Parsing Error: \(parseError.localizedDescription)")
                completion("Error", "Failed to parse data.", nil, "ABBR", "0", true)
            }
        }.resume()
    }

}

// MARK: - Preview
struct YourWidget_Previews: PreviewProvider {
    // This function fetches data synchronously ONLY for the preview.
    static func fetchPreviewData() -> SimpleEntry {
        let semaphore = DispatchSemaphore(value: 0)
        var resultEntry: SimpleEntry?
        
        Provider().fetchData { title, content, image, schoolAbbr, maskedId, isError in
            resultEntry = SimpleEntry(date: Date(), id: maskedId, title: title, content: content, backgroundImage: image, schoolAbbr: schoolAbbr, isError: isError)
            semaphore.signal()
        }


        _ = semaphore.wait(timeout: .now() + 10)  // waiting up to 10 seconds
        return resultEntry!
    }

    static var previews: some View {
        YourWidgetEntryView(entry: fetchPreviewData())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


