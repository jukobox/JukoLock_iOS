//
//  AddMachineViewController.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import AVFoundation
import Combine
import UIKit

final class AddMachineViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: AddMachineViewModel
    private let inputSubject: PassthroughSubject<AddMachineViewModel.Input, Never> = .init()
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - UI Components
    
    // MARK: - Init
    
    init(viewModel: AddMachineViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        setUpLayout()
        checkCameraPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let session = captureSession, session.isRunning {
            session.stopRunning()
        }
    }
    
    // 메모리 해제 시 처리
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - UI Settings

extension AddMachineViewController {
    private func setUpLayout() {
        bind()
    }
    
    // MARK: - Bind
    
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .addMachineSuccess:
                    self?.addMachineSuccess()
                    debugPrint("기기 추가 성공")
                case .addMachineFail:
                    self?.addMachineFail()
                    debugPrint("기기 추가 실패")
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension AddMachineViewController: AVCaptureMetadataOutputObjectsDelegate {
    func failed() {
        let alert = UIAlertController(title: "QR 스캔 불가", message: "QR 코드 스캔을 지원하지 않습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    // QR 코드 읽기 성공 시 호출
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // QR 코드 값 처리
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            addMachine(machineID: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    // QR 코드 값 처리 로직
    func addMachine(machineID: String) {
        DispatchQueue.main.async {
            let sheet = UIAlertController(title: "기기 추가", message: "기기를 추가하겠습니까?", preferredStyle: .alert)
            let addAction = UIAlertAction(title: "추가", style: .default) { _ in
                self.inputSubject.send(.qrReadSuccess(machineId: machineID))
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            sheet.addAction(addAction)
            sheet.addAction(cancelAction)
            self.present(sheet, animated: true)
        }
    }
    
    /// 접근 권한 체크 함수
    func checkCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { cameraPermission in
                if cameraPermission {
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.startCameraSession()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showCameraAccessDeniedAlert()
                    }
                }
            }
        case .restricted, .denied:
            self.showCameraAccessDeniedAlert()
        case .authorized:
            DispatchQueue.global(qos: .userInitiated).async {
                self.startCameraSession()
            }
        default:
            debugPrint("접근 권한 허가")
        }
    }
    
    /// 카메라 권한이 거부되었을 떄 설정으로 이동시켜주는 Alert 띄어주는 함수
    private func showCameraAccessDeniedAlert() {
        let alert = UIAlertController(title: "카메라 접근 권한 필요",
                                      message: "QR 코드를 스캔하기 위해 카메라 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    private func startCameraSession() {
        captureSession = AVCaptureSession()
        
        guard let captureSession = captureSession else { return }
        
        // 기본 카메라 장치(후면 카메라) 가져옴
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            debugPrint("카메라 가져오기 실패")
            return
        }
        
        do {
            // 카메라 입력 장치를 캡처 세션에 추가
            let videoInpout = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInpout) {
                captureSession.addInput(videoInpout)
            } else {
                failed()
                return
            }
        } catch {
            debugPrint("카메라 입력을 설정할 수 없습니다.")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            // 메타데이터 출력의 델리케이트와 디스패치 큐를 설정
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // QR 코드 유형의 메타데이터만 인식하도록 설정
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        // TODO: - Main Thread로 수정
        // 카메라 미리보기를 위한 레이어를 설정
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // 세션 시작
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }
    
    func addMachineSuccess() {
        let sheet = UIAlertController(title: "디바이스 추가 성공!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        sheet.addAction(action)
        self.present(sheet, animated: true)
    }
    
    func addMachineFail() {
        let sheet = UIAlertController(title: "인식 실패!", message: "QR코드 인식에 실패했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        sheet.addAction(action)
        self.present(sheet, animated: true)
    }
}
