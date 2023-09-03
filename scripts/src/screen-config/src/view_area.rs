use anyhow::{Context, Result};
use thiserror::Error;

use crate::monitor::Monitor;

#[derive(Error, Debug)]
enum AddMonitorError {
    #[error("Cannot use Monitor Output {0:?} more than one")]
    SameOutput(String),

    #[error("Cannot set multiple primary Monitors")]
    AnotherPrimary,
}

pub struct ViewArea {
    monitors: Vec<Monitor>,
}

impl ViewArea {
    pub fn new() -> ViewArea {
        ViewArea { monitors: vec![] }
    }

    pub fn add_monitor(mut self, new_monitor: Monitor) -> Result<ViewArea> {
        self.monitors
            .iter()
            .map(|monitor| match (monitor, &new_monitor) {
                (m1, m2) if m1.output == m2.output => {
                    Err(AddMonitorError::SameOutput(m1.output.clone()))
                }
                (m1, m2) if m1.is_primary && m2.is_primary => Err(AddMonitorError::AnotherPrimary),
                _ => Ok(()),
            })
            .collect::<Result<(), AddMonitorError>>()
            .context("Cannot add monitor with invalid properties")?;

        self.monitors.push(new_monitor);
        Ok(self)
    }

    pub fn as_args(&self) -> Vec<String> {
        todo!()
    }
}
