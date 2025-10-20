# daisy

second-screen/
├── rust-capture/                          # Rust capture & encoding service
│   ├── Cargo.toml
│   ├── Cargo.lock
│   ├── .cargo/
│   │   └── config.toml                    # Build configuration
│   ├── src/
│   │   ├── main.rs                        # Entry point & service orchestration
│   │   ├── lib.rs                         # Library exports
│   │   │
│   │   ├── capture/                       # Screen capture module
│   │   │   ├── mod.rs                     # Capture module interface
│   │   │   ├── windows_capture.rs         # Windows Desktop Duplication API
│   │   │   ├── frame_buffer.rs            # Frame buffer management
│   │   │   ├── monitor.rs                 # Monitor detection & selection
│   │   │   └── capture_stats.rs           # Capture performance statistics
│   │   │
│   │   ├── encoder/                       # Video encoding module
│   │   │   ├── mod.rs                     # Encoder interface
│   │   │   ├── h264_encoder.rs            # H.264 encoding (FFmpeg/OpenH264)
│   │   │   ├── hardware_encoder.rs        # NVENC/QuickSync/AMF
│   │   │   ├── encoder_config.rs          # Encoding parameters
│   │   │   ├── rate_controller.rs         # Adaptive bitrate logic
│   │   │   ├── quality_presets.rs         # Quality presets per connection
│   │   │   └── frame_pacer.rs             # 120fps frame timing & pacing
│   │   │
│   │   ├── webrtc/                        # WebRTC module
│   │   │   ├── mod.rs                     # WebRTC module interface
│   │   │   ├── peer_connection.rs         # WebRTC peer connection management
│   │   │   ├── track_manager.rs           # Video/audio track handling
│   │   │   ├── signaling.rs               # Signaling protocol (WebSocket)
│   │   │   ├── ice_handler.rs             # ICE candidate handling
│   │   │   ├── data_channel.rs            # Data channel for control messages
│   │   │   └── connection_stats.rs        # WebRTC connection statistics
│   │   │
│   │   ├── input/                         # Input injection module
│   │   │   ├── mod.rs                     # Input module interface
│   │   │   ├── windows_input.rs           # Windows SendInput API wrapper
│   │   │   ├── touch_handler.rs           # Touch event processing
│   │   │   ├── mouse_handler.rs           # Mouse event processing
│   │   │   ├── keyboard_handler.rs        # Keyboard event processing
│   │   │   ├── gesture_recognizer.rs      # Multi-touch gesture recognition
│   │   │   ├── coordinate_mapper.rs       # Screen coordinate transformation
│   │   │   └── input_queue.rs             # Input event queue & batching
│   │   │
│   │   ├── network/                       # Network communication
│   │   │   ├── mod.rs                     # Network module interface
│   │   │   ├── websocket_server.rs        # WebSocket server for signaling
│   │   │   ├── udp_server.rs              # UDP for STUN/TURN if needed
│   │   │   ├── protocol.rs                # Message protocol definitions
│   │   │   ├── connection_detector.rs     # NEW: Detect connection type
│   │   │   ├── connection_optimizer.rs    # NEW: Optimize per connection type
│   │   │   ├── network_monitor.rs         # NEW: Monitor network quality
│   │   │   ├── bandwidth_estimator.rs     # NEW: Estimate available bandwidth
│   │   │   ├── usb_network_handler.rs     # NEW: USB-specific network handling
│   │   │   └── interface_scanner.rs       # NEW: Scan network interfaces
│   │   │
│   │   ├── pipeline/                      # Processing pipeline
│   │   │   ├── mod.rs                     # Pipeline orchestration
│   │   │   ├── capture_pipeline.rs        # Capture → Encode → Stream
│   │   │   ├── frame_scheduler.rs         # 120fps frame timing
│   │   │   ├── performance_monitor.rs     # Latency & FPS monitoring
│   │   │   ├── adaptive_pipeline.rs       # NEW: Adaptive quality pipeline
│   │   │   └── latency_optimizer.rs       # NEW: Minimize glass-to-glass latency
│   │   │
│   │   ├── usb/                           # NEW: USB device management
│   │   │   ├── mod.rs                     # USB module interface
│   │   │   ├── device_detector.rs         # Detect iOS devices via USB
│   │   │   ├── device_info.rs             # USB device information
│   │   │   ├── usbmuxd_client.rs          # Communicate with usbmuxd (iOS)
│   │   │   ├── network_interface.rs       # USB network interface management
│   │   │   └── pairing_handler.rs         # USB device pairing
│   │   │
│   │   ├── config/                        # Configuration management
│   │   │   ├── mod.rs                     # Config module interface
│   │   │   ├── settings.rs                # Application settings
│   │   │   ├── display_config.rs          # Display-specific configuration
│   │   │   ├── connection_profiles.rs     # NEW: Connection-specific profiles
│   │   │   └── performance_config.rs      # NEW: Performance tuning config
│   │   │
│   │   └── utils/                         # Utility modules
│   │       ├── mod.rs
│   │       ├── logger.rs                  # Logging setup
│   │       ├── error.rs                   # Error types
│   │       ├── metrics.rs                 # Performance metrics
│   │       └── platform.rs                # Platform-specific utilities
│   │
│   ├── benches/                           # Performance benchmarks
│   │   ├── capture_bench.rs
│   │   ├── encoding_bench.rs
│   │   └── latency_bench.rs               # NEW: End-to-end latency
│   │
│   └── tests/                             # Integration tests
│       ├── capture_tests.rs
│       ├── encoding_tests.rs
│       ├── webrtc_tests.rs
│       └── usb_tests.rs                   # NEW: USB detection tests
│
├── go-server/                             # Go session management service
│   ├── go.mod
│   ├── go.sum
│   ├── cmd/
│   │   └── server/
│   │       └── main.go                    # Entry point
│   │
│   ├── internal/                          # Internal packages
│   │   ├── app/
│   │   │   └── app.go                     # Application setup & lifecycle
│   │   │
│   │   ├── session/                       # Session management
│   │   │   ├── manager.go                 # Session lifecycle management
│   │   │   ├── store.go                   # Session storage (in-memory/Redis)
│   │   │   ├── session.go                 # Session entity
│   │   │   ├── cleanup.go                 # Session cleanup & expiry
│   │   │   └── connection_session.go      # NEW: Connection-aware sessions
│   │   │
│   │   ├── signaling/                     # WebRTC signaling
│   │   │   ├── server.go                  # Signaling server
│   │   │   ├── handler.go                 # WebSocket signaling handlers
│   │   │   ├── messages.go                # SDP/ICE message types
│   │   │   ├── router.go                  # Route signals between Rust & clients
│   │   │   └── connection_negotiator.go   # NEW: Negotiate optimal connection
│   │   │
│   │   ├── discovery/                     # Service discovery
│   │   │   ├── mdns.go                    # mDNS/Bonjour advertising
│   │   │   ├── advertiser.go              # Service advertisement
│   │   │   ├── resolver.go                # Service resolution
│   │   │   ├── usb_detector.go            # NEW: Detect USB-tethered devices
│   │   │   ├── usb_scanner.go             # NEW: Scan for iOS USB devices
│   │   │   ├── connection_info.go         # NEW: Connection type & quality info
│   │   │   ├── network_analyzer.go        # NEW: Analyze network conditions
│   │   │   └── discovery_manager.go       # NEW: Unified discovery management
│   │   │
│   │   ├── api/                           # HTTP API
│   │   │   ├── server.go                  # HTTP server setup
│   │   │   ├── handlers/                  # HTTP handlers
│   │   │   │   ├── health.go              # Health check endpoint
│   │   │   │   ├── pairing.go             # Device pairing
│   │   │   │   ├── session.go             # Session CRUD
│   │   │   │   ├── config.go              # Configuration endpoints
│   │   │   │   ├── metrics.go             # Metrics endpoint
│   │   │   │   ├── usb.go                 # NEW: USB device endpoints
│   │   │   │   ├── connection.go          # NEW: Connection management
│   │   │   │   └── diagnostics.go         # NEW: Network diagnostics
│   │   │   ├── middleware/                # HTTP middleware
│   │   │   │   ├── auth.go                # Authentication
│   │   │   │   ├── cors.go                # CORS handling
│   │   │   │   ├── logging.go             # Request logging
│   │   │   │   └── ratelimit.go           # Rate limiting
│   │   │   └── routes.go                  # Route definitions
│   │   │
│   │   ├── auth/                          # Authentication & authorization
│   │   │   ├── authenticator.go           # Auth logic
│   │   │   ├── token.go                   # Token generation & validation
│   │   │   ├── pairing_code.go            # Pairing code generation
│   │   │   └── usb_trust.go               # NEW: USB device trust management
│   │   │
│   │   ├── streaming/                     # Streaming orchestration
│   │   │   ├── coordinator.go             # Stream coordination
│   │   │   ├── quality_adapter.go         # Adaptive quality control
│   │   │   ├── stats_collector.go         # Stream statistics
│   │   │   ├── reconnection.go            # Reconnection handling
│   │   │   ├── connection_optimizer.go    # NEW: Per-connection optimization
│   │   │   ├── bandwidth_monitor.go       # NEW: Monitor bandwidth usage
│   │   │   └── latency_tracker.go         # NEW: Track end-to-end latency
│   │   │
│   │   ├── usb/                           # NEW: USB device management
│   │   │   ├── manager.go                 # USB device lifecycle management
│   │   │   ├── detector.go                # Detect iOS devices
│   │   │   ├── device.go                  # USB device representation
│   │   │   ├── libimobiledevice.go        # libimobiledevice integration
│   │   │   ├── network_bridge.go          # USB network bridge management
│   │   │   ├── device_watcher.go          # Watch for device connect/disconnect
│   │   │   └── ios_lockdown.go            # iOS lockdown protocol
│   │   │
│   │   ├── bridge/                        # Rust ↔ Go communication
│   │   │   ├── rust_client.go             # Client to communicate with Rust
│   │   │   ├── ipc.go                     # IPC mechanism (gRPC/HTTP)
│   │   │   ├── messages.go                # Message types for bridge
│   │   │   └── connection_sync.go         # NEW: Sync connection info to Rust
│   │   │
│   │   ├── config/                        # Configuration
│   │   │   ├── config.go                  # Configuration loader
│   │   │   ├── validation.go              # Config validation
│   │   │   ├── defaults.go                # Default values
│   │   │   └── connection_profiles.go     # NEW: Connection profile configs
│   │   │
│   │   └── monitoring/                    # Monitoring & observability
│   │       ├── metrics.go                 # Prometheus metrics
│   │       ├── logger.go                  # Structured logging
│   │       ├── tracer.go                  # Distributed tracing
│   │       ├── health.go                  # Health checks
│   │       └── connection_metrics.go      # NEW: Connection-specific metrics
│   │
│   ├── pkg/                               # Public packages
│   │   ├── protocol/                      # Shared protocol definitions
│   │   │   ├── messages.pb.go             # Protobuf generated code
│   │   │   ├── signaling.go               # Signaling protocol
│   │   │   ├── control.go                 # Control message protocol
│   │   │   └── usb.go                     # NEW: USB-specific messages
│   │   │
│   │   └── types/                         # Shared types
│   │       ├── display.go                 # Display information types
│   │       ├── client.go                  # Client information types
│   │       ├── stream.go                  # Stream configuration types
│   │       ├── connection.go              # NEW: Connection types
│   │       └── usb.go                     # NEW: USB device types
│   │
│   ├── api/                               # API definitions (OpenAPI/gRPC)
│   │   ├── openapi.yaml                   # OpenAPI specification
│   │   └── proto/                         # Protocol buffer definitions
│   │       ├── session.proto
│   │       ├── signaling.proto
│   │       ├── control.proto
│   │       ├── connection.proto           # NEW: Connection management
│   │       └── usb.proto                  # NEW: USB device management
│   │
│   ├── configs/                           # Configuration files
│   │   ├── config.yaml                    # Main configuration
│   │   ├── config.dev.yaml                # Development config
│   │   ├── config.prod.yaml               # Production config
│   │   └── connection_profiles.yaml       # NEW: Connection quality profiles
│   │
│   ├── scripts/                           # Utility scripts
│   │   ├── generate_proto.sh              # Generate protobuf code
│   │   ├── run_dev.sh                     # Development runner
│   │   └── install_usb_deps.sh            # NEW: Install USB dependencies
│   │
│   └── tests/                             # Tests
│       ├── integration/                   # Integration tests
│       │   ├── session_test.go
│       │   ├── signaling_test.go
│       │   └── usb_test.go                # NEW: USB integration tests
│       └── e2e/                           # End-to-end tests
│           ├── flow_test.go
│           └── usb_flow_test.go           # NEW: USB connection flow
│
├── protocol/                              # Shared protocol definitions
│   ├── README.md                          # Protocol documentation
│   ├── signaling.md                       # Signaling protocol spec
│   ├── control.md                         # Control message spec
│   ├── connection.md                      # NEW: Connection negotiation spec
│   ├── usb.md                             # NEW: USB protocol spec
│   └── proto/                             # Shared .proto files
│       ├── common.proto
│       ├── input.proto
│       ├── stream.proto
│       ├── connection.proto               # NEW: Connection messages
│       └── usb.proto                      # NEW: USB messages
│
├── drivers/                               # NEW: Platform-specific drivers
│   ├── windows/
│   │   ├── usb_drivers/                   # Windows USB drivers
│   │   │   ├── README.md
│   │   │   └── install.bat
│   │   └── network/
│   │       └── rndis_setup.bat            # RNDIS network setup
│   └── macos/                             # Future: macOS support
│       └── usb_drivers/
│
├── tools/                                 # NEW: Development tools
│   ├── connection_tester/                 # Test connection quality
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   ├── usb_debugger/                      # Debug USB connections
│   │   ├── go.mod
│   │   └── main.go
│   └── latency_profiler/                  # Profile end-to-end latency
│       ├── Cargo.toml
│       └── src/
│           └── main.rs
│
├── scripts/                               # Build & deployment scripts
│   ├── build_all.sh                       # Build both services
│   ├── run_dev.sh                         # Run development environment
│   ├── install_deps.sh                    # Install dependencies
│   ├── setup_usb.sh                       # NEW: Setup USB support
│   ├── test_connection.sh                 # NEW: Test connection quality
│   └── docker/                            # Docker-related scripts
│       ├── build.sh
│       └── run.sh
│
├── docker/                                # Docker configuration
│   ├── Dockerfile.rust                    # Rust service container
│   ├── Dockerfile.go                      # Go service container
│   ├── docker-compose.yml                 # Multi-service orchestration
│   └── docker-compose.usb.yml             # NEW: USB passthrough support
│
├── configs/                               # Shared configuration
│   ├── logging.yaml                       # Logging configuration
│   ├── webrtc.yaml                        # WebRTC configuration
│   ├── connection_profiles.yaml           # NEW: Connection quality profiles
│   └── usb.yaml                           # NEW: USB configuration
│
├── docs/                                  # Documentation
│   ├── architecture.md                    # System architecture
│   ├── setup.md                           # Setup instructions
│   ├── api.md                             # API documentation
│   ├── protocol.md                        # Protocol specifications
│   ├── performance.md                     # Performance tuning guide
│   ├── usb_setup.md                       # NEW: USB setup guide
│   ├── connection_optimization.md         # NEW: Connection optimization
│   └── troubleshooting.md                 # NEW: Troubleshooting guide
│
├── .github/                               # GitHub configuration
│   └── workflows/
│       ├── rust-ci.yml                    # Rust CI/CD
│       ├── go-ci.yml                      # Go CI/CD
│       └── integration-tests.yml          # NEW: Full integration tests
│
├── .gitignore
├── README.md                              # Project overview
└── LICENSE
```

## Key New Components for USB Support

### **Rust Side - USB Detection & Optimization:**

1. **`usb/` module** - Complete USB device management
   - Detect iOS devices via USB (libimobiledevice/usbmuxd)
   - Manage USB network interfaces
   - Handle device pairing and trust

2. **`network/connection_detector.rs`** - Identifies connection type
   - USB tethering
   - Ethernet
   - WiFi 6/5/4
   - Auto-detects optimal settings

3. **`network/connection_optimizer.rs`** - Optimizes per connection
   - Adjusts encoding parameters
   - Tunes frame rate (120fps for USB/Ethernet)
   - Manages bitrate allocation

4. **`pipeline/adaptive_pipeline.rs`** - Dynamic quality adjustment
   - Real-time adaptation based on network conditions
   - Seamless switching between connection types

### **Go Side - USB Discovery & Management:**

1. **`usb/` package** - Full USB device lifecycle
   - Device detection and enumeration
   - libimobiledevice integration
   - iOS lockdown protocol support
   - Network bridge management

2. **`discovery/usb_detector.go`** - USB discovery alongside mDNS
   - Scans for USB-connected iOS devices
   - Reports connection quality
   - Prioritizes USB over WiFi when available

3. **`streaming/connection_optimizer.go`** - Orchestrates optimal streaming
   - Routes sessions through best available connection
   - Monitors connection quality
   - Triggers reconnection on connection type change

## Connection Priority Logic
```
1. USB Tethering (if available)    → 120fps, 15 Mbps, <5ms latency
2. Ethernet (if available)         → 120fps, 15 Mbps, <5ms latency
3. WiFi 6 (5GHz)                   → 120fps, 12 Mbps, <10ms latency
4. WiFi 5 (5GHz)                   → 90fps,  10 Mbps, <15ms latency
5. WiFi 4 or Fallback              → 60fps,  8 Mbps,  <30ms latency
```

## Updated Port Allocation

- **9001** - Rust WebRTC signaling (WebSocket)
- **9002** - Rust gRPC/HTTP API (for Go communication)
- **9003** - NEW: Rust USB device management API
- **8080** - Go HTTP API (REST endpoints)
- **8081** - Go WebSocket signaling (client-facing)
- **8082** - NEW: Go USB discovery & management API
- **3478** - STUN server
- **5349** - TURN server

## USB Connection Flow
```
1. User connects iPad via USB cable
   ↓
2. Go USB detector finds device (libimobiledevice)
   ↓
3. Go establishes trust with iOS device
   ↓
4. Windows detects USB network interface (RNDIS/NCM)
   ↓
5. Rust detects USB connection type
   ↓
6. Go signals Rust to optimize for USB (120fps, low latency)
   ↓
7. WebRTC establishes peer connection over USB network
   ↓
8. Stream begins with optimal USB settings