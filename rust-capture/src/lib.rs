// Library root - exports all public modules
// This is like a package.json or go.mod - it defines what's available to use

// Public modules - these are accessible from outside this library
pub mod config;
pub mod error;
pub mod utils;

// These modules will be added as we build them
// pub mod capture;
// pub mod encoder;
// pub mod webrtc;
// pub mod input;
// pub mod network;
// pub mod pipeline;

// Re-export commonly used types for convenience
// This allows users to write: use second_screen_capture::ServiceError
// Instead of: use second_screen_capture::error::ServiceError
pub use error::ServiceError;
pub use config::Settings;