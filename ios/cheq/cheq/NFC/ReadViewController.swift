//
//  ReadViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/9/24.
//

import UIKit
import CoreNFC

class ReadViewController: UIViewController {
    
    var session: NFCNDEFReaderSession?
    //    @IBOutlet weak var lblData: UILabel!
    let lblData = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "ajsflksdfjdklsfjaslkfd"
        v.isUserInteractionEnabled = true
        v.textColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(lblData)
        
        
        NSLayoutConstraint.activate([
            lblData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblData.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        lblData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnScan)))
    }
    
    @objc func btnScan(_ sender: UIButton) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .actionSheet
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
            self.session?.alertMessage = "Hold your iPhone near the item to learn more about it."
            self.session?.begin()
        }
    }
    
}
extension ReadViewController : NFCNDEFReaderSessionDelegate {
    
    
    // MARK: - NFCNDEFReaderSessionDelegate

    /// - Tag: processingTagData
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("readerSession didDetectNDEFs : \(messages.count)")
        for message in messages
        {
            for record in message.records
            {
                if record.typeNameFormat == .nfcWellKnown
                {
                    let val = record.wellKnownTypeTextPayload()
                    print(val)
                    if let s = val.0,!s.isEmpty,let v = val.0
                    {
                        DispatchQueue.main.async {
                            self.lblData.text = v
                        }
                    }
                }
            }
        }
    }

    /// - Tag: processingNDEFTag
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print("readerSession didDetect : \(tags.count)")
        if tags.count > 1 {
            // Restart polling in 500ms
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected, please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and perform NDEF message reading
        let tag = tags.first!
        print("1")
        session.connect(to: tag, completionHandler: { (error: Error?) in
            print("2")
            if nil != error {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            print("3")
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                print("4")
                if .notSupported == ndefStatus {
                    session.alertMessage = "Tag is not NDEF compliant"
                    session.invalidate()
                    return
                } else if nil != error {
                    session.alertMessage = "Unable to query NDEF status of tag"
                    session.invalidate()
                    return
                }
                print("5")
                
                tag.readNDEF(completionHandler: { (message: NFCNDEFMessage?, error: Error?) in
                    print("5-1")
                    var statusMessage: String
                    if nil != error || nil == message {
                        print("50")
                        statusMessage = "Fail to read NDEF from tag"
                    } else {
                        print("5-2")
                        statusMessage = "Found 1 NDEF message"
                        DispatchQueue.main.async {
                            // Process detected NFCNDEFMessage objects.
                            print("5-3 : \(message?.records.count)")
                            for record in message!.records {
                                if (record.typeNameFormat.rawValue == 1) {
                                    print("record is nil")
                                }
                                
                                DispatchQueue.main.async {
                                    print("5-4 : \(record.typeNameFormat)")
                                    if(record.typeNameFormat.rawValue == 1) {
                                        print("is 1 :: \(record.typeNameFormat == .nfcWellKnown)")
                                    }
                                    switch record.typeNameFormat {
                                    case .nfcWellKnown:
                                        print("511")
                                        if let url = record.wellKnownTypeURIPayload() {
                                            print("512")
                                            self.lblData.text = url.absoluteString
                                        }
                                    case .absoluteURI:
                                        print("52")
                                        if let text = String(data: record.payload, encoding: .utf8) {
                                            self.lblData.text = text
                                        }
                                    case .media:
                                        print("53")
                                        if let type = String(data: record.type, encoding: .utf8) {
                                            self.lblData.text = type
                                        }
                                    case .nfcExternal, .empty, .unknown, .unchanged:
                                        print("54")
                                        fallthrough
                                    @unknown default:
                                        print("55")
                                        self.lblData.text = record.typeNameFormat.rawValue.description
                                    }
                                }
                            }
                        }
                    }
                    print("6")
                    
                    session.alertMessage = statusMessage
                    session.invalidate()
                })
            })
        })
    }
    
    /// - Tag: sessionBecomeActive
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("readerSessionDidBecomeActive")
    }
    
    /// - Tag: endScanning
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("invalid data with error : \(error.localizedDescription)")
        DispatchQueue.main.async {
            // Check the invalidation reason from the returned error.
            if let readerError = error as? NFCReaderError {
                // Show an alert when the invalidation reason is not because of a
                // successful read during a single-tag read session, or because the
                // user canceled a multiple-tag read session from the UI or
                // programmatically using the invalidate method call.
                if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                    && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                    let alertController = UIAlertController(
                        title: "Session Invalidated",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            // To read new tags, a new session instance is required.
            self.session = nil
        }
    }

    

}
