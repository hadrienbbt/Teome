import Foundation

class SampleRelativeDateFormatter: RelativeDateTimeFormatter {
    override init() {
        super.init()
        self.locale = Locale.current
        self.calendar = Calendar.current
        self.dateTimeStyle = .named
        self.unitsStyle = .abbreviated
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func relativeString(_ date: Date) -> String {
        return self.localizedString(for: date, relativeTo: Date())
    }
}
