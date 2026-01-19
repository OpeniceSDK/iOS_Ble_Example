//
//  WrappingHStack.swift
//  OpeniceManager_Example
//
//  Created by 易大宝 on 2026/1/9.
//

import SwiftUI

@available(iOS 16.0, *)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8 // 元素之间的间距
    var lineSpacing: CGFloat = 8 // 行与行之间的间距

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        // 计算总高度
        let height = rows.last?.maxY ?? 0
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        
        for row in rows {
            for item in row.items {
                let x = bounds.minX + item.x
                let y = bounds.minY + item.y
                item.subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            }
        }
    }

    // 核心计算逻辑
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        let maxWidth = proposal.width ?? 0
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var currentItems: [Item] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            // 如果当前行放不下了，就换行
            if currentX + size.width > maxWidth && !currentItems.isEmpty {
                // 保存当前行
                rows.append(Row(items: currentItems, maxY: currentY + currentRowHeight))
                
                // 重置参数到下一行
                currentX = 0
                currentY += currentRowHeight + lineSpacing
                currentRowHeight = 0
                currentItems = []
            }

            // 添加元素到当前行
            currentItems.append(Item(subview: subview, x: currentX, y: currentY))
            
            // 更新当前行的游标
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }

        // 处理最后一行
        if !currentItems.isEmpty {
            rows.append(Row(items: currentItems, maxY: currentY + currentRowHeight))
        }

        return rows
    }

    struct Row {
        var items: [Item]
        var maxY: CGFloat
    }

    struct Item {
        var subview: LayoutSubview
        var x: CGFloat
        var y: CGFloat
    }
}
