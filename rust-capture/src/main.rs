
use anyhow::{Ok, Result};
use tracing::{info, error};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use second_screen_capture::{
    config::Settings,
    error::ServiceError,
};

#[tokio::main]
async fn main() -> Result<()> {
    setup_logging()?;

    info!("Daisy Screen Capture starting");
    info!("Version: {}", env!("CARGO_PKG_VERSION"));

    let settings = Settings::load().map_err(|e| {
        error!("Failed to load configuration: {}", e);
        e
    });

    info!("Configuration loaded Successfully");
    info!(" - Log level: {}", settings.log_level);
    info!(" - Server port: {}", settings.server.port);

    // TODO: Initialize capture service
    info!("Initializing screen capture...");
    
    // TODO: Initialize encoder
    info!("Initializing video encoder...");
    
    // TODO: Initialize WebRTC
    info!("Initializing WebRTC...");
    
    // TODO: Start network server
    info!("Starting network server on port {}...", settings.server.port);
    
    info!("✅ Service started successfully!");
    info!("Press Ctrl+C to stop");

    tokio::signal::ctrl_c().await?;

    info!("Shutting down...");

    Ok(())   

}

fn setup_logging() -> Result<()> {
      // Create a tracing subscriber with:
    // - Pretty formatted output for humans
    // - Environment variable filtering (RUST_LOG)
    // - Timestamp on each log line

    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "second_screen_capture=info,warn".into()),
        )
        .with(tracing_subscriber::fmt::layer().pretty())
        .init();

    Ok(())
}
