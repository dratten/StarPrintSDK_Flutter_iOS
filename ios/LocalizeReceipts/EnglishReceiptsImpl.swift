//
//  EnglishReceiptsImpl.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class EnglishReceiptsImpl: ILocalizeReceipts {
    override init() {
        super.init()
        
        languageCode = "En"
        
        characterCode = StarIoExtCharacterCode.standard
    }
    
    override func append2inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append((
            "Star Clothing Boutique\n" +
            "123 Star Road\n" +
            "City, State 12345\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "Date:MM/DD/YYYY    Time:HH:MM PM\n" +
            "--------------------------------\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withEmphasis: "SALE\n".data(using: encoding))
        
        builder.append((
            "SKU         Description    Total\n" +
            "300678566   PLAIN T-SHIRT  10.99\n" +
            "300692003   BLACK DENIM    29.99\n" +
            "300651148   BLUE DENIM     29.99\n" +
            "300642980   STRIPED DRESS  49.99\n" +
            "300638471   BLACK BOOTS    35.99\n" +
            "\n" +
            "Subtotal                  156.95\n" +
            "Tax                         0.00\n" +
            "--------------------------------\n").data(using: encoding))
        
        builder.append("Total     ".data(using: encoding))
        
        builder.appendData(withMultiple: "   $156.95\n".data(using: encoding), width: 2, height: 2)
        
        builder.append((
            "--------------------------------\n" +
            "\n" +
            "Charge\n" +
            "159.95\n" +
            "Visa XXXX-XXXX-XXXX-0123\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withInvert: "Refunds and Exchanges\n".data(using: encoding))
        
        builder.append("Within ".data(using: encoding))
        
        builder.appendData(withUnderLine: "30 days".data(using: encoding))
        
        builder.append(" with receipt\n".data(using: encoding))
        
        builder.append((
            "And tags attached\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
//      builder.appendBarcodeData("{BStar.".data(using: encoding),              symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".data(using: String.Encoding.ascii), symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode2, height: 40, hri: true)
    }
}
