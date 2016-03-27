//
//  DelegatedGeneralCollectionViewMultiSectionTestCases.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 3/27/16.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import XCTest
@testable import GenericDataSource

private class ClosureDataSource: ReportBasicDataSource<TextReportTableViewCell> {
    
    var configure: ([GeneralCollectionView] -> Void)?
    
    private override func ds_collectionView(collectionView: GeneralCollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        configure?([collectionView, ds_reusableViewDelegate!])
    }
}

class DelegatedGeneralCollectionViewMultiSectionTestCases: XCTestCase {
    
    var tableView: TableView!
    
    var dataSource: CompositeDataSource!
    private var textReportsDataSource: ClosureDataSource!
    
    override func setUp() {
        super.setUp()
        
        dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportTableViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        textReportsDataSource = ClosureDataSource()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        tableView = TableView()
        tableView.reset()
        tableView.ds_useDataSource(dataSource)
    }
    
    func testScrollView() {
        textReportsDataSource.configure = { collectionViews in
            
            class TestClass: UITableViewCell {
            }
            
            for collectionView in collectionViews {
                XCTAssertEqual(self.tableView, collectionView.ds_scrollView)
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testRegisterClass() {
        
        textReportsDataSource.configure = { collectionViews in
            
            class TestClass: UITableViewCell {
            }
            
            for collectionView in collectionViews {
                collectionView.ds_registerClass(TestClass.self, forCellWithReuseIdentifier: "testClass")
                
                XCTAssertEqual(NSStringFromClass(TestClass.self), NSStringFromClass(self.tableView.cellClass!))
                XCTAssertEqual("testClass", self.tableView.identifier)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testRegisterNib() {
        
        textReportsDataSource.configure = { collectionViews in
            
            let nib = UINib(nibName: "testNib", bundle: nil)
            for collectionView in collectionViews {
                collectionView.ds_registerNib(nib, forCellWithReuseIdentifier: "testNib")
                
                XCTAssertEqual(nib, self.tableView.nib)
                XCTAssertEqual("testNib", self.tableView.identifier)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testDequeueCell() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                collectionView.ds_dequeueReusableCellViewWithIdentifier("testCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                
                XCTAssertEqual(NSIndexPath(forRow: 0, inSection: 1), self.tableView.indexPath)
                XCTAssertEqual("testCell", self.tableView.identifier)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testNumberOfSections() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                self.tableView.sections = 45
                let sections = collectionView.ds_numberOfSections()
                
                XCTAssertEqual(sections, self.tableView.sections)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testNumberOfItems() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                self.tableView.items = 45
                let items = collectionView.ds_numberOfItemsInSection(0)
                
                XCTAssertEqual(items, self.tableView.items)
                XCTAssertEqual(1, self.tableView.section)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testReloadData() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                collectionView.ds_reloadData()
                
                XCTAssertTrue(self.tableView.called)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testPerformBatchUpdates() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                collectionView.ds_performBatchUpdates(nil, completion: nil)
                
                XCTAssertTrue(self.tableView.called)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testInsertSections() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexSet = NSIndexSet(index: 0)
                let animation = UITableViewRowAnimation.Bottom
                collectionView.ds_insertSections(indexSet, withRowAnimation: animation)
                
                XCTAssertEqual(NSIndexSet(index: 1), self.tableView.sectionsSet)
                XCTAssertEqual(animation, self.tableView.animation)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testDeleteSections() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexSet = NSIndexSet(index: 0)
                let animation = UITableViewRowAnimation.Bottom
                collectionView.ds_deleteSections(indexSet, withRowAnimation: animation)

                XCTAssertEqual(NSIndexSet(index: 1), self.tableView.sectionsSet)
                XCTAssertEqual(animation, self.tableView.animation)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testReloadSections() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexSet = NSIndexSet(index: 0)
                let animation = UITableViewRowAnimation.Bottom
                collectionView.ds_reloadSections(indexSet, withRowAnimation: animation)
                
                XCTAssertEqual(NSIndexSet(index: 1), self.tableView.sectionsSet)
                XCTAssertEqual(animation, self.tableView.animation)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testMoveSection() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                collectionView.ds_moveSection(0, toSection: 0)
                
                XCTAssertEqual(1, self.tableView.section)
                XCTAssertEqual(1, self.tableView.toSection)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testInsertItems() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPaths = [NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 10, inSection: 0)]
                let animation = UITableViewRowAnimation.Bottom
                collectionView.ds_insertItemsAtIndexPaths(indexPaths, withRowAnimation: animation)
                
                XCTAssertEqual([NSIndexPath(forRow: 0, inSection: 1), NSIndexPath(forRow: 10, inSection: 1)],
                               self.tableView.indexPaths!)
                XCTAssertEqual(animation, self.tableView.animation)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testDeleteItems() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPaths = [NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 10, inSection: 0)]
                let animation = UITableViewRowAnimation.Bottom
                collectionView.ds_deleteItemsAtIndexPaths(indexPaths, withRowAnimation: animation)
                
                XCTAssertEqual([NSIndexPath(forRow: 0, inSection: 1), NSIndexPath(forRow: 10, inSection: 1)],
                               self.tableView.indexPaths!)
                XCTAssertEqual(animation, self.tableView.animation)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testReloadItems() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPaths = [NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 10, inSection: 0)]
                let animation = UITableViewRowAnimation.Bottom
                collectionView.ds_reloadItemsAtIndexPaths(indexPaths, withRowAnimation: animation)
                
                XCTAssertEqual([NSIndexPath(forRow: 0, inSection: 1), NSIndexPath(forRow: 10, inSection: 1)],
                               self.tableView.indexPaths!)
                XCTAssertEqual(animation, self.tableView.animation)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testMoveItem() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                collectionView.ds_moveItemAtIndexPath(NSIndexPath(forRow: 15, inSection: 0), toIndexPath: NSIndexPath(forRow: 50, inSection: 0))
                
                XCTAssertEqual(NSIndexPath(forRow: 15, inSection: 1), self.tableView.indexPath)
                XCTAssertEqual(NSIndexPath(forRow: 50, inSection: 1), self.tableView.toIndexPath)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testScrollToItem() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPath = NSIndexPath(forRow: 145, inSection: 0)
                let scroll = UICollectionViewScrollPosition.Bottom
                let animated = true
                collectionView.ds_scrollToItemAtIndexPath(indexPath, atScrollPosition: scroll, animated: animated)
                
                XCTAssertEqual(NSIndexPath(forRow: 145, inSection: 1), self.tableView.indexPath)
                XCTAssertEqual(UITableViewScrollPosition.Bottom, self.tableView.scrollPosition)
                XCTAssertEqual(animated, self.tableView.animated)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testSelectItem() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPath = NSIndexPath(forRow: 145, inSection: 0)
                let scroll = UICollectionViewScrollPosition.Top
                let animated = true
                collectionView.ds_selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scroll)
                
                XCTAssertEqual(NSIndexPath(forRow: 145, inSection: 1), self.tableView.indexPath)
                XCTAssertEqual(UITableViewScrollPosition.Top, self.tableView.scrollPosition)
                XCTAssertEqual(animated, self.tableView.animated)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testSelectItemWithNil() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPath: NSIndexPath? = nil
                let scroll = UICollectionViewScrollPosition.Top
                let animated = true
                collectionView.ds_selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scroll)
                
                XCTAssertEqual(indexPath, self.tableView.indexPath)
                XCTAssertEqual(UITableViewScrollPosition.Top, self.tableView.scrollPosition)
                XCTAssertEqual(animated, self.tableView.animated)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testDeselectItem() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPath = NSIndexPath(forRow: 145, inSection: 0)
                let animated = false
                collectionView.ds_deselectItemAtIndexPath(indexPath, animated: animated)
                
                XCTAssertEqual(NSIndexPath(forRow: 145, inSection: 1), self.tableView.indexPath)
                XCTAssertEqual(animated, self.tableView.animated)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testIndexPathForCell() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let cell = UITableViewCell()
                self.tableView.indexPath = NSIndexPath(forRow: 50, inSection: 1)
                let indexPath = collectionView.ds_indexPathForCell(cell)
                
                XCTAssertEqual(NSIndexPath(forRow: 50, inSection: 0), indexPath)
                XCTAssertEqual(cell, self.tableView.cell)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testIndexPathForCellNil() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let cell = UITableViewCell()
                self.tableView.indexPath = nil
                let indexPath = collectionView.ds_indexPathForCell(cell)
                
                XCTAssertEqual(self.tableView.indexPath, indexPath)
                XCTAssertEqual(cell, self.tableView.cell)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testIndexPathForItemAtPoint() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let point = CGPoint(x: 11, y: 22)
                self.tableView.indexPath = NSIndexPath(forRow: 50, inSection: 1)
                let indexPath = collectionView.ds_indexPathForItemAtPoint(point)
                
                XCTAssertEqual(NSIndexPath(forRow: 50, inSection: 0), indexPath)
                XCTAssertEqual(point, self.tableView.point)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testIndexPathForItemAtPointNil() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let point = CGPoint(x: 11, y: 22)
                self.tableView.indexPath = nil
                let indexPath = collectionView.ds_indexPathForItemAtPoint(point)
                
                XCTAssertEqual(self.tableView.indexPath, indexPath)
                XCTAssertEqual(point, self.tableView.point)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testIndexPathsForVisibleItems() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                self.tableView.indexPaths = [NSIndexPath(forRow: 50, inSection: 1), NSIndexPath(forRow: 100, inSection: 1)]
                let indexPaths = collectionView.ds_indexPathsForVisibleItems()
                
                XCTAssertEqual([NSIndexPath(forRow: 50, inSection: 0), NSIndexPath(forRow: 100, inSection: 0)], indexPaths)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testIndexPathsForSelectedItems() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                self.tableView.indexPaths = [NSIndexPath(forRow: 50, inSection: 1), NSIndexPath(forRow: 100, inSection: 1)]
                let indexPaths = collectionView.ds_indexPathsForSelectedItems()
                
                XCTAssertEqual([NSIndexPath(forRow: 50, inSection: 0), NSIndexPath(forRow: 100, inSection: 0)], indexPaths)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testVisibleCells() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                self.tableView.cells = [UITableViewCell(), TextReportTableViewCell()]
                let cells = collectionView.ds_visibleCells()
                
                XCTAssertEqual(self.tableView.cells.count, cells.count)
                for i in 0..<cells.count {
                    if let cell = cells[i] as? UITableViewCell {
                        XCTAssertEqual(cell, self.tableView.cells[i])
                    } else {
                        XCTFail()
                    }
                }
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testCellForItemAtIndexPath() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                self.tableView.cell = UITableViewCell()
                let cell = collectionView.ds_cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                
                XCTAssertEqual(NSIndexPath(forRow: 0, inSection: 1), self.tableView.indexPath)
                XCTAssertEqual(cell as? UITableViewCell, self.tableView.cell)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testLocalIndexPathForGlobalIndexPath() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPath = collectionView.ds_localIndexPathForGlobalIndexPath(NSIndexPath(forRow: 51, inSection: 1))
                
                XCTAssertEqual(NSIndexPath(forRow: 51, inSection: 0), indexPath)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testGlobalIndexPathForLocalIndexPath() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let indexPath = collectionView.ds_globalIndexPathForLocalIndexPath(NSIndexPath(forRow: 2, inSection: 0))
                
                XCTAssertEqual(NSIndexPath(forRow: 2, inSection: 1), indexPath)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
    
    func testGlobalSectionForLocalSection() {
        
        textReportsDataSource.configure = { collectionViews in
            
            for collectionView in collectionViews {
                let section = collectionView.ds_globalSectionForLocalSection(0)
                XCTAssertEqual(1, section)
                
                self.tableView.reset()
            }
        }
        
        // call configure
        dataSource.ds_collectionView(tableView, didSelectItemAtIndexPath: NSIndexPath(forRow: 50, inSection: 1))
    }
}
