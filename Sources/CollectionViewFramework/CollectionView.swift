//
//  CollectionView.swift
//  FrameworkInProgress
//
//  Created by Никита Боровик on 08.11.2023.
//

import Foundation
import SwiftUI

/// Typealias for a closure that provides a view for a given cell, identified by its `IndexPath`.
public typealias CellContentProvider = (IndexPath) -> any View
/// Typealias for a closure that configures the layout of the collection view.
public typealias LayoutConfigurator = (UICollectionViewFlowLayout) -> Void
/// Typealias for a closure that handles the selection of an item, given its `IndexPath`.
public typealias SelectionHandler = (IndexPath) -> Void
/// Typealias for a closure that provides a view for the header of a given section.
public typealias HeaderContentProvider = (Int) -> any View
/// Typealias for a closure that provides a view for the footer of a given section.
public typealias FooterContentProvider = (Int) -> any View

/// A SwiftUI view that represents a UICollectionView, configurable for various data types.
public struct CollectionView<DataType>: UIViewRepresentable {

    @Binding private var data: [DataType]
    private let cell: CellContentProvider
    private var selectionHandler: SelectionHandler
    private var layoutPreferences = LayoutPreferences()
    private var numberOfSections: Int?
    private var numberOfItemsPerSection: Int?
    private var header: HeaderContentProvider?
    private var footer: FooterContentProvider?

    public init(data: Binding<[DataType]>,
                cell: @escaping CellContentProvider,
                selectionHandler: @escaping SelectionHandler,
                layoutPreferences: LayoutPreferences,
                numberOfSections: Int? = nil,
                numberOfItemsPerSection: Int? = nil,
                header: HeaderContentProvider? = nil,
                footer: FooterContentProvider? = nil) {
        self._data = data
        self.cell = cell
        self.selectionHandler = selectionHandler
        self.layoutPreferences = layoutPreferences
        self.numberOfSections = numberOfSections
        self.numberOfItemsPerSection = numberOfItemsPerSection
        self.header = header
        self.footer = footer
    }
    /// Sets the number of sections in the collection view.
    /// - Parameter number: The number of sections.
    /// - Returns: An updated instance of `CollectionView`.
    public func numberOfSections(_ number: Int) -> Self {
        var copy = self
        copy.numberOfSections = number
        return copy
    }

    /// Sets the number of items per section in the collection view.
    /// - Parameter number: The number of items per section.
    /// - Returns: An updated instance of `CollectionView`.
    public func numberOfItemsPerSection(_ number: Int) -> Self {
        var copy = self
        copy.numberOfItemsPerSection = number
        return copy
    }

    /// Sets the scroll direction of the collection view.
    /// - Parameter direction: The scroll direction, either horizontal or vertical.
    /// - Returns: An updated instance of `CollectionView`.
    public func scrollDirection(_ direction: UICollectionView.ScrollDirection) -> Self {
        var copy = self
        copy.layoutPreferences.scrollDirection = direction
        return copy
    }

    /// Sets the size of each item in the collection view.
    /// - Parameter size: The size for each item.
    /// - Returns: An updated instance of `CollectionView`.
    public func itemSize(_ size: CGSize) -> Self {
        var copy = self
        copy.layoutPreferences.itemSize = size
        return copy
    }

    /// Sets the minimum line spacing between rows in the collection view.
    /// - Parameter spacing: The minimum line spacing.
    /// - Returns: An updated instance of `CollectionView`.
    public func minimumLineSpacing(_ spacing: CGFloat) -> Self {
        var copy = self
        copy.layoutPreferences.minimumLineSpacing = spacing
        return copy
    }

    /// Sets the minimum spacing between items in the same row.
    /// - Parameter spacing: The minimum interitem spacing.
    /// - Returns: An updated instance of `CollectionView`.
    public func minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        var copy = self
        copy.layoutPreferences.minimumInteritemSpacing = spacing
        return copy
    }

    /// Sets the insets for each section in the collection view.
    /// - Parameter inset: The edge insets for each section.
    /// - Returns: An updated instance of `CollectionView`.
    public func sectionInset(_ inset: UIEdgeInsets) -> Self {
        var copy = self
        copy.layoutPreferences.sectionInset = inset
        return copy
    }

    /// Sets the size for header views in each section.
    /// - Parameter size: The size for header views.
    /// - Returns: An updated instance of `CollectionView`.
    public func headerSize(_ size: CGSize) -> Self {
        var copy = self
        copy.layoutPreferences.headerSize = size
        return copy
    }

    /// Sets the size for footer views in each section.
    /// - Parameter size: The size for footer views.
    /// - Returns: An updated instance of `CollectionView`.
    public func footerSize(_ size: CGSize) -> Self {
        var copy = self
        copy.layoutPreferences.footerSize = size
        return copy
    }

    /// Creates the collection view and sets it up.
    /// - Parameter context: The current context.
    /// - Returns: A configured `UICollectionView`.
    public func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = layoutPreferences.scrollDirection
        layout.itemSize = layoutPreferences.itemSize
        layout.minimumLineSpacing = layoutPreferences.minimumLineSpacing
        layout.minimumInteritemSpacing = layoutPreferences.minimumInteritemSpacing
        layout.sectionInset = layoutPreferences.sectionInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: UICollectionView.elementKindSectionHeader)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: UICollectionView.elementKindSectionFooter)
        return collectionView
    }

    /// Updates the collection view when data changes.
    /// - Parameters:
    ///   - uiView: The `UICollectionView` to update.
    ///   - context: The current context.
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.reloadData()
    }

    /// Creates a coordinator to manage the collection view.
    /// - Returns: A new `Coordinator` instance.
    public func makeCoordinator() -> Coordinator<DataType> {
        Coordinator(data: $data,
                    numberOfSections: numberOfSections,
                    numberOfItemsPerSection: numberOfItemsPerSection,
                    cellContentProvider: cell,
                    selectionHandler: selectionHandler,
                    headerProvider: header,
                    footerProvider: footer,
                    headerSize: layoutPreferences.headerSize,
                    footerSize: layoutPreferences.footerSize)
    }
}
/// Structure that stores layout preferences for a `CollectionView`.
public struct LayoutPreferences {
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var itemSize: CGSize = CGSize(width: 100, height: 100)
    var minimumLineSpacing: CGFloat = 10
    var minimumInteritemSpacing: CGFloat = 10
    var sectionInset: UIEdgeInsets = .zero
    var headerSize: CGSize = CGSize(width: 10, height: 10)
    var footerSize: CGSize = CGSize(width: 10, height: 10)
}

