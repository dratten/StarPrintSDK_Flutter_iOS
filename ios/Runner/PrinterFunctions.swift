
//  PrinterFunctions.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import Foundation

class PrinterFunctions {
    static func createTextReceiptData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, utf8: Bool) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        localizeReceipts.appendTextReceiptData(builder, utf8: utf8)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
}
