import Foundation
import AVFoundation
import UIKit

@objc protocol QRViewDelegate: class {
  @objc optional func qrScanningFailed()
  @objc optional func qrScanningSucceeded(_ str: String?)
  @objc optional func qrScanningStopped()
}

class QRView: UIView {
  weak var delegate: QRViewDelegate?

  private var session: AVCaptureSession?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }

  override var layer: AVCaptureVideoPreviewLayer {
    return super.layer as! AVCaptureVideoPreviewLayer
  }
}

extension QRView {
  public func createAvSession() {
    session = AVCaptureSession()

    guard let defaultDevice = AVCaptureDevice.default(for: .video) else {
      scanningFailed()
      return
    }

    guard let input = try? AVCaptureDeviceInput(device: defaultDevice), session?.canAddInput(input) ?? false else {
      delegate?.qrScanningFailed?()
      return
    }
    session?.addInput(input)

    let metadataOutput = AVCaptureMetadataOutput()
    guard session!.canAddOutput(metadataOutput) else {
      return
    }
    session!.addOutput(metadataOutput)
    metadataOutput.metadataObjectTypes = [.qr]
    metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
    session!.commitConfiguration()
    self.layer.session = session
  }

  public func setup() {
    if (session == nil) {
      createAvSession()
    }

    let mask = CAShapeLayer()
    let multiplier = CGFloat(3)
    let path = UIBezierPath(rect: CGRect(x: 0 - self.bounds.width, y: 0 - self.bounds.height, width: self.bounds.width * multiplier, height: self.bounds.height * multiplier))
    mask.path = path.cgPath
    self.layer.mask = mask
    self.layer.videoGravity = .resizeAspectFill
    self.layer.frame = self.layer.frame
  }

  func startScanning() {
    if let currentSession = session, !currentSession.isRunning {
      currentSession.startRunning()
    }
  }

  func stopScanning() {
    session?.stopRunning()
    delegate?.qrScanningStopped?()
  }

  private func scanningFailed() {
    delegate?.qrScanningFailed?()
    session = nil
  }

  private func result(_ res: String) {
    delegate?.qrScanningSucceeded?(res)
  }
}

extension QRView: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metaObject = metadataObjects.first {
      guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let stringValue = readableObject.stringValue else { return }
      result(stringValue)
    }
  }
}
