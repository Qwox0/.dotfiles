#![allow(unused)]
pub mod execute;
pub mod monitor;
pub mod view_area;

use anyhow::{Context, Result};
use std::process::Command;
use view_area::ViewArea;

use crate::{
    execute::Execute,
    monitor::{Monitor, Rotation},
};

fn main() {
    let rotated_monitor = Monitor::new("HDMI-A-1", (1920, 1080))
        //.scale(1.5)
        .scale(1.75)
        .set_rotation(Rotation::Right);
    let (width, height) = rotated_monitor.get_view_size();

    let main_monitor = Monitor::new("HDMI-A-0", (3840, 2160)).set_primary();
    //let y = height - main_monitor.size.1 - 150;
    let y = height - main_monitor.get_view_size().1 - 350;
    let main_monitor = main_monitor.move_to((width, y));

    Command::new("xrandr")
        .args(main_monitor.as_args().split_whitespace())
        .args(rotated_monitor.as_args().split_whitespace())
        .execute()
        .unwrap();

    println!("debug screens:");
    println!("{:?}", main_monitor);
    println!("{:?}", rotated_monitor);

    println!("\nnew Xrandr settings:");
    println!("{}", main_monitor);
    println!("{}", rotated_monitor);

    println!("\nnew Xrandr settings via Xrandr:");
    Command::new("xrandr")
        .arg("--listmonitors")
        .execute()
        .unwrap();
}
