//
//  StreamViewModel.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 25.12.25.
//

import Foundation
import HaishinKit
import RTMPHaishinKit
import Network
import UIKit

enum StreamingStatus {
    case offline
    case online
    case connecting
    case reconnecting
    case error
}

@MainActor
final class StreamViewModel: ObservableObject {
    private let service = StreamService()
    private let storage: StreamingStorage
    private let networkMonitor = NWPathMonitor()
    private weak var mtView: MTHKView?
    
    private var currentStatus: StreamingStatus = .offline
    private var isManuallyStopped = false
    private var timer: Timer?
    private var startTime: Date?

    // Callbacks for UIKit layer
    var onStreamingStatusUpdate: ((StreamingStatus) -> Void)?
    var onTimerUpdate: ((String) -> Void)?
    var onMuteUpdate: ((Bool) -> Void)?

    init(storage: StreamingStorage) {
        self.storage = storage
        
        startNetworkMonitoring()
        
        Task { [weak self] in
            try? await self?.service.configureMediaStack()
            await self?.setupStatusObservation()
        }
    }

    // MARK: - Connectivity Monitoring
    private func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                if path.status != .satisfied && self?.currentStatus == .online {
                    await self?.processError()
                } else if path.status == .satisfied && self?.currentStatus == .error {
                    self?.updateStatus(.offline)
                }
            }
        }
        networkMonitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }

    // MARK: - Stream Controls
    func toggleStream() {
        Task {
            if currentStatus == .online || currentStatus == .connecting {
                isManuallyStopped = true
                stopTimer()
                await service.disconnect()
                updateStatus(.offline)
            } else {
                isManuallyStopped = false
                await performConnect()
            }
        }
    }

    private func performConnect() async {
        guard let url = storage.urlString, let key = storage.keyString else { return }
        
        if currentStatus == .error {
            await service.resetStack()
            // Important: restart observation for the NEW stream object
            Task { await setupStatusObservation() }
        }
        
        updateStatus(.connecting)
        do {
            try await service.connect(url: url, key: key)
        } catch {
            await processError()
        }
    }

    // MARK: - Observation Logic
    private func setupStatusObservation() async {
        let streamToObserve = service.rtmpStream
        // Simplified: removed redundant await before streamToObserve
        for await status in await streamToObserve.status {
            switch status.code {
            case "NetStream.Publish.Start":
                updateStatus(.online)
                startTimer()
                
            case "NetConnection.Connect.Closed", "NetStream.Publish.Stop":
                stopTimer()
                updateStatus(isManuallyStopped ? .offline : .error)
                
            case "NetConnection.Connect.Failed", "NetConnection.Connect.Rejected":
                await processError()
                
            default:
                break
            }
        }
    }

    // MARK: - Error Handling
    private func processError() async {
        isManuallyStopped = false
        stopTimer()
        await service.disconnect()
        updateStatus(.error)
    }

    private func updateStatus(_ status: StreamingStatus) {
        self.currentStatus = status
        self.onStreamingStatusUpdate?(status)
    }

    // MARK: - Media Controls
    func switchCamera() {
        Task { await service.switchCamera() }
    }
    
    func toggleMute() {
        Task {
            let isMuted = await service.toggleMute()
            onMuteUpdate?(isMuted)
        }
    }
    
    func stopRunning() {
        stopTimer()
        Task {
            await service.disconnect()
            await service.stopMixer()
            updateStatus(.offline)
        }
    }

    // MARK: - Timer Logic
    private func startTimer() {
        stopTimer()
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, let start = self.startTime else { return }
                let diff = Date().timeIntervalSince(start)
                let hours = Int(diff) / 3600
                let minutes = (Int(diff) % 3600) / 60
                let seconds = Int(diff) % 60
                self.onTimerUpdate?(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        onTimerUpdate?("00:00:00")
    }
}

// MARK: - MTHKView Integration
extension StreamViewModel: MTHKViewRepresentable.PreviewSource {
    nonisolated func connect(to view: MTHKView) {
        Task { @MainActor [weak self] in
            self?.mtView = view
            // Polling to ensure the hardware is ready before attaching the view
            for _ in 0...10 {
                if self?.service.isMixerReady == true {
                    await self?.service.mixer.addOutput(view)
                    print("Preview successfully attached")
                    break
                }
                
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
        }
    }
}
