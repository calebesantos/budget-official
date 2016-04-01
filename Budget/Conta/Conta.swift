//
//  Conta.swift
//  Budget
//
//  Created by Calebe Santos on 3/31/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation
import CoreData

class Conta: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    let formatter = NSNumberFormatter()
    
    static func getConta() -> Conta{
        return ContextFactory.getManagedObject("Conta") as! Conta
    }
    
    static func getContasController(firstSort:String, secondSort:String = "", sectionName:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("Conta", firstSort: firstSort, secondSort: secondSort, sectionName: sectionName)
    }
    
    func moeda(valor: Float) -> String{
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return (formatter.stringFromNumber(valor))!
    }
}