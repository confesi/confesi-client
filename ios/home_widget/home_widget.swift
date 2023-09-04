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
}


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

struct YourWidgetEntryView: View {
    var entry: SimpleEntry
    
    @Environment(\.widgetFamily) var widgetFamily  // Identify the widget's size/family
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                
                // Black overlay
                if entry.title != "Error" {
                    Color.black.opacity(0.4).frame(width: geometry.size.width, height: geometry.size.height)
                }

                // Aligning content using VStack
                VStack(alignment: .leading) {
                    // School Abbreviation at top
                    Text(entry.schoolAbbr)
                        .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: false), weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.top, widgetVerticalPadding(for: widgetFamily))

                    Spacer()

                    // Main Content at bottom
                    VStack(alignment: .leading, spacing: 10) {
                        if entry.title == "Error" {
                            Text(entry.title)
                                .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: true), weight: .bold))
                                .foregroundColor(.white)

                            Text(entry.content)
                                .font(.system(size: widgetSizeFont(for: widgetFamily, isTitle: false)))
                                .foregroundColor(.white)
                                .truncationMode(.tail)
                        } else {
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
                    }
                    .padding(.bottom, widgetVerticalPadding(for: widgetFamily))
                }
                .padding(.horizontal, widgetHorizontalPadding(for: widgetFamily))  // Apply the horizontal padding to the entire VStack
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
        return SimpleEntry(date: Date(), id: "0", title: "Placeholder", content: "", backgroundImage: nil, schoolAbbr: "ABBR")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let defaultBackground = UIImage(named: "widget_preview")  // Load the image from asset catalog

        let entry = SimpleEntry(date: Date(), id: "1", title: "Sus math profs, dude", content: "I heard there are 3 math profs that every weekend get together as a cult. I believe I even had one as my prof last term — it was wild. They discuss students' marks over a giant round table. Has anyone else seen this before?", backgroundImage: defaultBackground, schoolAbbr: "UBC")
        completion(entry)
    }


    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        fetchData { title, content, image, schoolAbbr in
            let entry = SimpleEntry(date: Date(), id: "1", title: title, content: content, backgroundImage: image, schoolAbbr: schoolAbbr)

            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }

    func fetchData(completion: @escaping (String, String, UIImage?, String) -> Void) {
        print("Attempting to fetch data...")
        let urlString = "http://192.168.1.107:8080/api/v1/posts/widget"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion("Error", "Invalid URL.", nil, "ABBR")
            return
        }

        // Create a URLRequest and set its cache policy
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion("Error", "Failed to fetch data.", nil, "ABBR")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Unexpected response: \(response?.description ?? "nil")")
                completion("Error", "Invalid response.", nil, "ABBR")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let value = json["value"] as? [String: Any] {

                    let title = value["title"] as? String ?? "Unknown title"
                    let content = value["content"] as? String ?? "Unknown content"
                    let schoolImgUrl = value["school_img_url"] as? String ?? ""
                    let schoolAbbr = value["school_abbr"] as? String ?? "ABBR"

                    if let imgUrl = URL(string: schoolImgUrl), let imageData = try? Data(contentsOf: imgUrl) {
                        let image = UIImage(data: imageData)
                        completion(title, content, image, schoolAbbr)
                    } else {
                        completion(title, content, nil, schoolAbbr)
                    }

                } else {
                    print("Invalid JSON structure.")
                    completion("Error", "Failed to parse data.", nil, "ABBR")
                }
            } catch let parseError {
                print("Parsing Error: \(parseError.localizedDescription)")
                completion("Error", "Failed to parse data.", nil, "ABBR")
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

        Provider().fetchData { title, content, image, schoolAbbr in
            resultEntry = SimpleEntry(date: Date(), id: "1", title: title, content: content, backgroundImage: image, schoolAbbr: schoolAbbr)
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


