//
//  WindowDirection.swift
//  Loop
//
//  Created by Kai Azim on 2023-06-14.
//

import SwiftUI

// Enum that stores all possible resizing options
enum WindowDirection: CaseIterable {

    case noAction
    case maximize

    // Halves
    case topHalf
    case rightHalf
    case bottomHalf
    case leftHalf

    // Quarters
    case topRightQuarter
    case bottomRightQuarter
    case bottomLeftQuarter
    case topLeftQuarter

    // The following aren't accessible from the radial menu
    case rightThird
    case rightTwoThirds
    case horizontalCenterThird
    case leftThird
    case leftTwoThirds

    case topThird
    case topTwoThirds
    case verticalCenterThird
    case bottomThird
    case bottomTwoThirds

    var nextWindowDirection: WindowDirection {
        switch self {
        case .noAction:             .topHalf
        case .topHalf:              .topRightQuarter
        case .topRightQuarter:      .rightHalf
        case .rightHalf:            .bottomRightQuarter
        case .bottomRightQuarter:   .bottomHalf
        case .bottomHalf:           .bottomLeftQuarter
        case .bottomLeftQuarter:    .leftHalf
        case .leftHalf:             .topLeftQuarter
        case .topLeftQuarter:       .maximize
        case .maximize:             .noAction
        default:                    .noAction
        }
    }

    var keybindings: [Set<UInt16>] {
        switch self {
        case .noAction:                 [[]]
        case .maximize:                 [[KeyCode.space]]

        case .topHalf:                  [[KeyCode.w], [KeyCode.upArrow]]
        case .rightHalf:                [[KeyCode.d], [KeyCode.rightArrow]]
        case .bottomHalf:               [[KeyCode.s], [KeyCode.downArrow]]
        case .leftHalf:                 [[KeyCode.a], [KeyCode.leftArrow]]

        case .topRightQuarter:          [[KeyCode.w, KeyCode.d], [KeyCode.upArrow, KeyCode.rightArrow]]
        case .bottomRightQuarter:       [[KeyCode.s, KeyCode.d], [KeyCode.downArrow, KeyCode.rightArrow]]
        case .bottomLeftQuarter:        [[KeyCode.s, KeyCode.a], [KeyCode.downArrow, KeyCode.leftArrow]]
        case .topLeftQuarter:           [[KeyCode.w, KeyCode.a], [KeyCode.upArrow, KeyCode.leftArrow]]

        case .leftThird:                [[KeyCode.j]]
        case .leftTwoThirds:            [[KeyCode.u]]
        case .horizontalCenterThird:    [[KeyCode.k]]
        case .rightTwoThirds:           [[KeyCode.o]]
        case .rightThird:               [[KeyCode.l]]

        default:                        [[]]
        }
    }
}
