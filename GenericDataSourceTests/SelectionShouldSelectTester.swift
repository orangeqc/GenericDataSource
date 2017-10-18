//
//  SelectionShouldSelectTester.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 10/19/16.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import Foundation
import GenericDataSource
import XCTest

class SelectionShouldSelectTester<CellType>: DataSourceTester where CellType: ReportCell, CellType: ReusableCell, CellType: NSObject {
    let dataSource: ReportBasicDataSource<CellType> = ReportBasicDataSource<CellType>()
    let selector = MockSelectionController<Report, CellType>()

    required init(id: Int, numberOfReports: Int, collectionView: GeneralCollectionView) {
        dataSource.items = Report.generate(numberOfReports: numberOfReports)
        dataSource.registerReusableViewsInCollectionView(collectionView)
        dataSource.setSelectionHandler(selector)
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, tableView: UITableView) -> Bool {
        return dataSource.tableView(tableView, willSelectRowAt: indexPath) == indexPath
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, collectionView: UICollectionView) -> Bool {
        return dataSource.collectionView(collectionView, shouldSelectItemAt: indexPath)
    }

    func assert(result: Bool, indexPath: IndexPath, collectionView: GeneralCollectionView) {
        XCTAssertTrue(selector.shouldSelectCalled)
        XCTAssertTrue(result)
        XCTAssertEqual(indexPath, selector.indexPath)
    }

    func assertNotCalled(collectionView: GeneralCollectionView) {
        XCTAssertFalse(selector.shouldSelectCalled)
    }
}

class SelectionShouldSelectTester2<CellType>: DataSourceTester where CellType: ReportCell, CellType: ReusableCell, CellType: NSObject {
    let dataSource: ReportBasicDataSource<CellType> = ReportBasicDataSource<CellType>()
    let selector = MockSelectionController<Report, CellType>()

    required init(id: Int, numberOfReports: Int, collectionView: GeneralCollectionView) {
        dataSource.items = Report.generate(numberOfReports: numberOfReports)
        dataSource.registerReusableViewsInCollectionView(collectionView)
        dataSource.setSelectionHandler(selector)
        selector.shouldSelectResult = false
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, tableView: UITableView) -> Bool {
        return dataSource.tableView(tableView, willSelectRowAt: indexPath) == indexPath
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, collectionView: UICollectionView) -> Bool {
        return dataSource.collectionView(collectionView, shouldSelectItemAt: indexPath)
    }

    func assert(result: Bool, indexPath: IndexPath, collectionView: GeneralCollectionView) {
        XCTAssertTrue(selector.shouldSelectCalled)
        XCTAssertFalse(result)
        XCTAssertEqual(indexPath, selector.indexPath)
    }

    func assertNotCalled(collectionView: GeneralCollectionView) {
        XCTAssertFalse(selector.shouldSelectCalled)
    }
}