/// Coordinator class to manage the collection view's delegation.
public class Coordinator<DataType>: NSObject,
                                    UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {

    @Binding private var data: [DataType]
    private var cellContentProvider: CellContentProvider
    private var selectionHandler: SelectionHandler

    private var headerProvider: HeaderContentProvider?
    private var footerProvider: FooterContentProvider?

    private var headerSize: CGSize
    private var footerSize: CGSize
    private var numberOfSections: Int?
    private var numberOfItemsPerSection: Int?

    /// Initializes a new Coordinator for the CollectionView.
    /// - Parameters:
    ///   - data: Binding to the array of data.
    ///   - numberOfSections: Optional number of sections.
    ///   - numberOfItemsPerSection: Optional number of items per section.
    ///   - cellContentProvider: Closure providing the cell content.
    ///   - selectionHandler: Closure handling item selection.
    ///   - headerProvider: Optional closure providing header content.
    ///   - footerProvider: Optional closure providing footer content.
    ///   - headerSize: Size of the header view.
    ///   - footerSize: Size of the footer view.
    public init(data: Binding<[DataType]>,
                numberOfSections: Int?,
                numberOfItemsPerSection: Int?,
                cellContentProvider: @escaping CellContentProvider,
                selectionHandler: @escaping SelectionHandler,
                headerProvider: HeaderContentProvider?,
                footerProvider: FooterContentProvider?,
                headerSize: CGSize,
                footerSize: CGSize) {
        self._data = data
        self.cellContentProvider = cellContentProvider
        self.selectionHandler = selectionHandler
        self.headerProvider = headerProvider
        self.footerProvider = footerProvider
        self.numberOfSections = numberOfSections
        self.numberOfItemsPerSection = numberOfItemsPerSection
        self.headerSize = headerSize
        self.footerSize = footerSize
    }

    /// Returns the number of sections in the collection view.
    /// - Parameter collectionView: The collection view in question.
    /// - Returns: The number of sections.
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections ?? 1
    }

    /// Returns the number of items in a given section of the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view in question.
    ///   - section: The section number.
    /// - Returns: The number of items in the section.
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsPerSection ?? data.count
    }

    /// Provides a configured cell for a given index path in the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured cell.
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let cellView = cellContentProvider(indexPath)
        let hostingController = UIHostingController(rootView: AnyView(cellView))

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
        ]

        cell.contentView.addSubview(hostingController.view)
        cell.contentView.addConstraints(constraints)

        return cell
    }

    /// Provides a view for the supplementary element of a kind in a specified section.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the view.
    ///   - kind: The kind of supplementary view (header or footer).
    ///   - indexPath: The index path specifying the location of the supplementary view.
    /// - Returns: A configured supplementary view.
    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: kind,
            for: indexPath)
        reusableView.subviews.forEach { $0.removeFromSuperview() }

        let hostingController: UIHostingController<AnyView>
        if kind == UICollectionView.elementKindSectionHeader,
           let headerProvider = headerProvider {
            hostingController = UIHostingController(
                rootView: AnyView(headerProvider(indexPath.section)))
        } else if kind == UICollectionView.elementKindSectionFooter,
                  let footerProvider = footerProvider {
            hostingController = UIHostingController(
                rootView: AnyView(footerProvider(indexPath.section)))
        } else {
            return reusableView
        }

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: reusableView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: reusableView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: reusableView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: reusableView.trailingAnchor)
        ]

        reusableView.addSubview(hostingController.view)
        reusableView.addConstraints(constraints)

        return reusableView
    }
    /// Handles the selection of an item in the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view where the selection occurred.
    ///   - indexPath: The index path of the selected item.
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        selectionHandler(indexPath)
    }
    /// Returns the size for the header view in a given section.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the size.
    ///   - collectionViewLayout: The layout object providing information about the current layout.
    ///   - section: The section number.
    /// - Returns: The size of the header view.
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: headerSize.width, height: headerSize.width)
    }
    /// Returns the size for the footer view in a given section.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the size.
    ///   - collectionViewLayout: The layout object providing information about the current layout.
    ///   - section: The section number.
    /// - Returns: The size of the footer view.
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: footerSize.width, height: footerSize.width)
    }
}
