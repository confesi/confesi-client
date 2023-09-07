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

fileprivate struct Constants {
    static let lastPostTitleKey = "lastPostTitleKey"
    static let lastPostContentKey = "lastPostContentKey"
    static let lastPostImageKey = "lastPostImageKey"
    static let lastPostSchoolAbbrKey = "lastPostSchoolAbbrKey"
    static let lastPostIdKey = "lastPostIdKey"
}

extension UserDefaults {
    func storeLastSuccessfulPost(title: String, content: String, image: UIImage?, schoolAbbr: String, id: String) {
        set(title, forKey: Constants.lastPostTitleKey)
        set(content, forKey: Constants.lastPostContentKey)
        set(schoolAbbr, forKey: Constants.lastPostSchoolAbbrKey)
        set(id, forKey: Constants.lastPostIdKey)
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            set(imageData, forKey: Constants.lastPostImageKey)
        }
    }

    func getLastSuccessfulPost() -> (title: String, content: String, image: UIImage?, schoolAbbr: String, id: String)? {
        guard let title = string(forKey: Constants.lastPostTitleKey),
              let content = string(forKey: Constants.lastPostContentKey),
              let schoolAbbr = string(forKey: Constants.lastPostSchoolAbbrKey),
              let id = string(forKey: Constants.lastPostIdKey) else {
            return nil
        }

        var image: UIImage? = nil
        if let imageData = data(forKey: Constants.lastPostImageKey) {
            image = UIImage(data: imageData)
        }
        
        return (title, content, image, schoolAbbr, id)
    }
}

let retryQueue = DispatchQueue(label: "com.confesi.app")
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // This line makes it centered horizontally and vertically
                } else {
                    Color.black.opacity(0.55)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack(spacing: 0) {
                        if !entry.title.isEmpty {
                            Text(entry.schoolAbbr)  // Use the abbreviation from your API
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top, widgetVerticalPadding(for: widgetFamily))
                                .padding(.leading, widgetHorizontalPadding(for: widgetFamily))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()  // This Spacer pushes content below to the bottom

                        VStack(alignment: .leading, spacing: 10) {
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
                        .padding(.bottom, widgetVerticalPadding(for: widgetFamily))
                    }
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
                // Introduce a base delay of x seconds even for the first error
                let backoffTime = 60 + min(10 * pow(2, Double(retryCount)), 3600)
                refreshInterval = backoffTime
                print("Retrying after \(backoffTime) seconds.")
            } else {
                // Reset retry count when fetch is successful
                retryQueue.sync {
                    retryCount = 0
                }
                
                // Refresh every 11 hours if it's loaded successfully
                refreshInterval = 11 * 3600
                print("Refreshing in 11 hours.")
            }
            
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(refreshInterval)))
            completion(timeline)
        }
    }
    
    
    func fetchData(completion: @escaping (String, String, UIImage?, String, String, Bool) -> Void) {
        
        var retryCount = 0

        func attemptFetch() {
            retryCount += 1
            print("Attempting to fetch data... Retry #\(retryCount)")
            
            let urlString = "http://10.0.0.173:8080/api/v1/posts/widget"
            guard let url = URL(string: urlString) else {
                print("Invalid URL: \(urlString)")
                handleFailure()
                return
            }
            
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    handleFailure()
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Unexpected response.")
                    handleFailure()
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
                        
                        // Cache the response using Constants
                        UserDefaults.standard.set(title, forKey: Constants.lastPostTitleKey)
                        UserDefaults.standard.set(content, forKey: Constants.lastPostContentKey)
                        UserDefaults.standard.set(nil, forKey: Constants.lastPostImageKey) // Placeholder; we'll update this when the image is fetched
                        UserDefaults.standard.set(schoolAbbr, forKey: Constants.lastPostSchoolAbbrKey)
                        UserDefaults.standard.set(maskedId, forKey: Constants.lastPostIdKey)
                        
                        if let imgUrl = URL(string: schoolImgUrl) {
                            URLSession.shared.dataTask(with: imgUrl) { imageData, _, _ in
                                if let imageData = imageData {
                                    UserDefaults.standard.set(imageData, forKey: Constants.lastPostImageKey)
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
                        handleFailure()
                    }
                } catch {
                    print("JSON Parsing Error.")
                    handleFailure()
                }
            }.resume()
        }
        
        func handleFailure() {
            if
                let title = UserDefaults.standard.string(forKey: Constants.lastPostTitleKey),
                let content = UserDefaults.standard.string(forKey: Constants.lastPostContentKey),
                let schoolAbbr = UserDefaults.standard.string(forKey: Constants.lastPostSchoolAbbrKey),
                let maskedId = UserDefaults.standard.string(forKey: Constants.lastPostIdKey)
            {
                let imageData = UserDefaults.standard.data(forKey: Constants.lastPostImageKey)
                let image = imageData != nil ? UIImage(data: imageData!) : nil
                
                // Use cached title, content, schoolAbbr, and image
                completion(title, content, image, schoolAbbr, maskedId, false) // Here the isError is set to false
            } else {
                completion("Error", "Failed to fetch data.", nil, "ABBR", "0", true)
            }

            // After handling the failure and providing cached data, you can attempt a refetch in the background.
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                attemptFetch()
            }
        }

        attemptFetch()
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
    
    
