//
//  StreamService.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 24.12.25.
//

import Foundation
import AVFoundation
import HaishinKit
import RTMPHaishinKit

@MainActor
final class StreamService {
    private(set) var mixer = MediaMixer(captureSessionMode: .multi)
    private(set) var connection = RTMPConnection()
    private(set) var rtmpStream: RTMPStream
    
    private var currentPosition: AVCaptureDevice.Position = .back
    private var isMuted = false
    var isMixerReady = false

    init() {
        self.rtmpStream = RTMPStream(connection: connection)
    }

    // MARK: - Media Stack Setup
    
    func configureMediaStack() async throws {
        // Requesting permissions for hardware access
        guard await AVCaptureDevice.requestAccess(for: .video),
              await AVCaptureDevice.requestAccess(for: .audio) else { return }

        await mixer.configuration { session in
            session.automaticallyConfiguresApplicationAudioSession = true
        }

        // Setup Back Camera on Track 0
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        try await mixer.attachVideo(backCamera, track: 0)

        // Setup Front Camera on Track 1
        let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        try? await mixer.attachVideo(frontCamera, track: 1) { videoUnit in
            videoUnit.isVideoMirrored = true
        }

        // Setup Default Audio Input
        try await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
        
        // Start capture session
        await mixer.startRunning()
        isMixerReady = true
        
        // Output mixer data to the RTMP stream
        await mixer.addOutput(rtmpStream)
    }

    // MARK: - Connection Management
    
    func connect(url: String, key: String) async throws {
        var settings = VideoCodecSettings()
        settings.videoSize = CGSize(width: 720, height: 1280)
        settings.bitRate = 2_500_000
        try await rtmpStream.setVideoSettings(settings)
        
        _ = try await connection.connect(url)
        _ = try await rtmpStream.publish(key)
    }

    func disconnect() async {
        _ = try? await rtmpStream.close()
        try? await connection.close()
    }

    func resetStack() async {
        await disconnect()
        await mixer.removeOutput(rtmpStream)
        
        connection = RTMPConnection()
        rtmpStream = RTMPStream(connection: connection)
        
        await mixer.addOutput(rtmpStream)
    }

    // MARK: - Hardware Controls
    
    func switchCamera() async {
        var videoSettings = await mixer.videoMixerSettings
        // Toggle between track 0 (back) and track 1 (front)
        currentPosition = (currentPosition == .back) ? .front : .back
        videoSettings.mainTrack = (currentPosition == .back) ? 0 : 1
        await mixer.setVideoMixerSettings(videoSettings)
    }

    func toggleMute() async -> Bool {
        isMuted.toggle()
        var audioSettings = await mixer.audioMixerSettings
        // Accessing the first audio track to apply mute state
        var track = audioSettings.tracks[0] ?? AudioMixerTrackSettings()
        track.isMuted = isMuted
        audioSettings.tracks[0] = track
        await mixer.setAudioMixerSettings(audioSettings)
        return isMuted
    }
    
    func stopMixer() async {
        isMixerReady = false
        await mixer.stopRunning()
        
        // Detach hardware to release resources
        try? await mixer.attachAudio(nil)
        try? await mixer.attachVideo(nil, track: 0)
        try? await mixer.attachVideo(nil, track: 1)
        
        await mixer.removeOutput(rtmpStream)
    }
}
