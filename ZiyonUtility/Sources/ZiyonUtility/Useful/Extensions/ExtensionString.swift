//
//  ExtensionString.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 26/06/23.
//

import SwiftUI

/// Extension for `String` providing regex validation, text formatting, and localization utilities.
///
/// This extension includes:
/// - Regex patterns for name, phone, email, numbers, and date validation.
/// - Methods for capitalizing text, extracting characters, and applying markdown.
/// - Pluralization, localized string retrieval, and initials extraction.
///
/// - Author: Elioene Fernandes
/// - Date: 26/06/23
///
public extension String {

    // MARK: Regex
    /// Name Regex
    /// One or more characters, followed by any text, then a space, and finally one or more characters.
    static let namePattern = #"^(?=.{3,})[a-zA-Z]+(\s[a-zA-Z]+)*$"#
    /// Validates a full name that starts with a word and can have additional words separated by a hyphen, apostrophe, or space
    static let fullNamePattern = #"^[a-zA-ZÀ-ÖØ-öø-ÿ]+(?:[-'\s][a-zA-ZÀ-ÖØ-öø-ÿ]+)+$"#

    /// Phone Regex
    /// Based on E.164 global pattern
    /// Phone Regex
    /// "+##############"
    static let phonePattern = #"^\+[1-9]\d{1,14}$"#
    /// Phone Regex
    /// "+## ## #####-####"
    static let phoneBrazilPattern = #"^\+55\s\d{2}\s9\d{4}-\d{4}$"#
    /// Phone Regex
    ///  "+# ### ###-####"
    static let phoneEUAPattern = #"^\+1\s\d{3}\s\d{3}-\d{4}$"#
    /// Phone Regex
    /// "+## ## ## ## ## ##"
    static let phoneFrenchPattern = #"^\+33\s\d{2}\s\d{2}\s\d{2}\s\d{2}\s\d{2}$"#

    /// Email Regex
    /// One or more characters followed by an "@", then one or more characters followed by a ".", and finishing with one or more characters
    static let emailPattern = #"^\S+@\S+\.\S+$"#

    /// Numbers Regex
    /// Just allow numbers, can be 0 to infinite numbers.
    static let numbersPattern = #"[0-9]+"#

    /// Date Regex
    /// Checks if the date is in Brazilian/French format
    /// DD/MM/YYYY
    static let dateBrazilFrenchPattern = #"^((0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4})$"#
    /// Date Regex
    /// Checks if the date is in American format
    /// MM/DD/YYYY
    static let dateEUAPattern = #"^((0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\d{4})$"#

    func validateRegex(with format: String) -> Bool {
        let result = self.range(of: format, options: .regularExpression)
        return result != nil
    }

    // MARK: Capitalize the first letter and remove the period
    func capitalizeRemovePunctuation() -> String {
        return prefix(1).uppercased() +
        dropFirst().lowercased().trimmingCharacters(in:
                .punctuationCharacters)
    }

    // MARK: Masks
    /// Phone Mask
    /// Based on E.164 global pattern
    /// "+##############"
    static let phoneMask = "+##############"
    /// Phone Mask
    /// "+## ## #####-####"
    static let phoneBrazilFormat = "+## ## #####-####"
    /// Phone Mask
    /// "+# ### ###-####"
    static let phoneEUAFormat = "+# ### ###-####"
    /// Phone Mask
    /// "+## ## ## ## ## ##"
    static let phoneFrenchFormat = "+## ## ## ## ## ##"

    /// Time ShortMask Mask
    /// "#:##"
    static let timeShortMask = "#:##"
    /// Time Mask
    ///  "##:##"
    static let timeMask = "##:##"

    /// Date Mask
    ///    "dd-MM-yyyy"
    static let numberDateFormat = "dd-MM-yyyy"
    /// Date Mask
    ///    "dd MMM YYYY"
    static let dateDecriptiveFormat = "dd MMM yyyy"
    /// Date Mask
    ///    "dd MMM yyyy - HH:mm:ss"
    static let fullDateHoursFormat = "dd MMM yyyy - HH:mm:ss"
    /// Date Mask
    ///    "HH:mm"
    static let hourMinuteFormat = "HH:mm"
    /// Date Mask
    ///    "MM-yyyy"
    static let dateMonthYearFormat = "MM-yyyy"
    /// Date Mask
    ///    "##/##/####"
    static let dateBirthFormat = "##/##/####"

    /// format as  YYYY - `2000`
    static let year = "YYYY"

    /// format as `MMM` -  Jan
    static let month = "MMM"

    /// format as `dd` - 01
    static let day = "dd"

