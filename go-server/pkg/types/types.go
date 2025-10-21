package types

import "time"

// ConnectionType represents the type of network connection
type ConnectionType string

const (
	ConnectionTypeUSB       ConnectionType = "usb"
	ConnectionTypeEthernet  ConnectionType = "ethernet"
	ConnectionTypeWiFi6     ConnectionType = "wifi6"
	ConnectionTypeWiFi5     ConnectionType = "wifi5"
	ConnectionTypeWiFi4     ConnectionType = "wifi4"
	ConnectionTypeUnknown   ConnectionType = "unknown"
)

// SessionState represents the state of a streaming session
type SessionState string

const (
	SessionStateConnecting    SessionState = "connecting"
	SessionStateConnected     SessionState = "connected"
	SessionStateStreaming     SessionState = "streaming"
	SessionStateDisconnecting SessionState = "disconnecting"
	SessionStateDisconnected  SessionState = "disconnected"
	SessionStateError         SessionState = "error"
)

// Session represents a client session
type Session struct {
	ID             string            `json:"id"`
	ClientID       string            `json:"client_id"`
	State          SessionState      `json:"state"`
	ConnectionType ConnectionType    `json:"connection_type"`
	CreatedAt      time.Time         `json:"created_at"`
	LastActive     time.Time         `json:"last_active"`
	Quality        *StreamQuality    `json:"quality,omitempty"`
	Stats          *SessionStats     `json:"stats,omitempty"`
}

// StreamQuality represents the current streaming quality settings
type StreamQuality struct {
	Resolution   string `json:"resolution"`    // e.g., "1920x1080"
	FrameRate    int    `json:"frame_rate"`    // e.g., 60, 90, 120
	Bitrate      int    `json:"bitrate"`       // bits per second
	Codec        string `json:"codec"`         // e.g., "h264"
}

// SessionStats represents session statistics
type SessionStats struct {
	FramesSent      uint64  `json:"frames_sent"`
	BytesSent       uint64  `json:"bytes_sent"`
	PacketsLost     uint64  `json:"packets_lost"`
	AverageLatency  float64 `json:"average_latency_ms"`
	CurrentBitrate  int     `json:"current_bitrate"`
	TargetBitrate   int     `json:"target_bitrate"`
}

// ClientInfo represents information about a connected client (iPad)
type ClientInfo struct {
	ID            string    `json:"id"`
	Name          string    `json:"name"`
	DeviceModel   string    `json:"device_model"`    // e.g., "iPad Pro 12.9"
	OSVersion     string    `json:"os_version"`      // e.g., "iOS 17.2"
	Resolution    string    `json:"resolution"`      // e.g., "2732x2048"
	RefreshRate   int       `json:"refresh_rate"`    // e.g., 120
	Connected     bool      `json:"connected"`
	LastSeen      time.Time `json:"last_seen"`
}

// DisplayInfo represents information about a Windows display
type DisplayInfo struct {
	Index       int    `json:"index"`
	Name        string `json:"name"`
	Resolution  string `json:"resolution"`
	RefreshRate int    `json:"refresh_rate"`
	IsPrimary   bool   `json:"is_primary"`
	X           int    `json:"x"`
	Y           int    `json:"y"`
	Width       int    `json:"width"`
	Height      int    `json:"height"`
}

// ConnectionInfo represents network connection information
type ConnectionInfo struct {
	Type           ConnectionType `json:"type"`
	InterfaceName  string         `json:"interface_name"`
	IPAddress      string         `json:"ip_address"`
	Latency        float64        `json:"latency_ms"`
	Bandwidth      int            `json:"bandwidth_bps"`
	PacketLoss     float64        `json:"packet_loss_percent"`
}

// HealthStatus represents the health status of the service
type HealthStatus struct {
	Healthy      bool              `json:"healthy"`
	Version      string            `json:"version"`
	Uptime       time.Duration     `json:"uptime"`
	ActiveSessions int             `json:"active_sessions"`
	RustService  ServiceHealth     `json:"rust_service"`
	Components   map[string]bool   `json:"components"`
}

// ServiceHealth represents the health of a service component
type ServiceHealth struct {
	Reachable    bool          `json:"reachable"`
	ResponseTime time.Duration `json:"response_time_ms"`
	LastCheck    time.Time     `json:"last_check"`
}

// PairingRequest represents a device pairing request
type PairingRequest struct {
	Code       string `json:"code"`
	DeviceID   string `json:"device_id"`
	DeviceName string `json:"device_name"`
}

// PairingResponse represents the response to a pairing request
type PairingResponse struct {
	Success bool   `json:"success"`
	Token   string `json:"token,omitempty"`
	Message string `json:"message,omitempty"`
}