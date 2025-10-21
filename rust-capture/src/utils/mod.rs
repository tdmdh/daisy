
pub fn timestamp_ms() -> u64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_millis() as u64
}

pub fn format_bytes(bytes: u64) -> String {
    const KB: u64 = 1024;
    const MB: u64 = KB * 1024;
    const GB: u64 = MB * 1024;

    if bytes >= GB {
        format!("{:.2} GB", bytes as f64 / GB as f64)
    } else if bytes >= MB {
        format!("{:.2} MB", bytes as f64 / MB as f64)
    } else if bytes >= KB {
        format!("{:.2} KB", bytes as f64 / KB as f64)
    } else {
        format!("{} B", bytes)
    }
}

pub fn format_bitrate(bps: u32) -> String {
    const KBPS: u32 = 1000;
    const MBPS: u32 = KBPS * 1000;

    if bps >= MBPS {
        format!("{:.2} Mbps", bps as f64 / MBPS as f64)
    } else if bps >= KBPS {
        format!("{:.2} Kbps", bps as f64 / KBPS as f64)
    } else {
        format!("{} bps", bps)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_format_bytes() {
        assert_eq!(format_bytes(500), "500 B");
        assert_eq!(format_bytes(1024), "1.00 KB");
        assert_eq!(format_bytes(1024 * 1024), "1.00 MB");
        assert_eq!(format_bytes(1024 * 1024 * 1024), "1.00 GB");
    }
    
    #[test]
    fn test_format_bitrate() {
        assert_eq!(format_bitrate(500), "500 bps");
        assert_eq!(format_bitrate(5_000), "5.00 Kbps");
        assert_eq!(format_bitrate(10_000_000), "10.00 Mbps");
    }
    
    #[test]
    fn test_timestamp_ms() {
        let t1 = timestamp_ms();
        std::thread::sleep(std::time::Duration::from_millis(10));
        let t2 = timestamp_ms();
        assert!(t2 > t1);
        assert!(t2 - t1 >= 10);
    }
}