    // MARK: Dynamic Variables
    /// Just calling this variable to any string you can obtain its localized version.
    /// Arguments can be applied using the same SwiftUI Text() format:
    ///     "key \(argument)".localized
    var localized: String {
        if let index = self.firstIndex(of: " ") {
            let key = self.prefix(upTo: index)
            var parameter = self.suffix(from: index)
            parameter.removeFirst()
            return String(format: NSLocalizedString("\(key) %@", comment: ""), String(parameter))
        } else {
            return String(localized: LocalizationValue(self))
        }
    }

    // MARK: Methods
    /// Return an attributed version of the string with a substring highlighted
    func highlight(
        _ highlight: String,
        color: Color = .ziyonBlue,
        type: TextType = .caption,
        weight: Font.Weight = .regular,
        withUnderline: Bool = false
    ) -> AttributedString {
        var text = AttributedString(self.localized)

        if let range = text.range(of: highlight.localized) {
            text[range].foregroundColor = color
            text[range].font = .roboto(type: type, weight: weight)
            text[range].underlineColor = .init(color)
            text[range].underlineStyle = withUnderline ? .single : .none
        }

        return text
    }

    /// Extracts characters that match a given regex pattern.
    /// - Parameter pattern: The regex pattern to apply.
    /// - Returns: A string containing only the matched characters.
    func extractCharacters(_ pattern: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            let allowed = matches.map { match in
                if let range = Range(match.range, in: self) {
                    return String(self[range])
                } else {
                    return ""
                }
            }
            return allowed.joined()
        } catch {
            print("Error extracting regex: \(error)")
            return ""
        }
    }

    /// Creates an attributed string with optional markdown formatting.
    /// - Parameters:
    ///   - markdown: The markdown formatting characters to use (default is `**`).
    /// - Returns: An attributed string with applied markdown formatting.
    ///
    /// Example:
    /// ``` swift
    /// let plainText = "Hello, world!"
    /// let formattedText = plainText.markdown() // Formats as bold
    /// let italicText = plainText.markdown(markdown: "*") // Formats as italic
    /// ```
    func markdown(markdown: String = "**") -> AttributedString {
        do {
            // Try applying markdown formatting to the input string
            let attributedString = try AttributedString(markdown: "\(markdown)\(self)\(markdown)")
            return attributedString
        } catch {
            // Handle parsing error and return the original string
            print("Error applying markdown: \(error.localizedDescription)")
            return .init(self)
        }
    }
    /// A String extension for pluralizing strings based on an integer count.
    /// Pluralizes the string based on the count.
    ///
    /// - Parameters:
    ///   - count: The integer count to determine the pluralization.
    ///   - tableName: The table to search for the localization key. (default is "Localizable")
    ///   - bundle: The bundle containing the localization files. (default is the main bundle)
    /// - Returns: The pluralized or singular string as a `LocalizedStringKey`.
    ///
    /// - Example :
    ///   ```swiftUI
    ///   let itemCount = 3
    ///   let cartMessage = "You have \(itemCount) item in your cart."
    ///   let localizedMessage = cartMessage.pluralized(itemCount)
    ///   Text(localizedMessage)
    ///   print(localizedMessage) = "You have 3 items in your cart"
    ///   ```
    func pluralized(_ count: Int,
                    tableName: String = "Localizable",
                    bundle: Bundle = .main) -> LocalizedStringKey {
        // Check if the count is not equal to 1
        if count != 1 {
            // Use a pluralization key for localization
            return LocalizedStringKey(
                String(format: NSLocalizedString("%@s",
                                                 tableName: tableName,
                                                 bundle: bundle,
                                                 comment: ""), self)
            )
        }
        // Return the original string for count == 1
        return LocalizedStringKey(
            NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: "")
        )
    }
    // MARK: - String Formatting

    /// Converts a string to a `Double` value.
    /// - Returns: A `Double` representation of the string, or `0.0` if conversion fails.
    func asDouble() -> Double {
        return Double(self) ?? 0.0
    }

    /// Extracts the first name from a full name string.
    /// - Returns: The first word in the string.
    func firstName() -> String {
        return components(separatedBy: " ").first ?? self
    }

    /// Extracts the last name from a full name string.
    var lastName: String {
        return components(separatedBy: " ").last ?? self
    }

    /// Returns the initials of the first and last name.
    var initials: String {
        let firstLetter = firstName().first?.description ?? ""
        let lastLetter = lastName.first?.description ?? ""
        return "\(firstLetter)\(lastLetter)".uppercased()
    }
}

// MARK: - Optional String Extension

public extension Optional where Wrapped == String {
    /// Checks if an optional string is nil or empty.
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}


