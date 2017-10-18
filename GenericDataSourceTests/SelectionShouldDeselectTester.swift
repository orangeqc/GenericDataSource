//
//  SelectionShouldDeselectTester.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 10/19/16.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import Foundation
import GenericDataSource
import XCTest

class SelectionShouldDeselectTester<CellType>: DataSourceTester where CellType: ReportCell, CellType: ReusableCell, CellType: NSObject {
    let dataSource: ReportBasicDataSource<CellType> = ReportBasicDataSource<CellType>()
    let selector = MockSelectionController<Report, CellType>()

    required init(id: Int, numberOfReports: Int, collectionView: GeneralCollectionView) {
        dataSource.items = Report.generate(numberOfReports: numberOfReports)
        dataSource.registerReusableViewsInCollectionView(collectionView)
        dataSource.setSelectionHandler(selector)
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, tableView: UITableView) -> Bool {
        return dataSource.tableView(tableView, willDeselectRowAt: indexPath) == indexPath
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, collectionView: UICollectionView) -> Bool {
        return dataSource.collectionView(collectionView, shouldDeselectItemAt: indexPath)
    }

    func assert(result: Bool, indexPath: IndexPath, collectionView: GeneralCollectionView) {
        XCTAssertTrue(selector.shouldDeselectCalled)
        XCTAssertTrue(result)
        XCTAssertEqual(indexPath, selector.indexPath)
    }

    func assertNotCalled(collectionView: GeneralCollectionView) {
        XCTAssertFalse(selector.shouldDeselectCalled)
    }
}

class SelectionShouldDeselectTester2<CellType>: DataSourceTester where CellType: ReportCell, CellType: ReusableCell, CellType: NSObject {
    let dataSource: ReportBasicDataSource<CellType> = ReportBasicDataSource<CellType>()
    let selector = MockSelectionController<Report, CellType>()

    required init(id: Int, numberOfReports: Int, collectionView: GeneralCollectionView) {
        dataSource.items = Report.generate(numberOfReports: numberOfReports)
        dataSource.registerReusableViewsInCollectionView(collectionView)
        dataSource.setSelectionHandler(selector)
        selector.shouldDeselectResult = false
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, tableView: UITableView) -> Bool {
        return dataSource.tableView(tableView, willDeselectRowAt: indexPath) == indexPath
    }

    func test(indexPath: IndexPath, dataSource: AbstractDataSource, collectionView: UICollectionView) -> Bool {
        return dataSource.collectionView(collectionView, shouldDeselectItemAt: indexPath)
    }

    func assert(result: Bool, indexPath: IndexPath, collectionView: GeneralCollectionView) {
        XCTAssertTrue(selector.shouldDeselectCalled)
        XCTAssertFalse(result)
        XCTAssertEqual(indexPath, selector.indexPath)
    }

    func assertNotCalled(collectionView: GeneralCollectionView) {
        XCTAssertFalse(selector.shouldDeselectCalled)
    }
}
