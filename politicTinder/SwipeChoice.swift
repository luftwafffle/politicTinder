import Foundation

/// User-defined directions: left agrees, right disagrees.
enum SwipeChoice {
    static func answer(horizontal: CGFloat, vertical: CGFloat) -> Bool? {
        guard abs(horizontal) >= 90, abs(horizontal) > abs(vertical) * 1.3 else { return nil }
        return horizontal < 0
    }
}
